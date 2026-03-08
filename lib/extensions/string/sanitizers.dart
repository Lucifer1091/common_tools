import '../../index.dart';

/// Sanitization and masking helpers for nullable strings.
extension SanitizerExtensions on String? {
  /// Applies [mask] to this value, replacing each [char] placeholder with
  /// sequential characters from the source string.
  ///
  /// Example:
  /// ```dart
  /// final value = 'esentisgreece';
  /// final mask = 'Hello ####### you are from ######';
  /// final output = value.formatWithMask(mask);
  /// // Hello esentis you are from greece
  /// ```
  String? formatWithMask(String mask, {String char = '#'}) {
    if (isBlank) return this;

    final maskChars = mask.toArray;
    var index = 0;
    var out = '';
    for (final m in maskChars) {
      if (m == char) {
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

  /// Returns an obscured version of this value when [obscure] is `true`.
  ///
  /// Uses [char] as the replacement character.
  ///
  /// Example:
  /// ```dart
  /// 'secret'.obscure(obscure: true); // ******
  /// ```
  String? obscure({bool obscure = false, String char = '*'}) {
    if (isBlank || !obscure) return this;

    return char * this!.length;
  }

  /// Removes Latin letters (`a-zA-Z`) from this value.
  String? get removeLetters {
    if (isBlank) return this;

    final regex = RegExp('([a-zA-Z]+)');
    return this!.replaceAll(regex, '');
  }

  /// Removes numeric digits from this value.
  String? get removeNumbers {
    if (isBlank) return this;

    final regex = RegExp(r'(\d+)');
    return this!.replaceAll(regex, '');
  }

  /// Keeps only numeric digits from this value.
  String? get onlyNumbers {
    if (isBlank) return this;

    final regex = RegExp('([^0-9]+)');
    return this!.replaceAll(regex, '');
  }

  /// Keeps only Latin letters and spaces.
  String? get onlyLatin {
    if (isBlank) return this;

    final regex = RegExp(r'([^a-zA-Z\s]+)');
    return this!.replaceAll(regex, '');
  }

  /// Keeps only letter characters (Greek block + Latin + spaces).
  String? get onlyLetters {
    if (isBlank) return this;

    final regex = RegExp(r'([^\u0370-\u03FFA-Za-z\s]+)', unicode: true);
    return this!.replaceAll(regex, '');
  }

  /// Removes common special characters from this value.
  String? get removeSpecial {
    if (isBlank) return this;

    final regex = RegExp(r'[/!@#$%^\-&*()+",.?":{}|<>~_-`]');
    return this!.replaceAll(regex, '');
  }

  /// Removes escaped control characters matched by [Regex.escapedChar].
  String? get removeEscapedChars {
    if (isBlank) return this;

    return this!.replaceAll(Regex.escapedChar, '');
  }

  /// Removes all whitespace characters.
  ///
  /// Example:
  /// ```dart
  /// '   Hel l o W   orld'.removeWhiteSpace; // HelloWorld
  /// ```
  String? get removeWhiteSpace {
    if (isBlank) return this;

    return this!.replaceAll(Regex.whiteSpaces, '');
  }

  /// Removes punctuation characters (keeps letters, numbers, underscore, spaces).
  ///
  /// Returns this value unchanged when blank.
  String? get removePunctuation {
    if (isBlank) return this;

    return this!.replaceAll(RegExp(r'[^\w\s]'), '');
  }

  /// Removes leading/trailing characters listed in [chars].
  ///
  /// If [chars] is omitted, trims surrounding whitespace.
  String? strip([String? chars]) {
    if (isBlank) return this;

    if (chars != null) {
      final escaped = RegExp.escape(chars);
      return this!.replaceAll(RegExp('^[$escaped]+|[$escaped]+\$'), '');
    } else {
      return this!.trim();
    }
  }

  /// Removes HTML tags from this value.
  ///
  /// Example:
  /// ```dart
  /// '<p>Hello</p>'.stripHtml; // Hello
  /// ```
  String? get stripHtml {
    if (isBlank) return this;

    final regex = RegExp('<[^>]*>');
    return this!.replaceAll(regex, '');
  }

  /// Truncates this string to [length] characters.
  ///
  /// Appends `...` when [ellipsis] is `true`.
  /// Returns this value unchanged when blank, when [length] is non-positive,
  /// or when [length] is greater than or equal to current length.
  String? truncate({int length = 10, bool ellipsis = false}) {
    if (isBlank || length <= 0 || length >= this!.length) return this;

    return this!.substring(0, length) + (ellipsis ? '...' : '');
  }

  /// Truncates in the middle with an ellipsis, keeping both ends.
  ///
  /// Returns this value unchanged when blank, when [maxChars] is non-positive,
  /// or when [maxChars] is greater than the current length.
  ///
  /// Example:
  /// ```dart
  /// 'congratulations'.truncateMiddle(5); // con...ns
  /// ```
  String? truncateMiddle(int maxChars) {
    if (isBlank || maxChars <= 0 || maxChars > this!.length) return this;

    final int leftChars = (maxChars / 2).ceil();
    final int rightChars = maxChars - leftChars;

    return '${this!.first(n: leftChars)}...${this!.last(n: rightChars)}';
  }

  /// Returns this string reversed.
  ///
  /// Example:
  /// ```dart
  /// 'Hello World'.reverse; // dlroW olleH
  /// ```
  String? get reverse {
    if (isBlank) return this;

    final buffer = StringBuffer();
    for (var i = this!.length - 1; i >= 0; i--) {
      buffer.write(this![i]);
    }
    return buffer.toString();
  }

  /// Trims outer spaces and collapses repeated inner spaces to one.
  String? get trimAll {
    if (isBlank) return this;

    return this!.trim().replaceAll(RegExp(' +'), ' ');
  }

  /// Trims characters from the left side.
  ///
  /// If [chars] is omitted, trims leading whitespace.
  String? leftTrim([String? chars]) =>
      isNotBlank
          ? (chars != null)
              ? this!.replaceAll(RegExp('^[${RegExp.escape(chars)}]+'), '')
              : this!.replaceAll(RegExp(r'^\s+'), '')
          : null;

  /// Trims characters from the right side.
  ///
  /// If [chars] is omitted, trims trailing whitespace.
  String? rightTrim([String? chars]) =>
      isNotBlank
          ? (chars != null)
              ? this!.replaceAll(RegExp('[${RegExp.escape(chars)}]+\$'), '')
              : this!.replaceAll(RegExp(r'\s+$'), '')
          : null;

  /// Keeps only characters listed in [chars].
  String? whitelist(String chars) =>
      this?.replaceAll(RegExp('[^${RegExp.escape(chars)}]+'), '');

  /// Removes all characters listed in [chars].
  String? blacklist(String chars) =>
      this?.replaceAll(RegExp('[${RegExp.escape(chars)}]+'), '');

  /// Removes control characters (`< 0x20`) and `DEL` (`0x7F`).
  ///
  /// If [keepNewLines] is `true`, preserves `\n` and `\r`.
  String? stripLow([bool keepNewLines = false]) {
    final chars =
        keepNewLines ? '\x00-\x09\x0B\x0C\x0E-\x1F\x7F' : '\x00-\x1F\x7F';
    return blacklist(chars);
  }
}
