part of 'utilities.dart';

/// A utility class for debouncing actions.
///
/// The `Debouncer` class is designed to delay the execution of a function
/// until a specified period has elapsed since the last time it was invoked.
/// This is particularly useful for scenarios such as user input where you
/// want to reduce the frequency of actions like API calls or expensive
/// computations.
///
/// Example usage:
/// ```dart
/// final debouncer = Debouncer(milliseconds: 500);
///
/// void onUserInput(String input) {
///   debouncer.run(() {
///     // Code to execute after the debounce period
///     print('User input: $input');
///   });
/// }
/// ```
class Debouncer {
  /// The debounce duration in milliseconds.
  final int milliseconds;

  /// Timer used to manage the debounce period.
  Timer? _timer;

  /// Creates a [Debouncer] with the specified debounce duration.
  ///
  /// The [milliseconds] parameter specifies the duration in milliseconds
  /// to wait before executing the action.
  Debouncer({required this.milliseconds});

  /// Runs the provided [action] after the debounce period.
  ///
  /// If this method is called again before the debounce period ends,
  /// the previous timer is canceled, and the debounce period restarts.
  ///
  /// - [action]: The callback function to execute after the debounce period.
  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

/// A utility class for throttling actions.
///
/// The `Throttler` class ensures that a function is executed at most once
/// in a specified time interval. This is useful for scenarios where
/// frequent events need to be handled at regular intervals, such as during
/// window resizing or scrolling.
///
/// Example usage:
/// ```dart
/// final throttler = Throttler(milliseconds: 500);
///
/// void onScroll() {
///   throttler.run(() {
///     // Code to execute during the throttle period
///     print('Scroll event');
///   });
/// }
/// ```
class Throttler {
  /// The throttle duration in milliseconds.
  final int milliseconds;

  /// Timer used to manage the throttle period.
  Timer? _timer;

  /// Flag indicating if the action is available to run.
  bool _isAvailable = true;

  /// Creates a [Throttler] with the specified throttle duration.
  ///
  /// The [milliseconds] parameter specifies the duration in milliseconds
  /// to wait before allowing the next execution of the action.
  Throttler({required this.milliseconds});

  /// Runs the provided [action] if the throttle period has elapsed.
  ///
  /// If this method is called again before the throttle period ends,
  /// the call is ignored until the period has elapsed.
  ///
  /// - [action]: The callback function to execute during the throttle period.
  void run(VoidCallback action) {
    _timer?.cancel();
    if (_isAvailable) {
      action();
      _isAvailable = false;
      _timer = Timer(Duration(milliseconds: milliseconds), () {
        _isAvailable = true;
      });
    }
  }
}
