// ignore_for_file: avoid_slow_async_io

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:common_tools/network/dio/dio_download_delegate.dart';
import 'package:common_tools/network/index.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as path;

void main() {
  group('DioNetworkClient', () {
    test('merges headers, injects auth token, and applies request overrides', () async {
      final _TestHttpClientAdapter adapter = _TestHttpClientAdapter(
        <_FetchHandler>[
          _jsonHandler(200, <String, Object?>{'ok': true}),
        ],
      );
      final _TestTokenProvider tokenProvider = _TestTokenProvider('secret');
      final DioNetworkClient client = _createClient(
        adapter: adapter,
        config: NetworkConfig(
          baseUrl: 'https://api.example.com',
          defaultHeaders: const <String, String>{
            'x-default': 'base',
            'x-shared': 'base',
          },
          tokenProvider: tokenProvider,
        ),
      );

      final NetworkResponse<Map<String, Object?>> response =
          await client.send<Map<String, Object?>>(
            const NetworkRequest(
              path: '/items',
              requiresAuth: true,
              headers: <String, String>{
                'x-request': 'request',
                'x-shared': 'request',
              },
              timeout: Duration(seconds: 9),
            ),
            decoder: _decodeMap,
          );

      expect(response.data['ok'], isTrue);
      expect(tokenProvider.calls, 1);
      expect(adapter.requests, hasLength(1));
      expect(
        adapter.requests.single.headers['x-default'],
        'base',
      );
      expect(
        adapter.requests.single.headers['x-shared'],
        'request',
      );
      expect(
        adapter.requests.single.headers['x-request'],
        'request',
      );
      expect(
        adapter.requests.single.headers['Authorization'],
        'Bearer secret',
      );
      expect(
        adapter.requests.single.sendTimeout,
        const Duration(seconds: 9),
      );
      expect(
        adapter.requests.single.receiveTimeout,
        const Duration(seconds: 9),
      );
      expect(
        adapter.requests.single.uri.toString(),
        'https://api.example.com/items',
      );
    });

    test('refreshes auth once after a 401 response and retries the request', () async {
      final _TestHttpClientAdapter adapter = _TestHttpClientAdapter(
        <_FetchHandler>[
          _jsonHandler(401, <String, Object?>{'message': 'expired'}),
          _jsonHandler(200, <String, Object?>{'ok': true}),
        ],
      );
      final _TestTokenProvider tokenProvider = _TestTokenProvider('stale-token');
      final _TestAuthRefreshStrategy refreshStrategy = _TestAuthRefreshStrategy(
        onRefresh: () async {
          tokenProvider.token = 'fresh-token';
          return true;
        },
      );
      final DioNetworkClient client = _createClient(
        adapter: adapter,
        config: NetworkConfig(
          baseUrl: 'https://api.example.com',
          tokenProvider: tokenProvider,
          authRefreshStrategy: refreshStrategy,
        ),
      );

      final NetworkResponse<Map<String, Object?>> response =
          await client.send<Map<String, Object?>>(
            const NetworkRequest(path: '/session', requiresAuth: true),
            decoder: _decodeMap,
          );

      expect(response.data['ok'], isTrue);
      expect(refreshStrategy.calls, 1);
      expect(adapter.requests, hasLength(2));
      expect(
        adapter.requests.first.headers['Authorization'],
        'Bearer stale-token',
      );
      expect(
        adapter.requests.last.headers['Authorization'],
        'Bearer fresh-token',
      );
    });

    test('retries idempotent failures using the configured retry policy', () async {
      final _TestHttpClientAdapter adapter = _TestHttpClientAdapter(
        <_FetchHandler>[
          _jsonHandler(500, <String, Object?>{'message': 'server'}),
          _jsonHandler(200, <String, Object?>{'ok': true}),
        ],
      );
      final DioNetworkClient client = _createClient(
        adapter: adapter,
        config: const NetworkConfig(baseUrl: 'https://api.example.com'),
      );

      final NetworkResponse<Map<String, Object?>> response =
          await client.send<Map<String, Object?>>(
            const NetworkRequest(
              path: '/retry-me',
              retryPolicy: RetryPolicy(
                maxAttempts: 2,
                baseDelay: Duration.zero,
                maxDelay: Duration.zero,
                useJitter: false,
              ),
            ),
            decoder: _decodeMap,
          );

      expect(response.data['ok'], isTrue);
      expect(adapter.requests, hasLength(2));
    });

    test('does not retry non-idempotent requests with the default retry policy', () async {
      final _TestHttpClientAdapter adapter = _TestHttpClientAdapter(
        <_FetchHandler>[
          _jsonHandler(500, <String, Object?>{'message': 'server'}),
          _jsonHandler(200, <String, Object?>{'ok': true}),
        ],
      );
      final DioNetworkClient client = _createClient(
        adapter: adapter,
        config: const NetworkConfig(baseUrl: 'https://api.example.com'),
      );

      await expectLater(
        client.send<Map<String, Object?>>(
          const NetworkRequest(
            path: '/posts',
            method: RequestMethod.post,
            retryPolicy: RetryPolicy(
              maxAttempts: 2,
              baseDelay: Duration.zero,
              maxDelay: Duration.zero,
              useJitter: false,
            ),
          ),
          decoder: _decodeMap,
        ),
        throwsA(isA<ServerNetworkException>()),
      );

      expect(adapter.requests, hasLength(1));
    });

    test('serves cached GET responses without hitting the adapter again', () async {
      final _TestHttpClientAdapter adapter = _TestHttpClientAdapter(
        <_FetchHandler>[
          _jsonHandler(200, <String, Object?>{'page': 1}),
        ],
      );
      final MemoryCacheStore cacheStore = MemoryCacheStore();
      final DioNetworkClient client = _createClient(
        adapter: adapter,
        config: NetworkConfig(
          baseUrl: 'https://api.example.com',
          cacheStore: cacheStore,
        ),
      );

      final NetworkRequest request = const NetworkRequest(
        path: '/cacheable',
        cachePolicy: CachePolicy.memory(
          ttl: Duration(minutes: 1),
        ),
      );

      final NetworkResponse<Map<String, Object?>> first =
          await client.send<Map<String, Object?>>(
            request,
            decoder: _decodeMap,
          );
      final NetworkResponse<Map<String, Object?>> second =
          await client.send<Map<String, Object?>>(
            request,
            decoder: _decodeMap,
          );

      expect(first.isFromCache, isFalse);
      expect(second.isFromCache, isTrue);
      expect(second.data['page'], 1);
      expect(adapter.requests, hasLength(1));
    });

    test('maps offline probes to a connection exception before dispatch', () async {
      final _TestHttpClientAdapter adapter = _TestHttpClientAdapter(
        <_FetchHandler>[
          _jsonHandler(200, <String, Object?>{'ok': true}),
        ],
      );
      final DioNetworkClient client = _createClient(
        adapter: adapter,
        config: NetworkConfig(
          baseUrl: 'https://api.example.com',
          connectivityProbe: _TestConnectivityProbe(false),
        ),
      );

      await expectLater(
        client.send<Map<String, Object?>>(
          const NetworkRequest(path: '/offline'),
          decoder: _decodeMap,
        ),
        throwsA(isA<ConnectionNetworkException>()),
      );

      expect(adapter.requests, isEmpty);
    });

    test('maps Dio timeout failures to a timeout exception', () async {
      final _TestHttpClientAdapter adapter = _TestHttpClientAdapter(
        <_FetchHandler>[
          (
            RequestOptions options,
            Stream<Uint8List>? requestStream,
            Future<void>? cancelFuture,
          ) {
            throw DioException.connectionTimeout(
              requestOptions: options,
              timeout: const Duration(seconds: 1),
            );
          },
        ],
      );
      final DioNetworkClient client = _createClient(
        adapter: adapter,
        config: const NetworkConfig(baseUrl: 'https://api.example.com'),
      );

      await expectLater(
        client.send<Map<String, Object?>>(
          const NetworkRequest(
            path: '/timeout',
            retryPolicy: RetryPolicy.none,
          ),
          decoder: _decodeMap,
        ),
        throwsA(isA<TimeoutNetworkException>()),
      );
    });

    test('wraps decoder failures as parsing exceptions', () async {
      final _TestHttpClientAdapter adapter = _TestHttpClientAdapter(
        <_FetchHandler>[
          _jsonHandler(200, <String, Object?>{'id': 7}),
        ],
      );
      final DioNetworkClient client = _createClient(
        adapter: adapter,
        config: const NetworkConfig(baseUrl: 'https://api.example.com'),
      );

      await expectLater(
        client.send<int>(
          const NetworkRequest(path: '/parse'),
          decoder: (Object? rawData) {
            throw const FormatException('invalid payload');
          },
        ),
        throwsA(isA<ParsingNetworkException>()),
      );
    });

    test('maps cancelled requests to a cancellation exception', () async {
      final _TestHttpClientAdapter adapter = _TestHttpClientAdapter(
        <_FetchHandler>[
          (
            RequestOptions options,
            Stream<Uint8List>? requestStream,
            Future<void>? cancelFuture,
          ) async {
            final Completer<ResponseBody> completer = Completer<ResponseBody>();
            if (cancelFuture != null) {
              unawaited(
                cancelFuture.then((_) {
                  if (!completer.isCompleted) {
                    completer.completeError(
                      DioException.requestCancelled(
                        requestOptions: options,
                        reason: 'cancelled',
                      ),
                    );
                  }
                }),
              );
            }
            return completer.future;
          },
        ],
      );
      final DioCancelToken cancelToken = DioCancelToken();
      final DioNetworkClient client = _createClient(
        adapter: adapter,
        config: const NetworkConfig(baseUrl: 'https://api.example.com'),
      );

      final Future<NetworkResponse<Map<String, Object?>>> future =
          client.send<Map<String, Object?>>(
            NetworkRequest(path: '/cancel', cancelToken: cancelToken),
            decoder: _decodeMap,
          );

      await Future<void>.delayed(const Duration(milliseconds: 10));
      cancelToken.cancel('user cancelled');

      await expectLater(
        future,
        throwsA(isA<CancelledNetworkException>()),
      );
    });

    test('redacts sensitive logger fields and truncates large bodies', () async {
      final List<String> logs = <String>[];
      final String veryLongValue = List<String>.filled(300, 'x').join();
      final _TestHttpClientAdapter adapter = _TestHttpClientAdapter(
        <_FetchHandler>[
          _jsonHandler(
            200,
            <String, Object?>{
              'token': 'server-secret',
              'description': veryLongValue,
            },
            headers: const <String, List<String>>{
              'set-cookie': <String>['session=abc'],
            },
          ),
        ],
      );
      final _TestTokenProvider tokenProvider = _TestTokenProvider('client-secret');
      final DioNetworkClient client = _createClient(
        adapter: adapter,
        config: NetworkConfig(
          baseUrl: 'https://api.example.com',
          tokenProvider: tokenProvider,
          loggerConfig: NetworkLoggerConfig(
            level: LogLevel.body,
            maxBodyCharacters: 80,
            sink: logs.add,
          ),
        ),
      );

      await client.send<Map<String, Object?>>(
        const NetworkRequest(
          path: '/log',
          requiresAuth: true,
          body: <String, Object?>{
            'token': 'client-body-secret',
            'description': 'payload',
          },
        ),
        decoder: _decodeMap,
      );

      final String combinedLogs = logs.join('\n');
      expect(combinedLogs, contains('<redacted>'));
      expect(combinedLogs, isNot(contains('client-secret')));
      expect(combinedLogs, isNot(contains('client-body-secret')));
      expect(combinedLogs, isNot(contains('server-secret')));
      expect(combinedLogs, contains('<truncated>'));
    });

    test('downloads a file to disk and returns metadata', () async {
      final Directory tempDir = await Directory.systemTemp.createTemp(
        'dio-download-success-',
      );
      addTearDown(() async {
        if (await tempDir.exists()) {
          await tempDir.delete(recursive: true);
        }
      });

      final List<int> bytes = utf8.encode('hello download');
      final String savePath = path.join(tempDir.path, 'nested', 'file.txt');
      final _TestHttpClientAdapter adapter = _TestHttpClientAdapter(
        <_FetchHandler>[
          _binaryHandler(200, bytes, contentType: 'text/plain'),
        ],
      );
      final DioNetworkClient client = _createClient(
        adapter: adapter,
        config: const NetworkConfig(baseUrl: 'https://api.example.com'),
      );

      final DownloadResult result = await client.download(
        DownloadRequest(path: '/files/report.txt', savePath: savePath),
      );

      expect(await File(savePath).readAsString(), 'hello download');
      expect(result.filePath, savePath);
      expect(result.bytesWritten, bytes.length);
      expect(result.contentLength, bytes.length);
      expect(result.mimeType, 'text/plain');
      expect(result.statusCode, 200);
      expect(adapter.requests.single.method, 'GET');
      expect(adapter.requests.single.uri.toString(), 'https://api.example.com/files/report.txt');
    });

    test('downloads to a temporary native file when savePath is omitted', () async {
      final _TestHttpClientAdapter adapter = _TestHttpClientAdapter(
        <_FetchHandler>[
          _binaryHandler(200, utf8.encode('temp native file')),
        ],
      );
      final DioNetworkClient client = _createClient(
        adapter: adapter,
        config: const NetworkConfig(baseUrl: 'https://api.example.com'),
      );

      final DownloadResult result = await client.download(
        const DownloadRequest(path: '/files/temporary.txt'),
      );

      expect(result.filePath, isNotNull);
      expect(result.file.path, result.filePath);
      expect(result.file.name, 'temporary.txt');
      expect(await result.file.readAsString(), 'temp native file');
      expect(File(result.filePath!).existsSync(), isTrue);
      addTearDown(() async {
        final String? filePath = result.filePath;
        if (filePath != null) {
          final File file = File(filePath);
          if (await file.exists()) {
            await file.parent.delete(recursive: true);
          }
        }
      });
    });

    test('supports an in-memory XFile download flow that ignores savePath', () async {
      final _TestHttpClientAdapter adapter = _TestHttpClientAdapter(
        <_FetchHandler>[
          _binaryHandler(
            200,
            utf8.encode('web-like body'),
            contentType: 'text/plain',
            headers: const <String, List<String>>{
              'content-disposition': <String>[
                'attachment; filename="server-name.txt"',
              ],
            },
          ),
        ],
      );
      final DioNetworkClient client = _createClient(
        adapter: adapter,
        config: const NetworkConfig(baseUrl: 'https://api.example.com'),
        downloadDelegate: const _InMemoryDownloadDelegate(),
      );

      final DownloadResult result = await client.download(
        const DownloadRequest(
          path: '/files/report.txt',
          savePath: '/ignored/native/path.txt',
        ),
      );

      expect(result.filePath, isNull);
      expect(await result.file.readAsString(), 'web-like body');
      expect(result.mimeType, 'text/plain');
      expect(adapter.requests.single.method, 'GET');
      expect(adapter.requests.single.uri.toString(), 'https://api.example.com/files/report.txt');
    });

    test('injects auth headers for downloads', () async {
      final Directory tempDir = await Directory.systemTemp.createTemp(
        'dio-download-auth-',
      );
      addTearDown(() async {
        if (await tempDir.exists()) {
          await tempDir.delete(recursive: true);
        }
      });

      final _TestTokenProvider tokenProvider = _TestTokenProvider('secret');
      final _TestHttpClientAdapter adapter = _TestHttpClientAdapter(
        <_FetchHandler>[
          _binaryHandler(200, utf8.encode('file body')),
        ],
      );
      final DioNetworkClient client = _createClient(
        adapter: adapter,
        config: NetworkConfig(
          baseUrl: 'https://api.example.com',
          tokenProvider: tokenProvider,
        ),
      );

      await client.download(
        DownloadRequest(
          path: '/files/protected.bin',
          savePath: path.join(tempDir.path, 'protected.bin'),
          requiresAuth: true,
        ),
      );

      expect(tokenProvider.calls, 1);
      expect(adapter.requests.single.headers['Authorization'], 'Bearer secret');
    });

    test('refreshes auth once after a 401 response and retries the download', () async {
      final Directory tempDir = await Directory.systemTemp.createTemp(
        'dio-download-refresh-',
      );
      addTearDown(() async {
        if (await tempDir.exists()) {
          await tempDir.delete(recursive: true);
        }
      });

      final _TestHttpClientAdapter adapter = _TestHttpClientAdapter(
        <_FetchHandler>[
          _binaryHandler(401, utf8.encode('expired')),
          _binaryHandler(200, utf8.encode('fresh file')),
        ],
      );
      final _TestTokenProvider tokenProvider = _TestTokenProvider('stale-token');
      final _TestAuthRefreshStrategy refreshStrategy = _TestAuthRefreshStrategy(
        onRefresh: () async {
          tokenProvider.token = 'fresh-token';
          return true;
        },
      );
      final DioNetworkClient client = _createClient(
        adapter: adapter,
        config: NetworkConfig(
          baseUrl: 'https://api.example.com',
          tokenProvider: tokenProvider,
          authRefreshStrategy: refreshStrategy,
        ),
      );
      final String savePath = path.join(tempDir.path, 'session.txt');

      await client.download(
        DownloadRequest(
          path: '/session/export',
          savePath: savePath,
          requiresAuth: true,
        ),
      );

      expect(await File(savePath).readAsString(), 'fresh file');
      expect(refreshStrategy.calls, 1);
      expect(adapter.requests, hasLength(2));
      expect(
        adapter.requests.first.headers['Authorization'],
        'Bearer stale-token',
      );
      expect(
        adapter.requests.last.headers['Authorization'],
        'Bearer fresh-token',
      );
    });

    test('retries retryable GET download failures', () async {
      final Directory tempDir = await Directory.systemTemp.createTemp(
        'dio-download-retry-',
      );
      addTearDown(() async {
        if (await tempDir.exists()) {
          await tempDir.delete(recursive: true);
        }
      });

      final _TestHttpClientAdapter adapter = _TestHttpClientAdapter(
        <_FetchHandler>[
          _binaryHandler(500, utf8.encode('server failure')),
          _binaryHandler(200, utf8.encode('report')),
        ],
      );
      final DioNetworkClient client = _createClient(
        adapter: adapter,
        config: const NetworkConfig(baseUrl: 'https://api.example.com'),
      );
      final String savePath = path.join(tempDir.path, 'report.txt');

      await client.download(
        DownloadRequest(
          path: '/reports/daily',
          savePath: savePath,
          retryPolicy: const RetryPolicy(
            maxAttempts: 2,
            baseDelay: Duration.zero,
            maxDelay: Duration.zero,
            useJitter: false,
          ),
        ),
      );

      expect(await File(savePath).readAsString(), 'report');
      expect(adapter.requests, hasLength(2));
    });

    test('replaces an existing file only after a successful download', () async {
      final Directory tempDir = await Directory.systemTemp.createTemp(
        'dio-download-overwrite-success-',
      );
      addTearDown(() async {
        if (await tempDir.exists()) {
          await tempDir.delete(recursive: true);
        }
      });

      final String savePath = path.join(tempDir.path, 'overwrite.txt');
      await File(savePath).writeAsString('old body');
      final _TestHttpClientAdapter adapter = _TestHttpClientAdapter(
        <_FetchHandler>[
          _binaryHandler(200, utf8.encode('new body')),
        ],
      );
      final DioNetworkClient client = _createClient(
        adapter: adapter,
        config: const NetworkConfig(baseUrl: 'https://api.example.com'),
      );

      await client.download(
        DownloadRequest(path: '/files/latest', savePath: savePath),
      );

      expect(await File(savePath).readAsString(), 'new body');
      expect(File('$savePath.part').existsSync(), isFalse);
      expect(File('$savePath.bak').existsSync(), isFalse);
    });

    test('preserves the existing file and cleans temp files on failed responses', () async {
      final Directory tempDir = await Directory.systemTemp.createTemp(
        'dio-download-failure-',
      );
      addTearDown(() async {
        if (await tempDir.exists()) {
          await tempDir.delete(recursive: true);
        }
      });

      final String savePath = path.join(tempDir.path, 'report.txt');
      await File(savePath).writeAsString('old content');
      final _TestHttpClientAdapter adapter = _TestHttpClientAdapter(
        <_FetchHandler>[
          _binaryHandler(500, utf8.encode('error content')),
        ],
      );
      final DioNetworkClient client = _createClient(
        adapter: adapter,
        config: const NetworkConfig(baseUrl: 'https://api.example.com'),
      );

      await expectLater(
        client.download(
          DownloadRequest(
            path: '/reports/failure',
            savePath: savePath,
            retryPolicy: RetryPolicy.none,
          ),
        ),
        throwsA(isA<ServerNetworkException>()),
      );

      expect(await File(savePath).readAsString(), 'old content');
      expect(File('$savePath.part').existsSync(), isFalse);
      expect(File('$savePath.bak').existsSync(), isFalse);
    });

    test('fails before dispatch when overwrite is disabled and the file exists', () async {
      final Directory tempDir = await Directory.systemTemp.createTemp(
        'dio-download-overwrite-disabled-',
      );
      addTearDown(() async {
        if (await tempDir.exists()) {
          await tempDir.delete(recursive: true);
        }
      });

      final String savePath = path.join(tempDir.path, 'existing.txt');
      await File(savePath).writeAsString('keep me');
      final _TestHttpClientAdapter adapter = _TestHttpClientAdapter(
        <_FetchHandler>[
          _binaryHandler(200, utf8.encode('new content')),
        ],
      );
      final DioNetworkClient client = _createClient(
        adapter: adapter,
        config: const NetworkConfig(baseUrl: 'https://api.example.com'),
      );

      await expectLater(
        client.download(
          DownloadRequest(
            path: '/files/existing.txt',
            savePath: savePath,
            overwriteExisting: false,
          ),
        ),
        throwsA(isA<StorageNetworkException>()),
      );

      expect(await File(savePath).readAsString(), 'keep me');
      expect(adapter.requests, isEmpty);
    });

    test('cleans temporary files when a download is cancelled', () async {
      final Directory tempDir = await Directory.systemTemp.createTemp(
        'dio-download-cancel-',
      );
      addTearDown(() async {
        if (await tempDir.exists()) {
          await tempDir.delete(recursive: true);
        }
      });

      final _TestHttpClientAdapter adapter = _TestHttpClientAdapter(
        <_FetchHandler>[
          _streamingHandler(
            statusCode: 200,
            chunks: <List<int>>[
              utf8.encode('first chunk'),
            ],
            delay: const Duration(milliseconds: 100),
          ),
        ],
      );
      final DioCancelToken cancelToken = DioCancelToken();
      final DioNetworkClient client = _createClient(
        adapter: adapter,
        config: const NetworkConfig(baseUrl: 'https://api.example.com'),
      );
      final String savePath = path.join(tempDir.path, 'cancelled.bin');

      final Future<DownloadResult> future = client.download(
        DownloadRequest(
          path: '/files/large.bin',
          savePath: savePath,
          cancelToken: cancelToken,
        ),
      );

      await Future<void>.delayed(const Duration(milliseconds: 10));
      cancelToken.cancel('user cancelled');

      await expectLater(
        future,
        throwsA(isA<CancelledNetworkException>()),
      );

      expect(File(savePath).existsSync(), isFalse);
      expect(File('$savePath.part').existsSync(), isFalse);
    });

    test('omits binary response bodies from download logs', () async {
      final Directory tempDir = await Directory.systemTemp.createTemp(
        'dio-download-logs-',
      );
      addTearDown(() async {
        if (await tempDir.exists()) {
          await tempDir.delete(recursive: true);
        }
      });

      final List<String> logs = <String>[];
      const String secretBody = 'super-secret-download-body';
      final _TestHttpClientAdapter adapter = _TestHttpClientAdapter(
        <_FetchHandler>[
          _binaryHandler(200, utf8.encode(secretBody)),
        ],
      );
      final DioNetworkClient client = _createClient(
        adapter: adapter,
        config: NetworkConfig(
          baseUrl: 'https://api.example.com',
          loggerConfig: NetworkLoggerConfig(
            level: LogLevel.body,
            sink: logs.add,
          ),
        ),
      );

      await client.download(
        DownloadRequest(
          path: '/files/secret.bin',
          savePath: path.join(tempDir.path, 'secret.bin'),
        ),
      );

      final String combinedLogs = logs.join('\n');
      expect(combinedLogs, contains('<download body omitted>'));
      expect(combinedLogs, isNot(contains(secretBody)));
    });

    test('applies request interceptors and notifies error interceptors for downloads', () async {
      final Directory tempDir = await Directory.systemTemp.createTemp(
        'dio-download-interceptors-',
      );
      addTearDown(() async {
        if (await tempDir.exists()) {
          await tempDir.delete(recursive: true);
        }
      });

      final _RecordingNetworkInterceptor interceptor =
          _RecordingNetworkInterceptor();
      final _TestHttpClientAdapter adapter = _TestHttpClientAdapter(
        <_FetchHandler>[
          _binaryHandler(404, utf8.encode('missing')),
        ],
      );
      final DioNetworkClient client = _createClient(
        adapter: adapter,
        config: NetworkConfig(
          baseUrl: 'https://api.example.com',
          interceptors: <NetworkInterceptor>[interceptor],
        ),
      );

      await expectLater(
        client.download(
          DownloadRequest(
            path: '/files/missing.pdf',
            savePath: path.join(tempDir.path, 'missing.pdf'),
          ),
        ),
        throwsA(isA<NotFoundNetworkException>()),
      );

      expect(adapter.requests.single.headers['x-intercepted'], 'yes');
      expect(interceptor.errorCount, 1);
      expect(interceptor.responseCount, 0);
    });
  });
}

typedef _FetchHandler = Future<ResponseBody> Function(
  RequestOptions options,
  Stream<Uint8List>? requestStream,
  Future<void>? cancelFuture,
);

class _TestHttpClientAdapter implements HttpClientAdapter {
  _TestHttpClientAdapter(this.handlers);

  final List<_FetchHandler> handlers;
  final List<RequestOptions> requests = <RequestOptions>[];

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    if (handlers.isEmpty) {
      throw StateError('No response handler configured.');
    }
    final _FetchHandler handler = handlers.removeAt(0);
    return handler(options, requestStream, cancelFuture);
  }
}

class _TestConnectivityProbe implements ConnectivityProbe {
  _TestConnectivityProbe(this.isConnected);

  final bool isConnected;

  @override
  Future<bool> hasConnection() async {
    return isConnected;
  }
}

class _TestTokenProvider implements TokenProvider {
  _TestTokenProvider(this.token);

  int calls = 0;
  String? token;

  @override
  Future<String?> getToken() async {
    calls += 1;
    return token;
  }
}

class _TestAuthRefreshStrategy implements AuthRefreshStrategy {
  _TestAuthRefreshStrategy({required this.onRefresh});

  int calls = 0;
  final Future<bool> Function() onRefresh;

  @override
  Future<bool> refreshToken() async {
    calls += 1;
    return onRefresh();
  }
}

class _RecordingNetworkInterceptor extends NetworkInterceptor {
  int errorCount = 0;
  int responseCount = 0;

  @override
  Future<NetworkRequest> onRequest(NetworkRequest request) async {
    return request.copyWith(
      headers: <String, String>{
        ...request.headers,
        'x-intercepted': 'yes',
      },
    );
  }

  @override
  Future<NetworkResponse<dynamic>> onResponse(
    NetworkResponse<dynamic> response,
  ) async {
    responseCount += 1;
    return response;
  }

  @override
  Future<void> onError(NetworkException exception) async {
    errorCount += 1;
  }
}

class _InMemoryDownloadDelegate implements DioDownloadDelegate {
  const _InMemoryDownloadDelegate();

  @override
  Future<void> cleanup({
    required PreparedDownload preparedDownload,
    required NetworkRequest networkRequest,
    bool bestEffort = false,
  }) async {}

  @override
  Future<Response<dynamic>> dispatch({
    required Dio dio,
    required NetworkRequest request,
    required PreparedDownload preparedDownload,
    required Map<String, String> headers,
    required CancelToken? cancelToken,
    required Duration timeout,
  }) {
    return dio.request<List<int>>(
      request.path,
      queryParameters: request.query,
      cancelToken: cancelToken,
      onReceiveProgress: request.onReceiveProgress,
      options: Options(
        method: request.method.value,
        headers: headers,
        sendTimeout: timeout,
        receiveTimeout: timeout,
        validateStatus: (_) => true,
        responseType: ResponseType.bytes,
        extra: Map<String, dynamic>.from(request.extra),
      ),
    );
  }

  @override
  Future<DownloadArtifact> finalize({
    required DownloadRequest request,
    required NetworkRequest networkRequest,
    required PreparedDownload preparedDownload,
    required Response<dynamic> response,
  }) async {
    final List<int> bytes = response.data! as List<int>;
    return DownloadArtifact(
      file: XFile.fromData(
        Uint8List.fromList(bytes),
        mimeType: 'text/plain',
        name: filenameFromHeaders(response.headers.map) ?? 'download.txt',
        length: bytes.length,
      ),
      bytesWritten: bytes.length,
    );
  }

  @override
  bool isStorageError(Object? error) => false;

  @override
  Future<PreparedDownload> prepare({
    required DownloadRequest request,
    required NetworkRequest networkRequest,
  }) async {
    return PreparedDownload(
      suggestedFileName: inferDownloadFileName(request.path),
    );
  }

  @override
  String? storageErrorMessage(Object? error) => null;
}

DioNetworkClient _createClient({
  required _TestHttpClientAdapter adapter,
  required NetworkConfig config,
  DioDownloadDelegate? downloadDelegate,
}) {
  final DioNetworkClient client = DioNetworkClient(
    config: config,
    downloadDelegate: downloadDelegate,
  );
  client.dio.httpClientAdapter = adapter;
  return client;
}

Map<String, Object?> _decodeMap(Object? rawData) {
  if (rawData is! Map<Object?, Object?>) {
    throw const FormatException('Expected a JSON object response.');
  }

  return rawData.map<String, Object?>(
    (Object? key, Object? value) => MapEntry<String, Object?>(
      key.toString(),
      value,
    ),
  );
}

_FetchHandler _binaryHandler(
  int statusCode,
  List<int> body, {
  String contentType = 'application/octet-stream',
  Map<String, List<String>> headers = const <String, List<String>>{},
}) {
  return (
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    return ResponseBody.fromBytes(
      body,
      statusCode,
      headers: <String, List<String>>{
        Headers.contentTypeHeader: <String>[contentType],
        Headers.contentLengthHeader: <String>[body.length.toString()],
        ...headers,
      },
    );
  };
}

_FetchHandler _jsonHandler(
  int statusCode,
  Object? body, {
  Map<String, List<String>> headers = const <String, List<String>>{},
}) {
  return (
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    return ResponseBody.fromString(
      jsonEncode(body),
      statusCode,
      headers: <String, List<String>>{
        Headers.contentTypeHeader: <String>[Headers.jsonContentType],
        ...headers,
      },
    );
  };
}

_FetchHandler _streamingHandler({
  required int statusCode,
  required List<List<int>> chunks,
  required Duration delay,
  String contentType = 'application/octet-stream',
}) {
  return (
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final StreamController<Uint8List> controller = StreamController<Uint8List>();
    if (cancelFuture != null) {
      unawaited(
        cancelFuture.then((_) async {
          if (!controller.isClosed) {
            await controller.close();
          }
        }),
      );
    }

    unawaited(
      Future<void>.delayed(delay, () async {
        if (!controller.isClosed) {
          for (final List<int> chunk in chunks) {
            controller.add(Uint8List.fromList(chunk));
          }
          await controller.close();
        }
      }),
    );

    final int totalLength = chunks.fold<int>(
      0,
      (int sum, List<int> chunk) => sum + chunk.length,
    );

    return ResponseBody(
      controller.stream,
      statusCode,
      headers: <String, List<String>>{
        Headers.contentTypeHeader: <String>[contentType],
        Headers.contentLengthHeader: <String>[totalLength.toString()],
      },
    );
  };
}
