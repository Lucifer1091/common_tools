import 'auth_refresh_strategy.dart';
import 'cache_policy.dart';
import 'cache_store.dart';
import 'connectivity_probe.dart';
import 'network_interceptor.dart';
import 'network_logger_config.dart';
import 'retry_policy.dart';
import 'token_provider.dart';

/// Shared configuration applied to a network client.
class NetworkConfig {
  /// Creates a network configuration.
  const NetworkConfig({
    this.baseUrl = '',
    this.defaultHeaders = const <String, String>{},
    this.defaultTimeout = const Duration(seconds: 30),
    this.loggerConfig = const NetworkLoggerConfig(),
    this.connectivityProbe,
    this.tokenProvider,
    this.authRefreshStrategy,
    this.cacheStore,
    this.defaultCachePolicy = CachePolicy.none,
    this.defaultRetryPolicy = RetryPolicy.standard,
    this.interceptors = const <NetworkInterceptor>[],
  });

  /// Base URL prepended to relative request paths.
  final String baseUrl;

  /// Headers applied to every request before request-specific overrides.
  final Map<String, String> defaultHeaders;

  /// Default timeout applied when the request does not override it.
  final Duration defaultTimeout;

  /// Logger settings for transport-level diagnostics.
  final NetworkLoggerConfig loggerConfig;

  /// Optional connectivity abstraction used before dispatching requests.
  final ConnectivityProbe? connectivityProbe;

  /// Optional token provider used for authenticated requests.
  final TokenProvider? tokenProvider;

  /// Optional refresh strategy used after `401` responses.
  final AuthRefreshStrategy? authRefreshStrategy;

  /// Cache store used when a request enables caching.
  final CacheStore? cacheStore;

  /// Default cache policy applied when a request does not override it.
  final CachePolicy defaultCachePolicy;

  /// Default retry policy applied when a request does not override it.
  final RetryPolicy defaultRetryPolicy;

  /// Cross-cutting request/response/error interceptors.
  final List<NetworkInterceptor> interceptors;

  /// Creates a new config with overridden values.
  NetworkConfig copyWith({
    String? baseUrl,
    Map<String, String>? defaultHeaders,
    Duration? defaultTimeout,
    NetworkLoggerConfig? loggerConfig,
    ConnectivityProbe? connectivityProbe,
    TokenProvider? tokenProvider,
    AuthRefreshStrategy? authRefreshStrategy,
    CacheStore? cacheStore,
    CachePolicy? defaultCachePolicy,
    RetryPolicy? defaultRetryPolicy,
    List<NetworkInterceptor>? interceptors,
  }) {
    return NetworkConfig(
      baseUrl: baseUrl ?? this.baseUrl,
      defaultHeaders: defaultHeaders ?? this.defaultHeaders,
      defaultTimeout: defaultTimeout ?? this.defaultTimeout,
      loggerConfig: loggerConfig ?? this.loggerConfig,
      connectivityProbe: connectivityProbe ?? this.connectivityProbe,
      tokenProvider: tokenProvider ?? this.tokenProvider,
      authRefreshStrategy: authRefreshStrategy ?? this.authRefreshStrategy,
      cacheStore: cacheStore ?? this.cacheStore,
      defaultCachePolicy: defaultCachePolicy ?? this.defaultCachePolicy,
      defaultRetryPolicy: defaultRetryPolicy ?? this.defaultRetryPolicy,
      interceptors: interceptors ?? this.interceptors,
    );
  }
}
