import 'dart:convert';
import 'dart:typed_data';

import '../../constants/constants.dart';
import 'index.dart';

extension BigIntIterableExtension on Iterable<BigInt>? {
  /// Returns max value of values.
  BigInt min() {
    return isBlank
        ? BigInt.zero
        : this!.reduce((value, element) => value < element ? value : element);
  }

  /// Returns min value of values.
  BigInt max() {
    return isBlank
        ? BigInt.zero
        : this!.reduce((value, element) => value > element ? value : element);
  }
}

/// provides extensions for List of integers. e.g. bytes
extension IntListScrewdriver on List<int> {
// / Converts the list of integers to a base64 encoded string. e.g. converting
// / bytes to base64 string.
  String toBase64() => base64Encode(this);

  /// Converts list of integers to a [Uint8List].
  Uint8List toUint8List() => Uint8List.fromList(this);

  /// Converts list of integers to a [Uint16List].
  Uint16List toUint16List() => Uint16List.fromList(this);
}

extension IterableJoinToString<T> on Iterable<T> {
  /// Creates a string from all the elements separated using [separator] and
  /// using the given [prefix] and [postfix] if supplied.
  ///
  /// If the collection could be huge, you can specify a non-negative value of
  /// [limit], in which case only the first [limit] elements will be appended,
  /// followed by the [truncated] string (which defaults to `'...'`).
  String joinToString({
    String separator = ', ',
    GetValue<T, String>? transform,
    String prefix = '',
    String postfix = '',
    int? limit,
    String truncated = '...',
  }) {
    final buffer = StringBuffer();
    var count = 0;

    for (final element in this) {
      if (limit != null && count >= limit) {
        buffer.write(truncated);
        return buffer.toString();
      }

      if (count > 0) buffer.write(separator);

      buffer.write(prefix);

      if (transform != null) {
        buffer.write(transform(element));
      } else {
        buffer.write(element.toString());
      }
      buffer.write(postfix);

      count++;
    }

    return buffer.toString();
  }
}

extension ListFlattenExtension<E> on List<List<E>> {
  /// Returns a new [List] of all elements from all lists in this
  /// [List].
  ///
  /// ```dart
  /// final nestedList = [[1, 2, 3], [4, 5, 6]];
  /// final flattened = nestedList.flatten(); // [1, 2, 3, 4, 5, 6]
  /// ```
  ///
  ///
  /// This is a specialization of [IterableIterableX].flatten() which allows
  /// accessing elements by index afterwards
  ///
  /// ```dart
  /// final flat = [['a', 'b'], ['c', 'd']].flatten();
  /// print(flat[2]); // prints "c"
  /// ```
  List<E> flatten() => [for (final list in this) ...list];
}

extension IterableIterableX<T> on Iterable<Iterable<T>> {
  /// Returns a new lazy [Iterable] of all elements from all collections in this
  /// collection.
  ///
  /// ```dart
  /// final nestedList = List([[1, 2, 3], [4, 5, 6]]);
  /// final flattened = nestedList.flatten(); // [1, 2, 3, 4, 5, 6]
  /// ```
  Iterable<T> flatten() sync* {
    for (final current in this) {
      yield* current;
    }
  }
}

extension IterableFutureX<T> on Iterable<Future<T>> {
  /// Create a stream from a group of futures.
  ///
  /// The stream reports the results of the futures on the stream in the order
  /// in which the futures complete.
  /// Each future provides either a data event or an error event,
  /// depending on how the future completes.
  ///
  /// If some futures have already completed when `Stream.fromFutures` is
  /// called, their results will be emitted in some unspecified order.
  ///
  /// When all futures have completed, the stream is closed.
  Stream<T> asStreamAwaited() => Stream.fromFutures(this);
}
