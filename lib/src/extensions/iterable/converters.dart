import 'dart:async';
import 'dart:collection';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../constants/types.dart';
import './sanitizers.dart';
import './validators.dart';

/// Returns zero value for num, depends on required type.
///
/// It will be `0` for [int] and `0.0` for [double].
T _zero<T extends num>() => T == int ? 0 as T : 0.0 as T;

/// Statistical and aggregation helpers for nullable numeric iterables.
///
/// Most methods return fallbacks when the iterable is `null` or empty.
extension NumListConverter<T extends num> on Iterable<T>? {
  /// * return list summation
  /// * return `null` if list is empty
  num? sumOrNull() => isBlank ? null : this!.fold(_zero(), (a, b) => a! + b);

  /// * return list summation
  /// * return `value` if list is empty
  num sumOr(num value) => sumOrNull() ?? value;

  /// * return list summation
  /// * return `0` if isEmpty
  num sumOrZero() => sumOrNull() ?? _zero();

  /// * return the average of the list
  /// * return `null` if isEmpty
  num? averageOrNull() => isBlank ? null : (sumOrZero() / length);

  /// * return list average
  /// * return `value` if isEmpty
  num averageOr(num value) => averageOrNull() ?? value;

  /// * return the average of the list
  /// * return `0` if isEmpty
  num averageOrZero() => averageOr(_zero());

  /// * return the maximum value in the list
  /// * return `null` if isEmpty
  num? maxOrNull() => isBlank ? null : this!.reduce(math.max);

  /// * return the element with the max value
  /// * return `0` if isEmpty
  num maxOrZero() => maxOrNull() ?? _zero();

  /// * return the element with the max value
  /// * return `value` if isEmpty
  num maxOr(num value) => maxOrNull() ?? value;

  /// Returns the index where the max number of this list is.
  int get maxIndex =>
      isBlank ? _zero() : this!.toList().indexOf(maxOrZero() as T);

  /// * return the minimum value in the list
  /// * return `null` if isEmpty
  num? minOrNull() => isBlank ? null : this!.reduce(math.min);

  /// * return the element with the minimum value
  /// * return `value` if isEmpty
  num minOr(num value) => minOrNull() ?? value;

  /// * return the element with the minimum value
  /// * return `0` if isEmpty
  num minOrZero() => minOrNull() ?? _zero();

  /// Returns the index where the min number of this list is.
  int get minIndex =>
      isBlank ? _zero() : this!.toList().indexOf(minOrZero() as T);

  /// Returns the product of all elements in the list.
  ///
  /// Returns `null` if the list is empty.
  ///
  /// Example:
  /// ```dart
  /// List<int> numbers = [1, 2, 3];
  /// print(numbers.prodOrNull()); // Output: 6
  /// ```
  num? prodOrNull() => isBlank ? null : this!.fold<num>(1, (a, b) => a * b);

  /// Returns the product of all elements, or [value] if empty.
  num prodOr(num value) => prodOrNull() ?? value;

  /// Returns the product of all elements, or numeric zero if empty.
  num prodOrZero() => prodOrNull() ?? _zero();

  /// Calculates the median of all elements in the list.
  ///
  /// Returns `null` when the list is empty.
  ///
  /// Example:
  /// ```dart
  /// List<int> numbers = [1, 2, 3, 4];
  /// print(numbers.median()); // Output: 2.5
  /// ```
  num? median() {
    if (isBlank) return null;

    final sorted = [...this!]..sort();
    final middle = length ~/ 2;

    if (length.isEven) return (sorted[middle - 1] + sorted[middle]) / 2;

    return sorted[middle];
  }

  /// Finds the mode(s) of the numbers in the iterable.
  ///
  /// Returns a list of numbers that appear most frequently.
  List<num>? mode() {
    if (isBlank) return null;

    final frequencyMap = <num, int>{};
    for (final value in this!) {
      frequencyMap[value] = (frequencyMap[value] ?? 0) + 1;
    }

    final maxFrequency = frequencyMap.values.reduce(math.max);
    return frequencyMap.entries
        .where((entry) => entry.value == maxFrequency)
        .map((entry) => entry.key)
        .toList();
  }

  /// Returns the sum of squares for all values, or `null` if empty.
  num? sumOfSquares() => this?.map((value) => value * value).sumOrNull();

  /// Computes the variance of the numbers in the iterable.
  num? variance() {
    final m = averageOrNull();
    if (m == null) return null;

    return orEmpty().map((value) => math.pow(value - m, 2)).averageOrNull();
  }

  /// Calculates the standard deviation of the numbers in the iterable.
  num? standardDeviation() {
    final v = variance();

    return v != null ? math.sqrt(v) : null;
  }

  /// Computes the specified [percentile] of the numbers in the iterable.
  ///
  /// The [percentile] should be a value between 0 and 100.
  num? percentile(double percentile) {
    if (isBlank) return null;
    if (percentile < 0 || percentile > 100) {
      throw RangeError.range(percentile, 0, 100, 'percentile');
    }

    final sorted = List<num>.from(orEmpty())..sort();
    final index = ((percentile / 100) * (sorted.length - 1)).round();
    return sorted[index];
  }
}

/// Common extensions for iterables composed of enums
extension EnumConverter<T extends Enum> on Iterable<T> {
  /// Returns the enum in the iterable with the same name as [name], if found.
  ///
  /// Searches through the iterable to find an enum whose `name` property
  /// matches the provided [name].
  ///
  /// Returns `null` if no matching enum is found.
  ///
  /// Example:
  /// ```dart
  ///
  /// enum Fruit {
  ///   apple,
  ///   banana,
  ///   orange,
  /// }
  ///
  /// Fruit? foundFruit = Fruit.values.byNameOrNull('banana'); // Returns Fruit.banana
  /// ```
  T? byNameOrNull(String name) {
    for (final value in this) {
      if (value.name == name) return value;
    }
    return null;
  }

  T byNameOr(String name, T orElse) => byNameOrNull(name) ?? orElse;

  /// Returns the first enum value matching [test], or `null` if none matches.
  T? byValueOrNull(Predicate<T> test) {
    for (final value in this) {
      if (test(value)) return value;
    }
    return null;
  }

  /// Returns the first enum value matching [test], or [orElse] if none matches.
  T byValueOr(Predicate<T> test, T orElse) => byValueOrNull(test) ?? orElse;
}

/// General-purpose functional helpers for nullable iterables.
extension IterableScrewDriver<T> on Iterable<T>? {
  /// Returns the sum of all values produced by [selector] function
  /// applied to each element in the collection.
  R? sumBy<R extends num>(Transformer<T, R> selector) =>
      this?.fold<R>(
        _zero() as R,
        (previous, element) => previous + selector(element) as R,
      ) ??
      _zero() as R;

  num prodBy<R extends num>(Transformer<T, R> selector) => isBlank
      ? _zero()
      : this!.skip(1).fold<num>(selector(this!.first), (previous, element) {
          return previous * selector(element);
        });

  /// Returns the average of all values produced by [selector] function
  /// applied to each element in the collection.
  num averageBy<R extends num>(Transformer<T, R> selector) =>
      isBlank ? _zero() : sumBy(selector)! / length;

  /// Returns the maximum value based on the [comparator] function.
  /// If collection is empty this returns `null`.
  ///
  /// Example:
  /// ```dart
  /// [90, 10, 20, 30].maxBy((a, b) => a.compareTo(b)); // 90
  /// persons.maxBy((a, b) => a.age.compareTo(b.age));  // the oldest person
  /// ```
  T? maxBy(Comparator<T> comparator) => this?.reduce(
    (value, element) => comparator(value, element) > 0 ? value : element,
  );

  /// Returns the minimal value based on the [comparator] function.
  /// If collection is empty this returns `null`.
  ///
  /// Example:
  /// ```dart
  /// [1, 0, 2].minBy((a, b) => a.compareTo(b));       // 0
  /// persons.minBy((a, b) => a.age.compareTo(b.age)); // the youngest person
  /// ```
  T? minBy(Comparator<T> comparator) => this?.reduce(
    (value, element) => comparator(value, element) < 0 ? value : element,
  );

  /// Returns a map that contains [MapEntry]s provided by a [transform] function.
  ///
  /// If two elements share the same key, the last one gets added to the map.
  ///
  /// Example:
  /// ```dart
  /// [1, 2, 3].associate((e) => MapEntry('key_$e', e * 100)); // {'key_1': 100, 'key_2': 200, 'key_3': 300}
  /// ```
  Map<K, V> associate<K, V>(Transformer<T, MapEntry<K, V>> transform) {
    if (isBlank) return <K, V>{};

    return Map.fromEntries(this!.map(transform));
  }

  /// Returns a map where every element is associated by a key produced from
  /// the [transform] function.
  ///
  /// If two elements share the same key, the last one gets added to the map.
  ///
  /// Example:
  /// ```dart
  /// ['a', 'ab', 'abc'].associateBy((e) => e.length); // {1: 'a', 2: 'ab', 3: 'abc'}
  /// ```
  Map<K, T> associateBy<K>(Transformer<T, K> transform) {
    if (isBlank) return <K, T>{};

    final map = <K, T>{};
    for (final element in this!) {
      final key = transform(element);
      map[key] = element;
    }
    return map;
  }

  /// Returns a map where every element is used as a key that is associated
  /// with a value produced by the [transform] function.
  ///
  /// Example:
  /// ```dart
  /// [1, 2, 3].associateWith((e) => e * 1000); // {1: 1000, 2: 2000, 3: 3000}
  /// ```
  Map<T, V> associateWith<V>(Transformer<T, V> transform) {
    if (isBlank) return <T, V>{};

    final map = <T, V>{};
    for (final element in this!) {
      map[element] = transform(element);
    }
    return map;
  }

  Map<K, List<V>> groupBy<K, V>(
    Transformer<T, K> selector, {
    Transformer<T, V>? transform,
  }) {
    if (isBlank) return <K, List<V>>{};

    final transformFn = transform ?? (element) => element as V;

    final map = <K, List<V>>{};

    for (final element in this!) {
      final key = selector(element);

      if (!map.containsKey(key)) map[key] = [];

      map[key]!.add(transformFn(element));
    }

    return map;
  }

  /// Returns an iterable containing only distinct elements from
  /// the given iterable.
  Iterable<T> distinct() => toSet().toList();

  /// Returns an iterable containing only elements from the given iterable
  /// having distinct keys returned by the given [selector] function.
  Iterable<T> distinctBy<K>(Transformer<T, K> selector) =>
      distinctByTo(<T>[], selector);

  /// Populates and returns the [destination] list with containing only
  /// elements from the given iterable having distinct keys returned by
  /// the given [selector] function.
  Iterable<T> distinctByTo<K>(List<T> destination, Transformer<T, K> selector) {
    final set = HashSet<K>();
    if (this == null) return <T>[];

    for (final element in this!) {
      final key = selector(element);
      if (set.add(key)) destination.add(element);
    }
    return destination;
  }

  /// Convert iterable to set
  Set<T> toSet() => Set.from(this ?? []);

  /// Returns a set containing all elements that are contained
  /// by both this set and the specified collection.
  Set<T> intersect(Iterable<T> other) => toSet()..retainAll(other);

  /// Returns a set containing all elements that are contained
  /// by this collection and not contained by the specified collection.
  Set<T> subtract(Iterable<T> other) => toSet()..removeAll(other);

  /// Returns a set containing all distinct elements from both collections.
  Set<T> union(Iterable<T> other) => toSet()..addAll(other);

  /// Returns the number of elements matching the given [predicate].
  int count([Predicate<T>? predicate]) {
    if (isBlank) return 0;
    if (predicate == null) return length;

    return this!.where(predicate).length;
  }

  /// Returns count of elements that matches the given [predicate].
  /// Returns `0` if iterable is null.
  int countWhere(Predicate<T> predicate) {
    if (isBlank) return 0;
    return this!.where(predicate).length;
  }

  /// Performs the given [action] on each element and returns the
  /// iterable itself afterwards.
  Iterable<T> onEach(ValueChanged<T> action) sync* {
    if (isBlank) return;

    final it = this!.iterator;

    while (it.moveNext()) {
      action(it.current);
      yield it.current;
    }
  }

  /// Calls [action] for each element with its index and yields elements unchanged.
  Iterable<T> onEachIndexed(MapIndexedValue<T, void> action) sync* {
    if (isBlank) {
      yield* Iterable.empty();
      return;
    }

    final it = this!.iterator;
    var index = 0;

    while (it.moveNext()) {
      action(index++, it.current);
      yield it.current;
    }
  }

  /// Returns an iterable containing the items with their respective indices
  /// in form of records.
  ///
  /// One of the use-cases includes iterating over the collection with access
  /// to the index of each item in a for loop.
  ///
  /// e.g.
  ///
  /// for (final (index, item) in list.records) {
  ///   print('$index: $item');
  /// }
  ///
  Iterable<(int, T)> get records sync* {
    if (orEmpty().isEmpty) return;

    for (int index = 0; index < length; index++) {
      yield (index, this!.elementAt(index));
    }
  }
}

/// Read helpers for nullable iterables, including safe index accessors and
/// utility transformations.
extension IterableGetters<T> on Iterable<T>? {
  /// Returns this Iterable if it's not `null` and the empty list otherwise.
  Iterable<T> orEmpty() => this ?? [];

  /// Returns this iterable as a list, or an empty list when `null`.
  List<T> asList() => this?.toList() ?? <T>[];

  /// Returns an element at the given [index] or `null` if the [index] is out of
  /// bounds of this collection.
  ///
  /// ```dart
  /// final list = [1, 2, 3, 4];
  /// final first = list.getOrNull(0); // 1
  /// final fifth = list.getOrNull(4); // null
  /// ```
  T? getOrNull(int index) {
    if (isBlank || index < 0) return null;

    final iterator = this!.iterator;
    var skipCount = index;
    while (iterator.moveNext()) {
      if (skipCount == 0) return iterator.current;
      skipCount--;
    }

    return null;
  }

  /// Returns an element at the given [index] or [value] if the [index]
  /// is out of bounds of this collection.
  ///
  /// ```dart
  /// final list = [1, 2, 3, 4];
  /// final first = list.getOr(0, -1); // 1
  /// final fifth = list.getOr(4, -1); // -1
  /// ```
  T getOr(int index, T value) => getOrElse(index, (_) => value);

  /// Returns an element at the given [index] or the result of calling the
  /// [orElse] function if the [index] is out of bounds of this
  /// collection.
  ///
  /// ```dart
  /// final list = [1, 2, 3, 4];
  /// final first = list.getOrElse(0, (_) => -1); // 1
  /// final fifth = list.getOrElse(4, (_) => -1); // -1
  /// ```
  T getOrElse(int index, Transformer<int, T> orElse) {
    return getOrNull(index) ?? orElse(index);
  }

  /// First element or `null` if the collection is empty.
  ///
  /// ```dart
  /// final first = [1, 2, 3, 4].firstOrNull; // 1
  /// final emptyFirst = [].firstOrNull; // null
  /// ```
  T? get firstOrNull => isNotBlank ? this!.first : null;

  /// First element or `defaultValue` if the collection is empty.
  ///
  /// ```dart
  /// final first = [1, 2, 3, 4].firstOr(-1); // 1
  /// final emptyFirst = [].firstOr(-1); // -1
  /// ```
  T firstOr(T value) => firstOrNull ?? value;

  /// Returns the first element matching the given [predicate], or `null` if no
  /// such element was found.
  ///
  /// ```dart
  /// final list = ['a', 'Test'];
  /// final firstLong= list.firstWhereOrNull((e) => e.length > 1); // 'Test'
  /// final firstVeryLong = list.firstWhereOrNull((e) => e.length > 5); // null
  /// ```
  T? firstWhereOrNull(Predicate<T> predicate) {
    if (isBlank) return null;

    for (final element in this!) {
      if (predicate(element)) return element;
    }
    return null;
  }

  /// Last element or `null` if the collection is empty.
  ///
  /// ```dart
  /// final last = [1, 2, 3, 4].lastOrNull; // 4
  /// final emptyLast = [].lastOrNull; // null
  /// ```
  T? get lastOrNull => isNotBlank ? this!.last : null;

  /// * return the last element
  /// * return `value` if isEmpty
  T lastOr(T value) => lastOrNull ?? value;

  /// Returns the last element matching the given [predicate], or `null` if no
  /// such element was found.
  T? lastWhereOrNull(Predicate<T> predicate) {
    if (isBlank) return null;

    for (final element in this!.reversed) {
      if (predicate(element)) return element;
    }
    return null;
  }

  /// Returns the last valid index, or `null` when the iterable is empty.
  int? get lastIndex => isNotBlank ? length - 1 : null;

  /// Runs [action] sequentially for each item in this iterable.
  Future<void> forEachAsync(FutureOr<void> Function(T e) action) async {
    if (isBlank) return;

    for (final item in this!) {
      await action(item);
    }
  }

  /// * async Map
  Future<List<S>> asyncMap<S>(FutureOr<S> Function(T e) action) async {
    if (isBlank) return <S>[];

    final list = <S>[];
    for (final item in this!) {
      list.add(await action(item));
    }
    return list;
  }

  /// Returns a random element from [Iterable]. Returns null if no elements
  /// are present.
  T? randomOrNull([math.Random? random, int? seed]) {
    if (isBlank) return null;

    if (length == 1) return firstOrNull;

    return this!.elementAt((random ?? math.Random(seed)).nextInt(length));
  }

  /// * return a random element from list or the e if list is empty
  T randomOr(T e, [math.Random? random, int? seed]) =>
      isBlank ? e : this!.random(random, seed);

  /// Extract random items from the list
  List<T> randomSublist(int count) {
    final list = [...orEmpty()]..shuffle();
    return list.take(count).toList();
  }

  /// Returns an [Iterable] containing the first [end] elements of [Iterable],
  /// excluding the first [start] elements.
  ///
  /// This method is a generalization of [List.getRange] to [Iterable]s,
  /// and obeys the same contract.
  ///
  /// Example:
  /// ```dart
  /// {3, 8, 12, 4, 1}.getRange(2, 4); // [12, 4]
  /// ```
  Iterable<T> getRange(int start, int end) {
    if (isBlank) return Iterable.empty();

    RangeError.checkValidRange(start, end, length);
    return this!.skip(start).take(end - start);
  }

  /// * like `map()` function but now you have the index with the element
  ///
  /// Example:
  /// ```dart
  /// final labeled = ['a', 'b'].mapWithIndex((index, value) => '$index:$value');
  /// // ['0:a', '1:b']
  /// ```
  Iterable<E> mapWithIndex<E>(MapIndexedValue<T, E> map) sync* {
    if (isBlank) return;

    var index = 0;
    for (final value in this!) {
      yield map(index++, value);
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
    if (isBlank || other.isBlank) return;

    final it1 = this!.iterator;
    final it2 = other.iterator;

    while (it1.moveNext() && it2.moveNext()) {
      yield transform(it1.current, it2.current);
    }
  }

  /// Returns a new list containing elements at indices between [start]
  /// (inclusive) and [end] (inclusive).
  ///
  /// If [end] is omitted, it is being set to `lastIndex`.
  List<T> slice(int start, [int end = -1]) {
    if (isBlank) return [];

    final list = this is List ? this! as List<T> : this!.toList();
    var start0 = start;
    var end0 = end;

    if (start0 < 0) start0 = start0 + list.length;

    if (end0 < 0) end0 = end0 + list.length;

    RangeError.checkValidRange(start0, end0, list.length);

    return list.sublist(start0, end0 + 1);
  }

  /// Splits this iterable into lazy chunks of [size].
  ///
  /// Returns a single empty chunk when this iterable is empty or [size] is not
  /// positive.
  /// ```dart
  /// [1, 2, 3, 4, 5, 6, 7, 8, 9].chunks(2)
  /// // => [[1, 2], [3, 4], [5, 6], [7, 8], [9]]
  /// ```
  Iterable<List<T>> chunks(int size) sync* {
    if (isBlank || size <= 0) {
      yield List<T>.empty();
      return;
    }

    final len = this!.length;

    for (int i = 0; i < len; i += size) {
      final start = i > len ? i - len : i;
      yield this!.skip(start).take(size).toList();
    }
  }

  /// Splits the elements into lists of the specified [size].
  ///
  /// You can specify an optional [fill] function that produces values
  /// that fill up the last chunk to match the chunk size.
  ///
  /// Example:
  /// ```dart
  /// [1, 2, 3, 4, 5, 6].chunksOrFill(2);        // [[1, 2], [3, 4], [5, 6]]
  /// [1, 2, 3].chunksOrFill(2);                 // [[1, 2], [3]]
  /// [1, 2, 3].chunksOrFill(2, fill: () => 99); // [[1, 2], [3, 99]]
  /// ```
  Iterable<List<T>> chunksOrFill(int size, {T Function()? fill}) sync* {
    if (isBlank || size <= 0) {
      yield List<T>.empty();
      return;
    }

    final len = this!.length;

    for (int i = 0; i < len; i += size) {
      final start = i > len ? i - len : i;
      final chunk = this!.skip(start).take(size).toList();

      if (fill != null) {
        while (chunk.length < size) {
          chunk.add(fill());
        }
      }

      yield chunk;
    }
  }

  /// Splits this collection into a lazy [Iterable] of chunks, where chunks are
  /// created as long as [predicate] is true for a pair of entries.
  ///
  /// For example, one-by-one increasing subsequences can be chunked as follows:
  /// ```dart
  /// final list = [1, 2, 4, 9, 10, 11, 12, 15, 16, 19, 20, 21];
  /// final increasingSubSequences = list.chunkWhile((a, b) => a + 1 == b);
  /// ```
  ///
  /// Here, `increasingSubSequences` would consist of `[1, 2]`, `[4]`,
  /// `[9, 10, 11]`, `[12]`, `[15, 16]` and finally `[19, 20, 21]`.
  ///
  /// See also:
  ///  - [splitWhen], which works similarly but with a reverted [predicate].
  Iterable<List<T>> chunkWhile(bool Function(T, T) predicate) sync* {
    if (isBlank) {
      yield List<T>.empty();
      return;
    }

    var currentChunk = <T>[];
    var hasPrevious = false;
    late T previous;

    for (final element in this!) {
      if (!hasPrevious || predicate(previous, element)) {
        // keep element in current chunk
        currentChunk.add(element);
      } else {
        // start a new chunk containing the new element
        yield currentChunk;
        currentChunk = [element];
      }

      previous = element;
      hasPrevious = true;
    }

    if (currentChunk.isNotEmpty) yield currentChunk;
  }

  /// Splits this collection into a lazy [Iterable], where each split will be
  /// created if [predicate] returns `true` for a pair of consecutive entries.
  ///
  /// For example, one could split the iterable at each changed value like this:
  /// ```dart
  /// final list = [1, 1, 1, 2, 2, 1, 4, 4];
  /// final split = list.splitWhen((a, b) => a != b);
  /// ```
  ///
  /// In that example, `split` would consist of `[1, 1, 1]`, `[2, 2]`,
  /// `[1]`, `[4, 4]`.
  ///
  /// See also:
  ///  - [chunkWhile], which works similarly but with a reverted [predicate].
  Iterable<List<T>> splitWhen(bool Function(T, T) predicate) {
    return chunkWhile((a, b) => !predicate(a, b));
  }

  /// Returns a new lazy [Iterable] of windows of the given [size] sliding along
  /// this collection with the given [step].
  ///
  /// Partial windows are included only when [partialWindows] is `true`.
  ///
  /// Both [size] and [step] must be positive and can be greater than the number
  /// of elements in this collection.
  Iterable<List<T>> windowed(
    int size, {
    int step = 1,
    bool partialWindows = false,
  }) sync* {
    if (size <= 0 || step <= 0) {
      throw ArgumentError(
        'Size and step must be positive integers greater than 0.',
      );
    }

    if (isBlank) {
      yield List<T>.empty();
      return;
    }

    final gap = step - size;

    if (gap >= 0) {
      var buffer = <T>[];
      var skip = 0;
      for (final element in this!) {
        if (skip > 0) {
          skip -= 1;
          continue;
        }
        buffer.add(element);
        if (buffer.length == size) {
          yield buffer;
          buffer = <T>[];
          skip = gap;
        }
      }
      if (buffer.isNotEmpty && (partialWindows || buffer.length == size)) {
        yield buffer;
      }
    } else {
      final buffer = ListQueue<T>(size);
      for (final element in this!) {
        buffer.add(element);
        if (buffer.length == size) {
          yield buffer.toList();
          for (var i = 0; i < step; i++) {
            buffer.removeFirst();
          }
        }
      }
      if (partialWindows) {
        while (buffer.length > step) {
          yield buffer.toList();
          for (var i = 0; i < step; i++) {
            buffer.removeFirst();
          }
        }
        if (buffer.isNotEmpty) {
          yield buffer.toList();
        }
      }
    }
  }

  /// Performs [action] on each element, passing both index and value.
  ///
  /// Example:
  /// ```dart
  /// ['ss', 'tt', 'xx'].forEachIndexed((index, element) {
  ///   print('$element, $index');
  /// });
  /// ```
  void forEachIndexed(MapIndexedValue<T, void> action) {
    if (isBlank) return;

    for (var i = 0; i < this!.length; i++) {
      action(i, this!.elementAt(i));
    }
  }
}

/// Convenience helpers for non-null iterables.
extension IterableExtensions<T> on Iterable<T> {
  /// Returns a random element from [Iterable].
  T random([math.Random? random, int? seed]) {
    if (length == 1) return first;

    return elementAt((random ?? math.Random(seed)).nextInt(length));
  }

  /// Returns a new, randomly shuffled list.
  ///
  /// If [random] is given, it is being used for random number generation.
  List<T> shuffled([math.Random? random]) => toList()..shuffle(random);
}
