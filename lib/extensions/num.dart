// ignore_for_file: constant_identifier_names, non_constant_identifier_names
part of 'extensions.dart';

extension NumExtension on num {
  String get compact => NumberFormat.compact().format(this);

  String get formatComma => NumberFormat().format(this);

  String toSignificantDigits({int digit = 2}) {
    NumberFormat formatter = NumberFormat('0' * digit);
    return formatter.format(this);
  }

  String get ordinal {
    var specialValue = [11, 12, 13].contains(this % 100);
    if (specialValue) {
      return "${this}th";
    } else if (toString().length == 1) {
      switch (this) {
        case 0:
          return "0";
        case 1:
          return "${this}st";
        case 2:
          return "${this}nd";
        case 3:
          return "${this}rd";
        default:
          return "${this}th";
      }
    } else {
      switch (this % 10) {
        case 1:
          return "${this}st";
        case 2:
          return "${this}nd";
        case 3:
          return "${this}rd";
        default:
          return "${this}th";
      }
    }
  }

  String toClockFormat({bool showSeconds = false}) {
    int h, m, s;

    h = this ~/ 3600;

    m = ((this - h * 3600)) ~/ 60;

    s = toInt() - (h * 3600) - (m * 60);

    String hourLeft = h.toString().length < 2 ? "0$h" : h.toString();

    String minuteLeft = m.toString().length < 2 ? "0$m" : m.toString();

    String secondsLeft = s.toString().length < 2 ? "0$s" : s.toString();

    String result;
    if (showSeconds) {
      result = "$hourLeft:$minuteLeft:$secondsLeft";
    } else {
      result = "$hourLeft:$minuteLeft";
    }

    return result;
  }

  String getTimeFormatFromDouble() {
    if (this < 0) return '00:00';
    int flooredValue = floor();
    num decimalValue = this - flooredValue;
    String hourValue = flooredValue.toString();
    String minuteString = _getMinuteString(decimalValue);

    return '$hourValue:$minuteString';
  }

  String getTimeStringFromDouble() {
    if (this < 0) return '00:00';
    int flooredValue = floor();
    num decimalValue = this - flooredValue;
    String hourValue = _getHourString(flooredValue);
    String minuteString = _getMinuteString(decimalValue);

    return '$hourValue:$minuteString';
  }

  String _getMinuteString(num decimalValue) {
    return '${(decimalValue * 60).toInt()}'.padLeft(2, '0');
  }

  String _getHourString(int flooredValue) {
    return '${flooredValue % 24}'.padLeft(2, '0');
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
    if (this <= 0) return "0 bytes";
    const suffixes = ["bytes", "KB", "MB", "GB", "TB"];
    var i = (math.log(this) / math.log(1024)).floor();
    return '${(this / math.pow(1024, i)).toStringAsFixed(dp)} ${suffixes[i]}';
  }

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
    if (this <= 0) return 0;
    return (this / math.pow(1000, unit.id));
  }

  /// Returns a [bool] if [this] value is between (including) the two
  /// numeric values [first] and [second].
  ///
  /// Example:
  /// ```dart
  /// 100.0.isBetween(50, 150) // true;
  /// 100.0.isBetween(50.0, 150.0) // true;
  /// 100.0.isBetween(100.0, 100.0) // true;
  /// ```
  bool isBetween(num first, num second) {
    final lower = min(first, second);
    final upper = max(first, second);
    return this >= lower && this <= upper;
  }
}

enum SizeUnit {
  BYTES(0),
  KB(1),
  MB(2),
  GB(3),
  TB(4);

  final int id;
  const SizeUnit(this.id);
}

/// Extension on `num` to convert to human-readable words.
extension HumanReadableWords on num {
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
    'nine'
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
    'nineteen'
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
    'ninety'
  ];

  static final List<String> _thousands = [
    '',
    'thousand',
    'million',
    'billion',
    'trillion',
    'quadrillion',
    'quintillion'
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
    if (this == 0) return _units[0];

    if (this < 0) return 'minus ${(-this).toWords(useAnd: useAnd)}';

    String words = '';
    int integerPart = truncate();
    int thousandCounter = 0;

    while (integerPart > 0) {
      if (integerPart % 1000 != 0) {
        words = _convertLessThanThousand(
                integerPart % 1000, thousandCounter > 0, useAnd) +
            (thousandCounter > 0 ? ' ${_thousands[thousandCounter]} ' : '') +
            words;
      }
      integerPart ~/= 1000;
      thousandCounter++;
    }

    String fractionalWords = '';
    if (this is double) {
      String fractionalPart = toString().split('.').last;
      if (int.parse(fractionalPart) > 0) {
        fractionalWords =
            ' point ${fractionalPart.split('').map((digit) => _units[int.parse(digit)]).join(' ')}';
      }
    }

    return (words.trim() + fractionalWords).trim();
  }

  String _convertLessThanThousand(
      int number, bool isThousandGroup, bool useAnd) {
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

/// Double Extensions
extension DoubleExtensions on double? {
  double roundWithDigit(int digit) {
    final digitValue = math.pow(10, digit);
    return (validate() * digitValue).roundToDouble() / digitValue;
  }

  double floorWithDigit(int digit) {
    final digitValue = math.pow(10, digit);
    return (validate() * digitValue).floorToDouble() / digitValue;
  }

  /// Validates the double value and returns it if not null.
  ///
  /// If the value is null, returns 0.0.
  double validate({double value = 0.0}) => this ?? value;

  /// Returns a [BorderRadius] with circular radius.
  ///
  /// Example:
  /// ```dart
  /// double radius = 5.0;
  /// BorderRadius borderRadius = radius.circularRadius;
  /// ```
  BorderRadius get circularRadius => BorderRadius.circular(validate());

  /// Checks if the current value falls between the specified range.
  ///
  /// Returns `true` if the current value is between [first] and [second],
  /// otherwise returns `false`.
  ///
  /// Example:
  /// ```dart
  /// bool isInRange = 100.0.isBetween(50.0, 150.0);
  /// print('Is in range? $isInRange'); // Output: true
  /// ```
  bool isBetween(num first, num second) {
    final lower = math.min(first, second);
    final upper = math.max(first, second);
    return validate() >= lower && validate() <= upper;
  }

  /// Returns a square [Size] object with the current value as both width and height.
  ///
  /// Example:
  /// ```dart
  /// Size squareSize = 50.0.squareSizeBox;
  /// print('Square Size: $squareSize'); // Output: Size(50.0, 50.0)
  /// ```
  SizedBox get squareSizeBox => SizedBox(width: this!, height: this!);

  /// Returns a square [Size] with the current value as both width and height.
  ///
  /// Example:
  /// ```dart
  /// double sideLength = 100.0;
  /// Size squareSize = sideLength.squareSize; // Output: Size(100.0, 100.0)
  /// ```
  Size get squareSize => Size(this!, this!);
}

/// int Extensions
extension IntNullableExtensions on int? {
  /// Checks if the given String [s] is null or empty
  bool get isEmptyOrNull => this == null;

  /// Leaves given height of space
  Widget get height => SizedBox(height: validate().toDouble());

  /// Leaves given width of space
  Widget get width => SizedBox(width: validate().toDouble());

  /// Returns microseconds duration
  /// 5.microseconds
  Duration get microseconds => Duration(microseconds: validate());

  /// Returns milliseconds duration
  /// ```dart
  /// 5.milliseconds
  /// ```
  Duration get milliseconds => Duration(milliseconds: validate());

  /// Returns seconds duration
  /// ```dart
  /// 5.seconds
  /// ```
  Duration get seconds => Duration(seconds: validate());

  /// Returns minutes duration
  /// ```dart
  /// 5.minutes
  /// ```
  Duration get minutes => Duration(minutes: validate());

  /// Returns hours duration
  /// ```dart
  /// 5.hours
  /// ```
  Duration get hours => Duration(hours: validate());

  /// Returns days duration
  /// ```dart
  /// 5.days
  /// ```
  Duration get days => Duration(days: validate());

  /// Returns month duration
  /// ```dart
  /// 5.weeks
  /// ```
  Duration get weeks => Duration(days: validate() * 7);

  /// Returns month duration
  /// ```dart
  /// 5.months
  /// ```
  Duration get month => Duration(days: (validate() * 30));

  /// Returns years duration
  /// ```dart
  /// 5.years
  /// ```
  Duration get years => Duration(days: (validate() * 365));

  /// Returns Size
  Size get size => Size(validate().toDouble(), validate().toDouble());

  /// Returns Radius
  /// ```dart
  /// 5.circularRadius
  /// ```
  BorderRadius get circularBorderRadius =>
      BorderRadius.circular(validate().toDouble());

  /// Returns true if the value is `1`
  /// otherwise false is returned.
  bool toBool([int value = 1]) => this == value ? true : false;

  /// Validate given int is not null and returns given value if null.
  int validate({int value = 0}) => this ?? value;

  /// Validate given int is not null and returns given value if null.
  String? get addZeroPrefix {
    if (isEmptyOrNull) {
      return null;
    }
    if ((this ?? 0) < 10) {
      return '0$this';
    } else {
      return toString();
    }
  }

  /// get last charts of give value
  /// 'I  like dart language'.lastChars(13) // dart language
  int lastDigits(int n) {
    if (isEmptyOrNull) return 0;
    int charCount = n;
    if (toString().trim().length < n) {
      charCount = toString().trim().length;
    }
    return (toString().trim().substring(toString().trim().length - charCount))
            .toInt() ??
        0;
  }

  // returns month name from the given int
  String toMonthName({bool isHalfName = false}) {
    String status = '';
    if (!(this! >= 1 && this! <= 12)) {
      throw Exception('Invalid day of month');
    }
    if (this == 1) {
      return status = isHalfName ? 'Jan' : 'January';
    } else if (this == 2) {
      return status = isHalfName ? 'Feb' : 'February';
    } else if (this == 3) {
      return status = isHalfName ? 'Mar' : 'March';
    } else if (this == 4) {
      return status = isHalfName ? 'Apr' : 'April';
    } else if (this == 5) {
      return status = isHalfName ? 'May' : 'May';
    } else if (this == 6) {
      return status = isHalfName ? 'Jun' : 'June';
    } else if (this == 7) {
      return status = isHalfName ? 'Jul' : 'July';
    } else if (this == 8) {
      return status = isHalfName ? 'Aug' : 'August';
    } else if (this == 9) {
      return status = isHalfName ? 'Sept' : 'September';
    } else if (this == 10) {
      return status = isHalfName ? 'Oct' : 'October';
    } else if (this == 11) {
      return status = isHalfName ? 'Nov' : 'November';
    } else if (this == 12) {
      return status = isHalfName ? 'Dec' : 'December';
    }
    return status;
  }

  // returns WeekDay from the given int
  String toWeekDay({bool isHalfName = false}) {
    if (!(this! >= 1 && this! <= 7)) {
      throw Exception('Invalid day of month');
    }
    String weekName = '';

    if (this == 1) {
      return weekName = isHalfName ? "Mon" : "Monday";
    } else if (this == 2) {
      return weekName = isHalfName ? "Tue" : "Tuesday";
    } else if (this == 3) {
      return weekName = isHalfName ? "Wed" : "Wednesday";
    } else if (this == 4) {
      return weekName = isHalfName ? "Thu" : "Thursday";
    } else if (this == 5) {
      return weekName = isHalfName ? "Fri" : "Friday";
    } else if (this == 6) {
      return weekName = isHalfName ? "Sat" : "Saturday";
    } else if (this == 7) {
      return weekName = isHalfName ? "Sun" : "Sunday";
    }
    return weekName;
  }
}

/// Num Extensions
extension NumExt on num? {
  /// Returns `true` if this nullable iterable is either `null` or empty.
  bool get isNullOrEmpty => this == null;

  /// isZero
  bool isZero() => this == null || this == 0;

  /// Validate given double is not null and returns given value if null.
  num validate({num value = 0}) => this ?? value;

  /// Validate given double is not null and returns given value if null.
  num get validateNum => this ?? 0;

  /// Determines if [this] is between [a] and [b] whereas the bounds
  /// are inclusive.
  bool between(int min, int max) => validate() >= min && validate() <= max;

  // Returns price with currency
  // String toCurrencyAmount() => "$defaultCurrencySymbol${this.validate()}";

  /// Check if the number is in the range [min] to [max].
  /// Returns `true` if the number is in the range, `false` otherwise.
  bool isInRange(num min, num max) => (this ?? 0) >= min && (this ?? 0) <= max;

  /// Get list of random numbers.
  List<num> randomList({int min = 0, int max = 100}) {
    if (isNullOrEmpty) return [];
    var result = <num>[];
    for (var i = 0; i < (this ?? 0); i++) {
      result.add(math.Random().nextInt(max - min) + min);
    }
    return result;
  }

  /// Converts degrees to radians.
  double? degreesToRadians() {
    if (isNullOrEmpty) return null;
    return this! * (math.pi / 180.0);
  }

  /// Converts radians to degrees.
  double? radiansToDegrees() {
    if (isNullOrEmpty) return null;
    return this! * (180.0 / math.pi);
  }
}

extension NumExtension2 on num {
  double asPercentageInDecimal() {
    return validate() / 100.0;
  }

  double calculatePercentageOf(double percentage) {
    return (validate() * percentage) / 100.0;
  }
}

extension DoubleExtension on double {
  double asPercentageInDecimal() {
    return validate() / 100.0;
  }

  double calculatePercentageOf(double percentage) {
    return (validate() * percentage) / 100.0;
  }
}

extension IntExtension on int {
  int asPercentageInDecimal() {
    return validate() ~/ 100.0;
  }

  int calculatePercentageOf(double percentage) {
    return (validate() * percentage) ~/ 100;
  }
}

extension NumTimeExtension<T extends num> on T {
  /// Returns a Duration represented in weeks
  Duration get weeks => days * DurationTimeExtension.daysPerWeek;

  /// Returns a Duration represented in days
  Duration get days => milliseconds * Duration.millisecondsPerDay;

  /// Returns a Duration represented in hours
  Duration get hours => milliseconds * Duration.millisecondsPerHour;

  /// Returns a Duration represented in minutes
  Duration get minutes => milliseconds * Duration.millisecondsPerMinute;

  /// Returns a Duration represented in seconds
  Duration get seconds => milliseconds * Duration.millisecondsPerSecond;

  /// Returns a Duration represented in milliseconds
  Duration get milliseconds => Duration(
      microseconds: (this * Duration.microsecondsPerMillisecond).toInt());

  /// Returns a Duration represented in microseconds
  Duration get microseconds =>
      milliseconds ~/ Duration.microsecondsPerMillisecond;

  /// Returns a Duration represented in nanoseconds
  Duration get nanoseconds =>
      microseconds ~/ DurationTimeExtension.nanosecondsPerMicrosecond;
}

/// Supercharged extensions on [int] numbers.
extension IntSC on int {
  /// Creates an [Iterable<int>] that contains all values from current integer
  /// until (including) the value [n].
  ///
  /// Example:
  /// ```dart
  /// 0.rangeTo(5); // [0, 1, 2, 3, 4, 5]
  /// 3.rangeTo(1); // [3, 2, 1]
  /// ```
  Iterable<int> rangeTo(int n) {
    var count = (n - this).abs() + 1;
    var direction = (n - this).sign;
    var i = this - direction;
    return Iterable.generate(count, (int index) {
      return i += direction;
    });
  }

  /// Creates an [Iterable<int>] that contains all values from current integer
  /// until (excluding) the value [n].
  ///
  /// Example:
  /// ```dart
  /// 0.until(5); // [0, 1, 2, 3, 4]
  /// 3.until(1); // [3, 2]
  /// ```
  Iterable<int> until(int n) {
    if (this < n) {
      return rangeTo(n - 1);
    } else if (this > n) {
      return rangeTo(n + 1);
    } else {
      return const Iterable.empty();
    }
  }

  /// Executes the function [action] for [this] times.
  ///
  /// Example:
  /// 3.times(() => print('Hello')); // Hello... Hello... Hello
  void times(void Function() action) {
    0.until(this).forEach((_) => action());
  }

  /// Returns a [Duration] representing the current value as microseconds.
  ///
  /// Example:
  /// ```dart
  /// 200.microseconds; // Duration(microseconds: 200);
  /// ```
  Duration get microseconds {
    return Duration(microseconds: this);
  }

  /// Returns a [Duration] representing the current value as milliseconds.
  ///
  /// Example:
  /// ```dart
  /// 1000.milliseconds; // Duration(milliseconds: 1000);
  /// ```
  Duration get milliseconds {
    return Duration(milliseconds: this);
  }

  /// Returns a [Duration] representing the current value as seconds.
  ///
  /// Example:
  /// ```dart
  /// 30.seconds; // Duration(seconds: 1000);
  /// ```
  Duration get seconds {
    return Duration(seconds: this);
  }

  /// Returns a [Duration] representing the current value as minutes.
  ///
  /// Example:
  /// ```dart
  /// 15.minutes; // Duration(minutes: 15);
  /// ```
  Duration get minutes {
    return Duration(minutes: this);
  }

  /// Returns a [Duration] representing the current value as hours.
  ///
  /// Example:
  /// ```dart
  /// 24.hours; // Duration(hours: 24);
  /// ```
  Duration get hours {
    return Duration(hours: this);
  }

  /// Returns a [Duration] representing the current value as days.
  ///
  /// Example:
  /// ```dart
  /// 14.days; // Duration(days: 14);
  /// ```
  Duration get days {
    return Duration(days: this);
  }

  /// Returns a [bool] if [this] value is between (including) the two
  /// numeric values [first] and [second].
  ///
  /// Example:
  /// ```dart
  /// 100.isBetween(50, 150) // true;
  /// 100.isBetween(50.0, 150.0) // true;
  /// 100.isBetween(100, 100) // true;
  /// ```
  bool isBetween(num first, num second) {
    if (first <= second) {
      return this >= first && this <= second;
    } else {
      return this >= second && this <= first;
    }
  }
}

extension NumberUtils on num {
  /// Returns `true` if the number is even, `false` otherwise.
  bool get isEven => this % 2 == 0;

  /// Returns `true` if the number is odd, `false` otherwise.
  bool get isOdd => this % 2 != 0;

  /// Returns `true` if the number is positive, `false` otherwise.
  bool get isPositive => this > 0;

  /// Returns `true` if the number is negative, `false` otherwise.
  bool get isNegative => this < 0;

  /// Returns `true` if the number is zero, `false` otherwise.
  bool get isZero => this == 0;

  /// Returns `true` if the number is an integer, `false` otherwise.
  bool get isInteger => this == toInt();

  /// Returns `true` if the number is a double, `false` otherwise.
  bool get isDouble => this == toDouble();

  /// Swap the sign of the number.
  num swapSign() => -this;

  /// Convert the number to a [String] with the specified [precision].
  /// If [precision] is not specified, the default is 2.

  String toPrecision([int precision = 2]) {
    var result = toStringAsFixed(precision);
    if (result.endsWith('.00')) {
      result = result.substring(0, result.length - 3);
    }
    return result;
  }

  /// Convert to currency string with specified delimiter and precision.
  /// If [delimiter] is not specified, the default is ','.
  /// If [precision] is not specified, the default is 2.

  String toCurrencyString([String delimiter = ',', int precision = 2]) {
    var result1 = toPrecision(precision);
    var parts = result1.split('.');
    var integer = parts[0];
    var decimal = parts[1];
    var result = '';
    var count = 0;
    for (var i = integer.length - 1; i >= 0; i--) {
      result = integer[i] + result;
      count++;
      if (count == 3 && i != 0) {
        result = delimiter + result;
        count = 0;
      }
    }
    return '$result.$decimal';
  }

  /// Check if the number is in the range [min] to [max].
  /// Returns `true` if the number is in the range, `false` otherwise.
  bool isInRange(num min, num max) => this >= min && this <= max;

  /// Check if the number starts with [prefix].
  /// Returns `true` if the number starts with [prefix], `false` otherwise.
  bool startsWith(num prefix) => toString().startsWith(prefix.toString());

  /// Check if the number ends with [suffix].
  /// Returns `true` if the number ends with [suffix], `false` otherwise.
  bool endsWith(num suffix) => toString().endsWith(suffix.toString());

  /// Check if the number contains [substring].
  /// Returns `true` if the number contains [substring], `false` otherwise.
  bool contains(num substring) => toString().contains(substring.toString());

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

  /// sum of digits
  /// Returns the sum of digits in the number.
  num sumOfDigits() {
    num sum = 0;
    var number = this;
    while (number > 0) {
      sum += number % 10;
      number = (number / 10).floor();
    }
    return sum;
  }

  /// Get the digits after a [substring] in the number
  /// Returns the digits after a [substring] in the number
  num digitsAfter(num substring) {
    var index = toString().indexOf(substring.toString());
    if (index == -1) return 0;
    var result = toString().substring(index + 1);
    return int.parse(result);
  }

  /// Get the digits before a [substring] in the number
  /// Returns the digits before a [substring] in the number
  num digitsBefore(num substring) {
    var index = toString().indexOf(substring.toString());
    if (index == -1) return 0;
    var result = toString().substring(0, index);
    return int.parse(result);
  }

  /// Get the digits between [start] and [end] in the number
  /// Returns the digits between [start] and [end] in the number
  num digitsBetween(num start, num end) {
    var startIndex = toString().indexOf(start.toString());
    if (startIndex == -1) return 0;
    var endIndex = toString().indexOf(end.toString(), startIndex + 1);
    if (endIndex == -1) return 0;
    var result = toString().substring(startIndex + 1, endIndex);
    return int.parse(result);
  }

  /// Get the digits before the first occurrence of [substring] in the number
  /// Returns the digits before the first occurrence of [substring] in the number
  num digitsBeforeFirst(num substring) {
    var index = toString().indexOf(substring.toString());
    if (index == -1) return 0;
    var result = toString().substring(0, index);
    return int.parse(result);
  }

  /// Get the digits after the first occurrence of [substring] in the number
  /// Returns the digits after the first occurrence of [substring] in the number
  num digitsAfterFirst(num substring) {
    var index = toString().indexOf(substring.toString());
    if (index == -1) return 0;
    var result = toString().substring(index + 1);
    return int.parse(result);
  }

  /// Get the digits before the last occurrence of [substring] in the number
  /// Returns the digits before the last occurrence of [substring] in the number
  num digitsBeforeLast(num substring) {
    var index = toString().lastIndexOf(substring.toString());
    if (index == -1) return 0;
    var result = toString().substring(0, index);
    return int.parse(result);
  }

  /// Get the digits after the last occurrence of [substring] in the number
  /// Returns the digits after the last occurrence of [substring] in the number
  num digitsAfterLast(num substring) {
    var index = toString().lastIndexOf(substring.toString());
    if (index == -1) return 0;
    var result = toString().substring(index + 1);
    return int.parse(result);
  }

  /// Get the lorem ipsum text of [this] words.
  String loremIpsum() {
    var words = [
      'lorem',
      'ipsum',
      'dolor',
      'sit',
      'amet',
      'consectetur',
      'adipiscing',
      'elit',
      'sed',
      'do',
      'eiusmod',
      'tempor',
      'incididunt',
      'ut',
      'labore',
      'et',
      'dolore',
      'magna',
      'aliqua',
      'ut',
      'enim',
      'ad',
      'minim',
      'veniam',
      'quis',
      'nostrud',
      'exercitation',
      'ullamco',
      'laboris',
      'nisi',
      'ut',
      'aliquip',
      'ex',
      'ea',
      'commodo',
      'consequat',
      'duis',
      'aute',
      'irure',
      'dolor',
      'in',
      'reprehenderit',
      'in',
      'voluptate',
      'velit',
      'esse',
      'cillum',
      'dolore',
      'eu',
      'fugiat',
      'nulla',
      'pariatur',
      'excepteur',
      'sint',
      'occaecat',
      'cupidatat',
      'non',
      'proident',
      'sunt',
      'in',
      'culpa',
      'qui',
      'officia',
      'deserunt',
      'mollit',
      'anim',
      'id',
      'est',
      'laborum'
    ];

    var result = '';
    for (var i = 0; i < this; i++) {
      result += '${words[i % words.length]} ';
    }
    return result.trim();
  }

  /// Get list of random numbers.
  List<num> randomList({int min = 0, int max = 100}) {
    var result = <num>[];
    for (var i = 0; i < this; i++) {
      result.add(Random().nextInt(max - min) + min);
    }
    return result;
  }
}

/// Utilities for formatting numbers.
extension NumExtension3<T extends num> on T {
  /// Transforms `this` into a `String` and pads it on the left if it is shorter
  /// than the given [width].
  String padLeft(int width, [String padding = '0']) =>
      toString().padLeft(width, padding);

  /// Transforms `this` into a `String` and pads it on the right if it is shorter
  /// than the given [width].
  String padRight(int width, [String padding = '0']) =>
      toString().padRight(width, padding);

  /// Returns `true` if `this` is between the given [min] (inclusive) and [max] (exclusive).
  bool between(num min, num max) {
    assert(min <= max,
        'Invalid bounds: $min and $max, min cannot be greater than max');
    return min <= this && this < max;
  }

  /// Returns `true` if this number is outside the given range of [min] (exclusive) and
  /// [max] (exclusive).
  bool outside(num min, num max) {
    assert(min <= max,
        'Invalid bounds: $min and $max, min cannot be greater than max');
    return this < min || this > max;
  }
}

/// Utility extension methods for the native [int] class.
// extension IntBasics on int {
//   /// Returns an iterable from `0` up to but not including [this].
//   ///
//   /// Example:
//   /// ```dart
//   /// 5.range; // (0, 1, 2, 3, 4)
//   /// ```
//   Iterable<int> get range => Iterable<int>.generate(this);
//
//   /// Returns an iterable from [this] inclusive to [end] exclusive.
//   ///
//   /// Example:
//   /// ```dart
//   /// 3.to(6); // (3, 4, 5)
//   /// 2.to(-2); // (2, 1, 0, -1)
//   /// ```
//   ///
//   /// If [by] is provided, it will be used as step size for iteration. [by] is
//   /// always positive, even if the direction of iteration is decreasing.
//   ///
//   /// Example:
//   /// ```dart
//   /// 8.to(3, by: 2); // (8, 6, 4)
//   /// ```
//   Iterable<int> to(int end, {int by = 1}) {
//     if (by < 1) {
//       throw ArgumentError(
//           'Invalid step size: $by. Step size must be greater than 0');
//     }
//     final count = ((end - this).abs() / by).ceil();
//     // Explicit type declaration required for function argument.
//     final int Function(int) generator = this >= end
//         ? (index) => this - (by * index)
//         : (index) => this + (by * index);
//     return Iterable<int>.generate(count, generator);
//   }
//
//   /// Returns [Duration] of [this] in days.
//   Duration get days => Duration(days: this);
//
//   /// Returns [Duration] of [this] in hours.
//   Duration get hours => Duration(hours: this);
//
//   /// Returns [Duration] of [this] in minutes.
//   Duration get minutes => Duration(minutes: this);
//
//   /// Returns [Duration] of [this] in seconds.
//   Duration get seconds => Duration(seconds: this);
//
//   /// Returns [Duration] of [this] in milliseconds.
//   Duration get milliseconds => Duration(milliseconds: this);
//
//   /// Returns [Duration] of [this] in microseconds.
//   Duration get microseconds => Duration(microseconds: this);
// }
