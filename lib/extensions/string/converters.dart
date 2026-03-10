import 'dart:math';

import '../num/operators.dart';
import 'index.dart';

/// Conversion helpers for nullable strings.
extension StringConversions on String? {
  /// Returns this value when non-blank, otherwise [value].
  ///
  /// Example:
  /// ```dart
  /// final String? name = '  ';
  /// final resolved = name.getOrDefault('Guest'); // Guest
  /// ```
  String getOrDefault(String value) => isNotBlank ? this! : value;

  /// Returns this value when non-blank, otherwise `null`.
  String? getOrNull() => isNotBlank ? this : null;

  /// Parses this value as `int` with optional [radix], or `0` on failure.
  int toInt({int radix = 10}) => toIntOr(0, radix: radix);

  /// Parses this value as `int` with optional [radix], or `null` on failure.
  int? toIntOrNull({int radix = 10}) =>
      isNotBlank ? int.tryParse(this!, radix: radix) : null;

  /// Parses this value as `int` with optional [radix], or [value] on failure.
  int toIntOr(int value, {int radix = 10}) =>
      toIntOrNull(radix: radix) ?? value;

  /// Parses this value as `double`, or `0` on failure.
  double toDouble() => toDoubleOr(0);

  /// Parses this value as `double`, or `null` on failure.
  double? toDoubleOrNull() => isNotBlank ? double.tryParse(this!) : null;

  /// Parses this value as `double`, or [value] on failure.
  double toDoubleOr(double value) => toDoubleOrNull() ?? value;

  /// Parses this value as [DateTime], or `null` on failure.
  DateTime? toDateOrNull() => isNotBlank ? DateTime.tryParse(this!) : null;

  /// Parses this value as [DateTime], or [value] on failure.
  DateTime toDateOr(DateTime value) => toDateOrNull() ?? value;

  /// Parses this value as [DateTime], or `DateTime.now()` on failure.
  DateTime toDateOrNow() => toDateOrNull() ?? DateTime.now();

  /// Parses this value as [num], or `0` on failure.
  num toNum() => toNumOrZero();

  /// Parses this value as [num], or `0` on failure.
  num toNumOrZero() => toNumOr(0);

  /// Parses this value as [num], or `null` on failure.
  num? toNumOrNull() => isNotBlank ? num.tryParse(this!) : null;

  /// Parses this value as [num], or [value] on failure.
  num toNumOr(num value) => toNumOrNull() ?? value;

  /// Parses this value as `bool`, or `false` when unrecognized.
  bool toBool() => toBoolOr(false);

  /// Parses this value as `bool`.
  ///
  /// Accepted true values: `1`, `true`, `yes` (case-insensitive).
  /// Accepted false values: `0`, `false`, `no` (case-insensitive).
  ///
  /// Example:
  /// ```dart
  /// 'yes'.toBoolOrNull(); // true
  /// 'FALSE'.toBoolOrNull(); // false
  /// 'ok'.toBoolOrNull(); // null
  /// ```
  bool? toBoolOrNull() {
    if (isBlank) return null;

    if (this == '1' || lowercase == 'true' || lowercase == 'yes') return true;

    if (this == '0' || lowercase == 'false' || lowercase == 'no') return false;

    return null;
  }

  /// Parses this value as `bool`, or [value] when unrecognized.
  bool toBoolOr(bool value) => toBoolOrNull() ?? value;

  /// Parses this Roman numeral string into an integer.
  ///
  /// Returns `null` when this value is `null`.
  /// Throws [ArgumentError] when non-null input is not a valid canonical Roman numeral.
  int? get fromRomanNumeral =>
      this == null ? null : NumbersHelper.fromRomanNumeral(this!);

  /// Parses this value to enum [T] by matching enum `name` case-insensitively.
  ///
  /// If no match is found:
  /// - returns `orElse()` when provided
  /// - otherwise throws [StateError]
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
  T? toEnum<T extends Enum>({
    required Iterable<T> values,
    T Function()? orElse,
  }) {
    if (isBlank) return orElse?.call();

    return values.firstWhere(
      (e) => lowercase == e.name.lowercase,
      orElse: orElse,
    );
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

  /// Splits this string into lines using `\n` or `\r\n`.
  ///
  /// Returns an empty list when this value is `null`.
  ///
  /// Example:
  /// ```dart
  /// final lines = 'hello\nworld'.splitLines; // ['hello', 'world']
  /// ```
  List<String> get splitLines {
    if (isNull) return [];

    return this!.split(RegExp(r'\r?\n'));
  }

  /// Splits this string into chunks with the given [size].
  ///
  /// Returns an empty iterable when this value is blank.
  ///
  /// Throws [ArgumentError] when [size] is less than or equal to `0`.
  ///
  /// Example:
  /// ```dart
  /// 'abcdef'.chunks(2).toList(); // ['ab', 'cd', 'ef']
  /// ```
  Iterable<String> chunks(int size) sync* {
    if (size <= 0) {
      throw ArgumentError.value(size, 'size', 'Should be more than zero');
    }

    if (isBlank) return;

    final total = this!.length;

    if (total <= size) {
      yield this!;
    } else {
      var start = 0;
      do {
        final end = start + size;
        yield this!.substring(start, min(end, total));
        start = end;
      } while (start < total);
    }
  }

  /// Splits this value into: before first [pattern], matched [pattern], and after.
  ///
  /// Example:
  /// ```dart
  /// 'word'.partition('or'); // ['w', 'or', 'd']
  /// ```
  ///
  /// If [pattern] is not found, returns `[this, '', '']`.
  /// Returns `[]` for blank input.
  ///
  /// Example:
  /// ```dart
  /// 'word'.partition('z'); // ['word', '', '']
  /// ```
  List<String> partition(Pattern pattern) {
    if (isBlank) return [];

    final matches = pattern.allMatches(this!);

    if (matches.isEmpty) return [this!, '', ''];

    final matchStart = matches.first.start;
    final matchEnd = matches.first.end;

    return [
      this!.substring(0, matchStart),
      this!.substring(matchStart, matchEnd),
      this!.substring(matchEnd),
    ];
  }
}

/// Case and style normalization helpers for nullable strings.
extension StringNormalization on String? {
  /// Lower-cases this value when non-blank.
  String? get lowercase => isNotBlank ? this!.toLowerCase() : this;

  /// Upper-cases this value when non-blank.
  String? get uppercase => isNotBlank ? this!.toUpperCase() : this;

  /// Capitalizes the `String` in normal form.
  /// ### Example
  /// ```dart
  /// String foo = 'hAckER';
  /// String cFoo = foo.capitalize; // returns 'Hacker'.
  /// ```
  String? get capitalize => isNotBlank ? _ReCase(this!).capitalize : this;

  /// Converts this value to `camelCase`.
  String? get camelCase => isNotBlank ? _ReCase(this!).camelCase : this;

  /// Converts this value to `CONSTANT_CASE`.
  String? get constantCase => isNotBlank ? _ReCase(this!).constantCase : this;

  /// Converts this value to sentence case.
  String? get sentenceCase => isNotBlank ? _ReCase(this!).sentenceCase : this;

  /// Converts this value to `snake_case`.
  String? get snakeCase => isNotBlank ? _ReCase(this!).snakeCase : this;

  /// Converts this value to `dot.case`.
  String? get dotCase => isNotBlank ? _ReCase(this!).dotCase : this;

  /// Converts this value to `param-case`.
  String? get paramCase => isNotBlank ? _ReCase(this!).paramCase : this;

  /// Converts this value to `path/case`.
  String? get pathCase => isNotBlank ? _ReCase(this!).pathCase : this;

  /// Converts this value to `PascalCase`.
  String? get pascalCase => isNotBlank ? _ReCase(this!).pascalCase : this;

  /// Converts this value to `Header-Case`.
  String? get headerCase => isNotBlank ? _ReCase(this!).headerCase : this;

  /// Converts this value to `Title Case`.
  String? get titleCase => isNotBlank ? _ReCase(this!).titleCase : this;

  /// Returns initials from this value.
  ///
  /// - empty input => empty output
  /// - one word => first two characters
  /// - multi-word => first character from first two words
  String? get initials => isNotBlank ? _ReCase(this!).initials : this;
}

/// Internal helper for converting text into multiple case styles.
class _ReCase {
  _ReCase(String text) {
    originalText = text;
    _words = _groupIntoWords(text);
  }

  final RegExp _upperAlphaRegex = RegExp('[A-Z]');

  final symbolSet = {' ', '.', '/', '_', r'\', '-'};

  late String originalText;

  late List<String> _words;

  /// capitalize first letter
  String get capitalize => _upperCaseFirstLetter(originalText);

  /// camelCase
  String get camelCase => _getCamelCase();

  /// CONSTANT_CASE
  String get constantCase => _getConstantCase();

  /// Sentence case
  String get sentenceCase => _getSentenceCase();

  /// snake_case
  String get snakeCase => _getSnakeCase();

  /// dot.case
  String get dotCase => _getSnakeCase(separator: '.');

  /// param-case
  String get paramCase => _getSnakeCase(separator: '-');

  /// path/case
  String get pathCase => _getSnakeCase(separator: '/');

  /// PascalCase
  String get pascalCase => _getPascalCase();

  /// Header-Case
  String get headerCase => _getPascalCase(separator: '-');

  /// Title Case
  String get titleCase => _getPascalCase(separator: ' ');

  /// Returns initials from grouped words.
  String get initials {
    if (_words.isEmpty) return '';

    if (_words.length == 1) {
      final firstWord = _words.first;
      if (firstWord.length == 1) {
        return firstWord[0].uppercase ?? '';
      }

      return '${firstWord[0].uppercase}${firstWord[1].uppercase}'.trim();
    }

    if (_words.length > 2) {
      return _words
          .getRange(0, 2)
          .map((word) => word[0].uppercase)
          .join()
          .trim();
    }

    return _words.map((word) => word[0].uppercase).join().trim();
  }

  String _getCamelCase({String separator = ''}) {
    final words = _words.map(_upperCaseFirstLetter).toList();

    if (_words.isNotEmpty) words[0] = words[0].lowercase!;

    return words.join(separator);
  }

  String _getConstantCase({String separator = '_'}) {
    final words = _words.map((word) => word.uppercase).toList();

    return words.join(separator);
  }

  String _getPascalCase({String separator = ''}) {
    final words = _words.map(_upperCaseFirstLetter).toList();

    return words.join(separator);
  }

  String _getSentenceCase({String separator = ' '}) {
    final words = _words.map((word) => word.lowercase!).toList();

    if (_words.isNotEmpty) words[0] = _upperCaseFirstLetter(words[0]);

    return words.join(separator);
  }

  String _getSnakeCase({String separator = '_'}) {
    final words = _words.map((word) => word.lowercase).toList();

    return words.join(separator);
  }

  String _upperCaseFirstLetter(String word) {
    return '${word.substring(0, 1).uppercase}${word.substring(1).lowercase}';
  }

  List<String> _groupIntoWords(String text) {
    final sb = StringBuffer();
    final words = <String>[];

    final isAllCaps = text.uppercase == text;

    for (var i = 0; i < text.length; i++) {
      final char = text[i];
      final nextChar = i + 1 == text.length ? null : text[i + 1];

      if (symbolSet.contains(char)) continue;

      sb.write(char);

      final isEndOfWord =
          nextChar == null ||
          (_upperAlphaRegex.hasMatch(nextChar) && !isAllCaps) ||
          symbolSet.contains(nextChar);

      if (isEndOfWord) {
        words.add(sb.toString());
        sb.clear();
      }
    }

    return words;
  }
}
