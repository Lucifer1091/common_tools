part of 'extensions.dart';

extension DurationTimeExtension on Duration {
  static const int daysPerWeek = 7;
  static const int nanosecondsPerMicrosecond = 1000;

  /// Returns the duration represented in weeks.
  ///
  /// The result is the number of weeks in this duration, rounded up.
  int get inWeeks => (inDays / daysPerWeek).ceil();

  /// Returns a [DateTime] in the future by adding this [Duration] to the current time.
  ///
  /// Example:
  /// ```dart
  /// final twoDaysLater = Duration(days: 2).fromNow;
  /// ```
  DateTime get fromNow => DateTime.now() + this;

  /// Returns a [DateTime] in the past by subtracting this [Duration] from the current time.
  ///
  /// Example:
  /// ```dart
  /// final twoDaysAgo = Duration(days: 2).ago;
  /// ```
  DateTime get ago => DateTime.now() - this;

  /// Returns a [Future] that completes after this [Duration] has passed.
  ///
  /// This can be used to delay execution in asynchronous code.
  ///
  /// Example:
  /// ```dart
  /// await Duration(seconds: 2).delay;
  /// ```
  Future<void> get delay => Future.delayed(this);

  /// Returns this [Duration] clamped to be in the range [min]-[max].
  ///
  /// The comparison is done using [compareTo].
  ///
  /// The arguments [min] and [max] must form a valid range where
  /// `min.compareTo(max) <= 0`.
  ///
  /// Example:
  /// ```dart
  /// var result = Duration(days: 10, hours: 12).clamp(
  ///   min: Duration(days: 5),
  ///   max: Duration(days: 10),
  /// ); // Duration(days: 10)
  /// result = Duration(hours: 18).clamp(
  ///   min: Duration(days: 5),
  ///   max: Duration(days: 10),
  /// ); // Duration(days: 5)
  /// result = Duration(days: 0).clamp(
  ///   min: Duration(days: -5),
  ///   max: Duration(days: 5),
  /// ); // Duration(days: 0)
  /// ```
  Duration clamp({Duration? min, Duration? max}) {
    assert(
      ((min != null) && (max != null)) ? min.compareTo(max) <= 0 : true,
      'Duration min has to be shorter than max\n(min: $min - max: $max)',
    );
    if ((min != null) && compareTo(min).isNegative) {
      return min;
    } else if ((max != null) && max.compareTo(this).isNegative) {
      return max;
    }
    return this;
  }
}
