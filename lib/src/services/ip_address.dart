import '../network/core/network_client.dart';
import '../network/core/network_config.dart';
import '../network/core/network_exception.dart';
import '../network/core/network_request.dart';
import '../network/core/network_response.dart';
import '../network/dio/dio_network_client.dart';

/// Enum representing the format in which the IP address should be returned.
enum IPAddressFormat {
  /// IP address will be wrapped in a response map.
  json,

  /// IP address will be returned as a string.
  string,
}

/// IP protocol endpoint to use when resolving the public address.
enum IPAddressVersion {
  /// Resolve through the IPv4-only endpoint.
  v4,

  /// Resolve through the IPv6-only endpoint.
  v6,

  /// Resolve through the dual-stack endpoint.
  v64,
}

/// Exception thrown when an IP address cannot be resolved as a string.
class IPAddressException implements Exception {
  /// Creates an IP address lookup exception.
  const IPAddressException(this.message, {this.cause});

  /// Human-readable error message.
  final String message;

  /// Original failure reported by the network layer, when available.
  final Object? cause;

  @override
  String toString() {
    return message;
  }
}

/// Retrieves the public IP address using the package network layer.
class IPAddressService {
  /// Creates an IP address service.
  IPAddressService({NetworkClient? networkClient})
    : _networkClient =
          networkClient ?? DioNetworkClient(config: const NetworkConfig());

  final NetworkClient _networkClient;

  /// Retrieves the public IP address using the ipify API.
  ///
  /// Returns either a string IP address or a response map depending on
  /// [ipAddressFormat]. When [ipAddressFormat] is [IPAddressFormat.string],
  /// failures throw [IPAddressException]. When it is [IPAddressFormat.json],
  /// failures return a map with `status: false`.
  Future<Object> getIPAddress({
    IPAddressFormat ipAddressFormat = IPAddressFormat.string,
    String defaultErrorMessage = 'Not able to find the IP Address.',
    IPAddressVersion ipAddressVersion = IPAddressVersion.v64,
  }) async {
    try {
      final NetworkResponse<String> response = await _networkClient
          .send<String>(
            NetworkRequest(path: _getUrl(ipAddressVersion)),
            decoder: _decodeIPAddress,
          );

      return switch (ipAddressFormat) {
        IPAddressFormat.json => handleJSONResponse(
          status: true,
          value: response.data,
        ),
        IPAddressFormat.string => response.data,
      };
    } on NetworkException catch (error) {
      return _handleFailure(
        ipAddressFormat: ipAddressFormat,
        defaultErrorMessage: defaultErrorMessage,
        cause: error,
      );
    } catch (error) {
      return _handleFailure(
        ipAddressFormat: ipAddressFormat,
        defaultErrorMessage: defaultErrorMessage,
        cause: error,
      );
    }
  }
}

/// Retrieves the public IP address using the package network layer.
///
/// This top-level helper preserves the previous API while allowing callers to
/// inject a custom [networkClient] for shared configuration or tests.
Future<Object> getIPAddress({
  IPAddressFormat ipAddressFormat = IPAddressFormat.string,
  String defaultErrorMessage = 'Not able to find the IP Address.',
  IPAddressVersion ipAddressVersion = IPAddressVersion.v64,
  NetworkClient? networkClient,
}) {
  return IPAddressService(networkClient: networkClient).getIPAddress(
    ipAddressFormat: ipAddressFormat,
    defaultErrorMessage: defaultErrorMessage,
    ipAddressVersion: ipAddressVersion,
  );
}

/// Handles the JSON response for IP address retrieval.
///
/// Returns a map with `status` and `ip_address` keys.
Map<String, Object> handleJSONResponse({
  bool status = false,
  String value = '',
}) {
  return <String, Object>{'status': status, 'ip_address': value};
}

Object _handleFailure({
  required IPAddressFormat ipAddressFormat,
  required String defaultErrorMessage,
  required Object cause,
}) {
  return switch (ipAddressFormat) {
    IPAddressFormat.json => handleJSONResponse(value: defaultErrorMessage),
    IPAddressFormat.string => throw IPAddressException(
      defaultErrorMessage,
      cause: cause,
    ),
  };
}

String _decodeIPAddress(Object? rawData) {
  if (rawData == null) return '';

  if (rawData is String) return rawData.trim();

  return rawData.toString().trim();
}

String _getUrl(IPAddressVersion ipAddressVersion) {
  return switch (ipAddressVersion) {
    IPAddressVersion.v64 => 'https://api64.ipify.org',
    IPAddressVersion.v4 => 'https://api4.ipify.org',
    IPAddressVersion.v6 => 'https://api6.ipify.org',
  };
}
