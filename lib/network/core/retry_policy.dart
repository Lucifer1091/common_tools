import 'dart:math';

import 'network_exception.dart';
import 'network_method.dart';

/// Configures automatic retries for transient failures.
class RetryPolicy {
  /// Creates a retry policy.
  const RetryPolicy({
    this.maxAttempts = 1,
    this.baseDelay = const Duration(milliseconds: 250),
    this.maxDelay = const Duration(seconds: 5),
    this.useExponentialBackoff = true,
    this.useJitter = true,
    this.retryableMethods = const <RequestMethod>{
      RequestMethod.get,
      RequestMethod.put,
      RequestMethod.delete,
      RequestMethod.head,
    },
    this.retryableStatusCodes = const <int>{408, 429, 500, 502, 503, 504},
    this.retryConnectionErrors = true,
    this.retryTimeouts = true,
  });

  /// Disables retries.
  static const RetryPolicy none = RetryPolicy();

  /// Sensible default policy for idempotent requests.
  static const RetryPolicy standard = RetryPolicy(maxAttempts: 3);

  /// Total number of attempts including the first try.
  final int maxAttempts;

  /// Delay used for the first retry.
  final Duration baseDelay;

  /// Upper bound for retry delay growth.
  final Duration maxDelay;

  /// Enables exponential delay growth between attempts.
  final bool useExponentialBackoff;

  /// Adds jitter to reduce synchronized retries.
  final bool useJitter;

  /// Methods eligible for automatic retries.
  final Set<RequestMethod> retryableMethods;

  /// Status codes eligible for automatic retries.
  final Set<int> retryableStatusCodes;

  /// Whether connectivity failures should be retried.
  final bool retryConnectionErrors;

  /// Whether timeout failures should be retried.
  final bool retryTimeouts;

  /// Returns `true` when [method] may be retried under this policy.
  bool allowsMethod(RequestMethod method) {
    return retryableMethods.contains(method);
  }

  /// Returns `true` when [exception] qualifies for a retry.
  bool allowsException(NetworkException exception) {
    return switch (exception) {
      ConnectionNetworkException() => retryConnectionErrors,
      TimeoutNetworkException() => retryTimeouts,
      RateLimitedNetworkException() => true,
      ServerNetworkException() => retryableStatusCodes.contains(
        exception.statusCode,
      ),
      _ => retryableStatusCodes.contains(exception.statusCode),
    };
  }

  /// Computes the delay before the retry for [attemptNumber].
  Duration delayForAttempt(int attemptNumber) {
    int delayInMilliseconds = baseDelay.inMilliseconds;
    if (useExponentialBackoff && attemptNumber > 1) {
      delayInMilliseconds *= 1 << (attemptNumber - 1);
    }
    if (delayInMilliseconds > maxDelay.inMilliseconds) {
      delayInMilliseconds = maxDelay.inMilliseconds;
    }
    if (useJitter && delayInMilliseconds > 0) {
      final int jitter = Random().nextInt(delayInMilliseconds + 1);
      delayInMilliseconds = min(
        maxDelay.inMilliseconds,
        delayInMilliseconds + jitter,
      );
    }
    return Duration(milliseconds: delayInMilliseconds);
  }

  /// Creates a new policy with overridden values.
  RetryPolicy copyWith({
    int? maxAttempts,
    Duration? baseDelay,
    Duration? maxDelay,
    bool? useExponentialBackoff,
    bool? useJitter,
    Set<RequestMethod>? retryableMethods,
    Set<int>? retryableStatusCodes,
    bool? retryConnectionErrors,
    bool? retryTimeouts,
  }) {
    return RetryPolicy(
      maxAttempts: maxAttempts ?? this.maxAttempts,
      baseDelay: baseDelay ?? this.baseDelay,
      maxDelay: maxDelay ?? this.maxDelay,
      useExponentialBackoff:
          useExponentialBackoff ?? this.useExponentialBackoff,
      useJitter: useJitter ?? this.useJitter,
      retryableMethods: retryableMethods ?? this.retryableMethods,
      retryableStatusCodes:
          retryableStatusCodes ?? this.retryableStatusCodes,
      retryConnectionErrors:
          retryConnectionErrors ?? this.retryConnectionErrors,
      retryTimeouts: retryTimeouts ?? this.retryTimeouts,
    );
  }
}
