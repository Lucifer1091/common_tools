import 'dart:math';

import 'converters.dart';
import 'validators.dart';

/// Iterable, looping, and random-text helpers for nullable numbers.
extension NumHelper on num? {
  /// Returns values from `0` up to but not including this integer value.
  ///
  /// Example:
  /// ```dart
  /// 5.range; // (0, 1, 2, 3, 4)
  /// ```
  Iterable<int> get range {
    final count = toInt();
    if (count <= 0) return const Iterable<int>.empty();
    return Iterable<int>.generate(count);
  }

  /// Generates a sequence from this value toward [end] (exclusive).
  ///
  /// [step] is treated as magnitude (`abs`), and direction is inferred from
  /// start/end.
  ///
  /// Example:
  /// ```dart
  /// print(3.to(6));        // (3, 4, 5)
  /// print(8.to(3, step: 2));  // (8, 6, 4)
  /// print(8.to(3, step: -2)); // (8, 6, 4)
  /// print(1.to(10, step: 3)); // (1, 4, 7)
  /// ```
  Iterable<num> to(num end, {num? step}) sync* {
    if (isNull) return;

    final start = this!;
    if (start == end) return;

    final magnitude = (step ?? 1).abs();
    if (magnitude == 0) {
      throw ArgumentError('Step size cannot be zero');
    }

    final num direction = end > start ? 1 : -1;
    final num stepSize = magnitude * direction;
    num current = start;

    while ((direction > 0 && current < end) ||
        (direction < 0 && current > end)) {
      yield current;
      current += stepSize;
    }
  }

  /// Returns all integer values from this value through [n] (inclusive).
  ///
  /// Example:
  /// ```dart
  /// 0.rangeTo(5); // [0, 1, 2, 3, 4, 5]
  /// 3.rangeTo(1); // [3, 2, 1]
  /// ```
  Iterable<int> rangeTo(int n) {
    final value = toInt();

    final count = (n - value).abs() + 1;
    final direction = (n - value).sign;
    var i = value - direction;
    return Iterable.generate(count, (int index) => i += direction);
  }

  /// Returns all integer values from this value until [n] (exclusive).
  ///
  /// Example:
  /// ```dart
  /// 0.until(5); // [0, 1, 2, 3, 4]
  /// 3.until(1); // [3, 2]
  /// ```
  Iterable<int> until(int n) {
    final value = toInt();

    if (value < n) {
      return rangeTo(n - 1);
    } else if (value > n) {
      return rangeTo(n + 1);
    } else {
      return const Iterable.empty();
    }
  }

  /// Executes [action] `toInt()` times.
  ///
  /// Example:
  /// ```dart
  /// 3.times(() => print('Hello'));
  /// ```
  void times(void Function() action) {
    final count = toInt();
    if (count <= 0) return;

    for (var i = 0; i < count; i++) {
      action();
    }
  }

  /// Runs [func] `abs(toInt())` times with 1-based index.
  ///
  /// Example:
  /// ```dart
  /// final values = 3.repeat((i) => i * 2); // [2, 4, 6]
  /// ```
  List<T> repeat<T>(T Function(int count) func) => [
    for (var i = 1; i <= toInt().abs(); i++) func(i),
  ];

  /// Returns a list of random integers in `[min, max)`.
  ///
  /// The resulting list length is `toInt()`.
  List<num> randomList({int min = 0, int max = 100}) {
    if (isNull) return [];
    if (min >= max) {
      throw ArgumentError.value(max, 'max', 'max must be greater than min');
    }

    final count = toInt();
    if (count <= 0) return [];

    final random = Random();
    return List<num>.generate(count, (_) => random.nextInt(max - min) + min);
  }

  /// Returns lorem-ipsum text with `toInt()` words.
  ///
  /// Returns empty string for `null` or non-positive values.
  String loremIpsum() {
    if (isNull) return '';
    final count = toInt();
    if (count <= 0) return '';

    final words = [
      'lorem',
      'ipsum',
      'dolor',
      'sit',
      'amet',
      'consectetur',
      'adipiscing',
      'elit',
      'sed',
      'do',
      'eiusmod',
      'tempor',
      'incididunt',
      'ut',
      'labore',
      'et',
      'dolore',
      'magna',
      'aliqua',
      'ut',
      'enim',
      'ad',
      'minim',
      'veniam',
      'quis',
      'nostrud',
      'exercitation',
      'ullamco',
      'laboris',
      'nisi',
      'ut',
      'aliquip',
      'ex',
      'ea',
      'commodo',
      'consequat',
      'duis',
      'aute',
      'irure',
      'dolor',
      'in',
      'reprehenderit',
      'in',
      'voluptate',
      'velit',
      'esse',
      'cillum',
      'dolore',
      'eu',
      'fugiat',
      'nulla',
      'pariatur',
      'excepteur',
      'sint',
      'occaecat',
      'cupidatat',
      'non',
      'proident',
      'sunt',
      'in',
      'culpa',
      'qui',
      'officia',
      'deserunt',
      'mollit',
      'anim',
      'id',
      'est',
      'laborum',
    ];

    final buffer = StringBuffer();

    for (var i = 0; i < count; i++) {
      buffer.write('${words[i % words.length]} ');
    }

    return buffer.toString().trimRight();
  }
}
