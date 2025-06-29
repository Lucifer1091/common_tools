import 'dart:math';
import 'package:intl/intl.dart';

import '../date/index.dart';
import '../string/index.dart';
import 'validators.dart';

extension NumConverters on num? {
  /// Get or default given double is not null and returns given value if null.
  num getOr([num value = 0]) => this ?? value;

  double toDouble() => toDoubleOr(0);

  double? toDoubleOrNull() => this?.toDouble();

  double toDoubleOr(double value) => toDoubleOrNull() ?? value;

  int toInt() => toIntOr(0);

  int? toIntOrNull() => this?.toInt();

  int toIntOr(int value) => toIntOrNull() ?? value;

  bool toBool() => toBoolOr(false);

  bool? toBoolOrNull() => isNotNull ? this == 1 : null;

  bool toBoolOr(bool value) => toBoolOrNull() ?? value;

  /// Converts degrees to radians.
  double? degreesToRadians() => isNotNull ? this! * (pi / 180.0) : null;

  /// Converts radians to degrees.
  double? radiansToDegrees() => isNotNull ? this! * (180.0 / pi) : null;

  double asPercentageInDecimal() => getOr() / 100.0;

  double calculatePercentageOf(double percentage) =>
      (getOr() * percentage) / 100.0;

  /// Converts a file size (in bytes) to a specified unit (Bytes, KB, MB, GB, TB).
  ///
  /// The function takes an optional parameter [unit] which specifies the unit to convert the file size to.
  /// The default unit is megabytes (MB).
  ///
  /// If the file size is less than or equal to zero, the function returns 0.
  ///
  /// - Parameter [unit]: An enum value of [SizeUnit] specifying the unit to convert the file size to (default is [SizeUnit.MB]).
  ///
  /// Returns:
  /// - A double representing the file size in the specified unit.
  ///
  /// Example:
  /// ```dart
  /// int fileSizeInBytes = 1048576;
  /// double fileSizeInMB = fileSizeInBytes.fileSize(unit: SizeUnit.MB); // 1.048576
  /// ```
  double fileSize({SizeUnit unit = SizeUnit.MB}) {
    if (isNull || getOr() <= 0) return 0;
    return this! / pow(1000, unit.id);
  }

  /// Converts a file size (in bytes) to a human-readable string with appropriate suffix (Bytes, KB, MB, GB, TB).
  ///
  /// The function takes an optional parameter [dp] which specifies the number of decimal places to include in the output.
  ///
  /// If the file size is less than or equal to zero, the function returns "0 Bytes".
  ///
  /// - Parameter [dp]: An integer specifying the number of decimal places to include in the output (default is 0).
  ///
  /// Returns:
  /// - A string representing the file size in a human-readable format with an appropriate suffix.
  ///
  /// Example:
  /// ```dart
  /// int fileSize = 1048576;
  /// String readableSize = fileSize.fileSizeWithSuffix(dp: 2); // "1.00 MB"
  /// ```
  String fileSizeWithSuffix({int dp = 0}) {
    if (isNull || getOr() <= 0) return '0 bytes';

    const suffixes = ['bytes', 'KB', 'MB', 'GB', 'TB'];
    final i = (log(this!) / log(1024)).floor();
    return '${(this! / pow(1024, i)).toStringAsFixed(dp)} ${suffixes[i]}';
  }

  String get compact => NumberFormat.compact().format(this);

  String get formatComma => NumberFormat().format(this);

  /// Formats the number to a specified number of significant digits.
  ///
  /// The [digit] parameter determines the number of significant digits to retain.
  /// By default, it is set to `2`.
  ///
  /// Example:
  /// ```dart
  /// print(3.14159.toSignificantDigits(digit: 3)); // "3.14"
  /// print(1.toSignificantDigits(digit: 2)); // "01"
  /// ```
  ///
  /// Returns a string representation of the number with the specified precision.
  String toSignificantDigits({int digit = 2}) {
    final NumberFormat formatter = NumberFormat('0' * digit);
    return formatter.format(this);
  }

  /// Returns the ordinal suffix for the integer (e.g., 1st, 2nd, 3rd, 4th, etc.).
  String get ordinal {
    if (isNull) return '0';

    if ([11, 12, 13].contains(this! % 100)) return '${this}th';

    switch (this! % 10) {
      case 1:
        return '${this}st';
      case 2:
        return '${this}nd';
      case 3:
        return '${this}rd';
      default:
        return '${this}th';
    }
  }

  /// Returns the Roman numeral representation of an integer from 1 to 3999
  ///
  /// ```dart
  /// print(12.roman);   // XII
  /// print(455.roman);  // CDLV
  /// print(1.roman);    // I
  /// print(3999.roman); // MMMCMXCIX
  /// ```
  String get roman {
    if (isNull) return '';

    final int value = toIntOr(0);

    if (value < 1 || value > 3999) {
      throw ArgumentError('Number out of range (1 to 3999)');
    }

    final romanMap = {
      1000: 'M',
      900: 'CM',
      500: 'D',
      400: 'CD',
      100: 'C',
      90: 'XC',
      50: 'L',
      40: 'XL',
      10: 'X',
      9: 'IX',
      5: 'V',
      4: 'IV',
      1: 'I',
    };

    var num = value;
    final buffer = StringBuffer();

    for (final entry in romanMap.entries) {
      while (num >= entry.key) {
        buffer.write(entry.value);
        num -= entry.key;
      }
    }

    return buffer.toString();
  }

  double roundWithDigit(int digit) {
    final digitValue = pow(10, digit);
    return (getOr() * digitValue).roundToDouble() / digitValue;
  }

  /// Rounds value [precision] number of fraction points.
  /// Example:
  /// 2.1234567890.roundToPrecision(0)=> 2
  /// 2.1234567890.roundToPrecision(1)=> 2.1
  /// 2.1234567890.roundToPrecision(2)=> 2.12
  /// 2.1234567890.roundToPrecision(3)=> 2.123
  double roundToPrecision(int nthPosition) {
    final NumberFormat formatter = NumberFormat('0.##')
      ..minimumFractionDigits = 0;

    if (isNull) return 0;

    if (this!.isNaN || this!.isInfinite || this == double.negativeInfinity) {
      return toDouble();
    }

    formatter.maximumFractionDigits = nthPosition;
    return double.parse(formatter.format(this));
  }

  double floorWithDigit(int digit) {
    final digitValue = pow(10, digit);
    return (getOr() * digitValue).floorToDouble() / digitValue;
  }

  /// Returns [int] as string which has a zero appended as prefix if [this]
  /// is a single digit value.
  String twoDigits() => getOr() < 10 ? '0$this' : toString();

  /// get last charts of give value
  /// 'I  like dart language'.lastChars(13) // dart language
  int lastDigits(int n) {
    if (isNull) return 0;
    int charCount = n;

    if (toString().trim().length < n) {
      charCount = toString().trim().length;
    }

    return toString()
        .trim()
        .substring(toString().trim().length - charCount)
        .toInt();
  }

  /// Convert the number to a [String] with the specified [precision].
  /// If [precision] is not specified, the default is 2.
  String toPrecision([int precision = 2]) {
    var result = getOr().toStringAsFixed(precision);
    if (result.endsWith('.00')) {
      result = result.substring(0, result.length - 3);
    }
    return result;
  }

  /// Get count of a [substring] in the number.
  /// Returns the count of [substring] in the number.
  int count(num substring) {
    var count = 0;
    var index = 0;
    while (true) {
      index = toString().indexOf(substring.toString(), index);
      if (index == -1) break;
      count++;
      index++;
    }
    return count;
  }

  /// get the index of all occurrences of [substring] in the number.
  List<int> indexesOf(num substring) {
    final indexes = <int>[];
    var index = 0;
    while (true) {
      index = toString().indexOf(substring.toString(), index);
      if (index == -1) break;
      indexes.add(index);
      index++;
    }
    return indexes;
  }

  /// Get the index of the first occurrence of [substring] in the number.
  int indexOfFirst(num substring) => toString().indexOf(substring.toString());

  /// Get the index of the last occurrence of [substring] in the number.
  /// Returns the index of the last occurrence of [substring] in the number.
  int indexOfLast(num substring) =>
      toString().lastIndexOf(substring.toString());

  /// Transforms `this` into a `String` and pads it on the left if it is shorter
  /// than the given [width].
  String padLeft(int width, [String padding = '0']) =>
      toString().padLeft(width, padding);

  /// Transforms `this` into a `String` and pads it on the right if it is shorter
  /// than the given [width].
  String padRight(int width, [String padding = '0']) =>
      toString().padRight(width, padding);

  /// Returns list of digits of [this]
  /// e.g   12345.digits    // returns [1, 2, 3, 4, 5]
  /// e.g   8564.digits    // returns [8, 5, 6, 4]
  List<int> get digits => toString().split('').map(int.parse).toList();

  /// Returns number of digits in this number
  int get numberOfDigits => toString().length;

  /// Ensures that this value lies in the specified range
  /// [min]..[max].
  ///
  /// Return this value if it's in the range, or [min] if this value
  /// is less than [min], or [max] if this value is greater
  /// than [max].
  ///
  /// ```dart
  /// print(10.coerceIn(1, 100)) // 10
  /// print(0.coerceIn(1, 100)) // 1
  /// print(500.coerceIn(1, 100)) // 100
  /// 10.coerceIn(100, 0) // will fail with ArgumentError
  /// ````
  T coerceIn<T extends num>(T min, T max) {
    if (min > max) throw ArgumentError('min must be smaller the max');

    final value = getOr();
    if (value < min) return min;
    if (value > max) return max;

    return value as T;
  }

  /// Ensures that this value is not less than the specified [min].
  ///
  /// Return this value if it's greater than or equal to the [min]
  /// or the [min] otherwise.
  ///
  /// ```dart
  /// print(10.coerceAtLeast(5)) // 10
  /// print(10.coerceAtLeast(20)) // 20
  /// ```
  T coerceAtLeast<T extends num>(T min) {
    final value = getOr();

    return value < min ? min : value as T;
  }

  /// Ensures that this value is not greater than the specified [max].
  ///
  /// Return this value if it's less than or equal to the [max] or the
  /// [max] otherwise.
  ///
  /// ```dart
  /// print(10.coerceAtMost(5)) // 5
  /// print(10.coerceAtMost(20)) // 10
  /// ```
  T coerceAtMost<T extends num>(T max) {
    final value = getOr();

    return value > max ? max : value as T;
  }
}

extension NumTimeConverters on num? {
  String timeAgo({bool addAgo = true}) {
    if (isNull) return '';

    final String ago = addAgo ? 'ago' : '';

    final diff = Duration(seconds: toInt());
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
    if (isNull) return '';

    final List<String> months = [
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
    final List<String> shortMonths = [
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

    return style == Abbreviation.full || style == Abbreviation.semi
        ? shortMonths[toInt() - 1]
        : months[toInt() - 1];
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
    if (isNull) return '';

    final List<String> days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    final List<String> shortDays = [
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun',
    ];
    final List<String> veryShortDays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    if (style == Abbreviation.full) {
      return veryShortDays[toInt() - 1];
    } else {
      return style == Abbreviation.semi
          ? shortDays[toInt() - 1]
          : days[toInt() - 1];
    }
  }

  String toClockFormat({bool showSeconds = false}) {
    if (isNull) return '00:00';

    int h, m, s;

    h = this! ~/ 3600;

    m = (this! - h * 3600) ~/ 60;

    s = this!.toInt() - (h * 3600) - (m * 60);

    final String hourLeft = h.toString().length < 2 ? '0$h' : h.toString();

    final String minuteLeft = m.toString().length < 2 ? '0$m' : m.toString();

    final String secondsLeft = s.toString().length < 2 ? '0$s' : s.toString();

    String result;
    if (showSeconds) {
      result = '$hourLeft:$minuteLeft:$secondsLeft';
    } else {
      result = '$hourLeft:$minuteLeft';
    }

    return result;
  }

  /// Returns microseconds duration
  /// 5.microseconds
  Duration get microseconds => Duration(microseconds: toInt());

  /// Returns milliseconds duration
  /// ```dart
  /// 5.milliseconds
  /// ```
  Duration get milliseconds => Duration(milliseconds: toInt());

  /// Returns seconds duration
  /// ```dart
  /// 5.seconds
  /// ```
  Duration get seconds => Duration(seconds: toInt());

  /// Returns minutes duration
  /// ```dart
  /// 5.minutes
  /// ```
  Duration get minutes => Duration(minutes: toInt());

  /// Returns [DateTime] with time that is [this] minutes ago
  DateTime get minutesAgo => DateTime.now() - Duration(minutes: toInt());

  /// Returns [DateTime] with time that is [this] minutes after
  DateTime get minutesAfter => DateTime.now() + Duration(minutes: toInt());

  /// Returns hours duration
  /// ```dart
  /// 5.hours
  /// ```
  Duration get hours => Duration(hours: toInt());

  /// Returns [DateTime] with time that is [this] hours ago
  DateTime get hoursAgo => DateTime.now() - Duration(hours: toInt());

  /// Returns [DateTime] with time that is [this] hours after
  DateTime get hoursAfter => DateTime.now() + Duration(hours: toInt());

  /// Returns days duration
  /// ```dart
  /// 5.days
  /// ```
  Duration get days => Duration(days: toInt());

  /// Returns [DateTime] with date that is [this] days ago
  DateTime get daysAgo => DateTime.now() - Duration(days: toInt());

  /// Returns [DateTime] with date that is [this] days after
  DateTime get daysAfter => DateTime.now() + Duration(days: toInt());

  /// Returns month duration
  /// ```dart
  /// 5.weeks
  /// ```
  Duration get weeks => Duration(days: toInt() * 7);

  /// Returns [DateTime] with date that is [this] weeks ago
  DateTime get weeksAgo => DateTime.now() - Duration(days: toInt() * 7);

  /// Returns [DateTime] with date that is [this] weeks after
  DateTime get weeksAfter => DateTime.now() + Duration(days: toInt() * 7);

  /// Returns month duration
  /// ```dart
  /// 5.months
  /// ```
  Duration get month => Duration(days: toInt() * 30);

  /// Returns years duration
  /// ```dart
  /// 5.years
  /// ```
  Duration get years => Duration(days: toInt() * 365);
}

extension HumanReadableWords on num? {
  static final List<String> _units = [
    'zero',
    'one',
    'two',
    'three',
    'four',
    'five',
    'six',
    'seven',
    'eight',
    'nine',
  ];

  static final List<String> _teens = [
    'ten',
    'eleven',
    'twelve',
    'thirteen',
    'fourteen',
    'fifteen',
    'sixteen',
    'seventeen',
    'eighteen',
    'nineteen',
  ];

  static final List<String> _tens = [
    '',
    '',
    'twenty',
    'thirty',
    'forty',
    'fifty',
    'sixty',
    'seventy',
    'eighty',
    'ninety',
  ];

  static final List<String> _thousands = [
    '',
    'thousand',
    'million',
    'billion',
    'trillion',
    'quadrillion',
    'quintillion',
  ];

  /// Converts the number to a human-readable form as words.
  ///
  /// Example:
  /// ```dart
  /// print(13578921.toWords()); // Output: 'thirteen million five hundred seventy-eight thousand nine hundred twenty-one'
  /// print(1234.56.toWords()); // Output: 'one thousand two hundred and thirty-four point five six'
  /// ```
  ///
  /// Returns the string representation of the number as words.
  ///
  /// set [useAnd] to true if you want proper conversion
  ///
  /// ```dart
  /// print(13578921.toWords(useAnd: true)); // Output: 'thirteen million five hundred and seventy-eight thousand nine hundred and twenty-one'
  /// ```
  ///
  String toWords({bool useAnd = false}) {
    if (getOr() == 0) return _units[0];

    if (this! < 0) return 'minus ${(-this!).toWords(useAnd: useAnd)}';

    String words = '';
    int integerPart = this!.truncate();
    int thousandCounter = 0;

    while (integerPart > 0) {
      if (integerPart % 1000 != 0) {
        words =
            _convertLessThanThousand(
              integerPart % 1000,
              thousandCounter > 0,
              useAnd,
            ) +
            (thousandCounter > 0 ? ' ${_thousands[thousandCounter]} ' : '') +
            words;
      }
      integerPart ~/= 1000;
      thousandCounter++;
    }

    String fractionalWords = '';
    if (this is double) {
      final String fractionalPart = toString().split('.').last;
      if (int.parse(fractionalPart) > 0) {
        fractionalWords =
            ' point ${fractionalPart.split('').map((digit) => _units[int.parse(digit)]).join(' ')}';
      }
    }

    return (words.trim() + fractionalWords).trim();
  }

  String _convertLessThanThousand(
    int number,
    bool isThousandGroup,
    bool useAnd,
  ) {
    String words = '';

    if (number >= 100) {
      words += '${_units[number ~/ 100]} hundred';
      number %= 100;
      if (useAnd && number > 0) {
        words += ' and ';
      } else {
        words += ' ';
      }
    }

    if (number >= 20) {
      words += _tens[number ~/ 10];
      if (number % 10 > 0) {
        words += '-${_units[number % 10]}';
      }
    } else if (number >= 10) {
      words += _teens[number - 10];
    } else if (number > 0) {
      words += _units[number];
    } else if (useAnd && isThousandGroup && words.isNotEmpty) {
      words += ' and';
    } else {
      words += ' ';
    }

    return words;
  }
}

enum SizeUnit {
  BYTES(0),
  KB(1),
  MB(2),
  GB(3),
  TB(4);

  const SizeUnit(this.id);

  final int id;
}
