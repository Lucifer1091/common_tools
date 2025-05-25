import 'dart:collection';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../common_tools.dart';
import 'index.dart';

/// List extensions.
extension GenericListExtensions<T> on Iterable<T> {
  /// Returns a new list that contains this list repeated [data] times.
  ///
  /// The [data] argument specifies the number of times the list should be repeated.
  ///
  /// Example:
  /// ```dart
  /// List<int> numbers = [1, 2, 3];
  /// List<int> repeatedNumbers = numbers * 3;
  /// print(repeatedNumbers); // Output: [1, 2, 3, 1, 2, 3, 1, 2, 3]
  /// ```
  ///
  /// Returns:
  /// A new list that contains this list repeated [data] times.
  List<T> operator *(int data) {
    final List<T> result = [];
    for (int i = 0; i < data; i++) {
      result.addAll(this);
    }
    return result;
  }

  /// Returns a new list that contains the elements of this list followed by the elements of [data].
  ///
  /// The [data] argument specifies the list to concatenate with this list.
  ///
  /// Example:
  /// ```dart
  /// List<int> numbers1 = [1, 2, 3];
  /// List<int> numbers2 = [4, 5, 6];
  /// List<int> concatenatedNumbers = numbers1 + numbers2;
  /// print(concatenatedNumbers); // Output: [1, 2, 3, 4, 5, 6]
  /// ```
  ///
  /// Returns:
  /// A new list that contains the elements of this list followed by the elements of [data].
  List<T> operator +(List<T> data) => [...this, ...data];
}

extension ListExt<T> on List<T>? {
  /// convert List to List of widget
  List<Widget> toWidgetList(Widget Function(T value) map) =>
      isBlank ? [] : [...this!.map(map)];

  /// Remove all occurrences of [item] from the list.
  void removeAll(T item) {
    if (isBlank) return;

    while (this!.contains(item)) {
      this!.remove(item);
    }
  }

  List<T> separatorEvery(T separator, {bool start = false, bool end = false}) {
    final List<T> list = <T>[];

    if (isBlank) return list;

    /// First item Top separator
    if (start) list.add(separator);

    for (int n = 0; n < (this?.length ?? 0); n++) {
      if (end) {
        list.addAll([this![n], separator]);
        continue;
      }

      if (!end && (n == ((this?.length ?? 1) - 1))) {
        list.add(this![n]);
      }
    }

    return list;
  }

  List<List<T>> divideListByFunction(bool Function(T) condition) {
    final List<List<T>> nestedLists = [];
    final List<T> currentSublist = [];

    if (isBlank) return [];

    for (final T element in this ?? []) {
      if (condition(element)) {
        // Start a new sublist when the condition is met.
        if (currentSublist.isNotEmpty) {
          nestedLists.add(List<T>.from(currentSublist));
          currentSublist.clear();
        }
      } else {
        // Add the element to the current sublist.
        currentSublist.add(element);
      }
    }

    // Add the last sublist if it's not empty.
    if (currentSublist.isNotEmpty) {
      nestedLists.add(List<T>.from(currentSublist));
    }

    return nestedLists;
  }

  List<List<T>>? divideListByRange(int rangeSize) {
    if (this == null) return null;

    if (rangeSize <= 0) {
      throw ArgumentError('Range size must be greater than zero.');
    }

    final List<List<T>> nestedLists = [];

    for (int i = 0; i < this!.length; i += rangeSize) {
      final endIndex =
          (i + rangeSize < this!.length) ? i + rangeSize : this!.length;
      nestedLists.add(this!.sublist(i, endIndex));
    }

    return nestedLists;
  }
}

/// Supercharged extensions on [Iterable] like [List] and [Set].
extension IterableSC<T> on Iterable<T> {
  /// Returns the minimal value based on the [comparator] function.
  /// If collection is empty this returns `null`.
  ///
  /// Example:
  /// ```dart
  /// [1, 0, 2].minBy((a, b) => a.compareTo(b));       // 0
  /// persons.minBy((a, b) => a.age.compareTo(b.age)); // the youngest person
  /// ```
  T? minBy(Comparator<T> comparator) {
    if (isBlank) return null;

    return reduce(
      (value, element) => comparator(value, element) < 0 ? value : element,
    );
  }

  /// Returns the maximum value based on the [comparator] function.
  /// If collection is empty this returns `null`.
  ///
  /// Example:
  /// ```dart
  /// [90, 10, 20, 30].maxBy((a, b) => a.compareTo(b)); // 90
  /// persons.maxBy((a, b) => a.age.compareTo(b.age));  // the oldest person
  /// ```
  T? maxBy(Comparator<T> comparator) {
    if (isBlank) return null;

    return reduce(
      (value, element) => comparator(value, element) > 0 ? value : element,
    );
  }

  /// Lazily returns all values without the first one.
  ///
  /// Example:
  /// ```dart
  /// [1, 2, 3].withoutFirst(); // [2, 3]
  /// [].withoutFirst(); // [];
  /// ```
  Iterable<T> withoutFirst() sync* {
    final iter = iterator..moveNext();

    while (iter.moveNext()) {
      yield iter.current;
    }
  }

  /// Lazily returns all values without the last one.
  ///
  /// Example:
  /// ```dart
  /// [1, 2, 3].withoutLast(); // [1, 2]
  /// [].withoutLast(); // [];
  /// ```
  Iterable<T> withoutLast() sync* {
    final iter = iterator;

    final hasFirst = iter.moveNext();

    if (!hasFirst) return;

    while (true) {
      final value = iter.current;
      final isLastOne = !iter.moveNext();
      if (!isLastOne) {
        yield value;
      } else {
        break;
      }
    }
  }

  /// Replaces every element that matches the [comparator] with [replacement].
  ///
  /// Example:
  /// ```dart
  /// [1, 2, 3].replaceWhere((n) => n < 3, 0); // [0, 0, 3]
  /// ```
  Iterable<T> replaceWhere(Selector<T> comparator, T replacement) sync* {
    final it = iterator;

    while (it.moveNext()) {
      if (comparator(it.current)) {
        yield replacement;
      } else {
        yield it.current;
      }
    }
  }

  /// Replaces the first element that matches the [comparator] with [replacement].
  ///
  /// Example:
  /// ```dart
  /// [1, 2, 3].replaceFirstWhere((n) => n < 3, 0); // [0, 2, 3]
  /// ```
  Iterable<T> replaceFirstWhere(Selector<T> comparator, T replacement) sync* {
    final it = iterator;
    while (it.moveNext()) {
      if (comparator(it.current)) {
        yield replacement;
        while (it.moveNext()) {
          yield it.current;
        }
      } else {
        yield it.current;
      }
    }
  }

  /// Replaces an item in the list with [replacement] where [comparator] returns
  /// true. Returns true if an item is replaced, false otherwise.
  Iterable<T> replaceLastWhere(Selector<T> comparator, T replacement) sync* {
    final it = iterator;
    var found = false;

    while (it.moveNext()) {
      if (comparator(it.current) && !found) {
        yield replacement;
        found = true;
      } else {
        yield it.current;
      }
    }
  }
}

extension ListUtils<T> on List<T> {
  /// Merge the list with [List] [other].
  /// Returns a new list with all elements of the list and [other].
  List<T> mergeWith(List<T> other, {bool unique = false, IsEqual<T>? compare}) {
    final list = <T>[...this];

    if (unique) {
      for (final item in other) {
        if (compare != null) {
          if (!list.any((e) => compare(e, item))) list.add(item);
        } else if (!list.contains(item)) {
          list.add(item);
        }
      }
    } else {
      list.addAll(other);
    }
    return list;
  }

  /// Convert the list to a [Map] with [key] and [value] functions.
  /// Returns a new [Map] with the keys and values returned by [key] and [value].
  Map<K, V> toMap<K, V>(Transformer<T, K> key, Transformer<T, V> value) => {
    for (final e in this) key(e): value(e),
  };

  /// Remove null or empty elements from the list.
  /// Returns a new list with null or empty elements removed.
  List<T> compact() {
    final list = <T>[];
    for (final item in this) {
      if (item == null) {
        continue;
      } else if (item is String) {
        if (item.isNotEmpty) list.add(item);
      } else if (item is Iterable) {
        if (item.isNotEmpty) list.add(item);
      } else if (item is Map) {
        if (item.isNotEmpty) list.add(item);
      } else {
        list.add(item);
      }
    }
    return list;
  }

  /// Clear and add all elements of [List] [other] to the list.
  void clearAndAddAll(List<T> other) {
    if (isEmpty && other.isEmpty) return;
    clear();
    addAll(other);
  }

  /// Sort the list by [selector].
  /// Returns a new list sorted by [selector].
  List<T> sortedByAscending(dynamic Function(T) selector) {
    final list = <T>[...this]..sort((a, b) {
      final valueA = selector(a);
      final valueB = selector(b);
      if (valueA == null) {
        if (valueB == null) {
          return 0;
        } else {
          return 1;
        }
      } else if (valueB == null) {
        return -1;
      } else if (valueA is num) {
        return valueA.compareTo(valueB as num);
      } else if (valueA is String) {
        return valueA.compareTo(valueB as String);
      } else if (valueA is bool) {
        return valueA == valueB ? 0 : (valueA ? 1 : -1);
      } else if (valueA is DateTime) {
        return valueA.compareTo(valueB as DateTime);
      } else if (valueA is Comparable) {
        return valueA.compareTo(valueB);
      } else {
        return 0;
      }
    });
    return list;
  }

  // Sort the list by [f] descending.
  /// Returns a new list sorted by [selector] descending.
  List<T> sortedByDescending(dynamic Function(T) selector) {
    final list = <T>[...this]..sort((a, b) {
      final valueA = selector(a);
      final valueB = selector(b);
      if (valueA == null) {
        if (valueB == null) {
          return 0;
        } else {
          return -1;
        }
      } else if (valueB == null) {
        return 1;
      } else if (valueA is num) {
        return valueA.compareTo(valueB as num);
      } else if (valueA is String) {
        return valueA.compareTo(valueB as String);
      } else if (valueA is bool) {
        return valueA == valueB ? 0 : (valueA ? -1 : 1);
      } else if (valueA is DateTime) {
        return valueA.compareTo(valueB as DateTime);
      } else if (valueA is Comparable) {
        return valueA.compareTo(valueB);
      } else {
        return 0;
      }
    });
    return list;
  }

  /// Join to [String] with [separator], [prefix] and [suffix], and [transform] function.
  /// Returns a [String] with the elements joined by [separator], [prefix] and [suffix], and transformed by [transform].
  /// If [transform] is `null`, the elements are converted to [String] with `toString()`.
  String joinBy(
    String separator, {
    String prefix = '',
    String suffix = '',
    Transformer<T, String>? transform,
  }) {
    final buffer = StringBuffer()..write(prefix);

    for (var i = 0; i < length; i++) {
      if (i > 0) buffer.write(separator);
      buffer.write(transform == null ? this[i].toString() : transform(this[i]));
    }

    buffer.write(suffix);
    return buffer.toString();
  }

  /// Take while [selector] is true.
  /// Returns a new list with the elements taken while [selector] is true.
  List<T> takeWhile(Selector<T> selector) {
    final list = <T>[];
    for (final item in this) {
      if (selector(item)) {
        list.add(item);
      } else {
        break;
      }
    }
    return list;
  }

  /// Take if [selector] is true.
  ///  Returns a new list with the elements taken if [selector] is true.

  List<T> takeIf(Selector<T> selector) {
    final list = <T>[];
    for (final item in this) {
      if (selector(item)) {
        list.add(item);
      }
    }
    return list;
  }
}

/// Extension methods for any [List].
extension ListExtensions1<T> on List<T> {
  // Transformation

  // Transformation - List
  /// Copy current list with adding [element] at the end of new list.
  ///
  /// If current list is `null` - new list with [element] will be created.
  List<T> copyWith(T element) => List.from(this)..add(element);

  /// Copy current list with adding all [elements] at the end of new list.
  ///
  /// If current list is `null` - copy of list [elements] will be created.
  List<T> copyWithAll(List<T> elements) => List.from(this)..addAll(elements);

  /// Copy current list, replacing all [element] occurrences with [replacement].
  ///
  /// If [element] is not in the list than just copy will be returned.
  /// If current list is `null` - returns new empty list.
  List<T> copyWithReplace(T element, T replacement) => [
    for (final e in this) e == element ? replacement : e,
  ];

  /// Copy current list with adding all [elements] at the position of new list.
  ///
  /// Error thrown due to a value being outside a valid range.
  List<T> copyWithInsertAll(int index, List<T> elements) =>
      List.from(this)..insertAll(index, elements);

  /// Copy current list, replacing elements of list that
  /// satisfy [test] predicate with [replacement].
  ///
  /// If no elements that satisfy [test] predicate found
  /// than just copy will be returned.
  /// If current list is `null` - returns new empty list.
  List<T> copyWithReplaceWhere(Selector<T> test, T replacement) => [
    for (final e in this) test(e) ? replacement : e,
  ];

  /// Replaces all elements of list that satisfy [test] predicate
  /// with [replacement].
  ///
  /// Returns `true` if at least one element was replaced.
  /// If no elements that satisfy [test] predicate found than will be no changes.
  bool replaceWhere(Selector<T> test, T replacement) {
    var found = false;
    final len = length;

    for (var i = 0; i < len; i++) {
      if (test(this[i])) {
        this[i] = replacement;
        found = true;
      }
    }

    return found;
  }

  /// Adds [value] to the end of this list
  /// only if it's not null.
  ///
  /// The list must be growable.
  bool addIfNotNull(T? value) {
    if (value != null) {
      add(value);
      return true;
    } else {
      return false;
    }
  }
}

extension NullableListExtensions<E> on List<E>? {
  /// Copy current list with adding [element] at the end of new list.
  ///
  /// If current list is `null` - new list with [element] will be created.
  List<E> copyWith(E element) => this?.copyWith(element) ?? [element];

  /// Copy current list with adding all [elements] at the end of new list.
  ///
  /// If current list is `null` - copy of list [elements] will be created.
  List<E> copyWithAll(List<E> elements) =>
      this?.copyWithAll(elements) ?? List.from(elements);

  /// Copy current list with adding all [elements] at the position of new list.
  ///
  /// If current list is `null` - copy of list [elements] will be created.
  /// Error thrown due to a value being outside a valid range.
  List<E> copyWithInsertAll(int index, List<E> elements) =>
      this?.copyWithInsertAll(index, elements) ?? List.from(elements);

  /// Copy current list, replacing all [element] occurrences with [replacement].
  ///
  /// If [element] is not in the list than just copy will be returned.
  /// If current list is `null` - returns new empty list.
  List<E> copyWithReplace(E element, E replacement) =>
      this?.copyWithReplace(element, replacement) ?? const [];

  /// Copy current list, replacing elements of list that
  /// satisfy [test] predicate with [replacement].
  ///
  /// If no elements that satisfy [test] predicate found
  /// than just copy will be returned.
  /// If current list is `null` - returns new empty list.
  List<E> copyWithReplaceWhere(Selector<E> test, E replacement) =>
      this?.copyWithReplaceWhere(test, replacement) ?? const [];
}

extension FicIterableExtension<T> on Iterable<T> {
  /// Restricts some item to one of those present in this iterable.
  ///
  /// Returns the [item] itself, if it's present in this iterable. Otherwise,
  /// return [orElse]. For example:
  ///
  /// ```
  /// var primes = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31];
  /// primes.restrict(14, orElse: -1); // Returns -1.
  /// primes.restrict(7, orElse: -1); // Returns 7.
  /// ```
  ///
  T restrict(T? item, {required T orElse}) =>
      contains(item) ? item as T : orElse;

  /// Finds duplicates and then returns a [Set] with the duplicated elements.
  /// If there are no duplicates, an empty [Set] is returned.
  Set<T> findDuplicates() {
    final Set<T> duplicates = <T>{};
    final Set<T> auxSet = HashSet<T>();
    for (final T element in this) {
      if (!auxSet.add(element)) duplicates.add(element);
    }
    return duplicates;
  }

  /// Removes all duplicates, leaving only the distinct items.
  /// Optionally, you can provide an [by] function to compare the items.
  ///
  /// If you pass [removeNulls] as true, it will also remove the nulls
  /// (it will check the item is null, before applying the [by] function).
  ///
  /// Note: This is different from `List.distinct()` because `removeDuplicates`
  /// is lazy (and you can use it with any Iterable, not just a List).
  /// For example, it can be much more efficient when you are doing some extra
  /// processing. Suppose you have a list with a million items, and you want
  /// to remove duplicates and get the first 5:
  ///
  /// // This will process 5 items:
  /// var newList = list.removeDuplicates().take(5).toList();
  ///
  /// // This will process a million items:
  /// var newList = list.distinct().sublist(0, 5);
  ///
  ///
  Iterable<T> whereNoDuplicates({
    dynamic Function(T item)? by,
    bool removeNulls = false,
  }) sync* {
    if (by != null) {
      final Set<dynamic> ids = <dynamic>{};
      for (final T item in this) {
        if (removeNulls && item == null) continue;
        final dynamic id = by(item);
        if (!ids.contains(id)) yield item;
        ids.add(id);
      }
    } else {
      final Set<T> items = {};
      for (final T item in this) {
        if (removeNulls && item == null) continue;
        if (!items.contains(item)) yield item;
        items.add(item);
      }
    }
  }

  /// Returns a new list where [newItems] are added or updated, by their [id]
  /// (and the [id] is a function of the item), like so:
  ///
  /// 1) Items with the same [id] will be replaced, in place.
  /// 2) Items with new [id]s will be added go to the end of the list.
  ///
  /// Note: If the original iterable contains more than one item with the
  /// same [id] as some item in [newItems], the first will be replaced, and
  /// the others will be left untouched. If [newItems] contains more than
  /// one item with the same [id], the last one will be used, and the
  /// previous discarded.
  ///
  List<T> updateById(Iterable<T> newItems, dynamic Function(T item) id) {
    final List<T> newList = [];

    final Map<dynamic, T> idsPerNewItem = <dynamic, T>{
      for (final T item in newItems) id(item): item,
    };

    // Replace those with the same id.
    for (final T item in this) {
      final itemId = id(item);

      if (idsPerNewItem.containsKey(itemId)) {
        final T newItem = idsPerNewItem[itemId] as T;
        newList.add(newItem);
        idsPerNewItem.remove(itemId);
      } else {
        newList.add(item);
      }
    }

    // Add the new ones at the end.
    newList.addAll(idsPerNewItem.values);
    return newList;
  }
}

extension IterableMinus<T> on Iterable<T> {
  /// Returns a new list containing all elements of this collection except the
  /// elements contained in the given [elements] collection.
  List<T> operator -(Iterable<T> elements) => except(elements).toList();

  /// Returns a new lazy [Iterable] containing all elements of this collection
  /// except the given [element].
  Iterable<T> exceptElement(T element) sync* {
    for (final current in this) {
      if (element != current) yield current;
    }
  }

  /// Returns a new lazy [Iterable] containing all elements of this collection
  /// and then all elements of the given [elements] collection.
  Iterable<T> prepend(Iterable<T> elements) sync* {
    yield* elements;
    yield* this;
  }

  /// Returns a new lazy [Iterable] containing all elements of this collection
  /// and then the given [element].
  Iterable<T> prependElement(T element) sync* {
    yield element;
    yield* this;
  }

  /// Returns a new lazy [Iterable] containing all elements of the given
  /// [elements] collection and then all elements of this collection.
  Iterable<T> append(Iterable<T> elements) sync* {
    yield* this;
    yield* elements;
  }

  /// Returns a new list containing all elements of the given [elements]
  /// collection and then all elements of this collection.
  List<T> operator +(Iterable<T> elements) => append(elements).toList();

  /// Returns a new lazy [Iterable] containing the given [element] and then all
  /// elements of this collection.
  Iterable<T> appendElement(T element) sync* {
    yield* this;
    yield element;
  }

  /// Returns a new lazy [Iterable] containing all distinct elements from
  /// both collections.
  ///
  /// The returned set preserves the element iteration order of this collection.
  /// Those elements of the [other] collection that are unique are iterated in
  /// the end in the order of the [other] collection.
  Iterable<T> union(Iterable<T> other) sync* {
    final existing = HashSet<T>();
    for (final element in this) {
      if (existing.add(element)) yield element;
    }

    for (final element in other) {
      if (existing.add(element)) yield element;
    }
  }

  /// Returns a new lazy [Iterable] of values built from the elements of this
  /// collection and the [other] collection with the same index.
  ///
  /// Using the provided [transform] function applied to each pair of elements.
  /// The returned list has length of the shortest collection.
  ///
  /// Example (with added type definitions for [transform] parameters):
  ///
  /// ```dart
  ///final amounts = [2, 3, 4];
  ///final animals = ['dogs', 'birds', 'cats'];
  ///final all = amounts.zip(
  ///  animals,
  ///  (int amount, String animal) => '$amount $animal'
  ///);  // returns: ['2 dogs', '3 birds', '4 cats']
  /// ```
  Iterable<V> zip<R, V>(
    Iterable<R> other,
    V Function(T a, R b) transform,
  ) sync* {
    final it1 = iterator;
    final it2 = other.iterator;
    while (it1.moveNext() && it2.moveNext()) {
      yield transform(it1.current, it2.current);
    }
  }

  /// Returns a new lazy [Iterable] with all elements of this collection.
  Iterable<T> toIterable() sync* {
    yield* this;
  }

  /// Returns a new [Stream] with all elements of this collection.
  Stream<T> asStream() => Stream.fromIterable(this);

  /// Returns a new [HashSet] with all distinct elements of this collection.
  HashSet<T> toHashSet() => HashSet.from(this);

  /// Returns a Map containing key-value pairs provided by [transform] function
  /// applied to elements of this collection.
  ///
  /// If any of two pairs would have the same key the last one gets added to the
  /// map.
  Map<K, V> associate<K, V>(MapEntry<K, V> Function(T element) transform) {
    final map = <K, V>{};
    for (final element in this) {
      final entry = transform(element);
      map[entry.key] = entry.value;
    }
    return map;
  }

  /// Returns a Map containing the elements from the collection indexed by
  /// the key returned from [keySelector] function applied to each element.
  ///
  /// If any two elements would have the same key returned by [keySelector] the
  /// last one gets added to the map.
  Map<K, T> associateBy<K>(K Function(T element) keySelector) {
    final map = <K, T>{};
    for (final current in this) {
      map[keySelector(current)] = current;
    }
    return map;
  }

  /// Returns a Map containing the values returned from [valueSelector] function
  /// applied to each element indexed by the elements from the collection.
  ///
  /// If any of elements (-> keys) would be the same the last one gets added
  /// to the map.
  Map<T, V> associateWith<V>(V Function(T element) valueSelector) {
    final map = <T, V>{};
    for (final current in this) {
      map[current] = valueSelector(current);
    }
    return map;
  }

  /// Splits the collection into two lists according to [predicate].
  ///
  /// The first list contains elements for which [predicate] yielded true,
  /// while the second list contains elements for which [predicate] yielded
  /// false.
  List<List<T>> partition(bool Function(T element) predicate) {
    final t = <T>[];
    final f = <T>[];
    for (final element in this) {
      if (predicate(element)) {
        t.add(element);
      } else {
        f.add(element);
      }
    }
    return [t, f];
  }
}

/// Combines iterables [a] and [b] into one, by applying the [combine] function.
/// If [allowDifferentSizes] is true, it will stop as soon as one of the
/// iterables has no more values. If [allowDifferentSizes] is false, it will
/// throw an error if the iterables have different length.
///
/// See also: [IterableZip]
///
Iterable<R> combineIterables<A, B, R>(
  Iterable<A> a,
  Iterable<B> b,
  R Function(A, B) combine, {
  bool allowDifferentSizes = false,
}) sync* {
  final Iterator<A> iterA = a.iterator;
  final Iterator<B> iterB = b.iterator;

  while (iterA.moveNext()) {
    if (!iterB.moveNext()) {
      if (allowDifferentSizes) {
        return;
      } else {
        throw StateError("Can't combine iterables of different sizes (a > b).");
      }
    }
    yield combine(iterA.current, iterB.current);
  }

  if (iterB.moveNext() && !allowDifferentSizes) {
    throw StateError("Can't combine iterables of different sizes (a < b).");
  }
}
