part of 'extensions.dart';

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
  /// If [short] is true, returns the abbreviated form of the month's name.
  ///
  /// Returns the full or abbreviated month name as a string.
  ///
  /// Example:
  /// ```dart
  /// DateTime date = DateTime(2024, 6, 23);
  /// print(date.toMonth()); // Output: June
  /// print(date.toMonth(short: true)); // Output: Jun
  /// ```
  String toMonth({bool short = false}) {
    return month.toMonthName(short: short);
  }

  /// Converts the weekday of the [DateTime] to a string representing the day's name.
  ///
  /// If [short] is true, returns the abbreviated form of the day's name (e.g., "Mon" for Monday).
  ///
  /// If [abbreviated] is true, returns a very short form of the day's name (e.g., "M" for Monday).
  ///
  /// Only one of [short] or [abbreviated] can be true at a time. If both are false, returns the full day name.
  ///
  /// Returns the full, abbreviated, or very short day name as a string.
  ///
  /// Example:
  /// ```dart
  /// DateTime date = DateTime(2024, 6, 23);
  /// print(date.toWeekday()); // Output: Thursday
  /// print(date.toWeekday(short: true)); // Output: Thu
  /// print(date.toWeekday(abbreviated: true)); // Output: T
  /// ```
  String toWeekday({bool short = false, bool abbreviated = false}) {
    return weekday.toDayName(short: short, abbreviated: abbreviated);
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
      DateTime(
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

  /// Converts the string to a [DateTime] object using a specified [format].
  ///
  /// Returns null if the string is null or cannot be parsed according to the [format].
  ///
  /// If [format] is not provided, defaults to [DateFormats.defaultDateTime].
  DateTime? toDateTime({String? format}) {
    DateFormat dateFormat = DateFormat(format ?? DateFormats.defaultDateTime);
    try {
      return dateFormat.parse(this ?? '');
    } catch (e) {
      return null;
    }
  }

  /// Parses the provided [date] object into a [DateTime] object.
  ///
  /// Returns null if [date] is null, empty, or cannot be parsed.
  ///
  /// Accepts various object types and formats them into a [DateTime].
  static DateTime? parse(Object? date) {
    String? dt = date?.toString().trim();

    try {
      if (dt == "" || (dt?.isEmpty ?? true) || dt == null) return null;

      // return DateFormat("yyyy-MM-dd HH:mm:ss").parse(dt, true);

      return DateTime.tryParse(dt);
    } catch (e) {
      return null;
    }
  }

  /// Converts the string to a [TimeOfDay] object using the 'hh:mm a' format.
  ///
  /// The string must be in the format 'hh:mm a', for example, '02:30 PM'.
  ///
  /// Throws a [FormatException] if the string does not conform to the expected format.
  ///
  /// Returns a [TimeOfDay] object representing the parsed time.
  TimeOfDay? stringToTime() {
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
  /// If [short] is true, returns the abbreviated form of the month's name.
  ///
  /// Returns the full or abbreviated month name as a string.
  String toMonthName({bool short = false}) {
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
    return short ? shortMonths[this - 1] : months[this - 1];
  }

  /// Converts an integer representing the day of the week (1 for Monday through 7 for Sunday)
  /// to the corresponding day's name.
  ///
  /// If [short] is true, returns the abbreviated form of the day's name (e.g., "Mon" for Monday).
  ///
  /// If [abbreviated] is true, returns a very short form of the day's name (e.g., "M" for Monday).
  ///
  /// Only one of [short] or [abbreviated] can be true at a time. If both are false, returns the full day name.
  ///
  /// Returns the full, abbreviated, or very short day name as a string.
  ///
  /// Example:
  /// ```dart
  /// print(1.toDayName()); // Output: Monday
  /// print(1.toDayName(short: true)); // Output: Mon
  /// print(1.toDayName(abbreviated: true)); // Output: M
  /// ```
  String toDayName({bool short = false, bool abbreviated = false}) {
    assert(
      !(short && abbreviated),
      "Only one of 'short' or 'abbreviated' can be true.",
    );

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

    if (abbreviated) {
      return veryShortDays[this - 1];
    } else {
      return short ? shortDays[this - 1] : days[this - 1];
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
  /// If [short] is true, returns the abbreviated form of the month's name (e.g., "Jan" for January).
  ///
  /// Only [short] can be true at a time.
  ///
  /// Returns the full or abbreviated month name as a string.
  ///
  /// Example:
  /// ```dart
  /// DateTime? date = DateTime(2024, 6, 23);
  /// print(date.toMonth()); // Output: June
  /// print(date.toMonth(short: true)); // Output: Jun
  /// ```
  String toMonth({bool short = false}) {
    if (this == null) return '';

    return this!.toMonth(short: short);
  }

  /// Converts the weekday of the [DateTime] to a string representing the day's name.
  ///
  /// If [short] is true, returns the abbreviated form of the day's name (e.g., "Mon" for Monday).
  ///
  /// If [abbreviated] is true, returns a very short form of the day's name (e.g., "M" for Monday).
  ///
  /// Only one of [short] or [abbreviated] can be true at a time. If both are false, returns an empty string for null DateTime.
  ///
  /// Returns the full, abbreviated, or very short day name as a string.
  ///
  /// Example:
  /// ```dart
  /// DateTime? date = DateTime(2024, 6, 23);
  /// print(date.toWeekday()); // Output: Thursday
  /// print(date.toWeekday(short: true)); // Output: Thu
  /// print(date.toWeekday(abbreviated: true)); // Output: T
  /// ```
  String toWeekday({bool short = false, bool abbreviated = false}) {
    if (this == null) return '';

    return this!.toWeekday(short: short, abbreviated: abbreviated);
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

extension DateTimeExtension1 on DateTime {}

extension DateTimeExtension2 on DateTime? {}
