import '../../index.dart';
import 'index.dart';

extension SanitizerExtensions on String? {
  /// Formats the `String` with a specific mask.
  ///
  /// You can assign your own [char], defaults to '#'.
  ///
  /// ### Example
  /// ```dart
  ///var string3 = 'esentisgreece';
  ///var mask3 = 'Hello ####### you are from ######';
  ///var masked3 = string3.formatWithMask(mask3); // returns 'Hello esentis you are from greece'
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

  /// Formats the `String` with a specific [char].
  ///
  /// You can assign your own [char], defaults to '*'.
  ///
  /// ### Example
  /// ```dart
  ///var string3 = 'esentisgreece';
  ///var text = string3.obscure(obscure: true); // returns '**************'
  /// ```
  String? obscure({bool obscure = false, String char = '*'}) {
    if (isBlank || !obscure) return this;

    return char * this!.length;
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

    final regex = RegExp('([a-zA-Z]+)');
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

    final regex = RegExp(r'(\d+)');
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

    final regex = RegExp('([^0-9]+)');
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

    final regex = RegExp(r'([^a-zA-Z\s]+)');
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

    final regex = RegExp(r'([^α-ωΑ-ΩίϊΐόάέύϋΰήώΊΪΌΆΈΎΫΉΏa-zA-Z\s]+)');
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

    final regex = RegExp(r'[/!@#$%^\-&*()+",.?":{}|<>~_-`]');
    return this!.replaceAll(regex, '');
  }

  String? get removeEscapedChars {
    if (isBlank) return this;

    return this!.replaceAll(Regex.escapedChar, '');
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

    return this!.replaceAll(Regex.whiteSpaces, '');
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

    final regex = RegExp('<[^>]*>');
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

    final int leftChars = (maxChars / 2).ceil();
    final int rightChars = maxChars - leftChars;

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

    final buffer = StringBuffer();
    for (var i = this!.length - 1; i >= 0; i--) {
      buffer.write(this![i]);
    }
    return buffer.toString();
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

  /// Trims characters from the left side of the string.
  String? leftTrim([String? chars]) =>
      isNotBlank
          ? (chars != null)
              ? this!.replaceAll(RegExp('^[$chars]+'), '')
              : this!.replaceAll(RegExp(r'^\s+'), '')
          : null;

  /// Trims characters from the right side of the string.
  String? rightTrim([String? chars]) =>
      isNotBlank
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
}
