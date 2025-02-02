import 'dart:math';

import 'index.dart';

extension StringConversions on String? {
  /// Capitalizes the `String` in normal form.
  /// ### Example
  /// ```dart
  /// String foo = 'hAckER';
  /// String cFoo = foo.capitalize; // returns 'Hacker'.
  /// ```
  String? get capitalize {
    if (isBlank) return this;

    return '${this![0].toUpperCase()}${this!.substring(1).toLowerCase()}';
  }

  /// Capitalizes the first character of each word in the string.
  String? get capitalizeEachWord {
    if (isBlank) return this;
    return this!.split(' ').map((word) => word.capitalize).join(' ');
  }

  /// Returns the `String` to snake_case.
  ///
  /// ### Example
  /// ```dart
  /// String foo = 'SNAKE CASE';
  /// String fooSnake = foo.toSnakeCase; // returns 'snake_case'
  /// ```
  String? get toSnakeCase {
    if (isBlank) return this;

    final words = this!.toLowerCase().trim().split(RegExp(r'(\s+)'));
    var snakeWord = '';

    if (this!.length == 1) return this;

    for (var i = 0; i <= words.length - 1; i++) {
      if (i == words.length - 1) {
        snakeWord += words[i];
      } else {
        snakeWord += '${words[i]}_';
      }
    }
    return snakeWord;
  }

  /// Returns the `String` in camel case.
  /// ### Example
  /// ```dart
  /// String foo = 'Find max of array';
  /// String camelCase = foo.toCamelCase; // returns 'findMaxOfArray'
  /// ```
  String? get toCamelCase {
    if (isBlank) return this;

    final words = this!.trim().split(RegExp(r'(\s+)'));

    final buffer = StringBuffer()..write(words[0].toLowerCase());

    for (var i = 1; i < words.length; i++) {
      buffer
        ..write(words[i].substring(0, 1).toUpperCase())
        ..write(words[i].substring(1).toLowerCase());
    }

    return buffer.toString();
  }

  /// Returns the `String` title cased.
  ///
  /// ```dart
  /// String foo = 'Hello dear friend how you doing ?';
  /// Sting titleCased = foo.toTitleCase; // returns 'Hello Dear Friend How You Doing'.
  /// ```
  String? get toTitleCase {
    if (isBlank) return this;

    final words = this!.trim().toLowerCase().split(' ');
    for (var i = 0; i < words.length; i++) {
      words[i] = words[i].substring(0, 1).toUpperCase() + words[i].substring(1);
    }

    return words.join(' ');
  }

  /// Converts a string to kebab case.
  ///
  /// Kebab case is a naming convention where words are separated by hyphens.
  /// This method replaces any occurrence of a lowercase letter followed by an
  /// uppercase letter with the lowercase letter, a hyphen, and the uppercase
  /// letter. The resulting string is then converted to lowercase.
  ///
  /// Returns the kebab case representation of the string.
  ///
  /// Example:
  /// ```dart
  /// 'camelCaseString'.toKebabCase; // 'camel-case-string'
  /// ```
  String? get toKebabCase {
    if (isBlank) return this;
    return this!
        .replaceAllMapped(RegExp(r'\s'), (match) => '')
        .replaceAllMapped(
          RegExp('([a-z])([A-Z])'),
          (match) => '${match[1]}-${match[2]}',
        )
        .toLowerCase();
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

  /// Returns a string abbreviation like Jon Doe -> JD.
  String get toInitials {
    if (isBlank) return '';

    final nameParts = this!.trim.call().toUpperCase().split(RegExp(r'[\s/]+'));

    if (nameParts.length > 1) {
      return nameParts.first.substring(0, 1) + nameParts[1].substring(0, 1);
    }

    return nameParts.first.length > 1
        ? nameParts.first.substring(0, 2)
        : nameParts.first;
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

    return this!.replaceAll(RegExp(r'\s+'), '');
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

    final letters = this!.split('').toList().reversed;
    return letters.reduce((current, next) => current + next);
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

  /// Checks if the `String` is consisted of same characters (ignores cases).
  ///
  /// ### Example
  /// ```dart
  /// String foo1 = 'ttttttt'
  /// bool hasSame1 = foo.hasSameCharacters; // true;
  /// ```
  /// ```dart
  /// String foo = 'ttttttt12'
  /// bool hasSame2 = foo.hasSameCharacters;  // false;
  /// ```
  bool get hasSameCharacters {
    if (isBlank) return false;

    if (this!.length > 1) {
      final b = this![0].toLowerCase();
      for (var i = 1; i < this!.length; i++) {
        final c = this![i].toLowerCase();
        if (c != b) {
          return false;
        }
      }
    }
    return true;
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

  /// Formats the `String` with a specific mask.
  ///
  /// You can assign your own [specialChar], defaults to '#'.
  ///
  /// ### Example
  /// ```dart
  ///var string3 = 'esentisgreece';
  ///var mask3 = 'Hello ####### you are from ######';
  ///var masked3 = string3.formatWithMask(mask3); // returns 'Hello esentis you are from greece'
  /// ```
  String? formatWithMask(String mask, {String specialChar = '#'}) {
    if (isBlank) return this;

    //var buffer = StringBuffer();
    final maskChars = mask.toArray;
    var index = 0;
    var out = '';
    for (final m in maskChars) {
      if (m == specialChar) {
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

  /// Removes the first [n] characters from the `String`.
  ///
  /// ### Example
  /// ```dart
  /// String foo = 'esentis'
  /// String newFoo = foo.removeFirst(3) // 'ntis';
  /// ```
  String? removeFirst(int n) {
    if (isBlank) return this;

    if (n <= 0) return this;

    if (n >= this!.length) return '';

    return this!.substring(n, this!.length);
  }

  /// Removes the last [n] characters from the `String`.
  ///
  /// ### Example
  /// ```dart
  /// String foo = 'esentis';
  /// String newFoo = foo.removeLast(3); // 'esen';
  /// ```
  String? removeLast(int n) {
    if (isBlank || n <= 0) return this;

    if (n >= this!.length) return '';

    return this!.substring(0, this!.length - n);
  }

  /// Trims the `String` to have maximum [n] characters.
  ///
  /// ### Example
  /// ```dart
  /// String foo = 'esentis';
  /// String newFoo = foo.maxChars(3); // 'esen';
  /// ```
  String? maxChars(int n) {
    if (isBlank || n >= this!.length) return this;

    if (n <= 0) return '';

    return this!.substring(0, n);
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

    if (index > this!.length) return null;

    if (index < 0) return null;

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

  /// Returns the left side of the `String` starting from [char].
  ///
  /// If [char] doesn't exist, `null` is returned.
  /// ### Example
  ///
  /// ```dart
  ///  String s = 'peanutbutter';
  ///  String foo = s.leftOf('butter'); // returns 'peanut'
  /// ```
  String? leftOf(String char) {
    if (isBlank) return this;

    final int index = this!.indexOf(char);

    if (index == -1) return null;

    return this!.substring(0, index);
  }

  /// Returns the right side of the `String` starting from [char].
  ///
  /// If [char] doesn't exist, `null` is returned.
  ///
  /// ### Example
  ///
  /// ```dart
  ///  String s = 'peanutbutter';
  ///  String foo = s.rightOf('peanut'); // returns 'butter'
  /// ```
  String? rightOf(String char) {
    if (isBlank) return this;

    final int index = this!.indexOf(char);

    if (index == -1) return null;

    return this!.substring(index + char.length, this!.length);
  }

  /// Quotes the `String` adding "" at the start & at the end.
  ///
  /// Removes all " characters from the `String` before adding the quotes.
  ///
  /// ### Example
  ///
  /// ```dart
  /// String text = '"""Is this real"';
  /// String quote = text.quote; // "Is this real"
  /// ```
  String? get quote {
    if (isBlank) return this;

    final String normalizedString = this!.replaceAll('"', '');

    return normalizedString.append('"').prepend('"');
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

  /// Returns the `String` after a specific character.
  ///
  /// ### Example
  ///
  /// ```dart
  /// String test = 'hello brother what a day today';
  /// String afterString = test.after('brother'); // returns ' what a day today'
  /// ```
  String? after(String pattern) {
    if (isBlank) return this;

    if (!this!.contains(pattern)) return '';

    final List<String> patternWords = pattern.split(' ');

    if (patternWords.isEmpty) return '';

    final int indexOfLastPatternWord = this!.indexOf(patternWords.last);

    if (patternWords.last.isEmpty) return '';

    return this!.substring(
      indexOfLastPatternWord + patternWords.last.length,
      this!.length,
    );
  }

  /// Returns the `String` before a specific character
  ///
  /// ### Example
  ///
  /// ```dart
  /// String test = 'hello brother what a day today';
  /// String beforeString = test.before('brother'); // returns 'hello '
  /// ```
  String? before(String pattern) {
    if (isBlank) return this;

    if (!this!.contains(pattern)) return '';

    final List<String> patternWords = pattern.split(' ');

    if (patternWords.isEmpty) return '';

    final int indexOfFirstPatternWord = this!.indexOf(patternWords.first);

    if (patternWords.last.isEmpty) return '';

    return this!.substring(0, indexOfFirstPatternWord);
  }

  /// Continuously removes from the beginning of the `String` any match in [patterns].
  ///
  /// ### Example
  ///
  /// ```dart
  /// String s = "esentis".removeFirstAny(["s", "ng"]);// returns "esentis";
  /// ```
  String? removeFirstAny(List<String?> patterns) {
    var from = this;
    if (from.isNotBlank) {
      for (final pattern in patterns) {
        if (pattern != null && pattern.isNotEmpty) {
          while (from!.startsWith(pattern)) {
            from = from.removeFirst(pattern.length);
          }
        }
      }
    }
    return from;
  }

  /// Continuously removes from the end of the `String`, any match in [patterns].
  ///
  /// ### Example
  ///
  /// ```dart
  /// String s = "esentisfs12".removeLastAny(["12","s","ng","f",]); // returns "esentis";
  /// ```
  String? removeLastAny(List<String?> patterns) {
    var from = this;
    if (from.isNotBlank) {
      for (final pattern in patterns) {
        if (pattern != null && pattern.isNotEmpty) {
          while (from!.endsWith(pattern)) {
            from = from.removeLast(pattern.length);
          }
        }
      }
    }
    return from;
  }

  /// Continuously removes from the beginning & the end of the `String`, any match in [patterns].
  String? removeFirstAndLastAny(List<String?> patterns) =>
      removeFirstAny(patterns).removeLastAny(patterns);

  /// Removes the [pattern] from the end of the `String`.
  ///
  /// ### Example
  ///
  /// ```dart
  /// String s = "coolboy".removeLastEqual("y"); // returns "coolbo";
  /// ```
  String? removeLastEqual(String? pattern) => removeLastAny([pattern]);

  /// Removes any [pattern] match from the beginning of the `String`.
  ///
  /// ### Example
  ///
  /// ```dart
  /// String s = "djing".removeFirstEqual("dj"); // returns "ing"
  /// ```
  String? removeFirstEqual(String? pattern) => removeFirstAny([pattern]);

  /// Removes any [pattern] match from the beginning & the end of the `String`.
  ///
  /// ### Example
  ///
  /// ```dart
  /// String edited = "abracadabra".removeFirstAndLastEqual("a"); // returns "bracadabr";
  /// ```
  String? removeFirstAndLastEqual(String? pattern) =>
      removeFirstEqual(pattern).removeLastEqual(pattern);

  /// Removes everything in the `String` after the first match of the [pattern].
  ///
  /// ### Example
  /// ```dart
  /// String test = 'hello brother what a day today';
  /// String afterString = test.removeAfter('brother'); // returns 'hello ';
  /// ```
  String? removeAfter(String pattern) {
    if (isBlank) return this;

    if (!this!.contains(pattern)) return '';

    final List<String> patternWords = pattern.split(' ');

    if (patternWords.isEmpty) return '';

    final int indexOfLastPatternWord = this!.indexOf(patternWords.last);

    if (patternWords.last.isEmpty) return '';

    return this!.substring(0, indexOfLastPatternWord);
  }

  /// Removes everything in the `String` before the match of the [pattern].
  ///
  /// ### Example
  ///
  /// ```dart
  /// String test = 'hello brother what a day today';
  /// String afterString = test.removeBefore('brother'); // returns 'brother what a day today';
  /// ```
  String? removeBefore(String pattern) {
    if (isBlank) return this;

    if (!this!.contains(pattern)) return '';

    final List<String> patternWords = pattern.split(' ');

    if (patternWords.isEmpty) return '';

    final int indexOfFirstPatternWord = this!.indexOf(patternWords.first);

    if (patternWords.last.isEmpty) return '';

    return this!.substring(
      indexOfFirstPatternWord + 1,
      this!.length,
    );
  }

  /// Replaces the part of the string after the first occurrence of the given [delimiter]
  /// with the [replacement] string. If the string does not contain the delimiter,
  /// returns [defaultValue] or the original string if [defaultValue] is not provided.
  String? replaceAfter(
    String delimiter,
    String replacement, [
    String? defaultValue,
  ]) {
    if (this == null) return null;
    final index = this!.indexOf(delimiter);
    return (index == -1)
        ? (defaultValue?.isEmpty ?? true)
            ? this
            : defaultValue
        : this!
            .replaceRange(index + delimiter.length, this!.length, replacement);
  }

  /// Replaces the part of the string before the first occurrence of the given [delimiter]
  /// with the [replacement] string. If the string does not contain the delimiter,
  /// returns [defaultValue] or the original string if [defaultValue] is not provided.compareIgnoreCase
  String? replaceBefore(
    String delimiter,
    String replacement, [
    String? defaultValue,
  ]) {
    if (this == null) return null;
    final index = this!.indexOf(delimiter);
    return (index == -1)
        ? (defaultValue?.isEmpty ?? true)
            ? this
            : defaultValue
        : this!.replaceRange(0, index, replacement);
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

  /// Checks if the `String` matches **ANY** of the given [patterns].
  ///
  /// ### Example
  ///
  /// ```dart
  /// bool contains = "abracadabra".containsAny(["a", "p"]); // returns true;
  /// ```
  bool containsAny(List<String?> patterns) {
    if (isNotBlank) {
      for (final String? item
          in patterns.where((element) => element.isNotBlank)) {
        if (this!.contains(item!)) return true;
      }
    }
    return false;
  }

  /// Checks if the `String` matches **ALL** given [patterns].
  ///
  /// ### Example
  ///
  /// ```dart
  /// bool contains = "abracadabra".containsAll(["abra", "cadabra"]; // returns true;
  /// ```
  bool containsAll(List<String?> patterns) {
    for (final String? item
        in patterns.where((element) => element.isNotBlank)) {
      if (isBlank || !this!.contains(item!)) return false;
    }
    return true;
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
  String? insertAt(int i, String value) {
    if (isNull) return this;

    if (i < 0 || i > this!.length) throw RangeError('Index out of range');

    final start = this!.substring(0, i);
    final end = this!.substring(i);
    return start + value + end;
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

  /// Wrap the given string between the [wrapWith].
  String? wrap(String wrapWith) {
    if (isBlank) return this;
    return '$wrapWith$this$wrapWith';
  }

  /// Returns a new string with the current string centered in a string of length [width].
  ///
  /// If the current string is already longer than [width], the original string is returned.
  ///
  /// The optional [fillChar] parameter specifies the character to use for padding.
  /// Defaults to a space character.
  ///
  /// Example:
  /// ```dart
  /// print('hello'.center(10)); // Output: '   hello   '
  /// print('hello'.center(10, '-')); // Output: '---hello---'
  /// ```
  String? center(int width, [String fillChar = ' ']) {
    if (isBlank) return this;

    if (width <= this!.length) return this;
    final int totalPadding = width - this!.length;
    final int leftPadding = totalPadding ~/ 2;
    final int rightPadding = totalPadding - leftPadding;
    return fillChar * leftPadding + this! + fillChar * rightPadding;
  }
}

extension Safe1 on String {
  // Transformation

  // Transformation - to Iterable

  /// Splits string by chunks with specified [size].
  ///
  /// If string is empty than empty [Iterable] will be returned.
  ///
  /// If [size] less or equal 0, that [ArgumentError] will be raised.
  Iterable<String> chunks(int size) sync* {
    if (isEmpty) return;

    if (size <= 0) {
      throw ArgumentError.value(size, 'size', 'Should be more than zero');
    }

    final total = length;
    if (total <= size) {
      yield this;
    } else {
      var start = 0;
      do {
        final end = start + size;
        yield substring(start, min(end, total));
        start = end;
      } while (start < total);
    }
  }
}

/// convert string to different types
extension RStringConvert on String {
  ///Convert  String to List of Characters
  List<String> toChars() => split('');

  /// convert String to int if is possible
  /// else throw `FormatException`
  int toInt() => int.parse(this);

  /// convert String to int if is possible
  /// else will return null
  int? toIntOrNull() => int.tryParse(this);

  /// convert String to int if is possible
  /// else will return value
  int toIntOr(int value) => toIntOrNull() ?? value;

  /// convert String to `double` if is possible
  /// else throw `FormatException`
  double toDouble() => double.parse(this);

  /// convert String to double if is possible
  /// else will return null
  double? toDoubleOrNull() => double.tryParse(this);

  /// convert String to double if is possible
  /// else will return value
  double toDoubleOr(double value) => toDoubleOrNull() ?? value;

  /// convert String to `DateTime` if is possible
  /// else throw `FormatException`
  DateTime toDate() => DateTime.parse(this);

  /// convert String to DateTime if is possible
  /// else will return null
  DateTime? toDateOrNull() => DateTime.tryParse(this);

  /// convert String to DateTime if is possible
  /// else will return value
  DateTime toDateOr(DateTime value) => toDateOrNull() ?? value;

  /// convert String to DateTime if is possible
  /// else will return DateTime Now
  DateTime toDateOrNow() => toDateOrNull() ?? DateTime.now();

  /// convert String to `num` if is possible
  /// else throw `FormatException`
  num toNum() => num.parse(this);

  /// convert String to `num` if is possible
  /// else return `0`
  num toNumOrZero() => toNumOr(0);

  /// convert String to DateTime if is possible
  /// else will return null
  num? toNumOrNull() => num.tryParse(this);

  /// convert String to DateTime if is possible
  /// else will return value
  num toNumOr(num value) => toNumOrNull() ?? value;
}
