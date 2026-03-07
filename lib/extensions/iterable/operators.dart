import 'dart:collection';

import 'package:flutter/material.dart';

import '../../index.dart';

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

  /// Returns a new list containing all elements of the given [elements]
  /// collection and then all elements of this collection.
  List<T> operator +(Iterable<T> elements) => append(elements).toList();

  /// Returns a new list containing all elements of this collection except the
  /// elements contained in the given [elements] collection.
  List<T> operator -(Iterable<T> elements) => except(elements).toList();
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
    if (isBlank) return <T>[];

    final source = this!;
    final out = <T>[];

    if (start) out.add(separator);

    for (var i = 0; i < source.length; i++) {
      out.add(source[i]);

      final isLast = i == source.length - 1;
      if (!isLast || end) {
        out.add(separator);
      }
    }

    return out;
  }

  List<List<T>> divideListByFunction(Predicate<T> condition) {
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
  Iterable<T> replaceWhere(Predicate<T> comparator, T replacement) sync* {
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
  Iterable<T> replaceFirstWhere(Predicate<T> comparator, T replacement) sync* {
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
  Iterable<T> replaceLastWhere(Predicate<T> comparator, T replacement) sync* {
    final list = toList();
    final index = list.lastIndexWhere(comparator);
    if (index == -1) {
      yield* list;
      return;
    }

    list[index] = replacement;
    yield* list;
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
    if (isBlank && other.isBlank) return;
    clear();
    addAll(other);
  }

  /// Sort the list by [selector].
  /// Returns a new list sorted by [selector].
  List<T> sortByAscending(dynamic Function(T) selector) {
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
  List<T> sortByDescending(dynamic Function(T) selector) =>
      sortByAscending(selector).reversed.toList();

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
  List<T> takeWhile(Predicate<T> selector) {
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

  List<T> takeIf(Predicate<T> selector) {
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
  List<T> copyWithReplaceWhere(Predicate<T> test, T replacement) => [
    for (final e in this) test(e) ? replacement : e,
  ];

  /// Replaces all elements of list that satisfy [test] predicate
  /// with [replacement].
  ///
  /// Returns `true` if at least one element was replaced.
  /// If no elements that satisfy [test] predicate found than will be no changes.
  bool replaceWhere(Predicate<T> test, T replacement) {
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

extension FicIterableExtension<T> on Iterable<T> {
  /// Restricts some item to one of those present in this iterable.
  ///
  /// Returns the [item] itself, if it's present in this iterable. Otherwise,
  /// return [orElse]. For example:
  ///
  /// ```dart
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
  /// ```dart
  /// // This will process 5 items:
  /// var newList = list.removeDuplicates().take(5).toList();
  ///
  /// // This will process a million items:
  /// var newList = list.distinct().sublist(0, 5);
  /// ```
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

  /// Returns a new lazy [Iterable] with all elements of this collection.
  Iterable<T> toIterable() sync* {
    yield* this;
  }

  /// Returns a new [Stream] with all elements of this collection.
  Stream<T> asStream() => Stream.fromIterable(this);

  /// Returns a new [HashSet] with all distinct elements of this collection.
  HashSet<T> toHashSet() => HashSet.from(this);

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
