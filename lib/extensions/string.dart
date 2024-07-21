part of 'extensions.dart';

extension StringOperators on String? {
  /// Checks if the [length!] of the `String` is more than the length of [s].
  ///
  /// If the `String` is null or empty, it returns false.
  ///
  /// ### Example
  ///
  /// ```dart
  /// String foo = 'Hello';
  /// bool isMore = foo > 'Hi'; // returns true.
  /// ```
  bool operator >(String s) {
    if (isBlank) return false;

    return this!.length > s.length;
  }

  /// Checks if the [length!] of the `String` is more or equal than the length of [s].
  ///
  /// If the `String` is null or empty, it returns false.
  ///
  /// ### Example
  ///
  /// ```dart
  /// String foo = 'Hello';
  /// bool isMoreOrEqual = foo >= 'Hi'; // returns true.
  /// ```
  bool operator >=(String s) {
    if (isBlank) return false;

    return this!.length >= s.length;
  }

  /// Checks if the [length!] of the `String` is less than the length of [s].
  ///
  /// If the `String` is null or empty, it returns false.
  ///
  /// ### Example
  ///
  /// ```dart
  /// String foo = 'Hello';
  /// bool isLess = foo < 'Hi'; // returns false.
  /// ```
  bool operator <(String s) {
    if (isBlank) return false;

    return this!.length < s.length;
  }

  /// Checks if the [length!] of the `String` is less or equal than the length of [s].
  ///
  /// If the `String` is null or empty, it returns false.
  ///
  /// ### Example
  ///
  /// ```dart
  /// String foo = 'Hello';
  /// bool isLessOrEqual = foo <= 'Hi'; // returns false.
  /// ```
  bool operator <=(String s) {
    if (isBlank) return false;

    return this!.length <= s.length;
  }

  /// Removes a specified substring from the string.
  ///
  /// This operator method allows you to remove a specified substring from
  /// the string using the `-` operator. If either the original string or
  /// the substring is blank, appropriate behavior is handled.
  ///
  /// ### Example
  ///
  /// ```dart
  /// String text = "Hello, world!";
  /// String result = text - "world"; // "Hello, !"
  /// ```
  String operator -(String? s) {
    if (isBlank) return '';

    if (s.isBlank) return this!;

    return this!.replaceAll(s!, '');
  }
}

extension StringValidators on String? {
  /// Checks whether the `String` is `null`.
  /// ### Example 1
  /// ```dart
  /// String? foo;
  /// bool isNull = foo.isNull; // returns true
  /// ```
  /// ### Example 2
  /// ```dart
  /// String foo = 'fff';
  /// bool isNull = foo.isNull; // returns false
  /// ```
  bool get isNull => this == null || (this != null && this! == 'null');

  /// Checks whether the `String` is not `null`.
  /// ### Example 1
  /// ```dart
  /// String? foo;
  /// bool isNull = foo.isNotNull; // returns false
  /// ```
  /// ### Example 2
  /// ```dart
  /// String foo = 'fff';
  /// bool isNull = foo.isNotNull; // returns true
  /// ```
  bool get isNotNull => !isNull;

  /// Checks if the `String` is Blank (null, empty or only white spaces).
  bool get isBlank => isNull || (this?.trim().isEmpty ?? true);

  /// Checks if the `String` is not blank (null, empty or only white spaces).
  bool get isNotBlank => !isBlank;

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
    if (isBlank) return false;

    RegExp re = regex ?? RegExp(pattern ?? '');
    return re.hasMatch(this!);
  }

  /// Check if the string is an email
  bool get isEmail =>
      isNotBlank && this!.toLowerCase().matches(regex: Regex.email);

  /// Check if the string is a URL
  bool get isUrl => isNotBlank && (Uri.tryParse(this!)?.isAbsolute ?? false);

  /// Check if the string is an IP ([version] 4 or 6)
  ///
  /// [version] is a String or an `int` with options 4 and 6 only.
  bool isIP([Object? version]) {
    if (isBlank) return false;

    assert(
      version == null || version is String || version is int,
      'IP can only be a String or int',
    );

    version = version.toString();

    if (version == 'null') {
      return isIP(4) || isIP(6);
    } else if (version == '4') {
      if (!matches(regex: Regex.ipv4Maybe)) return false;

      var parts = this!.split('.')..sort((a, b) => int.parse(a) - int.parse(b));
      return int.parse(parts[3]) <= 255;
    }
    return version == '6' && matches(regex: Regex.ipv6);
  }

  /// Check if the string contains only letters (a-zA-Z).
  bool get isAlpha => matches(regex: Regex.alpha);

  /// Check if the string contains only letters and numbers
  bool get isAlphanumeric => matches(regex: Regex.alphanumeric);

  /// Check if the string contains only numbers
  bool get isNum => isNotBlank && num.tryParse(this!) != null;

  /// Check if the string is an integer
  bool get isInt => isNotBlank && int.tryParse(this!) != null;

  /// Check if the string is a float
  bool get isFloat => isNotBlank && double.tryParse(this!) != null;

  /// Check if a string is base64 encoded
  bool get isBase64 => matches(regex: Regex.base64);

  /// Check if the string is a hexadecimal number
  bool get isHexadecimal => matches(regex: Regex.hexadecimal);

  /// Check if the string is a hexadecimal color
  bool get isHexColor => matches(regex: Regex.hexColor);

  /// Check if the string is lowercase
  bool get isLowerCase => isNotBlank && this == this!.toLowerCase();

  /// Check if the string is uppercase
  bool get isUpperCase => isNotBlank && this == this!.toUpperCase();

  /// Check if the string is a number that's divisible by another
  ///
  /// [n] is a String or an int.
  bool isDivisibleBy(Object n) {
    if (isBlank) return false;

    assert(n is String || n is int, 'n can only be a String or Num');

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
    if (isBlank) return false;

    final surrogatePairs =
        Regex.surrogatePairsRegExp.allMatches(this!).toList();
    int len = this!.length - surrogatePairs.length;
    return len >= min && (max == null || len <= max);
  }

  /// Check if the string's length (in bytes) falls in a range.
  bool isByteLength(int min, [int? max]) {
    if (isBlank) return false;
    return this!.length >= min && (max == null || this!.length <= max);
  }

  /// Check if the string is a UUID (version 3, 4 or 5).
  bool isUuid([Object? version]) {
    if (isBlank) return false;

    if (version == null) {
      version = 'all';
    } else {
      version = version.toString();
    }

    RegExp? pat = Regex.uuid[version];
    return pat != null && pat.hasMatch(this!.toUpperCase());
  }

  /// Checks whether the `String` is a valid Guid.
  ///
  /// ### Example
  /// ```dart
  /// String foo = '6d64-4396-8547-1ec1b86e081e';
  /// bool isGuid = foo.isGuid; // returns false
  /// ```
  /// ```dart
  /// String foo = '887b7923-6d64-4396-8547-1ec1b86e081e';
  /// bool isGuid = foo.isGuid; // returns true
  /// ```
  bool get isGuid => matches(regex: Regex.guid);

  /// Check if the string is in an array of given values
  bool isIn(Object? values) {
    if (isBlank || values == null) return false;

    if (values is String) return values.contains(this!);

    if (values is! Iterable) return false;

    for (final Object? value in values) {
      if (value.toString() == this) return true;
    }
    return false;
  }

  /// Checks if the `String` provided is a valid credit card number using Luhn Algorithm.
  ///
  /// ### Example
  ///
  /// ```dart
  /// String cc = '5104 4912 8031 9406';
  /// bool isCreditCard = cc.isCreditCard ; returns true;
  /// ```
  bool get isCreditCard {
    if (isBlank) return false;

    String sanitized = this!.replaceAll(RegExp('[^0-9]+'), '');

    if (!sanitized.matches(regex: Regex.creditCard)) return false;

    // Luhn algorithm
    int sum = 0;
    String digit;
    bool shouldDouble = false;

    for (int i = sanitized.length - 1; i >= 0; i--) {
      digit = sanitized.substring(i, i + 1);
      int tmpNum = int.parse(digit);

      if (shouldDouble) {
        tmpNum *= 2;
        if (tmpNum >= 10) {
          sum += (tmpNum % 10) + 1;
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
    if (isBlank) return false;

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

  /// Checks if the `String` is a valid `json` format.
  ///
  /// ### Example
  ///
  /// ```dart
  /// String foo = '{"name":"John","age":30,"cars":null}';
  /// bool isJson = foo.isJson; // returns true
  /// ```
  bool get isJson {
    if (isBlank) return false;

    try {
      json.decode(this!);
    } catch (e) {
      return false;
    }
    return true;
  }

  /// Checks if the string contains any multibyte characters.
  ///
  /// This function uses the `multibyte` regular expression pattern to determine
  /// if the string contains any characters outside the ASCII range (0x00 to 0x7F).
  ///
  /// ### Example
  ///
  /// ```dart
  /// String text = "Hello, こんにちは!";
  /// bool hasMultibyte = text.hasMultibyteCharacters(); // true
  /// ```
  bool get isMultibyte => matches(regex: Regex.multibyte);

  /// Checks whether the `String` is a valid ASCII string.
  ///
  /// ### Example
  ///
  /// ```dart
  /// String foo = 'Hello World';
  /// bool isAscii = foo.isAscii; // returns true;
  /// ```
  ///
  /// ```dart
  /// String foo = 'œ∑´®†¥¨ˆøπ';
  /// bool isAscii = foo.isAscii; // returns false;
  /// ```
  bool get isAscii => matches(regex: Regex.ascii);

  /// Checks if the given string contains any full-width characters.
  ///
  /// This function uses a regular expression to determine if the input string
  /// contains any full-width characters. Full-width characters include characters
  /// that are not ASCII, half-width katakana, half-width Hangul, and certain symbols and digits.
  ///
  /// - Parameter [str]: The input string to check for full-width characters.
  ///
  /// Returns:
  /// - `true` if the input string contains any full-width characters, `false` otherwise.
  ///
  /// Example:
  /// ```dart
  /// String text = "Hello, こんにちは!";
  /// bool hasFullWidth = text.isFullWidth; // true
  /// ```
  bool get isFullWidth => matches(regex: Regex.fullWidth);

  /// Checks if the given string contains any half-width characters.
  ///
  /// This function uses a regular expression to determine if the input string
  /// contains any half-width characters. Half-width characters include ASCII,
  /// half-width katakana, half-width Hangul, and certain symbols and digits.
  ///
  /// - Parameter [str]: The input string to check for half-width characters.
  ///
  /// Returns:
  /// - `true` if the input string contains any half-width characters, `false` otherwise.
  ///
  /// Example:
  /// ```dart
  /// String text = "Hello, こんにちは!";
  /// bool hasHalfWidth = text.isHalfWidth; // true
  /// ```
  bool get isHalfWidth => matches(regex: Regex.halfWidth);

  /// Check if the string contains a mixture of full and half-width chars
  bool get isVariableWidth => isFullWidth && isHalfWidth;

  /// Checks if the given string contains any surrogate pairs.
  ///
  /// This function uses a regular expression to determine if the input string
  /// contains any surrogate pairs, which are used to represent characters outside
  /// the Basic Multilingual Plane in UTF-16 encoding.
  ///
  /// - Parameter [str]: The input string to check for surrogate pairs.
  ///
  /// Returns:
  /// - `true` if the input string contains any surrogate pairs, `false` otherwise.
  ///
  /// Example:
  /// ```dart
  /// String text = "Hello, 𠀋!";
  /// bool hasSurrogatePairs = text.isSurrogatePair; // true
  /// ```
  bool get isSurrogatePair => matches(regex: Regex.surrogatePairsRegExp);

  /// Checks whether the `String` complies to below rules :
  ///  * At least 1 uppercase
  ///  * At least 1 special character
  ///  * At least 1 number
  ///  * At least 8 characters in length
  /// ### Example
  /// ```dart
  /// String foo = 'qwerty';
  /// bool isStrong = foo.isStrongPassword; // returns false
  /// ```
  /// ```dart
  /// String foo = 'IsTh!$Strong';
  /// bool isStrong = foo.isStrongPassword; // returns true
  /// ```
  bool get isStrongPassword {
    if (isBlank) return false;

    var regex = RegExp(
      r'^(?=.*([A-Z]){1,})(?=.*[!@#$&*]{1,})(?=.*[0-9]{1,})(?=.*[a-z]{1,}).{8,100}$',
    );
    return regex.hasMatch(this!);
  }

  /// Checks if the `String` has only Latin characters.
  /// ### Example
  /// ```dart
  /// String foo = 'this is a τεστ';
  /// bool isLatin = foo.isLatin; // returns false
  /// String foo2 = 'this is hello world';
  /// bool isLatin2 = foo2.isLatin; // returns true
  /// ```
  bool get isLatin {
    if (isBlank) return false;

    return RegExp(r'^[a-zA-Z\s]+$').hasMatch(this!);
  }

  /// Returns `true` if the `String` contains only letters (Latin or Greek).
  ///
  /// ### Example
  ///
  /// ```dart
  /// String text = 'hello world';
  /// bool isLettersOnly = text.isLettersOnly; // Returns true
  /// ```
  bool get isLettersOnly {
    if (isBlank) return false;

    final onlyLetters = this!.onlyLetters;

    return onlyLetters?.length == this!.length;
  }

  /// Checks whether the `String` is an anagram of the provided `String`.
  ///
  /// ### Example
  ///
  /// ```dart
  /// String foo = 'Hello World';
  /// bool isAnagram = foo.isAnagramOf('World Hello'); // returns true;
  /// ```
  ///
  /// ```dart
  /// String foo = 'Hello World';
  /// bool isAnagram = foo.isAnagramOf('World Hello!'); // returns false;
  /// ```
  bool isAnagramOf(String s) {
    if (isBlank || s.isBlank) return false;

    final String? word1 = removeWhiteSpace, word2 = s.removeWhiteSpace;

    if (word1.isBlank || word2.isBlank || word1?.length != word2?.length) {
      return false;
    }

    Map<String, int> charCount = {};

    word1!
        .split('')
        .forEach((char) => charCount[char] = (charCount[char] ?? 0) + 1);

    word2!
        .split('')
        .forEach((char) => charCount[char] = (charCount[char] ?? 0) - 1);

    return charCount.values.every((count) => count == 0);
  }

  /// Checks whether the `String` is a palindrome.
  ///
  /// ### Example
  ///
  /// ```dart
  /// String foo = 'Hello World';
  /// bool isPalindrome = foo.isPalindrome; // returns false;
  /// ```
  ///
  /// ```dart
  /// String foo = 'racecar';
  /// bool isPalindrome = foo.isPalindrome; // returns true;
  /// ```
  bool get isPalindrome {
    if (isBlank) return false;

    return this == reverse;
  }

  /// Checks whether the `String` is consisted of both upper and lower case letters.
  ///
  /// ### Example
  ///
  /// ```dart
  /// String foo = 'Hello World';
  /// bool isMixedCase = foo.isMixedCase; // returns true;
  /// ```
  ///
  /// ```dart
  /// String foo = 'hello world';
  /// bool isMixedCase = foo.isMixedCase; // returns false;
  ///
  bool get isMixedCase {
    if (isBlank) return false;

    return this!.toUpperCase() != this && this!.toLowerCase() != this;
  }

  /// Checks whether the `String` has any whitespace characters.
  ///
  /// ### Example
  ///
  /// ```dart
  /// String foo = 'Hello World';
  /// bool hasWhitespace = foo.hasWhitespace; // returns true;
  /// ```
  ///
  /// ```dart
  /// String foo = 'HelloWorld';
  /// bool hasWhitespace = foo.hasWhitespace; // returns false;
  /// ```
  bool get hasWhitespace {
    if (isBlank) return false;

    return this!.contains(RegExp(r'\s'));
  }

  /// Checks if the given string contains any special characters.
  ///
  /// A special character is defined as any character that is not a letter
  /// (a-z, A-Z), digit (0-9), or space.
  ///
  /// This function uses a regular expression to determine if the input string
  /// contains any special characters. If the string contains only valid characters
  /// (letters, digits, spaces), the function returns false. Otherwise, it returns true.
  ///
  /// - Parameter [str]: The input string to check for special characters.
  ///
  /// Returns:
  /// - `true` if the input string contains any special characters, `false` otherwise.
  ///
  /// Example:
  /// ```dart
  /// String text = "Hello, world!";
  /// bool hasSpecialChar = text.hasSpecial; // true
  /// ```
  bool get hasSpecial => matches(regex: RegExp(r'^[a-zA-Z0-9 ]+$'));

  /// Checks if the current string equals the specified [other] string, ignoring case.
  ///
  /// The [other] parameter specifies the string to search for.
  ///
  /// Returns `true` if the current string is equal to the [other] string, ignoring case, otherwise `false`.
  ///
  /// Example:
  /// ```dart
  /// print('Hello World'.equalsIgnoreCase('hello')); // Output: false
  /// ```
  bool equalsIgnoreCase(String? other) =>
      (isBlank && other == null) ||
      (isNotBlank &&
          other != null &&
          this?.toLowerCase() == other.toLowerCase());

  /// Checks if the current string contains the specified [other] string, ignoring case.
  ///
  /// The [other] parameter specifies the string to search for.
  ///
  /// Returns `true` if the current string contains the [other] string, ignoring case, otherwise `false`.
  ///
  /// Example:
  /// ```dart
  /// print('Hello World'.containsIgnoreCase('hello')); // Output: true
  /// ```
  bool containsIgnoreCase(String other) {
    if (isBlank) return false;

    return this!.toLowerCase().contains(other.toLowerCase());
  }

  /// Compares this and [other] after converting to lower case.
  ///
  /// Both this and [other] must not be null.
  int compareIgnoreCase(String other) =>
      isNotBlank ? this!.toLowerCase().compareTo(other.toLowerCase()) : 0;

  /// Check if the string is a image path or url
  bool get isImage =>
      isNotBlank &&
      (matches(regex: Regex.image) || this!.startsWith('data:image'));

  /// Audio regex
  bool get isAudio => matches(regex: Regex.audio);

  /// Video regex
  bool get isVideo => matches(regex: Regex.video);

  /// Txt regex
  bool get isTxt => matches(regex: Regex.txt);

  /// Document regex
  bool get isDoc => matches(regex: Regex.doc);

  /// Excel regex
  bool get isExcel => matches(regex: Regex.excel);

  /// PPT regex
  bool get isPPT => matches(regex: Regex.ppt);

  /// Document regex
  bool get isApk => matches(regex: Regex.apk);

  /// PDF regex
  bool get isPdf => matches(regex: Regex.pdf);

  /// HTML regex
  bool get isHtml => matches(regex: Regex.html);
}

extension SanitizerExtensions on String? {
  /// Converts the string to a [double]. Returns NaN if parsing fails.
  double toFloat() =>
      isNotBlank ? double.tryParse(this!) ?? double.nan : double.nan;

  /// Converts the string to a [double]. Returns NaN if parsing fails.
  double toDouble() => toFloat();

  /// Converts the string to a [num]. [radix] is the base for integer parsing.
  int? toInt({int radix = 10}) =>
      isNotBlank ? int.tryParse(this!, radix: radix) : null;

  /// Converts a `String` to a numeric value if possible.
  ///
  /// If conversion fails, [double.nan] is returned.
  ///
  /// ### Example
  /// ```dart
  /// String foo = '4';
  /// int fooInt = foo.toNum(); // returns 4;
  /// ```
  /// ```dart
  /// String foo = '4f';
  /// var fooNull = foo.toNum(); // returns double.nan;
  /// ```
  num toNum() {
    if (isBlank) return double.nan;

    return num.tryParse(this!) ?? double.nan;
  }

  /// Checks the `String` and maps the value to a `bool` if possible.
  ///
  /// ### Example
  ///
  /// ```dart
  /// String text = 'yes';
  /// bool? textBool = text.toBool ; // returns true
  /// ```
  bool get toBool {
    if (isBlank) return false;

    String? lowerCase = this?.toLowerCase();

    if (this == '1' || lowerCase == 'true' || lowerCase == 'yes') return true;

    if (this == '0' || lowerCase == 'false' || lowerCase == 'no') return false;

    return false;
  }

  /// Trims characters from the left side of the string.
  String? leftTrim([String? chars]) => isNotBlank
      ? (chars != null)
          ? this!.replaceAll(RegExp('^[$chars]+'), '')
          : this!.replaceAll(RegExp(r'^\s+'), '')
      : null;

  /// Trims characters from the right side of the string.
  String? rightTrim([String? chars]) => isNotBlank
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
    final chars =
        keepNewLines ? '\x00-\x09\x0B\x0C\x0E-\x1F\x7F' : '\x00-\x1F\x7F';
    return blacklist(chars);
  }

  /// Generic string to enum function
  ///
  /// Converts the string to a [T]. Returns [orElse] or null if not found.
  ///
  /// Example:
  /// ```dart
  /// enum Fruit { apple, banana, orange }
  ///
  /// String input = "Apple";
  /// Fruit? fruit = input.toEnum(
  ///   values: Fruit.values,
  ///   orElse: () => Fruit.orange,
  /// );
  ///
  /// print(fruit); // Output: Fruit.apple
  /// ```
  T? toEnum<T>({required Iterable<T> values, T Function()? orElse}) {
    if (isBlank) return orElse?.call();

    return values.firstWhere(
      (element) =>
          element != null &&
          this!.toLowerCase() == (element as Enum).name.toLowerCase(),
      orElse: orElse,
    );
  }
}

extension StringConversions on String? {
  /// Capitalizes the `String` in normal form.
  /// ### Example
  /// ```dart
  /// String foo = 'hAckER';
  /// String cFoo = foo.capitalize; // returns 'Hacker'.
  /// ```
  String? get capitalize {
    if (isBlank) return this;

    return '${this![0].toUpperCase()}${this!.substring(1).toLowerCase()}';
  }

  /// Capitalizes the first character of each word in the string.
  String? get capitalizeEachWord {
    if (isBlank) return this;
    return this!.split(' ').map((word) => word.capitalize).join(' ');
  }

  /// Returns the `String` to snake_case.
  ///
  /// ### Example
  /// ```dart
  /// String foo = 'SNAKE CASE';
  /// String fooSnake = foo.toSnakeCase; // returns 'snake_case'
  /// ```
  String? get toSnakeCase {
    if (isBlank) return this;

    var words = this!.toLowerCase().trim().split(RegExp(r'(\s+)'));
    var snakeWord = '';

    if (this!.length == 1) return this;

    for (var i = 0; i <= words.length - 1; i++) {
      if (i == words.length - 1) {
        snakeWord += words[i];
      } else {
        snakeWord += '${words[i]}_';
      }
    }
    return snakeWord;
  }

  /// Returns the `String` in camel case.
  /// ### Example
  /// ```dart
  /// String foo = 'Find max of array';
  /// String camelCase = foo.toCamelCase; // returns 'findMaxOfArray'
  /// ```
  String? get toCamelCase {
    if (isBlank) return this;

    var words = this!.trim().split(RegExp(r'(\s+)'));

    var buffer = StringBuffer()..write(words[0].toLowerCase());

    for (var i = 1; i < words.length; i++) {
      buffer
        ..write(words[i].substring(0, 1).toUpperCase())
        ..write(words[i].substring(1).toLowerCase());
    }

    return buffer.toString();
  }

  /// Returns the `String` title cased.
  ///
  /// ```dart
  /// String foo = 'Hello dear friend how you doing ?';
  /// Sting titleCased = foo.toTitleCase; // returns 'Hello Dear Friend How You Doing'.
  /// ```
  String? get toTitleCase {
    if (isBlank) return this;

    var words = this!.trim().toLowerCase().split(' ');
    for (var i = 0; i < words.length; i++) {
      words[i] = words[i].substring(0, 1).toUpperCase() + words[i].substring(1);
    }

    return words.join(' ');
  }

  /// Converts a string to kebab case.
  ///
  /// Kebab case is a naming convention where words are separated by hyphens.
  /// This method replaces any occurrence of a lowercase letter followed by an
  /// uppercase letter with the lowercase letter, a hyphen, and the uppercase
  /// letter. The resulting string is then converted to lowercase.
  ///
  /// Returns the kebab case representation of the string.
  ///
  /// Example:
  /// ```dart
  /// 'camelCaseString'.toKebabCase; // 'camel-case-string'
  /// ```
  String? get toKebabCase {
    if (isBlank) return this;
    return this!
        .replaceAllMapped(RegExp(r'\s'), (match) => '')
        .replaceAllMapped(
          RegExp('([a-z])([A-Z])'),
          (match) => '${match[1]}-${match[2]}',
        )
        .toLowerCase();
  }

  /// Returns a list of the `String`'s characters.
  ///
  /// O(n)
  ///
  /// ### Example
  /// ```dart
  /// String foo = 'abracadabra';
  /// List<String> fooArray = foo.toArray; // returns '[a,b,r,a,c,a,d,a,b,r,a]'
  /// ```
  List<String> get toArray {
    if (isBlank) return [];

    return this!.split('');
  }

  /// Returns a string abbreviation like Jon Doe -> JD.
  String get toInitials {
    if (isBlank) return '';

    final nameParts = this!.trim.call().toUpperCase().split(RegExp(r'[\s/]+'));

    if (nameParts.length > 1) {
      return nameParts.first.substring(0, 1) + nameParts[1].substring(0, 1);
    }

    return nameParts.first.length > 1
        ? nameParts.first.substring(0, 2)
        : nameParts.first;
  }

  /// Removes only the letters from the `String`.
  /// ### Example 1
  /// ```dart
  /// String foo = 'es4e5523nt1is';
  /// String noLetters = foo.removeLetters; // returns '455231'
  /// ```
  /// ### Example 2
  /// ```dart
  /// String foo = '1244e*s*4e*5523n*t*1i*s';
  /// String noLetters = foo.removeLetters; // returns '1244**4*5523**1*'
  /// ```
  String? get removeLetters {
    if (isBlank) return this;

    var regex = RegExp('([a-zA-Z]+)');
    return this!.replaceAll(regex, '');
  }

  /// Removes only the numbers from the `String`.
  /// ### Example 1
  /// ```dart
  /// String foo = 'es4e5523nt1is';
  /// String noNumbers = foo.removeNumbers; // returns 'esentis'
  /// ```
  /// ### Example 2
  /// ```dart
  /// String foo = '1244e*s*4e*5523n*t*1i*s';
  /// String noNumbers = foo.removeNumbers; // returns 'e*s*e*n*t*i*s'
  /// ```
  String? get removeNumbers {
    if (isBlank) return this;

    var regex = RegExp(r'(\d+)');
    return this!.replaceAll(regex, '');
  }

  /// Returns only the numbers from the `String`.
  /// ### Example
  /// ```dart
  /// String foo = '4*%^55/es4e5523nt1is';
  /// String onyNumbers = foo.onlyNumbers; // returns '455455231'
  /// ```
  String? get onlyNumbers {
    if (isBlank) return this;

    var regex = RegExp('([^0-9]+)');
    return this!.replaceAll(regex, '');
  }

  /// Returns only the Latin characters from the `String`.
  /// ### Example
  /// ```dart
  /// String foo = '4*%^55/es4e5523nt1is';
  /// String onlyLatin = foo.onlyLatin; // returns 'esentis'
  /// ```
  String? get onlyLatin {
    if (isBlank) return this;

    var regex = RegExp(r'([^a-zA-Z\s]+)');
    return this!.replaceAll(regex, '');
  }

  /// Returns only the Latin OR Greek characters from the `String`.
  /// ### Example
  /// ```dart
  /// String foo = '4*%^55/σοφ4e5523ια';
  /// String onlyL1 = foo.onlyLetters; // returns 'σοφια'
  /// String foo2 = '4*%^55/es4e5523nt1is';
  /// String onlyL2 = foo2.onlyLetters; // returns 'esentis'
  /// ```
  String? get onlyLetters {
    if (isBlank) return this;

    var regex = RegExp(r'([^α-ωΑ-ΩίϊΐόάέύϋΰήώΊΪΌΆΈΎΫΉΏa-zA-Z\s]+)');
    return this!.replaceAll(regex, '');
  }

  /// Returns all special characters from the `String`.
  /// ### Example
  /// ```dart
  /// String foo = '/!@#\$%^\-&*()+",.?":{}|<>~_-`*%^/ese?:"///ntis/!@#\$%^&*(),.?":{}|<>~_-`';
  /// String removed = foo.removeSpecial; // returns 'esentis'
  /// ```
  String? get removeSpecial {
    if (isBlank) return this;

    var regex = RegExp(r'[/!@#$%^\-&*()+",.?":{}|<>~_-`]');
    return this!.replaceAll(regex, '');
  }

  /// Removes all whitespace from the `String`.
  ///
  /// ### Example
  ///
  /// ```dart
  /// String foo = '   Hel l o W   orld';
  /// String striped = foo.removeWhiteSpace; // returns 'HelloWorld';
  /// ```
  String? get removeWhiteSpace {
    if (isBlank) return this;

    return this!.replaceAll(RegExp(r'\s+'), '');
  }

  /// Removes all punctuation characters from the given string.
  ///
  /// Returns an empty string if the input is null.
  ///
  /// Returns a new string with all punctuation characters removed.
  ///
  /// Example:
  /// ```dart
  /// String input = "Hello, world!";
  /// String output = input.removePunctuation;
  /// print(output); // Output: "Hello world"
  /// ```
  ///
  /// Returns:
  /// A new string with all punctuation characters removed.
  String? get removePunctuation {
    if (isBlank) return this;

    return this!.replaceAll(RegExp(r'[^\w\s]'), '');
  }

  /// Returns a new string with leading and trailing characters removed.
  ///
  /// The optional [chars] argument specifies the characters to remove.
  ///
  /// If [chars] is not provided, it removes leading and trailing whitespace.
  String? strip([String? chars]) {
    if (isBlank) return this;

    if (chars != null) {
      return this!.replaceAll(RegExp('^[$chars]+|[$chars]+\$'), '');
    } else {
      return this!.trim();
    }
  }

  /// Strips all HTML code from `String`.
  ///
  /// ### Example
  /// ```dart
  /// String html = '<script>Hacky hacky.</script> <p>Here is some text. <span class="bold">This is bold. </span></p>';
  /// String stripped = html.stripHtml; // returns 'Hacky hacky. Here is some text. This is bold.';
  /// ```
  String? get stripHtml {
    if (isBlank) return this;

    var regex = RegExp('<[^>]*>');
    return this!.replaceAll(regex, '');
  }

  /// Truncate the string to given [length]
  /// [ellipsis] allows to add '...' in the end
  String? truncate({int length = 10, bool ellipsis = false}) {
    if (isBlank || length <= 0 || length >= this!.length) return this;

    return this!.substring(0, length) + (ellipsis ? '...' : '');
  }

  /// Truncates a long `String` in the middle while retaining the beginning and the end.
  ///
  /// [maxChars] must be more than 0.
  ///
  /// If [maxChars] > String.length the same `String` is returned without truncation.
  ///
  /// ### Example
  ///
  /// ```dart
  /// String f = 'congratulations';
  /// String truncated = f.truncateMiddle(5); // Returns 'con...ns'
  /// ```
  String? truncateMiddle(int maxChars) {
    if (isBlank || maxChars <= 0 || maxChars > this!.length) return this;

    int leftChars = (maxChars / 2).ceil();
    int rightChars = maxChars - leftChars;
    return '${this!.first(n: leftChars)}...${this!.last(n: rightChars)}';
  }

  /// Returns the `String` reversed.
  /// ### Example
  /// ```dart
  /// String foo = 'Hello World';
  /// String reversed = foo.reverse; // returns 'dlrow olleH'
  /// ```
  String? get reverse {
    if (isBlank) return this;

    var letters = this!.split('').toList().reversed;
    return letters.reduce((current, next) => current + next);
  }

  /// Returns the first [n] characters of the `String`.
  ///
  /// n is optional, by default it returns the first character of the `String`.
  ///
  /// If [n] provided is longer than the `String`'s length, the string will be returned.
  ///
  /// Faster than using
  /// ```dart
  /// substring(0,count)
  /// ```
  /// ### Example 1
  /// ```dart
  /// String foo = 'hello world';
  /// String firstChars = foo.first(); // returns 'h'
  /// ```
  /// ### Example 2
  /// ```dart
  /// String foo = 'hello world';
  /// bool firstChars = foo.first(3); // returns 'hel'
  /// ```
  String? first({int n = 1}) {
    if (isBlank || this!.length < n || n < 0) return this;

    return this!.substring(0, n);
  }

  /// Returns the last [n] characters of the `String`.
  ///
  /// [n] is optional, by default it returns the first character of the `String`.
  ///
  /// If [n] provided is longer than the `String`'s length, the string will be returned.
  ///
  /// Faster than using
  /// ```dart
  /// substring(length-n,length)
  /// ```
  /// ### Example 1
  /// ```dart
  /// String foo = 'hello world';
  /// String firstChars = foo.last(); // returns 'd'
  /// ```
  /// ### Example 2
  /// ```dart
  /// String foo = 'hello world';
  /// bool firstChars = foo.last(3); // returns 'rld'
  /// ```
  String? last({int n = 1}) {
    if (isBlank || this!.length < n || n < 0) return this;

    return this!.substring(this!.length - n, this!.length);
  }

  /// Adds a [replacement] character at [index] of the `String`.
  ///
  /// ### Example
  /// ```dart
  /// String foo = 'hello';
  /// String replaced = foo.replaceAtIndex(index:2,replacement:''); // returns 'helo';
  /// ```
  String? replaceAt({required int index, required String replacement}) {
    if (isBlank) return this;

    if (index > this!.length) return this;

    if (index < 0) return this;

    return '${this!.substring(0, index)}$replacement${this!.substring(index + 1, this!.length)}';
  }

  /// Given a pattern returns the starting indices of all occurrences of the [pattern] in the `String`.
  ///
  /// ### Example
  /// ```dart
  /// String foo = 'abracadabra';
  /// String result = foo.findPatterns(pattern:'abr'); // returns '[0, 7]'
  /// ```
  List<int> findPattern({required String pattern}) {
    if (isBlank) return [];

    List<int> occurrences = [];
    // How many times the pattern can fit the text provided
    var fitCount = (this!.length / pattern.length).truncate();

    if (fitCount > this!.length) return [];

    if (fitCount == 1) {
      if (this == pattern) return [0];

      return [];
    }

    for (var i = 0; i <= this!.length; i++) {
      if (i + pattern.length > this!.length) return occurrences;

      if (this!.substring(i, i + pattern.length) == pattern) occurrences.add(i);
    }

    return occurrences;
  }

  /// Repeats the `String` [count] times.
  ///
  /// ### Example
  /// ```dart
  /// String foo = 'foo';
  /// String fooRepeated = foo.repeat(5); // 'foofoofoofoofoo'
  /// ```
  String? repeat(int count) {
    if (isBlank || count <= 0) return this;

    return this! * count;
  }

  /// Squeezes the `String` by removing repeats of a given character.
  ///
  /// ### Example
  /// ```dart
  /// String foo = 'foofoofoofoofoo';
  /// String fooSqueezed = foo.squeeze('o'); // 'fofofofofo';
  /// ```
  String? squeeze(String char) {
    if (isBlank) return this;

    var sb = '';
    for (var i = 0; i < this!.length; i++) {
      if (i == 0 ||
          this![i - 1] != this![i] ||
          (this![i - 1] == this![i] && this![i] != char)) {
        sb += this![i];
      }
    }
    return sb;
  }

  /// Checks if the `String` is consisted of same characters (ignores cases).
  ///
  /// ### Example
  /// ```dart
  /// String foo1 = 'ttttttt'
  /// bool hasSame1 = foo.hasSameCharacters; // true;
  /// ```
  /// ```dart
  /// String foo = 'ttttttt12'
  /// bool hasSame2 = foo.hasSameCharacters;  // false;
  /// ```
  bool get hasSameCharacters {
    if (isBlank) return false;

    if (this!.length > 1) {
      var b = this![0].toLowerCase();
      for (var i = 1; i < this!.length; i++) {
        var c = this![i].toLowerCase();
        if (c != b) {
          return false;
        }
      }
    }
    return true;
  }

  /// Shuffles the given `String`'s characters.
  ///
  /// ### Example
  /// ```dart
  /// String foo1 = 'esentis';
  /// String shuffled = foo.shuffle; // 'tsniees'
  /// ```
  String? get shuffle {
    if (isBlank) return this;

    var stringArray = toArray..shuffle();
    return stringArray.join();
  }

  /// Formats the `String` with a specific mask.
  ///
  /// You can assign your own [specialChar], defaults to '#'.
  ///
  /// ### Example
  /// ```dart
  ///var string3 = 'esentisgreece';
  ///var mask3 = 'Hello ####### you are from ######';
  ///var masked3 = string3.formatWithMask(mask3); // returns 'Hello esentis you are from greece'
  /// ```
  String? formatWithMask(String mask, {String specialChar = '#'}) {
    if (isBlank) return this;

    //var buffer = StringBuffer();
    var maskChars = mask.toArray;
    var index = 0;
    var out = '';
    for (final m in maskChars) {
      if (m == specialChar) {
        if (index < this!.length) {
          out += this![index];
          index++;
        }
      } else {
        out += m;
      }
    }
    return out;
  }

  /// Removes the first [n] characters from the `String`.
  ///
  /// ### Example
  /// ```dart
  /// String foo = 'esentis'
  /// String newFoo = foo.removeFirst(3) // 'ntis';
  /// ```
  String? removeFirst(int n) {
    if (isBlank) return this;

    if (n <= 0) return this;

    if (n >= this!.length) return '';

    return this!.substring(n, this!.length);
  }

  /// Removes the last [n] characters from the `String`.
  ///
  /// ### Example
  /// ```dart
  /// String foo = 'esentis';
  /// String newFoo = foo.removeLast(3); // 'esen';
  /// ```
  String? removeLast(int n) {
    if (isBlank || n <= 0) return this;

    if (n >= this!.length) return '';

    return this!.substring(0, this!.length - n);
  }

  /// Trims the `String` to have maximum [n] characters.
  ///
  /// ### Example
  /// ```dart
  /// String foo = 'esentis';
  /// String newFoo = foo.maxChars(3); // 'esen';
  /// ```
  String? maxChars(int n) {
    if (isBlank || n >= this!.length) return this;

    if (n <= 0) return '';

    return this!.substring(0, n);
  }

  /// Reverses slash in the `String`, by providing [direction],
  ///
  /// `0 = / -> \\`
  ///
  /// `1 = \\-> /`
  ///
  /// ### Example
  /// ```dart
  /// String foo1 = 'C:/Documents/user/test';
  /// String revFoo1 = foo1.reverseSlash(0); // returns 'C:\Documents\user\test'
  ///
  /// String foo2 = 'C:\\Documents\\user\\test';
  /// String revFoo2 = foo1.reverseSlash(1); // returns 'C:/Documents/user/test'
  /// ```
  String? reverseSlash(int direction) {
    if (isBlank) return this;

    switch (direction) {
      case 0:
        return this!.replaceAll('/', r'\');
      case 1:
        return this!.replaceAll(r'\', '/');
      default:
        return this;
    }
  }

  /// Returns the character at [index] of the `String`.
  ///
  /// ### Example
  ///
  /// ```dart
  /// String foo1 = 'esentis';
  /// String char1 = foo1.charAt(0); // returns 'e'
  /// String char2 = foo1.charAt(4); // returns 'n'
  /// String? char3 = foo1.charAt(-20); // returns null
  /// String? char4 = foo1.charAt(20); // returns null
  /// ```
  String? charAt(int index) {
    if (isBlank) return this;

    if (index > this!.length) return null;

    if (index < 0) return null;

    return this!.split('')[index];
  }

  /// Appends a [suffix] to the `String`.
  ///
  /// ### Example
  ///
  /// ```dart
  /// String foo = 'hello';
  /// String newFoo = foo1.append(' world'); // returns 'hello world'
  /// ```
  String append(String suffix) {
    if (isBlank) return suffix;

    return this! + suffix;
  }

  /// Prepends a [prefix] to the `String`.
  ///
  /// ### Example
  ///
  /// ```dart
  /// String foo = 'world';
  /// String newFoo = foo1.prepend('hello '); // returns 'hello world'
  /// ```
  String prepend(String prefix) {
    if (isBlank) return prefix;

    return prefix + this!;
  }

  /// Returns the left side of the `String` starting from [char].
  ///
  /// If [char] doesn't exist, `null` is returned.
  /// ### Example
  ///
  /// ```dart
  ///  String s = 'peanutbutter';
  ///  String foo = s.leftOf('butter'); // returns 'peanut'
  /// ```
  String? leftOf(String char) {
    if (isBlank) return this;

    int index = this!.indexOf(char);

    if (index == -1) return null;

    return this!.substring(0, index);
  }

  /// Returns the right side of the `String` starting from [char].
  ///
  /// If [char] doesn't exist, `null` is returned.
  ///
  /// ### Example
  ///
  /// ```dart
  ///  String s = 'peanutbutter';
  ///  String foo = s.rightOf('peanut'); // returns 'butter'
  /// ```
  String? rightOf(String char) {
    if (isBlank) return this;

    int index = this!.indexOf(char);

    if (index == -1) return null;

    return this!.substring(index + char.length, this!.length);
  }

  /// Quotes the `String` adding "" at the start & at the end.
  ///
  /// Removes all " characters from the `String` before adding the quotes.
  ///
  /// ### Example
  ///
  /// ```dart
  /// String text = '"""Is this real"';
  /// String quote = text.quote; // "Is this real"
  /// ```
  String? get quote {
    if (isBlank) return this;

    String normalizedString = this!.replaceAll('"', '');

    return normalizedString.append('"').prepend('"');
  }

  /// Trims leading and trailing spaces from the `String`, so as extra spaces in between words.
  ///
  /// ### Example
  ///
  /// ```dart
  /// String text = '    esentis    thinks   ';
  /// String trimmed = text.trimAll ; // returns 'esentis thinks'
  /// ```
  String? get trimAll {
    if (isBlank) return this;

    return this!.trim().replaceAll(RegExp(' +'), ' ');
  }

  /// Returns the `String` after a specific character.
  ///
  /// ### Example
  ///
  /// ```dart
  /// String test = 'hello brother what a day today';
  /// String afterString = test.after('brother'); // returns ' what a day today'
  /// ```
  String? after(String pattern) {
    if (isBlank) return this;

    if (!this!.contains(pattern)) return '';

    List<String> patternWords = pattern.split(' ');

    if (patternWords.isEmpty) return '';

    int indexOfLastPatternWord = this!.indexOf(patternWords.last);

    if (patternWords.last.isEmpty) return '';

    return this!.substring(
      indexOfLastPatternWord + patternWords.last.length,
      this!.length,
    );
  }

  /// Returns the `String` before a specific character
  ///
  /// ### Example
  ///
  /// ```dart
  /// String test = 'hello brother what a day today';
  /// String beforeString = test.before('brother'); // returns 'hello '
  /// ```
  String? before(String pattern) {
    if (isBlank) return this;

    if (!this!.contains(pattern)) return '';

    List<String> patternWords = pattern.split(' ');

    if (patternWords.isEmpty) return '';

    int indexOfFirstPatternWord = this!.indexOf(patternWords.first);

    if (patternWords.last.isEmpty) return '';

    return this!.substring(0, indexOfFirstPatternWord);
  }

  /// Continuously removes from the beginning of the `String` any match in [patterns].
  ///
  /// ### Example
  ///
  /// ```dart
  /// String s = "esentis".removeFirstAny(["s", "ng"]);// returns "esentis";
  /// ```
  String? removeFirstAny(List<String?> patterns) {
    var from = this;
    if (from.isNotBlank) {
      for (final pattern in patterns) {
        if (pattern != null && pattern.isNotEmpty) {
          while (from!.startsWith(pattern)) {
            from = from.removeFirst(pattern.length);
          }
        }
      }
    }
    return from;
  }

  /// Continuously removes from the end of the `String`, any match in [patterns].
  ///
  /// ### Example
  ///
  /// ```dart
  /// String s = "esentisfs12".removeLastAny(["12","s","ng","f",]); // returns "esentis";
  /// ```
  String? removeLastAny(List<String?> patterns) {
    var from = this;
    if (from.isNotBlank) {
      for (final pattern in patterns) {
        if (pattern != null && pattern.isNotEmpty) {
          while (from!.endsWith(pattern)) {
            from = from.removeLast(pattern.length);
          }
        }
      }
    }
    return from;
  }

  /// Continuously removes from the beginning & the end of the `String`, any match in [patterns].
  String? removeFirstAndLastAny(List<String?> patterns) =>
      removeFirstAny(patterns).removeLastAny(patterns);

  /// Removes the [pattern] from the end of the `String`.
  ///
  /// ### Example
  ///
  /// ```dart
  /// String s = "coolboy".removeLastEqual("y"); // returns "coolbo";
  /// ```
  String? removeLastEqual(String? pattern) => removeLastAny([pattern]);

  /// Removes any [pattern] match from the beginning of the `String`.
  ///
  /// ### Example
  ///
  /// ```dart
  /// String s = "djing".removeFirstEqual("dj"); // returns "ing"
  /// ```
  String? removeFirstEqual(String? pattern) => removeFirstAny([pattern]);

  /// Removes any [pattern] match from the beginning & the end of the `String`.
  ///
  /// ### Example
  ///
  /// ```dart
  /// String edited = "abracadabra".removeFirstAndLastEqual("a"); // returns "bracadabr";
  /// ```
  String? removeFirstAndLastEqual(String? pattern) =>
      removeFirstEqual(pattern).removeLastEqual(pattern);

  /// Removes everything in the `String` after the first match of the [pattern].
  ///
  /// ### Example
  /// ```dart
  /// String test = 'hello brother what a day today';
  /// String afterString = test.removeAfter('brother'); // returns 'hello ';
  /// ```
  String? removeAfter(String pattern) {
    if (isBlank) return this;

    if (!this!.contains(pattern)) return '';

    List<String> patternWords = pattern.split(' ');

    if (patternWords.isEmpty) return '';

    int indexOfLastPatternWord = this!.indexOf(patternWords.last);

    if (patternWords.last.isEmpty) return '';

    return this!.substring(0, indexOfLastPatternWord);
  }

  /// Removes everything in the `String` before the match of the [pattern].
  ///
  /// ### Example
  ///
  /// ```dart
  /// String test = 'hello brother what a day today';
  /// String afterString = test.removeBefore('brother'); // returns 'brother what a day today';
  /// ```
  String? removeBefore(String pattern) {
    if (isBlank) return this;

    if (!this!.contains(pattern)) return '';

    List<String> patternWords = pattern.split(' ');

    if (patternWords.isEmpty) return '';

    int indexOfFirstPatternWord = this!.indexOf(patternWords.first);

    if (patternWords.last.isEmpty) return '';

    return this!.substring(
      indexOfFirstPatternWord + 1,
      this!.length,
    );
  }

  /// Replaces the part of the string after the first occurrence of the given [delimiter]
  /// with the [replacement] string. If the string does not contain the delimiter,
  /// returns [defaultValue] or the original string if [defaultValue] is not provided.
  String? replaceAfter(
    String delimiter,
    String replacement, [
    String? defaultValue,
  ]) {
    if (this == null) return null;
    final index = this!.indexOf(delimiter);
    return (index == -1)
        ? (defaultValue?.isEmpty ?? true)
            ? this
            : defaultValue
        : this!
            .replaceRange(index + delimiter.length, this!.length, replacement);
  }

  /// Replaces the part of the string before the first occurrence of the given [delimiter]
  /// with the [replacement] string. If the string does not contain the delimiter,
  /// returns [defaultValue] or the original string if [defaultValue] is not provided.compareIgnoreCase
  String? replaceBefore(
    String delimiter,
    String replacement, [
    String? defaultValue,
  ]) {
    if (this == null) return null;
    final index = this!.indexOf(delimiter);
    return (index == -1)
        ? (defaultValue?.isEmpty ?? true)
            ? this
            : defaultValue
        : this!.replaceRange(0, index, replacement);
  }

  /// Adds a `String` after the first match of the [pattern]. The [pattern] should not be `null`.
  ///
  /// If there is no match, the `String` is returned unchanged.
  ///
  /// ### Example
  ///
  /// ```dart
  /// String test = 'hello brother what a day today';
  /// String afterString = test.addAfter('brother', ' sam '); // returns 'hello brother sam what a day today ';
  /// ```
  String? addAfter(String pattern, String addition) {
    if (isBlank) return this;

    if (!this!.contains(pattern)) return this;

    List<String> patternWords = pattern.split(' ');

    if (patternWords.isEmpty) return '';

    int indexOfLastPatternWord = this!.indexOf(patternWords.last);

    if (patternWords.last.isEmpty) return '';

    return this!.substring(0, indexOfLastPatternWord + 1) +
        addition +
        this!.substring(indexOfLastPatternWord + 1, this!.length);
  }

  /// Adds a `String` before the first match of the [pattern]. The [pattern] should not be `null`.
  ///
  /// If there is no match, the `String` is returned unchanged.
  ///
  /// ### Example
  /// ```dart
  /// String test = 'hello brother what a day today';
  /// String afterString = test.addBefore('brother', 'big '); // returns 'hello big brother what a day today';
  /// ```
  String? addBefore(String pattern, String addition) {
    if (isBlank) return this;

    if (!this!.contains(pattern)) return this;

    List<String> patternWords = pattern.split(' ');

    if (patternWords.isEmpty) return '';

    int indexOfFirstPatternWord = this!.indexOf(patternWords.first);

    if (patternWords.last.isEmpty) return '';

    return this!.substring(0, indexOfFirstPatternWord) +
        addition +
        this!.substring(indexOfFirstPatternWord, this!.length);
  }

  /// Checks if the `String` matches **ANY** of the given [patterns].
  ///
  /// ### Example
  ///
  /// ```dart
  /// bool contains = "abracadabra".containsAny(["a", "p"]); // returns true;
  /// ```
  bool containsAny(List<String?> patterns) {
    if (isNotBlank) {
      for (final String? item
          in patterns.where((element) => element.isNotBlank)) {
        if (this!.contains(item!)) return true;
      }
    }
    return false;
  }

  /// Checks if the `String` matches **ALL** given [patterns].
  ///
  /// ### Example
  ///
  /// ```dart
  /// bool contains = "abracadabra".containsAll(["abra", "cadabra"]; // returns true;
  /// ```
  bool containsAll(List<String?> patterns) {
    for (final String? item
        in patterns.where((element) => element.isNotBlank)) {
      if (isBlank || !this!.contains(item!)) return false;
    }
    return true;
  }

  /// Inserts a `String` at the specified index.
  ///
  /// If the `String` is `null`, an `ArgumentError` is thrown.
  ///
  /// ### Example
  ///
  /// ```dart
  /// String text = 'hello world';
  /// String newText = text.insertAt(5, '!');
  /// print(newText); // prints 'hello! world'
  /// ```
  String? insertAt(int i, String value) {
    if (isNull) return this;

    if (i < 0 || i > this!.length) throw RangeError('Index out of range');

    final start = this!.substring(0, i);
    final end = this!.substring(i);
    return start + value + end;
  }

  /// Returns a new `String` with the first occurrence of the given pattern replaced with the replacement `String`.
  ///
  /// If the `String` is `null`, an `ArgumentError` is thrown.
  ///
  /// ### Example
  ///
  /// ```dart
  /// String s = "esentis".replaceFirst("s", "S"); // returns "eSentis";
  /// ```
  String? replaceFirst(String pattern, String replacement) {
    if (isNull) return this;

    int index = this!.indexOf(pattern);

    if (index == -1) return this!;

    return this!.replaceRange(index, index + pattern.length, replacement);
  }

  /// Returns a new `String` with the last occurrence of the given pattern replaced with the replacement `String`.
  ///
  /// If the `String` is `null`, an `ArgumentError` is thrown.
  ///
  /// ### Example
  ///
  /// ```dart
  /// String s = "esentis".replaceLast("s", "S"); // returns "esentiS";
  /// ```
  String? replaceLast(String pattern, String replacement) {
    if (isNull) return this;

    int index = this!.lastIndexOf(pattern);

    if (index == -1) return this!;

    return this!.replaceRange(index, index + pattern.length, replacement);
  }

  /// Splits the `String` into a `List` of lines ('\r\n' or '\n').
  ///
  /// If the `String` is `null`, an `ArgumentError` is thrown.
  ///
  /// ### Example
  ///
  /// ```dart
  /// String text = 'hello\nworld';
  /// List<String> lines = text.splitLines;
  /// print(lines); // prints ['hello', 'world']
  /// ```
  List<String> get splitLines {
    if (isNull) return [];

    return this!.split(RegExp(r'\r?\n'));
  }

  /// Wrap the given string between the [wrapWith].
  String? wrap(String wrapWith) {
    if (isBlank) return this;
    return '$wrapWith$this$wrapWith';
  }

  /// Returns a new string with the current string centered in a string of length [width].
  ///
  /// If the current string is already longer than [width], the original string is returned.
  ///
  /// The optional [fillChar] parameter specifies the character to use for padding.
  /// Defaults to a space character.
  ///
  /// Example:
  /// ```dart
  /// print('hello'.center(10)); // Output: '   hello   '
  /// print('hello'.center(10, '-')); // Output: '---hello---'
  /// ```
  String? center(int width, [String fillChar = ' ']) {
    if (isBlank) return this;

    if (width <= this!.length) return this;
    int totalPadding = width - this!.length;
    int leftPadding = totalPadding ~/ 2;
    int rightPadding = totalPadding - leftPadding;
    return fillChar * leftPadding + this! + fillChar * rightPadding;
  }
}

extension MiscExtensions on String? {
  /// Returns the average read time duration of the given `String` in seconds.
  ///
  /// The default calculation is based on 200 words per minute.
  ///
  /// You can pass the [wordsPerMinute] parameter for different read speeds.
  /// ### Example
  /// ```dart
  /// String foo =  'Hello dear friend how you doing ?';
  /// int readTime = foo.readTime(); // returns 3 seconds.
  /// ```
  int readTime({int wordsPerMinute = 200}) {
    if (isBlank) return 0;

    var words = this!.trim().split(RegExp(r'(\s+)'));
    var magicalNumber = words.length / wordsPerMinute;
    return (magicalNumber * 100).toInt();
  }

  /// Returns the word count in the given `String`.
  ///
  /// The pattern is based on spaces.
  /// ### Example
  /// ```dart
  /// String foo = 'Hello dear friend how you doing ?';
  /// int count = foo.wordCount; // returns 6 words.
  /// ```
  int get wordCount {
    if (isBlank) return 0;

    var words = this!.trim().split(RegExp(r'(\s+)'));
    // We filter out symbols and numbers from the word count
    var filteredWords = words.where((e) => e.onlyLatin.isNotBlank);
    return filteredWords.length;
  }

  /// Returns the digit count of the `String`.
  ///
  ///### Example
  ///
  ///```dart
  ///String foo = 'Hello World';
  ///int digitCount = foo.getDigitCount(); // returns 0;
  ///```
  ///
  ///```dart
  ///String foo = 'Hello World 123';
  ///int digitCount = foo.getDigitCount(); // returns 3;
  ///```
  int get digitCount {
    if (isBlank) return 0;

    RegExp digitsOnly = RegExp(r'\d');
    return digitsOnly.allMatches(this!).length;
  }

  /// Finds a specific's character occurrence in the `String`.
  ///
  /// ### Example
  /// ```dart
  /// String foo = 'foo';
  /// int occ = foo.charCount('o'); // returns 2
  /// ```
  int charCount(String char) {
    if (isBlank) return 0;

    return this!.split('').fold<int>(
          0,
          (previousValue, ch) => previousValue + (ch == char ? 1 : 0),
        );
  }

  /// Counts the number of occurrences of a specific word in the string.
  ///
  /// This method uses a regular expression to find all occurrences of the
  /// specified word in the string and returns the count of these occurrences.
  ///
  /// - Parameter [word]: The word to count within the string.
  ///
  /// Returns:
  /// - The number of occurrences of the specified word in the string.
  ///
  /// Example:
  /// ```dart
  /// String text = "hello world, hello!";
  /// int count = text.countWords("hello"); // 2
  /// ```
  int countWords(String word) {
    if (isBlank) return 0;

    if (word.isEmpty) return 0;
    final pattern =
        RegExp(r'\b' + RegExp.escape(word) + r'\b', caseSensitive: false);
    return pattern.allMatches(this!).length;
  }

  /// Finds all character occurrences and returns count as:
  /// ```dart
  /// List<Map<dynamic,dynamic>>
  /// ```
  /// ### Example 1
  /// ```dart
  /// String foo = 'esentis';
  /// List occurrences = foo.charOccurrences; // returns '[{e:2},{i:1},{n:1},{s:2},]'
  /// ```
  List<Map<String, int>> get charOccurrences {
    if (isBlank) return [];

    List<Map<String, int>> occurrences = [];
    var letters = this!.split('')..sort();
    var checkingLetter = letters[0];
    var count = 0;

    for (var i = 0; i < letters.length; i++) {
      if (letters[i] == checkingLetter) {
        count++;
        if (i == letters.length - 1) {
          occurrences.add({checkingLetter: count});
          checkingLetter = letters[i];
        }
      } else {
        occurrences.add({checkingLetter: count});
        checkingLetter = letters[i];
        count = 1;
      }
    }
    return occurrences;
  }

  /// Finds the most frequent character in the `String`.
  /// ### Example 1
  /// ```dart
  /// String foo = 'Hello World';
  /// String mostFrequent = foo.mostFrequent; // returns 'l'
  /// ```
  String? mostFrequent({bool ignoreSpaces = false}) {
    if (isBlank) return this;

    if (ignoreSpaces) return this!.replaceAll(' ', '').mostFrequent();

    var occurrences = <String, int>{};
    var letters = this!.split('')..sort();
    var checkingLetter = letters[0];
    var count = 0;

    for (var i = 0, len = letters.length; i < len; i++) {
      if (letters[i] == checkingLetter) {
        count++;
        if (i == len - 1) {
          occurrences[checkingLetter] = count;
        }
      } else {
        occurrences[checkingLetter] = count;
        checkingLetter = letters[i];
        count = 1;
      }
    }

    var mostFrequent = '';
    var occursCount = -1;

    occurrences.forEach((character, occurs) {
      if (occurs > occursCount) {
        mostFrequent = character;
        occursCount = occurs;
      }
    });

    return mostFrequent;
  }

  /// Checks whether all characters are contained in the `String`.
  ///
  /// The method is case sensitive by default.
  ///
  /// ### Example
  ///
  /// ```dart
  /// String foo = 'Hello World';
  /// bool containsAll = foo.containsAllCharacters('Hello'); // returns true;
  /// ```
  ///
  /// ```dart
  /// String foo = 'Hello World';
  /// bool containsAll = foo.containsAllCharacters('Hello!'); // returns false;
  /// ```
  bool containsAllCharacters(String characters) {
    if (isBlank) return false;

    final Map<String, int> letterCounts = {};

    this!.split('').forEach((letter) {
      letterCounts[letter] = (letterCounts[letter] ?? 0) + 1;
    });

    for (final letter in characters.split('')) {
      if (letterCounts[letter] == null || letterCounts[letter]! <= 0) {
        return false;
      }
      letterCounts[letter] = letterCounts[letter]! - 1;
    }

    return true;
  }

  /// Returns a `Set` of the common characters between the two `String`s.
  ///
  /// The `String` is case sensitive & sorted by default.
  ///
  /// ### Example
  ///
  /// ```dart
  /// String foo = 'Hello World';
  /// List<String> commonLetters = foo.commonCharacters('World Hello'); // returns ['H', 'e', 'l', 'o', 'r', 'w', 'd'];
  /// ```
  ///
  /// ```dart
  /// String foo = 'Hello World';
  /// List<String> commonLetters = foo.commonCharacters('World Hello!'); // returns ['H', 'e', 'l', 'o', 'r', 'w', 'd'];
  /// ```
  Set<String> commonCharacters(
    String otherString, {
    bool caseSensitive = true,
    bool sort = true,
    bool includeSpaces = false,
  }) {
    if (isBlank) return {};

    String processString(String input) =>
        (caseSensitive ? input : input.toLowerCase())
            .split('')
            .where((char) => includeSpaces || char != ' ')
            .join();

    final Set<String> commonLettersSet = {};
    final Set<String> otherStringSet =
        processString(otherString).split('').toSet();

    for (final letter in processString(this!).split('')) {
      if (otherStringSet.contains(letter)) {
        commonLettersSet.add(letter);
      }
    }

    if (sort) {
      final List<String> sortedList = commonLettersSet.toList()..sort();
      return sortedList.toSet();
    } else {
      return commonLettersSet;
    }
  }

  /// Returns a Set of the uncommon characters between the two `String`s.
  ///
  /// The `String` is case sensitive & sorted by default.
  ///
  /// ### Example
  ///
  /// ```dart
  /// String foo = 'Hello World';
  /// List<String> uncommonLetters = foo.uncommonCharacters('World Hello'); // returns {};
  /// ```
  ///
  /// ```dart
  /// String foo = 'Hello World';
  /// List<String> uncommonLetters = foo.uncommonCharacters('World Hello!'); // returns {'!'};
  /// ```
  Set<String> uncommonCharacters(
    String otherString, {
    bool caseSensitive = true,
    bool includeSpaces = false,
  }) {
    if (isBlank) return {};

    String processString(String input) =>
        (caseSensitive ? input : input.toLowerCase())
            .split('')
            .where((char) => includeSpaces || char != ' ')
            .join();

    final Set<String> thisSet = processString(this!).split('').toSet();
    final Set<String> otherStringSet =
        processString(otherString).split('').toSet();

    final Set<String> uncommonSet = thisSet
        .union(otherStringSet)
        .difference(thisSet.intersection(otherStringSet));

    return uncommonSet;
  }

  /// If the provided `String` is empty do something.
  ///
  /// ### Example
  /// ```dart
  /// String foo = '';
  /// foo.ifEmpty(()=>print('String is empty'));
  /// ```
  String? ifEmpty(ValueGetter<String?> act) {
    if (isNull) return null;

    return this!.trim().isEmpty ? act() : this;
  }

  /// If the provided `String` is `null` do something.
  ///
  /// ### Example
  /// ```dart
  /// String foo = ''
  /// foo.ifEmpty(()=>print('String is null'));
  /// ```
  String ifNull(ValueGetter<String> act) {
    if (isNotBlank) return this!;

    return act();
  }

  /// Provide default value if the `String` is `null`.
  ///
  /// ### Example
  /// ```dart
  /// String? foo = null;
  /// foo.ifNull('dont be null'); // returns 'dont be null'
  /// ```
  String? defaultValue(String defaultValue) {
    if (isNotBlank) return this;

    return defaultValue;
  }

  /// Return a empty `String` if this equals [comparisonString]. Otherwise return this.
  ///
  /// ### Example
  ///
  /// ```dart
  /// String t = 'OK'.emptyIf("OK"); // returns "";
  /// String f = 'NO'.emptyIf("YES"); // returns "NO";
  /// ```
  String? emptyIf(String? comparisonString) =>
      asIf((s) => s == comparisonString, '', this);

  /// Return null if this equals [comparisonString]. Otherwise return this.
  ///
  /// ### Example
  ///
  /// ```dart
  /// String t = 'OK'.nullIf("OK"); // returns null;
  /// String f = 'NO'.nullIf("YES"); // returns "NO";
  /// ```
  String? nullIf(String? comparisonString) =>
      asIf((s) => s == comparisonString, null, this);

  /// Return [this if not blank. Otherwise return [newString].
  String? ifBlank(String? newString) =>
      asIf((s) => s.isNotBlank, this, newString);

  /// Compares this using [comparison] and returns [trueString] if true, otherwise return [falseString].
  ///
  /// ### Example
  ///
  /// ```dart
  /// String s = 'OK'.asIf((s) => s == "OK", "is OK", "is not OK"); // returns "is OK";
  /// ```
  String? asIf(
    bool Function(String?) comparison,
    String? trueString,
    String? falseString,
  ) =>
      comparison(this) ? trueString : falseString;
}

extension Safe on String? {
  /// Refer to [String.length]
  ///
  /// If [string] is null then it is treated as an empty String
  static int length(String? string) => (string ?? '').length;

  /// Refer to [String.codeUnits]
  ///
  /// If [string] is null then it is treated as an empty String
  static List<int> codeUnits(String? string) => (string ?? '').codeUnits;

  /// Refer to [String.runes]
  ///
  /// If [string] is null then it is treated as an empty String
  static Runes runes(String? string) => (string ?? '').runes;

  /// Refer to [String.allMatches]
  ///
  /// If [string] is null then it is treated as an empty String
  static Iterable<Match> allMatches(
    String? pattern,
    String string, [
    int start = 0,
  ]) =>
      (pattern ?? '').allMatches(string, start);

  /// Refer to [String.codeUnitAt]
  ///
  /// If [string] is null it is treated as an empty string which will result
  /// in an IndexOutOfBoundsException
  static int codeUnitAt(String? string, int index) =>
      (string ?? '').codeUnitAt(index);

  /// Refer to [String.compareTo]
  ///
  /// This method has special handling for a null [string] or [other].
  /// If both are null then we return -1
  /// If one of them is null then we use [nullIsLessThan] to determine if
  /// we return -1  or 1.
  static int compareTo(
    String? string,
    String? other, {
    bool nullIsLessThan = true,
  }) {
    if (string == other) return 0;

    if (string == null) return nullIsLessThan ? -1 : 1;

    if (other == null) return nullIsLessThan ? 1 : -1;

    return string.compareTo(other);
  }

  /// Refer to [String.contains]
  ///
  /// If [string] is null then it is treated as an empty String
  static bool contains(String? string, Pattern other, [int startIndex = 0]) =>
      (string ?? '').contains(other, startIndex);

  /// Refer to [String.endsWith]
  static bool endsWith(String? string, String? other) {
    if (string == null || other == null) return false;

    return string.endsWith(other);
  }

  /// Refer to [String.indexOf]
  ///
  /// If [string] is null then it is treated as an empty String
  static int indexOf(String? string, Pattern pattern, [int start = 0]) =>
      (string ?? '').indexOf(pattern, start);

  /// Refer to [String.lastIndexOf]
  ///
  /// If [string] is null then it is treated as an empty String
  static int lastIndexOf(String? string, Pattern pattern, [int? start]) =>
      (string ?? '').lastIndexOf(pattern, start);

  /// Refer to [String.matchAsPrefix]
  ///
  /// If [string] is null then it is treated as an empty String
  static Match? matchAsPrefix(
    String? pattern,
    String string, [
    int start = 0,
  ]) =>
      (pattern ?? '').matchAsPrefix(string, start);

  /// Refer to [String.padLeft]
  ///
  /// If [string] is null then it is treated as an empty String
  static String padLeft(String? string, int width, [String padding = ' ']) =>
      (string ?? '').padLeft(width, padding);

  /// Refer to [String.padRight]
  ///
  /// If [string] is null then it is treated as an empty String
  static String padRight(String? string, int width, [String padding = ' ']) =>
      (string ?? '').padRight(width, padding);

  /// Refer to [String.replaceAll]
  ///
  /// If [string] is null then it is treated as an empty String
  static String replaceAll(String? string, Pattern from, String replace) =>
      (string ?? '').replaceAll(from, replace);

  /// Refer to [String.replaceAllMapped]
  ///
  /// If [string] is null then it is treated as an empty String
  static String replaceAllMapped(
    String? string,
    Pattern from,
    String Function(Match match) replace,
  ) =>
      (string ?? '').replaceAllMapped(from, replace);

  /// Refer to [String.replaceFirst]
  ///
  /// If [string] is null then it is treated as an empty String
  static String replaceFirst(
    String? string,
    Pattern from,
    String to, [
    int startIndex = 0,
  ]) =>
      (string ?? '').replaceFirst(from, to, startIndex);

  /// Refer to [String.replaceFirstMapped]
  ///
  /// If [string] is null then it is treated as an empty String
  static String replaceFirstMapped(
    String? string,
    Pattern from,
    String Function(Match match) replace, [
    int startIndex = 0,
  ]) =>
      (string ?? '').replaceFirstMapped(from, replace, startIndex);

  /// Refer to [String.replaceRange]
  ///
  /// If [string] is null then it is treated as an empty String
  static String replaceRange(
    String? string,
    int start,
    int? end,
    String replacement,
  ) =>
      (string ?? '').replaceRange(start, end, replacement);

  /// Refer to [String.split]
  ///
  /// If [string] is null then it is treated as an empty String
  static List<String> split(String? string, Pattern pattern) =>
      (string ?? '').split(pattern);

  /// Refer to [String.splitMapJoin]
  ///
  /// If [string] is null then it is treated as an empty String
  static String splitMapJoin(
    String? string,
    Pattern pattern, {
    String Function(Match)? onMatch,
    String Function(String)? onNonMatch,
  }) =>
      (string ?? '')
          .splitMapJoin(pattern, onMatch: onMatch, onNonMatch: onNonMatch);

  /// Refer to [String.startsWith]
  ///
  /// If [string] is null then it is treated as an empty String
  static bool startsWith(String? string, Pattern pattern, [int index = 0]) =>
      (string ?? '').startsWith(pattern, index);

  /// Refer to [String.substring]
  ///
  /// If [string] is null then it is treated as an empty String
  static String substring(String? string, int start, [int? end]) {
    if (string == null) return ' ' * ((end ?? start + 1) - start);

    return string.substring(start, end);
  }

  /// Refer to [String.toLowerCase]
  ///
  /// If [string] is null then it is treated as an empty String
  static String toLowerCase(String? string) => (string ?? '').toLowerCase();

  /// Refer to [String.toUpperCase]
  ///
  /// If [string] is null then it is treated as an empty String
  static String toUpperCase(String? string) => (string ?? '').toUpperCase();

  /// Refer to [String.trim]
  ///
  /// If [string] is null then it is treated as an empty String
  static String trim(String? string) => (string ?? '').trim();

  /// Refer to [String.trimLeft]
  ///
  /// If [string] is null then it is treated as an empty String
  static String trimLeft(String? string) => (string ?? '').trimLeft();

  /// Refer to [String.trimRight]
  ///
  /// If [string] is null then it is treated as an empty String
  static String trimRight(String? string) => (string ?? '').trimRight();
}

extension Safe1 on String {
  // Transformation

  // Transformation - to Iterable

  /// Splits string by chunks with specified [size].
  ///
  /// If string is empty than empty [Iterable] will be returned.
  ///
  /// If [size] less or equal 0, that [ArgumentError] will be raised.
  Iterable<String> chunks(int size) sync* {
    if (isEmpty) return;

    if (size <= 0) {
      throw ArgumentError.value(size, 'size', 'Should be more than zero');
    }

    final total = length;
    if (total <= size) {
      yield this;
    } else {
      var start = 0;
      do {
        final end = start + size;
        yield substring(start, min(end, total));
        start = end;
      } while (start < total);
    }
  }
}

// import 'package:characters/characters.dart';
//
// import 'src/slice_indices.dart';
//
// /// Utility extension methods for the native [String] class.
// extension StringBasics on String {
//   /// Returns a value according to the contract for [Comparator] indicating
//   /// the ordering between [this] and [other], ignoring letter case.
//   ///
//   /// Example:
//   /// ```dart
//   /// 'ABC'.compareToIgnoringCase('abd'); // negative value
//   /// 'ABC'.compareToIgnoringCase('abc'); // zero
//   /// 'ABC'.compareToIgnoringCase('abb'); // positive value
//   /// ```
//   ///
//   /// NOTE: This implementation relies on [String].`toLowerCase`, which is not
//   /// locale aware. Therefore, this method is likely to exhibit unexpected
//   /// behavior for non-ASCII characters.
//   int compareToIgnoringCase(String other) =>
//       this.toLowerCase().compareTo(other.toLowerCase());
//
//   /// Returns `true` if [this] is empty or consists solely of whitespace
//   /// characters as defined by [String.trim].
//   bool get isBlank => this.trim().isEmpty;
//
//   /// Returns `true` if [this] is not empty and does not consist solely of
//   /// whitespace characters as defined by [String.trim].
//   bool get isNotBlank => this.trim().isNotEmpty;
//
//   /// Returns a copy of [this] with [prefix] removed if it is present.
//   ///
//   /// If [this] does not start with [prefix], returns [this].
//   ///
//   /// Example:
//   /// ```dart
//   /// var string = 'abc';
//   /// string.withoutPrefix('ab'); // 'c'
//   /// string.withoutPrefix('z'); // 'abc'
//   /// ```
//   String withoutPrefix(Pattern prefix) => this.startsWith(prefix)
//       ? this.substring(prefix.allMatches(this).first.end)
//       : this;
//
//   /// Returns a copy of [this] with [suffix] removed if it is present.
//   ///
//   /// If [this] does not end with [suffix], returns [this].
//   ///
//   /// Example:
//   /// ```dart
//   /// var string = 'abc';
//   /// string.withoutSuffix('bc'); // 'a';
//   /// string.withoutSuffix('z'); // 'abc';
//   /// ```
//   String withoutSuffix(Pattern suffix) {
//     // Can't use endsWith because that takes a String, not a Pattern.
//     final matches = suffix.allMatches(this);
//     return (matches.isEmpty || matches.last.end != this.length)
//         ? this
//         : this.substring(0, matches.last.start);
//   }
//
//   /// Returns a copy of [this] with [other] inserted starting at [index].
//   ///
//   /// Example:
//   /// ```dart
//   /// 'word'.insert('s', 0); // 'sword'
//   /// 'word'.insert('ke', 3); // 'worked'
//   /// 'word'.insert('y', 4); // 'wordy'
//   /// ```
//   String insert(String other, int index) => (StringBuffer()
//     ..write(this.substring(0, index))
//     ..write(other)
//     ..write(this.substring(index)))
//       .toString();
//
//   /// Returns the concatenation of [other] and [this].
//   ///
//   /// Example:
//   /// ```dart
//   /// 'word'.prepend('key'); // 'keyword'
//   /// ```
//   String prepend(String other) => other + this;
//
//   /// Divides string into everything before [pattern], [pattern], and everything
//   /// after [pattern].
//   ///
//   /// Example:
//   /// ```dart
//   /// 'word'.partition('or'); // ['w', 'or', 'd']
//   /// ```
//   ///
//   /// If [pattern] is not found, the entire string is treated as coming before
//   /// [pattern].
//   ///
//   /// Example:
//   /// ```dart
//   /// 'word'.partition('z'); // ['word', '', '']
//   /// ```
//   List<String> partition(Pattern pattern) {
//     final matches = pattern.allMatches(this);
//     if (matches.isEmpty) return [this, '', ''];
//     final matchStart = matches.first.start;
//     final matchEnd = matches.first.end;
//     return [
//       this.substring(0, matchStart),
//       this.substring(matchStart, matchEnd),
//       this.substring(matchEnd)
//     ];
//   }
//
//   /// Returns a new string containing the characters of [this] from [start]
//   /// inclusive to [end] exclusive, skipping by [step].
//   ///
//   /// Example:
//   /// ```dart
//   /// 'word'.slice(start: 1, end: 3); // 'or'
//   /// 'word'.slice(start: 1, end: 4, step: 2); // 'od'
//   /// ```
//   ///
//   /// [start] defaults to the first character if [step] is positive and to the
//   /// last character if [step] is negative. [end] does the opposite.
//   ///
//   /// Example:
//   /// ```dart
//   /// 'word'.slice(end: 2); // 'wo'
//   /// 'word'.slice(start: 1); // 'ord'
//   /// 'word'.slice(end: 1, step: -1); // 'dr'
//   /// 'word'.slice(start: 2, step: -1); // 'row'
//   /// ```
//   ///
//   /// If [start] or [end] is negative, it will be counted backwards from the
//   /// last character of [this]. If [step] is negative, the characters will be
//   /// returned in reverse order.
//   ///
//   /// Example:
//   /// ```dart
//   /// 'word'.slice(start: -2); // 'rd'
//   /// 'word'.slice(end: -1); // 'wor'
//   /// 'word'.slice(step: -1); // 'drow'
//   /// ```
//   ///
//   /// Any out-of-range values for [start] or [end] will be truncated to the
//   /// maximum in-range value in that direction.
//   ///
//   /// Example:
//   /// ```dart
//   /// 'word'.slice(start: -100); // 'word'
//   /// 'word'.slice(end: 100); // 'word'
//   /// ```
//   ///
//   /// Will return an empty string if [start] and [end] are equal, [start] is
//   /// greater than [end] while [step] is positive, or [end] is greater than
//   /// [start] while [step] is negative.
//   ///
//   /// Example:
//   /// ```dart
//   /// 'word'.slice(start: 1, end: -3); // ''
//   /// 'word'.slice(start: 3, end: 1); // ''
//   /// 'word'.slice(start: 1, end: 3, step: -1); // ''
//   /// ```
//   String slice({int? start, int? end, int step = 1}) {
//     final indices = sliceIndices(start, end, step, this.length);
//     if (indices == null) {
//       return '';
//     }
//
//     final _start = indices.start;
//     final _end = indices.end;
//     final stringBuffer = StringBuffer();
//
//     if (step > 0) {
//       for (var i = _start; i < _end; i += step) {
//         stringBuffer.write(this[i]);
//       }
//     } else {
//       for (var i = _start; i > _end; i += step) {
//         stringBuffer.write(this[i]);
//       }
//     }
//     return stringBuffer.toString();
//   }
//
//   /// Returns [this] with characters in reverse order.
//   ///
//   /// Example:
//   /// ```dart
//   /// 'word'.reverse(); // 'drow'
//   /// ```
//   ///
//   /// WARNING: This is the naive-est possible implementation, relying on native
//   /// string indexing. Therefore, this method is almost guaranteed to exhibit
//   /// unexpected behavior for non-ASCII characters.
//   String reverse() {
//     final stringBuffer = StringBuffer();
//     for (var i = this.length - 1; i >= 0; i--) {
//       stringBuffer.write(this[i]);
//     }
//     return stringBuffer.toString();
//   }
//
//   /// Returns a truncated version of the string.
//   ///
//   /// Example:
//   /// ```dart
//   /// final sentence = 'The quick brown fox jumps over the lazy dog';
//   /// final truncated = sentence.truncate(20); // 'The quick brown fox...'
//   /// ```
//   ///
//   /// The [length] is the truncated length of the string.
//   /// The [substitution] is the substituting string of the truncated characters.
//   /// If not null or empty it will be appended at the end of the truncated string.
//   /// The [trimTrailingWhitespace] is whether or not to trim the spaces of the truncated string
//   /// before appending the ending string.
//   /// The [includeSubstitutionInLength] is whether or not that the length of the substitution string will be included
//   /// with the intended truncated length.
//   String truncate(
//       int length, {
//         String substitution = '',
//         bool trimTrailingWhitespace = true,
//         bool includeSubstitutionInLength = false,
//       }) {
//     if (this.length <= length) {
//       return this;
//     }
//
//     // calculate the final truncate length where whether or not to include the length of substitution string
//     final truncatedLength = includeSubstitutionInLength
//         ? (length - substitution.characters.length)
//         : length;
//     final truncated = this.characters.take(truncatedLength).toString();
//
//     // finally trim the trailing white space if needed
//     return (trimTrailingWhitespace ? truncated.trimRight() : truncated) +
//         substitution;
//   }
//
//   /// Returns a string with the first character in upper case.
//   ///
//   /// This method can capitalize first character
//   /// that is either alphabetic or accented.
//   ///
//   /// If the first character is not alphabetic then return the same string.
//   /// If [this] is empty, returns and empty string.
//   ///
//   /// Example:
//   /// ```dart
//   /// final foo = 'bar';
//   /// final baz = foo.capitalizeFirst(); // 'Bar'
//   ///
//   /// // accented first character
//   /// final og = 'éfoo';
//   /// final capitalized = og.capitalizeFirst() // 'Éfoo'
//   ///
//   /// // non alphabetic first character
//   /// final foo1 = '1bar';
//   /// final baz1 = foo1.capitalizeFirst(); // '1bar'
//   ///
//   /// final test = '';
//   /// final result = test.capitalizeFirst(); // ''
//   /// ```
//   String capitalize() {
//     if (this.isEmpty) return '';
//
//     // trim this string first
//     final trimmed = this.trimLeft();
//
//     // convert the first character to upper case
//     final firstCharacter = trimmed[0].toUpperCase();
//
//     return trimmed.replaceRange(0, 1, firstCharacter);
//   }
// }
//
// extension NullableStringBasics on String? {
//   /// Returns `true` if [this] is null, empty, or consists solely of
//   /// whitespace characters as defined by [String.trim].
//   bool get isNullOrBlank => this?.trim().isEmpty ?? true;
//
//   /// Returns `true` if [this] is not null, not empty, and does not consist
//   /// solely of whitespace characters as defined by [String.trim].
//   bool get isNotNullOrBlank => this?.trim().isNotEmpty ?? false;
// }
