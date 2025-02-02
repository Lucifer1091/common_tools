import 'dart:convert';

import '../../constants/constants.dart';
import 'index.dart';

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

    final RegExp re = regex ?? RegExp(pattern ?? '');
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

      final parts = this!.split('.')
        ..sort((a, b) => int.parse(a) - int.parse(b));
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
    final int len = this!.length - surrogatePairs.length;
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

    final RegExp? pat = Regex.uuid[version];
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

    final String sanitized = this!.replaceAll(RegExp('[^0-9]+'), '');

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

    final String sanitized = this!.replaceAll(RegExp(r'[\s-]+'), '');
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

      final factor = [1, 3];
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

    final regex = RegExp(
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

    final Map<String, int> charCount = {};

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
