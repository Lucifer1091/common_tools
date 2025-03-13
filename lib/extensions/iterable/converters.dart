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
  /// Calculates the sum of all elements in the list.
  ///
  /// Returns the sum of all elements in the list.
  ///
  /// Example:
  /// ```dart
  /// List<int> numbers = [1, 2, 3];
  /// print(numbers.sum); // Output: 6
  /// ```
  num get sum => isBlank ? _zero() : this!.fold(0, (a, b) => a + b);

  /// Calculates the average of all elements in the list.
  ///
  /// If the list is empty, a [StateError] is thrown with the message 'No element'.
  ///
  /// Returns the average of all elements in the list.
  ///
  /// Example:
  /// ```dart
  /// List<int> numbers = [1, 2, 3];
  /// print(numbers.average); // Output: 2.0
  /// ```
  num get average => isBlank ? _zero() : sum / this!.length;

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
  num get median {
    if (isBlank) return _zero();

    final sorted = [...this!]..sort();

    final length = this!.length;

    if (length.isEven) {
      return (sorted[length ~/ 2 - 1] + sorted[length ~/ 2]) / 2;
    }
    return sorted[length ~/ 2];
  }

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
  num get prod => isBlank ? _zero() : this!.fold(1, (a, b) => a * b);

  /// Returns max value of values.
  T get max => isBlank ? _zero() : this!.reduce(math.max);

  /// Returns min value of values.
  T get min => isBlank ? _zero() : this!.reduce(math.min);

  /// Returns the index where the min number of this list is.
  int get minIndex => this!.toList().indexOf(min);

  /// Returns the index where the max number of this list is.
  int get maxIndex => this!.toList().indexOf(max);
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

extension ListExtension4<T> on List<T> {
  /// Split one large list to limited sub lists
  /// ```dart
  /// [1, 2, 3, 4, 5, 6, 7, 8, 9].chunks(2)
  /// // => [[1, 2], [3, 4], [5, 6], [7, 8], [9]]
  /// ```
  List<List<T>> chunks(int chunkSize) {
    final chunks = <List<T>>[];
    final len = length;
    for (int i = 0; i < len; i += chunkSize) {
      final size = i + chunkSize;
      chunks.add(sublist(i, size > len ? len : size));
    }
    return chunks;
  }
}

extension RIterableNull<T> on List<T?> {
  /// * return the `length` without `null` elements
  void removeWhereNull() => removeWhere((e) => e == null);

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
  int countEmpty({bool trim = true}) => count(
        (e) => trim ? e.trim().isEmpty : e.isEmpty,
      );

  /// return counter of empty elements in the iterable
  /// does not count the null values
  int countNotEmpty() => count<String>((e) => e.trim().isNotEmpty);
}

/// provides extensions for Iterable
extension IterableScrewDriver<T> on Iterable<T> {
  /// Returns a list containing only elements matching the given [predicate!]
  List<T> filter(bool Function(T element) test) {
    if (this == null) return <T>[];
    final result = <T>[];
    for (final e in this!) {
      if (test(e)) {
        result.add(e);
      }
    }
    return result;
  }

  /// Returns a list containing all elements not matching the given [predicate!]
  List<T> filterNot(bool Function(T element) test) {
    if (this == null) return <T>[];
    final result = <T>[];
    for (final e in this!) {
      if (!test(e)) {
        result.add(e);
      }
    }
    return result;
  }

  /// Returns a list containing all elements that are not null
  List<T> filterNotNull() {
    if (this == null) return <T>[];
    final result = <T>[];
    for (final e in this!) {
      if (e != null) {
        result.add(e);
      }
    }
    return result;
  }

  /// Appends all elements matching the given [predicate] to
  /// the given [destination].
  Iterable<T> filterTo(List<T> destination, Selector<T> predicate) {
    for (final element in this) {
      if (predicate(element)) destination.add(element);
    }
    return destination;
  }

  /// Alias for [associate].
  /// Returns a [Map] containing key-value pairs provided by [transform]
  /// function applied to elements of the given List.
  Map<K, V> toMap<K, V>((K, V) Function(T element) transform) =>
      associate<K, V>(transform);

  /// Returns a [Map] containing key-value pairs provided by [transform]
  /// function applied to elements of the given List.
  Map<K, V> associate<K, V>((K, V) Function(T element) transform) =>
      associateTo(<K, V>{}, transform);

  /// Populates and returns the [destination] map with key-value pairs
  /// provided by [transform] function applied to each element
  /// of the given iterable.
  Map<K, V> associateTo<K, V>(
    Map<K, V> destination,
    (K, V) Function(T element) transform,
  ) {
    for (final element in this) {
      destination + transform(element);
    }
    return destination;
  }

  /// Returns a [Map] containing the elements from the given List
  /// indexed by the key returned from [selector] function applied
  /// to each element.
  Map<K, T> associateBy<K>(GetValue<T, K> selector) =>
      associateByTo(<K, T>{}, selector);

  /// Populates and returns the [destination] mutable map with key-value pairs,
  /// where key is provided by the [selector] function applied to each
  /// element of the given iterable and value is the element itself.
  Map<K, T> associateByTo<K>(Map<K, T> destination, GetValue<T, K> selector) =>
      {for (final element in this) selector(element): element};

  /// Returns a [Map] where keys are elements from the given iterable
  /// and values are produced by the [selector] function
  /// applied to each element.
  Map<T, V> associateWith<V>(GetValue<T, V> selector) =>
      associateWithTo(<T, V>{}, selector);

  /// Populates and returns the [destination] map with key-value
  /// pairs for each element of the given iterable,
  /// where key is the element itself and value is provided
  /// by the [selector] function applied to that key.
  Map<T, V> associateWithTo<V>(
    Map<T, V> destination,
    GetValue<T, V> selector,
  ) =>
      {for (final element in this) element: selector(element)};

  /// Groups elements of the original iterable by the key returned by
  /// the given [selector] function applied to each element
  /// and returns a map where each group key is associated with a
  /// list of corresponding elements.
  Map<K, List<T>> groupBy<K>(GetValue<T, K> selector) =>
      groupByTo(<K, List<T>>{}, selector);

  /// Groups elements of the original iterable by the key returned by
  /// the given [selector] function applied to each element
  /// and puts to the [destination] map each group key associated
  /// with a list of corresponding elements.
  Map<K, List<T>> groupByTo<K>(
    Map<K, List<T>> destination,
    GetValue<T, K> selector,
  ) {
    for (final element in this) {
      final key = selector(element);
      destination.putIfAbsent(key, () => <T>[]).add(element);
    }
    return destination;
  }

  /// Returns an iterable containing only distinct elements from
  /// the given iterable.
  Iterable<T> distinct() => toSet().toList();

  /// Returns an iterable containing only elements from the given iterable
  /// having distinct keys returned by the given [selector] function.
  Iterable<T> distinctBy<K>(GetValue<T, K> selector) =>
      distinctByTo(<T>[], selector);

  /// Populates and returns the [destination] list with containing only
  /// elements from the given iterable having distinct keys returned by
  /// the given [selector] function.
  Iterable<T> distinctByTo<K>(List<T> destination, GetValue<T, K> selector) {
    final set = HashSet<K>();
    for (final element in this) {
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
  int count(Selector<T> predicate) {
    if (isEmpty) return 0;

    var count = 0;
    for (final element in this) {
      if (predicate(element)) ++count;
    }
    return count;
  }

  /// Accumulates value starting with [initial] value and
  /// applying [operation] from right to left to each element
  /// and current accumulator value.
  R foldRight<R>(R initial, R Function(R previous, T element) operation) {
    var accumulator = initial;
    if (isNotEmpty) {
      for (final element in toList().reversed) {
        accumulator = operation(accumulator, element);
      }
    }
    return accumulator;
  }

  /// Accumulates value starting with [initial] value and applying
  /// [operation] from right to left to each element with its index in
  /// the original list and current accumulator value.
  R foldRightIndexed<R>(
    R initial,
    R Function(int index, R previous, T element) operation,
  ) {
    var accumulator = initial;
    if (isNotEmpty) {
      for (var index = length - 1; index >= 0; index--) {
        accumulator = operation(index, accumulator, elementAt(index));
      }
    }
    return accumulator;
  }

  /// Performs the given [action] on each element and returns the
  /// iterable itself afterwards.
  Iterable<T> onEach(GenericCallback<T> action) => this..forEach(action);

  /// Returns the sum of all values produced by [selector] function
  /// applied to each element in the collection.
  R sumBy<R extends num>(GetValue<T, R> selector) => fold<R>(
        _zero() as R,
        (previous, element) => previous + selector(element) as R,
      );

  /// Returns the average of all values produced by [selector] function
  /// applied to each element in the collection.
  num averageBy<R extends num>(GetValue<T, R> selector) {
    if (isBlank) return _zero();

    return sumBy(selector) / length;
  }

  /// Alias for [subtract].
  Iterable<T> except(Iterable<T> other) => subtract(other);

  /// Returns true if the collection contains all the elements
  /// present in [other] collection.
  bool containsAll(Iterable<T> other) => other.every(contains);

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
    for (int index = 0; index < length; index++) {
      yield (index, elementAt(index));
    }
  }

  /// Finds an element where the result of [selector] matches the [query].
  /// Throws [StateError] if no element is found.
  T findBy<S>(S query, GetValue<T, S> selector) {
    for (final item in this) {
      if (selector(item) == query) return item;
    }
    throw StateError('no element found');
  }

  /// Finds an element where the result of [selector] matches the [query].
  /// Returns null if no element is found.
  T? findByOrNull<C>(C query, GetValue<T, C> selector) {
    for (final item in this) {
      if (selector(item) == query) return item;
    }
    return null;
  }

  /// Finds all elements where the result of [selector] matches the [query].
  /// Returns empty collection if no element is found.
  Iterable<T> findAllBy<S>(S query, GetValue<T, S> selector) sync* {
    for (final item in this) {
      if (selector(item) == query) yield item;
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
  T elementAtOrElse(int index, GetValue<int, T> orElse) {
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

  /// * return the `length` of the NOT `null` elements
  int countNotNull() => count((e) => e != null);

  /// counter the element of certain value
  int countValue(T value) => count((e) => e == value);

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

  // /// Returns a random element from [this].
  // /// Throws [StateError] if there are no elements in the collection.
  // T random([math.Random? random]) {
  //   if (isEmpty) throw StateError('no elements');
  //   if (length == 1) return first;
  //   return elementAt((random ?? math.Random()).nextInt(length));
  // }
  //
  // /// Returns a random element from [this]. Returns null if no elements
  // /// are present.
  // T? randomOrNull([math.Random? random]) {
  //   if (isEmpty) return null;
  //   if (length == 1) return first;
  //   return elementAt((random ?? math.Random()).nextInt(length));
  // }
  //
  // /// * return a random element from list or the e if list is empty
  // T randomOr(T e) => isEmpty ? e : random;
  //
  //
  // /// Extract random items from the list
  // List<T> randomSublist(int count) {
  //   final list = [...this]..shuffle();
  //   return list.take(count).toList();
  // }

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

    final iterables = List<Iterable<T>>.empty()
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
  Iterable<List<T>> chunks(int chunkSize) sync* {
    if (isBlank) yield List<T>.empty();

    final len = this!.length;

    for (int i = 0; i < len; i += chunkSize) {
      final start = i > len ? i - len : i;
      yield this!.skip(start).take(chunkSize).toList();
    }
  }
}

extension IterableExtensions<T> on Iterable<T>? {
  /// Returns count of elements that matches the given [predicate].
  /// Returns -1 if iterable is null
  int countWhere(Selector<T> predicate) {
    if (isBlank) return -1;

    return this!.where(predicate).length;
  }

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
    var index = 0;
    for (final element in this!) {
      action(index++, element);
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
