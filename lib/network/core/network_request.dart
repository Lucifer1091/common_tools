import 'cache_policy.dart';
import 'network_cancel_token.dart';
import 'network_method.dart';
import 'retry_policy.dart';

const Object _bodyNotOverridden = Object();

/// Signature for transfer progress notifications.
typedef ProgressCallback = void Function(int count, int total);

/// Immutable description of a transport request.
class NetworkRequest {
  /// Creates a request description.
  const NetworkRequest({
    required this.path,
    this.method = RequestMethod.get,
    this.query = const <String, dynamic>{},
    this.headers = const <String, String>{},
    this.body,
    this.contentType,
    this.timeout,
    this.requiresAuth = false,
    this.retryPolicy,
    this.cachePolicy,
    this.cancelToken,
    this.extra = const <String, Object?>{},
    this.onSendProgress,
    this.onReceiveProgress,
  });

  /// Relative path or absolute URL.
  final String path;

  /// HTTP method.
  final RequestMethod method;

  /// Query parameters appended to the request URL.
  final Map<String, dynamic> query;

  /// Request-specific headers.
  final Map<String, String> headers;

  /// Request payload.
  final Object? body;

  /// Explicit request content type override.
  final String? contentType;

  /// Timeout override for this request.
  final Duration? timeout;

  /// Whether auth headers should be attached automatically.
  final bool requiresAuth;

  /// Retry policy override for this request.
  final RetryPolicy? retryPolicy;

  /// Cache policy override for this request.
  final CachePolicy? cachePolicy;

  /// Optional transport-specific cancellation handle.
  final NetworkCancelToken? cancelToken;

  /// Extra metadata carried alongside the request.
  final Map<String, Object?> extra;

  /// Callback invoked as bytes are uploaded.
  final ProgressCallback? onSendProgress;

  /// Callback invoked as bytes are downloaded.
  final ProgressCallback? onReceiveProgress;

  /// Creates a new request with overridden values.
  NetworkRequest copyWith({
    String? path,
    RequestMethod? method,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    Object? body = _bodyNotOverridden,
    String? contentType,
    Duration? timeout,
    bool? requiresAuth,
    RetryPolicy? retryPolicy,
    CachePolicy? cachePolicy,
    NetworkCancelToken? cancelToken,
    Map<String, Object?>? extra,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) {
    return NetworkRequest(
      path: path ?? this.path,
      method: method ?? this.method,
      query: query ?? this.query,
      headers: headers ?? this.headers,
      body: identical(body, _bodyNotOverridden) ? this.body : body,
      contentType: contentType ?? this.contentType,
      timeout: timeout ?? this.timeout,
      requiresAuth: requiresAuth ?? this.requiresAuth,
      retryPolicy: retryPolicy ?? this.retryPolicy,
      cachePolicy: cachePolicy ?? this.cachePolicy,
      cancelToken: cancelToken ?? this.cancelToken,
      extra: extra ?? this.extra,
      onSendProgress: onSendProgress ?? this.onSendProgress,
      onReceiveProgress: onReceiveProgress ?? this.onReceiveProgress,
    );
  }
}
