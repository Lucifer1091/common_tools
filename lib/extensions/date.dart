part of 'extensions.dart';

class DateFormats {
  DateFormats._();

// TODO : ADD static Default Formats like this
  static const defaultX = 'yyyy-MM-dd HH:mm:ss';
  static const dateTime = 'MMM dd, yyyy h:mm a';
  static const date = 'MMM dd, yyyy';
  static const time = 'h:mm a';
}

extension DateExtension on DateTime {
  String format({
    String pattern = DateFormats.dateTime,
    String locale = 'en_US',
  }) =>
      DateFormat(pattern, locale).format(this);

  //
  // /// Check if the string is a date
  // bool get isDate => v.isDate(this);
  //
  // /// Check if the string is a date that's after the specified date
  // ///
  // /// If `date` is not passed, it defaults to now.
  // bool isAfter([String? date]) => v.isAfter(this, date);
  //
  // /// Check if the string is a date that's before the specified date
  // ///
  // /// If `date` is not passed, it defaults to now.
  // bool isBefore([String? date]) => v.isBefore(this, date);
  //
  //
  // /// check if the string is a date
  // bool isDate(String str) {
  //   return DateTime.tryParse(str) != null;
  // }
  //
  // /// check if the string is a date that's after the specified date
  // ///
  // /// If `date` is not passed, it defaults to now.
  // bool isAfter(String str, [String? date]) {
  //   DateTime referenceDate;
  //   if (date == null) {
  //     referenceDate = DateTime.now();
  //   } else if (isDate(date)) {
  //     referenceDate = DateTime.parse(date);
  //   } else {
  //     return false;
  //   }
  //
  //   final strDate = DateTime.tryParse(str);
  //   if (strDate == null) return false;
  //
  //   return strDate.isAfter(referenceDate);
  // }
  //
  // /// check if the string is a date that's before the specified date
  // ///
  // /// If `date` is not passed, it defaults to now.
  // bool isBefore(String str, [String? date]) {
  //   DateTime referenceDate;
  //   if (date == null) {
  //     referenceDate = DateTime.now();
  //   } else if (isDate(date)) {
  //     referenceDate = DateTime.parse(date);
  //   } else {
  //     return false;
  //   }
  //
  //   final strDate = DateTime.tryParse(str);
  //   if (strDate == null) return false;
  //
  //   return strDate.isBefore(referenceDate);
  // }

  String toDate() => DateFormat.yMd().format(this);

  String toTime() => DateFormat.jm().format(this);

  String toDateTime() => DateFormat(DateFormats.dateTime).format(this);

  int get totalMinutes => hour * 60 + minute;

  TimeOfDay get timeOfDay => TimeOfDay(hour: hour, minute: minute);

  String get timeAgo {
    final now = DateTime.now().toUtc();
    final self = toUtc();
    final diff = now.difference(self);
    final sec = diff.inSeconds;
    if (sec < 0) {
      return format(pattern: 'yyyy.M.d');
    }

    if (diff.inDays > 365) {
      return "${(diff.inDays / 365).floor()} ${(diff.inDays / 365).floor() == 1 ? "year" : "years"} ago";
    }
    if (diff.inDays > 30) {
      return "${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1 ? "month" : "months"} ago";
    }
    if (diff.inDays > 7) {
      return "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1 ? "week" : "weeks"} ago";
    } else if (diff.inDays > 0) {
      return "${diff.inDays} ${diff.inDays == 1 ? "day" : "days"} ago";
    } else if (diff.inHours > 0) {
      return "${diff.inHours} ${diff.inHours == 1 ? "hour" : "hours"} ago";
    } else if (diff.inMinutes > 0) {
      return "${diff.inMinutes} ${diff.inMinutes == 1 ? "minute" : "minutes"} ago";
    } else {
      return "$sec ${sec == 1 ? "second" : "seconds"} ago";
    }

    // if (sec >= 60 * 60 * 24 * 30) {
    //   return format(pattern: 'yyyy.M.d');
    // } else if (sec >= 60 * 60 * 24) {
    //   return '${difference.inDays.toString()} days ago';
    // } else if (sec >= 60 * 60) {
    //   return '${difference.inHours.toString()} hours ago';
    // } else if (sec >= 60) {
    //   return '${difference.inMinutes.toString()} minutes ago';
    // } else {
    //   return '$sec seconds ago';
    // }
  }

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

  DateTime get clone => DateTime.fromMicrosecondsSinceEpoch(
        microsecondsSinceEpoch,
        isUtc: isUtc,
      );

  DateTime get startOfYear => DateTime(year, 1).startOfDay;

  DateTime get endOfYear => DateTime(year, 12, 31).startOfDay;

  DateTime get startOfDay => clone.setHour(0, 0, 0, 0, 0);

  DateTime get endOfDay => clone.setHour(23, 59, 59, 59, 59);

  /// https://stackoverflow.com/questions/62872349/dart-flutter-get-first-datetime-of-this-week
  DateTime get startOfWeek => subtract(Duration(days: weekday - 1)).startOfDay;

  DateTime get endOfWeek =>
      add(Duration(days: DateTime.daysPerWeek - weekday)).startOfDay;

  /// Calculates number of weeks for a given year as per https://en.wikipedia.org/wiki/ISO_week_date#Weeks_per_year
  int _numOfWeeks(int year) {
    DateTime dec28 = DateTime(year, 12, 28);
    int dayOfDec28 = int.parse(DateFormat("D").format(dec28));
    return ((dayOfDec28 - dec28.weekday + 10) / 7).floor();
  }

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

  DateTime get startOfMonth => DateTime(year, month).startOfDay;

  DateTime get endOfMonth => DateTime(year, month + 1, 0).startOfDay;

  DateTime get nextMonth => DateTime(year, month + 1);

  DateTime get beforeDay => DateTime(year, month, day - 1).startOfDay;

  DateTime get nextDay => DateTime(year, month, day + 1).startOfDay;

  int calculateAge() {
    return ((DateTime.now().difference(this).inDays) ~/ 365);
  }

  DateTime nearestQuarter() {
    return DateTime(
        year, month, day, hour, [15, 30, 45, 60][(minute / 15).floor()]);
  }

  DateTime nearestHalf() {
    return DateTime(year, month, day, hour, [30, 60][(minute / 30).floor()]);
  }

  DateTime nearestHalfHour() {
    return DateTime(year, month, day, hour, [0, 30, 60][(minute / 30).round()]);
  }

  String get weekdayToFullString {
    switch (weekday) {
      case DateTime.monday:
        return "Monday";
      case DateTime.tuesday:
        return "Tuesday";
      case DateTime.wednesday:
        return "Wednesday";
      case DateTime.thursday:
        return "Thursday";
      case DateTime.friday:
        return "Friday";
      case DateTime.saturday:
        return "Saturday";
      case DateTime.sunday:
        return "Sunday";
      default:
        return "Error";
    }
  }

  String get weekdayToAbbreviatedString {
    switch (weekday) {
      case DateTime.monday:
        return "M";
      case DateTime.tuesday:
        return "T";
      case DateTime.wednesday:
        return "W";
      case DateTime.thursday:
        return "T";
      case DateTime.friday:
        return "F";
      case DateTime.saturday:
        return "S";
      case DateTime.sunday:
        return "S";
      default:
        return "Err";
    }
  }
}

extension DateTimeCompare on DateTime? {
  // date > other => true
  // date <= other => false
  bool isGreater(DateTime other) {
    if (this == null) return false;

    final date = this!;
    return date.toUtc().isAfter(other.toUtc());
  }

  bool isAfterOrEqualTo(DateTime other) {
    if (this == null) return false;

    final date = this!;
    final isAtSameMomentAs = other.isAtSameMomentAs(date);
    return isAtSameMomentAs | date.isAfter(other);
  }

  bool isBeforeOrEqualTo(DateTime other) {
    if (this == null) return false;

    final date = this!;
    final isAtSameMomentAs = other.isAtSameMomentAs(date);
    return isAtSameMomentAs | date.isBefore(other);
  }

  bool isBetween(DateTime from, DateTime to) {
    if (this == null) return false;

    final date = this!;
    final isAfter = date.isAfterOrEqualTo(from);
    final isBefore = date.isBeforeOrEqualTo(to);
    return isAfter && isBefore;
  }

  bool isSameDate(DateTime other) {
    if (this == null) return false;

    final date = this!;

    return date.year == other.year &&
        date.month == other.month &&
        date.day == other.day;
  }

  bool isSameTime(DateTime other) {
    if (this == null) return false;

    final date = this!;
    return date.hour == other.hour &&
        date.minute == other.minute &&
        date.second == other.second;
  }

  bool isSameDateAndTime(DateTime other) {
    if (this == null) return false;
    final date = this!;

    return date.year == other.year &&
        date.month == other.month &&
        date.day == other.day &&
        date.hour == other.hour &&
        date.minute == other.minute;
  }

  bool isSameLocalDate(DateTime other) {
    if (this == null) return false;

    final a = this!.toLocal();
    final b = other.toLocal();
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  bool isSameMonthLocal(DateTime other) {
    if (this == null) return false;

    final a = this!.toLocal();
    final b = other.toLocal();
    return a.year == b.year && a.month == b.month;
  }
}

extension DateRangeUtils on DateTimeRange? {
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
  /// * dd-mm-yyyyy
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
    if (isBlank) {
      return false;
    }
    var regex = RegExp(
        r'^(?:(?:31(\/|-|\.)(?:0?[13578]|1[02]))\1|(?:(?:29|30)(\/|-|\.)(?:0?[13-9]|1[0-2])\2))(?:(?:1[6-9]|[2-9]\d)?\d{2})$|^(?:29(\/|-|\.)0?2\3(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))$|^(?:0?[1-9]|1\d|2[0-8])(\/|-|\.)(?:(?:0?[1-9])|(?:1[0-2]))\4(?:(?:1[6-9]|[2-9]\d)?\d{2})$');
    if (regex.hasMatch(this!)) {
      return true;
    }
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
  /// String day = date.getDayFromDate(); // returns 'Saturday'
  /// String grDay = date.getDayFromDate(locale:'el'); // returns 'Σάββατο'
  /// ```
  String? getDayFromDate({String locale = 'en'}) {
    initializeDateFormatting(locale);
    if (isBlank) {
      return this;
    }

    var date = DateTime.tryParse(this!);
    if (date == null) {
      return null;
    }
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
  /// String month = date.getMonthFromDate(); // returns 'August'
  /// String grMonth = date.getMonthFromDate(locale:'el'); // returns 'Αυγούστου'
  /// ```
  String? getMonthFromDate({String locale = 'en'}) {
    initializeDateFormatting(locale);
    if (isBlank) {
      return this;
    }

    var date = DateTime.tryParse(this!);
    if (date == null) {
      return null;
    }
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
    if (isBlank) {
      return this;
    }

    var date = DateTime.tryParse(this!);
    if (date == null) {
      return null;
    }
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
    if (isBlank) {
      return this;
    }

    var date = DateTime.tryParse(this!);
    if (date == null) {
      return null;
    }
    return DateFormat('EEEE', locale)
        .format(
          DateTime(date.year, date.month + 1, 1).add(
            const Duration(days: -1),
          ),
        )
        .toString();
  }

  /// Converts the string to a [DateTime] object. Returns null if parsing fails.
  DateTime? toDate() => this != null ? DateTime.tryParse(this!) : null;

  DateTime? toDateTime({String? format}) {
    DateFormat dateFormat = DateFormat(format ?? DateFormats.defaultX);
    try {
      return dateFormat.parse(this ?? '');
    } catch (e) {
      // logStack.f(e);
      return null;
    }
  }

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
}

extension DateIntUtils on int {
  String get weekdayToFullString {
    switch (this) {
      case DateTime.monday:
        return "Monday";
      case DateTime.tuesday:
        return "Tuesday";
      case DateTime.wednesday:
        return "Wednesday";
      case DateTime.thursday:
        return "Thursday";
      case DateTime.friday:
        return "Friday";
      case DateTime.saturday:
        return "Saturday";
      case DateTime.sunday:
        return "Sunday";
      default:
        return "Error";
    }
  }

  String get weekdayToAbbreviatedString {
    switch (this) {
      case DateTime.monday:
        return "M";
      case DateTime.tuesday:
        return "T";
      case DateTime.wednesday:
        return "W";
      case DateTime.thursday:
        return "T";
      case DateTime.friday:
        return "F";
      case DateTime.saturday:
        return "S";
      case DateTime.sunday:
        return "S";
      default:
        return "Err";
    }
  }
}

extension StringToTime on String {
  TimeOfDay stringToTime() {
    final format = DateFormat.jm();
    return TimeOfDay.fromDateTime(format.parse(this));
  }
}

extension TimeConversions on TimeOfDay {
  DateTime toDateTime() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, hour, minute);
  }

  String timeToString() {
    final timeFormat = DateFormat.jm();
    return timeFormat.format(toDateTime());
  }
}

extension TimeX on int {
  String get text {
    final diff = Duration(seconds: this);
    final sec = diff.inSeconds;

    if (diff.inDays > 365) {
      return "${(diff.inDays / 365).floor()} ${(diff.inDays / 365).floor() == 1 ? "year" : "years"}";
    }
    if (diff.inDays > 30) {
      return "${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1 ? "month" : "months"}";
    }
    if (diff.inDays > 7) {
      return "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1 ? "week" : "weeks"}";
    } else if (diff.inDays > 0) {
      return "${diff.inDays} ${diff.inDays == 1 ? "day" : "days"}";
    } else if (diff.inHours > 0) {
      return "${diff.inHours} ${diff.inHours == 1 ? "hour" : "hours"}";
    } else if (diff.inMinutes > 0) {
      return "${diff.inMinutes} ${diff.inMinutes == 1 ? "minute" : "minutes"}";
    } else {
      return "$sec ${sec == 1 ? "second" : "seconds"}";
    }
  }

  String get timeAgo {
    final diff = Duration(seconds: this);
    final sec = diff.inSeconds;

    if (diff.inDays > 365) {
      return "${(diff.inDays / 365).floor()} ${(diff.inDays / 365).floor() == 1 ? "year" : "years"} ago";
    }
    if (diff.inDays > 30) {
      return "${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1 ? "month" : "months"} ago";
    }
    if (diff.inDays > 7) {
      return "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1 ? "week" : "weeks"} ago";
    } else if (diff.inDays > 0) {
      return "${diff.inDays} ${diff.inDays == 1 ? "day" : "days"} ago";
    } else if (diff.inHours > 0) {
      return "${diff.inHours} ${diff.inHours == 1 ? "hour" : "hours"} ago";
    } else if (diff.inMinutes > 0) {
      return "${diff.inMinutes} ${diff.inMinutes == 1 ? "minute" : "minutes"} ago";
    } else {
      return "$sec ${sec == 1 ? "second" : "seconds"} ago";
    }
  }
}
