part of 'extensions.dart';

extension ValidatorExtensions on String? {
  /// Check if the string exactly matches with the [comparison]
  bool equals(Object? comparison) {
    if (comparison == null) {
      // Explicitly check if `comparison` is null because calling `toString`
      // on `null` will return 'null'. This is an issue when comparing to
      // the string 'null'. Also, `str` will never be null so if `comparison`
      // is null we can simply return false.
      return false;
    }
    return this == comparison.toString();
  }

  /// Check if string matches the [pattern] or [regex].
  bool matches({RegExp? regex, String? pattern}) {
    if (this == null) return false;

    RegExp re = regex ?? RegExp(pattern ?? '');
    return re.hasMatch(this!);
  }

  /// Check if the string is an email
  bool get isEmail =>
      this != null && this!.toLowerCase().matches(regex: Regex.email);

  /// Check if the string is a URL
  ///
  /// `options` is a `Map` which defaults to
  /// `{ 'protocols': ['http','https','ftp'], 'require_tld': true,
  /// 'require_protocol': false, 'allow_underscores': false }`.
  bool get isUrl => this != null && (Uri.tryParse(this!)?.isAbsolute ?? false);

  /// Check if the string is an IP ([version] 4 or 6)
  ///
  /// [version] is a String or an `int`.
  bool isIP(String str, [Object? version]) {
    assert(version == null || version is String || version is int);

    version = version.toString();
    if (version == 'null') {
      return isIP(str, 4) || isIP(str, 6);
    } else if (version == '4') {
      if (!matches(regex: Regex.ipv4Maybe)) return false;

      var parts = str.split('.');
      parts.sort((a, b) => int.parse(a) - int.parse(b));
      return int.parse(parts[3]) <= 255;
    }
    return version == '6' && matches(regex: Regex.ipv6);
  }

  /// Check if the string contains only letters (a-zA-Z).
  bool get isAlpha => this != null && matches(regex: Regex.alpha);

  /// Check if the string contains only numbers
  bool get isNumeric => this != null && matches(regex: Regex.numeric);

  /// Check if the string contains only letters and numbers
  bool get isAlphanumeric => this != null && matches(regex: Regex.alphanumeric);

  /// Check if a string is base64 encoded
  bool get isBase64 => this != null && matches(regex: Regex.base64);

  /// Check if the string is an integer
  bool get isInt => this != null && int.tryParse(this!) != null;

  /// Check if the string is a float
  bool get isFloat => this != null && double.tryParse(this!) != null;

  /// Check if the string is a hexadecimal number
  bool get isHexadecimal => this != null && matches(regex: Regex.hexadecimal);

  /// Check if the string is a hexadecimal color
  bool get isHexColor => this != null && matches(regex: Regex.hexColor);

  /// Check if the string is lowercase
  bool get isLowercase => this != null && this == this!.toLowerCase();

  /// Check if the string is uppercase
  bool get isUppercase => this != null && this == this!.toUpperCase();

  /// Check if the string is a number that's divisible by another
  ///
  /// [n] is a String or an int.
  bool isDivisibleBy(Object n) {
    if (this == null) return false;

    assert(n is String || n is int);

    final int? number;

    if (n is int) {
      number = n;
    } else if (n is String) {
      number = int.tryParse(n);
    } else {
      return false;
    }
    if (number == null) return false;
    try {
      return double.parse(this!) % number == 0;
    } catch (e) {
      return false;
    }
  }

  /// Check if the string's length falls in a range
  /// If no max is given then any length above min is ok.
  ///
  /// Note: this function takes into account surrogate pairs.
  /// Surrogate pairs are character representations in source code that
  /// represent a single character that consists of a sequence of two Unicode
  /// values. In a coded pair, the first value is a high surrogate and the
  /// second is a low surrogate. A high surrogate is a character in the range
  /// U+D800 through U+DBFF
  bool isLength(int min, [int? max]) {
    if (this == null) return false;

    final surrogatePairs =
        Regex.surrogatePairsRegExp.allMatches(this!).toList();
    int len = this!.length - surrogatePairs.length;
    return len >= min && (max == null || len <= max);
  }

  /// Check if the string's length (in bytes) falls in a range.
  bool isByteLength(int min, [int? max]) {
    if (this == null) return false;
    return this!.length >= min && (max == null || this!.length <= max);
  }

  /// Check if the string is a UUID (version 3, 4 or 5).
  bool isUuid([Object? version]) {
    if (this == null) return false;

    if (version == null) {
      version = 'all';
    } else {
      version = version.toString();
    }

    RegExp? pat = Regex.uuid[version];
    return (pat != null && pat.hasMatch(this!.toUpperCase()));
  }

  /// Check if the string is in an array of allowed values
  bool isIn(Object? values) {
    if (this == null || values == null) return false;

    if (values is String) return values.contains(this!);

    if (values is! Iterable) return false;

    for (Object? value in values) {
      if (value.toString() == this) return true;
    }
    return false;
  }

  /// Check if the string is a credit card using Luhn Algorithm
  bool get isCreditCard {
    if (this == null) return false;

    String sanitized = this!.replaceAll(RegExp(r'[^0-9]+'), '');

    if (!sanitized.matches(regex: Regex.creditCard)) return false;

    // Luhn algorithm
    int sum = 0;
    String digit;
    bool shouldDouble = false;

    for (int i = sanitized.length - 1; i >= 0; i--) {
      digit = sanitized.substring(i, (i + 1));
      int tmpNum = int.parse(digit);

      if (shouldDouble == true) {
        tmpNum *= 2;
        if (tmpNum >= 10) {
          sum += ((tmpNum % 10) + 1);
        } else {
          sum += tmpNum;
        }
      } else {
        sum += tmpNum;
      }
      shouldDouble = !shouldDouble;
    }

    return (sum % 10 == 0);
  }

  /// Check if the string is an ISBN (version 10 or 13)
  bool isISBN([Object? version]) {
    if (this == null) return false;

    if (version == null) return isISBN('10') || isISBN('13');

    version = version.toString();

    String sanitized = this!.replaceAll(RegExp(r'[\s-]+'), '');
    int checksum = 0;

    if (version == '10') {
      if (!sanitized.matches(regex: Regex.isbn10Maybe)) return false;

      for (int i = 0; i < 9; i++) {
        checksum += (i + 1) * int.parse(sanitized[i]);
      }
      if (sanitized[9] == 'X') {
        checksum += 10 * 10;
      } else {
        checksum += 10 * int.parse(sanitized[9]);
      }
      return (checksum % 11 == 0);
    } else if (version == '13') {
      if (!sanitized.matches(regex: Regex.isbn13Maybe)) return false;

      var factor = [1, 3];
      for (int i = 0; i < 12; i++) {
        checksum += factor[i % 2] * int.parse(sanitized[i]);
      }
      return (int.parse(sanitized[12]) - ((10 - (checksum % 10)) % 10) == 0);
    }

    return false;
  }

  /// Check if the string is valid JSON
  bool get isJson {
    if (this == null) return false;

    try {
      json.decode(this!);
    } catch (e) {
      return false;
    }
    return true;
  }

  /// Check if the string contains one or more multibyte chars
  bool get isMultibyte => this != null && matches(regex: Regex.multibyte);

  /// Check if the string contains ASCII chars only
  bool get isAscii => this != null && matches(regex: Regex.ascii);

  /// Check if the string contains any full-width chars
  bool get isFullWidth => this != null && matches(regex: Regex.fullWidth);

  /// Check if the string contains any half-width chars
  bool get isHalfWidth => this != null && matches(regex: Regex.halfWidth);

  /// Check if the string contains a mixture of full and half-width chars
  bool get isVariableWidth => isFullWidth && isHalfWidth;

  /// Check if the string contains any surrogate pairs chars
  bool get isSurrogatePair =>
      this != null && matches(regex: Regex.surrogatePairsRegExp);

  /// Check if the string is a image path or url
  bool get isImage {
    return this != null &&
        (matches(regex: Regex.image) || this!.startsWith('data:image'));
  }
}

extension SanitizerExtensions on String? {
  /// Converts the string to a [double]. Returns NaN if parsing fails.
  double toFloat() =>
      this != null ? double.tryParse(this!) ?? double.nan : double.nan;

  /// Converts the string to a [double]. Returns NaN if parsing fails.
  double toDouble() => toFloat();

  /// Converts the string to a [num]. [radix] is the base for integer parsing.
  num toInt({int radix = 10}) => this != null
      ? int.tryParse(this!, radix: radix) ??
          double.tryParse(this!)?.toInt() ??
          double.nan
      : double.nan;

  /// Converts the string to a [bool].
  /// [strict] mode only allows '1' and 'true' to return true.
  bool toBoolean([bool strict = false]) => this != null
      ? strict == true
          ? this == '1' || this == 'true'
          : this != '0' && this != 'false' && this!.isNotEmpty
      : false;

  /// Trims characters from the left side of the string.
  String? leftTrim([String? chars]) => this != null
      ? (chars != null)
          ? this!.replaceAll(RegExp('^[$chars]+'), '')
          : this!.replaceAll(RegExp(r'^\s+'), '')
      : null;

  /// Trims characters from the right side of the string.
  String? rightTrim([String? chars]) => this != null
      ? (chars != null)
          ? this!.replaceAll(RegExp('[$chars]+\$'), '')
          : this!.replaceAll(RegExp(r'\s+$'), '')
      : null;

  /// Removes characters that do not appear in the whitelist.
  String? whitelist(String chars) => this?.replaceAll(RegExp('[^$chars]+'), '');

  /// Removes characters that appear in the blacklist.
  String? blacklist(String chars) => this?.replaceAll(RegExp('[$chars]+'), '');

  /// Removes characters with a numerical value less than 32 and 127.
  /// If [keepNewLines] is true, newline characters are preserved (\n and \r, hex 0xA and 0xD).
  String? stripLow([bool keepNewLines = false]) {
    final chars = keepNewLines == true
        ? '\x00-\x09\x0B\x0C\x0E-\x1F\x7F'
        : '\x00-\x1F\x7F';
    return blacklist(chars);
  }

  /// Generic string to enum function
  ///
  /// Converts the string to a [T]. Returns [orElse] or null if not found.
  T? toEnum<T>({required Iterable<T> values, T Function()? orElse}) {
    if (this == null || this!.isEmpty) return orElse?.call();

    return values.firstWhere(
      (element) =>
          element != null &&
          this!.toLowerCase() == (element as Enum).name.toLowerCase(),
      orElse: orElse,
    );
  }
}

extension StringConversions on String? {
  /// Capitalizes the first character of the string.
  String? get capitalize {
    if (this == null || this!.isEmpty) return this;
    return this![0].toUpperCase() + this!.substring(1);
  }

  /// Capitalizes the first character of each word in the string.
  String? get capitalizeEachWord {
    if (this == null || this!.isEmpty) return this;
    return this!.split(' ').map((word) => word.capitalize).join(' ');
  }

  /// Converts the string to snake_case.
  String? get toSnakeCase {
    if (this == null || this!.isEmpty) return this;

    return this!.split('').mapWithIndex((index, character) {
      if (character == character.toUpperCase()) {
        return (index != 0 ? '_' : '') + character.toLowerCase();
      } else {
        return character;
      }
    }).join('');
  }

  /// Returns a string abbreviation like Jon Doe -> JD.
  String get toInitials {
    if (this == null) return '';

    final nameParts = this!.trim.call().toUpperCase().split(RegExp(r'[\s/]+'));

    if (nameParts.length > 1) {
      return nameParts.first.substring(0, 1) + nameParts[1].substring(0, 1);
    }

    return nameParts.first.length > 1
        ? nameParts.first.substring(0, 2)
        : nameParts.first;
  }

  String? get removeMaskFromPhoneNumber {
    if (this == null || this!.isEmpty) return this;

    return this!.length > 10
        ? this!.substring(2, this!.length).replaceAll(RegExp(r'\D'), '')
        : this;
  }

  String? formatPhoneNumber({bool addCountryCode = false}) {
    if (this == null || this!.isEmpty) return this;

    return "${addCountryCode ? "+1" : ""} ${this!.replaceAllMapped(RegExp(r'(\d{3})(\d{3})(\d+)'), (Match m) => "(${m[1]}) ${m[2]}-${m[3]}")}";
  }

  /// Truncate the string to given [length]
  /// [ellipsis] allows to add '...' in the end
  String? truncate({int maxLength = 10, bool ellipsis = false}) {
    if (this == null || this!.isEmpty) return this;

    return this!.length > maxLength
        ? ellipsis
            ? '${this!.substring(0, maxLength)}...'
            : this!.substring(0, maxLength)
        : this;
  }
}
