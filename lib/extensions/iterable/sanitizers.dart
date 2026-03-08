import 'dart:collection';

import '../../index.dart';

/// Sorting helpers for non-null iterables.
extension IterableSanitizers2<T> on Iterable<T> {
  /// Returns a new iterable sorted ascending by [selector].
  Iterable<T> sortByAsc<E extends Comparable<E>>(E Function(T) selector) =>
      toList()..sort((a, b) => selector(a).compareTo(selector(b)));

  /// Returns a new iterable sorted descending by [selector].
  Iterable<T> sortByDesc<E extends Comparable<E>>(E Function(T) selector) =>
      toList()..sort((a, b) => selector(b).compareTo(selector(a)));
}

/// Collection conversion and slicing helpers for non-null iterables.
extension CollectionsExtensions<T> on Iterable<T> {
  /// Convert iterable to set
  Set<T> toMutableSet() => Set.from(this);

  /// Returns a set containing all elements that are contained
  /// by both this set and the specified collection.
  Set<T> intersectSet(Iterable<T> other) {
    final set = toMutableSet()..retainAll(other);
    return set;
  }

  /// Returns `floor(length / 2)`.
  int get halfLength => (length / 2).floor();

  /// Returns a list containing first [n] elements.
  List<T> takeOnly(int n) {
    if (n <= 0) return [];

    final list = this is List<T> ? this as List<T> : toList();
    if (n >= list.length) return List<T>.from(list);
    return list.take(n).toList();
  }

  /// Returns a list containing all elements except first [n] elements.
  List<T> drop(int n) {
    final list = this is List<T> ? this as List<T> : toList();
    if (n <= 0) return List<T>.from(list);
    if (n >= list.length) return [];
    return list.sublist(n);
  }

  /// Maps each element with [f] and materializes the result as a [List].
  List<E> mapList<E>(E Function(T e) f) => map(f).toList();

  /// Returns the first half of this iterable as a list.
  List<T> firstHalf() => take(halfLength).toList();

  /// Returns the second half of this iterable as a list.
  List<T> secondHalf() => drop(halfLength).toList();

  /// returns a list with two swapped items
  /// [i] first item
  /// [j] second item
  List<T> swap(int i, int j) {
    final list = toList();
    final aux = list[i];
    list[i] = list[j];
    list[j] = aux;
    return list;
  }

  /// Returns a set containing all elements that are contained by this collection
  /// and not contained by the specified collection.
  /// The returned set preserves the element iteration order of the original collection.
  ///
  /// Example:
  /// ```dart
  /// [1, 2, 3, 4, 5, 6].subtract([4, 5, 6]); // {1, 2, 3}
  /// ```
  Set<T> subtract(Iterable<T> other) {
    final set = toSet()..removeAll(other);
    return set;
  }

  /// Converts this iterable into an [UnboundedStack] preserving iteration order.
  ///
  /// Example:
  /// ```dart
  /// final stack = [1, 2, 3, 4].toStack();
  /// stack.pop(); // 4
  /// stack.push(5);
  /// ```
  UnboundedStack<T> toStack() {
    final stack = UnboundedStack<T>()..pushAll(this);
    return stack;
  }

  /// Returns an [Iterable] of the objects in this list in reverse order.
  Iterable<T> get reversed {
    return this is List<T> ? (this as List<T>).reversed : toList().reversed;
  }

  /// Returns a list containing first [n] elements.
  ///
  /// ```dart
  /// final numbers = [1, 2, 3, 4, 5];
  /// print(numbers.takeFirst(3)); // [1, 2, 3]
  /// ```
  List<T> takeFirst(int n) {
    final list = this is List<T> ? this as List<T> : toList();
    return list.take(n).toList();
  }

  /// Returns a list containing last [n] elements.
  ///
  /// ```dart
  /// final numbers = [1, 2, 3, 4, 5];
  /// print(numbers.takeLast(2)); // [4, 5]
  /// ```
  List<T> takeLast(int n) {
    final list = this is List<T> ? this as List<T> : toList();
    return list.reversed.take(n).reversed.toList();
  }

  /// Returns the leading elements satisfying [predicate].
  ///
  /// ```dart
  /// final numbers = [2, 4, 6, 1, 8];
  /// print(numbers.firstWhile((e) => e.isEven)); // [2, 4, 6]
  /// ```
  Iterable<T> firstWhile(bool Function(T element) predicate) sync* {
    for (final element in this) {
      if (!predicate(element)) break;
      yield element;
    }
  }

  /// Returns the last elements satisfying the given [predicate].
  ///
  /// ```dart
  /// final numbers = [1, 3, 5, 6, 8];
  /// print(numbers.lastWhile((e) => e.isEven)); // [6, 8]
  /// ```
  Iterable<T> lastWhile(bool Function(T element) predicate) {
    final list = ListQueue<T>();
    for (final element in reversed) {
      if (!predicate(element)) break;
      list.addFirst(element);
    }
    return list;
  }
}

/// Predicate-based filtering helpers with optional index awareness.
extension IterableWhereIndexed<T> on Iterable<T> {
  /// Returns all elements that satisfy the given [predicate].
  Iterable<T> whereIndexed(
    bool Function(T element, int index) predicate,
  ) sync* {
    var index = 0;
    for (final element in this) {
      if (predicate(element, index++)) {
        yield element;
      }
    }
  }

  /// Appends all elements matching the given [predicate] to the given
  /// [destination].
  void whereTo(List<T> destination, bool Function(T element) predicate) {
    for (final element in this) {
      if (predicate(element)) {
        destination.add(element);
      }
    }
  }

  /// Appends all elements matching the given [predicate] to the given
  /// [destination].
  void whereIndexedTo(
    List<T> destination,
    bool Function(T element, int index) predicate,
  ) {
    var index = 0;
    for (final element in this) {
      if (predicate(element, index++)) {
        destination.add(element);
      }
    }
  }

  /// Returns all elements not matching the given [predicate].
  Iterable<T> whereNot(bool Function(T element) predicate) sync* {
    for (final element in this) {
      if (!predicate(element)) {
        yield element;
      }
    }
  }

  /// Returns all elements not matching the given [predicate].
  Iterable<T> whereNotIndexed(
    bool Function(T element, int index) predicate,
  ) sync* {
    var index = 0;
    for (final element in this) {
      if (!predicate(element, index++)) {
        yield element;
      }
    }
  }

  /// Appends all elements not matching the given [predicate] to the given
  /// [destination].
  void whereNotTo(List<T> destination, bool Function(T element) predicate) {
    for (final element in this) {
      if (!predicate(element)) {
        destination.add(element);
      }
    }
  }

  /// Appends all elements not matching the given [predicate] to the given
  /// [destination].
  void whereNotToIndexed(
    List<T> destination,
    bool Function(T element, int index) predicate,
  ) {
    var index = 0;
    for (final element in this) {
      if (!predicate(element, index++)) {
        destination.add(element);
      }
    }
  }
}

/// Null-filtering helpers for nullable iterables.
extension IterableFilterNotNull<T> on Iterable<T?> {
  /// Returns a new lazy [Iterable] with all elements which are not null.
  Iterable<T> filterNotNull() => whereNotNull();

  /// Returns a new lazy [Iterable] with all elements which are not null.
  Iterable<T> whereNotNull() => where((element) => element != null).cast<T>();
}

/// Mapping and projection helpers for non-null iterables.
extension IterableMapNotNull<T> on Iterable<T> {
  /// Returns a new lazy [Iterable] containing only the non-null results of
  /// applying the given [transform] function to each element in the original
  /// collection.
  Iterable<R> mapNotNull<R>(R? Function(T element) transform) sync* {
    for (final element in this) {
      final result = transform(element);
      if (result != null) {
        yield result;
      }
    }
  }

  /// Returns a new lazy [Iterable] containing the results of applying the
  /// given [transform] function to each element and its index in the original
  /// collection.
  Iterable<R> mapIndexed<R>(R Function(int index, T) transform) sync* {
    var index = 0;
    for (final element in this) {
      yield transform(index++, element);
    }
  }

  /// Returns a new lazy [Iterable] containing only the non-null results of
  /// applying the given [transform] function to each element and its index
  /// in the original collection.
  Iterable<R> mapIndexedNotNull<R>(R? Function(int index, T) transform) sync* {
    var index = 0;
    for (final element in this) {
      final result = transform(index++, element);
      if (result != null) {
        yield result;
      }
    }
  }

  /// Returns a new lazy [Iterable] of all elements yielded from results of
  /// [transform] function being invoked on each element of this collection.
  Iterable<R> flatMap<R>(Iterable<R> Function(T element) transform) sync* {
    for (final current in this) {
      yield* transform(current);
    }
  }

  /// Returns a new lazy [Iterable] which iterates over this collection [n]
  /// times.
  ///
  /// When it reaches the end, it jumps back to the beginning. If the
  /// collection is empty, this yields no elements.
  ///
  /// If [n] is omitted, the Iterable cycles forever.
  Iterable<T> cycle([int? n]) sync* {
    var it = iterator;
    if (!it.moveNext()) {
      return;
    }
    if (n == null) {
      yield it.current;
      // ignore: literal_only_boolean_expressions
      while (true) {
        while (it.moveNext()) {
          yield it.current;
        }
        it = iterator;
      }
    } else {
      var count = 0;
      yield it.current;
      while (count++ < n) {
        while (it.moveNext()) {
          yield it.current;
        }
        it = iterator;
      }
    }
  }

  /// Returns a new lazy [Iterable] containing all elements that are contained
  /// by both this collection and the [other] collection.
  ///
  /// The returned collection preserves the element iteration order of the
  /// this collection.
  Iterable<T> intersect(Iterable<T> other) sync* {
    final second = HashSet<T>.from(other);
    final output = HashSet<T>();
    for (final current in this) {
      if (second.contains(current)) {
        if (output.add(current)) {
          yield current;
        }
      }
    }
  }

  /// Returns a new lazy [Iterable] containing all elements of this collection
  /// except the elements contained in the given [elements] collection.
  Iterable<T> except(Iterable<T> elements) sync* {
    for (final current in this) {
      if (!elements.contains(current)) yield current;
    }
  }
}

/// Extra list-only utilities.
extension ListExtension2<T> on List<T> {
  /// Index of the first element or -1 if the collection is empty.
  ///
  /// ```dart
  /// [1, 2, 3].firstIndex; // 0
  ///
  /// [].firstIndex; // -1
  /// ```
  int get firstIndex => isNotEmpty ? 0 : -1;

  /// Index of the last element or -1 if the collection is empty.
  ///
  /// ```dart
  /// [1, 2, 3].lastIndex; // 2
  ///
  /// [].lastIndex; // -1
  /// ```
  int get lastIndex => length - 1;

  /// Iterates all valid indices of the current list in ascending order.
  Iterable<int> get indices sync* {
    var index = 0;
    while (index <= lastIndex) {
      yield index++;
    }
  }

  /// Returns a new list containing all elements except leading elements that
  /// satisfy the given [predicate].
  List<T> dropWhile(Predicate<T> predicate) {
    int? startIndex;
    for (var i = 0; i < length; i++) {
      if (!predicate(this[i])) {
        startIndex = i;
        break;
      }
    }
    if (startIndex == null) return [];
    return sublist(startIndex);
  }

  /// Returns a new list containing all elements except last [n] elements.
  List<T> dropLast(int n) {
    if (n < 0) {
      throw ArgumentError('Requested element count $n is less than zero.');
    }
    if (n == 0) return toList();

    final resultSize = length - n;
    if (resultSize <= 0) return [];
    if (resultSize == 1) return [first];
    return sublist(0, length - n);
  }

  /// Returns a new list containing all elements except last elements that
  /// satisfy the given [predicate].
  List<T> dropLastWhile(Predicate<T> predicate) {
    int? endIndex;
    for (var i = lastIndex; i >= 0; i--) {
      if (!predicate(this[i])) {
        endIndex = i;
        break;
      }
    }
    if (endIndex == null) return [];
    return sublist(0, endIndex + 1);
  }

  /// Swaps the elements in the indices provided.
  ///
  /// ```dart
  /// final list = [1, 2, 3, 4];
  /// list.swap(0, 2); // [3, 2, 1, 4]
  /// ```
  void swap(int indexA, int indexB) {
    final temp = this[indexA];
    this[indexA] = this[indexB];
    this[indexB] = temp;
  }

  /// Replaces the first element in the list that matches the [predicate]
  /// with the [newElement]. If no matching element is found, no replacement occurs.
  void replaceWhere(
    bool Function(T element) predicate, {
    T? newElement,
    T Function(T)? replaceWith,
  }) {
    if (newElement == null && replaceWith == null) return;

    final index = indexWhere(predicate);

    if (index != -1) {
      this[index] = replaceWith?.call(this[index]) ?? newElement!;
    }
  }
}

/// Utility methods for nullable iterables returning materialized collections.
extension IterableSanitizers<T> on Iterable<T>? {
  /// Returns the iterable length, or `0` when the iterable is `null`.
  int get length => this?.length ?? 0;

  /// Adds the [value] to the list if not in the iterable already.
  Iterable<T> putIfAbsent(T value, {Predicate<T>? compare}) {
    if (isBlank) return <T>[value];

    if (compare != null ? this!.any(compare) : this!.contains(value)) {
      return this!;
    } else {
      return [...this!, value];
    }
  }

  /// Adds or removes the [value] based on if the value was already
  /// in.
  List<T> toggle(T value) {
    if (isBlank) return <T>[value];

    if (this!.contains(value)) {
      final result = this!.toList()..remove(value);
      return result;
    } else {
      final result = this!.toList()..add(value);
      return result;
    }
  }

  /// Returns a new list. If `b == true` it will be reversed.
  Iterable<T> reverseIf(bool b) => b ? orEmpty().reversed : orEmpty();

  /// Returns the element at position [index] % [length].
  T? loop(int index) {
    if (isBlank) return null;

    final list = this!.toList();
    return list[index % list.length];
  }

  /// Transforms an iterable like:
  /// duplicate(3): [a,b] => [a,b,a,b,a,b]
  /// duplicate(2): [a,b] => [a,b,a,b]
  /// duplicate(1): [a,b] => [a,b]
  /// duplicate(0): [a,b] => []
  List<T> duplicate(int times) {
    if (isBlank) return <T>[];

    var l = <T>[];
    for (var i = 0; i < times; ++i) {
      l = [...l, ...this!];
    }
    return l;
  }

  /// Returns the item after [value]. If [value] is the last one, it
  /// will return the first one.
  T? after(T value) => isBlank ? null : loop(this!.toList().indexOf(value) + 1);

  /// Returns a new list with [separator] between each element.
  /// If [wrap] is true, it will add a [separator] at the beginning and
  /// at the end.
  Iterable<T> separateBy(T separator, {bool wrap = false}) {
    if (isBlank) return <T>[];

    final iterator = this!.iterator;
    if (!iterator.moveNext()) return <T>[];

    final l = [iterator.current];
    while (iterator.moveNext()) {
      l
        ..add(separator)
        ..add(iterator.current);
    }
    return (wrap ? l.wrapBy(separator) : l);
  }

  /// Returns a new list with [hugger] at the beginning and at the end.
  Iterable<T> wrapBy(T hugger) => isBlank ? <T>[] : [hugger, ...this!, hugger];

  /// Finds the first element in this iterable that satisfies a given condition,
  /// optionally restricted to a range of indices.
  ///
  /// This method walks the iterable starting at index `start` and ending at
  /// index `end` (inclusive),
  /// applying the `test` function to each element. When the `test` function
  /// returns `true` for an element, that element is returned.
  /// If no element satisfies the condition, `null` is returned.
  ///
  /// Parameters:
  /// - [test]: Function used to test whether an element satisfies the condition.
  /// - [start]: Starting index to search, defaults to 0.
  /// - [end]: Ending index to search, defaults to the iterable length minus
  ///   one, meaning the entire iterable is traversed by default.
  ///
  /// Example:
  ///
  /// ```dart
  /// List<int> numbers = [1, 2, 3, 4, 5];
  /// int? firstEven = numbers.find((element) => element % 2 == 0);
  /// print(firstEven); // Output: 2
  ///
  /// int? inRangeEven = numbers.find(
  ///   (element) => element % 2 == 0,
  ///   start: 1,
  ///   end: 4,
  /// );
  /// print(inRangeEven); // Output: 2, because 2 is the first even number in the range from 1 to 4
  /// ```
  T? find(bool Function(T) test, {int start = 0, int? end}) {
    if (isBlank) return null;

    final list = asList();
    final startIndex =
        start < 0 ? 0 : (start >= list.length ? list.length - 1 : start);
    final endValue = end ?? list.length - 1;
    final endIndex =
        endValue < 0
            ? 0
            : (endValue >= list.length ? list.length - 1 : endValue);
    if (startIndex > endIndex) return null;

    for (var i = startIndex; i <= endIndex; i++) {
      if (test(list[i])) return list[i];
    }
    return null;
  }
}
