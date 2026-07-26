import 'dart:async';

import 'package:dio/dio.dart' hide ResponseDecoder;

import '../core/auth_refresh_strategy.dart';
import '../core/cache_policy.dart';
import '../core/cache_store.dart';
import '../core/download_request.dart';
import '../core/download_result.dart';
import '../core/network_client.dart';
import '../core/network_config.dart';
import '../core/network_exception.dart';
import '../core/network_interceptor.dart';
import '../core/network_method.dart';
import '../core/network_request.dart';
import '../core/network_response.dart';
import '../core/response_decoder.dart';
import '../core/retry_policy.dart';
import './dio_download_delegate.dart';
import './network_log_interceptor.dart';

const String _operationExtraKey = 'network.operation';
const String _downloadOperation = 'download';

/// Dio-backed implementation of [NetworkClient].
class DioNetworkClient implements NetworkClient {
  /// Creates a Dio-based network client.
  DioNetworkClient({
    required NetworkConfig config,
    Dio? dio,
    DioDownloadDelegate? downloadDelegate,
  }) : _config = config,
       _downloadDelegate = downloadDelegate ?? createDioDownloadDelegate(),
       _dio =
           dio ??
           Dio(
             BaseOptions(
               baseUrl: config.baseUrl,
               connectTimeout: config.defaultTimeout,
               receiveTimeout: config.defaultTimeout,
               sendTimeout: config.defaultTimeout,
               headers: config.defaultHeaders,
               validateStatus: (_) => true,
             ),
           ) {
    if (_config.loggerConfig.isEnabled) {
      _dio.interceptors.add(NetworkLogInterceptor(_config.loggerConfig));
    }
  }

  final NetworkConfig _config;
  final DioDownloadDelegate _downloadDelegate;
  final Dio _dio;

  /// Underlying Dio instance for advanced transport customization.
  Dio get dio => _dio;

  @override
  Future<NetworkResponse<T>> send<T>(
    NetworkRequest request, {
    required ResponseDecoder<T> decoder,
  }) async {
    final NetworkRequest preparedRequest = await _applyRequestInterceptors(
      request,
    );

    final RetryPolicy retryPolicy =
        preparedRequest.retryPolicy ?? _config.defaultRetryPolicy;
    final CachePolicy cachePolicy =
        preparedRequest.cachePolicy ?? _config.defaultCachePolicy;

    if (preparedRequest.method == RequestMethod.get && cachePolicy.isEnabled) {
      final NetworkResponse<T>? cachedResponse = await _readFromCache<T>(
        preparedRequest,
        decoder,
        cachePolicy,
      );
      if (cachedResponse != null) {
        final NetworkResponse<dynamic> intercepted =
            await _applyResponseInterceptors<dynamic>(cachedResponse);
        return intercepted as NetworkResponse<T>;
      }
    }

    final bool hasConnection = await _hasConnection();
    if (!hasConnection) {
      final NetworkException exception = NetworkException.connection(
        message: 'No internet connection',
        request: preparedRequest,
      );
      await _notifyErrorInterceptors(exception);
      throw exception;
    }

    int attempt = 0;
    bool hasRetriedAuth = false;

    while (attempt < retryPolicy.maxAttempts) {
      attempt += 1;
      try {
        final Response<dynamic> response = await _dispatch(preparedRequest);
        final int statusCode = response.statusCode ?? 0;

        if (statusCode == 401 &&
            preparedRequest.requiresAuth &&
            !hasRetriedAuth &&
            _config.authRefreshStrategy != null) {
          hasRetriedAuth = true;
          final bool refreshed = await _refreshAuth(
            _config.authRefreshStrategy!,
          );
          if (refreshed) {
            continue;
          }
        }

        if (!_isSuccessStatusCode(statusCode)) {
          final NetworkException exception = _mapResponseException(
            request: preparedRequest,
            response: response,
          );
          if (_shouldRetry(retryPolicy, preparedRequest, attempt, exception)) {
            await Future<void>.delayed(retryPolicy.delayForAttempt(attempt));
            continue;
          }
          throw exception;
        }

        final NetworkResponse<T> networkResponse = await _decodeResponse<T>(
          request: preparedRequest,
          response: response,
          decoder: decoder,
        );

        if (preparedRequest.method == RequestMethod.get &&
            cachePolicy.isEnabled) {
          await _writeToCache(preparedRequest, networkResponse, cachePolicy);
        }

        final NetworkResponse<dynamic> intercepted =
            await _applyResponseInterceptors<dynamic>(networkResponse);
        return intercepted as NetworkResponse<T>;
      } on DioException catch (error, stackTrace) {
        final NetworkException exception = _mapDioException(
          error: error,
          request: preparedRequest,
          stackTrace: stackTrace,
        );
        if (_shouldRetry(retryPolicy, preparedRequest, attempt, exception)) {
          await Future<void>.delayed(retryPolicy.delayForAttempt(attempt));
          continue;
        }
        await _notifyErrorInterceptors(exception);
        throw exception;
      } on NetworkException catch (exception) {
        if (_shouldRetry(retryPolicy, preparedRequest, attempt, exception)) {
          await Future<void>.delayed(retryPolicy.delayForAttempt(attempt));
          continue;
        }
        await _notifyErrorInterceptors(exception);
        rethrow;
      }
    }

    final NetworkException exception = NetworkException.unknown(
      message: 'Request failed after ${retryPolicy.maxAttempts} attempts',
      request: preparedRequest,
    );
    await _notifyErrorInterceptors(exception);
    throw exception;
  }

  @override
  Future<DownloadResult> download(DownloadRequest request) async {
    final NetworkRequest preparedRequest = await _applyRequestInterceptors(
      _toNetworkRequest(request),
    );
    final DownloadRequest resolvedRequest = _toResolvedDownloadRequest(
      original: request,
      preparedRequest: preparedRequest,
    );
    final RetryPolicy retryPolicy =
        preparedRequest.retryPolicy ?? _config.defaultRetryPolicy;
    final PreparedDownload preparedDownload;

    try {
      preparedDownload = await _downloadDelegate.prepare(
        request: resolvedRequest,
        networkRequest: preparedRequest,
      );
    } on NetworkException catch (exception) {
      await _notifyErrorInterceptors(exception);
      rethrow;
    }

    final bool hasConnection = await _hasConnection();
    if (!hasConnection) {
      final NetworkException exception = NetworkException.connection(
        message: 'No internet connection',
        request: preparedRequest,
      );
      await _notifyErrorInterceptors(exception);
      throw exception;
    }

    int attempt = 0;
    bool hasRetriedAuth = false;

    while (attempt < retryPolicy.maxAttempts) {
      attempt += 1;
      try {
        await _downloadDelegate.cleanup(
          preparedDownload: preparedDownload,
          networkRequest: preparedRequest,
        );

        final Response<dynamic> response = await _dispatchDownload(
          preparedRequest,
          preparedDownload,
        );
        final int statusCode = response.statusCode ?? 0;

        if (statusCode == 401 &&
            preparedRequest.requiresAuth &&
            !hasRetriedAuth &&
            _config.authRefreshStrategy != null) {
          hasRetriedAuth = true;
          await _downloadDelegate.cleanup(
            preparedDownload: preparedDownload,
            networkRequest: preparedRequest,
          );
          final bool refreshed = await _refreshAuth(
            _config.authRefreshStrategy!,
          );
          if (refreshed) {
            continue;
          }
        }

        if (!_isSuccessStatusCode(statusCode)) {
          await _downloadDelegate.cleanup(
            preparedDownload: preparedDownload,
            networkRequest: preparedRequest,
          );
          final NetworkException exception = _mapResponseException(
            request: preparedRequest,
            response: response,
          );
          if (_shouldRetry(retryPolicy, preparedRequest, attempt, exception)) {
            await Future<void>.delayed(retryPolicy.delayForAttempt(attempt));
            continue;
          }
          throw exception;
        }

        final DownloadArtifact artifact = await _downloadDelegate.finalize(
          request: resolvedRequest,
          networkRequest: preparedRequest,
          preparedDownload: preparedDownload,
          response: response,
        );
        return _toDownloadResult(
          request: resolvedRequest,
          response: response,
          artifact: artifact,
        );
      } on DioException catch (error, stackTrace) {
        await _downloadDelegate.cleanup(
          preparedDownload: preparedDownload,
          networkRequest: preparedRequest,
          bestEffort: true,
        );
        final NetworkException exception = _mapDioException(
          error: error,
          request: preparedRequest,
          stackTrace: stackTrace,
        );
        if (_shouldRetry(retryPolicy, preparedRequest, attempt, exception)) {
          await Future<void>.delayed(retryPolicy.delayForAttempt(attempt));
          continue;
        }
        await _notifyErrorInterceptors(exception);
        throw exception;
      } on NetworkException catch (exception) {
        await _downloadDelegate.cleanup(
          preparedDownload: preparedDownload,
          networkRequest: preparedRequest,
          bestEffort: true,
        );
        if (_shouldRetry(retryPolicy, preparedRequest, attempt, exception)) {
          await Future<void>.delayed(retryPolicy.delayForAttempt(attempt));
          continue;
        }
        await _notifyErrorInterceptors(exception);
        rethrow;
      }
    }

    final NetworkException exception = NetworkException.unknown(
      message: 'Download failed after ${retryPolicy.maxAttempts} attempts',
      request: preparedRequest,
    );
    await _notifyErrorInterceptors(exception);
    throw exception;
  }

  Future<Response<dynamic>> _dispatch(NetworkRequest request) {
    final CancelToken? cancelToken = _resolveCancelToken(request);
    final Map<String, String> headers = <String, String>{
      ..._config.defaultHeaders,
      ...request.headers,
    };

    return _attachAuthHeaders(headers: headers, request: request).then((
      Map<String, String> resolvedHeaders,
    ) {
      final Duration timeout = request.timeout ?? _config.defaultTimeout;
      return _dio.request<dynamic>(
        request.path,
        data: request.body,
        queryParameters: request.query,
        cancelToken: cancelToken,
        onSendProgress: request.onSendProgress,
        onReceiveProgress: request.onReceiveProgress,
        options: Options(
          method: request.method.value,
          headers: resolvedHeaders,
          contentType: request.contentType,
          sendTimeout: timeout,
          receiveTimeout: timeout,
        ),
      );
    });
  }

  Future<Response<dynamic>> _dispatchDownload(
    NetworkRequest request,
    PreparedDownload preparedDownload,
  ) {
    final CancelToken? cancelToken = _resolveCancelToken(request);
    final Map<String, String> headers = <String, String>{
      ..._config.defaultHeaders,
      ...request.headers,
    };

    return _attachAuthHeaders(headers: headers, request: request).then((
      Map<String, String> resolvedHeaders,
    ) {
      final Duration timeout = request.timeout ?? _config.defaultTimeout;
      return _downloadDelegate.dispatch(
        dio: _dio,
        request: request,
        preparedDownload: preparedDownload,
        headers: resolvedHeaders,
        cancelToken: cancelToken,
        timeout: timeout,
      );
    });
  }

  NetworkRequest _toNetworkRequest(DownloadRequest request) {
    return NetworkRequest(
      path: request.path,
      query: request.query,
      headers: request.headers,
      timeout: request.timeout,
      requiresAuth: request.requiresAuth,
      retryPolicy: request.retryPolicy,
      cancelToken: request.cancelToken,
      extra: <String, Object?>{
        ...request.extra,
        _operationExtraKey: _downloadOperation,
      },
      onReceiveProgress: request.onReceiveProgress,
    );
  }

  DownloadRequest _toResolvedDownloadRequest({
    required DownloadRequest original,
    required NetworkRequest preparedRequest,
  }) {
    return original.copyWith(
      path: preparedRequest.path,
      query: preparedRequest.query,
      headers: preparedRequest.headers,
      timeout: preparedRequest.timeout,
      requiresAuth: preparedRequest.requiresAuth,
      retryPolicy: preparedRequest.retryPolicy,
      cancelToken: preparedRequest.cancelToken,
      extra: _removeInternalExtra(preparedRequest.extra),
      onReceiveProgress: preparedRequest.onReceiveProgress,
    );
  }

  DownloadResult _toDownloadResult({
    required DownloadRequest request,
    required Response<dynamic> response,
    required DownloadArtifact artifact,
  }) {
    final Map<String, List<String>> headers = _normalizeHeaders(
      response.headers.map,
    );
    return DownloadResult(
      file: artifact.file,
      filePath: artifact.filePath,
      statusCode: response.statusCode ?? 0,
      headers: headers,
      bytesWritten: artifact.bytesWritten,
      contentLength: _contentLengthFromHeaders(headers),
      mimeType: _mimeTypeFromHeaders(headers),
      request: request,
    );
  }

  int? _contentLengthFromHeaders(Map<String, List<String>> headers) {
    final String? rawValue = headers[Headers.contentLengthHeader]?.first;
    final int? parsedValue = rawValue == null ? null : int.tryParse(rawValue);
    if (parsedValue == null || parsedValue < 0) {
      return null;
    }
    return parsedValue;
  }

  String? _mimeTypeFromHeaders(Map<String, List<String>> headers) {
    final String? contentType = headers[Headers.contentTypeHeader]?.first;
    if (contentType == null || contentType.trim().isEmpty) {
      return null;
    }

    return contentType.split(';').first.trim();
  }

  Future<Map<String, String>> _attachAuthHeaders({
    required Map<String, String> headers,
    required NetworkRequest request,
  }) async {
    if (!request.requiresAuth || _config.tokenProvider == null) {
      return headers;
    }

    if (_hasAuthorizationHeader(headers)) {
      return headers;
    }

    final String? token = await _config.tokenProvider!.getToken();
    if (token == null || token.isEmpty) {
      return headers;
    }

    return <String, String>{...headers, 'Authorization': 'Bearer $token'};
  }

  Future<NetworkResponse<T>> _decodeResponse<T>({
    required NetworkRequest request,
    required Response<dynamic> response,
    required ResponseDecoder<T> decoder,
    bool isFromCache = false,
    Object? rawData,
    Map<String, List<String>>? headers,
    int? statusCode,
  }) async {
    final Object? payload = rawData ?? response.data;
    final Map<String, List<String>> normalizedHeaders =
        headers ?? _normalizeHeaders(response.headers.map);
    final int resolvedStatusCode = statusCode ?? response.statusCode ?? 0;

    try {
      final T data = await decoder(payload);
      return NetworkResponse<T>(
        data: data,
        statusCode: resolvedStatusCode,
        headers: normalizedHeaders,
        rawData: payload,
        request: request,
        isFromCache: isFromCache,
      );
    } catch (error, stackTrace) {
      throw NetworkException.parsing(
        message: 'Failed to decode response: $error',
        request: request,
        responseBody: payload,
        headers: normalizedHeaders,
        cause: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<NetworkRequest> _applyRequestInterceptors(
    NetworkRequest request,
  ) async {
    NetworkRequest currentRequest = request;
    for (final NetworkInterceptor interceptor in _config.interceptors) {
      currentRequest = await interceptor.onRequest(currentRequest);
    }
    return currentRequest;
  }

  Future<NetworkResponse<T>> _applyResponseInterceptors<T>(
    NetworkResponse<T> response,
  ) async {
    NetworkResponse<dynamic> currentResponse = response;
    for (final NetworkInterceptor interceptor in _config.interceptors) {
      currentResponse = await interceptor.onResponse(currentResponse);
    }
    return currentResponse as NetworkResponse<T>;
  }

  Future<void> _notifyErrorInterceptors(NetworkException exception) async {
    for (final NetworkInterceptor interceptor in _config.interceptors) {
      await interceptor.onError(exception);
    }
  }

  Future<NetworkResponse<T>?> _readFromCache<T>(
    NetworkRequest request,
    ResponseDecoder<T> decoder,
    CachePolicy cachePolicy,
  ) async {
    final CacheStore? cacheStore = _config.cacheStore;
    if (cacheStore == null) {
      return null;
    }

    final String cacheKey = _cacheKeyFor(request);
    final NetworkCacheEntry? entry = await cacheStore.read(cacheKey);
    if (entry == null) {
      return null;
    }

    if (entry.isExpired && !cachePolicy.allowStale) {
      await cacheStore.remove(cacheKey);
      return null;
    }

    try {
      return _decodeResponse<T>(
        request: request,
        response: Response<dynamic>(
          requestOptions: RequestOptions(path: request.path),
          data: entry.rawData,
          statusCode: entry.statusCode,
        ),
        decoder: decoder,
        isFromCache: true,
        rawData: entry.rawData,
        headers: entry.headers,
        statusCode: entry.statusCode,
      );
    } on ParsingNetworkException {
      await cacheStore.remove(cacheKey);
      return null;
    }
  }

  Future<void> _writeToCache<T>(
    NetworkRequest request,
    NetworkResponse<T> response,
    CachePolicy cachePolicy,
  ) async {
    final CacheStore? cacheStore = _config.cacheStore;
    if (cacheStore == null) {
      return;
    }

    final String cacheKey = _cacheKeyFor(request);
    await cacheStore.write(
      cacheKey,
      NetworkCacheEntry(
        rawData: response.rawData,
        statusCode: response.statusCode,
        headers: response.headers,
        cachedAt: DateTime.now(),
        ttl: cachePolicy.ttl,
      ),
    );
  }

  Future<bool> _hasConnection() async {
    final probe = _config.connectivityProbe;
    if (probe == null) {
      return true;
    }
    return probe.hasConnection();
  }

  Future<bool> _refreshAuth(AuthRefreshStrategy strategy) {
    return strategy.refreshToken();
  }

  CancelToken? _resolveCancelToken(NetworkRequest request) {
    final Object? rawValue = request.cancelToken?.rawValue;
    if (rawValue is CancelToken) {
      return rawValue;
    }
    return null;
  }

  bool _hasAuthorizationHeader(Map<String, String> headers) {
    return headers.keys.any(
      (String key) => key.toLowerCase() == 'authorization',
    );
  }

  bool _isSuccessStatusCode(int statusCode) {
    return statusCode >= 200 && statusCode < 300;
  }

  bool _shouldRetry(
    RetryPolicy policy,
    NetworkRequest request,
    int attempt,
    NetworkException exception,
  ) {
    if (attempt >= policy.maxAttempts) {
      return false;
    }

    if (!policy.allowsMethod(request.method)) {
      return false;
    }

    return policy.allowsException(exception);
  }

  NetworkException _mapDioException({
    required DioException error,
    required NetworkRequest request,
    required StackTrace stackTrace,
  }) {
    final NetworkException? nestedException = _mapNestedException(
      error: error,
      request: request,
      stackTrace: stackTrace,
    );
    if (nestedException != null) {
      return nestedException;
    }

    switch (error.type) {
      case DioExceptionType.cancel:
        return NetworkException.cancelled(
          message: error.message ?? 'Request cancelled',
          request: request,
          cause: error,
          stackTrace: stackTrace,
        );
      case DioExceptionType.transformTimeout:
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException.timeout(
          message: error.message ?? 'Request timed out',
          request: request,
          cause: error,
          stackTrace: stackTrace,
        );
      case DioExceptionType.connectionError:
        return NetworkException.connection(
          message: error.message ?? 'Unable to reach the network',
          request: request,
          cause: error,
          stackTrace: stackTrace,
        );
      case DioExceptionType.badResponse:
        final Response<dynamic>? response = error.response;
        if (response == null) {
          return NetworkException.unknown(
            message: error.message ?? 'Unexpected response error',
            request: request,
            cause: error,
            stackTrace: stackTrace,
          );
        }
        return _mapResponseException(request: request, response: response);
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return NetworkException.unknown(
          message: error.message ?? 'Unexpected network error',
          request: request,
          cause: error,
          stackTrace: stackTrace,
        );
    }
  }

  NetworkException? _mapNestedException({
    required DioException error,
    required NetworkRequest request,
    required StackTrace stackTrace,
  }) {
    final Object? nestedError = error.error;
    if (nestedError is DioException) {
      return _mapDioException(
        error: nestedError,
        request: request,
        stackTrace: stackTrace,
      );
    }

    if (nestedError is TimeoutException) {
      return NetworkException.timeout(
        message: nestedError.message ?? error.message ?? 'Request timed out',
        request: request,
        cause: error,
        stackTrace: stackTrace,
      );
    }

    if (_downloadDelegate.isStorageError(nestedError)) {
      return NetworkException.storage(
        message:
            _downloadDelegate.storageErrorMessage(nestedError) ??
            error.message ??
            'Failed to access local storage',
        request: request,
        cause: error,
        stackTrace: stackTrace,
      );
    }

    return null;
  }

  NetworkException _mapResponseException({
    required NetworkRequest request,
    required Response<dynamic> response,
  }) {
    final int statusCode = response.statusCode ?? 0;
    final Map<String, List<String>> headers = _normalizeHeaders(
      response.headers.map,
    );
    final String message = _extractMessage(response.data, statusCode);

    if (statusCode == 401) {
      return NetworkException.unauthorized(
        message: message,
        request: request,
        responseBody: response.data,
        headers: headers,
      );
    }

    if (statusCode == 403) {
      return NetworkException.forbidden(
        message: message,
        request: request,
        responseBody: response.data,
        headers: headers,
      );
    }

    if (statusCode == 404) {
      return NetworkException.notFound(
        message: message,
        request: request,
        responseBody: response.data,
        headers: headers,
      );
    }

    if (statusCode == 429) {
      return NetworkException.rateLimited(
        message: message,
        request: request,
        responseBody: response.data,
        headers: headers,
      );
    }

    if (statusCode == 400 || statusCode == 422) {
      return NetworkException.validation(
        message: message,
        request: request,
        statusCode: statusCode,
        responseBody: response.data,
        headers: headers,
      );
    }

    if (statusCode >= 500) {
      return NetworkException.server(
        message: message,
        request: request,
        statusCode: statusCode,
        responseBody: response.data,
        headers: headers,
      );
    }

    return NetworkException.unknown(
      message: message,
      request: request,
      statusCode: statusCode,
      responseBody: response.data,
      headers: headers,
    );
  }

  Map<String, List<String>> _normalizeHeaders(
    Map<String, List<String>> headers,
  ) {
    return Map<String, List<String>>.unmodifiable(
      headers.map(
        (String key, List<String> value) => MapEntry<String, List<String>>(
          key,
          List<String>.unmodifiable(value),
        ),
      ),
    );
  }

  String _extractMessage(Object? payload, int statusCode) {
    if (payload is Map<Object?, Object?>) {
      final Object? message =
          payload['message'] ??
          payload['error'] ??
          payload['detail'] ??
          payload['title'];
      if (message is String && message.trim().isNotEmpty) {
        return message;
      }
    }

    if (payload is String && payload.trim().isNotEmpty) {
      return payload;
    }

    return 'Request failed with status $statusCode';
  }

  Map<String, Object?> _removeInternalExtra(Map<String, Object?> extra) {
    final Map<String, Object?> sanitized = <String, Object?>{...extra}
      ..remove(_operationExtraKey);
    return Map<String, Object?>.unmodifiable(sanitized);
  }

  String _cacheKeyFor(NetworkRequest request) {
    final Uri uri = _composeUri(request);
    return '${request.method.value}:$uri';
  }

  Uri _composeUri(NetworkRequest request) {
    final Uri rawUri = Uri.parse(request.path);
    if (rawUri.isAbsolute) {
      return rawUri.replace(
        queryParameters: _normalizedQueryParameters(request.query),
      );
    }

    final String trimmedBaseUrl = _config.baseUrl.replaceFirst(
      RegExp(r'/$'),
      '',
    );
    final String normalizedPath = request.path.startsWith('/')
        ? request.path
        : '/${request.path}';
    final Uri baseUri = trimmedBaseUrl.isEmpty
        ? Uri(path: normalizedPath)
        : Uri.parse('$trimmedBaseUrl$normalizedPath');
    return baseUri.replace(
      queryParameters: _normalizedQueryParameters(request.query),
    );
  }

  Map<String, String> _normalizedQueryParameters(Map<String, dynamic> query) {
    final List<MapEntry<String, dynamic>> entries =
        query.entries.toList(growable: false)..sort((
          MapEntry<String, dynamic> left,
          MapEntry<String, dynamic> right,
        ) {
          return left.key.compareTo(right.key);
        });
    final Map<String, String> normalized = <String, String>{};
    for (final MapEntry<String, dynamic> entry in entries) {
      final Object? value = entry.value;
      if (value == null) {
        continue;
      }
      normalized[entry.key] = value.toString();
    }
    return normalized;
  }
}
