import 'network_cancel_token.dart';
import 'network_request.dart' show ProgressCallback;
import 'retry_policy.dart';

const Object _savePathNotOverridden = Object();

/// Immutable description of a file download request.
class DownloadRequest {
  /// Creates a download request description.
  const DownloadRequest({
    required this.path,
    this.savePath,
    this.query = const <String, dynamic>{},
    this.headers = const <String, String>{},
    this.timeout,
    this.requiresAuth = false,
    this.retryPolicy,
    this.cancelToken,
    this.extra = const <String, Object?>{},
    this.onReceiveProgress,
    this.overwriteExisting = true,
  });

  /// Relative path or absolute URL.
  final String path;

  /// Optional final destination path on disk for native platforms.
  final String? savePath;

  /// Query parameters appended to the request URL.
  final Map<String, dynamic> query;

  /// Request-specific headers.
  final Map<String, String> headers;

  /// Timeout override for this request.
  final Duration? timeout;

  /// Whether auth headers should be attached automatically.
  final bool requiresAuth;

  /// Retry policy override for this request.
  final RetryPolicy? retryPolicy;

  /// Optional transport-specific cancellation handle.
  final NetworkCancelToken? cancelToken;

  /// Extra metadata carried alongside the request.
  final Map<String, Object?> extra;

  /// Callback invoked as bytes are downloaded.
  final ProgressCallback? onReceiveProgress;

  /// Whether an existing destination file should be replaced on success.
  final bool overwriteExisting;

  /// Creates a new request with overridden values.
  DownloadRequest copyWith({
    String? path,
    Object? savePath = _savePathNotOverridden,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    Duration? timeout,
    bool? requiresAuth,
    RetryPolicy? retryPolicy,
    NetworkCancelToken? cancelToken,
    Map<String, Object?>? extra,
    ProgressCallback? onReceiveProgress,
    bool? overwriteExisting,
  }) {
    return DownloadRequest(
      path: path ?? this.path,
      savePath: identical(savePath, _savePathNotOverridden)
          ? this.savePath
          : savePath as String?,
      query: query ?? this.query,
      headers: headers ?? this.headers,
      timeout: timeout ?? this.timeout,
      requiresAuth: requiresAuth ?? this.requiresAuth,
      retryPolicy: retryPolicy ?? this.retryPolicy,
      cancelToken: cancelToken ?? this.cancelToken,
      extra: extra ?? this.extra,
      onReceiveProgress: onReceiveProgress ?? this.onReceiveProgress,
      overwriteExisting: overwriteExisting ?? this.overwriteExisting,
    );
  }
}
