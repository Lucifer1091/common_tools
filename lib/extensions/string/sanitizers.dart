import 'index.dart';


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

    final String? lowerCase = this?.toLowerCase();

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
