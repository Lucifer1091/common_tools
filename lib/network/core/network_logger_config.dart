import 'log_level.dart';

/// Signature used by the transport logger to emit messages.
typedef NetworkLogSink = void Function(String message);

void _defaultNetworkLogSink(String message) {
  // ignore: avoid_print
  print(message);
}

bool _isDebugMode() {
  bool isDebugMode = false;
  assert(() {
    isDebugMode = true;
    return true;
  }(), 'Debug mode detection should only run in asserts.');
  return isDebugMode;
}

/// Settings for request and response logging.
class NetworkLoggerConfig {
  /// Creates logger settings.
  const NetworkLoggerConfig({
    this.level = LogLevel.off,
    this.enabledInRelease = false,
    this.maxBodyCharacters = 2048,
    this.redactedHeaders = const <String>{
      'authorization',
      'cookie',
      'set-cookie',
      'x-api-key',
      'api-key',
      'token',
      'access-token',
      'access_token',
      'refresh-token',
      'refresh_token',
    },
    this.sink = _defaultNetworkLogSink,
  });

  /// Requested log level.
  final LogLevel level;

  /// Whether logging remains enabled in release builds.
  final bool enabledInRelease;

  /// Maximum number of body characters printed per payload.
  final int maxBodyCharacters;

  /// Header names that must be redacted when logged.
  final Set<String> redactedHeaders;

  /// Sink that receives formatted log messages.
  final NetworkLogSink sink;

  /// Returns `true` when the logger should emit messages.
  bool get isEnabled {
    if (level == LogLevel.off) return false;

    return enabledInRelease || _isDebugMode();
  }

  /// Creates a new config with overridden values.
  NetworkLoggerConfig copyWith({
    LogLevel? level,
    bool? enabledInRelease,
    int? maxBodyCharacters,
    Set<String>? redactedHeaders,
    NetworkLogSink? sink,
  }) {
    return NetworkLoggerConfig(
      level: level ?? this.level,
      enabledInRelease: enabledInRelease ?? this.enabledInRelease,
      maxBodyCharacters: maxBodyCharacters ?? this.maxBodyCharacters,
      redactedHeaders: redactedHeaders ?? this.redactedHeaders,
      sink: sink ?? this.sink,
    );
  }
}
