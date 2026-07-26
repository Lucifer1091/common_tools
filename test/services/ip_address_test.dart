import 'package:common_tools/network/index.dart';
import 'package:common_tools/services/ip_address.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('IPAddressService', () {
    test('returns an IP address string through the network layer', () async {
      final _FakeNetworkClient networkClient = _FakeNetworkClient();
      final IPAddressService service = IPAddressService(
        networkClient: networkClient,
      );

      final Object result = await service.getIPAddress();

      expect(result, '203.0.113.10');
      expect(networkClient.requests, hasLength(1));
      expect(networkClient.requests.single.path, 'https://api64.ipify.org');
    });

    test('returns the requested IP version endpoint', () async {
      final _FakeNetworkClient networkClient = _FakeNetworkClient();

      await getIPAddress(
        ipAddressVersion: IPAddressVersion.v4,
        networkClient: networkClient,
      );

      expect(networkClient.requests.single.path, 'https://api4.ipify.org');
    });

    test('wraps the IP address in a response map for json format', () async {
      final IPAddressService service = IPAddressService(
        networkClient: _FakeNetworkClient(data: '2001:db8::1'),
      );

      final Object result = await service.getIPAddress(
        ipAddressFormat: IPAddressFormat.json,
      );

      expect(result, <String, Object>{
        'status': true,
        'ip_address': '2001:db8::1',
      });
    });

    test('returns the default error map for json failures', () async {
      final IPAddressService service = IPAddressService(
        networkClient: _FakeNetworkClient(error: _connectionException),
      );

      final Object result = await service.getIPAddress(
        ipAddressFormat: IPAddressFormat.json,
        defaultErrorMessage: 'Unable to resolve IP.',
      );

      expect(result, <String, Object>{
        'status': false,
        'ip_address': 'Unable to resolve IP.',
      });
    });

    test('throws an IPAddressException for string failures', () async {
      final IPAddressService service = IPAddressService(
        networkClient: _FakeNetworkClient(error: _connectionException),
      );

      expect(
        service.getIPAddress(defaultErrorMessage: 'Unable to resolve IP.'),
        throwsA(
          isA<IPAddressException>().having(
            (IPAddressException error) => error.message,
            'message',
            'Unable to resolve IP.',
          ),
        ),
      );
    });
  });
}

final NetworkException _connectionException = NetworkException.connection(
  message: 'No internet connection',
  request: const NetworkRequest(path: 'https://api64.ipify.org'),
);

class _FakeNetworkClient implements NetworkClient {
  _FakeNetworkClient({this.data = '203.0.113.10', this.error});

  final Object? data;
  final NetworkException? error;
  final List<NetworkRequest> requests = <NetworkRequest>[];

  @override
  Future<DownloadResult> download(DownloadRequest request) {
    throw UnimplementedError();
  }

  @override
  Future<NetworkResponse<T>> send<T>(
    NetworkRequest request, {
    required ResponseDecoder<T> decoder,
  }) async {
    requests.add(request);
    final NetworkException? networkError = error;
    if (networkError != null) {
      throw networkError;
    }

    final T decoded = await decoder(data);
    return NetworkResponse<T>(
      data: decoded,
      statusCode: 200,
      headers: const <String, List<String>>{},
      rawData: data,
      request: request,
    );
  }
}
