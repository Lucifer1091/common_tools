import 'dart:math';

import 'converters.dart';
import 'validators.dart';

extension NumHelper on num? {
  /// Returns an iterable from `0` up to but not including [this].
  ///
  /// Example:
  /// ```dart
  /// 5.range; // (0, 1, 2, 3, 4)
  /// ```
  Iterable<int> get range => Iterable<int>.generate(toInt());

  /// Generates a sequence from `this` to `end` (exclusive),
  /// with a customizable `step` size.
  ///
  /// - If `step` is positive, it counts up.
  /// - If `step` is negative, it counts down.
  /// - If `step` is omitted, it auto-determines direction.
  ///
  /// Example:
  /// ```dart
  /// print(3.to(6));        // (3, 4, 5)
  /// print(8.to(3, step: 2));  // (8, 6, 4)
  /// print(8.to(3, step: -2)); // (8, 6, 4)
  /// print(1.to(10, step: 3)); // (1, 4, 7)
  /// ```
  Iterable<num> to(num end, {num? step}) sync* {
    if (step == 0) {
      throw ArgumentError('Step size cannot be zero');
    }

    final num direction = end > getOr() ? 1 : -1; // Determine auto-direction
    final num stepSize =
        step ?? direction; // Use provided step or auto-direction

    num current = getOr();

    while (
        (direction > 0 && current < end) || (direction < 0 && current > end)) {
      yield current;
      current += stepSize;
    }
  }

  /// Creates an [Iterable<int>] that contains all values from current integer
  /// until (including) the value [n].
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

  /// Creates an [Iterable<int>] that contains all values from current integer
  /// until (excluding) the value [n].
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

  /// Executes the function [action] for [this] times.
  ///
  /// Example:
  /// 3.times(() => print('Hello')); // Hello... Hello... Hello
  void times(void Function() action) {
    0.until(toInt()).forEach((_) => action());
  }

  /// runs [func] for [this] number of times.
  /// This is irrespective of the sign of [this]. the for loop will always
  /// run from 1 to absolute value of [this].
  ///
  /// Returns [List] of type [T] where T is the return type of [func]
  List<T> repeat<T>(T Function(int count) func) =>
      [for (var i = 1; i <= toInt().abs(); i++) func(i)];

  /// Generates a non-negative random floating point value uniformly distributed
  /// in the range from 0.0, inclusive, to 1.0, exclusive.
  double randomDouble({double? max}) => Random().nextDouble() * (max ?? 1);

  /// Generates a non-negative random integer uniformly distributed in the range
  /// rom 0, inclusive, to [max], exclusive.
  /// default [max] is 1_000_000
  int randomInt({int? max}) => Random().nextInt(max ?? 1000000);

  /// Get list of random numbers.
  List<num> randomList({int min = 0, int max = 100}) {
    if (isNull) return [];

    final result = <num>[];

    for (var i = 0; i < this!; i++) {
      result.add(Random().nextInt(max - min) + min);
    }

    return result;
  }

  /// Get the lorem ipsum text of [this] words.
  String loremIpsum() {
    if (isNull) return '';

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

    for (var i = 0; i < this!; i++) {
      buffer.write('${words[i % words.length]} ');
    }

    return buffer.toString();
  }
}

extension IterableNumSumExtension<T extends num> on Iterable<T> {
  /// Returns the sum of all elements in the collection.
  T sum() {
    num sum = 0.0;
    for (final current in this) {
      sum += current;
    }
    if (T == int) {
      return sum.toInt() as T;
    } else {
      return sum.toDouble() as T;
    }
  }

  /// Returns the average of all elements in the collection.
  double average() {
    var count = 0;
    num sum = 0;
    for (final current in this) {
      sum += current;
      count++;
    }

    if (count == 0) {
      throw StateError('No elements in collection');
    } else {
      return sum / count;
    }
  }

  /// Returns the median of the elements in this collection.
  ///
  /// Empty collections throw an error.
  double median() {
    if (length == 0) throw StateError('No elements in collection');
    final values = toList()..sort();
    final size = values.length;
    if (size.isOdd) {
      return values[(size / 2).floor()].toDouble();
    } else {
      final x = values[(size / 2).floor()];
      final y = values[(size / 2).floor() - 1];
      return (x + y) / 2;
    }
  }
}
