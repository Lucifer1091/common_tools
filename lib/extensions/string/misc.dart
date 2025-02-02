import 'package:flutter/material.dart';

import 'index.dart';

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

    final words = this!.trim().split(RegExp(r'(\s+)'));
    final magicalNumber = words.length / wordsPerMinute;
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

    final words = this!.trim().split(RegExp(r'(\s+)'));
    // We filter out symbols and numbers from the word count
    final filteredWords = words.where((e) => e.onlyLatin.isNotBlank);
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

    final RegExp digitsOnly = RegExp(r'\d');
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

  /// Finds the most frequent character in the `String`.
  /// ### Example 1
  /// ```dart
  /// String foo = 'Hello World';
  /// String mostFrequent = foo.mostFrequent; // returns 'l'
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
