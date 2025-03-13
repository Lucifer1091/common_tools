import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../common_tools.dart';
import 'index.dart';

T Function(T, T) _generateCustomMaxFunction<T>(Comparator<T> compare) {
  T max(T a, T b) {
    if (compare(a, b) >= 0) return a;
    return b;
  }

  return max;
}

T Function(T, T) _generateCustomMinFunction<T>(Comparator<T> compare) {
  T min(T a, T b) {
    if (compare(a, b) <= 0) return a;
    return b;
  }

  return min;
}

Map<E, int> _elementCountsIn<E>(Iterable<E> iterable) {
  final counts = <E, int>{};
  for (final element in iterable) {
    final currentCount = counts[element] ?? 0;
    counts[element] = currentCount + 1;
  }
  return counts;
}

/// List extensions.
extension GenericListExtensions<E> on Iterable<E> {
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
  List<E> operator *(int data) {
    final List<E> result = [];
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
  List<E> operator +(List<E> data) => [...this, ...data];
}

extension IterableOptionalExt<T> on Iterable<T?> {
  T? get random {
    if (isNotNullOrEmpty) return null;

    final random = math.Random();
    final int index = random.nextInt(this!.length);
    return this?.elementAtOrNull(index);
  }

  /// Extract one random item from the list
  T random() => toList()[math.Random().nextInt(length)];

  /// Returns a new list the the non-null items.
  ///
  /// Same as `where((el) => el != null)`
  List<T> removeNull() {
    final list = <T>[];
    for (final element in this) {
      if (element != null) list.add(element);
    }
    return list;
  }

  T? firstWhereOrNull(bool Function(T element) comparator) {
    if (isNotNullOrEmpty) return null;

    try {
      return this!.firstWhere(comparator);
    } on StateError catch (_) {
      return null;
    }
  }

  /// The first element satisfying [test], or `null` if there are none.
  T? firstWhereOrNull(bool Function(T element) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }

  /// Returns the last element matching the given [test], or null if element was not found.
  ///  ["Flutter", "Dart", "Java", "IOS", "Android","web"].lastOrNullIf((it) => it.length == 9); // null
  ///  ["Flutter", "Dart", "Java", "IOS", "Android","web"].lastOrNullIf((it) => it.length == 3); // IOS
  T? firstWhereOrNull(bool Function(T element) test) {
    if (isNullOrEmpty) {
      return null;
    }
    final list = this!.where(test);
    return list.isEmpty ? null : list.first;
  }

  /// Returns the last element matching the given [test], or null if element was not found.
  ///  ["Flutter", "Dart", "Java", "IOS", "Android","web"].lastOrNullIf((it) => it.length == 9); // null
  ///  ["Flutter", "Dart", "Java", "IOS", "Android","web"].lastOrNullIf((it) => it.length == 3); // web
  T? lastWhereOrNull(bool Function(T element) test) {
    if (isNullOrEmpty) {
      return null;
    }
    final list = this!.where(test);
    return list.isEmpty ? null : list.last;
  }

//remove first element in [list]
  List<T> get removeFirstElement {
    final List<T> list = [];
    if (isNullOrEmpty) return list;
    final thisList = this!.toList();
    return thisList..removeAt(0);
  }

  //remove Last element in [list]
  List<T> get removeLastElement {
    final List<T> list = [];
    if (isNullOrEmpty) return list;
    final thisList = this!.toList();
    return thisList..removeAt(thisList.length - 1);
  }

  // Returns count of elements that matches the given [predicate].
  int countWhere(bool Function(T element) predicate) {
    if (isNullOrEmpty) return 0;
    return this!.where(predicate).length;
  }

  // Returns a list containing first [n] elements.
  List<T> take(int n) {
    if (this == null) return <T>[];
    if (n <= 0) return [];

    final list = <T>[];
    if (this is Iterable) {
      if (n >= this!.length) return this!.toList();

      var count = 0;
      final thisList = this!.toList();
      for (final item in thisList) {
        list.add(item);
        if (++count == n) break;
      }
    }
    return list;
  }

  /// Returns a list containing only elements matching the given [test]
  Iterable<T> filterOrNewList(bool Function(T e) test) {
    if (isNullOrEmpty) {
      return [];
    }
    final result = <T>[];
    for (final element in this!) {
      if (test(element)) result.add(element);
    }
    return result;
  }

  /// Returns a list containing only elements matching the given [predicate]
  // void filter(bool Function(T e) fun) {
  //   if (isNullOrEmpty) {
  //     return;
  //   }
  //   final result = <T>[];
  //   for (var element in this!) {
  //     if (fun(element)) this?.remove(element);
  //   }
  // }

  /// Returns a list containing all elements not matching the given [test]
  Iterable<T> filterNot(bool Function(T element) test) {
    if (isNullOrEmpty) {
      return [];
    }
    final result = <T>[];
    for (final element in this!) {
      if (!test(element)) result.add(element);
    }
    return result;
  }
}

extension ListExt<T> on List<T>? {
  /// convert List to List of widget
  List<Widget> toWidgetList(Widget Function(T value) mapFunc) =>
      isNullOrEmpty ? [] : [...this!.map(mapFunc)];

  int? get lastIndex => isNullOrEmpty ? this!.length - 1 : null;

  /// Remove all occurrences of [item] from the list.
  void removeAll(T item) {
    if (isNullOrEmpty) return;

    while (this!.contains(item)) {
      this!.remove(item);
    }
  }

  /// Counts the elements for which the [test] holds.
  ///
  /// See [where].
  int countWhere(bool Function(T) test) {
    if (isNullOrEmpty) return 0;
    return this!.where(test).length;
  }

  /// For each method with provides not only the element but the index as well.
  ///
  /// See [forEach].
  void forEachIndexed(void Function(int index, T element) f) {
    if (isNullOrEmpty) return;
    for (var i = 0; i < this!.length; i++) {
      f(i, this![i]);
    }
  }

  /// Return a random element of the list.
  T? random({int? seed}) {
    if (isNullOrEmpty) return null;
    return this![math.Random(seed).nextInt(this!.length)];
  }

  List<T> separatorEvery(T separator, {bool start = false, bool end = false}) {
    final List<T> list = <T>[];
    if (isNullOrEmpty) return list;

    ///First item Top separator
    if (start) {
      list.add(separator);
    }
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
    if (isNullOrEmpty) return [];

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
    if (this == null) {
      return null;
    }
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

// Iterable Extensions
extension ListExtensions<T> on Iterable<T>? {
  /// Validate given List is not null and returns blank list if null.
  /// This should not be used to clear list
  List<T> validate() {
    if (this == null) {
      return [];
    } else {
      return this!.toList();
    }
  }

  /// Generate forEach but gives index for each element
  void forEachIndexed(void Function(T element, int index) action) {
    var index = 0;
    for (final element in this!) {
      action(element!, index++);
    }
  }

  /// Example:
  /// ```dart
  /// [1, 3, 7].sumBy((n) => n);                 // 11
  /// ['hello', 'world'].sumBy((s) => s.length); // 10
  /// ```
  int sumBy(int Function(T) selector) =>
      this.validate().map(selector).fold(0, (prev, curr) => prev + curr);

  /// Example:
  /// ```dart
  /// [1.5, 2.5].sumByDouble((d) => 0.5 * d); // 2.0
  /// ```
  double sumByDouble(num Function(T) selector) =>
      this.validate().map(selector).fold(0, (prev, curr) => prev + curr);

  /// Example:
  /// ```dart
  /// [1, 2, 3].averageBy((n) => n);               // 2.0
  /// ['cat', 'horse'].averageBy((s) => s.length); // 4.0
  /// ```
  double? averageBy(num Function(T) selector) {
    if (this.validate().isEmpty) {
      return null;
    }

    return sumByDouble(selector) / this!.length;
  }
}

/// Supercharged extensions on [Iterable<int>] like [List<int>] and [Set<int>].
extension IterableOfIntSC on Iterable<int> {
  /// Deprecation hint: Read the
  /// [migration guide](https://github.com/felixblaschke/supercharged/blob/master/migration_v2.md)
  /// for more details on migrating.
  ///
  /// Returns the sum of all elements.
  ///
  /// Example:
  /// ```dart
  /// [2, 6, 4, 8].sum(); // 20
  /// ```
  @Deprecated(
    'Dart natively supports this function. Read DartDoc comment for more info.',
  )
  int sumSC() => sumBy((n) => n);

  /// Deprecation hint: Read the
  /// [migration guide](https://github.com/felixblaschke/supercharged/blob/master/migration_v2.md)
  /// for more details on migrating.
  ///
  /// Returns the average value (arithmetic mean) of all elements.
  /// If collection is empty this returns `null`.
  ///
  /// Example:
  /// ```dart
  /// [2, 4, 6, 8].average(); // 5.0
  /// ```
  @Deprecated(
    'Dart natively supports this function. Read DartDoc comment for more info.',
  )
  double? averageSC() => averageBy((n) => n);

  /// Returns the largest value of all elements
  /// If collection is empty this returns `null`.
  ///
  /// Example:
  /// ```dart
  /// [9, 42, 3].max(); // 42
  /// ```
  int? max() => maxBy((a, b) => a.compareTo(b));

  /// Returns the lowest value of all elements
  /// If collection is empty this returns `null`.
  ///
  /// Example:
  /// ```dart
  /// [17, 13, 92].min(); // 13
  /// ```
  int? min() => minBy((a, b) => a.compareTo(b));
}

/// Supercharged extensions on [Iterable] like [List] and [Set].
extension IterableSC<T> on Iterable<T> {
  /// Returns the sum of all values produced by the [selector] function that is
  /// applied to each element.
  ///
  /// Example:
  /// ```dart
  /// [2, 4, 6].sumBy((n) => n);                   // 12
  /// ['hello', 'flutter'].sumBy((s) => s.length); // 12
  /// ```
  int sumBy(int Function(T) selector) =>
      map(selector).fold(0, (prev, curr) => prev + curr);

  /// Returns the sum of all values produced by the [selector] function that is
  /// applied to each element.
  ///
  /// Example:
  /// ```dart
  /// [1.5, 2.5].sumByDouble((d) => 0.5 * d); // 2.0
  /// ```
  double sumByDouble(num Function(T) selector) =>
      map(selector).fold(0, (prev, curr) => prev + curr);

  /// Returns the average value (arithmetic mean) of all values produces by the
  /// [selector] function that is applied to each element.
  ///
  ///
  /// Example:
  /// ```dart
  /// [1, 2, 3].averageBy((n) => n);               // 2.0
  /// ['cat', 'horse'].averageBy((s) => s.length); // 4.0
  /// ```
  double? averageBy(num Function(T) selector) {
    if (isEmpty) {
      return null;
    }

    return sumByDouble(selector) / length;
  }

  /// Splits the elements into lists of the specified [size].
  ///
  /// You can specify an optional [fill] function that produces values
  /// that fill up the last chunk to match the chunk size.
  ///
  /// Example:
  /// ```dart
  /// [1, 2, 3, 4, 5, 6].chunked(2);        // [[1, 2], [3, 4], [5, 6]]
  /// [1, 2, 3].chunked(2);                 // [[1, 2], [3]]
  /// [1, 2, 3].chunked(2, fill: () => 99); // [[1, 2], [3, 99]]
  /// ```
  Iterable<List<T>> chunked(int size, {T Function()? fill}) {
    if (size <= 0) {
      throw ArgumentError('chunkSize must be positive integer greater than 0.');
    }

    if (isEmpty) {
      return const Iterable.empty();
    }

    final countOfChunks = (length / size.toDouble()).ceil();

    return Iterable.generate(countOfChunks, (int index) {
      final chunk = skip(index * size).take(size).toList();

      if (fill != null) {
        while (chunk.length < size) {
          chunk.add(fill());
        }
      }

      return chunk;
    });
  }

  /// Returns the number of elements that matches the [test].
  ///
  /// If no [test] is specified it will count every element.
  ///
  /// Example:
  /// ```dart
  /// [1, 2, 3, 13, 14, 15].count();             // 6
  /// [1, 2, 3, 13, 14, 15].count((n) => n > 9); // 3
  /// ```
  int count([Selector<T>? test]) => test == null ? length : where(test).length;

  /// Returns a new [Iterable] with all elements that satisfy the
  /// predicate [test].
  ///
  /// Example:
  /// ```dart
  /// [1, 2, 3, 4].filter((n) => n < 3).toList(); // [1,2]
  /// ```
  ///
  /// This method is an alias for [where].
  Iterable<T> filter(bool Function(T element) test) => where(test);

  /// Returns the [index]th element. If the index is out of bounds the [orElse]
  /// supplier function is called to provide a value.
  ///
  /// Example:
  /// ```dart
  /// ['a', 'b'].elementAtOrElse(2, () => ''); // ''
  /// ```
  T elementAtOrElse(int index, T Function() orElse) {
    try {
      return elementAt(index);
    } catch (_) {
      return orElse();
    }
  }

  /// Deprecation hint: Read the
  /// [migration guide](https://github.com/felixblaschke/supercharged/blob/master/migration_v2.md)
  /// for more details on migrating.
  ///
  /// Returns the [index]th element.
  /// If the index is out of bounds it will return `null`.
  ///
  /// Example:
  /// ```dart
  /// ['a', 'b'].elementAtOrNull(2); // null
  /// ```
  T? elementAtOrNull(int index) {
    try {
      return elementAt(index);
    } catch (error) {
      return null;
    }
  }

  /// Returns the first element. If there is no first element the [orElse]
  /// supplier function is called to provide a value.
  ///
  /// Example:
  /// ```dart
  /// ['a', 'b'].firstOrElse(() => ''); // 'a'
  /// [].firstOrElse(() => '');         // ''
  /// ```
  T firstOrElse(T Function() orElse) => firstWhere((_) => true, orElse: orElse);

  /// Deprecation hint: Read the
  /// [migration guide](https://github.com/felixblaschke/supercharged/blob/master/migration_v2.md)
  /// for more details on migrating.
  ///
  /// Returns the first element.
  /// If there is no first element it will return `null`.
  ///
  /// Example:
  /// ```dart
  /// ['a', 'b'].firstOrNull(); // 'a'
  /// [].firstOrNull();         // null
  /// ```
  @Deprecated(
    'Dart natively supports this function. Read DartDoc comment for more info.',
  )
  T? firstOrNullSC() {
    if (isEmpty) {
      return null;
    }

    return firstWhere((_) => true, orElse: null);
  }

  /// Returns the last element. If there is no last element the [orElse]
  /// supplier function is called to provide a value.
  ///
  /// Example:
  /// ```dart
  /// ['a', 'b'].lastOrElse(() => ''); // 'a'
  /// [].lastOrElse(() => '');         // ''
  /// ```
  T lastOrElse(T Function() orElse) => lastWhere((_) => true, orElse: orElse);

  /// Deprecation hint: Read the
  /// [migration guide](https://github.com/felixblaschke/supercharged/blob/master/migration_v2.md)
  /// for more details on migrating.
  ///
  /// Returns the last element.
  /// If there is no last element it will return `null`.
  ///
  /// Example:
  /// ```dart
  /// ['a', 'b'].lastOrElse(); // 'a'
  /// [].lastOrElse();         // null
  /// ```
  @Deprecated(
    'Dart natively supports this function. Read DartDoc comment for more info.',
  )
  T? lastOrNullSC() {
    if (isEmpty) {
      return null;
    }

    return lastWhere((_) => true, orElse: null);
  }

  /// Groups the elements of the list into a map by a key
  /// that is defined by a [keySelector] function.
  ///
  /// The optional [valueTransform] function can be used to
  /// remap your elements.
  ///
  /// Example:
  /// ```dart
  /// var map = [1, 2, 3, 97, 98, 99].groupBy((n) => n < 10 ? 'smallNumbers' : 'largeNumbers')
  /// // map = {'smallNumbers': [1, 2, 3], 'largeNumbers': [97, 98, 99]}
  /// ```
  ///
  /// ```dart
  /// List<Person> persons = [
  ///     Person(name: 'John', age: 21),
  ///     Person(name: 'Carl', age: 18),
  ///     Person(name: 'Peter', age: 56),
  ///     Person(name: 'Sarah', age: 61)
  /// ];
  /// var map = persons.groupBy((p) => p.age < 40 ? 'young' : 'old',
  ///        valueTransform: (p) => p.name);
  /// // map = {'young': ['John', 'Carl'], 'old': ['Peter', 'Sarah']}
  /// ```
  Map<K, List<V>> groupBy<K, V>(
    K Function(T element) keySelector, {
    V Function(T element)? valueTransform,
  }) {
    final transformFn = valueTransform ?? (element) => element as V;

    final map = <K, List<V>>{};

    forEach((element) {
      final key = keySelector(element);

      if (!map.containsKey(key)) {
        map[key] = [];
      }
      map[key]!.add(transformFn(element));
    });

    return map;
  }

  /// Returns a map that contains [MapEntry]s provided by a [transform] function.
  ///
  /// If two elements share the same key, the last one gets added to the map.
  ///
  /// Example:
  /// ```dart
  /// [1, 2, 3].associate((e) => MapEntry('key_$e', e * 100)); // {'key_1': 100, 'key_2': 200, 'key_3': 300}
  /// ```
  Map<K, V> associate<K, V>(MapEntry<K, V> Function(T element) transform) =>
      Map.fromEntries(map(transform));

  /// Returns a map where every element is associated by a key produced from
  /// the [keySelector] function.
  ///
  /// If two elements share the same key, the last one gets added to the map.
  ///
  /// Example:
  /// ```dart
  /// ['a', 'ab', 'abc'].associateBy((e) => e.length); // {1: 'a', 2: 'ab', 3: 'abc'}
  /// ```
  Map<K, T> associateBy<K>(K Function(T element) keySelector) {
    final map = <K, T>{};
    forEach((element) {
      final key = keySelector(element);
      map[key] = element;
    });
    return map;
  }

  /// Returns a map where every element is used as a key that is associated
  /// with a value produced by the [valueSelector] function.
  ///
  /// Example:
  /// ```dart
  /// [1, 2, 3].associateWith((e) => e * 1000); // {1: 1000, 2: 2000, 3: 3000}
  /// ```
  Map<T, V> associateWith<V>(V Function(T element) valueSelector) {
    final map = <T, V>{};
    forEach((element) {
      map[element] = valueSelector(element);
    });
    return map;
  }

  /// Returns the minimal value based on the [comparator] function.
  /// If collection is empty this returns `null`.
  ///
  /// Example:
  /// ```dart
  /// [1, 0, 2].minBy((a, b) => a.compareTo(b));       // 0
  /// persons.minBy((a, b) => a.age.compareTo(b.age)); // the youngest person
  /// ```
  T? minBy(Comparator<T> comparator) {
    if (isEmpty) {
      return null;
    }
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
    if (isEmpty) {
      return null;
    }
    return reduce(
      (value, element) => comparator(value, element) > 0 ? value : element,
    );
  }

  /// Deprecation hint: Read the
  /// [migration guide](https://github.com/felixblaschke/supercharged/blob/master/migration_v2.md)
  /// for more details on migrating.
  ///
  /// Returns this as sorted list using the [comparator] function.
  ///
  /// Example:
  /// ```dart
  /// [3, 1, 5, 9, 7].sortedBy((a,b) => a.compareTo(b)); // [1, 3, 5, 7, 9]
  /// ```
  @Deprecated(
    'Dart natively supports this function. Read DartDoc comment for more info.',
  )
  List<T> sortedBySC(Comparator<T> comparator) => toList()..sort(comparator);

  /// Deprecation hint: Read the
  /// [migration guide](https://github.com/felixblaschke/supercharged/blob/master/migration_v2.md)
  /// for more details on migrating.
  ///
  /// Returns this as sorted list using the [valueProvider] function that produces
  /// numerical values as base for sorting.
  ///
  /// Example:
  /// ```dart
  /// [2, 1, 3].sortedByNum((n) => n); // [1, 2, 3]
  /// persons.sortedByNum((p) => p.age).reversed; // oldest persons first
  /// ```
  @Deprecated(
    'Dart natively supports this function. Read DartDoc comment for more info.',
  )
  List<T> sortedByNumSC(num Function(T element) valueProvider) =>
      sortedBySC((a, b) => valueProvider(a).compareTo(valueProvider(b)));

  /// Deprecation hint: Read the
  /// [migration guide](https://github.com/felixblaschke/supercharged/blob/master/migration_v2.md)
  /// for more details on migrating.
  ///
  /// Returns this as sorted list using the [valueProvider] function that produces
  /// character values as base for sorting.
  ///
  /// Example:
  /// ```dart
  /// ['c', 'b', 'a'].sortedByNum((c) => c); // ['a', 'b', 'c']
  /// persons.sortedByString((p) => p.name); // sort persons alphabetically
  /// ```
  @Deprecated(
    'Dart natively supports this function. Read DartDoc comment for more info.',
  )
  List<T> sortedByStringSC(String Function(T element) valueProvider) =>
      sortedBySC((a, b) => valueProvider(a).compareTo(valueProvider(b)));

  /// Returns the last accessible index.
  /// If collection is empty this returns `null`.
  ///
  /// Example:
  /// ```dart
  /// var list = ['a', 'b', 'c'];
  /// list.lastIndex; // 2
  /// list[list.lastIndex]; // 'c'
  /// ```
  int? get lastIndex {
    if (isNotEmpty) {
      return length - 1;
    } else {
      return null;
    }
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

    if (!hasFirst) {
      return;
    }

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

  /// Replaces every element that matches the [comparator] with [newValue].
  ///
  /// Example:
  /// ```dart
  /// [1, 2, 3].replaceWhere((n) => n < 3, 0); // [0, 0, 3]
  /// ```
  Iterable<T> replaceWhere(
    bool Function(T currentValue) comparator,
    T newValue,
  ) sync* {
    final it = iterator;
    while (it.moveNext()) {
      if (comparator(it.current)) {
        yield newValue;
      } else {
        yield it.current;
      }
    }
  }

  /// Replaces the first element that matches the [comparator] with [newValue].
  ///
  /// Example:
  /// ```dart
  /// [1, 2, 3].replaceFirstWhere((n) => n < 3, 0); // [0, 2, 3]
  /// ```
  Iterable<T> replaceFirstWhere(
    bool Function(T currentValue) comparator,
    T newValue,
  ) sync* {
    final it = iterator;
    while (it.moveNext()) {
      if (comparator(it.current)) {
        yield newValue;
        while (it.moveNext()) {
          yield it.current;
        }
      } else {
        yield it.current;
      }
    }
  }

  /// Applies the given [action] on each element and also returns the
  /// whole [Iterable] without modifying it.
  ///
  /// Example:
  /// ```dart
  /// var sum = [1, 2, 3].onEach(print).sum(); // sum = 6 (also prints each number)
  /// ```
  Iterable<T> onEach(void Function(T element) action) sync* {
    final it = iterator;
    while (it.moveNext()) {
      action(it.current);
      yield it.current;
    }
  }

  /// Applies the given [action] on each element and also returns the
  /// whole [Iterable] without modifying it. The [action] takes a second
  /// parameter index matching the element index.
  ///
  /// Example:
  /// ```dart
  /// var sum = [1, 2, 3].onEach(print).sum(); // sum = 6 (also prints each number)
  /// ```
  Iterable<T> onEachIndexed(void Function(T element, int index) action) sync* {
    final it = iterator;
    var index = 0;
    while (it.moveNext()) {
      action(it.current, index++);
      yield it.current;
    }
  }

  /// Returns a random item.
  /// The randomness can be customized by setting [random].
  ///
  /// Example:
  /// ```dart
  /// [1, 2, 3].pickOne(); // 2 (or 1 or 3)
  /// ```
  T pickOne([Random? random]) {
    final list = toList()..shuffle(random);
    return list.first;
  }

  /// Returns an [List] of [count] random items.
  /// The randomness can be customized by setting [random].
  ///
  /// Example:
  /// ```dart
  /// [1, 2, 3].pickSome(2); // [1, 2] or [3, 2] and so on...
  /// ```
  List<T> pickSome(int count, [Random? random]) {
    final list = toList()..shuffle(random);
    return list.take(min(count, length)).toList();
  }
}

extension ListUtils<T> on List<T> {
  /// Remove the first occurrence of [item] from the list.
  void removeFirst(T item) {
    final index = indexOf(item);
    if (index == -1) return;
    removeAt(index);
  }

  /// Remove the last occurrence of [item] from the list.
  void removeLast(T item) {
    final index = lastIndexOf(item);
    if (index == -1) return;
    removeAt(index);
  }

  /// Remove all occurrences of [item] from the list.
  void removeAll(T item) {
    while (contains(item)) {
      remove(item);
    }
  }

  /// Remove all occurrences of [List] [items] from the list.
  void removeAllList(List<T> items) => items.forEach(removeAll);

  /// Remove all occurrences of [Set] [items] from the list.
  void removeAllSet(Set<T> items) => items.forEach(removeAll);

  /// Remove all occurrences of [Iterable] [items] from the list.
  void removeAllIterable(Iterable<T> items) => items.forEach(removeAll);

  /// Remove all occurrences of [Map] [items] keys from the list.
  void removeAllMapKeys(Map<T, dynamic> items) => items.keys.forEach(removeAll);

  /// Remove all occurrences of [Map] [items] values from the list.
  void removeAllMapValues(Map<T, dynamic> items) {
    for (final item in items.values) {
      removeAll(item as T);
    }
  }

  /// Remove first [n] occurrences of [item] from the list.
  ///  If [n] is negative, remove from end of list.
  void removeN(T item, int n) {
    if (n == 0) return;
    if (n > 0) {
      for (var i = 0; i < n; i++) {
        removeFirst(item);
      }
    } else {
      for (var i = 0; i < -n; i++) {
        removeLast(item);
      }
    }
  }

  /// Remove first [n] occurrences of [List] [items] from the list.
  ///  If [n] is negative, remove from end of list.
  void removeNList(List<T> items, int n) {
    if (n == 0) return;
    if (n > 0) {
      for (var i = 0; i < n; i++) {
        removeAllList(items);
      }
    } else {
      for (var i = 0; i < -n; i++) {
        removeAllList(items.reversed.toList());
      }
    }
  }

  /// Get the first occurrence of [item] from the list.
  /// Returns `null` if the item was not found.
  T? getFirst(T item) {
    final index = indexOf(item);
    if (index == -1) return null;
    return this[index];
  }

  /// Get the last occurrence of [item] from the list.
  /// Returns `null` if the item was not found.
  T? getLast(T item) {
    final index = lastIndexOf(item);
    if (index == -1) return null;
    return this[index];
  }

  /// Sum by [f] of all elements in the list.
  /// Returns `0` if the list is empty and [f] returns `null`.
  num sumBy(num Function(T) f) {
    num sum = 0;
    for (final item in this) {
      final value = f(item);
      sum += value;
    }
    return sum;
  }

  /// Split the list into chunks of size [n].
  /// Returns a list of chunks.
  List<List<T>> chunk(int n) {
    final chunks = <List<T>>[];
    for (var i = 0; i < length; i += n) {
      chunks.add(sublist(i, i + n));
    }
    return chunks;
  }

  /// Check if the list contains all elements of [List] [items].
  /// Returns `true` if the list contains all elements of [items], `false` otherwise.
  bool containsAllList(List<T> items) {
    for (final item in items) {
      if (!contains(item)) return false;
    }
    return true;
  }

  /// Merge the list with [List] [items].
  /// Returns a new list with all elements of the list and [items].
  List<T> mergeList(List<T> items, {bool unique = false}) {
    final list = <T>[...this];

    if (unique) {
      for (final item in items) {
        if (!list.contains(item)) list.add(item);
      }
    } else {
      list.addAll(items);
    }
    return list;
  }

  /// Convert the list to a [Map] with [key] and [value] functions.
  /// Returns a new [Map] with the keys and values returned by [key] and [value].
  Map<K, V> toMap<K, V>(K Function(T) key, V Function(T) value) {
    final map = <K, V>{};
    for (final item in this) {
      map[key(item)] = value(item);
    }
    return map;
  }

  /// Distinct the list by [f].
  /// Returns a new list with distinct elements based on [f].
  List<T> distinctBy(dynamic Function(T) f) {
    final list = <T>[];
    for (final item in this) {
      if (!list.any((e) => f(e) == f(item))) list.add(item);
    }
    return list;
  }

  /// Remove null or empty elements from the list.
  /// Returns a new list with null or empty elements removed.
  List<T> compact() {
    final list = <T>[];
    for (final item in this) {
      if (item == null) {
        continue;
      } else if (item is String) {
        if (item.isNotEmpty) {
          list.add(item);
        }
      } else if (item is Iterable) {
        if (item.isNotEmpty) {
          list.add(item);
        }
      } else if (item is Map) {
        if (item.isNotEmpty) {
          list.add(item);
        }
      } else {
        list.add(item);
      }
    }
    return list;
  }

  /// Clear and add all elements of [List] [items] to the list.
  void clearAndAddAll(List<T> items) {
    if (isEmpty && items.isEmpty) return;
    clear();
    addAll(items);
  }

  /// Sort the list by [f].
  /// Returns a new list sorted by [f].
  List<T> sortedBy(dynamic Function(T) f) {
    final list = <T>[...this]..sort((a, b) {
        final valueA = f(a);
        final valueB = f(b);
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
  /// Returns a new list sorted by [f] descending.
  List<T> sortedByDescending(dynamic Function(T) f) {
    final list = <T>[...this]..sort((a, b) {
        final valueA = f(a);
        final valueB = f(b);
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

  /// Group the list by [f].
  /// Returns a [Map] with the keys and values returned by [f].
  Map<K, List<T>> groupBy<K>(K Function(T) f) {
    final map = <K, List<T>>{};
    for (final item in this) {
      final key = f(item);
      if (map.containsKey(key)) {
        map[key]!.add(item);
      } else {
        map[key] = [item];
      }
    }
    return map;
  }

  /// Join to [String] with [separator], [prefix] and [suffix], and [transform] function.
  /// Returns a [String] with the elements joined by [separator], [prefix] and [suffix], and transformed by [transform].
  /// If [transform] is `null`, the elements are converted to [String] with `toString()`.
  String joinToString(
    String separator, {
    String prefix = '',
    String suffix = '',
    String Function(T)? transform,
  }) {
    final buffer = StringBuffer()..write(prefix);
    for (var i = 0; i < length; i++) {
      if (i > 0) buffer.write(separator);
      buffer.write(transform == null ? this[i].toString() : transform(this[i]));
    }
    buffer.write(suffix);
    return buffer.toString();
  }

  /// Take while [f] is true.
  /// Returns a new list with the elements taken while [f] is true.

  List<T> takeWhile(bool Function(T) f) {
    final list = <T>[];
    for (final item in this) {
      if (f(item)) {
        list.add(item);
      } else {
        break;
      }
    }
    return list;
  }

  /// Take if [f] is true.
  ///  Returns a new list with the elements taken if [f] is true.

  List<T> takeIf(bool Function(T) f) {
    final list = <T>[];
    for (final item in this) {
      if (f(item)) {
        list.add(item);
      }
    }
    return list;
  }
}

/// Extension methods for any [Iterable].
extension IterableExtensions1<E> on Iterable<E> {
  // Common

  /// Returns count of elements that satisfy the predicate [test].
  int countWhere(TestPredicate<E> test) =>
      fold(0, (count, e) => test(e) ? count + 1 : count);

  /// Returns `true` if the collection contains all elements from the [elements].
  ///
  /// Order of elements does not matter.
  ///
  /// See [contains].
  bool containsAll(Iterable<E> elements) {
    for (final e in elements) {
      if (!contains(e)) return false;
    }

    return true;
  }

  // Common - Equality

  // /// Check equality of the elements of this and [other] iterables
  // /// without considering order.
  // ///
  // /// Return `true` if two iterable have the same number of elements,
  // /// and the elements of this iterable can be paired with the elements of
  // /// the other iterable, so that each pair are equal.
  // bool isUnorderedEquivalent(Iterable<E> other) =>
  //     _getUnorderedEquality<E>().equals(this, other);

  // Common - Search

  /// Return the first element that satisfies the given predicate [test]
  /// or `null` if no element satisfies.
  ///
  /// See [Iterable.firstWhere].
  E? firstWhereOrNull(TestPredicate<E> test) {
    for (final element in this) {
      if (test(element)) return element;
    }

    return null;
  }

  // Common - Safe elements access

  /// Returns the first element or `null` if `this` is empty.
  E? get firstOrNull => isEmpty ? null : first;

  /// Returns the element at the [index] if exists
  /// or [orElse] if it is out of range.
  E? tryElementAt(int index, {E? orElse}) {
    try {
      return elementAt(index);
    } catch (e) {
      return orElse;
    }
  }

  // Transformation

  /// Reduces values of elements in a collection
  /// to a single value by iteratively combining its
  /// using the provided function.
  ///
  /// The iterable must have at least one element.
  /// If it has only one element, that element is returned.
  T reduceValue<T>(
    T Function(T value, T elementVal) combine,
    GetValue<E, T> getVal,
  ) {
    final iterator = this.iterator;
    if (!iterator.moveNext()) {
      throw StateError('No element');
    }

    var value = getVal(iterator.current);
    while (iterator.moveNext()) {
      value = combine(value, getVal(iterator.current));
    }

    return value;
  }

  // Transformation - Iterables

  // /// Splits into chunks of the specified size.
  // ///
  // /// Example:
  // /// ```
  // /// final res = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].chunks(3);
  // /// ```
  // /// Result:
  // /// ```
  // /// [[1, 2, 3], [4, 5, 6], [7, 8, 9], [10]]
  // /// ```
  // Iterable<List<E>> chunks(int size) => partition(this, size);
  //
  // /// Adds [element] between elements of the iterable.
  // ///
  // /// Example: if we have `[1, 2, 3]` and adds `0`, then as a result
  // /// we will have `[1, 0, 2, 0, 3]`.
  // ///
  // /// If iterable is empty then returns empty iterable.
  // ///
  // /// If iterable have only one element then
  // /// returns iterable with only one element.
  // Iterable<E> intersperse(E element) =>
  //     isEmpty ? [] : IntersperseIterable(this, element);
  //
  // /// Create a new iterable by passing each element and index to the callback.
  // ///
  // /// Example: if we have `['a', 'b', 'c']`, then the callback is called
  // /// with ('a', 0), ('b', 1), then ('c', 2).
  // ///
  // /// Returns a new lazy iterable with elements that are created by
  // /// calling `toElement` on each element of this `Iterable` in
  // /// iteration order with a generated index.
  // ///
  // /// See [Iterable.map] for caveats about the lazy iterable.
  // Iterable<T> mapIndex<T>(MapIndexedValue<E, T> toElement) =>
  //     enumerate(this).map((e) => toElement(e.value, e.index));

  // Transformation - String

  /// Get string value for each element and concatenates it with [separator].
  ///
  /// [getVal] used to get string value for element. It can be value of some
  /// field, or custom stringify function.
  String joinOf(GetValue<E, String> getVal, [String separator = '']) =>
      fold('', (res, e) => res != '' ? res + separator + getVal(e) : getVal(e));

  // Transformation - Map

  /// Creates a Map instance from the iterable.
  ///
  /// [getKey] used to get key for result Map.
  /// [getVal] used to get value for result Map.
  Map<TKey, TVal> toMap<TKey, TVal>(
    GetValue<E, TKey> getKey,
    GetValue<E, TVal> getVal,
  ) =>
      {for (final e in this) getKey(e): getVal(e)};

  // Math

  /// Returns sum of int values by elements.
  ///
  /// [getVal] should return value for sum up. It can be property of element,
  /// or any another value by element.
  int sumOf(GetValue<E, int> getVal) => fold(0, (sum, e) => sum + getVal(e));

  /// Returns sum of double values by elements.
  ///
  /// [getVal] should return value for sum up. It can be property of element,
  /// or any another value by element.
  double sumOfDouble(GetValue<E, double> getVal) =>
      fold(0, (sum, e) => sum + getVal(e));

  /// Returns the average value of int values by elements.
  ///
  /// [getVal] should return value for calculate average.
  /// It can be property of element, or any another value by element.
  ///
  /// If no elements, return `0`.
  double avgOf(GetValue<E, int> getVal) {
    final count = length;
    return count > 0 ? sumOf(getVal) / count : 0;
  }

  /// Returns the average value of double values by elements.
  ///
  /// [getVal] should return value for calculate average.
  /// It can be property of element, or any another value by element.
  ///
  /// If no elements, return `0`.
  double avgOfDouble(GetValue<E, double> getVal) {
    final count = length;
    return count > 0 ? sumOfDouble(getVal) / count : 0;
  }

  /// Returns the max value of int or double values by elements.
  ///
  /// [getVal] should return value for compare.
  /// It can be property of element, or any another value by element.
  ///
  /// If no elements, return zero.
  T maxOf<T extends num>(GetValue<E, T> getVal) =>
      isEmpty ? _zero() : reduceValue(math.max, getVal);

  /// Returns the min value of int or double values by elements.
  ///
  /// [getVal] should return value for compare.
  /// It can be property of element, or any another value by element.
  ///
  /// If no elements, return zero.
  T minOf<T extends num>(GetValue<E, T> getVal) =>
      isEmpty ? _zero() : reduceValue(math.min, getVal);
}

/// Extension methods for [Iterable] of int.
extension IntIterableExtensions on Iterable<int> {
  // Math

  /// Returns sum of values.
  int sum() => fold(0, (sum, v) => sum + v);

  /// Returns the average value of values.
  double avg() => isNotEmpty ? sum() / length : 0;
}

/// Extension methods for [Iterable] of double.
extension DoubleIterableExtensions on Iterable<double> {
  // Math

  /// Returns sum of values.
  double sum() => fold(0, (sum, v) => sum + v);

  /// Returns the average value of values.
  double avg() => isNotEmpty ? sum() / length : 0;
}

extension IterableExtension<E> on Iterable<E> {
  BigInt sumOfBigInt(GetValue<E, BigInt> getVal) =>
      fold(BigInt.zero, (sum, e) => sum + getVal(e));
}

/// Extension methods for any [List].
extension ListExtensions1<E> on List<E> {
  // Common

  // Common - Get

  /// Returns a random element from the list.
  ///
  /// Throws a [StateError] if `this` is empty.
  E get random {
    if (isEmpty) {
      throw StateError('No element');
    }

    final rnd = Random();
    return this[rnd.nextInt(length)];
  }

  // Transformation

  // Transformation - List
  /// Copy current list with adding [element] at the end of new list.
  ///
  /// If current list is `null` - new list with [element] will be created.
  List<E> copyWith(E element) => List.from(this)..add(element);

  /// Copy current list with adding all [elements] at the end of new list.
  ///
  /// If current list is `null` - copy of list [elements] will be created.
  List<E> copyWithAll(List<E> elements) => List.from(this)..addAll(elements);

  /// Copy current list, replacing all [element] occurrences with [replacement].
  ///
  /// If [element] is not in the list than just copy will be returned.
  /// If current list is `null` - returns new empty list.
  List<E> copyWithReplace(E element, E replacement) =>
      [for (final e in this) e == element ? replacement : e];

  /// Copy current list with adding all [elements] at the position of new list.
  ///
  /// Error thrown due to a value being outside a valid range.
  List<E> copyWithInsertAll(int index, List<E> elements) =>
      List.from(this)..insertAll(index, elements);

  /// Copy current list, replacing elements of list that
  /// satisfy [test] predicate with [replacement].
  ///
  /// If no elements that satisfy [test] predicate found
  /// than just copy will be returned.
  /// If current list is `null` - returns new empty list.
  List<E> copyWithReplaceWhere(TestPredicate<E> test, E replacement) =>
      [for (final e in this) test(e) ? replacement : e];

  // Modification

  // Modification - Element

  /// Replaces all [element] occurrences with [replacement].
  ///
  /// Returns `true` if element was replaced.
  /// If [element] is not in the list than will be no changes.
  /// If there are multiple [element] in list - all will be replaced.
  bool replace(E element, E replacement) {
    var found = false;
    final len = length;
    for (var i = 0; i < len; i++) {
      if (element == this[i]) {
        this[i] = replacement;
        found = true;
      }
    }

    return found;
  }

  /// Replaces all elements of list that satisfy [test] predicate
  /// with [replacement].
  ///
  /// Returns `true` if at least one element was replaced.
  /// If no elements that satisfy [test] predicate found than will be no changes.
  bool replaceWhere(TestPredicate<E> test, E replacement) {
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
  bool addIfNotNull(E? value) {
    if (value != null) {
      add(value);
      return true;
    } else {
      return false;
    }
  }

  // Modification - Sorting

  /// Sorts the list in ascending order of the object's field value.
  void sortBy(Comparable<E> Function(E e) getVal) =>
      sort((a, b) => getVal(a).compareTo(getVal(b) as E));

  /// Sorts the list in descending order of the object's field value.
  void sortByDescending(Comparable<E> Function(E e) getVal) =>
      sort((a, b) => getVal(b).compareTo(getVal(a) as E));
}

extension NullableListExtensions<E> on List<E>? {
  // Transformation

  // Transformation - List

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
  List<E> copyWithReplaceWhere(TestPredicate<E> test, E replacement) =>
      this?.copyWithReplaceWhere(test, replacement) ?? const [];
}

/// Utility extension methods for the native [Iterable] class.
extension IterableBasics<E> on Iterable<E> {
  /// Alias for [Iterable]`.every`.
  bool all(bool Function(E) test) => every(test);

  /// Returns `true` if no element of [this] satisfies [test].
  ///
  /// Example:
  /// ```dart
  /// [1, 2, 3].none((e) => e > 4); // true
  /// [1, 2, 3].none((e) => e > 2); // false
  /// ```
  bool none(bool Function(E) test) => !any(test);

  /// Returns `true` if there is exactly one element of [this] which satisfies
  /// [test].
  ///
  /// Example:
  /// ```dart
  /// [1, 2, 3].one((e) => e == 2); // 1 element satisfies. Returns true.
  /// [1, 2, 3].one((e) => e > 4); // No element satisfies. Returns false.
  /// [1, 2, 3].one((e) => e > 1); // >1 element satisfies. Returns false.
  /// ```
  bool one(bool Function(E) test) {
    bool foundOne = false;
    for (var e in this) {
      if (test(e)) {
        if (foundOne) return false;
        foundOne = true;
      }
    }
    return foundOne;
  }

  /// Returns `true` if [this] contains at least one element also contained in
  /// [other].
  ///
  /// Example:
  /// ```dart
  /// [1, 2, 3].containsAny([5, 2]); // true
  /// [1, 2, 3].containsAny([4, 5, 6]); // false
  /// ```
  bool containsAny(Iterable<E> other) => any(other.contains);

  /// Returns true if every element in [other] also exists in [this].
  ///
  /// Example:
  /// ```dart
  /// [1, 2, 3].containsAll([1, 2]); // true
  /// [1, 2].containsAll([1, 2, 3]); // false
  /// ```
  ///
  /// If [collapseDuplicates] is true, only the presence of a value will be
  /// considered, not the number of times it occurs. If [collapseDuplicates] is
  /// false, the number of occurrences of a given value in [this] must be
  /// greater than or equal to the number of occurrences of that value in
  /// [other] for the result to be true.
  ///
  /// Example:
  /// ```
  /// [1, 2, 3].containsAll([1, 1, 1, 2]); // true
  /// [1, 2, 3].containsAll([1, 1, 1, 2], collapseDuplicates: false); // false
  /// [1, 1, 2, 3].containsAll([1, 1, 2], collapseDuplicates: false); // true
  /// ```
  bool containsAll(Iterable<E> other, {bool collapseDuplicates = true}) {
    if (other.isEmpty) return true;
    if (collapseDuplicates) {
      return Set<E>.from(this).containsAll(Set<E>.from(other));
    }

    final thisElementCounts = _elementCountsIn<E>(this);
    final otherElementCounts = _elementCountsIn<E>(other);

    for (final element in otherElementCounts.keys) {
      final countInThis = thisElementCounts[element] ?? 0;
      final countInOther = otherElementCounts[element] ?? 0;
      if (countInThis < countInOther) {
        return false;
      }
    }
    return true;
  }

  /// Returns the greatest element of [this] as ordered by [compare], or [null]
  /// if [this] is empty.
  ///
  /// Example:
  /// ```dart
  /// ['a', 'aaa', 'aa']
  ///   .max((a, b) => a.length.compareTo(b.length)).value; // 'aaa'
  /// ```
  E? max(Comparator<E> compare) =>
      isEmpty ? null : reduce(_generateCustomMaxFunction<E>(compare));

  /// Returns the smallest element of [this] as ordered by [compare], or [null]
  /// if [this] is empty.
  ///
  /// Example:
  /// ```dart
  /// ['a', 'aaa', 'aa']
  ///   .min((a, b) => a.length.compareTo(b.length)).value; // 'a'
  /// ```
  E? min(Comparator<E> compare) =>
      isEmpty ? null : reduce(_generateCustomMinFunction<E>(compare));

  /// Returns the element of [this] with the greatest value for [sortKey], or
  /// [null] if [this] is empty.
  ///
  /// This method is guaranteed to calculate [sortKey] only once for each
  /// element.
  ///
  /// Example:
  /// ```dart
  /// ['a', 'aaa', 'aa'].maxBy((e) => e.length).value; // 'aaa'
  /// ```
  E? maxBy(Comparable<dynamic> Function(E) sortKey) {
    final sortKeyCache = <E, Comparable<dynamic>>{};
    return this.max((a, b) => sortKeyCompare<E>(a, b, sortKey, sortKeyCache));
  }

  /// Returns the element of [this] with the least value for [sortKey], or
  /// [null] if [this] is empty.
  ///
  /// This method is guaranteed to calculate [sortKey] only once for each
  /// element.
  ///
  /// Example:
  /// ```dart
  /// ['a', 'aaa', 'aa'].minBy((e) => e.length).value; // 'a'
  /// ```
  E? minBy(Comparable<dynamic> Function(E) sortKey) {
    final sortKeyCache = <E, Comparable<dynamic>>{};
    return this.min((a, b) => sortKeyCompare<E>(a, b, sortKey, sortKeyCache));
  }

  /// Returns the sum of all the values in this iterable, as defined by
  /// [addend].
  ///
  /// Returns 0 if [this] is empty.
  ///
  /// Example:
  /// ```dart
  /// ['a', 'aa', 'aaa'].sum((s) => s.length); // 6
  /// ```
  num sum(num Function(E) addend) =>
      isEmpty ? 0 : fold(0, (prev, element) => prev + addend(element));

  /// Returns the average of all the values in this iterable, as defined by
  /// [value].
  ///
  /// Returns null if [this] is empty.
  ///
  /// Example:
  /// ```dart
  /// ['a', 'aa', 'aaa'].average((s) => s.length); // 2
  /// [].average(); // null
  /// ```
  num? average(num Function(E) value) {
    if (isEmpty) return null;

    return this.sum(value) / length;
  }

  /// Returns a random element of [this], or [null] if [this] is empty.
  ///
  /// If [seed] is provided, will be used as the random seed for determining
  /// which element to select. (See [math.Random].)
  E? getRandom({int? seed}) =>
      isEmpty ? null : elementAt(math.Random(seed).nextInt(length));

  /// Returns an [Iterable] containing the first [end] elements of [this],
  /// excluding the first [start] elements.
  ///
  /// This method is a generalization of [List.getRange] to [Iterable]s,
  /// and obeys the same contract.
  ///
  /// Example:
  /// ```dart
  /// {3, 8, 12, 4, 1}.range(2, 4); // [12, 4]
  /// ```
  Iterable<E> getRange(int start, int end) {
    RangeError.checkValidRange(start, end, length);
    return skip(start).take(end - start);
  }
}

/// Utility extension methods for [Iterable]s containing [num]s.
extension NumIterableBasics<E extends num> on Iterable<E> {
  /// Returns the greatest number in [this], or [null] if [this] is empty.
  ///
  /// Example:
  /// ```dart
  /// [104, 3, 18].max().value; // 104
  /// ```
  ///
  /// If [compare] is provided, it will be used to order the elements.
  ///
  /// Example:
  /// ```dart
  /// [-47, 10, 2].max((a, b) =>
  ///     a.toString().length.compareTo(b.toString().length)).value; // -47
  /// ```
  E? max([Comparator<E>? compare]) => isEmpty
      ? null
      : reduce(
          compare == null ? math.max : _generateCustomMaxFunction<E>(compare));

  /// Returns the least number in [this], or [null] if [this] is empty.
  ///
  /// Example:
  /// ```dart
  /// [104, 3, 18].min().value; // 3
  /// ```
  ///
  /// If [compare] is provided, it will be used to order the elements.
  ///
  /// Example:
  /// ```dart
  /// [-100, -200, 5].min((a, b) =>
  ///     a.toString().length.compareTo(b.toString().length)).value; // 5
  /// ```
  E? min([Comparator<E>? compare]) => isEmpty
      ? null
      : reduce(
          compare == null ? math.min : _generateCustomMinFunction<E>(compare));

  /// Returns the sum of all the values in this iterable.
  ///
  /// If [addend] is provided, it will be used to compute the value to be
  /// summed.
  ///
  /// Returns 0 if [this] is empty.
  ///
  /// Example:
  /// ```dart
  /// [1, 2, 3].sum(); // 6.
  /// [2, 3, 4].sum((i) => i * 0.5); // 4.5.
  /// [].sum() // 0.
  /// ```
  num sum([num Function(E)? addend]) {
    if (isEmpty) return 0;
    return addend == null
        ? reduce((a, b) => (a + b) as E)
        : fold(0, (prev, element) => prev + addend(element));
  }

  /// Returns the average of all the values in this iterable.
  ///
  /// If [value] is provided, it will be used to compute the value to be
  /// averaged.
  ///
  /// Returns null if [this] is empty.
  ///
  /// Example:
  /// ```dart
  /// [2, 2, 4, 8].average(); // 4.
  /// [2, 2, 4, 8].average((i) => i + 1); // 5.
  /// [].average() // null.
  /// ```
  num? average([num Function(E)? value]) {
    if (isEmpty) return null;

    return this.sum(value) / length;
  }
}

/// Utility extension methods for the native [List] class.
extension ListBasics<E> on List<E> {
  /// Returns a sorted copy of this list.
  List<E> sortedCopy() {
    return List<E>.of(this)..sort();
  }

  /// Sorts this list by the value returned by [sortKey] for each element.
  ///
  /// This method is guaranteed to calculate [sortKey] only once for each
  /// element.
  ///
  /// Example:
  /// ```dart
  /// var list = [-12, 3, 10];
  /// list.sortBy((e) => e.toString().length); // list is now [3, 10, -12].
  /// ```
  void sortBy(Comparable<dynamic> Function(E) sortKey) {
    final sortKeyCache = <E, Comparable<dynamic>>{};
    this.sort((a, b) => sortKeyCompare(a, b, sortKey, sortKeyCache));
  }

  /// Returns a copy of this list sorted by the value returned by [sortKey] for
  /// each element.
  ///
  /// This method is guaranteed to calculate [sortKey] only once for each
  /// element.
  ///
  /// Example:
  /// ```dart
  /// var list = [-12, 3, 10];
  /// var sorted = list.sortedCopyBy((e) => e.toString().length);
  /// // list is still [-12, 3, 10]. sorted is [3, 10, -12].
  /// ```
  List<E> sortedCopyBy(Comparable<dynamic> Function(E) sortKey) {
    return List<E>.of(this)..sortBy(sortKey);
  }

  /// Removes a random element of [this] and returns it.
  ///
  /// Returns [null] if [this] is empty.
  ///
  /// If [seed] is provided, will be used as the random seed for determining
  /// which element to select. (See [math.Random].)
  E? takeRandom({int? seed}) => this.isEmpty
      ? null
      : this.removeAt(math.Random(seed).nextInt(this.length));
}

/// list `readableX`
extension RNumList on Iterable<num> {
  ///  how many elements == zero
  int countZeros() => countValue(0);

  /// * return list summation
  /// * return `null` if list is empty
  num? sumOrNull() => isEmpty ? null : fold(0, (a, b) => a! + b);

  /// * return list summation
  /// * return `value` if list is empty
  num sumOr(num value) => sumOrNull() ?? value;

  /// * return list summation
  /// * return `0` if  isEmpty
  num sumOrZero() => sumOrNull() ?? 0;

  /// * return list summation
  /// ! throws `StateError` if isEmpty
  num sum() => sumOrNull() ?? (throw StateError('list is empty'));

  /// * return the average of the list
  /// * return `null` if isEmpty
  num? averageOrNull() => isEmpty ? null : (sum() / length);

  /// * return list average
  /// * return `value` if isEmpty
  num averageOr(num value) => averageOrNull() ?? value;

  /// * return the average of the list
  /// * return `0` if  isEmpty
  num averageOrZero() => averageOr(0);

  /// * return list average
  /// ! throws `StateError` if isEmpty
  num average() => averageOrNull() ?? (throw StateError('list is empty'));

  /// * return the maximum value in the list
  /// * return `null` if isEmpty
  num? maxOrNull() {
    if (isEmpty) return null;
    num max = first;
    for (final n in this) {
      if (n > max) max = n;
    }
    return max;
  }

  /// * return the element with the max value
  /// * return `0` if isEmpty
  num maxOrZero() => maxOrNull() ?? 0;

  /// * return the element with the max value
  /// * return `value` if isEmpty
  num maxOr(num value) => maxOrNull() ?? value;

  /// * return the element with the max value
  /// ! throws `StateError` if isEmpty
  num max() => maxOrNull() ?? (throw StateError('list is empty'));

  /// * return the minimum value in the list
  /// * return `null` if isEmpty
  num? minOrNull() {
    if (isEmpty) return null;
    num min = first;
    for (final n in this) {
      if (n < min) min = n;
    }
    return min;
  }

  /// * return the element with the minimum value
  /// * return `value` if isEmpty
  num minOr(num value) => minOrNull() ?? value;

  /// * return the element with the minimum value
  /// * return `value` if isEmpty
  num minOrZero() => minOrNull() ?? 0;

  /// * return the element with the minimum value

  /// * return the element with the max value
  /// ! throws `StateError` if isEmpty
  num min() => minOrNull() ?? (throw StateError('list is empty'));
}

/// provides extensions for List
extension ListScrewDriver<E> on List<E> {
  /// adds [element] into the list and returns the list
  List<E> operator <<(E element) => this..add(element);

  /// Replaces an item in the list with [replacement] where [predicate] returns
  /// true. Returns true if an item is replaced, false otherwise.
  bool replaceFirstWhere(E replacement, bool Function(E item) predicate) {
    if (isEmpty) return false;
    for (int index = 0; index < length; index++) {
      if (predicate(elementAt(index))) {
        this[index] = replacement;
        return true;
      }
    }
    return false;
  }

  /// Replaces an item in the list with [replacement] where [predicate] returns
  /// true. Returns true if an item is replaced, false otherwise.
  bool replaceLastWhere(E replacement, bool Function(E item) predicate) {
    if (isEmpty) return false;
    for (int index = length - 1; index >= 0; index--) {
      if (predicate(elementAt(index))) {
        this[index] = replacement;
        return true;
      }
    }
    return false;
  }
}

extension IterableSorted<E> on Iterable<E> {
  /// Returns a new list with all elements sorted according to natural sort
  /// order.
  List<E> sorted() {
    final list = toList();
    list.sort();
    return list;
  }
}

extension IterableSortedDescending<E> on Iterable<E> {
  /// Returns a new list with all elements sorted according to descending
  /// natural sort order.
  List<E> sortedDescending() {
    final list = toList();
    list.sort((a, b) => -(a as Comparable).compareTo(b));
    return list;
  }
}

extension IterableSortedBy<E> on Iterable<E> {
  /// Returns a new list with all elements sorted according to natural sort
  /// order of the values returned by specified [selector] function.
  ///
  /// To sort by more than one property, `thenBy()` or `thenByDescending()` can
  /// be called afterwards.
  ///
  /// **Note:** The actual sorting is performed when an element is accessed for
  /// the first time.
  SortedList<E> sortedBy(Comparable Function(E element) selector) {
    return SortedList<E>.withSelector(this, selector, 1, null);
  }
}

extension IterableSortedByDescending<E> on Iterable<E> {
  /// Returns a new list with all elements sorted according to descending
  /// natural sort order of the values returned by specified [selector]
  /// function.
  ///
  /// To sort by more than one property, `thenBy()` or `thenByDescending` can
  /// be called afterwards.
  ///
  /// **Note:** The actual sorting is performed when an element is accessed for
  /// the first time.
  SortedList<E> sortedByDescending(Comparable Function(E element) selector) {
    return SortedList<E>.withSelector(this, selector, -1, null);
  }
}

extension IterableSortedWith<E> on Iterable<E> {
  /// Returns a new list with all elements sorted according to specified
  /// [comparator].
  ///
  /// To sort by more than one property, `thenBy()` or `thenByDescending` can
  /// be called afterwards.
  ///
  /// **Note:** The actual sorting is performed when an element is accessed for
  /// the first time.
  SortedList<E> sortedWith(Comparator<E> comparator) {
    return SortedList<E>(this, comparator);
  }
}

extension IterableSumBy<E> on Iterable<E> {
  /// Returns the sum of all values produced by [selector] function applied to
  /// each element in the collection.
  T sumBy<T extends num>(T Function(E element) selector) {
    var sum = T == double ? 0.0 : 0;
    for (final current in this) {
      sum += selector(current);
    }
    return sum as T;
  }
}

extension IterableAverageBy<E> on Iterable<E> {
  /// Returns the average of values returned by [selector] for all elements in
  /// the collection.
  double averageBy(num Function(E element) selector) {
    var count = 0;
    num sum = 0;

    for (final current in this) {
      sum += selector(current);
      count++;
    }

    if (count == 0) {
      throw StateError('No elements in collection');
    } else {
      return sum / count;
    }
  }
}

extension InterableMin<E> on Iterable<E> {
  /// Returns the smallest element or `null` if there are no elements.
  ///
  /// All elements must be of type [Comparable].
  E? min() => _minMax(-1);
}

extension _MinMaxHelper<E> on Iterable<E> {
  E? _minMax(int order) {
    final it = iterator;
    if (!it.moveNext()) {
      return null;
    }
    var currentMin = it.current;

    if (order < 0) {
      while (it.moveNext()) {
        if ((it.current as Comparable).compareTo(currentMin) <= order) {
          currentMin = it.current;
        }
      }
    } else {
      while (it.moveNext()) {
        if ((it.current as Comparable).compareTo(currentMin) >= order) {
          currentMin = it.current;
        }
      }
    }

    return currentMin;
  }

  E? _minMaxBy(int order, Comparable Function(E element) selector) {
    final it = iterator;
    if (!it.moveNext()) {
      return null;
    }

    var currentMin = it.current;
    var currentMinValue = selector(it.current);
    while (it.moveNext()) {
      final comp = selector(it.current);
      if (comp.compareTo(currentMinValue) == order) {
        currentMin = it.current;
        currentMinValue = comp;
      }
    }

    return currentMin;
  }

  E? _minMaxWith(int order, Comparator<E> comparator) {
    final it = iterator;
    if (!it.moveNext()) {
      return null;
    }
    var currentMin = it.current;

    while (it.moveNext()) {
      if (comparator(it.current, currentMin) == order) {
        currentMin = it.current;
      }
    }

    return currentMin;
  }
}

extension IterableMinBy<E> on Iterable<E> {
  /// Returns the first element yielding the smallest value of the given
  /// [selector] or `null` if there are no elements.
  E? minBy(Comparable Function(E element) selector) => _minMaxBy(-1, selector);
}

extension IterableMinWith<E> on Iterable<E> {
  /// Returns the first element having the smallest value according to the
  /// provided [comparator] or `null` if there are no elements.
  E? minWith(Comparator<E> comparator) => _minMaxWith(-1, comparator);
}

extension IterableMax<E> on Iterable<E> {
  /// Returns the largest element or `null` if there are no elements.
  ///
  /// All elements must be of type [Comparable].
  E? max() => _minMax(1);
}

extension IterableMaxBy<E> on Iterable<E> {
  /// Returns the first element yielding the largest value of the given
  /// [selector] or `null` if there are no elements.
  E? maxBy(Comparable Function(E element) selector) => _minMaxBy(1, selector);
}

extension IterableMaxWith<E> on Iterable<E> {
  /// Returns the first element having the largest value according to the
  /// provided [comparator] or `null` if there are no elements.
  E? maxWith(Comparator<E> comparator) => _minMaxWith(1, comparator);
}

extension IterableCount<E> on Iterable<E> {
  /// Returns the number of elements matching the given [predicate].
  ///
  /// If no [predicate] is given, this equals to [length].
  int count([bool Function(E element)? predicate]) {
    var count = 0;
    if (predicate == null) {
      return length;
    } else {
      for (final current in this) {
        if (predicate(current)) {
          count++;
        }
      }
    }

    return count;
  }
}


/// See also: [FicListExtension], [FicSetExtension]
extension FicIterableExtensionTypeNullable<T> on Iterable<T?> {
  //
  /// Similar to [map], but MAY return a non-nullable type.
  ///
  /// ```
  /// int? f(String? e) => (e == null) ? 0 : e.length;
  ///
  /// List<int?> list1 = ["xxx", "xx", null, "x"].map(f).toList();
  /// expect(list1, isA<List<int?>>());
  ///
  /// List<int?> list2 = ["xxx", "xx", null, "x"].mapNotNull(f).toList();
  /// expect(list2, isA<List<int>>());
  /// ```
  Iterable<E> mapNotNull<E>(E? Function(T? e) f) => map(f).cast();
}

/// See also: [FicListExtension], [FicSetExtension]
extension FicIterableExtension<T> on Iterable<T> {
  //

  /// Creates an *immutable* set ([ISet]) from the iterable.
  ISet<T> toISet([ConfigSet? config]) => ISet<T>.withConfig(this, config ?? ISet.defaultConfig);

  /// Creates an *immutable* list ([IList]) from the iterable.
  IList<T> toIList([ConfigList? config]) =>
      IList<T>.withConfig(this, config ?? IList.defaultConfig);

  /// Returns a [List] containing the elements of this iterable.
  /// If the Iterable is already a [List], return the same instance (nothing new is created).
  /// Otherwise, create a new List from it.
  /// See also: Dart's native [toList], which always creates a new list.
  List<T> asList() => (this is List<T>) ? (this as List<T>) : toList();

  /// Creates a [Set] containing the same elements as this iterable.
  /// If the Iterable is already a [Set], return the same instance (nothing new is created).
  /// Otherwise, create a new Set from it.
  /// See also: Dart's native [toSet], which always creates a new set.
  Set<T> asSet() => (this is Set<T>) ? (this as Set<T>) : toSet();

  // Removed, since now you can: import "package:collection/collection.dart";
  // /// Returns the first element that satisfies the given predicate [test].
  // ///
  // /// If no element satisfies [test], the result of invoking the [orElse]
  // /// function is returned.
  // /// If [orElse] is omitted, return null.
  // T? firstWhereOrNull(Predicate<T> test, {T? Function()? orElse}) {
  //   for (T element in this) if (test(element)) return element;
  //   if (orElse != null) return orElse();
  //   return null;
  // }

  /// Compare all items, in order or not, according to [ignoreOrder],
  /// using [operator ==]. Return true if they are all the same,
  /// in the same order.
  ///
  bool deepEquals(Iterable? other, {bool ignoreOrder = false}) {
    if (identical(this, other)) return true;
    if (other == null) return false;

    // Assumes `EfficientLengthIterable` for these:
    if ((this is List) ||
        (this is Set) ||
        (this is Queue) ||
        (this is ImmutableCollection)) if (length != other.length) return false;

    return ignoreOrder
        ? const UnorderedIterableEquality<dynamic>(DefaultEquality<dynamic>()).equals(this, other)
        : const IterableEquality<dynamic>(DefaultEquality<dynamic>()).equals(this, other);
  }

  /// Return true if they are all the same, in the same order.
  /// Compare all items, in order or not, according to [ignoreOrder],
  /// using [identical]. Return true if they are all the same,
  /// in the same order.
  bool deepEqualsByIdentity(Iterable? other, {bool ignoreOrder = false}) {
    if (identical(this, other)) return true;
    if (other == null) return false;

    /// Assumes EfficientLengthIterable for these:
    if ((this is List) ||
        (this is Set) ||
        (this is Queue) ||
        (this is ImmutableCollection)) if (length != other.length) return false;

    return ignoreOrder
        ? const UnorderedIterableEquality<dynamic>(IdentityEquality<dynamic>()).equals(this, other)
        : const IterableEquality<dynamic>(IdentityEquality<dynamic>()).equals(this, other);
  }

  /// The sum of the values returned by the [mapper] function.
  ///
  /// Examples:
  /// ```
  /// expect([1, 2, 3, 4, 5].sumBy((e) => e), 15);
  /// expect([1.5, 2.5, 3.3, 4, 5].sumBy((e) => e), 16.3);
  /// expect(['a', 'ab', 'abc', 'abcd', 'abcde'].sumBy((e) => e.length), 15);
  /// ```
  N sumBy<N extends num>(N Function(T element) mapper) {
    // If the iterable is empty but N is double
    // then result will be an int because 0 is an int
    // therefore result as N (which in this case will be: 0 as double)
    // will throw an error
    if (isEmpty) {
      return _zeroOf<N>();
    }

    num result = 0;
    for (final value in this) {
      result = result + mapper(value);
    }
    return result as N;
  }

  /// Returns a zero of type [N].
  N _zeroOf<N extends num>() {
    // num is a sealed class with only two subclasses: int and double
    // therefore this function should never throw
    return switch (N) {
      const (int) => 0 as N,
      const (double) => 0.0 as N,
      _ => throw UnsupportedError("Unsupported type: $N"),
    };
  }

  /// The arithmetic mean of the elements of a non-empty iterable.
  /// The arithmetic mean is the sum of the elements divided by the number of elements.
  /// If iterable is empty it returns 0.
  /// Examples:
  /// ```
  /// expect([1, 2, 3, 4, 5].averageBy((e) => e), 3.0);
  /// expect([1.5, 2.5, 3.3, 4, 5].averageBy((e) => e), 3.26);
  /// expect(['a', 'ab', 'abc', 'abcd', 'abcde'].sumBy((e) => e.length), 3.0);
  /// ```
  double averageBy<N extends num>(N Function(T element) mapper) {
    double result = 0.0;
    var count = 0;
    for (final value in this) {
      count += 1;
      result += (mapper(value) - result) / count;
    }
    return result;
  }

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
  T restrict(T? item, {required T orElse}) => contains(item) ? item as T : orElse;

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

  /// Returns `true` if all items are equal to [value].
  bool everyIs(T value) => every((item) => item == value);

  /// Returns `true` if any item is equal to [value].
  bool anyIs(T value) => any((item) => item == value);

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
  /// See also: `distinct` and `removeDuplicates` in [FicListExtension].
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

  /// Creates a reversed sorted list of the elements of the iterable.
  ///
  /// If the [compare] function is not supplied, the sorting uses the
  /// [compareObject] function.
  ///
  /// See also: [sorted] (from 'package:collection/collection.dart').
  ///
  List<T> sortedReversed([Comparator<T>? compare]) => [...this]..sortReversed(compare);

  /// Returns a list, sorted according to the order specified by the [ordering] iterable.
  /// Items which don't appear in [ordering] will be included in the end, in their original order.
  /// Items of [ordering] which are not found in the original list are ignored.
  ///
  List<T> sortedLike(Iterable ordering) {
    final Set<T> thisSet = Set.of(this);
    final Set<dynamic> otherSet = Set<dynamic>.of(ordering);

    final DiffAndIntersectResult<T, dynamic> result = thisSet.diffAndIntersect<dynamic>(
      otherSet,
      diffThisMinusOther: true,
      diffOtherMinusThis: false,
      intersectThisWithOther: false,
      intersectOtherWithThis: true,
    );

    final List<T> intersectOtherWithThis = result.intersectOtherWithThis ?? [];
    final List<T> diffThisMinusOther = result.diffThisMinusOther ?? [];
    return intersectOtherWithThis.followedBy(diffThisMinusOther).toList();
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
  List<T> updateById(
      Iterable<T> newItems,
      dynamic Function(T item) id,
      ) {
    final List<T> newList = [];

    final Map<dynamic, T> idsPerNewItem = <dynamic, T>{for (final T item in newItems) id(item): item};

    // Replace those with the same id.
    for (final T item in this) {
      final itemId = id(item);
      if (idsPerNewItem.containsKey(itemId)) {
        final T newItem = idsPerNewItem[itemId] as T;
        newList.add(newItem);
        idsPerNewItem.remove(itemId);
      } else
        newList.add(item);
    }

    // Add the new ones at the end.
    newList.addAll(idsPerNewItem.values);
    return newList;
  }

  /// Return true if the given [item] is the same (by identity) as the first iterable item.
  /// If this iterable is empty, always return null.
  /// This is useful for non-indexed loops where you need to know when you have the first item.
  /// For example:
  ///
  /// ```dart
  /// for (student in students) {
  ///    if (!children.isFirst(student) result.add(Divider());
  ///    result.add(Text(student.name));
  /// }
  /// ```
  ///
  bool isFirst(T item) => length > 0 && identical(first, item);

  /// Return true if the given [item] is NOT the same (by identity) as the first iterable item.
  /// If this iterable is empty, always return null.
  /// This is useful for non-indexed loops where you need to know when you don't have the first
  /// item. For example:
  ///
  /// ```dart
  /// for (student in students) {
  ///    if (children.isNotFirst(student) result.add(Divider());
  ///    result.add(Text(student.name));
  /// }
  /// ```
  ///
  bool isNotFirst(T item) => !isFirst(item);

  /// Return true if the given [item] is the same (by identity) as the last iterable item.
  /// If this iterable is empty, always return null.
  /// This is useful for non-indexed loops where you need to know when you have the last item.
  /// For example:
  ///
  /// ```dart
  /// for (student in students) {
  ///    if (!children.isLast(student) result.add(Divider());
  ///    result.add(Text(student.name));
  /// }
  /// ```
  ///
  bool isLast(T item) => length > 0 && identical(last, item);

  /// Return true if the given [item] is NOT the same (by identity) as the last iterable item.
  /// If this iterable is empty, always return null.
  /// This is useful for non-indexed loops where you need to know when you don't have the last
  /// item. For example:
  ///
  /// ```dart
  /// for (student in students) {
  ///    if (children.isNotLast(student) result.add(Divider());
  ///    result.add(Text(student.name));
  /// }
  /// ```
  ///
  bool isNotLast(T item) => !isLast(item);

  /// Maps each element and its index to a new value.
  /// This is similar to [mapIndexed] but also tells you which item is the last.
  Iterable<R> mapIndexedAndLast<R>(R Function(int index, T item, bool isLast) convert) sync* {
    var index = 0;
    final int _length = length; // In case length is not efficient.
    for (final item in this) {
      yield convert(index++, item, index == _length);
    }
  }

  /// Returns true if this [Iterable] has any items in common with the [other] Iterable.
  /// This method is as performant as possible, but it will be faster if any of the Iterables
  /// is a [Set] or an [ISet].
  bool intersectsWith(Iterable<T> other) {
    //
    // Note: We could convert them to Sets, and check if Set.intersect is empty.
    // But that's not performant.

    // If both are Set/ISet we'll iterate the smaller one, because that's faster.
    if ((this is Set || this is ISet) && (other is Set || other is ISet)) {
      if (length > other.length) {
        for (final T item in other) {
          if (contains(item)) return true;
        }
        return false;
      }
      //
      else {
        for (final T item in this) {
          if (other.contains(item)) return true;
        }
        return false;
      }
    }

    // ---

    Iterable<T> set;
    Iterable<T> iterable;

    // If none of them is a Set/ISet, convert one of them to a Set.
    if ((this is! Set<T> && this is! ISet<T>) && (other is! Set<T> && other is! ISet<T>)) {
      set = other.toSet();
      iterable = this;
    }
    //
    // If one of them is a Set/ISet, find it.
    else {
      if (this is Set<T> || this is ISet<T>) {
        set = this;
        iterable = other;
      } else {
        assert(other is Set<T> || other is ISet<T>);
        set = other;
        iterable = this;
      }
    }

    /// Iterate the Iterable, searching the Set.
    for (final T item in iterable) {
      if (set.contains(item)) return true;
    }
    return false;
  }
}


extension IterableMinus<E> on Iterable<E> {
  /// Returns a new list containing all elements of this collection except the
  /// elements contained in the given [elements] collection.
  List<E> operator -(Iterable<E> elements) => except(elements).toList();
}

extension IterableExceptElement<E> on Iterable<E> {
  /// Returns a new lazy [Iterable] containing all elements of this collection
  /// except the given [element].
  Iterable<E> exceptElement(E element) sync* {
    for (final current in this) {
      if (element != current) yield current;
    }
  }
}

extension IterablePrepend<E> on Iterable<E> {
  /// Returns a new lazy [Iterable] containing all elements of this collection
  /// and then all elements of the given [elements] collection.
  Iterable<E> prepend(Iterable<E> elements) sync* {
    yield* elements;
    yield* this;
  }
}

extension IterablePrependElement<E> on Iterable<E> {
  /// Returns a new lazy [Iterable] containing all elements of this collection
  /// and then the given [element].
  Iterable<E> prependElement(E element) sync* {
    yield element;
    yield* this;
  }
}

extension IterableAppend<E> on Iterable<E> {
  /// Returns a new lazy [Iterable] containing all elements of the given
  /// [elements] collection and then all elements of this collection.
  Iterable<E> append(Iterable<E> elements) sync* {
    yield* this;
    yield* elements;
  }
}

extension IterablePlus<E> on Iterable<E> {
  /// Returns a new list containing all elements of the given [elements]
  /// collection and then all elements of this collection.
  List<E> operator +(Iterable<E> elements) => append(elements).toList();
}

extension IterableAppendElement<E> on Iterable<E> {
  /// Returns a new lazy [Iterable] containing the given [element] and then all
  /// elements of this collection.
  Iterable<E> appendElement(E element) sync* {
    yield* this;
    yield element;
  }
}

extension IterableUnion<E> on Iterable<E> {
  /// Returns a new lazy [Iterable] containing all distinct elements from
  /// both collections.
  ///
  /// The returned set preserves the element iteration order of this collection.
  /// Those elements of the [other] collection that are unique are iterated in
  /// the end in the order of the [other] collection.
  Iterable<E> union(Iterable<E> other) sync* {
    final existing = HashSet<E>();
    for (final element in this) {
      if (existing.add(element)) yield element;
    }

    for (final element in other) {
      if (existing.add(element)) yield element;
    }
  }
}

extension IterableZip<E> on Iterable<E> {
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
      V Function(E a, R b) transform,
      ) sync* {
    final it1 = iterator;
    final it2 = other.iterator;
    while (it1.moveNext() && it2.moveNext()) {
      yield transform(it1.current, it2.current);
    }
  }
}

extension IterableToIterable<E> on Iterable<E> {
  /// Returns a new lazy [Iterable] with all elements of this collection.
  Iterable<E> toIterable() sync* {
    yield* this;
  }
}

extension IterableAsStream<E> on Iterable<E> {
  /// Returns a new [Stream] with all elements of this collection.
  Stream<E> asStream() => Stream.fromIterable(this);
}

extension IterableToHashSet<E> on Iterable<E> {
  /// Returns a new [HashSet] with all distinct elements of this collection.
  HashSet<E> toHashSet() => HashSet.from(this);
}

extension IterableToUnmodifiable<E> on Iterable<E> {
  /// Returns an unmodifiable List view of this collection.
  List<E> toUnmodifiable() => collection.UnmodifiableListView(this);
}

extension IterableShuffled<E> on Iterable<E> {
  /// Returns a new, randomly shuffled list.
  ///
  /// If [random] is given, it is being used for random number generation.
  List<E> shuffled([Random? random]) => toList()..shuffle(random);
}

extension IterableAssociate<E> on Iterable<E> {
  /// Returns a Map containing key-value pairs provided by [transform] function
  /// applied to elements of this collection.
  ///
  /// If any of two pairs would have the same key the last one gets added to the
  /// map.
  Map<K, V> associate<K, V>(MapEntry<K, V> Function(E element) transform) {
    final map = <K, V>{};
    for (final element in this) {
      final entry = transform(element);
      map[entry.key] = entry.value;
    }
    return map;
  }
}

extension IterableAssociateBy<E> on Iterable<E> {
  /// Returns a Map containing the elements from the collection indexed by
  /// the key returned from [keySelector] function applied to each element.
  ///
  /// If any two elements would have the same key returned by [keySelector] the
  /// last one gets added to the map.
  Map<K, E> associateBy<K>(K Function(E element) keySelector) {
    final map = <K, E>{};
    for (final current in this) {
      map[keySelector(current)] = current;
    }
    return map;
  }
}

extension IterableAssociateWith<E> on Iterable<E> {
  /// Returns a Map containing the values returned from [valueSelector] function
  /// applied to each element indexed by the elements from the collection.
  ///
  /// If any of elements (-> keys) would be the same the last one gets added
  /// to the map.
  Map<E, V> associateWith<V>(V Function(E element) valueSelector) {
    final map = <E, V>{};
    for (final current in this) {
      map[current] = valueSelector(current);
    }
    return map;
  }
}

extension IterableGroupBy<E> on Iterable<E> {
  /// Groups elements of the original collection by the key returned by the
  /// given [keySelector] function applied to each element and returns a map.
  ///
  /// Each group key is associated with a list of corresponding elements.
  ///
  /// The returned map preserves the entry iteration order of the keys produced
  /// from the original collection.
  Map<K, List<E>> groupBy<K>(K Function(E element) keySelector) {
    return collection.groupBy(this, keySelector);
  }
}

extension IterablePartition<E> on Iterable<E> {
  /// Splits the collection into two lists according to [predicate].
  ///
  /// The first list contains elements for which [predicate] yielded true,
  /// while the second list contains elements for which [predicate] yielded
  /// false.
  List<List<E>> partition(bool Function(E element) predicate) {
    final t = <E>[];
    final f = <E>[];
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
      if (allowDifferentSizes)
        return;
      else
        throw StateError("Can't combine iterables of different sizes (a > b).");
    }
    yield combine(iterA.current, iterB.current);
  }

  if (iterB.moveNext() && !allowDifferentSizes)
    throw StateError("Can't combine iterables of different sizes (a < b).");
}
