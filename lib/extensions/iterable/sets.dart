import 'dart:math' as math;

import '../../index.dart';

/// Utility extension methods for the native [Set] class.
extension SetBasics<T> on Set<T>? {
  /// Returns `true` if [T] and [other] contain exactly the same elements.
  ///
  /// Example:
  /// ```dart
  /// var set = {'a', 'b', 'c'};
  /// set.isEqualTo({'b', 'a', 'c'}); // true
  /// set.isEqualTo({'b', 'a', 'f'}); // false
  /// set.isEqualTo({'a', 'b'}); // false
  /// set.isEqualTo({'a', 'b', 'c', 'd'}); // false
  /// ```
  bool isEqualTo(Set<Object>? other) {
    final current = this;
    if (current == null || other == null) {
      return current == null && other == null;
    }

    return current.length == other.length && current.containsAll(other);
  }

  /// Returns `true` if [T] and [other] have no elements in common.
  ///
  /// Example:
  /// ```dart
  /// var set = {'a', 'b', 'c'};
  /// set.isDisjointWith({'d', 'e', 'f'}); // true
  /// set.isDisjointWith({'d', 'e', 'b'}); // false
  /// ```
  bool isDisjointWith(Set<Object>? other) {
    if (this == null || other == null) return true;

    return this!.intersection(other).isEmpty;
  }

  /// Returns `true` if [T] and [other] have at least one element in common.
  ///
  /// Example:
  /// ```dart
  /// var set = {'a', 'b', 'c'};
  /// set.isIntersectingWith({'d', 'e', 'b'}); // true
  /// set.isIntersectingWith({'d', 'e', 'f'}); // false
  /// ```
  bool isIntersectingWith(Set<Object>? other) {
    if (this == null || other == null) return false;

    return this!.intersection(other).isNotEmpty;
  }

  /// Returns `true` if every element of [T] is contained in [other].
  ///
  /// Example:
  /// ```dart
  /// var set = {'a', 'b', 'c'};
  /// set.isSubsetOf({'a', 'b', 'c', 'd'}); // true
  /// set.isSubsetOf({'a', 'b', 'c'}); // true
  /// set.isSubsetOf({'a', 'b', 'f'}); // false
  /// ```
  bool isSubsetOf(Set<Object>? other) {
    final current = this;
    if (current == null || current.isEmpty) return true;
    if (other == null) return false;

    return current.length <= other.length && other.containsAll(current);
  }

  /// Returns `true` if every element of [other] is contained in [T].
  ///
  /// ```dart
  /// var set = {'a', 'b', 'c'};
  /// set.isSupersetOf({'a', 'b'}); // true
  /// set.isSupersetOf({'a', 'b', 'c'}); // true
  /// set.isSupersetOf({'a', 'b', 'f'}); // false
  /// ```
  bool isSupersetOf(Set<Object> other) {
    final current = this;
    if (current == null) return other.isEmpty;

    return current.length >= other.length && current.containsAll(other);
  }

  /// Returns `true` if every element of [T] is contained in [other] and at
  /// least one element of [other] is not contained in [T].
  ///
  /// Example:
  /// ```dart
  /// var set = {'a', 'b', 'c'};
  /// set.isStrictSubsetOf({'a', 'b', 'c', 'd'}); // true
  /// set.isStrictSubsetOf({'a', 'b', 'c'}); // false
  /// set.isStrictSubsetOf({'a', 'b', 'f'}); // false
  /// ```
  bool isStrictSubsetOf(Set<Object> other) {
    final current = this;
    if (current == null || current.isEmpty) return other.isNotEmpty;

    return current.length < other.length && other.containsAll(current);
  }

  /// Returns `true` if every element of [other] is contained in [T] and at
  /// least one element of [T] is not contained in [other].
  ///
  /// ```dart
  /// var set = {'a', 'b', 'c'};
  /// set.isStrictSupersetOf({'a', 'b'}); // true
  /// set.isStrictSupersetOf({'a', 'b', 'c'}); // false
  /// set.isStrictSupersetOf({'a', 'b', 'f'}); // false
  /// ```
  bool isStrictSupersetOf(Set<Object> other) {
    final current = this;
    if (current == null) return false;

    return current.length > other.length && current.containsAll(other);
  }

  /// Removes a random element of this set and returns it.
  ///
  /// Returns `null` if the set is empty.
  ///
  /// If [seed] is provided, will be used as the random seed for determining
  /// which element to select. (See [math.Random].)
  T? takeRandom({int? seed}) {
    if (isBlank) return null;

    final element = this!.elementAt(math.Random(seed).nextInt(this!.length));
    this!.remove(element);
    return element;
  }

  /// Returns a map grouping all elements of [T] with the same value for
  /// [classifier].
  ///
  /// Example:
  /// ```dart
  /// {'aaa', 'bbb', 'cc', 'a', 'bb'}.classify<int>((e) => e.length);
  /// // Returns {
  /// //   1: {'a'},
  /// //   2: {'cc', 'bb'},
  /// //   3: {'aaa', 'bbb'}
  /// // }
  /// ```
  Map<K, Set<T>> classify<K>(Transformer<T, K> classifier) {
    if (isBlank) return {};

    final groups = <K, Set<T>>{};
    for (final e in this!) {
      groups.putIfAbsent(classifier(e), () => <T>{}).add(e);
    }
    return groups;
  }
}
