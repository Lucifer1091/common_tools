import '../../constants/types.dart';
import '../date/operators.dart';

/// Convenience math, conversion, and scheduling helpers for [Duration].
extension DurationTimeExtension on Duration {
  /// Returns this duration multiplied by [by].
  ///
  /// Example:
  /// ```dart
  /// final total = const Duration(minutes: 15).times(4); // 1 hour
  /// ```
  Duration times(int by) {
    return Duration(microseconds: inMicroseconds * by);
  }

  /// Returns this duration divided by [by] using integer division.
  ///
  /// Throws when [by] is `0`.
  Duration divide(int by) {
    return Duration(microseconds: inMicroseconds ~/ by);
  }

  /// Number of days in one week.
  static const int daysPerWeek = 7;

  /// Number of nanoseconds in one microsecond.
  static const int nanosecondsPerMicrosecond = 1000;

  /// Returns the duration represented in weeks.
  ///
  /// The result is rounded up.
  ///
  /// Example:
  /// ```dart
  /// final weeks = const Duration(days: 8).inWeeks; // 2
  /// ```
  int get inWeeks => (inDays / daysPerWeek).ceil();

  /// Returns a [DateTime] in the future by adding this [Duration] to the current time.
  ///
  /// Example:
  /// ```dart
  /// final expiresAt = const Duration(hours: 2).fromNow;
  /// ```
  DateTime get fromNow => DateTime.now() + this;

  /// Returns a [DateTime] in the past by subtracting this [Duration] from the current time.
  ///
  /// Example:
  /// ```dart
  /// final startedAt = const Duration(minutes: 30).ago;
  /// ```
  DateTime get ago => DateTime.now() - this;

  /// Returns a [Future] that completes after this [Duration] has passed.
  ///
  /// This can be used to delay execution in asynchronous code.
  ///
  /// If [callback] is omitted, the future completes with `null`.
  ///
  /// Example:
  /// ```dart
  /// await const Duration(seconds: 2).delay();
  ///
  /// final value = await const Duration(milliseconds: 300).delay(() => 42);
  /// ```
  Future<T> delay<T>([FutureOrCallback<T>? callback]) =>
      Future<T>.delayed(this, callback);

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
      min == null || max == null || min.compareTo(max) <= 0,
      'Duration min has to be shorter than max\n(min: $min - max: $max)',
    );
    if ((min != null) && compareTo(min).isNegative) {
      return min;
    } else if ((max != null) && max.compareTo(this).isNegative) {
      return max;
    }
    return this;
  }

  /// Returns the number of whole years spanned by this Duration.
  ///
  /// This is a simple `365-days` calculation and ignores leap years.
  int get inYears => inDays ~/ 365;

  /// Returns `true` when this duration is at least one year.
  bool get isInYears => inYears > 0;

  /// Returns `true` when this duration is at least one day.
  bool get isInDays => inDays > 0;

  /// Returns `true` when this duration is at least one hour and less than a day.
  bool get isInHours => inHours > 0 && !isInDays;

  /// Returns `true` when this duration is at least one minute and less than an hour.
  bool get isInMinutes => inMinutes > 0 && inHours == 0;

  /// Returns `true` when this duration is at least one second and less than a minute.
  bool get isInSeconds => inSeconds > 0 && inMinutes == 0;

  /// Returns `true` when this duration is at least one millisecond and less than a second.
  bool get isInMillis => inMilliseconds > 0 && inSeconds == 0;

  /// Returns remaining minutes after deriving hours.
  int get absoluteMinutes => inMinutes % Duration.minutesPerHour;

  /// Returns remaining hours after deriving days.
  int get absoluteHours => inHours % Duration.hoursPerDay;

  /// Returns remaining seconds after deriving minutes.
  int get absoluteSeconds => inSeconds % Duration.secondsPerMinute;
}
