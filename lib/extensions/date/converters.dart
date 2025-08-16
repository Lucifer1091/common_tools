import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../index.dart';

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
  static const dateTime = 'MMM dd, yyyy hh:mm a';
  static const date = 'MMM dd, yyyy';
  static const time = 'hh:mm a';
  static const time24 = 'HH:mm:ss';
  static const month = 'MMMM';
  static const year = 'yyyy';
  static const monthYear = 'MMMM, yyyy';
  static const monthDay = 'MMM dd';
  static const day = 'dd';
  static const fullDay = 'EEEE';
  static const shortDay = 'EEE';
  static const fullDate = 'EEE MMM dd, yyyy';
}

extension DateConversions on DateTime {
  /// Formats the [DateTime] value to a string using the specified [pattern] and [locale].
  ///
  /// Returns the formatted string.
  String format({
    String pattern = DateFormats.dateTime,
    String locale = 'en_US',
  }) => DateFormat(pattern, locale).format(this);

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
  String toMonth({Abbreviation style = Abbreviation.none}) =>
      month.toMonth(style: style);

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
  String toWeekday({Abbreviation style = Abbreviation.none}) =>
      weekday.toDay(style: style);

  /// Returns a greeting based on the current time of day.
  ///
  /// Returns "Good Morning" if the hour is between 5:00 and 11:59 AM,
  /// "Good Afternoon" if the hour is between 12:00 and 4:59 PM,
  /// and "Good Night" for all other times.
  String greeting() {
    if (isMorning) {
      return 'Good Morning';
    } else if (isAfternoon) {
      return 'Good Afternoon';
    } else if (isEvening) {
      return 'Good Evening';
    } else {
      return 'Good Night';
    }
  }

  /// Calculates the total minutes represented by the time of day of the [DateTime] value.
  ///
  /// Returns the total minutes.
  int get totalMinutes => hour * 60 + minute;

  /// Converts the [DateTime] value to a [TimeOfDay] object.
  ///
  /// Returns the [TimeOfDay] object.
  TimeOfDay get timeOfDay => TimeOfDay(hour: hour, minute: minute);

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

  /// Converts the date into a human-readable representation of the time.
  ///
  /// For example, if a [DateTime] is today at 4:30 PM, it returns "Today at 4:30 PM".
  /// It also accounts for dates that are tomorrow, yesterday, or within the past or next week.
  ///
  /// Example:
  /// ```dart
  /// DateTime date = DateTime.now();
  /// print(date.toHuman); // Outputs: "Today at 4:30 PM" (depending on the current time)
  /// ```
  String get toHuman {
    final String time = DateFormat.jm().format(this);
    final String day = format(pattern: DateFormats.fullDay);
    final String fullDate = DateFormat.yMMMEd().format(this);
    final String fullTime = DateFormat.jm().format(this);
    final String fullDateTime = '$fullDate $fullTime';

    if (isToday) {
      return 'Today at $time';
    } else if (isTomorrow) {
      return 'Tomorrow at $time';
    } else if (isNextWeek) {
      return '$day at $time';
    } else if (isYesterday) {
      return 'Yesterday at $time';
    } else if (isLastWeek) {
      return 'Last $day at $time';
    } else {
      return fullDateTime;
    }
  }

  /// Calculates the number of ISO weeks for the current year.
  ///
  /// Returns the number of ISO weeks.
  /// Calculates number of weeks for a given year as per https://en.wikipedia.org/wiki/ISO_week_date#Weeks_per_year
  int _numOfWeeks(int year) {
    final DateTime dec28 = DateTime(year, 12, 28);
    final int dayOfDec28 = int.parse(DateFormat('D').format(dec28));
    return ((dayOfDec28 - dec28.weekday + 10) / 7).floor();
  }

  /// Returns the ISO week number for the current [DateTime].
  ///
  /// Returns the ISO week number.
  /// Calculates week number from a date as per https://en.wikipedia.org/wiki/ISO_week_date#Calculation
  int get weekNumber {
    final int dayOfYear = int.parse(DateFormat('D').format(this));
    int woy = ((dayOfYear - weekday + 10) / 7).floor();
    if (woy < 1) {
      woy = _numOfWeeks(year - 1);
    } else if (woy > _numOfWeeks(year)) {
      woy = 1;
    }
    return woy;
  }

  /// Calculates the age based on the current date.
  ///
  /// Returns the age in years.
  int get toAge => (DateTime.now().difference(this).inDays) ~/ 365;

  /// Gets the Unix timestamp of this [DateTime].
  ///
  /// Returns the Unix timestamp in seconds as an integer.
  int get timeStamp => millisecondsSinceEpoch ~/ 1000;

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

  /// Calculates the day of the year (1-based index) for the current date.
  ///
  /// The day of the year is calculated as the 1-based index of the current date
  /// within its year. For example, January 1st returns 1, February 1st returns 32,
  /// and December 31st returns 365 (or 366 in a leap year).
  int get dayOfYear {
    // Get the date of January 1st of the current year
    final DateTime jan1st = DateTime(year);

    // Calculate the difference in days between the current date and January 1st
    final int difference = differenceInDays(jan1st);

    // Add 1 because differenceInDays returns a 0-based difference
    return difference + 1;
  }

  /// Calculates the difference in years between this date and [other].
  ///
  /// Returns the number of full years between the two dates, considering whole days.
  int differenceInYear(DateTime other) {
    final Duration difference = this.difference(other);
    final int years = difference.inDays ~/ 365;

    return years;
  }

  /// Calculates the difference in months between this date and [other].
  ///
  /// Returns the number of full months between the two dates, considering whole days.
  int differenceInMonth(DateTime other) {
    final Duration difference = this.difference(other);
    final int months = (difference.inDays % 365) ~/ 30;

    return months;
  }

  /// Calculates the difference in days between two DateTime objects.
  ///
  /// Returns the difference in days as an integer. The calculation is based on
  /// the difference between the dates at midnight, ignoring any time component.
  int differenceInDays(DateTime other) {
    final DateTime a = this;

    // Convert both dates to midnight for accurate day difference calculation
    final DateTime aMidnight = DateTime(a.year, a.month, a.day);
    final DateTime bMidnight = DateTime(other.year, other.month, other.day);

    // Calculate the difference in milliseconds
    final int differenceInMilliseconds =
        aMidnight.difference(bMidnight).inMilliseconds;

    // Convert milliseconds to days
    return (differenceInMilliseconds / (24 * 60 * 60 * 1000)).round();
  }

  /// Creates a [DateTimeRange] from this to [other].
  ///
  /// If this is after [other], the range is swapped to maintain chronological order.
  /// Returns a [DateTimeRange] with the correct start and end dates.
  DateTimeRange toRange(DateTime other) {
    if (this <= other) return DateTimeRange(start: this, end: other);

    return DateTimeRange(start: other, end: this);
  }

  /// Returns the hour in 12-hour format.
  ///
  /// Useful for formatting times with AM/PM. Returns 12 for midnight and noon.
  int get hour12 {
    if (hour == 0 || hour == 12) return 12;

    return hour % 12;
  }

  /// Returns the quarter of the year.
  ///
  /// - Q1: January, February, March
  /// - Q2: April, May, June
  /// - Q3: July, August, September
  /// - Q4: October, November, December
  int get quarter => (month - 1) ~/ 3 + 1;

  /// Returns the timezone offset in a formatted string.
  ///
  /// Formats the timezone offset as "GMT+/-HH:mm". You can disable [separateWithColon]
  /// to remove the colon between hours and minutes, resulting in "GMT+/-HHmm".
  /// Example: "-06:00" becomes "GMT-6" or "-0600" becomes "GMT-6:00".
  String timeZoneFormatted([bool separateWithColon = true]) {
    final int inMinutes = timeZoneOffset.abs().inMinutes;

    final int hours = inMinutes ~/ 60;
    final int minutes = inMinutes - (hours * 60);

    return (timeZoneOffset.isNegative ? '-' : '+') +
        hours.toString().padLeft(2, '0') +
        (separateWithColon ? ':' : '') +
        minutes.toString().padLeft(2, '0');
  }

  /// Converts the [DateTime] object to a string representation.
  ///
  /// If [utc] is `true`, converts the date to UTC and returns the UTC formatted string,
  /// excluding milliseconds. If [utc] is `false` or omitted, returns the local time
  /// formatted string, excluding milliseconds.
  String toUtcString({bool utc = true}) {
    if (utc) {
      return toUtc().toString().split('.')[0];
    }

    return toString().split('.')[0];
  }
}

extension ParseDateTime on String? {
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

  DateTime? toDateTime({bool utc = false, String? format}) =>
      parse(this, utc: utc, format: format);

  String? toUtcString({
    bool utc = true,
    String format = 'MMM dd, yyyy h:mm a',
  }) => parse(this, format: format, utc: utc)?.toString().split('.')[0];

  String? detectFormat() {
    if (isBlank) return null;

    String? finalPattern;
    final List<String> patternsFound = [];

    for (final entry in Regex.dateFormats.entries) {
      final regex = RegExp(entry.key);
      if (matches(regex: regex)) {
        // return entry.value;
        patternsFound.add(entry.value);
      }
    }

    if (patternsFound.isNotEmpty && patternsFound.length > 1) {
      for (final String pattern in patternsFound) {
        final bool validatePattern = validateDatePattern(
          expected: this!,
          pattern: pattern,
        );
        if (validatePattern) {
          finalPattern = pattern;
          break;
        }
      }
    } else {
      if (patternsFound.isNotEmpty) finalPattern = patternsFound[0];
    }

    return finalPattern;
  }

  bool validateDatePattern({
    required String expected,
    String pattern = 'yyyy-MM-dd HH:mm:ss',
  }) {
    if (isBlank) return false;

    try {
      final DateTime dateTime = DateFormat(pattern).parse(this!);
      final String formattedDate = DateFormat(pattern).format(dateTime);
      return formattedDate == expected;
    } catch (e) {
      return false;
    }
  }

  static DateTime? parse(Object? date, {bool utc = true, String? format}) {
    final String? dt = date?.toString().trim();

    try {
      if (dt == '' || (dt?.isEmpty ?? true) || dt == null) return null;

      if (utc) {
        return DateFormat(
          format ?? 'yyyy-MM-dd HH:mm:ss',
        ).parse(dt, true).toLocal();
      }

      if (format != null) {
        return DateFormat(format).parse(dt, utc).toLocal();
      }

      return DateTime.tryParse(dt);
    } catch (e) {
      try {
        // if its failing it means the date format is 2024-04-17T07:20:57.573
        final DateFormat format = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS");
        final DateTime dateTime = format.parse(dt!, utc).toLocal();

        return dateTime;
      } catch (e) {
        final String? detectedDateFormat = dt.detectFormat();

        if (detectedDateFormat == null) return null;

        try {
          final DateFormat outputFormat = DateFormat(detectedDateFormat);
          final DateTime? result = outputFormat.tryParse(dt!, utc);

          return result;
        } catch (e) {
          return null;
        }
      }
    }
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
    final int difference =
        (other ?? DateTime.now()).millisecondsSinceEpoch -
        (this ?? DateTime.now()).millisecondsSinceEpoch;
    final int count = (difference / 1000).truncate();
    return count;
  }

  /// Converts the time difference to a number of minutes.
  ///
  /// Returns the number of minutes between the current DateTime instance and [other].
  /// If [other] is not provided, the current system DateTime is used.
  int countMinutes(DateTime? other) {
    final int difference =
        (other ?? DateTime.now()).millisecondsSinceEpoch -
        (this ?? DateTime.now()).millisecondsSinceEpoch;
    final int count = (difference / 60000).truncate();
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
    final int difference =
        (other ?? DateTime.now()).millisecondsSinceEpoch -
        (this ?? DateTime.now()).millisecondsSinceEpoch;
    final int count = (difference / 3600000).truncate();
    return count;
  }

  /// Calculates the number of days between two [DateTime] objects.
  ///
  /// The [other] parameter specifies the end date for the calculation.
  ///
  /// Returns the number of days as an integer value.
  int countDays(DateTime? other) {
    final int difference =
        (other ?? DateTime.now()).millisecondsSinceEpoch -
        (this ?? DateTime.now()).millisecondsSinceEpoch;
    final int count = (difference / 86400000).truncate();
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
    final int difference =
        (other ?? DateTime.now()).millisecondsSinceEpoch -
        (this ?? DateTime.now()).millisecondsSinceEpoch;
    final int count = (difference / 604800000).truncate();
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
    final int difference =
        (other ?? DateTime.now()).millisecondsSinceEpoch -
        (this ?? DateTime.now()).millisecondsSinceEpoch;
    final int count = (difference / 2628003000).round();
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
    final int difference =
        (other ?? DateTime.now()).millisecondsSinceEpoch -
        (this ?? DateTime.now()).millisecondsSinceEpoch;
    final int count = (difference / 31536000000).truncate();
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
  DateTime? get asUtc =>
      isNull
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

  /// Returns Duration difference between [this] and current time
  Duration fromNow() {
    if (this == null) return Duration.zero;

    return this!.difference(DateTime.now());
  }
}
