/// Transport-agnostic cancellation handle for network requests.
abstract interface class NetworkCancelToken {
  /// Transport-specific cancellation object.
  Object get rawValue;

  /// Returns `true` when the request has already been cancelled.
  bool get isCancelled;
}
