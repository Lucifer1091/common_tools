part of 'extensions.dart';

enum Abbreviation {
  /// Full form.
  ///
  /// e.g., "3 hours", "7 minutes"
  none,

  /// Semi-abbreviated form.
  ///
  /// e.g., "3 hr", "7 min"
  semi,

  /// Abbreviated form.
  ///
  /// e.g., "3h", "7m"
  full,
}

class DateFormats {
  DateFormats._();

  static const defaultDateTime = 'yyyy-MM-dd HH:mm:ss';
  static const defaultDate = 'yyyy-MM-dd';
  static const dateTime = 'MMM dd, yyyy h:mm a';
  static const date = 'MMM dd, yyyy';
  static const time = 'h:mm a';
  static const month = 'MMMM';
  static const monthYear = 'MMMM yyyy';
  static const monthDay = 'MMM dd';
  static const day = 'dd';
  static const fullDay = 'EEEE';
  static const shortDay = 'EEE';
  static const fullDate = 'EEE MMM dd, yyyy';
}

extension DateValidators on DateTime? {
  /// Checks if the [DateTime] value is null.
  bool get isNull => this == null;

  /// Checks if the [DateTime] value is not null.
  bool get isNotNull => !isNull;

  /// Checks if the year of this [DateTime] is a leap year.
  ///
  /// Returns `false` if the [DateTime] is `null`.
  bool get isLeapYear {
    if (this == null) return false;
    int year = this!.year;
    return (year % 4 == 0 && year % 100 != 0) || year % 400 == 0;
  }

  /// Checks if this [DateTime] is greater than [other].
  ///
  /// Returns `true` if this [DateTime] is later than [other], `false` otherwise.
  /// If this [DateTime] is null, returns `false`.
  bool isGreater(DateTime other) {
    if (this == null) return false;

    final date = this!;
    return date.toUtc().isAfter(other.toUtc());
  }

  /// Checks if this [DateTime] is after or equal to [other].
  ///
  /// Returns `true` if this [DateTime] is the same moment or later than [other],
  /// `false` otherwise.
  /// If this [DateTime] is null, returns `false`.
  bool isAfterOrEqualTo(DateTime other) {
    if (this == null) return false;

    final date = this!;
    final isAtSameMomentAs = other.isAtSameMomentAs(date);
    return isAtSameMomentAs || date.isAfter(other);
  }

  /// Checks if this [DateTime] is before or equal to [other].
  ///
  /// Returns `true` if this [DateTime] is the same moment or earlier than [other],
  /// `false` otherwise.
  /// If this [DateTime] is null, returns `false`.
  bool isBeforeOrEqualTo(DateTime other) {
    if (this == null) return false;

    final date = this!;
    final isAtSameMomentAs = other.isAtSameMomentAs(date);
    return isAtSameMomentAs || date.isBefore(other);
  }

  /// Checks if this [DateTime] is between [from] and [to].
  ///
  /// Returns `true` if this [DateTime] is later than or equal to [from] and earlier
  /// than or equal to [to], `false` otherwise.
  /// If this [DateTime] is null, returns `false`.
  bool isBetween(DateTime from, DateTime to) {
    if (this == null) return false;

    final date = this!;
    final isAfter = date.isAfterOrEqualTo(from);
    final isBefore = date.isBeforeOrEqualTo(to);
    return isAfter && isBefore;
  }

  /// Checks if this [DateTime] represents the same date as [other].
  ///
  /// Returns `true` if both [DateTime] instances have the same year, month, and day,
  /// `false` otherwise.
  /// If this [DateTime] is null, returns `false`.
  bool isSameDate(DateTime other) {
    if (this == null) return false;

    final date = this!;
    return date.year == other.year &&
        date.month == other.month &&
        date.day == other.day;
  }

  /// Checks if this [DateTime] represents the same time as [other].
  ///
  /// Returns `true` if both [DateTime] instances have the same hour, and minute
  /// `false` otherwise.
  /// If this [DateTime] is null, returns `false`.
  bool isSameTime(DateTime other) {
    if (this == null) return false;

    final date = this!;
    return date.hour == other.hour && date.minute == other.minute;
  }

  /// Checks if this [DateTime] represents the same date and time as [other].
  ///
  /// Returns `true` if both [DateTime] instances have the same year, month, day, hour,
  /// and minute, `false` otherwise.
  /// If this [DateTime] is null, returns `false`.
  bool isSameDateAndTime(DateTime other) {
    if (this == null) return false;

    return isSameDate(other) && isSameTime(other);
  }

  /// Checks if the DateTime instance represents today's date.
  ///
  /// This function compares the year, month, and day of the DateTime instance
  /// with the current date. If all these components match, it returns true.
  ///
  /// Example:
  /// ```dart
  /// DateTime date = DateTime.now();
  /// bool result = date.isToday; // result will be true
  /// ```
  ///
  /// Returns `true` if the date is today, otherwise `false`.
  bool get isToday => isSameDate(DateTime.now());

  /// Checks if the DateTime instance represents yesterday's date.
  ///
  /// This function subtracts one day from the current date and compares
  /// the year, month, and day of the DateTime instance with the resulting date.
  /// If all these components match, it returns true.
  ///
  /// Example:
  /// ```dart
  /// DateTime date = DateTime.now().subtract(Duration(days: 1));
  /// bool result = date.isYesterday; // result will be true
  /// ```
  ///
  /// Returns `true` if the date is yesterday, otherwise `false`.
  bool get isYesterday => isSameDate(
        DateTime.now().subtract(const Duration(days: 1)),
      );

  /// Checks if the DateTime instance represents tomorrow's date.
  ///
  /// This function adds one day to the current date and compares
  /// the year, month, and day of the DateTime instance with the resulting date.
  /// If all these components match, it returns true.
  ///
  /// Example:
  /// ```dart
  /// DateTime date = DateTime.now().add(Duration(days: 1));
  /// bool result = date.isTomorrow; // result will be true
  /// ```
  ///
  /// Returns `true` if the date is tomorrow, otherwise `false`.
  bool get isTomorrow =>
      isSameDate(DateTime.now().add(const Duration(days: 1)));

  /// Checks if the current DateTime instance is in the past.
  ///
  /// Returns `true` if the current DateTime instance represents a moment
  /// before the current date and time as returned by [DateTime.now],
  /// otherwise returns `false`.
  ///
  /// Example:
  /// ```dart
  /// final dateTime = DateTime(2000);
  /// final bool result = dateTime.isInPast();
  /// print(result); // true, since 2000 is in the past
  /// ```
  bool get isInPast => isNotNull && this!.isBefore(DateTime.now());

  /// Checks if the current DateTime instance is in the future.
  ///
  /// Returns `true` if the current DateTime instance represents a moment
  /// after the current date and time as returned by [DateTime.now],
  /// otherwise returns `false`.
  ///
  /// Example:
  /// ```dart
  /// final dateTime = DateTime(3000);
  /// final bool result = dateTime.isInFuture();
  /// print(result); // true, since 3000 is in the future
  /// ```
  bool get isInFuture => isNotNull && this!.isAfter(DateTime.now());

  /// Checks if the current date is between the specified start date and end date.
  ///
  /// Returns `true` if the current date is greater than or equal to the start date
  /// and less than or equal to the end date. Otherwise, returns `false`.
  ///
  /// Example:
  /// ```dart
  /// final startDate = DateTime(2024, 5, 1);
  /// final endDate = DateTime(2024, 5, 31);
  /// final currentDate = DateTime.now();
  ///
  /// final bool result = currentDate.isDateInRange(startDate, endDate);
  /// print(result); // true if currentDate is between May 1 and May 31, 2024
  /// ```
  bool isDateInRange(
    DateTime startDate,
    DateTime endDate, [
    DateTime? currentDate,
  ]) {
    final current = currentDate ?? this ?? DateTime.now();
    return current.isAfter(startDate) && current.isBefore(endDate);
  }

  /// Checks if the datetime has passed a specified duration.
  ///
  /// Returns `true` if the current datetime is later than the given duration.
  /// Otherwise, returns `false`.
  ///
  /// Example:
  /// ```dart
  /// final date = DateTime.parse('2024-05-27T14:31:57.505Z');
  /// final bool result = date.hasDurationPassed(Duration(hours: 5, minutes: 30));
  /// print(result); // Returns true if the current time is past 20:01:57.505Z on 2024-05-27
  /// ```
  bool hasDurationPassed(Duration duration) {
    if (isNull) return false;

    return DateTime.now().isAfter(this!.add(duration));
  }
}

extension DateConversions on DateTime {
  /// Formats the [DateTime] value to a string using the specified [pattern] and [locale].
  ///
  /// Returns the formatted string.
  String format({
    String pattern = DateFormats.dateTime,
    String locale = 'en_US',
  }) =>
      DateFormat(pattern, locale).format(this);

  /// Formats the [DateTime] value to a string in 'MM/dd/yyyy' format.
  ///
  /// Returns the formatted string.
  String get toDate => DateFormat.yMd().format(this);

  /// Converts the month of the [DateTime] to a string representing the month's name.
  ///
  /// If [Abbreviation] is [Abbreviation.full], returns the abbreviated form of the month's name.
  ///
  /// Returns the full or abbreviated month name as a string.
  ///
  /// Example:
  /// ```dart
  /// DateTime date = DateTime(2024, 6, 23);
  /// print(date.toMonth()); // Output: June
  /// print(date.toMonth(style : Abbreviation.full)); // Output: Jun
  /// ```
  String toMonth({Abbreviation style = Abbreviation.none}) {
    return month.toMonthName(style: style);
  }

  /// Converts the weekday of the [DateTime] to a string representing the day's name.
  ///
  /// If [Abbreviation] is [Abbreviation.none], returns the normal form of the day's name (e.g., Monday).
  ///
  /// If [Abbreviation] is [Abbreviation.semi], returns the abbreviated form of the day's name (e.g., "Mon" for Monday).
  ///
  /// If [Abbreviation] is [Abbreviation.full], returns a very short form of the day's name (e.g., "M" for Monday).
  ///
  /// Returns the full, abbreviated, or very short day name as a string.
  ///
  /// Example:
  /// ```dart
  /// DateTime date = DateTime(2024, 6, 23);
  /// print(date.toWeekday()); // Output: Thursday
  /// print(date.toWeekday(style : Abbreviation.semi)); // Output: Thu
  /// print(date.toWeekday(style : Abbreviation.full)); // Output: T
  /// ```
  String toWeekday({Abbreviation style = Abbreviation.none}) {
    return weekday.toDayName(style: style);
  }

  /// Formats the [DateTime] value to a string in 'hh:mm a' format.
  ///
  /// Returns the formatted string.
  String get toTime => DateFormat.jm().format(this);

  /// Formats the [DateTime] value to a string in 'MM/dd/yyyy hh:mm a' format.
  ///
  /// Returns the formatted string.
  String get toDateTime => DateFormat(DateFormats.dateTime).format(this);

  /// Calculates the total minutes represented by the time of day of the [DateTime] value.
  ///
  /// Returns the total minutes.
  int get totalMinutes => hour * 60 + minute;

  /// Converts the [DateTime] value to a [TimeOfDay] object.
  ///
  /// Returns the [TimeOfDay] object.
  TimeOfDay get timeOfDay => TimeOfDay(hour: hour, minute: minute);

  /// Compares this [DateTime] with [other].
  ///
  /// Returns a negative value if this [DateTime] is before [other], zero if they are equal,
  /// and a positive value if this [DateTime] is after [other].
  ///
  /// Throws an [ArgumentError] if [other] is null.
  int compareTo(DateTime other) => compareTo(other);

  /// Returns a string representing the time ago from this [DateTime] to now.
  ///
  /// Returns the formatted time ago string.
  /// Example: "3 days ago", "1 year ago", etc.
  String get timeAgo {
    final now = DateTime.now().toUtc();
    final self = toUtc();
    final diff = now.difference(self);
    final sec = diff.inSeconds;

    if (sec < 0) return format(pattern: DateFormats.date);

    return sec.timeAgo();
  }

  /// Sets the hour, minute, second, millisecond, and microsecond of this [DateTime].
  ///
  /// Returns a new [DateTime] with the updated values.
  DateTime setHour(
    int hour, [
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  ]) =>
      DateTime(
        year,
        month,
        day,
        hour,
        minute ?? this.minute,
        second ?? this.second,
        millisecond ?? this.millisecond,
        microsecond ?? this.microsecond,
      );

  /// Creates a new [DateTime] instance with the provided fields replaced.
  ///
  /// Returns a new [DateTime] with the updated values.
  DateTime copyWith({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  }) =>
      isUtc
          ? DateTime.utc(
              year ?? this.year,
              month ?? this.month,
              day ?? this.day,
              hour ?? this.hour,
              minute ?? this.minute,
              second ?? this.second,
              millisecond ?? this.millisecond,
              microsecond ?? this.microsecond,
            )
          : DateTime(
              year ?? this.year,
              month ?? this.month,
              day ?? this.day,
              hour ?? this.hour,
              minute ?? this.minute,
              second ?? this.second,
              millisecond ?? this.millisecond,
              microsecond ?? this.microsecond,
            );

  /// Creates a new [DateTime] instance that is a copy of this instance.
  ///
  /// Returns a new [DateTime] instance.
  DateTime get clone => DateTime.fromMicrosecondsSinceEpoch(
        microsecondsSinceEpoch,
        isUtc: isUtc,
      );

  /// Returns the starting [DateTime] of the current year.
  ///
  /// Returns a new [DateTime] instance set to the start of the year.
  DateTime get startOfYear => DateTime(year, 1).startOfDay;

  /// Returns the ending [DateTime] of the current year.
  ///
  /// Returns a new [DateTime] instance set to the end of the year.
  DateTime get endOfYear => DateTime(year, 12, 31).startOfDay;

  /// Returns the starting [DateTime] of the current day.
  ///
  /// Returns a new [DateTime] instance set to the start of the day.
  DateTime get startOfDay => clone.setHour(0, 0, 0, 0, 0);

  /// Returns the ending [DateTime] of the current day.
  ///
  /// Returns a new [DateTime] instance set to the end of the day.
  DateTime get endOfDay => clone.setHour(23, 59, 59, 59, 59);

  /// Returns the starting [DateTime] of the current week.
  ///
  /// Returns a new [DateTime] instance set to the start of the week.
  /// Reference: https://stackoverflow.com/questions/62872349/dart-flutter-get-first-datetime-of-this-week
  DateTime get startOfWeek => subtract(Duration(days: weekday - 1)).startOfDay;

  /// Returns the ending [DateTime] of the current week.
  ///
  /// Returns a new [DateTime] instance set to the end of the week.
  DateTime get endOfWeek =>
      add(Duration(days: DateTime.daysPerWeek - weekday)).startOfDay;

  /// Calculates the number of ISO weeks for the current year.
  ///
  /// Returns the number of ISO weeks.
  /// Calculates number of weeks for a given year as per https://en.wikipedia.org/wiki/ISO_week_date#Weeks_per_year
  int _numOfWeeks(int year) {
    DateTime dec28 = DateTime(year, 12, 28);
    int dayOfDec28 = int.parse(DateFormat("D").format(dec28));
    return ((dayOfDec28 - dec28.weekday + 10) / 7).floor();
  }

  /// Returns the ISO week number for the current [DateTime].
  ///
  /// Returns the ISO week number.
  /// Calculates week number from a date as per https://en.wikipedia.org/wiki/ISO_week_date#Calculation
  int get weekNumber {
    int dayOfYear = int.parse(DateFormat("D").format(this));
    int woy = ((dayOfYear - weekday + 10) / 7).floor();
    if (woy < 1) {
      woy = _numOfWeeks(year - 1);
    } else if (woy > _numOfWeeks(year)) {
      woy = 1;
    }
    return woy;
  }

  /// Returns the starting [DateTime] of the current month.
  ///
  /// Returns a new [DateTime] instance set to the start of the month.
  DateTime get startOfMonth => DateTime(year, month).startOfDay;

  /// Returns the ending [DateTime] of the current month.
  ///
  /// Returns a new [DateTime] instance set to the end of the month.
  DateTime get endOfMonth => DateTime(year, month + 1, 0).startOfDay;

  /// Returns the starting [DateTime] of the next month.
  ///
  /// Returns a new [DateTime] instance set to the start of the next month.
  DateTime get nextMonth => DateTime(year, month + 1);

  /// Returns the starting [DateTime] of the previous month.
  ///
  /// Returns a new [DateTime] instance set to the start of the previous month.
  DateTime get previousMonth => DateTime(year, month - 1);

  /// Returns the [DateTime] of the previous day.
  ///
  /// Returns a new [DateTime] instance set to the previous day.
  DateTime get beforeDay => DateTime(year, month, day - 1).startOfDay;

  /// Returns the [DateTime] of the next day.
  ///
  /// Returns a new [DateTime] instance set to the next day.
  DateTime get nextDay => DateTime(year, month, day + 1).startOfDay;

  /// Calculates the age based on the current date.
  ///
  /// Returns the age in years.
  int get toAge => ((DateTime.now().difference(this).inDays) ~/ 365);

  /// Adds a specified number of business days.
  ///
  /// The function skips weekends, considering them as non-business days.
  /// It takes into account only Monday to Friday as business days.
  ///
  /// `days`: The number of business days to add.
  ///
  /// Returns a new `DateTime` instance with the added business days.
  ///
  /// Example:
  /// ```dart
  /// final startDate = DateTime(2024, 5, 1);
  /// final resultDate = startDate.addWorkingDays(10);
  /// print(resultDate); // Prints the date after adding 10 business days.
  /// ```
  DateTime addWorkingDays(int days) {
    int totalDays = days;
    DateTime result = this;
    while (totalDays > 0) {
      result = result.add(const Duration(days: 1));
      if (result.weekday != DateTime.saturday &&
          result.weekday != DateTime.sunday) {
        totalDays--;
      }
    }
    return result;
  }

  /// Subtracts a specified number of business days.
  ///
  /// The function skips weekends, considering them as non-business days.
  /// It takes into account only Monday to Friday as business days.
  ///
  /// `days`: The number of business days to subtract.
  ///
  /// Returns a new `DateTime` instance with the subtracted business days.
  ///
  /// Example:
  /// ```dart
  /// final endDate = DateTime(2024, 5, 31);
  /// final resultDate = date.subtractWorkingDays(10);
  /// print(resultDate); // Prints the date after subtracting 10 business days.
  /// ```
  DateTime subtractWorkingDays(int days) {
    int totalDays = days;
    DateTime result = this;
    while (totalDays > 0) {
      result = result.subtract(const Duration(days: 1));
      if (result.weekday != DateTime.saturday &&
          result.weekday != DateTime.sunday) {
        totalDays--;
      }
    }
    return result;
  }

  /// Returns the [DateTime] resulting from adding the given number
  /// of days to this [DateTime].
  ///
  /// The result is computed by incrementing the day parts of this
  /// [DateTime] by [days] days.
  ///
  /// For example:
  /// (2020, 12, 31) -> add 2 days -> (2021, 01, 2).
  /// (2020, 12, 31) -> add 14 days -> (2021, 1, 14).
  DateTime addDays(int days) => copyWith(day: day + days);

  /// Returns the [DateTime] resulting from adding the given number
  /// of weeks to this [DateTime].
  ///
  /// The result is computed by incrementing the day parts of this
  /// [DateTime] by [weeks] weeks.
  ///
  /// For example:
  /// (2020, 12, 31) -> add 1 week -> (2021, 01, 7).
  /// (2020, 12, 31) -> add 14 weeks -> (2021, 04, 08).
  DateTime addWeeks(int weeks) => addDays(DateTime.daysPerWeek * weeks);

  /// Returns the [DateTime] resulting from adding the given number
  /// of months to this [DateTime].
  ///
  /// The result is computed by incrementing the month parts of this
  /// [DateTime] by [months] months, and, if required, adjusting the day part
  /// of the resulting date downwards to the last day of the resulting month.
  ///
  /// For example:
  /// (2020, 12, 31) -> add 2 months -> (2021, 2, 28).
  /// (2020, 12, 31) -> add 1 month -> (2021, 1, 31).
  DateTime addMonths(int months) {
    var res = copyWith(month: month + months);
    if (day != res.day) res = copyWith(day: 0);
    return res;
  }

  /// Returns the [DateTime] resulting from adding the given number
  /// of years to this [DateTime].
  ///
  /// The result is computed by incrementing the year part of this
  /// [DateTime] by [years] years, and, if required, adjusting the day part
  /// of the resulting date downwards to the last day of the month
  /// in resulting year.
  ///
  /// For example:
  /// (2020, 12, 31) -> add 2 years -> (2022, 12, 31).
  /// (2020, 02, 29) -> add 1 year -> (2021, 02, 28).
  DateTime addYears(int years) {
    var res = copyWith(year: year + years);
    if (day != res.day) res = copyWith(day: 0);
    return res;
  }

  /// Rounds this [DateTime] to the nearest quarter hour.
  ///
  /// Example:
  /// ```dart
  /// DateTime dateTime = DateTime(2024, 6, 23, 14, 38);
  /// DateTime roundedDateTime = dateTime.nearestQuarter();
  /// print(roundedDateTime); // Output: 2024-06-23 14:45:00.000
  /// ```
  ///
  /// Returns a new [DateTime] instance rounded to the nearest quarter hour.
  DateTime nearestQuarter() {
    // Calculate the minute value nearest to the quarter-hour mark
    int roundedMinute = [15, 30, 45, 60][(minute / 15).floor()];

    // Return a new DateTime instance with the rounded minute value
    return DateTime(year, month, day, hour, roundedMinute);
  }

  /// Rounds this [DateTime] to the nearest half hour.
  ///
  /// Example:
  /// ```dart
  /// DateTime dateTime = DateTime(2024, 6, 23, 14, 38);
  /// DateTime roundedDateTime = dateTime.nearestHalf();
  /// print(roundedDateTime); // Output: 2024-06-23 15:00:00.000
  /// ```
  ///
  /// Returns a new [DateTime] instance rounded to the nearest half hour.
  DateTime nearestHalf() {
    // Calculate the minute value nearest to the half-hour mark
    int roundedMinute = [30, 60][(minute / 30).floor()];

    // Return a new DateTime instance with the rounded minute value
    return DateTime(year, month, day, hour, roundedMinute);
  }

  /// Rounds this [DateTime] to the nearest half hour.
  ///
  /// Example:
  /// ```dart
  /// DateTime dateTime = DateTime(2024, 6, 23, 14, 38);
  /// DateTime roundedDateTime = dateTime.nearestHalfHour();
  /// print(roundedDateTime); // Output: 2024-06-23 14:30:00.000
  /// ```
  ///
  /// Returns a new [DateTime] instance rounded to the nearest half hour.
  DateTime nearestHalfHour() {
    // Calculate the minute value rounded to the nearest half hour
    int roundedMinute = [0, 30, 60][(minute / 30).round()];

    // Return a new DateTime instance with the rounded minute value
    return DateTime(year, month, day, hour, roundedMinute);
  }

  /// Gets the Unix timestamp of this [DateTime].
  ///
  /// Returns the Unix timestamp in seconds as an integer.
  int get timeStamp => (millisecondsSinceEpoch ~/ 1000).toInt();

  /// Gets the number of days in the month of this [DateTime].
  ///
  /// This method calculates the number of days in the current month of the
  /// [DateTime] instance, accounting for leap years.
  ///
  /// Returns the number of days in the month as an integer.
  ///
  /// Example:
  /// ```dart
  /// DateTime date = DateTime(2024, 2);
  /// int daysInFebruary = date.daysInMonth; // 29
  /// ```
  int get daysInMonth {
    const List<int> monthLength = [
      31, // January
      28, // February
      31, // March
      30, // April
      31, // May
      30, // June
      31, // July
      31, // August
      30, // September
      31, // October
      30, // November
      31, // December
    ];

    if (month == 2 && isLeapYear) return 29;

    return monthLength[month - 1];
  }

  /// Generates an iterable sequence of dates starting from `this` date up to
  /// but not including the `end` date.
  ///
  /// Optionally, the end date can be included in the sequence by setting
  /// [inclusive] to `true`.
  ///
  /// Dates are yielded in ascending order, adjusting for changes in timezone
  /// offset during iteration.
  ///
  /// Example usage:
  ///
  /// ```dart
  /// DateTime startDate = DateTime(2024, 6, 1);
  /// DateTime endDate = DateTime(2024, 6, 10);
  ///
  /// Iterable<DateTime> dates = startDate.daysInRange(endDate, inclusive: false);
  ///
  /// for (var date in dates) {
  ///   print(date.toIso8601String());
  /// }
  /// ```
  Iterable<DateTime> daysInRange(DateTime end, {bool inclusive = true}) sync* {
    DateTime i = this;
    Duration offset = timeZoneOffset;

    while (inclusive
        ? i.isBefore(end) || i.isAtSameMomentAs(end)
        : i.isBefore(end)) {
      yield i;
      i = i.add(const Duration(days: 1));

      Duration timeZoneDiff = i.timeZoneOffset - offset;
      if (timeZoneDiff.inSeconds != 0) {
        offset = i.timeZoneOffset;
        i = i.subtract(timeZoneDiff);
      }
    }
  }

  /// Calculates the day of the year (1-based index) for the current date.
  ///
  /// The day of the year is calculated as the 1-based index of the current date
  /// within its year. For example, January 1st returns 1, February 1st returns 32,
  /// and December 31st returns 365 (or 366 in a leap year).
  int get dayOfYear {
    // Get the date of January 1st of the current year
    DateTime jan1st = DateTime(year, 1, 1);

    // Calculate the difference in days between the current date and January 1st
    int difference = differenceInDays(jan1st);

    // Add 1 because differenceInDays returns a 0-based difference
    return difference + 1;
  }

  /// Calculates the difference in days between two DateTime objects.
  ///
  /// Returns the difference in days as an integer. The calculation is based on
  /// the difference between the dates at midnight, ignoring any time component.
  int differenceInDays(DateTime other) {
    DateTime a = this;

    // Convert both dates to midnight for accurate day difference calculation
    DateTime aMidnight = DateTime(a.year, a.month, a.day);
    DateTime bMidnight = DateTime(other.year, other.month, other.day);

    // Calculate the difference in milliseconds
    int differenceInMilliseconds =
        aMidnight.difference(bMidnight).inMilliseconds;

    // Convert milliseconds to days
    return (differenceInMilliseconds / (24 * 60 * 60 * 1000)).round();
  }

  /// Calculates the ISO week number for the current date.
  ///
  /// The ISO week number defines the week of the year based on the ISO 8601 standard.
  /// The week containing January 4th is considered the first week of the year (week 1).
  /// If January 4th falls on a Monday to Wednesday, the previous year's last week is considered week 53.
  /// This method handles daylight savings time and compares dates based on their UTC representation.
  int get isoWeekNumber {
    // Calculate the day of the year (1-based)
    int dayOfYear = int.parse(DateFormat("D").format(this));

    // Find the first Thursday of the year
    DateTime firstThursdayOfYear = DateTime(year, 1, 1);
    while (firstThursdayOfYear.weekday != DateTime.thursday) {
      firstThursdayOfYear = firstThursdayOfYear.add(const Duration(days: 1));
    }

    // Calculate the week number based on the position of this date relative to the first Thursday
    int weekNumber =
        ((dayOfYear - firstThursdayOfYear.dayOfYear + 7) ~/ 7).toInt();

    // Adjust if the week number goes beyond the end of the previous year
    if (weekNumber == 0) {
      weekNumber = DateTime(year - 1, 12, 31).isoWeekNumber;
    } else if (weekNumber == 53 &&
        DateTime(year, 12, 31).weekday < DateTime.thursday) {
      weekNumber = 1;
    }

    return weekNumber;
  }

  /// Determines if this date falls within the same ISO week as [other].
  ///
  /// Dates are considered to be in the same ISO week if they have the same ISO week
  /// number within their respective years. This method handles daylight savings
  /// by comparing dates based on their UTC representation.
  ///
  /// Returns `true` if this date and [other] are in the same ISO week; otherwise, returns `false`.
  bool isSameWeek(DateTime other) {
    // Convert dates to UTC to handle daylight savings time correctly
    DateTime a = DateTime.utc(year, month, day);
    other = DateTime.utc(other.year, other.month, other.day);

    // Calculate ISO week numbers for both dates
    int aWeek = a.isoWeekNumber;
    int bWeek = other.isoWeekNumber;

    // Compare ISO week numbers to determine if they are in the same week
    return aWeek == bWeek;
  }
}

extension DateRangeUtils on DateTimeRange? {
  /// Checks if this [DateTimeRange] is between or equal to the given [start] and [end] dates.
  ///
  /// Returns `true` if this [DateTimeRange] overlaps with the range defined by [start] and [end],
  /// inclusive of both ends. Returns `false` otherwise.
  ///
  /// If this [DateTimeRange], [start], or [end] is null, returns `false`.
  bool isBetweenOrEqual({DateTime? start, DateTime? end}) {
    if (this == null || start == null || end == null) return false;

    if (this!.start.isBeforeOrEqualTo(end) &&
        start.isBeforeOrEqualTo(this!.end)) {
      return true;
    }
    return false;
  }
}

extension StringToDate on String? {
  /// Checks whether the `String` is a valid `DateTime`:
  ///
  /// ### Valid formats
  ///
  /// * dd/mm/yyyy
  /// * dd-mm-yyyy
  /// * dd.mm.yyyy
  /// * yyyy-mm-dd
  /// * yyyy-mm-dd hrs
  /// * 20120227 13:27:00
  /// * 20120227T132700
  /// * 20120227
  /// * +20120227
  /// * 2012-02-27T14Z
  /// * 2012-02-27T14+00:00
  /// * -123450101 00:00:00 Z": in the year -12345
  /// * 2002-02-27T14:00:00-0500": Same as "2002-02-27T19:00:00Z
  bool get isDate {
    if (isBlank) return false;

    if (matches(regex: Regex.date)) return true;

    try {
      DateTime.parse(this!);
      return true;
    } on FormatException {
      return false;
    }
  }

  /// Returns the day name of the date provided in `String` format.
  ///
  /// If the date is in `DateTime` format, you can convert it to `String` `DateTime().toString()`.
  ///
  /// You can provide the [locale] to filter the result to a specific language.
  ///
  /// Defaults to 'en-US'.
  ///
  /// ### Example
  ///
  /// ```dart
  /// String date = '2021-10-23';
  /// String day = date.toDay(); // returns 'Saturday'
  /// String grDay = date.toDay(locale:'el'); // returns 'Σάββατο'
  /// ```
  String? toDay({String locale = 'en'}) {
    initializeDateFormatting(locale);
    if (isBlank) return this;

    var date = DateTime.tryParse(this!);

    if (date == null) return null;

    return DateFormat('EEEE', locale).format(date).toString();
  }

  /// Returns the month name of the date provided in `String` format.
  ///
  /// If the date is in `DateTime` format, you can convert it to `String` `DateTime().toString()`.
  ///
  /// You can provide the [locale] to filter the result to a specific language.
  ///
  /// Defaults to 'en-US'.
  ///
  /// ### Example
  ///
  /// ```dart
  /// String date = '2021-10-23';
  /// String month = date.toMonth(); // returns 'August'
  /// String grMonth = date.toMonth(locale:'el'); // returns 'Αυγούστου'
  /// ```
  String? toMonth({String locale = 'en'}) {
    initializeDateFormatting(locale);
    if (isBlank) return this;

    var date = DateTime.tryParse(this!);

    if (date == null) return null;

    return DateFormat('MMMM', locale).format(date).toString();
  }

  /// Returns the first day of the month from the provided `DateTime` in `String` format.
  ///
  /// If the date is in `DateTime` format, you can convert it to `String` `DateTime().toString()`.
  ///
  /// You can provide the [locale] to filter the result to a specific language.
  ///
  /// Defaults to 'en-US'.
  ///
  /// ### Example
  ///
  /// ```dart
  /// String date = '2021-10-23';
  /// String day = date.firstDayOfDate(); // returns 'Friday'
  /// String grDay = date.firstDayOfDate(locale:'el'); // returns 'Παρασκευή'
  /// ```
  String? firstDayOfMonth({String locale = 'en'}) {
    initializeDateFormatting(locale);

    if (isBlank) return this;

    var date = DateTime.tryParse(this!);

    if (date == null) return null;

    return DateFormat('EEEE', locale)
        .format(DateTime(date.year, date.month, 1))
        .toString();
  }

  /// Returns the last day of the month from the provided `DateTime` in `String` format.
  ///
  /// If the date is in `DateTime` format, you can convert it to `String` `DateTime().toString()`.
  ///
  /// You can provide the [locale] to filter the result to a specific language.
  ///
  /// Defaults to 'en-US'.
  ///
  /// ### Example
  ///
  /// ```dart
  /// String date = '2021-10-23';
  /// String day = date.firstDayOfDate(); // returns 'Friday'
  /// String grDay = date.firstDayOfDate(locale:'el'); // returns 'Παρασκευή'
  /// ```
  String? lastDayOfMonth({String locale = 'en'}) {
    initializeDateFormatting(locale);
    if (isBlank) return this;

    var date = DateTime.tryParse(this!);

    if (date == null) return null;

    return DateFormat('EEEE', locale)
        .format(
          DateTime(date.year, date.month + 1, 1).add(
            const Duration(days: -1),
          ),
        )
        .toString();
  }

  /// Converts the string to a [DateTime] object using [DateTime.tryParse].
  ///
  /// Returns null if the string is null or parsing fails.
  DateTime? toDate() => this != null ? DateTime.tryParse(this!) : null;

  /// Converts the string to a [TimeOfDay] object using the 'hh:mm a' format.
  ///
  /// The string must be in the format 'hh:mm a', for example, '02:30 PM'.
  ///
  /// Throws a [FormatException] if the string does not conform to the expected format.
  ///
  /// Returns a [TimeOfDay] object representing the parsed time.
  TimeOfDay? toTime() {
    if (isBlank) return null;

    final format = DateFormat.jm();
    return TimeOfDay.fromDateTime(format.parse(this!));
  }
}

extension DateIntUtils on int {
  String timeAgo({bool addAgo = true}) {
    String ago = addAgo ? 'ago' : '';

    final diff = Duration(seconds: this);
    final sec = diff.inSeconds;

    if (diff.inDays > 365) {
      return "${(diff.inDays / 365).floor()} ${(diff.inDays / 365).floor() == 1 ? "year" : "years"}${' $ago'}";
    }
    if (diff.inDays > 30) {
      return "${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1 ? "month" : "months"}${' $ago'}";
    }
    if (diff.inDays > 7) {
      return "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1 ? "week" : "weeks"}${' $ago'}";
    } else if (diff.inDays > 0) {
      return "${diff.inDays} ${diff.inDays == 1 ? "day" : "days"}${' $ago'}";
    } else if (diff.inHours > 0) {
      return "${diff.inHours} ${diff.inHours == 1 ? "hour" : "hours"}${' $ago'}";
    } else if (diff.inMinutes > 0) {
      return "${diff.inMinutes} ${diff.inMinutes == 1 ? "minute" : "minutes"}${' $ago'}";
    } else {
      return "$sec ${sec == 1 ? "second" : "seconds"}${' $ago'}";
    }
  }

  /// Converts an integer to the corresponding month's name.
  ///
  /// If [Abbreviation] is [Abbreviation.none], returns the normal form of the month's name.
  ///
  /// If [Abbreviation] is [Abbreviation.full], returns the abbreviated form of the month's name.
  ///
  /// Returns the full or abbreviated month name as a string.
  String toMonthName({Abbreviation style = Abbreviation.none}) {
    List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    List<String> shortMonths = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    return style == Abbreviation.full || style == Abbreviation.semi
        ? shortMonths[this - 1]
        : months[this - 1];
  }

  /// Converts an integer representing the day of the week (1 for Monday through 7 for Sunday)
  /// to the corresponding day's name.
  ///
  /// If [Abbreviation] is [Abbreviation.none], returns the normal form of the day's name (e.g., Monday).
  ///
  /// If [Abbreviation] is [Abbreviation.semi], returns the abbreviated form of the day's name (e.g., "Mon" for Monday).
  ///
  /// If [Abbreviation] is [Abbreviation.full], returns a very short form of the day's name (e.g., "M" for Monday).
  ///
  /// Returns the full, abbreviated, or very short day name as a string.
  ///
  /// Example:
  /// ```dart
  /// print(1.toDayName()); // Output: Monday
  /// print(1.toDayName(style: Abbreviation.semi)); // Output: Mon
  /// print(1.toDayName(style: Abbreviation.full)); // Output: M
  /// ```
  String toDayName({Abbreviation style = Abbreviation.none}) {
    List<String> days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    List<String> shortDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    List<String> veryShortDays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    if (style == Abbreviation.full) {
      return veryShortDays[this - 1];
    } else {
      return style == Abbreviation.semi ? shortDays[this - 1] : days[this - 1];
    }
  }
}

extension TimeConversions on TimeOfDay? {
  /// Checks if the [TimeOfDay] value is null.
  bool get isNull => this == null;

  /// Checks if the [TimeOfDay] value is not null.
  bool get isNotNull => !isNull;

  DateTime? toDateTime() {
    if (isNull) return null;

    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, this!.hour, this!.minute);
  }

  String? timeToString() {
    if (isNull) return null;

    final timeFormat = DateFormat.jm();
    return timeFormat.format(this!.toDateTime()!);
  }
}

extension DateTimeExtension on DateTime? {
  /// Converts the month of the [DateTime] to a string representing the month's name.
  ///
  /// If [Abbreviation] is [Abbreviation.full], returns the abbreviated form of the month's name.
  ///
  /// Returns the full or abbreviated month name as a string.
  ///
  /// Example:
  /// ```dart
  /// DateTime? date = DateTime(2024, 6, 23);
  /// print(date.toMonth()); // Output: June
  /// print(date.toMonth(style : Abbreviation.full)); // Output: Jun
  /// ```
  String toMonth({Abbreviation style = Abbreviation.none}) {
    if (this == null) return '';

    return this!.toMonth(style: style);
  }

  /// Converts the weekday of the [DateTime] to a string representing the day's name.
  ///
  /// If [Abbreviation] is [Abbreviation.none], returns the normal form of the day's name (e.g., Monday).
  ///
  /// If [Abbreviation] is [Abbreviation.semi], returns the abbreviated form of the day's name (e.g., "Mon" for Monday).
  ///
  /// If [Abbreviation] is [Abbreviation.full], returns a very short form of the day's name (e.g., "M" for Monday).
  ///
  /// Returns the full, abbreviated, or very short day name as a string.
  ///
  /// Example:
  /// ```dart
  /// DateTime? date = DateTime(2024, 6, 23);
  /// print(date.toWeekday()); // Output: Thursday
  /// print(date.toWeekday(style : Abbreviation.semi)); // Output: Thu
  /// print(date.toWeekday(style : Abbreviation.full)); // Output: T
  /// ```
  String toWeekday({Abbreviation style = Abbreviation.none}) {
    if (this == null) return '';

    return this!.toWeekday(style: style);
  }

  /// Converts the time difference to a number of seconds.
  ///
  /// Returns the number of seconds between the current DateTime instance and [other].
  /// If [other] is not provided, the current system DateTime is used.
  int countSeconds(DateTime? other) {
    int difference = (other ?? DateTime.now()).millisecondsSinceEpoch -
        (this ?? DateTime.now()).millisecondsSinceEpoch;
    int count = (difference / 1000).truncate();
    return count;
  }

  /// Converts the time difference to a number of minutes.
  ///
  /// Returns the number of minutes between the current DateTime instance and [other].
  /// If [other] is not provided, the current system DateTime is used.
  int countMinutes(DateTime? other) {
    int difference = (other ?? DateTime.now()).millisecondsSinceEpoch -
        (this ?? DateTime.now()).millisecondsSinceEpoch;
    int count = (difference / 60000).truncate();
    return count;
  }

  /// Calculates the difference in hours between the current DateTime object and [other].
  ///
  /// If [other] is null, the current DateTime object is used.
  ///
  /// Returns the difference in hours as an integer value.
  ///
  /// Example:
  /// ```dart
  /// DateTime startDateTime = DateTime(2023, 1, 1);
  /// DateTime endDateTime = DateTime(2023, 1, 2);
  ///
  /// int differenceInHours = startDateTime.countHours(endDateTime);
  /// print('Difference in hours: $differenceInHours'); // Output: 24
  /// ```
  int countHours(DateTime? other) {
    int difference = (other ?? DateTime.now()).millisecondsSinceEpoch -
        (this ?? DateTime.now()).millisecondsSinceEpoch;
    int count = (difference / 3600000).truncate();
    return count;
  }

  /// Calculates the number of days between two [DateTime] objects.
  ///
  /// The [other] parameter specifies the end date for the calculation.
  ///
  /// Returns the number of days as an integer value.
  int countDays(DateTime? other) {
    int difference = (other ?? DateTime.now()).millisecondsSinceEpoch -
        (this ?? DateTime.now()).millisecondsSinceEpoch;
    int count = (difference / 86400000).truncate();
    return count;
  }

  /// Counts the number of weeks between the current [DateTime] and the [other].
  ///
  /// Returns an integer representing the number of weeks.
  /// This function truncates to the lowest week.
  ///
  /// Example:
  /// ```dart
  /// DateTime date1 = DateTime(2023, 1, 1);
  /// DateTime date2 = DateTime(2023, 10, 16);
  /// int weeksDifference = date1.countWeeks(date2);
  /// print('Weeks difference: $weeksDifference'); // Output: Weeks difference: 41
  /// ```
  int countWeeks(DateTime? other) {
    int difference = (other ?? DateTime.now()).millisecondsSinceEpoch -
        (this ?? DateTime.now()).millisecondsSinceEpoch;
    int count = (difference / 604800000).truncate();
    return count;
  }

  /// Calculates the number of months between the current DateTime object and [other].
  ///
  /// This function rounds to the nearest month and returns the count as an integer.
  /// The result can be positive if [other] is after the current DateTime object,
  /// or negative if [other] is before the current DateTime object.
  ///
  /// Example:
  /// ```dart
  /// DateTime startDate = DateTime(1996, 1, 1);
  /// DateTime endDate = DateTime(2023, 10, 16);
  ///
  /// int monthsDifference = startDate.countMonths(endDate); // Output: 334
  /// ```
  int countMonths(DateTime? other) {
    int difference = (other ?? DateTime.now()).millisecondsSinceEpoch -
        (this ?? DateTime.now()).millisecondsSinceEpoch;
    int count = (difference / 2628003000).round();
    return count;
  }

  /// Calculates the number of years between this DateTime instance and another DateTime instance.
  ///
  /// Returns an integer representing the number of years difference.
  ///
  /// Example usage:
  /// ```dart
  /// DateTime startDate = DateTime(1996, 1, 1);
  /// DateTime endDate = DateTime(2023, 10, 16);
  ///
  /// int yearsDifference = startDate.countYears(endDate);
  /// print('Years Difference: $yearsDifference'); // Output: 27
  /// ```
  int countYears(DateTime? other) {
    int difference = (other ?? DateTime.now()).millisecondsSinceEpoch -
        (this ?? DateTime.now()).millisecondsSinceEpoch;
    int count = (difference / 31536000000).truncate();
    return count;
  }

  /// Converts the DateTime object to the UTC timezone.
  ///
  /// Returns a DateTime object in UTC timezone.
  ///
  /// If the DateTime object is null, returns null.
  ///
  /// Example:
  /// ```dart
  /// DateTime dateTime = DateTime.now();
  /// DateTime? utcDateTime = dateTime.asUtc;
  /// print('UTC DateTime: $utcDateTime');
  /// ```
  DateTime? get asUtc => isNull
      ? null
      : DateTime.utc(
          this!.year,
          this!.month,
          this!.day,
          this!.hour,
          this!.minute,
          this!.second,
        );

  /// Calculates the day of the year (1-based index) for the current date.
  ///
  /// The day of the year is calculated as the 1-based index of the current date
  /// within its year. For example, January 1st returns 1, February 1st returns 32,
  /// and December 31st returns 365 (or 366 in a leap year).
  int? get dayOfYear {
    if (this == null) return null;

    return this!.dayOfYear; // Delegate to the non-nullable extension method
  }

  /// Calculates the ISO week number for the current date.
  ///
  /// The ISO week number defines the week of the year based on the ISO 8601 standard.
  /// The week containing January 4th is considered the first week of the year (week 1).
  /// If January 4th falls on a Monday to Wednesday, the previous year's last week is considered week 53.
  /// This method handles daylight savings time and compares dates based on their UTC representation.
  int? get isoWeekNumber {
    if (this == null) return null;

    return this!.isoWeekNumber; // Delegate to the non-nullable extension method
  }

  /// Determines if this date falls within the same ISO week as [other].
  ///
  /// Dates are considered to be in the same ISO week if they have the same ISO week
  /// number within their respective years. This method handles daylight savings
  /// by comparing dates based on their UTC representation.
  ///
  /// Returns `true` if this date and [other] are in the same ISO week; otherwise, returns `false`.
  bool? isSameWeek(DateTime? other) {
    if (this == null || other == null) return null;

    return this!
        .isSameWeek(other); // Delegate to the non-nullable extension method
  }
}

extension DateTimeExtension1 on DateTime {
  String toUtcString({bool utc = true}) {
    if (utc) {
      return toUtc().toString().split('.')[0];
    }

    return toString().split('.')[0];
  }

  DateTime get nextWeek => endOfWeek.add(const Duration(days: 1)).startOfWeek;

  DateTime get previousWeek =>
      startOfWeek.subtract(const Duration(days: 1)).startOfWeek;

  bool compareWithoutTime(DateTime date) =>
      day == date.day && month == date.month && year == date.year;

  bool compareTime(DateTime date) =>
      hour == date.hour && minute == date.minute && second == date.second;

  /// Adds this DateTime and Duration and returns the sum as a new DateTime object.
  DateTime operator +(Duration duration) => add(duration);

  /// Subtracts the Duration from this DateTime returns the difference as a new DateTime object.
  DateTime operator -(Duration duration) => subtract(duration);

  /// Returns a range of dates to [to], exclusive start, inclusive end
  /// ```dart
  /// final start = DateTime(2019);
  /// final end = DateTime(2020);
  /// start.to(end, by: const Duration(days: 365)).forEach(print); // 2020-01-01 00:00:00.000
  /// ```
  Iterable<DateTime> to(DateTime to,
      {Duration by = const Duration(days: 1)}) sync* {
    if (isAtSameMomentAs(to)) return;

    if (isBefore(to)) {
      var value = this + by;
      yield value;

      var count = 1;
      while (value.isBefore(to)) {
        value = this + (by * ++count);
        yield value;
      }
    } else {
      var value = this - by;
      yield value;

      var count = 1;
      while (value.isAfter(to)) {
        value = this - (by * ++count);
        yield value;
      }
    }
  }

  /// Returns this [DateTime] clamped to be in the range [min]-[max].
  ///
  /// The comparison is done using [compareTo].
  ///
  /// The arguments [min] and [max] must form a valid range where
  /// `min.compareTo(max) <= 0`.
  ///
  /// Example:
  /// ```dart
  /// var result = DateTime(2022, DateTime.october, 15).clamp(
  ///   min: DateTime(2022, DateTime.september, 1),
  ///   max: DateTime(2022, DateTime.september, 30),
  /// ); // DateTime(2022, DateTime.september, 30);
  /// result = DateTime(2022, DateTime.august, 21).clamp(
  ///   min: DateTime(2022, DateTime.september, 15),
  ///   max: DateTime(2022, DateTime.september, 30),
  /// ); // DateTime(2022, DateTime.september, 15);
  /// result = DateTime(2022, DateTime.september, 1).clamp(
  ///   min: DateTime(2022, DateTime.august, 1),
  ///   max: DateTime(2022, DateTime.september, 30),
  /// ); // DateTime(2022, DateTime.september, 1);
  /// ```
  DateTime clamp({DateTime? min, DateTime? max}) {
    assert(
      ((min != null) && (max != null))
          ? (min.isBefore(max) || (min == max))
          : true,
      'DateTime min has to be before or equal to max\n(min: $min - max: $max)',
    );
    if ((min != null) && compareTo(min).isNegative) {
      return min;
    } else if ((max != null) && max.compareTo(this).isNegative) {
      return max;
    }
    return this;
  }

  bool get isWeekend =>
      (weekday == DateTime.saturday) || (weekday == DateTime.sunday);

  bool get isWorkday => !isWeekend;

  /// Returns the Monday of this week
  DateTime get firstDayOfWeek => isUtc
      ? DateTime.utc(year, month, day + 1 - weekday)
      : DateTime(year, month, day + 1 - weekday);

  /// Returns the Sunday of this week
  DateTime get lastDayOfWeek => isUtc
      ? DateTime.utc(year, month, day + 7 - weekday)
      : DateTime(year, month, day + 7 - weekday);

  /// Returns the first day of this month
  DateTime get firstDayOfMonth =>
      isUtc ? DateTime.utc(year, month, 1) : DateTime(year, month, 1);

  /// Returns the last day of this month (considers leap years)
  DateTime get lastDayOfMonth =>
      isUtc ? DateTime.utc(year, month + 1, 0) : DateTime(year, month + 1, 0);

  /// Returns the first day of this year
  DateTime get firstDayOfYear =>
      isUtc ? DateTime.utc(year, 1, 1) : DateTime(year, 1, 1);

  /// Returns the last day of this year
  DateTime get lastDayOfYear =>
      isUtc ? DateTime.utc(year, 12, 31) : DateTime(year, 12, 31);

  /// addDays(): Adds a specified number of days to a DateTime.
  DateTime addDays({int days = 0}) {
    return add(Duration(days: days));
  }

  /// subtractDays(): Subtracts a specified number of days from a DateTime.
  DateTime subtractDays({int days = 0}) {
    return subtract(Duration(days: days));
  }

  /// addMonths(): Adds a specified number of months to a DateTime.
  DateTime addMonths({int months = 0}) {
    return DateTime(year, month + months, day, hour, minute, second,
        millisecond, microsecond);
  }

  /// subtractMonths(): Subtracts a specified number of months from a DateTime.
  DateTime subtractMonths(int months) {
    return DateTime(year, month - months, day, hour, minute, second,
        millisecond, microsecond);
  }

  /// addYears(): Adds a specified number of years to a DateTime.
  DateTime addYears(int years) {
    return DateTime(year + years, month, day, hour, minute, second, millisecond,
        microsecond);
  }

  /// subtractYears(): Subtracts a specified number of years from a DateTime.
  DateTime subtractYears(int years) {
    return DateTime(year - years, month, day, hour, minute, second, millisecond,
        microsecond);
  }

  /// subtractSeconds(): Subtracts a specified number of seconds from a DateTime.
  DateTime subtractSeconds(int seconds) {
    return subtract(Duration(seconds: seconds));
  }

  /// addMilliseconds(): Adds a specified number of milliseconds to a DateTime.
  DateTime addMilliseconds(int milliseconds) {
    return add(Duration(milliseconds: milliseconds));
  }

  /// subtractMilliseconds(): Subtracts a specified number of milliseconds from a DateTime.
  DateTime subtractMilliseconds(int milliseconds) {
    return subtract(Duration(milliseconds: milliseconds));
  }

  /// addHours(): Adds a specified number of hours to a DateTime.
  DateTime addHours(int hours) {
    return add(Duration(hours: hours));
  }

  /// subtractHours(): Subtracts a specified number of hours from a DateTime.
  DateTime subtractHours(int hours) {
    return subtract(Duration(hours: hours));
  }

  ///addMinutes(): Adds a specified number of minutes to a DateTime.
  DateTime addMinutes(int minutes) {
    return add(Duration(minutes: minutes));
  }

  /// subtractMinutes(): Subtracts a specified number of minutes from a DateTime.
  DateTime subtractMinutes(int minutes) {
    return subtract(Duration(minutes: minutes));
  }

  int differenceInMonth({required DateTime endDate}) {
    Duration difference = this.difference(endDate);
    int months = (difference.inDays % 365) ~/ 30;

    return months;
  }

  int differenceInYear({required DateTime endDate}) {
    Duration difference = this.difference(endDate);
    int years = difference.inDays ~/ 365;

    return years;
  }

  int differenceInDays({required DateTime endDate}) {
    Duration difference = this.difference(endDate);
    int days = difference.inDays % 30;
    return days;
  }

  List<DateTime> daysInMonth() {
    var first = firstDayOfMonth;
    var daysBefore = first.weekday;
    var firstToDisplay = first.subtract(Duration(days: daysBefore));
    var last = lastDayOfMonth;

    var daysAfter = 7 - last.weekday;

    // If the last day is sunday (7) the entire week must be rendered
    if (daysAfter == 0) {
      daysAfter = 7;
    }

    var lastToDisplay = last.add(Duration(days: daysAfter));
    return firstToDisplay.daysInRange(lastToDisplay).toList();
  }

  String getGreeting() {
    int hour = this.hour;

    if (hour >= 5 && hour < 12) {
      return "Good Morning";
    } else if (hour >= 12 && hour < 17) {
      return "Good Afternoon";
    } else {
      return "Good Night";
    }
  }
}

extension DateEx on String {
  String? detectDateFormat() {
    Map<String, String> regexWithFormat = {
      r'\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}':
          "yyyy-MM-dd HH:mm:ss", // Example: 2022-01-14 12:34:56
      r'\w{3}, \w{3} \d{1,2}, \d{2}':
          "EEE, MMM d, 'yy", // Example: Fri, Jan 14, '22
      r'\w+ \d{1,2}, \d{4}': "MMMM dd, yyyy", // Example: January 14, 2022
      r'\d{2}/\d{2}/\d{4}': "MM/dd/yyyy", // Example: 01/14/2022
      r'\d{2}-\d{2}-\d{4}': "dd-MM-yyyy", // Example: 14-01-2022
      r'\d{2}:\d{2} [APap][Mm]': "hh:mm a", // Example: 12:34 PM
      r'\w+ \d{4}': "MMMM yyyy", // Example: January 2022
      r'\w{3}, \d{1,2} \w{3} \d{4}':
          "EEE, dd MMM yyyy HH:mm:ss", // Example: Fri, 14 Jan 2022 12:34:56
      r'\d{2}/\d{2}/\d{4} \d{2}:\d{2}:\d{2}':
          "dd/MM/yyyy HH:mm:ss", // Example: 14/01/2022 12:34:56
      r'\d{4}-\d{2}-\d{2}': "yyyy-MM-dd", // Example: 2022-01-14 (Date only)
      r'\d{1,2} \w{3} \d{4}': "d MMM yyyy", // Example: 22 Sep 2023
      r'\w{3}, \d{1,2} \w{3} \d{2}':
          "EEE, d MMM 'yy", // Example: Fri, 22 Sep '23
      r'\d{2}:\d{2}': "HH:mm", // Example: 12:34 (Time only)
      r'\d{1,2}/\d{1,2}/\d{2}': "M/d/yy", // Example: 9/22/23
      r'\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}':
          "yyyy-MM-ddTHH:mm:ss", // Example: 2022-01-14T12:34:56
      r'\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z':
          "yyyy-MM-ddTHH:mm:ssZ", // Example: 2022-01-14T12:34:56Z
      r'^\d{4}-\d{2}-\d{2}$': 'yyyy-MM-dd', // Example: 2022-01-14
      r'^\d{2}/\d{2}/\d{4}$': 'MM/dd/yyyy', // Example: 01/14/2022
      r'^\d{2}\.\d{2}\.\d{4}$': 'MM.dd.yyyy', // Example: 01.14.2022
      r'^\d{2}\s\d{2}\s\d{4}$': 'MM dd yyyy', // Example: 01 14 2022
      r'^\d{4}/\d{2}/\d{2}$': 'yyyy/MM/dd', // Example: 2022/01/14
      r'^\d{4}\.\d{2}\.\d{2}$': 'yyyy.MM.dd', // Example: 2022.01.14
      r'^\d{4}\s\d{2}\s\d{2}$': 'yyyy MM dd', // Example: 2022 01 14
      r'^\d{2}-\d{2}-\d{4}$': 'dd-MM-yyyy', // Example: 14-01-2022
      r'^\d{2}/\d{2}/\d{2}$': 'dd/MM/yy', // Example: 14/01/22
      r'^\d{2}\.\d{2}\.\d{2}$': 'dd.MM.yy', // Example: 14.01.22
      r'^\d{2}\s\d{2}\s\d{2}$': 'dd MM yy', // Example: 14 01 22
      r'^\d{4}-\d{1,2}-\d{1,2}$': 'yyyy-M-d', // Example: 2022-1-14
      r'^\d{2}/\d{1,2}/\d{1,2}$': 'MM/d/yy', // Example: 01/1/22
      r'^\d{2}\.\d{1,2}\.\d{1,2}$': 'MM.d.yy', // Example: 01.1.22
      r'^\d{2}\s\d{1,2}\s\d{1,2}$': 'MM d yy', // Example: 01 1 22
      r'^\d{1,2}-\d{1,2}-\d{4}$': 'd-M-yyyy', // Example: 14-1-2022
      r'^\d{1,2}/\d{1,2}/\d{4}$': 'd/M/yyyy', // Example: 14/1/2022
      r'^\d{1,2}\.\d{1,2}\.\d{4}$': 'd.M.yyyy', // Example: 14.1.2022
      r'^\d{1,2}\s\d{1,2}\s\d{4}$': 'd M yyyy', // Example: 14 1 2022
      r'^\d{1,2} \w+ \d{4}$': 'd MMMM yyyy', // Example: 29 April 1999
      r'^\d{1,2} \w{3} \d{4}$': 'dd MMM yyyy', // Example: 29 Apr 1999
      r'^\d{8}$': 'yyyyMMdd', // Example: 20220114
      r'^\d{6}$': 'yyMMdd', // Example: 220114
    };

    String? finalPattern;
    List<String> patternsFound = [];

    for (final entry in regexWithFormat.entries) {
      final regex = RegExp(entry.key);
      if (regex.hasMatch(this)) {
        // return entry.value;
        patternsFound.add(entry.value);
      }
    }
    if (patternsFound.isNotEmpty && patternsFound.length > 1) {
      for (String pattern in patternsFound) {
        bool validatePattern =
            validateDatePattern(this, expected: this, pattern: pattern);
        if (validatePattern) {
          finalPattern = pattern;
          break;
        }
      }
    } else {
      if (patternsFound.isNotEmpty) {
        finalPattern = patternsFound[0];
      }
    }

    return finalPattern;
  }

  DateTime getDateFromString({String pattern = "dd-MM-yyyy"}) {
    DateFormat dateFormat = DateFormat(pattern);

    // Parse the date string
    DateTime dateTime = dateFormat.parse(this);

    return dateTime;
  }

  bool validateDatePattern(String dateString,
      {String pattern = "yyyy-MM-dd HH:mm:ss", required String expected}) {
    try {
      DateTime dateTime = DateFormat(pattern).parse(dateString);
      String formattedDate = DateFormat(pattern).format(dateTime);
      return formattedDate == expected;
    } catch (e) {
      return false;
    }
  }

  formatServerDateTo(
      {required String uiFormat, String fallBackFormat = "dd-MM-yyyy"}) {
    String detectedDateFormat = uiFormat.detectDateFormat() ?? fallBackFormat;
    DateTime date = DateTime.parse(this);
    DateFormat outputFormat = DateFormat(detectedDateFormat);
    String result = outputFormat.format(date);
    return result;
  }
}

extension StringToDate1 on String? {
  DateTime? toDateTime({bool utc = false, String? format}) =>
      parse(this, utc: utc, format: format);

  String? toUtcString({
    bool utc = true,
    String format = 'MMM dd, yyyy h:mm a',
  }) {
    return parse(this, format: format, utc: utc)?.toString().split('.')[0];
  }

  static DateTime? parse(Object? date, {bool utc = true, String? format}) {
    String? dt = date?.toString().trim();

    try {
      if (dt == "" || (dt?.isEmpty ?? true) || dt == null) return null;

      if (utc) {
        return DateFormat(format ?? "yyyy-MM-dd HH:mm:ss")
            .parse(dt, true)
            .toLocal();
      }

      if (format != null) {
        return DateFormat(format).parse(dt, utc).toLocal();
      }

      return DateTime.tryParse(dt);
    } catch (e) {
      try {
        // if its failing it means the date format is 2024-04-17T07:20:57.573
        DateFormat format = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS");
        DateTime dateTime = format.parse(dt ?? '', utc).toLocal();

        return dateTime;
      } catch (e) {
        return null;
      }
    }
  }
}

extension DateTimeExtension2 on DateTime? {}

extension DurationTimeExtension on Duration {
  static const int daysPerWeek = 7;
  static const int nanosecondsPerMicrosecond = 1000;

  /// Returns the representation in weeks
  int get inWeeks => (inDays / daysPerWeek).ceil();

  /// Adds the Duration to the current DateTime and returns a DateTime in the future
  DateTime get fromNow => DateTime.now() + this;

  /// Subtracts the Duration from the current DateTime and returns a DateTime in the past
  DateTime get ago => DateTime.now() - this;

  /// Returns a Future.delayed from this
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

// class Interval {
//   late final DateTime _start;
//   late final Duration _duration;
//
//   Interval(DateTime start, DateTime end) {
//     if (start.isAfter(end)) {
//       throw RangeError('Invalid Range');
//     }
//     _start = start;
//     _duration = end.difference(start);
//   }
//
//   Duration get duration => _duration;
//
//   DateTime get start => _start;
//
//   DateTime get end => _start.add(_duration);
//
//   Interval setStart(DateTime val) => Interval(val, end);
//   Interval setEnd(DateTime val) => Interval(start, val);
//   Interval setDuration(Duration val) => Interval(start, start.add(duration));
//
//   bool includes(DateTime date) =>
//       (date.isAfter(start) || date.isAtSameMomentAs(start)) &&
//       (date.isBefore(end) || date.isAtSameMomentAs(end));
//
//   bool contains(Interval interval) =>
//       includes(interval.start) && includes(interval.end);
//
//   bool cross(Interval other) => includes(other.start) || includes(other.end);
//
//   bool equals(Interval other) =>
//       start.isAtSameMomentAs(other.start) && end.isAtSameMomentAs(other.end);
//
//   Interval union(Interval other) {
//     if (cross(other)) {
//       if (end.isAfter(other.start) || end.isAtSameMomentAs(other.start)) {
//         return Interval(start, other.end);
//       } else if (other.end.isAfter(start) ||
//           other.end.isAtSameMomentAs(start)) {
//         return Interval(other.start, end);
//       } else {
//         throw RangeError('Error this: $this; other: $other');
//       }
//     } else {
//       throw RangeError('Intervals don\'t cross');
//     }
//   }
//
//   Interval intersection(Interval other) {
//     if (!cross(other)) {
//       if (other.contains(this)) {
//         return this;
//       }
//
//       throw RangeError('Intervals don\'t cross');
//     }
//
//     final intersectionStart = Date.max(start, other.start);
//     final intersectionEnd = Date.min(end, other.end);
//
//     return Interval(intersectionStart, intersectionEnd);
//   }
//
//   Interval? difference(Interval other) {
//     if (other == this) {
//       return null;
//     } else if (this <= other) {
//       // | this | | other |
//       if (end.isBefore(other.start)) {
//         return this;
//       } else {
//         return Interval(start, other.start);
//       }
//     } else if (this >= other) {
//       // | other | | this |
//       if (other.end.isBefore(start)) {
//         return this;
//       } else {
//         return Interval(other.end, end);
//       }
//     } else {
//       throw RangeError('Error this: $this; other: $other');
//     }
//   }
//
//   List<Interval?> symetricDiffetence(Interval other) {
//     final list = <Interval?>[null, null];
//     try {
//       list[0] = difference(other);
//     } catch (e) {
//       list[0] = null;
//     }
//     try {
//       list[1] = other.difference(this);
//     } catch (e) {
//       list[1] = null;
//     }
//     return list;
//   }
//
//   // Operators
//   bool operator <(Interval other) => start.isBefore(other.start);
//
//   bool operator <=(Interval other) =>
//       start.isBefore(other.start) || start.isAtSameMomentAs(other.start);
//
//   bool operator >(Interval other) => end.isAfter(other.end);
//
//   bool operator >=(Interval other) =>
//       end.isAfter(other.end) || end.isAtSameMomentAs(other.end);
//
//   @override
//   String toString() => '<${start} | ${end} | ${duration} >';
// }
//
// const int MILLISECONDS_IN_WEEK = 604800000;
//
// extension Date on DateTime {
//   /// Number of seconds since epoch time / A.K.A Unix timestamp
//   ///
//   /// The Unix epoch (or Unix time or POSIX time or Unix timestamp) is the number of
//   /// seconds that have elapsed since January 1, 1970 (midnight UTC/GMT), not counting
//   /// leap seconds (in ISO 8601: 1970-01-01T00:00:00Z).
//   /// Literally speaking the epoch is Unix time 0 (midnight 1/1/1970).
//   static DateTime fromSecondsSinceEpoch(
//     int secondsSinceEpoch, {
//     bool isUtc = false,
//   }) =>
//       DateTime.fromMillisecondsSinceEpoch(
//         secondsSinceEpoch * 1000,
//         isUtc: isUtc,
//       );
//
//   /// Transforms a date that follows a pattern from a [String] representation to a [DateTime] object
//   static DateTime parse(
//     String dateString, {
//     String? pattern,
//     String locale = 'en_US',
//     bool isUTC = false,
//   }) {
//     initializeDateFormatting();
//     return pattern == null
//         ? DateTime.parse(dateString)
//         : DateFormat(pattern, locale).parse(dateString, isUTC);
//   }
//
//   /// Create a [Date] object from a Unix timestamp
//   static DateTime unix(int seconds) => fromSecondsSinceEpoch(seconds);
//
//   /// Tomorrow at same hour / minute / second than now
//   static DateTime get tomorrow => DateTime.now().nextDay;
//
//   /// Yesterday at same hour / minute / second than now
//   static DateTime get yesterday => DateTime.now().previousDay;
//
//   /// Current date (Same as [Date.now])
//   static DateTime get today => DateTime.now();
//
//   /// Get [Date] object as UTC of current object.
//   DateTime get toUTC => toUtc();
//
//   /// Get [Date] object in LocalTime of current object.
//   DateTime get toLocalTime => toLocal();
//
//   DateTime get clone => DateTime.fromMicrosecondsSinceEpoch(
//         microsecondsSinceEpoch,
//         isUtc: isUtc,
//       );
//
//   // /// Add a [Duration] to this date
//   // DateTime add(Duration duration) {
//   //   return add(duration);
//   // }
//
//   /// Substract a [Duration] to this date
//   DateTime subtract(Duration duration) => add(Duration.zero - duration);
//
//   /// Get the difference between this data and other date as a [Duration]
//   Duration diff(DateTime other) => difference(other);
//
//   /// Add a certain amount of days to this date
//   DateTime addDays(int amount, [bool ignoreDaylightSavings = false]) =>
//       ignoreDaylightSavings
//           ? DateTime(year, month, day + amount, hour, minute, second,
//               millisecond, microsecond)
//           : add(Duration(days: amount));
//
//   /// Add a certain amount of hours to this date
//   DateTime addHours(int amount, [bool ignoreDaylightSavings = false]) =>
//       ignoreDaylightSavings
//           ? DateTime(year, month, day, hour + amount, minute, second,
//               millisecond, microsecond)
//           : add(Duration(hours: amount));
//
//   // TODO: this
//   // Date addISOYears(int amount) {
//   //   return this;
//   // }
//
//   /// Add a certain amount of milliseconds to this date
//   DateTime addMilliseconds(int amount) => add(Duration(milliseconds: amount));
//
//   /// Add a certain amount of microseconds to this date
//   DateTime addMicroseconds(int amount) => add(Duration(microseconds: amount));
//
//   /// Add a certain amount of minutes to this date
//   DateTime addMinutes(int amount, [bool ignoreDaylightSavings = false]) =>
//       ignoreDaylightSavings
//           ? DateTime(year, month, day, hour, minute + amount, second,
//               millisecond, microsecond)
//           : add(Duration(minutes: amount));
//
//   /// Add a certain amount of months to this date
//   DateTime addMonths(int amount) => clone.setMonth(month + amount);
//
//   /// Add a certain amount of quarters to this date
//   DateTime addQuarters(int amount) => addMonths(amount * 3);
//
//   /// Add a certain amount of seconds to this date
//   DateTime addSeconds(int amount, [bool ignoreDaylightSavings = false]) =>
//       ignoreDaylightSavings
//           ? DateTime(year, month, day, hour, minute, second + amount,
//               millisecond, microsecond)
//           : add(Duration(seconds: amount));
//
//   /// Add a certain amount of weeks to this date
//   DateTime addWeeks(int amount) => addDays(amount * 7);
//
//   /// Add a certain amount of years to this date
//   DateTime addYears(int amount) => clone.setYear(year + amount);
//
//   /// Know if two ranges of dates overlaps
//   static bool areRangesOverlapping(
//     DateTime initialRangeStartDate,
//     DateTime initialRangeEndDate,
//     DateTime comparedRangeStartDate,
//     DateTime comparedRangeEndDate,
//   ) {
//     if (initialRangeStartDate.isAfter(initialRangeEndDate)) {
//       throw RangeError('Not valid initial range');
//     }
//
//     if (comparedRangeStartDate.isAfter(comparedRangeEndDate)) {
//       throw RangeError('Not valid compareRange range');
//     }
//
//     final initial = Interval(initialRangeStartDate, initialRangeEndDate);
//     final compared = Interval(comparedRangeStartDate, comparedRangeEndDate);
//
//     return initial.cross(compared) || compared.cross(initial);
//   }
//
//   /// Get index of the closest day to current one, returns null if empty [Iterable] is passed as argument
//   int? closestIndexTo(Iterable<DateTime> datesArray) {
//     final differences = datesArray.map((date) {
//       return date.difference(this).abs();
//     });
//
//     if (datesArray.isEmpty) {
//       return null;
//     }
//
//     var index = 0;
//     for (var i = 0; i < differences.length; i++) {
//       if (differences.elementAt(i) < differences.elementAt(index)) {
//         index = i;
//       }
//     }
//     return index;
//   }
//
//   /// Get closest day to current one, returns null if empty [Iterable] is passed as argument
//   DateTime? closestTo(Iterable<DateTime> datesArray) {
//     if (datesArray.isEmpty) {
//       return null;
//     }
//     final index = closestIndexTo(datesArray);
//     if (index == null) {
//       return null;
//     }
//
//     return datesArray.elementAt(index);
//   }
//
//   /// Compares this Date object to [other],
//   /// returning zero if the values are equal.
//   /// Returns a negative value if this Date [isBefore] [other]. It returns 0
//   /// if it [isAtSameMomentAs] [other], and returns a positive value otherwise
//   /// (when this [isAfter] [other]).
//   int compare(DateTime other) => compareTo(other);
//
//   /// Returns true if left [isBefore] than right
//   static DateTime min(DateTime left, DateTime right) =>
//       (left < right) ? left : right;
//
//   /// Returns true if left [isAfter] than right
//   static DateTime max(DateTime left, DateTime right) =>
//       (left < right) ? right : left;
//
//   /// Compare the two dates and return 1 if the first date [isAfter] the second,
//   /// -1 if the first date [isBefore] the second or 0 first date [isEqual] the second.
//   static int compareAsc(DateTime dateLeft, DateTime dateRight) {
//     if (dateLeft.isAfter(dateRight)) {
//       return 1;
//     } else if (dateLeft.isBefore(dateRight)) {
//       return -1;
//     } else {
//       return 0;
//     }
//   }
//
//   /// Compare the two dates and return -1 if the first date [isAfter] the second,
//   /// 1 if the first date [isBefore] the second or 0 first date [isEqual] the second.
//   static int compareDesc(DateTime dateLeft, DateTime dateRight) =>
//       (-1) * compareAsc(dateLeft, dateRight);
//
//   // int differenceInCalendarDays(dateLeft, dateRight)
//   // int differenceInCalendarISOWeeks(dateLeft, dateRight)
//   // int differenceInCalendarISOYears(dateLeft, dateRight)
//   // int differenceInCalendarMonths(dateLeft, dateRight)
//   // int differenceInCalendarQuarters(dateLeft, dateRight)
//   // int differenceInCalendarWeeks(dateLeft, dateRight, [options])
//   // int differenceInCalendarYears(dateLeft, dateRight)
//   // int differenceInISOYears(dateLeft, dateRight)
//
//   /// Difference in microseconds between this date and other
//   int differenceInMicroseconds(DateTime other) => diff(other).inMicroseconds;
//
//   /// Difference in milliseconds between this date and other
//   int differenceInMilliseconds(DateTime other) => diff(other).inMilliseconds;
//
//   /// Difference in minutes between this date and other
//   int differenceInMinutes(DateTime other) => diff(other).inMinutes;
//
//   /// Difference in seconds between this date and other
//   int differenceInSeconds(DateTime other) => diff(other).inSeconds;
//
//   /// Difference in hours between this date and other
//   int differenceInHours(DateTime other) => diff(other).inHours;
//
//   /// Difference in days between this date and other
//   int differenceInDays(DateTime other) => diff(other).inDays;
//
//   // int differenceInMonths(dateLeft, dateRight)
//   // int differenceInQuarters(dateLeft, dateRight)
//   // int differenceInWeeks(dateLeft, dateRight)
//   // int differenceInYears(dateLeft, dateRight)
//
//   /// Formats provided [date] to a fuzzy time like 'a moment ago' (use timeago package to change locales)
//   ///
//   /// - If [locale] is passed will look for message for that locale, if you want
//   ///   to add or override locales use [setLocaleMessages]. Defaults to 'en'
//   /// - If [clock] is passed this will be the point of reference for calculating
//   ///   the elapsed time. Defaults to DateTime.now()
//   /// - If [allowFromNow] is passed, format will use the From prefix, ie. a date
//   ///   5 minutes from now in 'en' locale will display as '5 minutes from now'
//   /// If locales was not loaded previously en would be used use timeago.setLocaleMessages to set them
//   String timeago({String? locale, DateTime? clock, bool? allowFromNow}) =>
//       timeago_lib.format(
//         this,
//         locale: locale,
//         clock: clock,
//         allowFromNow: allowFromNow ?? false,
//       );
//
//   /// Return an Iterable of dates which is inclusive to [this] but exclusive to [date]
//   Iterable<DateTime> eachDay(
//     DateTime date, {
//     bool ignoreDaylightSavings = false,
//   }) sync* {
//     if (isSameDay(date)) {
//       yield date.startOfDay;
//
//       return;
//     }
//
//     final daysDiff = differenceInDays(date);
//
//     for (var i = 0; i != daysDiff; i += daysDiff.sign) {
//       yield this.addDays(-i, ignoreDaylightSavings);
//     }
//   }
//
//   /// Return the end of a day for this date. The result will be in the local timezone.
//   DateTime get endOfDay => clone.setHour(23, 59, 59, 999, 999);
//
//   /// Return the end of the hour for this date. The result will be in the local timezone.
//   DateTime get endOfHour => clone.setMinute(59, 59, 999, 999);
//
//   /// Return the end of ISO week for this date. The result will be in the local timezone.
//   DateTime get endOfISOWeek => startOfISOWeek.addDays(6).endOfDay;
//
//   // DateTime endOfISOYear()
//
//   /// Return the end of the minute for this date. The result will be in the local timezone.
//   DateTime get endOfMinute => clone.setSecond(59, 999, 999);
//
//   /// Return the end of the month for this date. The result will be in the local timezone.
//   DateTime get endOfMonth => DateTime(year, month + 1).subMicroseconds(1);
//
//   // Date endOfQuarter()
//
//   /// Return the end of the second for this date. The result will be in the local timezone.
//   DateTime get endOfSecond => clone.setMillisecond(999, 999);
//
//   /// Return the end of today. The result will be in the local timezone.
//   static DateTime get endOfToday => DateTime.now().endOfDay;
//
//   /// Return the end of tomorrow. The result will be in the local timezone.
//   static DateTime get endOfTomorrow => DateTime.now().nextDay.endOfDay;
//
//   /// Return the end of yesterday. The result will be in the local timezone.
//   static DateTime get endOfYesterday => DateTime.now().previousDay.endOfDay;
//
//   /// Return the end of the week for this date. The result will be in the local timezone.
//   DateTime get endOfWeek => nextWeek.startOfWeek.subMicroseconds(1);
//
//   /// Return the end of the year for this date. The result will be in the local timezone.
//   DateTime get endOfYear => clone.setYear(year, DateTime.december).endOfMonth;
//
//   /// Get the day of the month of the given date.
//   /// The day of the month 1..31.
//   int get getDate => day;
//
//   /// Get the day of the week of the given date.
//   int get getDay => weekday;
//
//   /// Days since year started. The result will be in the local timezone.
//   int get getDayOfYear => diff(startOfYear).inDays + 1;
//
//   /// Days since month started. The result will be in the local timezone.
//   int get getDaysInMonth => endOfMonth.diff(startOfMonth).inDays + 1;
//
//   /// Number of days in current year
//   int get getDaysInYear => endOfYear.diff(startOfYear).inDays + 1;
//
//   /// Get the hours of the given date.
//   /// The hour of the day, expressed as in a 24-hour clock 0..23.
//   int get getHours => hour;
//
//   // int getISODay(date)
//   // int getISOYear(date)
//
//   /// Get the milliseconds of the given date.
//   /// The millisecond 0...999.
//   int get getMilliseconds => millisecond;
//
//   /// Get the microseconds of the given date.
//   /// The microsecond 0...999.
//   int get getMicroseconds => microsecond;
//
//   /// Get the milliseconds since the 'Unix epoch' 1970-01-01T00:00:00Z (UTC).
//   int get getMillisecondsSinceEpoch => millisecondsSinceEpoch;
//
//   /// Get the microseconds since the 'Unix epoch' 1970-01-01T00:00:00Z (UTC).
//   int get getMicrosecondsSinceEpoch => microsecondsSinceEpoch;
//
//   /// Get the minutes of the given date.
//   /// The minute 0...59.
//   int get getMinutes => minute;
//
//   /// Get the month of the given date.
//   /// The month 1..12.
//   int get getMonth => month;
//
//   // int getOverlappingDaysInRanges(initialRangeStartDate, initialRangeEndDate, comparedRangeStartDate, comparedRangeEndDate)
//   // int getQuarter(date)
//
//   /// Get the seconds of the given date.
//   /// The second 0...59.
//   int get getSeconds => second;
//
//   /// get the numer of milliseconds since epoch
//   int get timestamp => millisecondsSinceEpoch;
//
//   /// get the numer of milliseconds since epoch
//   int get getTime => millisecondsSinceEpoch;
//
//   /// The year
//   int get getYear => year;
//
//   /// The time zone name.
//   /// This value is provided by the operating system and may be an abbreviation or a full name.
//   /// In the browser or on Unix-like systems commonly returns abbreviations, such as 'CET' or 'CEST'.
//   /// On Windows returns the full name, for example 'Pacific Standard Time'.
//   String get getTimeZoneName => timeZoneName;
//
//   /// The time zone offset, which is the difference between local time and UTC.
//   /// The offset is positive for time zones east of UTC.
//   /// Note, that JavaScript, Python and C return the difference between UTC and local time.
//   /// Java, C# and Ruby return the difference between local time and UTC.
//   Duration get getTimeZoneOffset => timeZoneOffset;
//
//   /// The day of the week monday..sunday.
//   /// In accordance with ISO 8601 a week starts with Monday, which has the value 1.
//   int get getWeekday => weekday;
//
//   /// Get the week index
//   int get getWeek => addDays(1).getISOWeek;
//
//   /// Get the ISO week index
//   int get getISOWeek {
//     final woy = ((_ordinalDate - weekday + 10) ~/ 7);
//
//     // If the week number equals zero, it means that the given date belongs to the preceding (week-based) year.
//     if (woy == 0) {
//       // The 28th of December is always in the last week of the year
//       return DateTime(year - 1, 12, 28).getISOWeek;
//     }
//
//     // If the week number equals 53, one must check that the date is not actually in week 1 of the following year
//     if (woy == 53 &&
//         DateTime(year, 1, 1).weekday != DateTime.thursday &&
//         DateTime(year, 12, 31).weekday != DateTime.thursday) {
//       return 1;
//     }
//
//     return woy;
//   }
//
//   int get _ordinalDate {
//     const offsets = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334];
//     return offsets[month - 1] + day + (isLeapYear && month > 2 ? 1 : 0);
//   }
//
//   /// Get the local week-numbering year
//   int get getWeekYear {
//     final startOfNextYear = DateTime(year + 1).startOfWeek;
//
//     if (millisecondsSinceEpoch >= startOfNextYear.millisecondsSinceEpoch) {
//       return year + 1;
//     } else {
//       final startOfThisYear = DateTime(year).startOfWeek;
//
//       if (millisecondsSinceEpoch >= startOfThisYear.millisecondsSinceEpoch) {
//         return year;
//       } else {
//         return year - 1;
//       }
//     }
//   }
//
//   /// Return true if other [isEqual] or [isAfter] to this date
//   bool isSameOrAfter(DateTime other) => this == other || isAfter(other);
//
//   /// Return true if other [isEqual] or [isBefore] to this date
//   bool isSameOrBefore(DateTime other) => this == other || isBefore(other);
//
//   /// Check if a Object if a [DateTime], use for validation purposes
//   static bool isDate(argument) => argument is DateTime;
//
//   /// Check if a date is [equals] to other
//   bool isEqual(other) => equals(other);
//
//   /// Return true if this date day is monday
//   bool get isMonday => weekday == DateTime.monday;
//
//   /// Return true if this date day is tuesday
//   bool get isTuesday => weekday == DateTime.tuesday;
//
//   /// Return true if this date day is wednesday
//   bool get isWednesday => weekday == DateTime.wednesday;
//
//   /// Return true if this date day is thursday
//   bool get isThursday => weekday == DateTime.thursday;
//
//   /// Return true if this date day is friday
//   bool get isFriday => weekday == DateTime.friday;
//
//   /// Return true if this date day is saturday
//   bool get isSaturday => weekday == DateTime.saturday;
//
//   /// Return true if this date day is sunday
//   bool get isSunday => weekday == DateTime.sunday;
//
//   /// Is the given date the first day of a month?
//   bool get isFirstDayOfMonth => isSameDay(startOfMonth);
//
//   /// Return true if this date [isAfter] [Date.now]
//   bool get isFuture => isAfter(DateTime.now());
//
//   /// Is the given date the last day of a month?
//   bool get isLastDayOfMonth =>
//       isSameDay(nextMonth.startOfMonth.subHours(12).startOfDay);
//
//   /// Is the given date in the leap year?
//   bool get isLeapYear => year % 4 == 0 && (year % 100 != 0 || year % 400 == 0);
//
//   /// Return true if this date [isBefore] [Date.now]
//   bool get isPast => isBefore(DateTime.now());
//
//   /// Check if this date is in the same day than other
//   bool isSameDay(DateTime other) => startOfDay == other.startOfDay;
//
//   /// Check if this date is in the same hour than other
//   bool isSameHour(DateTime other) => startOfHour == other.startOfHour;
//
//   // bool isSameISOWeek(dateLeft, dateRight)
//   // bool isSameISOYear(dateLeft, dateRight)
//
//   /// Check if this date is in the same minute than other
//   bool isSameMinute(DateTime other) => startOfMinute == other.startOfMinute;
//
//   /// Check if this date is in the same month than other
//   bool isSameMonth(DateTime other) => startOfMonth == other.startOfMonth;
//
//   // bool isSameQuarter(dateLeft, dateRight)
//
//   /// Check if this date is in the same second than other
//   bool isSameSecond(DateTime other) =>
//       secondsSinceEpoch == other.secondsSinceEpoch;
//
//   // bool isSameWeek(dateLeft, dateRight, [options])
//
//   /// Check if this date is in the same year than other
//   bool isSameYear(DateTime other) => year == other.year;
//
//   /// Check if this date is in the same hour than [DateTime.now]
//   bool get isThisHour => startOfHour == today.startOfHour;
//
//   // bool isThisISOWeek()
//   // bool isThisISOYear()
//
//   /// Check if this date is in the same minute than [DateTime.now]
//   bool get isThisMinute => startOfMinute == today.startOfMinute;
//
//   /// Check if this date is in the same month than [DateTime.now]
//   bool get isThisMonth => isSameMonth(today);
//
//   // bool isThisQuarter()
//
//   /// Check if this date is in the same second than [DateTime.now]
//   bool get isThisSecond => isSameSecond(today);
//
//   // bool isThisWeek(, [options])
//
//   /// Check if this date is in the same year than [DateTime.now]
//   bool get isThisYear => isSameYear(today);
//
//   // bool isValid()
//
//   /// Check if this date is in the same day than [DateTime.today]
//   bool get isToday => isSameDay(today);
//
//   /// Check if this date is in the same day than [DateTime.tomorrow]
//   bool get isTomorrow => isSameDay(tomorrow);
//
//   /// Check if this date is in the same day than [DateTime.yesterday]
//   bool get isYesterday => isSameDay(yesterday);
//
//   /// Return true if this [DateTime] is set as UTC.
//   bool get isUTC => isUtc;
//
//   /// Return true if this [DateTime] is a saturday or a sunday
//   bool get isWeekend =>
//       weekday == DateTime.saturday || weekday == DateTime.sunday;
//
//   /// Checks if a [DateTime] is within a Rage (two dates that makes an [Interval])
//   bool isWithinRange(DateTime startDate, DateTime endDate) =>
//       Interval(startDate, endDate).includes(this);
//
//   /// Checks if a [DateTime] is within an [Interval]
//   bool isWithinInterval(Interval interval) => interval.includes(this);
//
//   // DateTime lastDayOfISOWeek(date)
//   // DateTime lastDayOfISOYear(date)
//   // DateTime lastDayOfMonth(date)
//   // DateTime lastDayOfQuarter(date)
//   // DateTime lastDayOfWeek(date, [options])
//   // DateTime lastDayOfYear(date)
//   // static DateTime max(Iterable<DateTime>)
//   // static DateTime min(Iterable<DateTime>)
//   // static DateTime parse(any)
//   // DateTime setDate(date, dayOfMonth)
//   // DateTime setDayOfYear(date, dayOfYear)
//   // DateTime setISODay(date, day)
//   // DateTime setISOWeek(date, isoWeek)
//   // DateTime setISOYear(date, isoYear)
//
//   /// Change [year] of this date
//   ///
//   /// set [month] if you want to change it as well, to skip an change other optional field set it as [null]
//   /// set [day] if you want to change it as well, to skip an change other optional field set it as [null]
//   /// set [hour] if you want to change it as well, to skip an change other optional field set it as [null]
//   /// set [minute] if you want to change it as well, to skip an change other optional field set it as [null]
//   /// set [second] if you want to change it as well, to skip an change other optional field set it as [null]
//   /// set [millisecond] if you want to change it as well, to skip an change other optional field set it as [null]
//   /// set [microsecond] if you want to change it as well
//   DateTime setYear(
//     int year, [
//     int? month,
//     int? day,
//     int? hour,
//     int? minute,
//     int? second,
//     int? millisecond,
//     int? microsecond,
//   ]) =>
//       DateTime(
//         year,
//         month ?? this.month,
//         day ?? this.day,
//         hour ?? this.hour,
//         minute ?? this.minute,
//         second ?? this.second,
//         millisecond ?? this.millisecond,
//         microsecond ?? this.microsecond,
//       );
//
//   /// Change [month] of this date
//   ///
//   /// set [day] if you want to change it as well, to skip an change other optional field set it as [null]
//   /// set [hour] if you want to change it as well, to skip an change other optional field set it as [null]
//   /// set [minute] if you want to change it as well, to skip an change other optional field set it as [null]
//   /// set [second] if you want to change it as well, to skip an change other optional field set it as [null]
//   /// set [millisecond] if you want to change it as well, to skip an change other optional field set it as [null]
//   /// set [microsecond] if you want to change it as well
//   DateTime setMonth(
//     int month, [
//     int? day,
//     int? hour,
//     int? minute,
//     int? second,
//     int? millisecond,
//     int? microsecond,
//   ]) =>
//       DateTime(
//         year,
//         month,
//         day ?? this.day,
//         hour ?? this.hour,
//         minute ?? this.minute,
//         second ?? this.second,
//         millisecond ?? this.millisecond,
//         microsecond ?? this.microsecond,
//       );
//
//   /// Change [day] of this date
//   ///
//   /// set [hour] if you want to change it as well, to skip an change other optional field set it as [null]
//   /// set [minute] if you want to change it as well, to skip an change other optional field set it as [null]
//   /// set [second] if you want to change it as well, to skip an change other optional field set it as [null]
//   /// set [millisecond] if you want to change it as well, to skip an change other optional field set it as [null]
//   /// set [microsecond] if you want to change it as well
//   DateTime setDay(
//     int day, [
//     int? hour,
//     int? minute,
//     int? second,
//     int? millisecond,
//     int? microsecond,
//   ]) =>
//       DateTime(
//         year,
//         month,
//         day,
//         hour ?? this.hour,
//         minute ?? this.minute,
//         second ?? this.second,
//         millisecond ?? this.millisecond,
//         microsecond ?? this.microsecond,
//       );
//
//   /// Change [weekday] of this date
//   ///
//   /// set [weekStartsOn] if you want to use any other day as the start of the week
//   DateTime setWeekDay(int weekday, [int weekStartsOn = DateTime.sunday]) {
//     const daysPerWeek = DateTime.daysPerWeek;
//     final currentDay = this.weekday;
//     final reminder = weekday % daysPerWeek;
//     final dayIndex = (reminder + daysPerWeek) % daysPerWeek;
//     final delta = daysPerWeek - weekStartsOn;
//     final diff = weekday < 0 || weekday > 6
//         ? weekday - ((currentDay + delta) % daysPerWeek)
//         : ((dayIndex + delta) % daysPerWeek) -
//             ((currentDay + delta) % daysPerWeek);
//
//     return addDays(diff);
//   }
//
//   /// Change [hour] of this date
//   ///
//   /// set [minute] if you want to change it as well, to skip an change other optional field set it as [null]
//   /// set [second] if you want to change it as well, to skip an change other optional field set it as [null]
//   /// set [millisecond] if you want to change it as well, to skip an change other optional field set it as [null]
//   /// set [microsecond] if you want to change it as well
//   DateTime setHour(
//     int hour, [
//     int? minute,
//     int? second,
//     int? millisecond,
//     int? microsecond,
//   ]) =>
//       DateTime(
//         year,
//         month,
//         day,
//         hour,
//         minute ?? this.minute,
//         second ?? this.second,
//         millisecond ?? this.millisecond,
//         microsecond ?? this.microsecond,
//       );
//
//   /// Change [minute] of this date
//   ///
//   /// set [second] if you want to change it as well, to skip an change other optional field set it as [null]
//   /// set [millisecond] if you want to change it as well, to skip an change other optional field set it as [null]
//   /// set [microsecond] if you want to change it as well
//   DateTime setMinute(
//     int minute, [
//     int? second,
//     int? millisecond,
//     int? microsecond,
//   ]) =>
//       DateTime(
//         year,
//         month,
//         day,
//         hour,
//         minute,
//         second ?? this.second,
//         millisecond ?? this.millisecond,
//         microsecond ?? this.microsecond,
//       );
//
//   /// Change [second] of this date
//   ///
//   /// set [millisecond] if you want to change it as well, to skip an change other optional field set it as [null]
//   /// set [microsecond] if you want to change it as well
//   DateTime setSecond(
//     int second, [
//     int? millisecond,
//     int? microsecond,
//   ]) =>
//       DateTime(
//         year,
//         month,
//         day,
//         hour,
//         minute,
//         second,
//         millisecond ?? this.millisecond,
//         microsecond ?? this.microsecond,
//       );
//
//   /// Change [millisecond] of this date
//   ///
//   /// set [microsecond] if you want to change it as well
//   DateTime setMillisecond(
//     int millisecond, [
//     int? microsecond,
//   ]) =>
//       DateTime(
//         year,
//         month,
//         day,
//         hour,
//         minute,
//         second,
//         millisecond,
//         microsecond ?? this.microsecond,
//       );
//
//   /// Change [microsecond] of this date
//   DateTime setMicrosecond(
//     int microsecond,
//   ) =>
//       DateTime(
//         year,
//         month,
//         day,
//         hour,
//         minute,
//         second,
//         millisecond,
//         microsecond,
//       );
//
//   // DateTime setQuarter(quarter)
//
//   /// Get a [DateTime] representing start of Day of this [DateTime] in local time.
//   DateTime get startOfDay => clone.setHour(0, 0, 0, 0, 0);
//
//   /// Get a [DateTime] representing start of Hour of this [DateTime] in local time.
//   DateTime get startOfHour => clone.setMinute(0, 0, 0, 0);
//
//   /// Get a [DateTime] representing start of week (ISO week) of this [DateTime] in local time.
//   DateTime get startOfISOWeek => subDays(weekday - 1).startOfDay;
//
//   // DateTime startOfISOYear()
//
//   /// Get a [DateTime] representing start of minute of this [DateTime] in local time.
//   DateTime get startOfMinute => clone.setSecond(0, 0, 0);
//
//   /// Get a [DateTime] representing start of month of this [DateTime] in local time.
//   DateTime get startOfMonth => clone.setDay(1, 0, 0, 0, 0, 0);
//
//   // DateTime startOfQuarter()
//   /// Get a [DateTime] representing start of second of this [DateTime] in local time.
//   DateTime get startOfSecond => clone.setMillisecond(0, 0);
//
//   /// Get a [DateTime] representing start of today of [DateTime.today] in local time.
//   static DateTime get startOfToday => today.startOfDay;
//
//   /// Get a [DateTime] representing start of week of this [DateTime] in local time.
//   DateTime get startOfWeek =>
//       weekday == DateTime.sunday ? startOfDay : subDays(weekday).startOfDay;
//
//   /// Get a [DateTime] representing start of year of this [DateTime] in local time.
//   DateTime get startOfYear =>
//       clone.setMonth(DateTime.january, 1, 0, 0, 0, 0, 0);
//
//   /// Get the start of a local week-numbering year
//   DateTime get startOfWeekYear => startOfYear.startOfWeek;
//
//   /// Get the start of a local week-numbering year
//   DateTime get startOfISOWeekYear => startOfYear.startOfISOWeek;
//
//   /// Get the number of weeks in an ISO week-numbering year
//   int get getISOWeeksInYear {
//     return DateTime(year, 12, 28).getISOWeek;
//   }
//
//   /// Subtracts a [Duration] from this [DateTime]
//   DateTime sub(Duration duration) => add(Duration.zero - duration);
//
//   /// Subtracts an amout of hours from this [DateTime]
//   DateTime subHours(int amount) => addHours(-amount);
//
//   /// Subtracts an amout of days from this [DateTime]
//   DateTime subDays(int amount) => addDays(-amount);
//
//   /// Subtracts an amout of milliseconds from this [DateTime]
//   DateTime subMilliseconds(amount) => addMilliseconds(-amount);
//
//   /// Subtracts an amout of microseconds from this [DateTime]
//   DateTime subMicroseconds(amount) => addMicroseconds(-amount);
//
//   // DateTime subISOYears(amount)
//   /// Subtracts an amout of minutes from this [DateTime]
//   DateTime subMinutes(amount) => addMinutes(-amount);
//
//   /// Subtracts an amout of months from this [DateTime]
//   DateTime subMonths(amount) => addMonths(-amount);
//
//   // DateTime subQuarters(amount)
//   /// Subtracts an amout of seconds from this [DateTime]
//   DateTime subSeconds(amount) => addSeconds(-amount);
//
//   // DateTime subWeeks(amount)
//   /// Subtracts an amout of years from this [DateTime]
//   DateTime subYears(amount) => addYears(-amount);
//
//   // Check if two dates are [equals]
//   bool equals(DateTime other) => isAtSameMomentAs(other);
//
//   bool operator <(DateTime other) => isBefore(other);
//
//   bool operator <=(DateTime other) =>
//       isBefore(other) || isAtSameMomentAs(other);
//
//   bool operator >(DateTime other) => isAfter(other);
//
//   bool operator >=(DateTime other) => isAfter(other) || isAtSameMomentAs(other);
//
//   String toHumanString() => format('E MMM d y H:m:s');
//
//   /// The day after
//   /// The day after this [DateTime]
//   DateTime get nextDay => addDays(1);
//
//   /// The day previous this [DateTime]
//   DateTime get previousDay => addDays(-1);
//
//   /// The month after this [DateTime]
//   DateTime get nextMonth => clone.setMonth(month + 1);
//
//   /// The month previous this [DateTime]
//   DateTime get previousMonth => clone.setMonth(month - 1);
//
//   /// The year after this [DateTime]
//   DateTime get nextYear => clone.setYear(year + 1);
//
//   /// The year previous this [DateTime]
//   DateTime get previousYear => clone.setYear(year - 1);
//
//   /// The week after this [DateTime]
//   DateTime get nextWeek => addDays(7);
//
//   /// The week previous this [DateTime]
//   DateTime get previousWeek => subDays(7);
//
//   /// Number of seconds since epoch time
//   ///
//   /// The Unix epoch (or Unix time or POSIX time or Unix timestamp) is the number of
//   /// seconds that have elapsed since January 1, 1970 (midnight UTC/GMT), not counting
//   /// leap seconds (in ISO 8601: 1970-01-01T00:00:00Z).
//   /// Literally speaking the epoch is Unix time 0 (midnight 1/1/1970).
//   int get secondsSinceEpoch => millisecondsSinceEpoch ~/ 1000;
//
//   /// Format this [DateTime] following the [String pattern]
//   ///
//   ///      ICU Name                   Skeleton
//   ///      --------                   --------
//   ///      DAY                          d
//   ///      ABBR_WEEKDAY                 E
//   ///      WEEKDAY                      EEEE
//   ///      ABBR_STANDALONE_MONTH        LLL
//   ///      STANDALONE_MONTH             LLLL
//   ///      NUM_MONTH                    M
//   ///      NUM_MONTH_DAY                Md
//   ///      NUM_MONTH_WEEKDAY_DAY        MEd
//   ///      ABBR_MONTH                   MMM
//   ///      ABBR_MONTH_DAY               MMMd
//   ///      ABBR_MONTH_WEEKDAY_DAY       MMMEd
//   ///      MONTH                        MMMM
//   ///      MONTH_DAY                    MMMMd
//   ///      MONTH_WEEKDAY_DAY            MMMMEEEEd
//   ///      ABBR_QUARTER                 QQQ
//   ///      QUARTER                      QQQQ
//   ///      YEAR                         y
//   ///      YEAR_NUM_MONTH               yM
//   ///      YEAR_NUM_MONTH_DAY           yMd
//   ///      YEAR_NUM_MONTH_WEEKDAY_DAY   yMEd
//   ///      YEAR_ABBR_MONTH              yMMM
//   ///      YEAR_ABBR_MONTH_DAY          yMMMd
//   ///      YEAR_ABBR_MONTH_WEEKDAY_DAY  yMMMEd
//   ///      YEAR_MONTH                   yMMMM
//   ///      YEAR_MONTH_DAY               yMMMMd
//   ///      YEAR_MONTH_WEEKDAY_DAY       yMMMMEEEEd
//   ///      YEAR_ABBR_QUARTER            yQQQ
//   ///      YEAR_QUARTER                 yQQQQ
//   ///      HOUR24                       H
//   ///      HOUR24_MINUTE                Hm
//   ///      HOUR24_MINUTE_SECOND         Hms
//   ///      HOUR                         j
//   ///      HOUR_MINUTE                  jm
//   ///      HOUR_MINUTE_SECOND           jms
//   ///      HOUR_MINUTE_GENERIC_TZ       jmv
//   ///      HOUR_MINUTE_TZ               jmz
//   ///      HOUR_GENERIC_TZ              jv
//   ///      HOUR_TZ                      jz
//   ///      MINUTE                       m
//   ///      MINUTE_SECOND                ms
//   ///      SECOND                       s
//   /// Examples Using the US Locale:
//   ///
//   ///      Pattern                           Result
//   ///      ----------------                  -------
//   ///      new DateFormat.yMd()             -> 7/10/1996
//   ///      new DateFormat('yMd')            -> 7/10/1996
//   ///      new DateFormat.yMMMMd('en_US')   -> July 10, 1996
//   ///      new DateFormat.jm()              -> 5:08 PM
//   ///      new DateFormat.yMd().add_jm()    -> 7/10/1996 5:08 PM
//   ///      new DateFormat.Hm()              -> 17:08 // force 24 hour time
//   ///
//   /// Explicit patterns
//   ///
//   ///     Symbol   Meaning                Presentation       Example
//   ///     ------   -------                ------------       -------
//   ///     G        era designator         (Text)             AD
//   ///     y        year                   (Number)           1996
//   ///     M        month in year          (Text & Number)    July & 07
//   ///     L        standalone month       (Text & Number)    July & 07
//   ///     d        day in month           (Number)           10
//   ///     c        standalone day         (Number)           10
//   ///     h        hour in am/pm (1~12)   (Number)           12
//   ///     H        hour in day (0~23)     (Number)           0
//   ///     m        minute in hour         (Number)           30
//   ///     s        second in minute       (Number)           55
//   ///     S        fractional second      (Number)           978
//   ///     E        day of week            (Text)             Tuesday
//   ///     D        day in year            (Number)           189
//   ///     a        am/pm marker           (Text)             PM
//   ///     k        hour in day (1~24)     (Number)           24
//   ///     K        hour in am/pm (0~11)   (Number)           0
//   ///     z        time zone              (Text)             Pacific Standard Time
//   ///     Z        time zone (RFC 822)    (Number)           -0800
//   ///     v        time zone (generic)    (Text)             Pacific Time
//   ///     Q        quarter                (Text)             Q3
//   ///     '        escape for text        (Delimiter)        'DateTime='
//   ///     ''       single quote           (Literal)          'o''clock'
//   ///
//   String format(String pattern, [String locale = 'en_US']) {
//     initializeDateFormatting();
//     return DateFormat(pattern, locale).format(this);
//   }
//
//   /// Get UTC [DateTime] from this [DateTime]
//   DateTime get utc => DateTime.fromMicrosecondsSinceEpoch(
//         microsecondsSinceEpoch,
//         isUtc: true,
//       );
//
//   /// Get Local [DateTime] from this [DateTime]
//   DateTime get local => DateTime.fromMicrosecondsSinceEpoch(
//         microsecondsSinceEpoch,
//         isUtc: false,
//       );
//
//   DateTime operator -(Duration other) {
//     return this.subtract(other);
//   }
//
//   DateTime operator +(Duration other) {
//     return add(other);
//   }
// }
//
// extension DurationExtension on Duration {
//   Duration operator -(Duration other) {
//     return Duration(microseconds: inMicroseconds - other.inMicroseconds);
//   }
//
//   Duration operator +(Duration other) {
//     return Duration(microseconds: inMicroseconds + other.inMicroseconds);
//   }
//
//   Duration operator *(num other) {
//     return Duration(microseconds: (inMicroseconds * other).round());
//   }
//
//   Duration operator /(num other) {
//     return Duration(microseconds: (inMicroseconds / other).round());
//   }
// }

///

// extension DateTimeExtension3 on DateTime {
//   /// Returns a new [Date] with given amount of days added to [this].
//   /// [days] can be negative, in this case subtraction will happen.
//   Date operator +(final int days) => addDays(days);
//
//   /// Returns a new [Date] with given amount of days subtracted from [this].
//   /// [days] can be negative, in this case addition will happen.
//   Date operator -(final int days) => subtractDays(days);
//
//   @override
//   bool operator ==(final dynamic other) =>
//       other is Date &&
//       other.day == _date.day &&
//       other.month == _date.month &&
//       other.year == _date.year;
//
//   /// Checks if [this] is after [other].
//   bool operator >(final Date other) => _date.isAfter(other.toDateTime());
//
//   /// Checks if [this] is before [other].
//   bool operator <(final Date other) => _date.isBefore(other.toDateTime());
//
//   /// Checks if [this] is after or at the same day as [other].
//   bool operator >=(final Date other) => this == other || this > other;
//
//   /// Checks if [this] is before or at the same day as [other].
//   bool operator <=(final Date other) => this == other || this < other;
//
//   /// Checks if [this] is before [other].
//   bool isBefore(final Date other) => this < other;
//
//   /// Checks if [this] is after [other].
//   bool isAfter(final Date other) => this > other;
//
//   /// Checks if [this] is the same date as [other].
//   bool isTheSameDate(final Date other) => _date.isTheSameDate(other);
//
//   /// Returns today's date.
//   DateTime today() => DateTime.now();
//
//   /// Returns tomorrow's date.
//   DateTime tomorrow() =>
//       _date = _truncateTimeOfDay(DateTime.now().add(const Duration(days: 1)));
//
//   /// Returns yesterday's date.
//   DateTime yesterday() => _date =
//       _truncateTimeOfDay(DateTime.now().subtract(const Duration(days: 1)));

//
// Get rid of the given [DateTime]'s time of day data, leaving it all zeroes.
// static DateTime _truncateTimeOfDay(final DateTime dateTime) => DateTime(dateTime.year, dateTime.month, dateTime.day);
// }

///

// enum DayOfWeek {
//   sunday,
//   monday,
//   tuesday,
//   wednesday,
//   thursday,
//   friday,
//   saturday,
// }
//
// /// Main class
// class CalendarTime {
//   late DateTime _date;
//
//   // Get the dateTime object used by this CalendarTime
//   DateTime get toDate => _date;
//
//   /// Adds a duration to the current DateTime
//   ///
//   DateTime add(Duration duration) => _date.add(duration);
//
//   /// Subtract a duration from the current DateTime
//   ///
//   DateTime subtract(Duration duration) => _date.subtract(duration);
//
//   /// Returns this DateTime value in the local time zone.
//   ///
//   /// Returns [this] if it is already in the local time zone.
//   ///
//   DateTime get dateLocal => _date.toLocal();
//
//   /// Specify the format for times when outputting
//   /// Specify it as [DateFormat.<skeleton>]
//   ///
//   ///      ICU Name                   Skeleton
//   ///      --------                   --------
//   ///      DAY                          d
//   ///      ABBR_WEEKDAY                 E
//   ///      WEEKDAY                      EEEE
//   ///      ABBR_STANDALONE_MONTH        LLL
//   ///      STANDALONE_MONTH             LLLL
//   ///      NUM_MONTH                    M
//   ///      NUM_MONTH_DAY                Md
//   ///      NUM_MONTH_WEEKDAY_DAY        MEd
//   ///      ABBR_MONTH                   MMM
//   ///      ABBR_MONTH_DAY               MMMd
//   ///      ABBR_MONTH_WEEKDAY_DAY       MMMEd
//   ///      MONTH                        MMMM
//   ///      MONTH_DAY                    MMMMd
//   ///      MONTH_WEEKDAY_DAY            MMMMEEEEd
//   ///      ABBR_QUARTER                 QQQ
//   ///      QUARTER                      QQQQ
//   ///      YEAR                         y
//   ///      YEAR_NUM_MONTH               yM
//   ///      YEAR_NUM_MONTH_DAY           yMd
//   ///      YEAR_NUM_MONTH_WEEKDAY_DAY   yMEd
//   ///      YEAR_ABBR_MONTH              yMMM
//   ///      YEAR_ABBR_MONTH_DAY          yMMMd
//   ///      YEAR_ABBR_MONTH_WEEKDAY_DAY  yMMMEd
//   ///      YEAR_MONTH                   yMMMM
//   ///      YEAR_MONTH_DAY               yMMMMd
//   ///      YEAR_MONTH_WEEKDAY_DAY       yMMMMEEEEd
//   ///      YEAR_ABBR_QUARTER            yQQQ
//   ///      YEAR_QUARTER                 yQQQQ
//   ///      HOUR24                       H
//   ///      HOUR24_MINUTE                Hm
//   ///      HOUR24_MINUTE_SECOND         Hms
//   ///      HOUR                         j
//   ///      HOUR_MINUTE                  jm
//   ///      HOUR_MINUTE_SECOND           jms
//   ///      HOUR_MINUTE_GENERIC_TZ       jmv
//   ///      HOUR_MINUTE_TZ               jmz
//   ///      HOUR_GENERIC_TZ              jv
//   ///      HOUR_TZ                      jz
//   ///      MINUTE                       m
//   ///      MINUTE_SECOND                ms
//   ///      SECOND                       s
//   DateFormat timeFormat = DateFormat.jm();
//
//   /// Specify the format used for the date portion of any formatting
//   /// Use the format [DateFormat.<skeleton>]
//   ///
//   ///      ICU Name                   Skeleton
//   ///      --------                   --------
//   ///      DAY                          d
//   ///      ABBR_WEEKDAY                 E
//   ///      WEEKDAY                      EEEE
//   ///      ABBR_STANDALONE_MONTH        LLL
//   ///      STANDALONE_MONTH             LLLL
//   ///      NUM_MONTH                    M
//   ///      NUM_MONTH_DAY                Md
//   ///      NUM_MONTH_WEEKDAY_DAY        MEd
//   ///      ABBR_MONTH                   MMM
//   ///      ABBR_MONTH_DAY               MMMd
//   ///      ABBR_MONTH_WEEKDAY_DAY       MMMEd
//   ///      MONTH                        MMMM
//   ///      MONTH_DAY                    MMMMd
//   ///      MONTH_WEEKDAY_DAY            MMMMEEEEd
//   ///      ABBR_QUARTER                 QQQ
//   ///      QUARTER                      QQQQ
//   ///      YEAR                         y
//   ///      YEAR_NUM_MONTH               yM
//   ///      YEAR_NUM_MONTH_DAY           yMd
//   ///      YEAR_NUM_MONTH_WEEKDAY_DAY   yMEd
//   ///      YEAR_ABBR_MONTH              yMMM
//   ///      YEAR_ABBR_MONTH_DAY          yMMMd
//   ///      YEAR_ABBR_MONTH_WEEKDAY_DAY  yMMMEd
//   ///      YEAR_MONTH                   yMMMM
//   ///      YEAR_MONTH_DAY               yMMMMd
//   ///      YEAR_MONTH_WEEKDAY_DAY       yMMMMEEEEd
//   ///      YEAR_ABBR_QUARTER            yQQQ
//   ///      YEAR_QUARTER                 yQQQQ
//   ///      HOUR24                       H
//   ///      HOUR24_MINUTE                Hm
//   ///      HOUR24_MINUTE_SECOND         Hms
//   ///      HOUR                         j
//   ///      HOUR_MINUTE                  jm
//   ///      HOUR_MINUTE_SECOND           jms
//   ///      HOUR_MINUTE_GENERIC_TZ       jmv
//   ///      HOUR_MINUTE_TZ               jmz
//   ///      HOUR_GENERIC_TZ              jv
//   ///      HOUR_TZ                      jz
//   ///      MINUTE                       m
//   ///      MINUTE_SECOND                ms
//   ///      SECOND                       s
//   DateFormat dayFormat = DateFormat.EEEE();
//
//   /// Specify the format when outputting a full date
//   /// Use the format [DateFormat.<skeleton>]
//   ///
//   ///      ICU Name                   Skeleton
//   ///      --------                   --------
//   ///      DAY                          d
//   ///      ABBR_WEEKDAY                 E
//   ///      WEEKDAY                      EEEE
//   ///      ABBR_STANDALONE_MONTH        LLL
//   ///      STANDALONE_MONTH             LLLL
//   ///      NUM_MONTH                    M
//   ///      NUM_MONTH_DAY                Md
//   ///      NUM_MONTH_WEEKDAY_DAY        MEd
//   ///      ABBR_MONTH                   MMM
//   ///      ABBR_MONTH_DAY               MMMd
//   ///      ABBR_MONTH_WEEKDAY_DAY       MMMEd
//   ///      MONTH                        MMMM
//   ///      MONTH_DAY                    MMMMd
//   ///      MONTH_WEEKDAY_DAY            MMMMEEEEd
//   ///      ABBR_QUARTER                 QQQ
//   ///      QUARTER                      QQQQ
//   ///      YEAR                         y
//   ///      YEAR_NUM_MONTH               yM
//   ///      YEAR_NUM_MONTH_DAY           yMd
//   ///      YEAR_NUM_MONTH_WEEKDAY_DAY   yMEd
//   ///      YEAR_ABBR_MONTH              yMMM
//   ///      YEAR_ABBR_MONTH_DAY          yMMMd
//   ///      YEAR_ABBR_MONTH_WEEKDAY_DAY  yMMMEd
//   ///      YEAR_MONTH                   yMMMM
//   ///      YEAR_MONTH_DAY               yMMMMd
//   ///      YEAR_MONTH_WEEKDAY_DAY       yMMMMEEEEd
//   ///      YEAR_ABBR_QUARTER            yQQQ
//   ///      YEAR_QUARTER                 yQQQQ
//   ///      HOUR24                       H
//   ///      HOUR24_MINUTE                Hm
//   ///      HOUR24_MINUTE_SECOND         Hms
//   ///      HOUR                         j
//   ///      HOUR_MINUTE                  jm
//   ///      HOUR_MINUTE_SECOND           jms
//   ///      HOUR_MINUTE_GENERIC_TZ       jmv
//   ///      HOUR_MINUTE_TZ               jmz
//   ///      HOUR_GENERIC_TZ              jv
//   ///      HOUR_TZ                      jz
//   ///      MINUTE                       m
//   ///      MINUTE_SECOND                ms
//   ///      SECOND                       s
//   DateFormat fullDayFormat = DateFormat.yMMMEd().add_jm();
//
//   /// Create a calendar time object by passing in a date
//   /// Not passing in a date will create a CalendarTime at the present date
//   ///
//   CalendarTime([_date]) {
//     this._date = _date ??= DateTime.now();
//   }
//
//   /// Convert the date into a human readable representation of a time
//   /// For example if a datetime is today at 4:30 it will return "Today at 4:30pm"
//   ///
//   String get toHuman {
//     final String time = formatTime;
//     final String day = dayFormat.format(dateLocal);
//     final String fullDate = DateFormat.yMMMEd().format(dateLocal);
//     final String fullTime = DateFormat.jm().format(dateLocal);
//     final String fullDateTime = "$fullDate $fullTime";
//
//     if (isToday) {
//       return 'Today at $time';
//     } else if (isTomorrow) {
//       return 'Tomorrow at $time';
//     } else if (isNextWeek) {
//       return '$day at $time';
//     } else if (isYesterday) {
//       return 'Yesterday at $time';
//     } else if (isLastWeek) {
//       return 'Last $day at $time';
//     } else {
//       return fullDateTime;
//     }
//   }
//
//   /// Will return the date in format specified in [CalendarTime.timeformat]
//   ///
//   String get formatTime {
//     return timeFormat.format(dateLocal);
//   }
//
//   /// Format the date in a string given a format string.
//   ///
//   /// Explicit Pattern Syntax: Formats can also be specified with a pattern
//   /// string.  This can be used for formats that don't have a skeleton available,
//   /// but these will not adapt to different locales. For example, in an explicit
//   /// pattern the letters 'H' and 'h' are available for 24 hour and 12 hour time
//   /// formats respectively. But there isn't a way in an explicit pattern to get
//   /// the behaviour of the 'j' skeleton, which prints 24 hour or 12 hour time
//   /// according to the conventions of the locale, and also includes am/pm markers
//   /// where appropriate. So it is preferable to use the skeletons.
//   ///
//   /// The following characters are available in explicit patterns:
//   ///
//   ///     Symbol   Meaning                Presentation       Example
//   ///     ------   -------                ------------       -------
//   ///     G        era designator         (Text)             AD
//   ///     y        year                   (Number)           1996
//   ///     M        month in year          (Text & Number)    July & 07
//   ///     L        standalone month       (Text & Number)    July & 07
//   ///     d        day in month           (Number)           10
//   ///     c        standalone day         (Number)           10
//   ///     h        hour in am/pm (1~12)   (Number)           12
//   ///     H        hour in day (0~23)     (Number)           0
//   ///     m        minute in hour         (Number)           30
//   ///     s        second in minute       (Number)           55
//   ///     S        fractional second      (Number)           978
//   ///     E        day of week            (Text)             Tuesday
//   ///     D        day in year            (Number)           189
//   ///     a        am/pm marker           (Text)             PM
//   ///     k        hour in day (1~24)     (Number)           24
//   ///     K        hour in am/pm (0~11)   (Number)           0
//   ///     z        time zone              (Text)             Pacific Standard Time
//   ///     Z        time zone (RFC 822)    (Number)           -0800
//   ///     v        time zone (generic)    (Text)             Pacific Time
//   ///     Q        quarter                (Text)             Q3
//   ///     '        escape for text        (Delimiter)        'Date='
//   ///     ''       single quote           (Literal)          'o''clock'
//   ///
//   /// The count of pattern letters determine the format.
//   ///
//   /// **Text**:
//   /// * 5 pattern letters--use narrow form for standalone. Otherwise not used.
//   /// * 4 or more pattern letters--use full form,
//   /// * 3 pattern letters--use short or abbreviated form if one exists
//   /// * less than 3--use numeric form if one exists
//   ///
//   /// **Number**: the minimum number of digits. Shorter numbers are zero-padded to
//   /// this amount (e.g. if 'm' produces '6', 'mm' produces '06'). Year is handled
//   /// specially; that is, if the count of 'y' is 2, the Year will be truncated to
//   /// 2 digits. (e.g., if 'yyyy' produces '1997', 'yy' produces '97'.) Unlike
//   /// other fields, fractional seconds are padded on the right with zero.
//   ///
//   /// **(Text & Number)**: 3 or over, use text, otherwise use number.
//   ///
//   /// Any characters not in the pattern will be treated as quoted text. For
//   /// instance, characters like ':', '.', ' ', '#' and '@' will appear in the
//   /// resulting text even though they are not enclosed in single quotes. In our
//   /// current pattern usage, not all letters have meanings. But those unused
//   /// letters are strongly discouraged to be used as quoted text without quotes,
//   /// because we may use other letters as pattern characters in the future.
//   ///
//   /// Examples Using the US Locale:
//   ///
//   ///     Format Pattern                    Result
//   ///     --------------                    -------
//   ///     'yyyy.MM.dd G 'at' HH:mm:ss vvvv' 1996.07.10 AD at 15:08:56 Pacific Time
//   ///     'EEE, MMM d, ''yy'                Wed, Jul 10, '96
//   ///     'h:mm a'                          12:08 PM
//   ///     'hh 'o''clock' a, zzzz'           12 o'clock PM, Pacific Daylight Time
//   ///     'K:mm a, vvv'                     0:00 PM, PT
//   ///     'yyyyy.MMMMM.dd GGG hh:mm aaa'    01996.July.10 AD 12:08 PM
//   ///
//   /// When parsing a date string using the abbreviated year pattern ('yy'),
//   /// DateFormat must interpret the abbreviated year relative to some
//   /// century. It does this by adjusting dates to be within 80 years before and 20
//   /// years after the time the parse function is called. For example, using a
//   /// pattern of 'MM/dd/yy' and a DateParse instance created on Jan 1, 1997,
//   /// the string '01/11/12' would be interpreted as Jan 11, 2012 while the string
//   /// '05/04/64' would be interpreted as May 4, 1964. During parsing, only
//   /// strings consisting of exactly two digits will be parsed into the default
//   /// century. Any other numeric string, such as a one digit string, a three or
//   /// more digit string will be interpreted as its face value.
//   ///
//   /// If the year pattern does not have exactly two 'y' characters, the year is
//   /// interpreted literally, regardless of the number of digits. So using the
//   /// pattern 'MM/dd/yyyy', '01/11/12' parses to Jan 11, 12 A.D.
//   String format(String formatString) {
//     return DateFormat(formatString).format(dateLocal);
//   }
//
//   ///The same as calling [toHuman] except it breaks down the result into multiple
//   ///lines for a vertical display
//   ///
//   /// ie. `Today at 4:30pm` is formatted as
//   ///
//   /// Today
//   ///  at
//   /// 4:30pm
//   String get toHumanMultiLine {
//     return toHuman.split(" at ").join("\n");
//   }
//
//   ///The same as calling [toHuman] except it breaks down the result into array
//   ///[0] is date, [1] is time
//   List<String> get toHumanArray {
//     return toHuman.split(" at ");
//   }
//
//   /// Boolean check to see if the current date is today
//   ///
//   bool get isToday {
//     if (dateLocal.isAfter(startOfToday) && dateLocal.isBefore(endOfToday)) {
//       return true;
//     }
//     return false;
//   }
//
//   /// Boolean to check if the current date is tomororw
//   ///
//   bool get isTomorrow {
//     if (dateLocal.isAfter(endOfToday) && dateLocal.isBefore(endOfTomorrow)) {
//       return true;
//     }
//     return false;
//   }
//
//   /// Boolean check to see if the current date is next week
//   ///
//   bool get isNextWeek {
//     if (dateLocal.isAfter(endOfToday) && dateLocal.isBefore(endOfNextWeek)) {
//       return true;
//     }
//     return false;
//   }
//
//   /// Boolean check to see if the current date is yesterday
//   ///
//   bool get isYesterday {
//     if (dateLocal.isAfter(startOfYesterday) &&
//         dateLocal.isBefore(startOfToday)) {
//       return true;
//     }
//     return false;
//   }
//
//   /// Boolean check to see if the current date is last week
//   bool get isLastWeek {
//     if (dateLocal.isAfter(startOfLastWeek) &&
//         dateLocal.isBefore(startOfYesterday)) {
//       return true;
//     }
//     return false;
//   }
//
//   /// Get the [DateTime] at the start of today.
//   /// note this is based on the current time, not the time passed into the [CalendarTime]
//   ///
//   /// ie. set the current date to 12:00am
//   DateTime get startOfToday =>
//       DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
//
//   /// Get the [DateTime] at the start of the calendar time day
//   /// note this is based on the time time passeed into [CalendarTime]
//   /// If you want the start of today object use [startOfToday]
//   ///
//   /// ie. set the current date to 12:00am
//   DateTime get startOfDay => DateTime(_date.year, _date.month, _date.day);
//
//   /// Get the time at the start of yesterday
//   /// note this is based on the current time, not the time passed into the [CalendarTime]
//   ///
//   DateTime get startOfYesterday => startOfToday.subtract(Duration(days: 1));
//
//   /// Get the time at the start of last week
//   /// note this is based on the current time, not the time passed into the [CalendarTime]
//   ///
//   DateTime get startOfLastWeek => startOfToday.subtract(Duration(days: 7));
//
//   /// Get the date at the start of the week based on the [weekDayStart]
//   /// this is based on the time passed into CalendarTime.
//   ///
//   /// To work out the right value to pass in, use DateTime.<weekday> ie DateTime.tuesday
//   /// it defaults to monday
//   DateTime startOfWeek({int weekDayStart = DateTime.monday}) {
//     var difference = dateLocal.weekday - weekDayStart;
//     // if difference is negative, add 7 to make it positive
//     if (difference < 0) {
//       difference += 7;
//     }
//     return startOfDay.subtract(Duration(days: difference));
//   }
//
//   /// Get the date at the end of the week based on the [weekDayStart]
//   /// this is based on the time passed into CalendarTime.
//   ///
//   /// To work out the right value to pass in, use DateTime.<weekday> ie DateTime.tuesday
//   /// it defaults to monday
//   DateTime endOfWeek({int weekDayStart = DateTime.monday}) {
//     final startOfWeek = this.startOfWeek(weekDayStart: weekDayStart);
//     return CalendarTime(startOfWeek.add(Duration(days: 6))).endOfDay;
//   }
//
//   /// Get the time at the end of today,
//   /// note this is based on the current time, not the time passed into the [CalendarTime]
//   /// If you want the end of the day of the CalendarTime object, use [endOfDay]
//   ///
//   DateTime get endOfToday => DateTime(DateTime.now().year, DateTime.now().month,
//       DateTime.now().day, 23, 59, 59, 999, 999);
//
//   /// Get the time at the end of the day given to the CalendarTime obejct
//   ///
//   DateTime get endOfDay =>
//       DateTime(_date.year, _date.month, _date.day, 23, 59, 59, 999, 999);
//
//   /// Get the time at the end of tomorrow
//   /// note this is based on the current time, not the time passed into the [CalendarTime]
//   ///
//   DateTime get endOfTomorrow => endOfToday.add(Duration(days: 1));
//
//   /// Get the time at the end of next week
//   /// note this is based on the current time, not the time passed into the [CalendarTime]
//   ///
//   DateTime get endOfNextWeek => endOfToday.add(Duration(days: 7));
//
//   /// Generate a CalendarTime object from a string with a custom format
//   ///
//   /// You can specify the date format using the intl skeleton as per below
//   ///
//   /// Example usage
//   /// ```dart
//   /// CalendarTime.fromString("4/4/02 11:14am", "d/M/yy j:ma")
//   ///
//   /// Skeletons: These can be specified either as the ICU constant name or as the
//   /// skeleton to which it resolves. The supported set of skeletons is as follows.
//   /// For each skeleton there is a named constructor that can be used to create
//   /// it.  It's also possible to pass the skeleton as a string, but the
//   /// constructor is preferred.
//   ///
//   ///      ICU Name                   Skeleton
//   ///      --------                   --------
//   ///      DAY                          d
//   ///      ABBR_WEEKDAY                 E
//   ///      WEEKDAY                      EEEE
//   ///      ABBR_STANDALONE_MONTH        LLL
//   ///      STANDALONE_MONTH             LLLL
//   ///      NUM_MONTH                    M
//   ///      NUM_MONTH_DAY                Md
//   ///      NUM_MONTH_WEEKDAY_DAY        MEd
//   ///      ABBR_MONTH                   MMM
//   ///      ABBR_MONTH_DAY               MMMd
//   ///      ABBR_MONTH_WEEKDAY_DAY       MMMEd
//   ///      MONTH                        MMMM
//   ///      MONTH_DAY                    MMMMd
//   ///      MONTH_WEEKDAY_DAY            MMMMEEEEd
//   ///      ABBR_QUARTER                 QQQ
//   ///      QUARTER                      QQQQ
//   ///      YEAR                         y
//   ///      YEAR_NUM_MONTH               yM
//   ///      YEAR_NUM_MONTH_DAY           yMd
//   ///      YEAR_NUM_MONTH_WEEKDAY_DAY   yMEd
//   ///      YEAR_ABBR_MONTH              yMMM
//   ///      YEAR_ABBR_MONTH_DAY          yMMMd
//   ///      YEAR_ABBR_MONTH_WEEKDAY_DAY  yMMMEd
//   ///      YEAR_MONTH                   yMMMM
//   ///      YEAR_MONTH_DAY               yMMMMd
//   ///      YEAR_MONTH_WEEKDAY_DAY       yMMMMEEEEd
//   ///      YEAR_ABBR_QUARTER            yQQQ
//   ///      YEAR_QUARTER                 yQQQQ
//   ///      HOUR24                       H
//   ///      HOUR24_MINUTE                Hm
//   ///      HOUR24_MINUTE_SECOND         Hms
//   ///      HOUR                         j
//   ///      HOUR_MINUTE                  jm
//   ///      HOUR_MINUTE_SECOND           jms
//   ///      HOUR_MINUTE_GENERIC_TZ       jmv
//   ///      HOUR_MINUTE_TZ               jmz
//   ///      HOUR_GENERIC_TZ              jv
//   ///      HOUR_TZ                      jz
//   ///      MINUTE                       m
//   ///      MINUTE_SECOND                ms
//   ///      SECOND                       s
//   factory CalendarTime.fromString(String input,
//       [String? pattern, String? locale]) {
//     final format = DateFormat(pattern, locale);
//     final dateTime = format.parse(input);
//     return CalendarTime(dateTime);
//   }
//
//   bool isSameDayAs(DateTime comparisonDate) {
//     return (_date.toLocal()).toLocal().year ==
//         (comparisonDate.toLocal()).year &&
//         (_date.toLocal()).month == (comparisonDate.toLocal()).month &&
//         (_date.toLocal()).day == (comparisonDate.toLocal()).day;
//   }
// }

///

// extension MomentBenefits on DateTime {
//   /// Returns hour in 12-hour format
//   ///
//   /// Relevant: [isAm] or [isPm]
//   int get hour12 {
//     if (hour == 0 || hour == 12) return 12;
//
//     return hour % 12;
//   }
//
//   /// Returns whether the [hour] is before noon (ante meridiem) in the current timezone
//   bool get isAm => hour < 12;
//
//   /// Returns whether the [hour] is after noon (post meridiem) in the current timezone
//   bool get isPm => hour >= 12;
//
//   /// Returns quarter of the year.
//   ///
//   /// Jan,Feb,Mar is Q1
//   ///
//   /// Apr,May,Jun is Q2
//   ///
//   /// Jul,Aug,Sep is Q3
//   ///
//   /// Oct,Nov,Dec is Q4
//   int get quarter => (month - 1) ~/ 3 + 1;
//
//   int get _isoWeekRaw => (10 + dayOfYear - weekday) ~/ 7;
//
//   bool get _isoWeekInNextYear =>
//       DateTime(year, 1, 1).weekday != DateTime.thursday &&
//       DateTime(year, 12, 31).weekday != DateTime.thursday;
//
//   /// Returns [ISO week](https://en.wikipedia.org/wiki/ISO_week_date) number of the year
//   ///
//   /// [1, 2, 3, ..., 52, 53]
//   int get week {
//     final int w = _isoWeekRaw;
//
//     // Last year may have 52 or 53 weeks, we shall check
//     //
//     // Dec 28 is always in the last week
//     if (w == 0) return DateTime(year - 1, 12, 28).week;
//
//     // It might actually be [Week 1] in the next year
//     if (w == 53 && _isoWeekInNextYear) return 1;
//
//     return w;
//   }
//
//   /// Returns year according to [ISO week](https://en.wikipedia.org/wiki/ISO_week_date) number of the year
//   int get weekYear {
//     final int w = _isoWeekRaw;
//
//     if (w == 0) return year - 1;
//
//     if (w == 53 && _isoWeekInNextYear) return year + 1;
//
//     return year;
//   }
//
//   /// Returns ordinal day of the year in the current timezone
//   ///
//   /// [1,2,3,...,365,366]
//   int get dayOfYear {
//     const List<int> dayCount = [
//       0,
//       0,
//       31,
//       59,
//       90,
//       120,
//       151,
//       181,
//       212,
//       243,
//       273,
//       304,
//       334
//     ];
//
//     final int dayOfTheYear = dayCount[month] + day;
//
//     if (isLeapYear && month > 2) {
//       return dayOfTheYear + 1;
//     }
//
//     return dayOfTheYear;
//   }
//
//   /// Difference calculated after omitting hour, minute, ..., microsecond
//   ///
//   /// Does not take timezones of [this] and [other]!
//   ///
//   /// Uses DateTime.difference(), therefore behaves same.
//   /// So, be careful with UTC and local timezones.
//   ///
//   /// -------
//   ///
//   /// If [other] occured after [this], result is negative
//   ///
//   /// ```dart
//   /// today.differenceInDays(tomorrow); // -1
//   /// tomorrow.differenceInDays(today); // 1
//   ///
//   /// // 0 means [this] and [other] occured at the same day.
//   /// ```
//   int differenceInDays(DateTime other) {
//     return difference(other).inDays;
//   }
//
//   /// Equivalent to `add(other)`
//   operator +(Duration other) => add(other);
//
//   /// Equivalent to `subtract(other)`
//   operator -(Duration other) => subtract(other);
//
//   /// Equivalent to `isAfter(other)`
//   operator >(DateTime other) => isAfter(other);
//
//   /// Equivalent to `isBefore(other)`
//   operator <(DateTime other) => isBefore(other);
//
//   /// Equivalent to `isAfter(other) || isAtSameMomentAs(other)`
//   operator >=(DateTime other) => isAfter(other) || isAtSameMomentAs(other);
//
//   /// Equivalent to `isBefore(other) || isAtSameMomentAs(other)`
//   operator <=(DateTime other) => isBefore(other) || isAtSameMomentAs(other);
//
//   /// Returns timezone:
//   ///
//   /// -06:00 => GMT-6
//   ///
//   /// +13:00 => GMT+13
//   ///
//   /// You can disable [seperateWithColon].
//   ///
//   /// -0730 => GMT-7:30
//   ///
//   /// +1300 => GMT+13
//   String timeZoneFormatted([bool seperateWithColon = true]) {
//     final int inMinutes = timeZoneOffset.abs().inMinutes;
//
//     final int hours = inMinutes ~/ 60;
//     final int minutes = inMinutes - (hours * 60);
//
//     return (timeZoneOffset.isNegative ? "-" : "+") +
//         hours.toString().padLeft(2, '0') +
//         (seperateWithColon ? ":" : "") +
//         minutes.toString().padLeft(2, '0');
//   }
//
//   /// Returns [DateTimeRange] from [this] to [other]
//   ///
//   /// If [this] is after [other], it will be swapped.
//   DateTimeRange to(DateTime other) {
//     if (this <= other) return DateTimeRange(start: this, end: other);
//
//     return DateTimeRange(start: other, end: this);
//   }
// }

///

// extension DateTimeConstructors on DateTime {
//   static DateTime nowWithTimezone(bool isUtc) {
//     if (isUtc) {
//       return DateTime.now().toUtc();
//     }
//
//     return DateTime.now();
//   }
//
//   static DateTime withTimezone(
//       bool isUtc,
//       int year, [
//         int month = 1,
//         int day = 1,
//         int hour = 0,
//         int minute = 0,
//         int second = 0,
//         int millisecond = 0,
//         int microsecond = 0,
//       ]) {
//     if (isUtc) {
//       return DateTime.utc(
//         year,
//         month,
//         day,
//         hour,
//         minute,
//         second,
//         millisecond,
//         microsecond,
//       );
//     }
//     return DateTime(
//       year,
//       month,
//       day,
//       hour,
//       minute,
//       second,
//       millisecond,
//       microsecond,
//     );
//   }
//
//   static DateTime dateWithTimezone(
//       int year, [
//         int month = 1,
//         int day = 1,
//         bool isUtc = false,
//       ]) {
//     if (isUtc) {
//       return DateTime.utc(
//         year,
//         month,
//         day,
//         0,
//         0,
//         0,
//         0,
//         0,
//       );
//     }
//     return DateTime(
//       year,
//       month,
//       day,
//       0,
//       0,
//       0,
//       0,
//       0,
//     );
//   }
// }

///

// extension YearFinder on DateTime {
//   /// Returns a new [DateTime] of same timezone
//   DateTime startOfNextYear() =>
//       DateTimeConstructors.withTimezone(isUtc, year + 1);
//
//   /// Returns a new [DateTime] of same timezone
//   DateTime startOfLastYear() =>
//       DateTimeConstructors.withTimezone(isUtc, year - 1);
//
//   /// Returns a new [DateTime] of same timezone
//   DateTime endOfNextYear() =>
//       DateTimeConstructors.withTimezone(isUtc, year + 1).endOfYear();
//
//   /// Returns a new [DateTime] of same timezone
//   DateTime endOfLastYear() =>
//       DateTimeConstructors.withTimezone(isUtc, year - 1).endOfYear();
// }
//
// extension MonthFinder on DateTime {
//   /// Returns a new [DateTime] of same timezone
//   DateTime startOfNextMonth() =>
//       DateTimeConstructors.withTimezone(isUtc, year, month + 1);
//
//   /// Returns a new [DateTime] of same timezone
//   DateTime startOfLastMonth() =>
//       DateTimeConstructors.withTimezone(isUtc, year, month - 1);
//
//   /// Returns a new [DateTime] of same timezone
//   DateTime endOfNextMonth() =>
//       DateTimeConstructors.withTimezone(isUtc, year, month + 1).endOfMonth();
//
//   /// Returns a new [DateTime] of same timezone
//   DateTime endOfLastMonth() =>
//       DateTimeConstructors.withTimezone(isUtc, year, month - 1).endOfMonth();
// }
//
// extension LocalWeekFinder on DateTime {
//   /// Assumes [this] is in local timezone, but will preserve the timezone
//   DateTime startOfNextLocalWeek([int? weekStart]) =>
//       startOfLocalWeek(weekStart).add(const Duration(days: 7));
//
//   /// Assumes [this] is in local timezone, but will preserve the timezone
//   DateTime startOfLastLocalWeek([int? weekStart]) =>
//       startOfLocalWeek(weekStart).subtract(const Duration(days: 7));
//
//   /// Assumes [this] is in local timezone, but will preserve the timezone
//   DateTime endOfNextLocalWeek([int? weekStart]) =>
//       endOfLocalWeek(weekStart).add(const Duration(days: 7));
//
//   /// Assumes [this] is in local timezone, but will preserve the timezone
//   DateTime endOfLastLocalWeek([int? weekStart]) =>
//       endOfLocalWeek(weekStart).subtract(const Duration(days: 7));
// }
//
// extension IsoWeekFinder on DateTime {
//   /// Assumes [this] is in local timezone, but will preserve the timezone
//   DateTime startOfNextIsoWeek() => startOfNextLocalWeek(DateTime.monday);
//
//   /// Assumes [this] is in local timezone, but will preserve the timezone
//   DateTime startOfLastIsoWeek() => startOfLastLocalWeek(DateTime.monday);
//
//   /// Assumes [this] is in local timezone, but will preserve the timezone
//   DateTime endOfNextIsoWeek() => endOfNextLocalWeek(DateTime.monday);
//
//   /// Assumes [this] is in local timezone, but will preserve the timezone
//   DateTime endOfLastIsoWeek() => endOfLastLocalWeek(DateTime.monday);
// }
//
// extension DayFinder on DateTime {
//   /// Returns a new [DateTime] of same timezone
//   DateTime startOfNextDay() =>
//       DateTimeConstructors.withTimezone(isUtc, year, month, day + 1);
//
//   /// Returns a new [DateTime] of same timezone
//   DateTime startOfLastDay() =>
//       DateTimeConstructors.withTimezone(isUtc, year, month, day - 1);
//
//   /// Returns a new [DateTime] of same timezone
//   DateTime endOfNextDay() =>
//       DateTimeConstructors.withTimezone(isUtc, year, month, day + 1).endOfDay();
//
//   /// Returns a new [DateTime] of same timezone
//   DateTime endOfLastDay() =>
//       DateTimeConstructors.withTimezone(isUtc, year, month, day - 1).endOfDay();
// }
//
// extension HourFinder on DateTime {
//   /// Returns a new [DateTime] of same timezone
//   DateTime startOfNextHour() =>
//       DateTimeConstructors.withTimezone(isUtc, year, month, day, hour + 1);
//
//   /// Returns a new [DateTime] of same timezone
//   DateTime startOfLastHour() =>
//       DateTimeConstructors.withTimezone(isUtc, year, month, day, hour - 1);
//
//   /// Returns a new [DateTime] of same timezone
//   DateTime endOfNextHour() => DateTimeConstructors.withTimezone(
//     isUtc,
//     year,
//     month,
//     day,
//     hour + 1,
//     59,
//     59,
//     999,
//     999,
//   );
//
//   /// Returns a new [DateTime] of same timezone
//   DateTime endOfLastHour() => DateTimeConstructors.withTimezone(
//     isUtc,
//     year,
//     month,
//     day,
//     hour - 1,
//     59,
//     59,
//     999,
//     999,
//   );
// }
//
// extension MinuteFinder on DateTime {
//   /// Returns a new [DateTime] of same timezone
//   DateTime startOfNextMinute() => DateTimeConstructors.withTimezone(
//       isUtc, year, month, day, hour, minute + 1);
//
//   /// Returns a new [DateTime] of same timezone
//   DateTime startOfLastMinute() => DateTimeConstructors.withTimezone(
//       isUtc, year, month, day, hour, minute - 1);
//
//   /// Returns a new [DateTime] of same timezone
//   DateTime endOfNextMinute() => DateTimeConstructors.withTimezone(
//       isUtc, year, month, day, hour, minute + 1, 59, 999, 999);
//
//   /// Returns a new [DateTime] of same timezone
//   DateTime endOfLastMinute() => DateTimeConstructors.withTimezone(
//       isUtc, year, month, day, hour, minute - 1, 59, 999, 999);
// }

///

// extension WeekdayFinder on DateTime {
//   /// Returns new [DateTime] instance of nearest `n`th weekday in the future
//   ///
//   /// If `n`th day is today, will return `7 days in the future`.
//   DateTime nextWeekday(int weekday) {
//     assert(weekday > -1 && weekday < 8,
//     "[moment_dart] Weekday must be in range `0<=n<=7`");
//
//     final int requiredDelta = (weekday - this.weekday) % 7;
//
//     return this + Duration(days: requiredDelta == 0 ? 7 : requiredDelta);
//   }
//
//   /// Returns new [DateTime] instance of nearest Monday in the Future
//   ///
//   /// If [this] is Monday, will return `7 days in the future`
//   DateTime nextMonday() => nextWeekday(DateTime.monday);
//
//   /// Returns new [DateTime] instance of nearest Tuesday in the Future
//   ///
//   /// If [this] is Tuesday, will return `7 days in the future`
//   DateTime nextTuesday() => nextWeekday(DateTime.tuesday);
//
//   /// Returns new [DateTime] instance of nearest Wednesday in the Future
//   ///
//   /// If [this] is Wednesday, will return `7 days in the future`
//   DateTime nextWednesday() => nextWeekday(DateTime.wednesday);
//
//   /// Returns new [DateTime] instance of nearest Thursday in the Future
//   ///
//   /// If [this] is Thursday, will return `7 days in the future`
//   DateTime nextThursday() => nextWeekday(DateTime.thursday);
//
//   /// Returns new [DateTime] instance of nearest Friday in the Future
//   ///
//   /// If [this] is Friday, will return `7 days in the future`
//   DateTime nextFriday() => nextWeekday(DateTime.friday);
//
//   /// Returns new [DateTime] instance of nearest Saturday in the Future
//   ///
//   /// If [this] is Saturday, will return `7 days in the future`
//   DateTime nextSaturday() => nextWeekday(DateTime.saturday);
//
//   /// Returns new [DateTime] instance of nearest Sunday in the Future
//   ///
//   /// If [this] is Sunday, will return `7 days in the future`
//   DateTime nextSunday() => nextWeekday(DateTime.sunday);
//
//   /// Returns new [DateTime] instance of last `n`th weekday
//   ///
//   /// If today is the `n`th day, will return `7 days in the past`
//   DateTime lastWeekday(int weekday) {
//     assert(weekday > -1 && weekday < 8,
//     "[Moment Dart] Weekday must be in range `0<=n<=7`");
//
//     final int requiredDelta = (this.weekday - weekday) % 7;
//
//     return this - Duration(days: requiredDelta == 0 ? 7 : requiredDelta);
//   }
//
//   /// Returns new [DateTime] instance of nearest Monday in the past
//   ///
//   /// If [this] is Monday, will return `7 days in the past`
//   DateTime lastMonday() => lastWeekday(DateTime.monday);
//
//   /// Returns new [DateTime] instance of nearest Tuesday in the past
//   ///
//   /// If [this] is Tuesday, will return `7 days in the past`
//   DateTime lastTuesday() => lastWeekday(DateTime.tuesday);
//
//   /// Returns new [DateTime] instance of nearest Wednesday in the past
//   ///
//   /// If [this] is Wednesday, will return `7 days in the past`
//   DateTime lastWednesday() => lastWeekday(DateTime.wednesday);
//
//   /// Returns new [DateTime] instance of nearest Thursday in the past
//   ///
//   /// If [this] is Thursday, will return `7 days in the past`
//   DateTime lastThursday() => lastWeekday(DateTime.thursday);
//
//   /// Returns new [DateTime] instance of nearest Friday in the past
//   ///
//   /// If [this] is Friday, will return `7 days in the past`
//   DateTime lastFriday() => lastWeekday(DateTime.friday);
//
//   /// Returns new [DateTime] instance of nearest Saturday in the past
//   ///
//   /// If [this] is Saturday, will return `7 days in the past`
//   DateTime lastSaturday() => lastWeekday(DateTime.saturday);
//
//   /// Returns new [DateTime] instance of nearest Sunday in the past
//   ///
//   /// If [this] is Sunday, will return `7 days in the past`
//   DateTime lastSunday() => lastWeekday(DateTime.sunday);
// }

///
