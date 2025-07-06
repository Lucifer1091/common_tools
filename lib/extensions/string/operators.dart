import 'index.dart';

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

    final int index = this!.indexOf(pattern);

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

    final int index = this!.lastIndexOf(pattern);

    if (index == -1) return this!;

    return this!.replaceRange(index, index + pattern.length, replacement);
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

  /// Replaces the part of the string after the first occurrence of the given [delimiter]
  /// with the [replacement] string. If the string does not contain the delimiter,
  /// returns [defaultValue] or the original string if [defaultValue] is not provided.
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

  /// Replaces the part of the string before the first occurrence of the given [delimiter]
  /// with the [replacement] string. If the string does not contain the delimiter,
  /// returns [defaultValue] or the original string if [defaultValue] is not provided.compareIgnoreCase
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

  /// Given a pattern returns the starting indices of all occurrences of the [pattern] in the `String`.
  ///
  /// ### Example
  /// ```dart
  /// String foo = 'abracadabra';
  /// String result = foo.findPatterns(pattern:'abr'); // returns '[0, 7]'
  /// ```
  List<int> findPattern({required String pattern}) {
    if (isBlank) return [];

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

    if (index > this!.length || index < 0) return null;

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

  /// Returns the left side of the `String` starting from [pattern].
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

  /// Returns the right side of the `String` starting from [pattern].
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

    final List<String> patternWords = pattern.split(' ');

    if (patternWords.isEmpty) return '';

    final int indexOfLastPatternWord = this!.indexOf(patternWords.last);

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

    final List<String> patternWords = pattern.split(' ');

    if (patternWords.isEmpty) return '';

    final int indexOfFirstPatternWord = this!.indexOf(patternWords.first);

    if (patternWords.last.isEmpty) return '';

    return this!.substring(0, indexOfFirstPatternWord) +
        addition +
        this!.substring(indexOfFirstPatternWord, this!.length);
  }

  /// Wrap the given string between the [char].
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

  /// Shuffles the given `String`'s characters.
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

  /// Measures how similar this string is to another string using the specified algorithm.
  /// it uses the public [StringSimilarity] class which offers different methods
  /// for measuring how similar two strings are.
  double compareWith(
    String other,
    SimilarityAlgorithm algorithm, {
    StringSimilarityConfig config = const StringSimilarityConfig(),
  }) =>
      isBlank
          ? 0.0
          : StringSimilarity.compare(this!, other, algorithm, config: config);
}
