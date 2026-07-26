import 'network_exception.dart';
import 'network_request.dart';
import 'network_response.dart';

/// Cross-cutting hook for request, response, and error handling.
abstract class NetworkInterceptor {
  /// Creates an interceptor.
  const NetworkInterceptor();

  /// Called before the transport sends a request.
  Future<NetworkRequest> onRequest(NetworkRequest request) async => request;

  /// Called after a response has been decoded.
  Future<NetworkResponse<dynamic>> onResponse(
    NetworkResponse<dynamic> response,
  ) async => response;

  /// Called before a final exception is thrown.
  Future<void> onError(NetworkException exception) async {}
}
