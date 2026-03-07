import 'dart:math';

import '../num/operators.dart';
import 'index.dart';

/// convert string to different types
extension StringConversions on String? {
  /// getOrDefault
  /// returns default value if blank
  String getOrDefault(String value) => isNotBlank ? this! : value;

  /// getOrNull
  /// returns null if null or empty
  String? getOrNull() => isNotBlank ? this : null;

  /// convert String to int if is possible
  int toInt({int radix = 10}) => toIntOr(0, radix: radix);

  /// convert String to int if is possible
  /// else will return null
  int? toIntOrNull({int radix = 10}) =>
      isNotBlank ? int.tryParse(this!, radix: radix) : null;

  /// convert String to int if is possible
  /// else will return value
  int toIntOr(int value, {int radix = 10}) =>
      toIntOrNull(radix: radix) ?? value;

  /// convert String to `double` if is possible
  double toDouble() => toDoubleOr(0);

  /// convert String to double if is possible
  /// else will return null
  double? toDoubleOrNull() => isNotBlank ? double.tryParse(this!) : null;

  /// convert String to double if is possible
  /// else will return value
  double toDoubleOr(double value) => toDoubleOrNull() ?? value;

  /// convert String to `DateTime` if is possible
  DateTime toDate() => toDateOrNow();

  /// convert String to DateTime if is possible
  /// else will return null
  DateTime? toDateOrNull() => isNotBlank ? DateTime.tryParse(this!) : null;

  /// convert String to DateTime if is possible
  /// else will return value
  DateTime toDateOr(DateTime value) => toDateOrNull() ?? value;

  /// convert String to DateTime if is possible
  /// else will return DateTime Now
  DateTime toDateOrNow() => toDateOrNull() ?? DateTime.now();

  /// convert String to `num` if is possible
  num toNum() => toNumOrZero();

  /// convert String to `num` if is possible
  /// else return `0`
  num toNumOrZero() => toNumOr(0);

  /// convert String to DateTime if is possible
  /// else will return null
  num? toNumOrNull() => isNotBlank ? num.tryParse(this!) : null;

  /// convert String to DateTime if is possible
  /// else will return value
  num toNumOr(num value) => toNumOrNull() ?? value;

  bool toBool() => toBoolOr(false);

  /// Checks the `String` and maps the value to a `bool` if possible.
  ///
  /// ### Example
  ///
  /// ```dart
  /// String text = 'yes';
  /// bool? textBool = text.toBool() ; // returns true
  /// ```
  bool? toBoolOrNull() {
    if (isBlank) return null;

    if (this == '1' || lowercase == 'true' || lowercase == 'yes') return true;

    if (this == '0' || lowercase == 'false' || lowercase == 'no') return false;

    return null;
  }

  bool toBoolOr(bool value) => toBoolOrNull() ?? value;

  /// Returns the integer value of the Roman numeral string.
  int? get fromRomanNumeral =>
      this == null ? null : NumbersHelper.fromRomanNumeral(this!);

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

  /// Splits string by chunks with specified [size].
  ///
  /// If string is empty than empty [Iterable] will be returned.
  ///
  /// If [size] less or equal 0, that [ArgumentError] will be raised.
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

  /// Divides string into everything before [pattern], [pattern], and everything
  /// after [pattern].
  ///
  /// Example:
  /// ```dart
  /// 'word'.partition('or'); // ['w', 'or', 'd']
  /// ```
  ///
  /// If [pattern] is not found, the entire string is treated as coming before
  /// [pattern].
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

extension StringNormalization on String? {
  String? get lowercase => isNotBlank ? this!.toLowerCase() : this;

  String? get uppercase => isNotBlank ? this!.toUpperCase() : this;

  /// Capitalizes the `String` in normal form.
  /// ### Example
  /// ```dart
  /// String foo = 'hAckER';
  /// String cFoo = foo.capitalize; // returns 'Hacker'.
  /// ```
  String? get capitalize => isNotBlank ? _ReCase(this!).capitalize : this;

  /// camelCase string
  String? get camelCase => isNotBlank ? _ReCase(this!).camelCase : this;

  /// constantCase string
  String? get constantCase => isNotBlank ? _ReCase(this!).constantCase : this;

  /// sentenceCase string
  String? get sentenceCase => isNotBlank ? _ReCase(this!).sentenceCase : this;

  /// snakeCase string
  String? get snakeCase => isNotBlank ? _ReCase(this!).snakeCase : this;

  /// dotCase string
  String? get dotCase => isNotBlank ? _ReCase(this!).dotCase : this;

  /// paramCase string
  String? get paramCase => isNotBlank ? _ReCase(this!).paramCase : this;

  /// pathCase string
  String? get pathCase => isNotBlank ? _ReCase(this!).pathCase : this;

  /// pascalCase string
  String? get pascalCase => isNotBlank ? _ReCase(this!).pascalCase : this;

  /// headerCase string
  String? get headerCase => isNotBlank ? _ReCase(this!).headerCase : this;

  /// titleCase string
  String? get titleCase => isNotBlank ? _ReCase(this!).titleCase : this;

  /// initials
  /// returns the initials of the string
  /// if the string is empty, returns an empty string
  /// if the string has one word, returns the first two characters
  /// if the string has two or more words, returns the first character of the first two words
  String? get initials => isNotBlank ? _ReCase(this!).initials : this;
}

/// use to convert string into different cases
///
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

  /// Initials
  /// returns the initials of the string
  /// if the string is empty, returns an empty string
  /// if the string has one word, returns the first two characters
  /// if the string has two or more words, returns the first character of the first two words
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
