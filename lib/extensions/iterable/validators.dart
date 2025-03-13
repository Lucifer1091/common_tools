import '../../common_tools.dart';

/// Common Operations for Iterables with nullable items.
extension IterableValidators<T> on Iterable<T>? {
  /// Alias for [isNullOrEmpty].
  /// Returns true if [T] is either null or empty collection.
  bool get isBlank => this?.isEmpty ?? true;

  /// Alias for [isNotNullOrEmpty].
  /// Returns true if [T] is neither null nor empty collection.
  bool get isNotBlank => !isBlank;

  // This getter checks if the List contains exactly one element.
  bool get isSingle => this?.singleOrNull != null;

  /// Returns true if no entries match the given [predicate] or if the
  /// collection is empty.
  bool none(Selector<T> predicate) => isNotBlank && !this!.any(predicate);

  /// Returns `true` if the iterable is has an element of type [S].
  bool anyType<S extends T>() => this?.whereType<S>().isNotEmpty ?? false;

  /// Checks if all elements in the specified [other] are contained in
  /// T collection.
  bool containsAll(Iterable<T>? other) {
    if (isBlank || other.isBlank) return false;

    for (final element in other!) {
      if (!this!.contains(element)) return false;
    }
    return true;
  }

  /// Checks if any elements in the specified [other] are contained in
  /// T collection.
  bool containsAny(Iterable<T>? other) {
    if (isBlank || other.isBlank) return false;

    for (final element in other!) {
      if (this!.contains(element)) return true;
    }
    return false;
  }

  /// Returns true if T collection is structurally equal to the [other]
  /// collection.
  ///
  /// I.e. contain the same number of the same elements in the same order.
  ///
  /// If [compare] is provided, it is used to check if two elements are the
  /// same.
  bool contentEquals(Iterable<T>? other, [Comparator<T>? compare]) {
    if (isBlank || other.isBlank) return false;

    final it1 = this!.iterator, it2 = other!.iterator;

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
    if (isBlank || other.isBlank) return false;

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
