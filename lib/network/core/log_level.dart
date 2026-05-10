/// Controls how much request and response data is logged.
enum LogLevel {
  /// Disable request logging.
  off,

  /// Log method, URL, status code, and duration.
  basic,

  /// Log basic fields plus headers.
  headers,

  /// Log headers and truncated bodies.
  body,
}
