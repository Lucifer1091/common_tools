import '../../index.dart';

/// Common Operations for Iterables with nullable items.
extension IterableValidators<T> on Iterable<T>? {
  /// Returns `true` if this iterable is `null` or empty.
  bool get isBlank => this?.isEmpty ?? true;

  /// Returns `true` if this iterable is not `null` and not empty.
  bool get isNotBlank => !isBlank;

  /// Returns `true` if the iterable contains exactly one element.
  ///
  /// Returns `false` for `null`, empty, or multi-item iterables.
  bool get isSingle => this?.singleOrNull != null;

  /// Returns `true` if no entries match the given [predicate] or if the
  /// collection is empty.
  bool none(Predicate<T> predicate) => this?.any(predicate) != true;

  /// Returns `true` if there is exactly one element of [Iterable] which satisfies
  /// [test].
  ///
  /// Example:
  /// ```dart
  /// [1, 2, 3].one((e) => e == 2); // 1 element satisfies. Returns true.
  /// [1, 2, 3].one((e) => e > 4); // No element satisfies. Returns false.
  /// [1, 2, 3].one((e) => e > 1); // >1 element satisfies. Returns false.
  /// ```
  bool one(Predicate<T> test) {
    if (isBlank) return false;

    bool found = false;

    for (final element in this!) {
      if (test(element)) {
        if (found) return false;
        found = true;
      }
    }
    return found;
  }

  /// Returns `true` if the iterable has at least one element of type [S].
  bool anyType<S extends T>() => this?.whereType<S>().isNotEmpty ?? false;

  /// Returns `true` if the collection contains all the elements
  /// present in [other] collection.
  bool containsAll(Iterable<T>? other) =>
      this != null && (other?.every(this!.contains) ?? false);

  /// Returns `true` if the collection does not contain any of the elements
  /// present in [other] collection.
  bool containsNone(Iterable<T>? other) =>
      none((element) => other?.contains(element) ?? false);

  /// Checks if any elements in the specified [other] are contained in
  /// this collection.
  bool containsAny(Iterable<T>? other) {
    if (isBlank || other.isBlank) return false;

    for (final element in other!) {
      if (this!.contains(element)) return true;
    }
    return false;
  }

  /// Returns `true` if this collection is structurally equal to the [other]
  /// collection.
  ///
  /// I.e. contain the same number of the same elements in the same order.
  ///
  /// If [compare] is provided, it is used to check if two elements are the
  /// same.
  bool contentEquals(Iterable<T>? other, [IsEqual<T>? compare]) {
    if (identical(this, other)) return true;
    if (this == null || other == null) return false;

    final it1 = this!.iterator, it2 = other.iterator;

    if (compare != null) {
      while (it1.moveNext()) {
        if (!it2.moveNext()) return false;
        if (!compare(it1.current, it2.current)) return false;
      }
    } else {
      while (it1.moveNext()) {
        if (!it2.moveNext()) return false;
        if (it1.current != it2.current) return false;
      }
    }

    return !it2.moveNext();
  }

  /// Returns if this [Iterable] starts with the elements of [other].
  ///
  /// If [other] is empty, `true` is returned. If [other] has
  /// more elements than this [Iterable], `false` is returned.
  ///
  /// ```dart
  /// [1, 2, 3].startsWith([]); // -> true
  /// [1, 2, 3].startsWith([1]); // -> true
  /// [1, 2, 3].startsWith([1, 2]); // -> true
  /// [1, 2, 3].startsWith([1, 2, 3]); // -> true
  /// [1, 2, 3].startsWith([1, 2, 3, 4]); // -> false
  /// [1, 2, 3].startsWith([2, 3]); // -> false
  /// ```
  bool startsWith(Iterable<T> other) {
    if (other.isEmpty) return true;
    if (this == null) return false;

    final thisIterator = this!.iterator;
    final otherIterator = other.iterator;
    if (!otherIterator.moveNext()) return true;
    do {
      // this iterator is empty or the current elements are different
      if (!thisIterator.moveNext() ||
          otherIterator.current != thisIterator.current) {
        return false;
      }
    } while (otherIterator.moveNext());
    return true;
  }
}
