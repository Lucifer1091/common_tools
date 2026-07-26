import 'network_request.dart';

/// Base type for all transport-independent network failures.
sealed class NetworkException implements Exception {
  /// Creates a network exception.
  const NetworkException({
    required this.message,
    required this.request,
    this.statusCode,
    this.responseBody,
    this.headers = const <String, List<String>>{},
    this.cause,
    this.stackTrace,
  });

  /// Creates a connectivity exception.
  factory NetworkException.connection({
    required String message,
    required NetworkRequest request,
    Object? responseBody,
    Map<String, List<String>> headers = const <String, List<String>>{},
    Object? cause,
    StackTrace? stackTrace,
  }) {
    return ConnectionNetworkException(
      message: message,
      request: request,
      responseBody: responseBody,
      headers: headers,
      cause: cause,
      stackTrace: stackTrace,
    );
  }

  /// Creates a timeout exception.
  factory NetworkException.timeout({
    required String message,
    required NetworkRequest request,
    Object? responseBody,
    Map<String, List<String>> headers = const <String, List<String>>{},
    Object? cause,
    StackTrace? stackTrace,
  }) {
    return TimeoutNetworkException(
      message: message,
      request: request,
      responseBody: responseBody,
      headers: headers,
      cause: cause,
      stackTrace: stackTrace,
    );
  }

  /// Creates a cancellation exception.
  factory NetworkException.cancelled({
    required String message,
    required NetworkRequest request,
    Object? responseBody,
    Map<String, List<String>> headers = const <String, List<String>>{},
    Object? cause,
    StackTrace? stackTrace,
  }) {
    return CancelledNetworkException(
      message: message,
      request: request,
      responseBody: responseBody,
      headers: headers,
      cause: cause,
      stackTrace: stackTrace,
    );
  }

  /// Creates an unauthorized exception.
  factory NetworkException.unauthorized({
    required String message,
    required NetworkRequest request,
    int statusCode = 401,
    Object? responseBody,
    Map<String, List<String>> headers = const <String, List<String>>{},
    Object? cause,
    StackTrace? stackTrace,
  }) {
    return UnauthorizedNetworkException(
      message: message,
      request: request,
      statusCode: statusCode,
      responseBody: responseBody,
      headers: headers,
      cause: cause,
      stackTrace: stackTrace,
    );
  }

  /// Creates a forbidden exception.
  factory NetworkException.forbidden({
    required String message,
    required NetworkRequest request,
    int statusCode = 403,
    Object? responseBody,
    Map<String, List<String>> headers = const <String, List<String>>{},
    Object? cause,
    StackTrace? stackTrace,
  }) {
    return ForbiddenNetworkException(
      message: message,
      request: request,
      statusCode: statusCode,
      responseBody: responseBody,
      headers: headers,
      cause: cause,
      stackTrace: stackTrace,
    );
  }

  /// Creates a not-found exception.
  factory NetworkException.notFound({
    required String message,
    required NetworkRequest request,
    int statusCode = 404,
    Object? responseBody,
    Map<String, List<String>> headers = const <String, List<String>>{},
    Object? cause,
    StackTrace? stackTrace,
  }) {
    return NotFoundNetworkException(
      message: message,
      request: request,
      statusCode: statusCode,
      responseBody: responseBody,
      headers: headers,
      cause: cause,
      stackTrace: stackTrace,
    );
  }

  /// Creates a validation exception.
  factory NetworkException.validation({
    required String message,
    required NetworkRequest request,
    required int statusCode,
    Object? responseBody,
    Map<String, List<String>> headers = const <String, List<String>>{},
    Object? cause,
    StackTrace? stackTrace,
  }) {
    return ValidationNetworkException(
      message: message,
      request: request,
      statusCode: statusCode,
      responseBody: responseBody,
      headers: headers,
      cause: cause,
      stackTrace: stackTrace,
    );
  }

  /// Creates a rate-limited exception.
  factory NetworkException.rateLimited({
    required String message,
    required NetworkRequest request,
    int statusCode = 429,
    Object? responseBody,
    Map<String, List<String>> headers = const <String, List<String>>{},
    Object? cause,
    StackTrace? stackTrace,
  }) {
    return RateLimitedNetworkException(
      message: message,
      request: request,
      statusCode: statusCode,
      responseBody: responseBody,
      headers: headers,
      cause: cause,
      stackTrace: stackTrace,
    );
  }

  /// Creates a server exception.
  factory NetworkException.server({
    required String message,
    required NetworkRequest request,
    required int statusCode,
    Object? responseBody,
    Map<String, List<String>> headers = const <String, List<String>>{},
    Object? cause,
    StackTrace? stackTrace,
  }) {
    return ServerNetworkException(
      message: message,
      request: request,
      statusCode: statusCode,
      responseBody: responseBody,
      headers: headers,
      cause: cause,
      stackTrace: stackTrace,
    );
  }

  /// Creates a parsing exception.
  factory NetworkException.parsing({
    required String message,
    required NetworkRequest request,
    Object? responseBody,
    Map<String, List<String>> headers = const <String, List<String>>{},
    Object? cause,
    StackTrace? stackTrace,
  }) {
    return ParsingNetworkException(
      message: message,
      request: request,
      responseBody: responseBody,
      headers: headers,
      cause: cause,
      stackTrace: stackTrace,
    );
  }

  /// Creates a storage exception.
  factory NetworkException.storage({
    required String message,
    required NetworkRequest request,
    Object? responseBody,
    Map<String, List<String>> headers = const <String, List<String>>{},
    Object? cause,
    StackTrace? stackTrace,
  }) {
    return StorageNetworkException(
      message: message,
      request: request,
      responseBody: responseBody,
      headers: headers,
      cause: cause,
      stackTrace: stackTrace,
    );
  }

  /// Creates an unknown exception.
  factory NetworkException.unknown({
    required String message,
    required NetworkRequest request,
    int? statusCode,
    Object? responseBody,
    Map<String, List<String>> headers = const <String, List<String>>{},
    Object? cause,
    StackTrace? stackTrace,
  }) {
    return UnknownNetworkException(
      message: message,
      request: request,
      statusCode: statusCode,
      responseBody: responseBody,
      headers: headers,
      cause: cause,
      stackTrace: stackTrace,
    );
  }

  /// Human-readable explanation of the failure.
  final String message;

  /// Request that produced the failure.
  final NetworkRequest request;

  /// HTTP status code when available.
  final int? statusCode;

  /// Raw response body or transport payload associated with the failure.
  final Object? responseBody;

  /// Response headers when available.
  final Map<String, List<String>> headers;

  /// Underlying transport or decoding error.
  final Object? cause;

  /// Stack trace captured for the failure.
  final StackTrace? stackTrace;

  @override
  String toString() {
    return 'NetworkException(message: $message, statusCode: $statusCode)';
  }
}

/// Raised when the request cannot reach the network.
final class ConnectionNetworkException extends NetworkException {
  /// Creates a connectivity exception.
  const ConnectionNetworkException({
    required super.message,
    required super.request,
    super.responseBody,
    super.headers,
    super.cause,
    super.stackTrace,
  });
}

/// Raised when the request times out.
final class TimeoutNetworkException extends NetworkException {
  /// Creates a timeout exception.
  const TimeoutNetworkException({
    required super.message,
    required super.request,
    super.responseBody,
    super.headers,
    super.cause,
    super.stackTrace,
  });
}

/// Raised when the request is cancelled.
final class CancelledNetworkException extends NetworkException {
  /// Creates a cancellation exception.
  const CancelledNetworkException({
    required super.message,
    required super.request,
    super.responseBody,
    super.headers,
    super.cause,
    super.stackTrace,
  });
}

/// Raised after a `401 Unauthorized` response.
final class UnauthorizedNetworkException extends NetworkException {
  /// Creates an unauthorized exception.
  const UnauthorizedNetworkException({
    required super.message,
    required super.request,
    super.statusCode = 401,
    super.responseBody,
    super.headers,
    super.cause,
    super.stackTrace,
  });
}

/// Raised after a `403 Forbidden` response.
final class ForbiddenNetworkException extends NetworkException {
  /// Creates a forbidden exception.
  const ForbiddenNetworkException({
    required super.message,
    required super.request,
    super.statusCode = 403,
    super.responseBody,
    super.headers,
    super.cause,
    super.stackTrace,
  });
}

/// Raised after a `404 Not Found` response.
final class NotFoundNetworkException extends NetworkException {
  /// Creates a not-found exception.
  const NotFoundNetworkException({
    required super.message,
    required super.request,
    super.statusCode = 404,
    super.responseBody,
    super.headers,
    super.cause,
    super.stackTrace,
  });
}

/// Raised after a client-side validation response such as `400` or `422`.
final class ValidationNetworkException extends NetworkException {
  /// Creates a validation exception.
  const ValidationNetworkException({
    required super.message,
    required super.request,
    required super.statusCode,
    super.responseBody,
    super.headers,
    super.cause,
    super.stackTrace,
  });
}

/// Raised after a `429 Too Many Requests` response.
final class RateLimitedNetworkException extends NetworkException {
  /// Creates a rate-limited exception.
  const RateLimitedNetworkException({
    required super.message,
    required super.request,
    super.statusCode = 429,
    super.responseBody,
    super.headers,
    super.cause,
    super.stackTrace,
  });
}

/// Raised after a `5xx` server-side response.
final class ServerNetworkException extends NetworkException {
  /// Creates a server exception.
  const ServerNetworkException({
    required super.message,
    required super.request,
    required super.statusCode,
    super.responseBody,
    super.headers,
    super.cause,
    super.stackTrace,
  });
}

/// Raised when the raw payload cannot be decoded into the requested model.
final class ParsingNetworkException extends NetworkException {
  /// Creates a parsing exception.
  const ParsingNetworkException({
    required super.message,
    required super.request,
    super.responseBody,
    super.headers,
    super.cause,
    super.stackTrace,
  });
}

/// Raised when a local file system operation fails.
final class StorageNetworkException extends NetworkException {
  /// Creates a storage exception.
  const StorageNetworkException({
    required super.message,
    required super.request,
    super.responseBody,
    super.headers,
    super.cause,
    super.stackTrace,
  });
}

/// Raised when no more specific exception matches.
final class UnknownNetworkException extends NetworkException {
  /// Creates an unknown exception.
  const UnknownNetworkException({
    required super.message,
    required super.request,
    super.statusCode,
    super.responseBody,
    super.headers,
    super.cause,
    super.stackTrace,
  });
}
