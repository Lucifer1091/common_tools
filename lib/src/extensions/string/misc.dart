import 'package:flutter/material.dart';

import './sanitizers.dart';
import './validators.dart';

/// Miscellaneous analytics and conditional helpers for nullable strings.
extension MiscExtensions on String? {
  /// Returns the average read time duration of the given `String` in seconds.
  ///
  /// The default calculation is based on 200 words per minute.
  ///
  /// You can pass the [wordsPerMinute] parameter for different read speeds.
  /// ### Example
  /// ```dart
  ///  String foo =  'Hello dear friend how you doing ?';
  ///  int readTime = foo.readTime(); // returns 3 seconds.
  /// ```
  int readTime({int wordsPerMinute = 200}) {
    if (isBlank) return 0;
    if (wordsPerMinute <= 0) {
      throw ArgumentError.value(
        wordsPerMinute,
        'wordsPerMinute',
        'must be greater than zero',
      );
    }

    final words = this!.trim().split(RegExp(r'(\s+)'));
    final minutes = words.length / wordsPerMinute;
    return (minutes * 60).ceil();
  }

  /// Returns an approximate word count.
  ///
  /// Splits by whitespace and counts only tokens containing Latin letters.
  ///
  /// Example:
  /// ```dart
  /// final count = 'Hello dear friend how are you doing ?'.wordCount; // 7
  /// ```
  int get wordCount {
    if (isBlank) return 0;

    final words = this!.trim().split(RegExp(r'(\s+)'));
    // We filter out symbols and numbers from the word count
    final filteredWords = words.where((e) => e.onlyLatin.isNotBlank);
    return filteredWords.length;
  }

  /// Returns the count of numeric digits in this string.
  ///
  /// Example:
  /// ```dart
  /// 'Hello World'.digitCount; // 0
  /// 'Hello World 123'.digitCount; // 3
  /// ```
  int get digitCount {
    if (isBlank) return 0;

    final RegExp digitsOnly = RegExp(r'\d');
    return digitsOnly.allMatches(this!).length;
  }

  /// Returns line count using `\n` as separator.
  int get linesCount => isBlank ? 0 : this!.split('\n').length;

  /// Counts occurrences of a single-character [char].
  ///
  /// Example:
  /// ```dart
  /// 'foo'.charCount('o'); // 2
  /// ```
  int charCount(String char) {
    if (isBlank) return 0;

    return this!
        .split('')
        .fold<int>(
          0,
          (previousValue, ch) => previousValue + (ch == char ? 1 : 0),
        );
  }

  /// Counts whole-word matches of [word], case-insensitively.
  ///
  /// Example:
  /// ```dart
  /// 'hello world, hello!'.countWords('hello'); // 2
  /// ```
  int countWords(String word) {
    if (isBlank || word.isEmpty) return 0;

    final pattern = RegExp(
      r'\b' + RegExp.escape(word) + r'\b',
      caseSensitive: false,
    );

    return pattern.allMatches(this!).length;
  }

  /// Returns sorted character frequency as a list of single-entry maps.
  ///
  /// Example:
  /// ```dart
  /// 'esentis'.charOccurrences; // [{'e': 2}, {'i': 1}, {'n': 1}, {'s': 2}]
  /// ```
  List<Map<String, int>> get charOccurrences {
    if (isBlank) return [];

    final List<Map<String, int>> occurrences = [];
    final letters = this!.split('')..sort();
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

  /// Returns the most frequent character.
  ///
  /// Returns this value unchanged when blank (`null`/empty/whitespace).
  ///
  /// Example:
  /// ```dart
  /// 'Hello World'.mostFrequent(); // 'l'
  /// ```
  String? mostFrequent({bool ignoreSpaces = false}) {
    if (isBlank) return this;

    if (ignoreSpaces) return this!.replaceAll(' ', '').mostFrequent();

    final occurrences = <String, int>{};
    final letters = this!.split('')..sort();
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

  /// Returns common characters between this string and [otherString].
  ///
  /// Case-sensitive and sorted by default.
  ///
  /// Example:
  /// ```dart
  /// 'Hello World'.commonCharacters('World Hello!');
  /// // {' ', 'H', 'W', 'd', 'e', 'l', 'o', 'r'}
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
    final Set<String> otherStringSet = processString(
      otherString,
    ).split('').toSet();

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

  /// Returns symmetric difference of characters between this string and [otherString].
  ///
  /// Case-sensitive by default.
  ///
  /// Example:
  /// ```dart
  /// 'Hello'.uncommonCharacters('World'); // {'H', 'W', 'r', 'd'}
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
    final Set<String> otherStringSet = processString(
      otherString,
    ).split('').toSet();

    final Set<String> uncommonSet = thisSet
        .union(otherStringSet)
        .difference(thisSet.intersection(otherStringSet));

    return uncommonSet;
  }

  /// Returns [action] when this value is empty after trim.
  ///
  /// Returns `null` when this value is `null`.
  ///
  /// Example:
  /// ```dart
  /// ''.ifEmpty(() => 'fallback'); // fallback
  /// ```
  String? ifEmpty(ValueGetter<String?> action) {
    if (isNull) return null;

    return this!.trim().isEmpty ? action() : this;
  }

  /// Returns [action] when this value is blank.
  ///
  /// If this value is non-blank, returns it unchanged.
  ///
  /// Example:
  /// ```dart
  /// ''.ifNull(() => 'fallback'); // fallback
  /// 'ok'.ifNull(() => 'fallback'); // ok
  /// ```
  String ifNull(ValueGetter<String> action) {
    if (isNotBlank) return this!;

    return action();
  }

  /// Return a empty `String` if this equals [other]. Otherwise return this.
  ///
  /// ### Example
  ///
  /// ```dart
  /// String t = 'OK'.emptyIf("OK"); // returns "";
  /// String f = 'NO'.emptyIf("YES"); // returns "NO";
  /// ```
  String? emptyIf(String? other) => asIf((s) => s == other, '', this);

  /// Return null if this equals [other]. Otherwise return this.
  ///
  /// ### Example
  ///
  /// ```dart
  /// String t = 'OK'.nullIf("OK"); // returns null;
  /// String f = 'NO'.nullIf("YES"); // returns "NO";
  /// ```
  String? nullIf(String? other) => asIf((s) => s == other, null, this);

  /// Returns this value when non-blank, otherwise [other].
  String? ifBlank(String? other) => asIf((s) => s.isNotBlank, this, other);

  /// Returns [other] when this value is non-blank, otherwise this value.
  String? ifNotBlank(String? other) => asIf((s) => s.isNotBlank, other, this);

  /// Returns [trueString] when [comparison] passes, otherwise [falseString].
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
  ) => comparison(this) ? trueString : falseString;
}
