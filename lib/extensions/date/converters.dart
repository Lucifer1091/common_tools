import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../index.dart';

/// Controls how month/day text should be abbreviated when formatting.
enum Abbreviation {
  /// Full form.
  ///
  /// Example: `January`, `Monday`.
  none,

  /// Semi-abbreviated form.
  ///
  /// Example: `Jan`, `Mon`.
  semi,

  /// Abbreviated form.
  ///
  /// Example: `J`, `M` (for weekday helpers) or `Jan` (for month helpers).
  full,
}

/// Common date/time format patterns used across the package.
class MyDateFormats {
  MyDateFormats._();

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

  static const List<String> months = [
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
    'December',
  ];

  static const List<String> shortMonths = [
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
    'Dec',
  ];

  static const List<String> days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  static const List<String> shortDays = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  static const List<String> veryShortDays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
}

/// Conversion helpers on [DateTime] for formatting, ranges, and calendar math.
extension DateConversions on DateTime {
  /// Formats the [DateTime] value to a string using the specified [pattern] and [locale].
  ///
  /// Returns the formatted string.
  String format({
    String pattern = MyDateFormats.dateTime,
    String locale = 'en_US',
  }) => DateFormat(pattern, locale).format(this);

  /// Converts the month of the [DateTime] to a string representing the month's name.
  ///
  /// [Abbreviation.none] returns full month text (for example, `June`).
  /// [Abbreviation.semi] and [Abbreviation.full] return abbreviated month text
  /// (for example, `Jun`).
  ///
  /// Returns the full or abbreviated month name as a string.
  ///
  /// Example:
  /// ```dart
  /// DateTime date = DateTime(2024, 6, 23);
  /// print(date.toMonth()); // Output: June
  /// print(date.toMonth(style: Abbreviation.full)); // Output: Jun
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
  /// DateTime date = DateTime(2024, 6, 20);
  /// print(date.toWeekday()); // Output: Thursday
  /// print(date.toWeekday(style: Abbreviation.semi)); // Output: Thu
  /// print(date.toWeekday(style: Abbreviation.full)); // Output: T
  /// ```
  String toWeekday({Abbreviation style = Abbreviation.none}) =>
      weekday.toDay(style: style);

  /// Returns a greeting based on the current time of day.
  ///
  /// Returns "Good Morning" if the hour is between 5:00 and 11:59 AM,
  /// "Good Afternoon" if the hour is between 12:00 and 4:59 PM,
  /// "Good Evening" if the hour is between 5:00 and 8:59 PM,
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
    final now = DateTime.now();
    final diff = now.difference(this);
    final sec = diff.inSeconds;

    if (sec < 0) return format(pattern: MyDateFormats.date);

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
    final String day = format(pattern: MyDateFormats.fullDay);
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

  /// Calculates number of ISO weeks for [year].
  ///
  /// Reference:
  /// https://en.wikipedia.org/wiki/ISO_week_date#Weeks_per_year
  int _numOfWeeks(int year) {
    final DateTime dec28 = DateTime(year, 12, 28);
    final int dayOfDec28 = int.parse(DateFormat('D').format(dec28));
    return ((dayOfDec28 - dec28.weekday + 10) / 7).floor();
  }

  /// Returns the ISO week number for the current [DateTime].
  ///
  /// Reference:
  /// https://en.wikipedia.org/wiki/ISO_week_date#Calculation
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

  /// Calculates approximate age in years from this date until now.
  ///
  /// This uses a simple `inDays ~/ 365` calculation.
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

    // Add 1 because differenceInDays returns a 0-based difference
    return difference(jan1st).inDays + 1;
  }

  /// Returns the duration difference between this value and current time.
  Duration fromNow() => difference(DateTime.now());

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
  /// The output format is `+/-HH:mm` by default.
  ///
  /// Set [separateWithColon] to `false` for compact output (`+/-HHmm`).
  ///
  /// Example: `+05:30` or `+0530`.
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
  /// If [utc] is `true`, converts this value to UTC before formatting.
  ///
  /// The returned value drops fractional seconds by splitting at `.`.
  String toUtcString({bool utc = false}) {
    if (utc) {
      return toUtc().toString().split('.')[0];
    }

    return toString().split('.')[0];
  }

  /// Converts the DateTime object to the UTC timezone.
  ///
  /// Returns a [DateTime] in UTC with the same date and clock components.
  ///
  /// Example:
  /// ```dart
  /// final dateTime = DateTime.now();
  /// final utcDateTime = dateTime.asUtc;
  /// print('UTC DateTime: $utcDateTime');
  /// ```
  DateTime? get asUtc => DateTime.utc(year, month, day, hour, minute, second);
}

/// Parsing helpers for nullable date/time strings.
///
/// These helpers support both explicit patterns and best-effort parsing.
extension ParseDateTime on String? {
  /// Checks whether this string can be interpreted as a date/time value.
  ///
  /// This first checks [Regex.date], then falls back to [DateTime.parse].
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

  /// Parses this string into [DateTime] using an optional [format].
  ///
  /// When [utc] is `true`, parsing is normalized to UTC.
  /// Returns `null` for blank or invalid input.
  ///
  /// Example:
  /// ```dart
  /// final local = '15/01/2024 18:45'.toDateTime(
  ///   format: 'dd/MM/yyyy HH:mm',
  /// );
  /// final utc = '2024-01-10T12:00:00Z'.toDateTime(utc: true);
  /// ```
  DateTime? toDateTime({bool utc = false, String? format}) =>
      parse(this, utc: utc, format: format);

  /// Parses this string and returns a normalized date-time string without
  /// fractional seconds.
  ///
  /// The [format] is used only for parsing input text.
  /// When [utc] is `true`, output is converted to UTC; otherwise local time is used.
  /// Returns `null` if parsing fails.
  String? toUtcString({
    bool utc = false,
    String format = 'MMM dd, yyyy h:mm a',
  }) {
    final DateTime? parsed = parse(this, format: format, utc: utc);
    if (parsed == null) return null;

    final DateTime normalized = utc ? parsed.toUtc() : parsed.toLocal();
    return normalized.toString().split('.')[0];
  }

  /// Parses [date] into a [DateTime] using a best-effort strategy.
  ///
  /// Resolution order:
  /// 1. Returns `null` for blank values.
  /// 2. Uses explicit [format] when provided.
  /// 3. Tries [DateTime.tryParse].
  /// 4. Falls back to `yyyy-MM-dd HH:mm:ss` parsing.
  /// 5. If parsing throws, tries `yyyy-MM-dd'T'HH:mm:ss.SSS`.
  ///
  /// The resulting value is normalized based on [utc].
  ///
  /// Example:
  /// ```dart
  /// final a = ParseDateTime.parse('2024-01-10T12:00:00Z');
  /// final b = ParseDateTime.parse(
  ///   '15/01/2024 18:45',
  ///   format: 'dd/MM/yyyy HH:mm',
  ///   utc: false,
  /// );
  /// ```
  static DateTime? parse(Object? date, {bool utc = false, String? format}) {
    final String? dt = date?.toString().trim();

    DateTime? normalize(DateTime? value) {
      if (value == null) return null;
      return utc ? value.toUtc() : value.toLocal();
    }

    try {
      if (dt == null || dt.isEmpty) return null;

      if (format != null) {
        return DateFormat(format).parse(dt, utc);
      }

      final DateTime? parsed = DateTime.tryParse(dt);
      if (parsed != null) return normalize(parsed);

      return DateFormat('yyyy-MM-dd HH:mm:ss').tryParse(dt, utc);
    } catch (e) {
      try {
        // Fallback for values like 2024-04-17T07:20:57.573
        final DateFormat format = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS");
        final DateTime dateTime = format.parse(dt!, utc);

        return dateTime;
      } catch (e) {
        return null;
      }
    }
  }
}
