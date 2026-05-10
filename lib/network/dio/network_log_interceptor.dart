import 'dart:convert';

import 'package:dio/dio.dart';

import '../core/log_level.dart';
import '../core/network_logger_config.dart';

/// Dio interceptor that prints redacted request and response logs.
class NetworkLogInterceptor extends Interceptor {
  /// Creates a transport logger.
  NetworkLogInterceptor(this.config);

  static const String _startedAtKey = 'network_logger_started_at';

  /// Logger settings.
  final NetworkLoggerConfig config;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (!config.isEnabled) {
      super.onError(err, handler);
      return;
    }

    final Duration? elapsed = _elapsed(err.requestOptions);
    config.sink(
      '[dio] ERROR ${err.requestOptions.method} '
      '${err.requestOptions.uri} (${_formatDuration(elapsed)}) '
      '${err.type}: ${err.message}',
    );

    if (config.level == LogLevel.headers) {
      _logHeaders(err.requestOptions.headers, prefix: '[dio] Request headers');
    }

    if (config.level == LogLevel.body) {
      _logBody(err.requestOptions.data, prefix: '[dio] Request body');
      if (_isDownloadRequest(err.requestOptions)) {
        config.sink('[dio] Error body: <download body omitted>');
      } else {
        _logBody(err.response?.data, prefix: '[dio] Error body');
      }
    }

    super.onError(err, handler);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (!config.isEnabled) {
      super.onRequest(options, handler);
      return;
    }

    options.extra[_startedAtKey] = DateTime.now();
    config.sink('[dio] REQUEST ${options.method} ${options.uri}');

    if (config.level == LogLevel.headers || config.level == LogLevel.body) {
      _logHeaders(options.headers, prefix: '[dio] Request headers');
    }

    if (config.level == LogLevel.body) {
      _logBody(options.data, prefix: '[dio] Request body');
    }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    if (!config.isEnabled) {
      super.onResponse(response, handler);
      return;
    }

    final Duration? elapsed = _elapsed(response.requestOptions);
    config.sink(
      '[dio] RESPONSE ${response.requestOptions.method} ${response.requestOptions.uri} '
      '${response.statusCode} (${_formatDuration(elapsed)})',
    );

    if (config.level == LogLevel.headers || config.level == LogLevel.body) {
      final Map<String, Object?> headers = <String, Object?>{};
      response.headers.map.forEach((String key, List<String> value) {
        headers[key] = value.join(', ');
      });
      _logHeaders(headers, prefix: '[dio] Response headers');
    }

    if (config.level == LogLevel.body) {
      if (_isDownloadRequest(response.requestOptions) ||
          response.data is ResponseBody) {
        config.sink('[dio] Response body: <download body omitted>');
      } else {
        _logBody(response.data, prefix: '[dio] Response body');
      }
    }

    super.onResponse(response, handler);
  }

  Duration? _elapsed(RequestOptions options) {
    final Object? startedAt = options.extra[_startedAtKey];
    if (startedAt is! DateTime) {
      return null;
    }
    return DateTime.now().difference(startedAt);
  }

  String _formatDuration(Duration? duration) {
    if (duration == null) {
      return 'n/a';
    }
    return '${duration.inMilliseconds}ms';
  }

  void _logBody(Object? body, {required String prefix}) {
    if (body == null) {
      config.sink('$prefix: <empty>');
      return;
    }

    final Object? sanitizedBody = _sanitizeBody(body);
    String text;
    try {
      if (sanitizedBody is Map<Object?, Object?> ||
          sanitizedBody is List<Object?>) {
        text = const JsonEncoder.withIndent('  ').convert(sanitizedBody);
      } else {
        text = sanitizedBody.toString();
      }
    } catch (_) {
      text = sanitizedBody.toString();
    }

    if (text.length > config.maxBodyCharacters) {
      text = '${text.substring(0, config.maxBodyCharacters)}...<truncated>';
    }

    config.sink('$prefix: $text');
  }

  void _logHeaders(Map<String, Object?> headers, {required String prefix}) {
    final Map<String, Object?> sanitized = _sanitizeHeaders(headers);
    config.sink('$prefix: ${jsonEncode(sanitized)}');
  }

  Object? _sanitizeBody(Object? value) {
    if (value is Map<Object?, Object?>) {
      final Map<String, Object?> sanitized = <String, Object?>{};
      value.forEach((Object? key, Object? nestedValue) {
        final String keyString = key.toString();
        sanitized[keyString] =
            _shouldRedact(keyString)
                ? '<redacted>'
                : _sanitizeBody(nestedValue);
      });
      return sanitized;
    }

    if (value is Iterable<Object?>) {
      return value.map(_sanitizeBody).toList(growable: false);
    }

    return value;
  }

  Map<String, Object?> _sanitizeHeaders(Map<String, Object?> headers) {
    final Map<String, Object?> sanitized = <String, Object?>{};
    headers.forEach((String key, Object? value) {
      sanitized[key] = _shouldRedact(key) ? '<redacted>' : value;
    });
    return sanitized;
  }

  bool _shouldRedact(String key) {
    return config.redactedHeaders.contains(key.toLowerCase());
  }

  bool _isDownloadRequest(RequestOptions options) {
    return options.extra['network.operation'] == 'download';
  }
}
