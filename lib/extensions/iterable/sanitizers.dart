import 'dart:collection';

import '../../constants/constants.dart';
import '../../data_types/stack.dart';
import 'index.dart';
import 'operators.dart';

extension IterableSanitizers2<T> on Iterable<T> {
  Iterable<T> sortByAsc<E extends Comparable<E>>(E Function(T) selector) =>
      toList()..sort((a, b) => selector(a).compareTo(selector(b)));

  Iterable<T> sortByDesc<E extends Comparable<E>>(E Function(T) selector) =>
      toList()..sort((a, b) => selector(b).compareTo(selector(a)));

  /// The contrary version of [whereType]. Returns a new
  /// list composed of only the elements that are **NOT** of type [S].
  List<T> whereTypeNot<S extends T>() {
    final extracted = whereType<S>();
    return [
      for (final element in this)
        extracted.cast<T>().contains(element) ? null : element,
    ].removeNull().cast<T>();
  }

  /// Same as [whereType] but with a pair of types.
  List<T> whereTypes<S extends T, R extends T>() {
    final uniqueValues = {...whereType<S>(), ...whereType<R>()};
    final l = <T>[];
    for (final item in this) {
      if (uniqueValues.contains(item)) l.add(item);
    }
    return l;
  }

  /// Contiguous slices of `this` with the given [length].
  ///
  /// Each slice is [length] elements long, except for the last one which may be
  /// shorter if `this` contains too few elements. Each slice begins after the
  /// last one ends. The [length] must be greater than zero.
  ///
  /// For example, `{1, 2, 3, 4, 5}.slices(2)` returns `([1, 2], [3, 4], [5])`.
  Iterable<List<T>> slices(int length) sync* {
    if (length < 1) throw RangeError.range(length, 1, null, 'length');

    final iterator = this.iterator;
    while (iterator.moveNext()) {
      final slice = [iterator.current];
      for (var i = 1; i < length && iterator.moveNext(); i++) {
        slice.add(iterator.current);
      }
      yield slice;
    }
  }

  /// Returns a new list containing elements at indices between [start]
  /// (inclusive) and [end] (inclusive).
  ///
  /// If [end] is omitted, it is being set to `lastIndex`.
  List<T> slice(int start, [int end = -1]) {
    final list = this is List ? this as List<T> : toList();
    var start0 = start;
    var end0 = end;

    if (start0 < 0) start0 = start0 + list.length;

    if (end0 < 0) end0 = end0 + list.length;

    RangeError.checkValidRange(start0, end0, list.length);

    return list.sublist(start0, end0 + 1);
  }
}

extension CollectionsExtensions<T> on Iterable<T> {
  /// Convert iterable to set
  Set<T> toMutableSet() => Set.from(this);

  /// Returns a set containing all elements that are contained
  /// by both this set and the specified collection.
  Set<T> intersect(Iterable<T> other) {
    final set = this.toMutableSet()..addAll(other);
    return set;
  }

  /// Returns a list containing only elements matching the given [test].
  List<T> filter(bool Function(T element) test) {
    final result = <T>[];
    forEach((e) {
      if (e != null && test(e)) {
        result.add(e);
      }
    });
    return result;
  }

  /// Returns a list containing all elements not matching the given [test] and will filter nulls as well.
  List<T> filterNot(bool Function(T element) test) {
    final result = <T>[];
    forEach((e) {
      if (e != null && !test(e)) {
        result.add(e);
      }
    });
    return result;
  }

// return the half size of a list
  int get halfLength => (length / 2).floor();

  /// Returns a list containing first [n] elements.
  List<T> takeOnly(int n) {
    if (n == 0) return [];

    final list = List<T>.empty();
    final thisList = toList();
    final resultSize = length - n;
    if (resultSize <= 0) return [];
    if (resultSize == 1) return [last];

    List.generate(n, (index) {
      list.add(thisList[index]);
    });
    return list;
  }

  /// Returns a list containing all elements except first [n] elements.
  List<T> drop(int n) {
    if (n == 0) return [];

    final list = List<T>.empty();
    final originalList = toList();
    final resultSize = length - n;
    if (resultSize <= 0) return [];
    if (resultSize == 1) return [last];

    originalList.removeRange(0, n);

    for (final element in originalList) {
      list.add(element);
    }
    return list;
  }

  // Returns map operation as a List
  List<E> mapList<E>(E Function(T e) f) => map(f).toList();

  // Takes the first half of a list
  List<T> firstHalf() => take(halfLength).toList();

  // Takes the second half of a list
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

  ///
  /// Performs the given action on each element on iterable, providing sequential index with the element.
  /// [item] the element on the current iteration
  /// [index] the index of the current iteration
  ///
  /// example:
  /// ["a","b","c"].forEachIndexed((element, index) {
  ///    print("$element, $index");
  ///  });
  /// result:
  /// a, 0
  /// b, 1
  /// c, 2
  void forEachIndexed(MapIndexedValue<T, void> action) {
    var index = 0;
    for (final element in this) {
      action(index++, element);
    }
  }

  /// Return a number of the existing elements by a specific predicate
  /// example:
  ///  final aboveTwenty = [
  ///    User(33, "chicko"),
  ///    User(45, "ronit"),
  ///    User(19, "amsalam"),
  ///  ].count((user) => user.age > 20); // 2
  int count([Selector<T>? predicate]) {
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

  /// Returns a set containing all elements that are contained by this collection
  /// and not contained by the specified collection.
  /// The returned set preserves the element iteration order of the original collection.
  ///
  /// example:
  ///
  /// [1,2,3,4,5,6].subtract([4,5,6])
  ///
  /// result:
  /// 1,2,3
  Set<T> subtract(Iterable<T> other) {
    final set = toSet()..removeAll(other);
    return set;
  }

  /// will convert iterable into a Stack data structure
  /// example:
  ///  [1,2,3,4].toStack()
  ///  stack.pop()
  ///  stack.push(5)
  ///
  StackX<T> toStack() {
    final stack = StackX<T>()..addAll(this);
    return stack;
  }

  /// Returns an [Iterable] of the objects in this list in reverse order.
  Iterable<T> get reversed {
    return this is List<T> ? (this as List<T>).reversed : toList().reversed;
  }

  /// Returns a list containing first [n] elements.
  ///
  /// ```dart
  /// val chars = [1, 2, 3, 4, 5, 6, 7, 8, 9];
  /// print(chars.take(3)) // [1, 2, 3]
  /// print(chars.takeWhile((it) => it < 5) // [1, 2, 3, 4]
  /// print(chars.takeLast(2)) // [8, 9]
  /// print(chars.takeLastWhile((it) => it > 5 }) // [6, 7, 8, 9]
  /// ```
  List<T> takeFirst(int n) {
    final list = this is List<T> ? this as List<T> : toList();
    return list.take(n).toList();
  }

  /// Returns a list containing last [n] elements.
  ///
  /// ```dart
  /// val chars = [1, 2, 3, 4, 5, 6, 7, 8, 9];
  /// print(chars.take(3)) // [1, 2, 3]
  /// print(chars.takeWhile((it) => it < 5) // [1, 2, 3, 4]
  /// print(chars.takeLast(2)) // [8, 9]
  /// print(chars.takeLastWhile((it) => it > 5 }) // [6, 7, 8, 9]
  /// ```
  List<T> takeLast(int n) {
    final list = this is List<T> ? this as List<T> : toList();
    return list.reversed.take(n).reversed.toList();
  }

  //// Returns the first elements satisfying the given [predicate].
  ///
  /// ```dart
  /// val chars = [1, 2, 3, 4, 5, 6, 7, 8, 9];
  /// print(chars.take(3)) // [1, 2, 3]
  /// print(chars.takeWhile((it) => it < 5) // [1, 2, 3, 4]
  /// print(chars.takeLast(2)) // [8, 9]
  /// print(chars.takeLastWhile((it) => it > 5 }) // [6, 7, 8, 9]
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
  /// val chars = [1, 2, 3, 4, 5, 6, 7, 8, 9];
  /// print(chars.take(3)) // [1, 2, 3]
  /// print(chars.takeWhile((it) => it < 5) // [1, 2, 3, 4]
  /// print(chars.takeLast(2)) // [8, 9]
  /// print(chars.takeLastWhile((it) => it > 5 }) // [6, 7, 8, 9]
  /// ```
  Iterable<T> lastWhile(bool Function(T element) predicate) {
    final list = ListQueue<T>();
    for (final element in reversed) {
      if (!predicate(element)) break;
      list.addFirst(element);
    }
    return list;
  }

  /// Returns all elements matching the given [predicate].
  Iterable<T> filter(bool Function(T element) predicate) => where(predicate);

  /// Returns all elements that satisfy the given [predicate].
  Iterable<T> filterIndexed(bool Function(T element, int index) predicate) =>
      IterableWhereIndexed(this).whereIndexed(predicate);

  /// Appends all elements matching the given [predicate] to the given
  /// [destination].
  void filterTo(List<T> destination, bool Function(T element) predicate) =>
      whereTo(destination, predicate);

  /// Appends all elements matching the given [predicate] to the given
  /// [destination].
  void filterIndexedTo(
    List<T> destination,
    bool Function(T element, int index) predicate,
  ) =>
      whereIndexedTo(destination, predicate);

  /// Appends all elements not matching the given [predicate] to the given
  /// [destination].
  void filterNotTo(List<T> destination, bool Function(T element) predicate) =>
      whereNotTo(destination, predicate);

  /// Appends all elements not matching the given [predicate] to the given
  /// [destination].
  void filterNotToIndexed(
    List<T> destination,
    bool Function(T element, int index) predicate,
  ) =>
      whereNotToIndexed(destination, predicate);
}

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

extension IterableFilterNotNull<T> on Iterable<T?> {
  /// Returns a new lazy [Iterable] with all elements which are not null.
  Iterable<T> filterNotNull() => whereNotNull();

  /// Returns a new lazy [Iterable] with all elements which are not null.
  Iterable<T> whereNotNull() => where((element) => element != null).cast<T>();
}

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

  /// Returns a new lazy [Iterable] which performs the given action on each
  /// element.
  Iterable<T> onEach(void Function(T element) action) sync* {
    for (final element in this) {
      action(element);
      yield element;
    }
  }

  /// Returns a new lazy [Iterable] containing only distinct elements from the
  /// collection.
  ///
  /// The elements in the resulting list are in the same order as they were in
  /// the source collection.
  Iterable<T> distinct() sync* {
    final existing = HashSet<T>();
    for (final current in this) {
      if (existing.add(current)) {
        yield current;
      }
    }
  }

  /// Returns a new lazy [Iterable] containing only elements from the collection
  /// having distinct keys returned by the given [selector] function.
  ///
  /// The elements in the resulting list are in the same order as they were in
  /// the source collection.
  Iterable<T> distinctBy<R>(GetValue<T, R> selector) sync* {
    final existing = HashSet<R>();
    for (final current in this) {
      if (existing.add(selector(current))) {
        yield current;
      }
    }
  }

  /// Splits this collection into a new lazy [Iterable] of lists each not
  /// exceeding the given [size].
  ///
  /// The last list in the resulting list may have less elements than the given
  /// [size].
  ///
  /// [size] must be positive and can be greater than the number of elements in
  /// this collection.
  Iterable<List<T>> chunked(int size) sync* {
    if (size < 1) {
      throw ArgumentError('Requested chunk size $size is less than one.');
    }

    var currentChunk = <T>[];
    for (final current in this) {
      currentChunk.add(current);
      if (currentChunk.length >= size) {
        yield currentChunk;
        currentChunk = <T>[];
      }
    }
    if (currentChunk.isNotEmpty) {
      yield currentChunk;
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
    var currentChunk = <T>[];
    var hasPrevious = false;
    late T previous;

    for (final element in this) {
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
  /// make if [predicate] returns true for a pair of entries.
  ///
  /// For example, one could split the iterable at each changed value like this:
  /// ```dart
  /// final list = [1, 1, 1, 2, 2, 1, 4, 4];
  /// final splitted = list.splitWhen((a, b) => a != b);
  /// ```
  ///
  /// In that example, `splitted` would consist of `[1, 1, 1, 1]`, `[2, 2]`,
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
  /// The last list may have less elements than the given size.
  ///
  /// Both [size] and [step] must be positive and can be greater than the number
  /// of elements in this collection.
  Iterable<List<T>> windowed(
    int size, {
    int step = 1,
    bool partialWindows = false,
  }) sync* {
    final gap = step - size;
    if (gap >= 0) {
      var buffer = <T>[];
      var skip = 0;
      for (final element in this) {
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
      for (final element in this) {
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
  /// When it reaches the end, it jumps back to the beginning. Returns `null`
  /// [n] times if the collection is empty.
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

  Iterable<int> get indices sync* {
    var index = 0;
    while (index <= lastIndex) {
      yield index++;
    }
  }

  /// Returns a new list containing all elements except first [n] elements.
  List<T> drop(int n) {
    if (n < 0) {
      throw ArgumentError('Requested element count $n is less than zero.');
    }

    if (n == 0) toList();

    final resultSize = length - n;
    if (resultSize <= 0) return [];
    if (resultSize == 1) return [last!];

    return sublist(n);
  }

  /// Returns a new list containing all elements except last elements that
  /// satisfy the given [predicate].
  List<T> dropWhile(Selector<T> predicate) {
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
    if (n == 0) toList();

    final resultSize = length - n;
    if (resultSize <= 0) return [];
    if (resultSize == 1) return [first];
    return sublist(0, length - n);
  }

  /// Returns a new list containing all elements except last elements that
  /// satisfy the given [predicate].
  List<T> dropLastWhile(Selector<T> predicate) {
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
}

extension IterableSanitizers<T> on Iterable<T>? {
  int get length => this?.length ?? 0;

  /// Adds the [value] to the list if not in the iterable already.
  Iterable<T> putIfAbsent(T value, {Selector<T>? compare}) {
    if (isBlank) return <T>[];

    if (compare != null ? this!.any(compare) : this!.contains(value)) {
      return this!;
    } else {
      return [...this!, value];
    }
  }

  /// Adds or removes the [value] based on if the value was already
  /// in.
  List<T> toggle(T value) {
    if (isBlank) return <T>[];

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
  T? loop(int index) => this?.toList()[index % length];

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
}
