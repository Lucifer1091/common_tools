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
