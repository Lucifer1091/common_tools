import 'dart:async';
import 'dart:collection';
import 'dart:math' as math;

import '../../common_tools.dart';
import 'index.dart';

/// Returns zero value for num, depends on required type.
///
/// It will be `0` for [int] and `0.0` for [double].
T _zero<T extends num>() => T == int ? 0 as T : 0.0 as T;

extension NumListConverter<T extends num> on Iterable<T>? {
  ///  how many elements == zero
  int countZeros() => countValue(_zero());

  /// * return list summation
  /// * return `null` if list is empty
  num? sumOrNull() => isBlank ? null : this!.fold(_zero(), (a, b) => a! + b);

  /// * return list summation
  /// * return `value` if list is empty
  num sumOr(num value) => sumOrNull() ?? value;

  /// * return list summation
  /// * return `0` if  isEmpty
  num sumOrZero() => sumOrNull() ?? _zero();

  /// * return the average of the list
  /// * return `null` if isEmpty
  num? averageOrNull() => isBlank ? null : (sumOrZero() / length);

  /// * return list average
  /// * return `value` if isEmpty
  num averageOr(num value) => averageOrNull() ?? value;

  /// * return the average of the list
  /// * return `0` if  isEmpty
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
  /// * return `value` if isEmpty
  num minOrZero() => minOrNull() ?? _zero();

  /// Returns the index where the min number of this list is.
  int get minIndex =>
      isBlank ? _zero() : this!.toList().indexOf(minOrZero() as T);

  /// Returns the product of all elements in the list.
  ///
  /// If the list is empty, a [StateError] is thrown with the message 'No element'.
  ///
  /// Returns the product of all elements in the list.
  ///
  /// Example:
  /// ```dart
  /// List<int> numbers = [1, 2, 3];
  /// print(numbers.prod); // Output: 6
  ///
  num? prodOrNull() => isBlank ? _zero() : this!.fold(1, (a, b) => a! * b);

  num prodOr(num value) => prodOrNull() ?? value;

  num prodOrZero() => prodOrNull() ?? _zero();

  /// Calculates the median of all elements in the list.
  ///
  /// If the list is empty, an [Exception] is thrown with the message 'List is empty'.
  ///
  /// Returns the median of all elements in the list.
  ///
  /// Example:
  /// ```dart
  /// List<int> numbers = [1, 2, 3, 4];
  /// print(numbers.median); // Output: 2.5
  /// ```
  num? medianOrNull() {
    if (isBlank) return null;

    final sorted = [...this!]..sort();

    final length = this!.length;

    if (length.isEven) {
      return (sorted[length ~/ 2 - 1] + sorted[length ~/ 2]) / 2;
    }
    return sorted[length ~/ 2];
  }

  num medianOr(num value) => medianOrNull() ?? value;

  num medianOrZero() => medianOrNull() ?? _zero();
}

/// Common extensions for iterables composed of enums
extension EnumConverter<T extends Enum> on Iterable<T> {
  /// Returns the enum in the iterable with the same name as [name], if found.
  ///
  /// Searches through the iterable to find an enum whose `name` property (obtained
  /// via `toString().split('.').last`) matches the provided [name].
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

  T? byValueOrNull(Selector<T> test) {
    for (final value in this) {
      if (test(value)) return value;
    }
    return null;
  }

  T byValueOr(Selector<T> test, T orElse) => byValueOrNull(test) ?? orElse;
}

/// Common extensions for iterables composed of more lists
extension IterableListExt<T> on Iterable<List<T>> {
  /// Returns a single list composed of each element of the lists inside.
  List<T> get flat {
    final l = <T>[];
    forEach(l.addAll);

    return l;
  }
}

extension RIterableNull<T> on List<T?> {
  /// * return the `length` without `null` elements
  void removeWhereNull() => removeWhere((e) => e == null);

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

  /// * return the `length` without `null` elements
  int countWithoutNull() {
    /// create a new list && remove elements where null
    final holder = List<T>.from(this)
      ..removeWhere((element) => element == null);

    /// return the holder elements count
    return holder.length;
  }

  /// * return the `count` of the `null` elements
  int countNull() => count((e) => e == null);
}

extension RIterableString on Iterable<String> {
  /// return counter of empty elements in the iterable
  /// does not count the null values
  int countEmpty({bool trim = true}) =>
      count((e) => trim ? e.trim().isEmpty : e.isEmpty);

  /// return counter of empty elements in the iterable
  /// does not count the null values
  int countNotEmpty() => count<String>((e) => e.trim().isNotEmpty);
}

/// provides extensions for Iterable
extension IterableScrewDriver<T> on Iterable<T>? {
  /// Returns a list containing only elements matching the given [predicate!]
  List<T> filter(bool Function(T element) test) {
    if (isBlank) return <T>[];

    final result = <T>[];
    for (final e in this!) {
      if (test(e)) result.add(e);
    }
    return result;
  }

  /// Returns a list containing all elements not matching the given [predicate!]
  List<T> filterNot(bool Function(T element) test) {
    if (isBlank) return <T>[];

    final result = <T>[];
    for (final e in this!) {
      if (!test(e)) result.add(e);
    }
    return result;
  }

  /// Returns a list containing all elements that are not null
  List<T> filterNotNull() {
    if (isBlank) return <T>[];

    final result = <T>[];
    for (final e in this!) {
      if (e != null) result.add(e);
    }
    return result;
  }

  /// Appends all elements matching the given [predicate] to
  /// the given [destination].
  Iterable<T> filterTo(List<T> destination, Selector<T> predicate) {
    if (isBlank) return <T>[];

    for (final element in this!) {
      if (predicate(element)) destination.add(element);
    }
    return destination;
  }

  /// Returns a map that contains [MapEntry]s provided by a [transform] function.
  ///
  /// If two elements share the same key, the last one gets added to the map.
  ///
  /// Example:
  /// ```dart
  /// [1, 2, 3].associate((e) => MapEntry('key_$e', e * 100)); // {'key_1': 100, 'key_2': 200, 'key_3': 300}
  /// ```
  Map<K, V> associate<K, V>(MapEntry<K, V> Function(T element) transform) {
    if (isBlank) return <K, V>{};

    return Map.fromEntries(this!.map(transform));
  }

  /// Returns a map where every element is associated by a key produced from
  /// the [selector] function.
  ///
  /// If two elements share the same key, the last one gets added to the map.
  ///
  /// Example:
  /// ```dart
  /// ['a', 'ab', 'abc'].associateBy((e) => e.length); // {1: 'a', 2: 'ab', 3: 'abc'}
  /// ```
  Map<K, T> associateBy<K>(K Function(T element) selector) {
    if (isBlank) return <K, T>{};

    final map = <K, T>{};
    for (final element in this!) {
      final key = selector(element);
      map[key] = element;
    }
    return map;
  }

  /// Returns a map where every element is used as a key that is associated
  /// with a value produced by the [selector] function.
  ///
  /// Example:
  /// ```dart
  /// [1, 2, 3].associateWith((e) => e * 1000); // {1: 1000, 2: 2000, 3: 3000}
  /// ```
  Map<T, V> associateWith<V>(V Function(T element) selector) {
    if (isBlank) return <T, V>{};

    final map = <T, V>{};
    for (final element in this!) {
      map[element] = selector(element);
    }
    return map;
  }

  Map<K, List<V>> groupBy<K, V>(
    K Function(T element) selector, {
    V Function(T element)? transform,
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
  int count<E>([Selector<T>? predicate]) {
    if (isBlank) return -1;

    if (predicate == null) return length;

    return this!.where(predicate).length;
  }

  /// Performs the given [action] on each element and returns the
  /// iterable itself afterwards.
  Iterable<T> onEach(GenericCallback<T> action) sync* {
    if (isBlank) yield* Iterable.empty();

    final it = this!.iterator;

    while (it.moveNext()) {
      action(it.current);
      yield it.current;
    }
  }

  Iterable<T> onEachIndexed(MapIndexedValue<T, void> action) sync* {
    if (isBlank) yield* Iterable.empty();

    final it = this!.iterator;
    var index = 0;

    while (it.moveNext()) {
      action(index++, it.current);
      yield it.current;
    }
  }

  /// Returns the sum of all values produced by [selector] function
  /// applied to each element in the collection.
  R? sumBy<R extends num>(Transformer<T, R> selector) =>
      this?.fold<R>(
        _zero() as R,
        (previous, element) => previous + selector(element) as R,
      ) ??
      _zero() as R;

  /// Returns the average of all values produced by [selector] function
  /// applied to each element in the collection.
  num averageBy<R extends num>(Transformer<T, R> selector) {
    if (isBlank) return _zero();

    return sumBy(selector)! / length;
  }

  /// Alias for [subtract].
  Iterable<T> except(Iterable<T> other) => subtract(other);

  /// Returns true if the collection contains all the elements
  /// present in [other] collection.
  bool containsAll(Iterable<T> other) =>
      this != null && other.every(this!.contains);

  /// Returns true if the collection doesn't contain any of the elements
  /// present in [other] collection.
  bool containsNone(Iterable<T> other) =>
      none((element) => other.contains(element));

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

extension IterableGetters<T> on Iterable<T>? {
  /// Returns this Iterable if it's not `null` and the empty list otherwise.
  Iterable<T> orEmpty() => this ?? [];

  /// Returns an element at the given [index] or `null` if the [index] is out of
  /// bounds of this collection.
  ///
  /// ```dart
  /// final list = [1, 2, 3, 4];
  /// final first = list.elementAtOrNull(0); // 1
  /// final fifth = list.elementAtOrNull(4); // null
  /// ```
  T? elementAtOrNull(int index) {
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
  /// final first = list.elementAtOrDefault(0, -1); // 1
  /// final fifth = list.elementAtOrDefault(4, -1); // -1
  /// ```
  T elementAtOr(int index, T value) => elementAtOrElse(index, (_) => value);

  /// Returns an element at the given [index] or the result of calling the
  /// [orElse] function if the [index] is out of bounds of this
  /// collection.
  ///
  /// ```dart
  /// final list = [1, 2, 3, 4];
  /// final first = list.elementAtOrElse(0); // 1
  /// final fifth = list.elementAtOrElse(4, -1); // -1
  /// ```
  T elementAtOrElse(int index, Transformer<int, T> orElse) {
    return elementAtOrNull(index) ?? orElse(index);
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
  /// final first = [1, 2, 3, 4].firstOrDefault(-1); // 1
  /// final emptyFirst = [].firstOrDefault(-1); // -1
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
  T? firstWhereOrNull(Selector<T> predicate) {
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
  /// final emptyLast = [].firstOrNull; // null
  /// ```
  T? get lastOrNull => isNotBlank ? this!.last : null;

  /// * return the last element
  /// * return `value` if isEmpty
  T lastOr(T value) => lastOrNull ?? value;

  /// Returns the last element matching the given [predicate], or `null` if no
  /// such element was found.
  T? lastWhereOrNull(Selector<T> predicate) {
    if (isBlank) return null;

    for (final element in this!.reversed) {
      if (predicate(element)) return element;
    }
    return null;
  }

  int? get lastIndex => isNotBlank ? length - 1 : null;

  /// * return the `length` of the NOT `null` elements
  int countNotNull() => count<T>((e) => e != null);

  /// counter the element of certain value
  int countValue(T value) => count<T>((e) => e == value);

  /// Returns count of elements that matches the given [predicate].
  /// Returns -1 if iterable is null
  int countWhere(Selector<T> predicate) {
    if (isBlank) return -1;

    return this!.where(predicate).length;
  }

  /// * async for each
  Future<void> loop(FutureOr<void> Function(T e) action) async {
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
  Iterable<T> getRange(int start, int end) {
    if (isBlank) return Iterable.empty();

    RangeError.checkValidRange(start, end, length);
    return this!.skip(start).take(end - start);
  }

  /// * like `map()` function but now you have the index with the element
  Iterable<E> mapWithIndex<E>(MapIndexedValue<T, E> map) sync* {
    if (isBlank) return;

    var index = 0;
    for (final value in this!) {
      yield map(index++, value);
    }
  }

  /// Return a list concatenates the output of the current list and another [iterable]
  List<T> concatWithSingleList(Iterable<T> iterable) {
    if (isBlank || iterable.isBlank) return [];

    return <T>[...this.orEmpty(), ...iterable];
  }

  /// Return a list concatenates the output of the current list and multiple [iterables]
  List<T> concatWithMultipleList(List<Iterable<T>> iterables) {
    if (isBlank || iterables.isBlank) return [];

    final list = iterables.toList(growable: false).expand((i) => i);
    return <T>[...this.orEmpty(), ...list];
  }

  /// Zip is used to combine multiple iterables into a single list that contains
  /// the combination of them two.
  Iterable<void> zip(Iterable<T>? iterable) sync* {
    if (iterable.isBlank) return;

    final iterables =
        List<Iterable<T>>.empty()
          ..add(orEmpty())
          ..add(iterable!);

    final iterators = iterables.map((e) => e.iterator).toList(growable: false);
    while (iterators.every((e) => e.moveNext())) {
      yield iterators.map((e) => e.current).toList(growable: false);
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

  /// Split one large list to limited sub lists
  /// ```dart
  /// [1, 2, 3, 4, 5, 6, 7, 8, 9].chunks(2)
  /// // => [[1, 2], [3, 4], [5, 6], [7, 8], [9]]
  /// ```
  Iterable<List<T>> chunks(int size) sync* {
    if (isBlank || size <= 0) yield List<T>.empty();

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
  /// [1, 2, 3, 4, 5, 6].chunked(2);        // [[1, 2], [3, 4], [5, 6]]
  /// [1, 2, 3].chunked(2);                 // [[1, 2], [3]]
  /// [1, 2, 3].chunked(2, fill: () => 99); // [[1, 2], [3, 99]]
  /// ```
  Iterable<List<T>> chunksOrFill(int size, {T Function()? fill}) sync* {
    if (isBlank || size <= 0) yield List<T>.empty();

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

  //   Iterable<List<T>> chunked(int size, {T Function()? fill}) {
  //   if (size <= 0) {
  //     throw ArgumentError('chunkSize must be positive integer greater than 0.');
  //   }

  //   if (isEmpty) {
  //     return const Iterable.empty();
  //   }

  //   final countOfChunks = (length / size.toDouble()).ceil();

  //   return Iterable.generate(countOfChunks, (int index) {
  //     final chunk = skip(index * size).take(size).toList();

  //     if (fill != null) {
  //       while (chunk.length < size) {
  //         chunk.add(fill());
  //       }
  //     }

  //     return chunk;
  //   });
  // }

  /// Performs the given action on each element on iterable, providing sequential index with the element.
  /// [element!] the element on the current iteration
  /// [index!] the index of the current iteration
  ///
  /// example:
  /// ["ss","tt","xx"].forEachIndexed((it, index) {
  ///    print("it, $index");
  ///  });
  /// result:
  /// ss, 0
  /// tt, 1
  /// xx, 2
  void forEachIndexed(MapIndexedValue<T, void> action) {
    if (isBlank) return;

    for (var i = 0; i < this!.length; i++) {
      action(i, this!.elementAt(i));
    }
  }

  /// Returns a list containing first [n] elements.
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
}

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

extension FicIterableExtensionTypeNullable<T> on Iterable<T?> {
  //
  /// Similar to [map], but MAY return a non-nullable type.
  ///
  /// int? f(String? e) => (e == null) ? 0 : e.length;
  ///
  /// List<int?> list1 = ["xxx", "xx", null, "x"].map(f).toList();
  /// expect(list1, isA<List<int?>>());
  ///
  /// List<int?> list2 = ["xxx", "xx", null, "x"].mapNotNull(f).toList();
  /// expect(list2, isA<List<int>>());
  Iterable<E> mapNotNull<E>(E? Function(T? e) f) => map(f).cast();
}
