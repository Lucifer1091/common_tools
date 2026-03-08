import 'index.dart';

/// Operator-style transformations and slicing helpers for nullable strings.
extension StringOperators on String? {
  /// Returns `true` when this string length is greater than [s].length.
  ///
  /// Returns `false` for blank values.
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

  /// Returns `true` when this string length is greater than or equal to [s].length.
  ///
  /// Returns `false` for blank values.
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

  /// Returns `true` when this string length is less than [s].length.
  ///
  /// Returns `false` for blank values.
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

  /// Returns `true` when this string length is less than or equal to [s].length.
  ///
  /// Returns `false` for blank values.
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

  /// Removes all occurrences of [s] from this string using the `-` operator.
  ///
  /// Example:
  /// ```dart
  /// final result = 'Hello, world!' - 'world'; // Hello, !
  /// ```
  String operator -(String? s) {
    if (isBlank) return '';

    if (s.isBlank) return this!;

    return this!.replaceAll(s!, '');
  }

  /// Returns the first [n] characters.
  ///
  /// Returns this value unchanged when blank, when [n] is negative,
  /// or when [n] exceeds the string length.
  ///
  /// Example:
  /// ```dart
  /// 'hello'.first(); // h
  /// 'hello'.first(n: 3); // hel
  /// ```
  String? first({int n = 1}) {
    if (isBlank || this!.length < n || n < 0) return this;

    return this!.substring(0, n);
  }

  /// Returns the last [n] characters.
  ///
  /// Returns this value unchanged when blank, when [n] is negative,
  /// or when [n] exceeds the string length.
  ///
  /// Example:
  /// ```dart
  /// 'hello'.last(); // o
  /// 'hello'.last(n: 3); // llo
  /// ```
  String? last({int n = 1}) {
    if (isBlank || this!.length < n || n < 0) return this;

    return this!.substring(this!.length - n, this!.length);
  }

  /// Inserts [value] at [index].
  ///
  /// Returns this value when `null`.
  /// Throws [RangeError] when [index] is outside `0..length`.
  ///
  /// ### Example
  ///
  /// ```dart
  /// String text = 'hello world';
  /// String newText = text.insertAt(5, '!');
  /// print(newText); // prints 'hello! world'
  /// ```
  String? insertAt(int index, String value) {
    if (isNull) return this;

    if (index < 0 || index > this!.length) {
      throw RangeError('Index out of range');
    }

    return (StringBuffer()
          ..write(this!.substring(0, index))
          ..write(value)
          ..write(this!.substring(index)))
        .toString();
  }

  /// Replaces the first occurrence of [pattern] with [replacement].
  ///
  /// Returns this value when `null` or when [pattern] is not found.
  ///
  /// ### Example
  ///
  /// ```dart
  /// String s = "esentis".replaceFirst("s", "S"); // returns "eSentis";
  /// ```
  String? replaceFirst(String pattern, String replacement) {
    if (isNull) return this;

    final int index = this!.indexOf(pattern);

    if (index == -1) return this!;

    return this!.replaceRange(index, index + pattern.length, replacement);
  }

  /// Replaces the last occurrence of [pattern] with [replacement].
  ///
  /// Returns this value when `null` or when [pattern] is not found.
  ///
  /// ### Example
  ///
  /// ```dart
  /// String s = "esentis".replaceLast("s", "S"); // returns "esentiS";
  /// ```
  String? replaceLast(String pattern, String replacement) {
    if (isNull) return this;

    final int index = this!.lastIndexOf(pattern);

    if (index == -1) return this!;

    return this!.replaceRange(index, index + pattern.length, replacement);
  }

  /// Replaces the character at [index] with [replacement].
  ///
  /// ### Example
  /// ```dart
  /// String foo = 'hello';
  /// String replaced = foo.replaceAtIndex(index:2,replacement:''); // returns 'helo';
  /// ```
  String? replaceAt({required int index, required String replacement}) {
    if (isBlank) return this;

    if (index < 0 || index >= this!.length) return this;

    return '${this!.substring(0, index)}$replacement${this!.substring(index + 1, this!.length)}';
  }

  /// Replaces content after the first [delimiter] with [replacement].
  ///
  /// If [delimiter] is missing, returns [defaultValue] when provided,
  /// otherwise the original string.
  String? replaceAfter(
    String delimiter,
    String replacement, [
    String? defaultValue,
  ]) {
    if (isBlank) return this;

    final index = this!.indexOf(delimiter);

    return (index == -1)
        ? (defaultValue ?? this)
        : this!.replaceRange(
          index + delimiter.length,
          this!.length,
          replacement,
        );
  }

  /// Replaces content before the first [delimiter] with [replacement].
  ///
  /// If [delimiter] is missing, returns [defaultValue] when provided,
  /// otherwise the original string.
  String? replaceBefore(
    String delimiter,
    String replacement, [
    String? defaultValue,
  ]) {
    if (isBlank) return this;

    final index = this!.indexOf(delimiter);

    return (index == -1)
        ? (defaultValue ?? this)
        : this!.replaceRange(0, index, replacement);
  }

  /// Returns start indexes for all occurrences of [pattern].
  ///
  /// ### Example
  /// ```dart
  /// String foo = 'abracadabra';
  /// String result = foo.findPatterns(pattern:'abr'); // returns '[0, 7]'
  /// ```
  List<int> findPattern({required String pattern}) {
    if (isBlank || pattern.isEmpty) return [];

    final List<int> occurrences = [];
    // How many times the pattern can fit the text provided
    final fitCount = (this!.length / pattern.length).truncate();

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

  /// Repeats this string [count] times.
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

  /// Squeezes duplicate runs of [char] down to a single [char].
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

  /// Converts slash direction based on [direction].
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
  /// String revFoo2 = foo2.reverseSlash(1); // returns 'C:/Documents/user/test'
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

  /// Returns character at [index], or `null` when out of bounds.
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

    if (index >= this!.length || index < 0) return null;

    return this!.split('')[index];
  }

  /// Returns this string with [suffix] appended.
  ///
  /// ### Example
  ///
  /// ```dart
  /// String foo = 'hello';
  /// String newFoo = foo.append(' world'); // hello world
  /// ```
  String append(String suffix) {
    if (isBlank) return suffix;

    return this! + suffix;
  }

  /// Returns this string with [prefix] prepended.
  ///
  /// ### Example
  ///
  /// ```dart
  /// String foo = 'world';
  /// String newFoo = foo.prepend('hello '); // hello world
  /// ```
  String prepend(String prefix) {
    if (isBlank) return prefix;

    return prefix + this!;
  }

  /// Returns substring to the left of the first [pattern].
  ///
  /// If [pattern] doesn't exist, `null` is returned.
  /// ### Example
  ///
  /// ```dart
  ///  String test = 'hello brother what a day today';
  ///  String result = test.leftOf('brother'); // returns 'hello ';
  /// ```
  String? leftOf(String pattern) {
    if (isBlank) return this;

    final int index = this!.indexOf(pattern);

    if (index == -1) return null;

    return this!.substring(0, index);
  }

  /// Returns substring to the right of the first [pattern].
  ///
  /// If [pattern] doesn't exist, `null` is returned.
  ///
  /// ### Example
  ///
  /// ```dart
  ///  String test = 'hello brother what a day today';
  ///  String result = test.rightOf('brother'); // returns ' what a day today';
  /// ```
  String? rightOf(String pattern) {
    if (isBlank) return this;

    final int index = this!.indexOf(pattern);

    if (index == -1) return null;

    return this!.substring(index + pattern.length, this!.length);
  }

  /// Inserts [addition] immediately after first [pattern] match.
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
    if (isBlank || pattern.isEmpty) return this;

    final index = this!.indexOf(pattern);
    if (index == -1) return this;

    final insertAt = index + pattern.length;
    return this!.substring(0, insertAt) +
        addition +
        this!.substring(insertAt, this!.length);
  }

  /// Inserts [addition] immediately before first [pattern] match.
  ///
  /// If there is no match, the `String` is returned unchanged.
  ///
  /// ### Example
  /// ```dart
  /// String test = 'hello brother what a day today';
  /// String afterString = test.addBefore('brother', 'big '); // returns 'hello big brother what a day today';
  /// ```
  String? addBefore(String pattern, String addition) {
    if (isBlank || pattern.isEmpty) return this;

    final int indexOfFirstPatternWord = this!.indexOf(pattern);
    if (indexOfFirstPatternWord == -1) return this;

    return this!.substring(0, indexOfFirstPatternWord) +
        addition +
        this!.substring(indexOfFirstPatternWord, this!.length);
  }

  /// Wraps this value with [char] on both sides.
  String? wrap(String char) {
    if (isBlank) return this;

    return '$char$this$char';
  }

  /// Returns a new string with the current string centered in a string of length [width].
  ///
  /// If the current string is already longer than [width], the original string is returned.
  ///
  /// The optional [char] parameter specifies the character to use for padding.
  /// Defaults to a space character.
  ///
  /// Example:
  /// ```dart
  /// print('hello'.center(10)); // Output: '   hello   '
  /// print('hello'.center(10, '-')); // Output: '---hello---'
  /// ```
  String? center(int width, [String char = ' ']) {
    if (isBlank) return this;

    if (width <= this!.length) return this;

    final int totalPadding = width - this!.length;
    final int leftPadding = totalPadding ~/ 2;
    final int rightPadding = totalPadding - leftPadding;

    return char * leftPadding + this! + char * rightPadding;
  }

  /// Returns this string with characters shuffled randomly.
  ///
  /// ### Example
  /// ```dart
  /// String foo1 = 'esentis';
  /// String shuffled = foo.shuffle; // 'tsniees'
  /// ```
  String? get shuffle {
    if (isBlank) return this;

    final stringArray = toArray..shuffle();

    return stringArray.join();
  }

  /// Measures similarity to [other] using the selected [algorithm].
  ///
  /// Delegates to [StringSimilarity.compare].
  double compareWith(
    String other,
    SimilarityAlgorithm algorithm, {
    StringSimilarityConfig config = const StringSimilarityConfig(),
  }) =>
      isBlank
          ? 0.0
          : StringSimilarity.compare(this!, other, algorithm, config: config);
}
