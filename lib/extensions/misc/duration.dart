import '../../common_tools.dart';

extension DurationTimeExtension on Duration {
  static const int daysPerWeek = 7;

  static const int nanosecondsPerMicrosecond = 1000;

  /// Returns the duration represented in weeks.
  ///
  /// The result is the number of weeks in this duration, rounded up.
  int get inWeeks => (inDays / daysPerWeek).ceil();

  /// Returns a [DateTime] in the future by adding this [Duration] to the current time.
  ///
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
  /// Example 1:
  /// ```dart
  /// await Duration(seconds: 2).delay;
  /// ```
  /// Example 2:
  /// ```dart
  ///   await 3.seconds.delay(() {
  ///           ....
  ///   }
  ///```
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
      ((min != null) && (max != null)) && min.compareTo(max) <= 0,
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
  /// Please note that this does not account for leap year.
  int get inYears => inDays ~/ 365;

  /// Returns true if [this] duration equals to or more than a year.
  bool get isInYears => inYears > 0;

  /// Returns true if [this] duration equals to or more than a day.
  bool get isInDays => inDays > 0;

  /// Returns true if [this] duration equals to or more than an hour but
  /// is less than a day.
  bool get isInHours => inHours > 0 && !isInDays;

  /// Returns true if [this] duration equals to or more than a minute but
  /// is less than an hour.
  bool get isInMinutes => inMinutes > 0 && !isInHours;

  /// Returns true if [this] duration equals to or more than a second but
  /// is less than a minute.
  bool get isInSeconds => inSeconds > 0 && !isInMinutes;

  /// Returns true if [this] duration equals to or more than a millisecond but
  /// is less than a second.
  bool get isInMillis => inMilliseconds > 0 && !isInSeconds;

  /// Returns remaining minutes after deriving hours.
  int get absoluteMinutes => inMinutes % Duration.minutesPerHour;

  /// Returns remaining minutes after deriving days.
  int get absoluteHours => inHours % Duration.hoursPerDay;

  /// Returns remaining minutes after deriving minutes.
  int get absoluteSeconds => inSeconds % Duration.secondsPerMinute;
}
