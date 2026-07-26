import 'network_request.dart';

/// Decoded network response returned by the transport.
class NetworkResponse<T> {
  /// Creates a decoded response.
  const NetworkResponse({
    required this.data,
    required this.statusCode,
    required this.headers,
    required this.rawData,
    required this.request,
    this.isFromCache = false,
  });

  /// Decoded response payload.
  final T data;

  /// HTTP status code.
  final int statusCode;

  /// Response headers.
  final Map<String, List<String>> headers;

  /// Raw response payload before decoding.
  final Object? rawData;

  /// Request that produced the response.
  final NetworkRequest request;

  /// Indicates whether the response was served from a cache store.
  final bool isFromCache;
}
