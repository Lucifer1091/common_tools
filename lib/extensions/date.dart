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

  /// Returns `true` if this [DateTime] is a Saturday or a Sunday.
  ///
  /// This getter checks if the day of the week of the [DateTime] is either
  /// Saturday or Sunday. Returns `false` if the [DateTime] is `null`.
  ///
  /// Example:
  /// ```dart
  /// DateTime? saturday = DateTime(2023, 1, 7); // A Saturday
  /// print(saturday.isWeekend); // Outputs: true
  ///
  /// DateTime? monday = DateTime(2023, 1, 9); // A Monday
  /// print(monday.isWeekend); // Outputs: false
  /// ```
  bool get isWeekend =>
      isNotNull && (this!.weekday == DateTime.saturday) ||
      (this!.weekday == DateTime.sunday);

  /// Returns `true` if this [DateTime] is not a Saturday or Sunday.
  ///
  /// This getter checks if the day of the week of the [DateTime] is a
  /// workday (Monday through Friday). Returns `false` if the [DateTime] is `null`.
  ///
  /// Example:
  /// ```dart
  /// DateTime? friday = DateTime(2023, 1, 6); // A Friday
  /// print(friday.isWorkday); // Outputs: true
  ///
  /// DateTime? sunday = DateTime(2023, 1, 8); // A Sunday
  /// print(sunday.isWorkday); // Outputs: false
  /// ```
  bool get isWorkday => !isWeekend;

  /// Returns whether the [hour] is before noon (ante meridiem) in the current timezone.
  ///
  /// This getter checks if the hour of the [DateTime] is less than 12, indicating AM.
  /// Returns `false` if the [DateTime] is `null`.
  ///
  /// Example:
  /// ```dart
  /// DateTime? morningTime = DateTime(2023, 1, 1, 9, 0); // 9:00 AM
  /// print(morningTime.isAm); // Outputs: true
  /// ```
  bool get isAm => isNotNull && this!.hour < 12;

  /// Returns whether the [hour] is after noon (post meridiem) in the current timezone.
  ///
  /// This getter checks if the hour of the [DateTime] is 12 or greater, indicating PM.
  /// Returns `false` if the [DateTime] is `null`.
  ///
  /// Example:
  /// ```dart
  /// DateTime? afternoonTime = DateTime(2023, 1, 1, 15, 0); // 3:00 PM
  /// print(afternoonTime.isPm); // Outputs: true
  /// ```
  bool get isPm => isNotNull && this!.hour >= 12;

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

  /// Determines if this date falls within the same ISO week as [other].
  ///
  /// Dates are considered to be in the same ISO week if they have the same ISO week
  /// number within their respective years. This method handles daylight savings
  /// by comparing dates based on their UTC representation.
  ///
  /// Returns `true` if this date and [other] are in the same ISO week; otherwise, returns `false`.
  bool isSameWeek(DateTime? other) {
    if (isNull || other == null) return false;
    // Convert dates to UTC to handle daylight savings time correctly
    DateTime a = DateTime.utc(this!.year, this!.month, this!.day);
    other = DateTime.utc(other.year, other.month, other.day);

    // Calculate ISO week numbers for both dates
    int aWeek = a.weekNumber;
    int bWeek = other.weekNumber;

    // Compare ISO week numbers to determine if they are in the same week
    return aWeek == bWeek;
  }

  /// Check if this date is in the same month than other
  bool isSameMonth(DateTime other) =>
      isNotNull && this!.startOfMonth == other.startOfMonth;

  /// Check if this date is in the same year than other
  bool isSameYear(DateTime other) => isNotNull && this!.year == other.year;

  /// Check if two dates are [equals]
  bool equals(DateTime other) => isNotNull && this!.isAtSameMomentAs(other);

  /// Check if a date is [equals] to other
  bool isEqual(other) => equals(other);

  /// Return true if this date day is monday
  bool get isMonday => isNotNull && this!.weekday == DateTime.monday;

  /// Return true if this date day is tuesday
  bool get isTuesday => isNotNull && this!.weekday == DateTime.tuesday;

  /// Return true if this date day is wednesday
  bool get isWednesday => isNotNull && this!.weekday == DateTime.wednesday;

  /// Return true if this date day is thursday
  bool get isThursday => isNotNull && this!.weekday == DateTime.thursday;

  /// Return true if this date day is friday
  bool get isFriday => isNotNull && this!.weekday == DateTime.friday;

  /// Return true if this date day is saturday
  bool get isSaturday => isNotNull && this!.weekday == DateTime.saturday;

  /// Return true if this date day is sunday
  bool get isSunday => isNotNull && this!.weekday == DateTime.sunday;

  /// Is the given date the first day of a month?
  bool get isFirstDayOfMonth => isSameDate(this!.startOfMonth);

  /// Is the given date the last day of a month?
  bool get isLastDayOfMonth =>
      isNotNull &&
      isSameDate(this!.nextMonth.startOfMonth.previousDay.startOfDay);

  /// Return true if this [DateTime] is set as UTC.
  bool get isUTC => isNotNull && this!.isUtc;

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

  /// Boolean check to see if the current date is in the next week.
  ///
  /// Returns `true` if this [DateTime] falls within the next week (starting from
  /// the end of today until the end of the next week). Returns `false` if the
  /// [DateTime] is `null`.
  ///
  /// Example:
  /// ```dart
  /// DateTime? nextMonday = DateTime.now().add(Duration(days: 7));
  /// print(nextMonday.isNextWeek); // Outputs: true if today is not Monday
  /// ```
  bool get isNextWeek {
    if (isNull) return false;

    DateTime now = DateTime.now();
    DateTime startOfNextWeek = now.addDays(7 - now.weekday);
    DateTime endOfNextWeek = startOfNextWeek.addDays(6);

    return this!.isAfter(now) && this!.isBefore(endOfNextWeek);
  }

  /// Boolean check to see if the current date is in the last week.
  ///
  /// Returns `true` if this [DateTime] falls within the last week (from the start
  /// of last week until the end of the previous day). Returns `false` if the
  /// [DateTime] is `null`.
  ///
  /// Example:
  /// ```dart
  /// DateTime? lastWednesday = DateTime.now().subtract(Duration(days: 7 + DateTime.now().weekday - 3));
  /// print(lastWednesday.isLastWeek); // Outputs: true if today is Wednesday
  /// ```
  bool get isLastWeek {
    if (isNull) return false;

    DateTime now = DateTime.now();
    DateTime startOfLastWeek = now.startOfLastWeek;
    DateTime endOfLastWeek = startOfLastWeek.endOfWeek;

    return this!.isAfter(startOfLastWeek) && this!.isBefore(endOfLastWeek);
  }

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

  /// Checks if a [DateTime] is within a given [DateTimeRange].
  ///
  /// Returns `true` if this [DateTime] is not null and falls within the provided
  /// [range], inclusive of the start and end dates. Returns `false` if the
  /// [DateTime] is `null`.
  ///
  /// Example:
  /// ```dart
  /// DateTime? date = DateTime.now();
  /// DateTimeRange range = DateTimeRange(start: DateTime.now().subtract(Duration(days: 1)), end: DateTime.now().add(Duration(days: 1)));
  /// print(date.isWithinRange(range)); // Outputs: true
  /// ```
  bool isWithinRange(DateTimeRange range) => isNotNull && range.includes(this!);

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
    return month.toMonth(style: style);
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
    return weekday.toDay(style: style);
  }

  /// Returns a greeting based on the current time of day.
  ///
  /// Returns "Good Morning" if the hour is between 5:00 and 11:59 AM,
  /// "Good Afternoon" if the hour is between 12:00 and 4:59 PM,
  /// and "Good Night" for all other times.
  String toGreeting() {
    int hour = this.hour;

    if (hour >= 5 && hour < 12) {
      return "Good Morning";
    } else if (hour >= 12 && hour < 17) {
      return "Good Afternoon";
    } else {
      return "Good Night";
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
    final String fullDateTime = "$fullDate $fullTime";

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

  /// Calculates the age based on the current date.
  ///
  /// Returns the age in years.
  int get toAge => ((DateTime.now().difference(this).inDays) ~/ 365);

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

  /// Calculates the difference in years between this date and [other].
  ///
  /// Returns the number of full years between the two dates, considering whole days.
  int differenceInYear(DateTime other) {
    Duration difference = this.difference(other);
    int years = difference.inDays ~/ 365;

    return years;
  }

  /// Calculates the difference in months between this date and [other].
  ///
  /// Returns the number of full months between the two dates, considering whole days.
  int differenceInMonth(DateTime other) {
    Duration difference = this.difference(other);
    int months = (difference.inDays % 365) ~/ 30;

    return months;
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

  /// Truncates the time portion of the [DateTime] object.
  ///
  /// Returns a new [DateTime] instance with the same year, month, and day,
  /// but the time set to midnight (00:00:00).
  DateTime truncateTime() => DateTime(year, month, day);

  /// Creates a [DateTimeRange] from [this] to [other].
  ///
  /// If [this] is after [other], the range is swapped to maintain chronological order.
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

    return (timeZoneOffset.isNegative ? "-" : "+") +
        hours.toString().padLeft(2, '0') +
        (separateWithColon ? ":" : "") +
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
  }) {
    return parse(this, format: format, utc: utc)?.toString().split('.')[0];
  }

  String? detectDateFormat() {
    if (isBlank) return null;

    String? finalPattern;
    List<String> patternsFound = [];

    for (final entry in Regex.dateFormats.entries) {
      final regex = RegExp(entry.key);
      if (matches(regex: regex)) {
        // return entry.value;
        patternsFound.add(entry.value);
      }
    }

    if (patternsFound.isNotEmpty && patternsFound.length > 1) {
      for (String pattern in patternsFound) {
        bool validatePattern =
            validateDatePattern(expected: this!, pattern: pattern);
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
    String pattern = "yyyy-MM-dd HH:mm:ss",
    required String expected,
  }) {
    if (isBlank) return false;

    try {
      DateTime dateTime = DateFormat(pattern).parse(this!);
      String formattedDate = DateFormat(pattern).format(dateTime);
      return formattedDate == expected;
    } catch (e) {
      return false;
    }
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
        DateTime dateTime = format.parse(dt!, utc).toLocal();

        return dateTime;
      } catch (e) {
        String? detectedDateFormat = dt.detectDateFormat();

        if (detectedDateFormat == null) return null;

        try {
          DateFormat outputFormat = DateFormat(detectedDateFormat);
          DateTime? result = outputFormat.tryParse(dt!, utc);

          return result;
        } catch (e) {
          return null;
        }
      }
    }
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
  String toMonth({Abbreviation style = Abbreviation.none}) {
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
  /// print(1.toDay()); // Output: Monday
  /// print(1.toDay(style: Abbreviation.semi)); // Output: Mon
  /// print(1.toDay(style: Abbreviation.full)); // Output: M
  /// ```
  String toDay({Abbreviation style = Abbreviation.none}) {
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
}

extension DateTimeOperators on DateTime {
  /// Adds a [Duration] to this [DateTime] and returns the resulting [DateTime].
  ///
  /// This operator allows for concise addition of durations to dates.
  DateTime operator +(Duration other) => add(other);

  /// Subtracts a [Duration] from this [DateTime] and returns the resulting [DateTime].
  ///
  /// This operator allows for concise subtraction of durations from dates.
  DateTime operator -(Duration other) => subtract(other);

  /// Compares if this [DateTime] is greater than [other].
  ///
  /// Returns `true` if this date is after [other], otherwise `false`.
  bool operator >(DateTime other) => isAfter(other);

  /// Compares if this [DateTime] is less than [other].
  ///
  /// Returns `true` if this date is before [other], otherwise `false`.
  bool operator <(DateTime other) => isBefore(other);

  /// Compares if this [DateTime] is greater than or equal to [other].
  ///
  /// Returns `true` if this date is after or at the same moment as [other].
  bool operator >=(DateTime other) => isAfter(other) || isAtSameMomentAs(other);

  /// Compares if this [DateTime] is less than or equal to [other].
  ///
  /// Returns `true` if this date is before or at the same moment as [other].
  bool operator <=(DateTime other) =>
      isBefore(other) || isAtSameMomentAs(other);

  /// Checks if this [DateTime] is equal to [other].
  ///
  /// Returns `true` if both dates represent the same moment in time.
  bool equals(DateTime other) => isAtSameMomentAs(other);
}

extension DateTimeIterables on DateTime {
  /// Generates an iterable sequence of dates between `this` date and `end` date,
  /// optionally including or excluding both start and end dates based on [inclusive],
  /// with a specified [by] step.
  ///
  /// If [forceIncludeLast] is set to true and the step (`by`) exceeds the end date,
  /// the last possible date will be included which does not exceeds [end].
  ///
  /// Dates are yielded in ascending order, adjusting for changes in timezone
  /// offset during iteration.
  ///
  /// Example usage:
  ///
  /// ```dart
  /// DateTime startDate = DateTime(2024, 6, 1);
  /// DateTime endDate = startDate.endOfMonth;
  ///
  /// Iterable<DateTime> dates = startDate.to(endDate, inclusive: false, by: const Duration(days: 5));
  ///
  /// for (var date in dates) {
  ///   print(date.toIso8601String());
  /// }
  /// ```
  Iterable<DateTime> to(
    DateTime end, {
    Duration by = const Duration(days: 1),
    bool inclusive = true,
    bool forceIncludeLast = false,
  }) sync* {
    DateTime current = this;

    if (current == end && !inclusive) return;

    if (current.isBefore(end) || (inclusive && current.isAtSameMomentAs(end))) {
      while (current.isBefore(end) ||
          (inclusive && current.isAtSameMomentAs(end))) {
        yield current;
        current = current.add(by);
      }
    } else {
      while (current.isAfter(end) ||
          (inclusive && current.isAtSameMomentAs(end))) {
        yield current;
        current = current.subtract(by);
      }
    }

    // Check if we need to force include the last date
    if (forceIncludeLast &&
        current != end &&
        (current.isAfter(end) || current.isAtSameMomentAs(end))) {
      yield end;
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

  /// Returns the index of the closest date to the current [DateTime]
  /// from the given [Iterable] of dates. Returns `null` if the iterable is empty.
  ///
  /// Example:
  /// ```dart
  /// DateTime today = DateTime.now();
  /// List<DateTime> dates = [DateTime(2024, 1, 1), DateTime(2024, 6, 15)];
  /// int? closestIndex = today.closestIndexTo(dates);
  /// ```
  int? closestIndexTo(Iterable<DateTime> datesArray) {
    if (datesArray.isEmpty) return null;

    var index = 0;
    var minDifference = datesArray.first.difference(this).abs();

    for (var i = 1; i < datesArray.length; i++) {
      var difference = datesArray.elementAt(i).difference(this).abs();
      if (difference < minDifference) {
        minDifference = difference;
        index = i;
      }
    }

    return index;
  }

  /// Returns the closest date to the current [DateTime] from the given
  /// [Iterable] of dates. Returns `null` if the iterable is empty.
  ///
  /// Example:
  /// ```dart
  /// DateTime today = DateTime.now();
  /// List<DateTime> dates = [DateTime(2024, 1, 1), DateTime(2024, 6, 15)];
  /// DateTime? closestDate = today.closestTo(dates);
  /// ```
  DateTime? closestTo(Iterable<DateTime> datesArray) {
    if (datesArray.isEmpty) return null;

    final index = closestIndexTo(datesArray);
    return index != null ? datesArray.elementAt(index) : null;
  }
}

extension DateTimeMaths on DateTime {
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
  DateTime addYears(int years) => clone.setYear(year + years);

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
  DateTime addMonths(int months) => clone.setMonth(month + months);

  /// Add a certain amount of quarters to this date.
  ///
  /// Each quarter is equivalent to 3 months.
  ///
  /// For example:
  /// (2020, 12, 31) -> add 1 quarter -> (2021, 3, 31).
  /// (2020, 12, 31) -> add 2 quarters -> (2021, 6, 30).
  DateTime addQuarters(int quarters) => addMonths(quarters * 3);

  /// Returns the [DateTime] resulting from adding the given number
  /// of weeks to this [DateTime].
  ///
  /// The result is computed by incrementing the day parts of this
  /// [DateTime] by [weeks] weeks.
  ///
  /// For example:
  /// (2020, 12, 31) -> add 1 week -> (2021, 1, 7).
  /// (2020, 12, 31) -> add 14 weeks -> (2021, 4, 8).
  DateTime addWeeks(int weeks) => addDays(DateTime.daysPerWeek * weeks);

  /// Returns the [DateTime] resulting from adding the given number
  /// of days to this [DateTime].
  ///
  /// The result is computed by incrementing the day parts of this
  /// [DateTime] by [days] days.
  ///
  /// For example:
  /// (2020, 12, 31) -> add 2 days -> (2021, 1, 2).
  /// (2020, 12, 31) -> add 14 days -> (2021, 1, 14).
  DateTime addDays(int days) => copyWith(day: day + days);

  /// Adds a specified number of business days to this [DateTime].
  ///
  /// Business days are considered as Monday to Friday.
  ///
  /// For example:
  /// (2024-05-01) -> add 10 business days -> (2024-05-15).
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

  /// Returns the [DateTime] resulting from adding the given number
  /// of hours to this [DateTime].
  ///
  /// For example:
  /// (2020-12-31 12:00:00) -> add 2 hours -> (2020-12-31 14:00:00).
  /// (2020-12-31 23:00:00) -> add 5 hours -> (2021-01-01 04:00:00).
  DateTime addHours(int hours) => add(Duration(hours: hours));

  /// Returns the [DateTime] resulting from adding the given number
  /// of minutes to this [DateTime].
  ///
  /// For example:
  /// (2020-12-31 12:00:00) -> add 30 minutes -> (2020-12-31 12:30:00).
  /// (2020-12-31 23:45:00) -> add 15 minutes -> (2020-12-31 23:59:00).
  DateTime addMinutes(int minutes) => add(Duration(minutes: minutes));

  /// Returns the [DateTime] resulting from subtracting the given number
  /// of years from this [DateTime].
  ///
  /// The result is computed by decrementing the year part of this
  /// [DateTime] by [years] years, and, if required, adjusting the day part
  /// of the resulting date upwards to the last day of the month
  /// in the resulting year.
  ///
  /// For example:
  /// (2022, 12, 31) -> subtract 2 years -> (2020, 12, 31).
  /// (2021, 02, 28) -> subtract 1 year -> (2020, 02, 28).
  DateTime subtractYears(int years) => clone.setYear(year - years);

  /// Returns the [DateTime] resulting from subtracting the given number
  /// of months from this [DateTime].
  ///
  /// The result is computed by decrementing the month parts of this
  /// [DateTime] by [months] months, and, if required, adjusting the day part
  /// of the resulting date upwards to the last day of the resulting month.
  ///
  /// For example:
  /// (2021, 2, 28) -> subtract 2 months -> (2020, 12, 28).
  /// (2021, 1, 31) -> subtract 1 month -> (2020, 12, 31).
  DateTime subtractMonths(int months) => clone.setMonth(month - months);

  /// Subtracts a specified number of quarters from this [DateTime].
  ///
  /// Each quarter is equivalent to 3 months.
  ///
  /// For example:
  /// (2021-03-31) -> subtract 1 quarter -> (2020-12-31).
  /// (2021-06-30) -> subtract 2 quarters -> (2020-12-31).
  DateTime subtractQuarters(int quarters) => addMonths(-quarters * 3);

  /// Subtracts a specified number of days from this [DateTime].
  ///
  /// For example:
  /// (2021-01-02) -> subtract 2 days -> (2020-12-31).
  /// (2021-01-15) -> subtract 14 days -> (2020-12-31).
  DateTime subtractDays(int days) => subtract(Duration(days: days));

  /// Subtracts a specified number of business days from this [DateTime].
  ///
  /// Business days are considered as Monday to Friday.
  ///
  /// For example:
  /// (2024-05-31) -> subtract 10 business days -> (2024-05-15).
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

  /// Subtracts a specified number of hours from this [DateTime].
  ///
  /// For example:
  /// (2020-12-31 14:00:00) -> subtract 2 hours -> (2020-12-31 12:00:00).
  /// (2021-01-01 04:00:00) -> subtract 5 hours -> (2020-12-31 23:00:00).
  DateTime subtractHours(int hours) => subtract(Duration(hours: hours));

  /// Subtracts a specified number of minutes from this [DateTime].
  ///
  /// For example:
  /// (2020-12-31 12:30:00) -> subtract 30 minutes -> (2020-12-31 12:00:00).
  /// (2020-12-31 23:59:00) -> subtract 15 minutes -> (2020-12-31 23:45:00).
  DateTime subtractMinutes(int minutes) => subtract(Duration(minutes: minutes));
}

extension DateTimeGetters on DateTime {
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
  /// Returns a new [DateTime] instance set to the start of the year (January 1st, 00:00:00).
  DateTime get startOfYear => DateTime(year, 1, 1, 0, 0, 0, 0);

  /// Returns the starting [DateTime] of the current month.
  ///
  /// Returns a new [DateTime] instance set to the start of the month (first day, 00:00:00).
  DateTime get startOfMonth => DateTime(year, month, 1, 0, 0, 0, 0);

  /// Returns the starting [DateTime] of the current week.
  ///
  /// Returns a new [DateTime] instance set to the start of the week (Monday, 00:00:00).
  /// Reference: https://stackoverflow.com/questions/62872349/dart-flutter-get-first-datetime-of-this-week
  DateTime get startOfWeek => subtract(Duration(days: weekday - 1)).startOfDay;

  /// Returns the starting [DateTime] of the previous week.
  ///
  /// Returns a new [DateTime] instance set to the start of the previous week (Monday, 00:00:00).
  DateTime get startOfLastWeek => startOfDay.subtractDays(7).startOfWeek;

  /// Returns the starting [DateTime] of the current day.
  ///
  /// Returns a new [DateTime] instance set to the start of the day (00:00:00).
  DateTime get startOfDay => clone.setHour(0, 0, 0, 0, 0);

  /// Returns the starting [DateTime] of the current hour.
  ///
  /// Returns a new [DateTime] instance set to the start of the hour (HH:00:00).
  DateTime get startOfHour => clone.setMinute(0, 0, 0, 0);

  /// Returns the end of the year for this date. The result will be in the local timezone.
  DateTime get endOfYear => clone.setYear(year, DateTime.december).endOfMonth;

  /// Returns the ending [DateTime] of the current month.
  ///
  /// Returns a new [DateTime] instance set to the end of the month.
  DateTime get endOfMonth => DateTime(year, month + 1, 0).startOfDay;

  /// Returns the ending [DateTime] of the current week.
  ///
  /// Returns a new [DateTime] instance set to the end of the week.
  DateTime get endOfWeek =>
      add(Duration(days: DateTime.daysPerWeek - weekday)).startOfDay;

  /// Returns the end of the next week from the current date.
  DateTime get endOfNextWeek => endOfDay.addDays(7);

  /// Return the end of a day for this date. The result will be in the local timezone.
  DateTime get endOfDay => clone.setHour(23, 59, 59, 999, 999);

  /// Return the end of the hour for this date. The result will be in the local timezone.
  DateTime get endOfHour => clone.setMinute(59, 59, 999, 999);

  /// The year after this [DateTime]
  DateTime get nextYear => clone.setYear(year + 1);

  /// The year previous this [DateTime]
  DateTime get previousYear => clone.setYear(year - 1);

  /// The month after this [DateTime]
  DateTime get nextMonth => clone.setMonth(month + 1);

  /// The month previous this [DateTime]
  DateTime get previousMonth => clone.setMonth(month - 1);

  /// The week after this [DateTime]
  DateTime get nextWeek => addDays(7);

  /// The week previous this [DateTime]
  DateTime get previousWeek => subtractDays(7);

  DateTime get nextDay => addDays(1);

  /// The day previous this [DateTime]
  DateTime get previousDay => addDays(-1);

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

  /// Get UTC [DateTime] from this [DateTime]
  DateTime get utc => DateTime.fromMicrosecondsSinceEpoch(
        microsecondsSinceEpoch,
        isUtc: true,
      );

  /// Get Local [DateTime] from this [DateTime]
  DateTime get local => DateTime.fromMicrosecondsSinceEpoch(
        microsecondsSinceEpoch,
        isUtc: false,
      );
}

extension DateTimeSetters on DateTime {
  /// Change [year] of this date
  ///
  /// set [month] if you want to change it as well, to skip an change other optional field set it as [null]
  /// set [day] if you want to change it as well, to skip an change other optional field set it as [null]
  /// set [hour] if you want to change it as well, to skip an change other optional field set it as [null]
  /// set [minute] if you want to change it as well, to skip an change other optional field set it as [null]
  /// set [second] if you want to change it as well, to skip an change other optional field set it as [null]
  /// set [millisecond] if you want to change it as well, to skip an change other optional field set it as [null]
  /// set [microsecond] if you want to change it as well
  DateTime setYear(
    int year, [
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  ]) =>
      DateTime(
        year,
        month ?? this.month,
        day ?? this.day,
        hour ?? this.hour,
        minute ?? this.minute,
        second ?? this.second,
        millisecond ?? this.millisecond,
        microsecond ?? this.microsecond,
      );

  /// Change [month] of this date
  ///
  /// set [day] if you want to change it as well, to skip an change other optional field set it as [null]
  /// set [hour] if you want to change it as well, to skip an change other optional field set it as [null]
  /// set [minute] if you want to change it as well, to skip an change other optional field set it as [null]
  /// set [second] if you want to change it as well, to skip an change other optional field set it as [null]
  /// set [millisecond] if you want to change it as well, to skip an change other optional field set it as [null]
  /// set [microsecond] if you want to change it as well
  DateTime setMonth(
    int month, [
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  ]) =>
      DateTime(
        year,
        month,
        day ?? this.day,
        hour ?? this.hour,
        minute ?? this.minute,
        second ?? this.second,
        millisecond ?? this.millisecond,
        microsecond ?? this.microsecond,
      );

  /// Change [weekday] of this date
  ///
  /// set [weekStartsOn] if you want to use any other day as the start of the week
  DateTime setWeekDay(int weekday, [int weekStartsOn = DateTime.sunday]) {
    const daysPerWeek = DateTime.daysPerWeek;
    final currentDay = this.weekday;
    final reminder = weekday % daysPerWeek;
    final dayIndex = (reminder + daysPerWeek) % daysPerWeek;
    final delta = daysPerWeek - weekStartsOn;
    final diff = weekday < 0 || weekday > 6
        ? weekday - ((currentDay + delta) % daysPerWeek)
        : ((dayIndex + delta) % daysPerWeek) -
            ((currentDay + delta) % daysPerWeek);

    return addDays(diff);
  }

  /// Change [day] of this date
  ///
  /// set [hour] if you want to change it as well, to skip an change other optional field set it as [null]
  /// set [minute] if you want to change it as well, to skip an change other optional field set it as [null]
  /// set [second] if you want to change it as well, to skip an change other optional field set it as [null]
  /// set [millisecond] if you want to change it as well, to skip an change other optional field set it as [null]
  /// set [microsecond] if you want to change it as well
  DateTime setDay(
    int day, [
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  ]) =>
      DateTime(
        year,
        month,
        day,
        hour ?? this.hour,
        minute ?? this.minute,
        second ?? this.second,
        millisecond ?? this.millisecond,
        microsecond ?? this.microsecond,
      );

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

  /// Change [minute] of this date
  ///
  /// set [second] if you want to change it as well, to skip an change other optional field set it as [null]
  /// set [millisecond] if you want to change it as well, to skip an change other optional field set it as [null]
  /// set [microsecond] if you want to change it as well
  DateTime setMinute(
    int minute, [
    int? second,
    int? millisecond,
    int? microsecond,
  ]) =>
      DateTime(
        year,
        month,
        day,
        hour,
        minute,
        second ?? this.second,
        millisecond ?? this.millisecond,
        microsecond ?? this.microsecond,
      );

  /// Change [second] of this date
  ///
  /// set [millisecond] if you want to change it as well, to skip an change other optional field set it as [null]
  /// set [microsecond] if you want to change it as well
  DateTime setSecond(
    int second, [
    int? millisecond,
    int? microsecond,
  ]) =>
      DateTime(
        year,
        month,
        day,
        hour,
        minute,
        second,
        millisecond ?? this.millisecond,
        microsecond ?? this.microsecond,
      );

  /// Change [millisecond] of this date
  ///
  /// set [microsecond] if you want to change it as well
  DateTime setMillisecond(
    int millisecond, [
    int? microsecond,
  ]) =>
      DateTime(
        year,
        month,
        day,
        hour,
        minute,
        second,
        millisecond,
        microsecond ?? this.microsecond,
      );

  /// Change [microsecond] of this date
  DateTime setMicrosecond(
    int microsecond,
  ) =>
      DateTime(
        year,
        month,
        day,
        hour,
        minute,
        second,
        millisecond,
        microsecond,
      );
}

extension Date on DateTime {
  /// Tomorrow at same hour / minute / second than now
  static DateTime tomorrow() => DateTime.now().nextDay;

  /// Yesterday at same hour / minute / second than now
  static DateTime yesterday() => DateTime.now().previousDay;

  /// Current date (Same as [Date.now])
  static DateTime today() => DateTime.now();

  static DateTime nowWithTimezone(bool isUtc) {
    if (isUtc) {
      return DateTime.now().toUtc();
    }

    return DateTime.now();
  }

  static DateTime withTimezone(
    bool isUtc,
    int year, [
    int month = 1,
    int day = 1,
    int hour = 0,
    int minute = 0,
    int second = 0,
    int millisecond = 0,
    int microsecond = 0,
  ]) {
    if (isUtc) {
      return DateTime.utc(
        year,
        month,
        day,
        hour,
        minute,
        second,
        millisecond,
        microsecond,
      );
    }
    return DateTime(
      year,
      month,
      day,
      hour,
      minute,
      second,
      millisecond,
      microsecond,
    );
  }

  static DateTime dateWithTimezone(
    int year, [
    int month = 1,
    int day = 1,
    bool isUtc = false,
  ]) {
    if (isUtc) {
      return DateTime.utc(
        year,
        month,
        day,
        0,
        0,
        0,
        0,
        0,
      );
    }
    return DateTime(
      year,
      month,
      day,
      0,
      0,
      0,
      0,
      0,
    );
  }

  /// Returns true if left [isBefore] than right
  static DateTime min(DateTime left, DateTime right) =>
      (left < right) ? left : right;

  /// Returns true if left [isAfter] than right
  static DateTime max(DateTime left, DateTime right) =>
      (left < right) ? right : left;

  /// Compare the two dates and return 1 if the first date [isAfter] the second,
  /// -1 if the first date [isBefore] the second or 0 first date [isEqual] the second.
  static int compareAsc(DateTime dateLeft, DateTime dateRight) {
    if (dateLeft.isAfter(dateRight)) {
      return 1;
    } else if (dateLeft.isBefore(dateRight)) {
      return -1;
    } else {
      return 0;
    }
  }

  /// Compare the two dates and return -1 if the first date [isAfter] the second,
  /// 1 if the first date [isBefore] the second or 0 first date [isEqual] the second.
  static int compareDesc(DateTime dateLeft, DateTime dateRight) =>
      (-1) * compareAsc(dateLeft, dateRight);
}

extension WeekdayFinder on DateTime {
  /// Returns new [DateTime] instance of nearest `n`th weekday in the future
  ///
  /// If `n`th day is today, will return `7 days in the future`.
  DateTime nextWeekday(int weekday) {
    assert(weekday > -1 && weekday < 8,
        "[moment_dart] Weekday must be in range `0<=n<=7`");

    final int requiredDelta = (weekday - this.weekday) % 7;

    return this + Duration(days: requiredDelta == 0 ? 7 : requiredDelta);
  }

  /// Returns new [DateTime] instance of nearest Monday in the Future
  ///
  /// If [this] is Monday, will return `7 days in the future`
  DateTime nextMonday() => nextWeekday(DateTime.monday);

  /// Returns new [DateTime] instance of nearest Tuesday in the Future
  ///
  /// If [this] is Tuesday, will return `7 days in the future`
  DateTime nextTuesday() => nextWeekday(DateTime.tuesday);

  /// Returns new [DateTime] instance of nearest Wednesday in the Future
  ///
  /// If [this] is Wednesday, will return `7 days in the future`
  DateTime nextWednesday() => nextWeekday(DateTime.wednesday);

  /// Returns new [DateTime] instance of nearest Thursday in the Future
  ///
  /// If [this] is Thursday, will return `7 days in the future`
  DateTime nextThursday() => nextWeekday(DateTime.thursday);

  /// Returns new [DateTime] instance of nearest Friday in the Future
  ///
  /// If [this] is Friday, will return `7 days in the future`
  DateTime nextFriday() => nextWeekday(DateTime.friday);

  /// Returns new [DateTime] instance of nearest Saturday in the Future
  ///
  /// If [this] is Saturday, will return `7 days in the future`
  DateTime nextSaturday() => nextWeekday(DateTime.saturday);

  /// Returns new [DateTime] instance of nearest Sunday in the Future
  ///
  /// If [this] is Sunday, will return `7 days in the future`
  DateTime nextSunday() => nextWeekday(DateTime.sunday);

  /// Returns new [DateTime] instance of last `n`th weekday
  ///
  /// If today is the `n`th day, will return `7 days in the past`
  DateTime lastWeekday(int weekday) {
    assert(weekday > -1 && weekday < 8,
        "[Moment Dart] Weekday must be in range `0<=n<=7`");

    final int requiredDelta = (this.weekday - weekday) % 7;

    return this - Duration(days: requiredDelta == 0 ? 7 : requiredDelta);
  }

  /// Returns new [DateTime] instance of nearest Monday in the past
  ///
  /// If [this] is Monday, will return `7 days in the past`
  DateTime lastMonday() => lastWeekday(DateTime.monday);

  /// Returns new [DateTime] instance of nearest Tuesday in the past
  ///
  /// If [this] is Tuesday, will return `7 days in the past`
  DateTime lastTuesday() => lastWeekday(DateTime.tuesday);

  /// Returns new [DateTime] instance of nearest Wednesday in the past
  ///
  /// If [this] is Wednesday, will return `7 days in the past`
  DateTime lastWednesday() => lastWeekday(DateTime.wednesday);

  /// Returns new [DateTime] instance of nearest Thursday in the past
  ///
  /// If [this] is Thursday, will return `7 days in the past`
  DateTime lastThursday() => lastWeekday(DateTime.thursday);

  /// Returns new [DateTime] instance of nearest Friday in the past
  ///
  /// If [this] is Friday, will return `7 days in the past`
  DateTime lastFriday() => lastWeekday(DateTime.friday);

  /// Returns new [DateTime] instance of nearest Saturday in the past
  ///
  /// If [this] is Saturday, will return `7 days in the past`
  DateTime lastSaturday() => lastWeekday(DateTime.saturday);

  /// Returns new [DateTime] instance of nearest Sunday in the past
  ///
  /// If [this] is Sunday, will return `7 days in the past`
  DateTime lastSunday() => lastWeekday(DateTime.sunday);
}
