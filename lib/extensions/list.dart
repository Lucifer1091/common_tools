part of 'extensions.dart';

extension IterableWithIndex<T> on Iterable<T> {
  Iterable<T> sortByAsc<TSelected extends Comparable<TSelected>>(
    TSelected Function(T) selector,
  ) =>
      toList()..sort((a, b) => selector(a).compareTo(selector(b)));

  Iterable<T> sortByDesc<TSelected extends Comparable<TSelected>>(
    TSelected Function(T) selector,
  ) =>
      toList()..sort((a, b) => selector(b).compareTo(selector(a)));

  Iterable<E> mapWithIndex<E>(E Function(int index, T value) f) =>
      Iterable<int>.generate(length).map((int i) => f(i, elementAt(i)));

  // returns only distinct elements
  Iterable<T> distinctBy(Object Function(T e) getCompareValue) {
    final result = <T>[];
    forEach(
      (element) {
        if (!result.any(
          (x) => getCompareValue(x) == getCompareValue(element),
        )) {
          result.add(element);
        }
      },
    );
    return result;
  }

  T get getRandomElement {
    final random = math.Random();
    final int index = random.nextInt(length);
    return elementAt(index);
  }

  // T? firstWhereOrNull(bool Function(T element) comparator) {
  //   try {
  //     return firstWhere(comparator);
  //   } on StateError catch (_) {
  //     return null;
  //   }
  // }
}

/// Common Operations for Iterables with nullable items.
extension IterableOptionalExt<T> on Iterable<T?> {
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
}

/// Common Operations for Iterables with items.
extension IterableExt<T> on Iterable<T> {
  /// Returns a new list. If `b == true` it will be reversed.
  List<T> reverseIf(bool b) => b ? toList().reversed.toList() : toList();

  /// Returns the item after [value]. If [value] is the last one, it
  /// will return the first one.
  T after(T value) => loop(toList().indexOf(value) + 1);

  /// Returns a new list with [separator] between each element.
  /// If [wrap] is true, it will add a [separator] at the beginning and
  /// at the end.
  List<T> separateBy(T separator, {bool wrap = false}) {
    final iterator = this.iterator;
    if (!iterator.moveNext()) return [];

    final l = [iterator.current];
    while (iterator.moveNext()) {
      l
        ..add(separator)
        ..add(iterator.current);
    }
    return (wrap ? l.hugBy(separator) : l).toList();
  }

  /// Returns a new list with [hugger] at the beginning and at the end.
  Iterable<T> hugBy(T hugger) => [
        hugger,
        ...this,
        hugger,
      ];

  /// Same as [map] but providing the index too.
  Iterable<S> indexedMap<S>(S Function(T item, int index) map) {
    final iterator = this.iterator;
    if (!iterator.moveNext()) return [];

    var index = 0;
    final l = [map(iterator.current, index)];
    while (iterator.moveNext()) {
      ++index;
      l.add(map(iterator.current, index));
    }
    return l;
  }

  /// Adds the [value] to the list if not in the iterable already.
  Iterable<T> putIfAbsent(
    T value, {
    BoolCallback<T>? equalityBuilder,
  }) {
    final containsValue =
        equalityBuilder != null ? any(equalityBuilder) : contains(value);
    if (containsValue) {
      return this;
    } else {
      return [...this, value];
    }
  }

  /// Adds or removes the [value] based on if the value was already
  /// in.
  List<T> toggle(T value) {
    if (contains(value)) {
      final result = toList()..remove(value);
      return result;
    } else {
      final result = toList()..add(value);
      return result;
    }
  }

  /// Returns `true` if the iterable is has an element of type [S].
  bool anyType<S extends T>() => whereType<S>().isNotEmpty;

  /// Extract one random item from the list
  T random() => toList()[math.Random().nextInt(length)];

  /// Extract random items from the list
  List<T> randomSublist(int count) {
    final list = [...this]..shuffle();
    return list.take(count).toList();
  }

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

  /// The first element satisfying [test], or `null` if there are none.
  T? firstWhereOrNull(bool Function(T element) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }

  /// Returns a map grouped by the [keyFunction].
  Map<K, List<T>> groupBy<K>(K Function(T) keyFunction) => fold(
        <K, List<T>>{},
        (Map<K, List<T>> map, T element) =>
            map..putIfAbsent(keyFunction(element), () => <T>[]).add(element),
      );

  /// Returns the element at position [index] % [length].
  T loop(int index) => toList()[index % length];

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

  // /// Returns a new list containing elements at indices between [start]
  // /// (inclusive) and [end] (inclusive).
  // ///
  // /// If [end] is omitted, it is being set to `lastIndex`.
  // List<T> slice(int start, [int end = -1]) {
  //   final list = this is List ? this as List<T> : toList();
  //   var start0 = start;
  //   var end0 = end;

  //   if (start0 < 0) {
  //     start0 = start0 + list.length;
  //   }
  //   if (end0 < 0) {
  //     end0 = end0 + list.length;
  //   }

  //   RangeError.checkValidRange(start0, end0, list.length);

  //   return list.sublist(start0, end0 + 1);
  // }

  /// Transforms an iterable like:
  /// duplicate(3): [a,b] => [a,b,a,b,a,b]
  /// duplicate(2): [a,b] => [a,b,a,b]
  /// duplicate(1): [a,b] => [a,b]
  /// duplicate(0): [a,b] => []
  List<T> duplicate(int x) {
    var l = <T>[];
    for (var i = 0; i < x; ++i) {
      l = [...l, ...this];
    }
    return l;
  }
}

/// Common extensions for iterables composed of numbers
extension IterableNumExt on Iterable<num> {
  /// Returns the max number of this list.
  num get max {
    num? x;
    for (final item in this) {
      if (x == null) {
        x = item;
        continue;
      }
      if (item > x) x = item;
    }
    return x ?? 0;
  }

  /// Returns the min number of this list.
  num get min {
    num? x;
    for (final item in this) {
      if (x == null) {
        x = item;
        continue;
      }
      if (item < x) x = item;
    }
    return x ?? 0;
  }

  /// Returns the index where the max number of this list is.
  int get minIndex => toList().indexOf(min);

  /// Returns the index where the min number of this list is.
  int get maxIndex => toList().indexOf(max);
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

/// Common extensions for iterables composed of enums
extension EnumByName<T extends Enum> on Iterable<T> {
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
}

extension MyIterable<T> on Iterable<T>? {
  /// Returns `true` if this nullable iterable is either `null` or empty.
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  /// Returns `false` if this nullable iterable is either `null` or empty.
  bool get isNotNullOrEmpty => this != null && this!.isNotEmpty;

  T? get firstOrNull => isNullOrEmpty ? null : this!.first;

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

  // Gets an element at specific index or returns `null`
  T? elementAtOrNull(int index) {
    if (isNullOrEmpty) {
      return null;
    }
    if (index < this!.length) {
      return this!.elementAt(index);
    } else {
      return null;
    }
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

/*  /// Returns a list containing only elements matching the given [predicate]
  void filter(bool Function(T e) fun) {
    if (isNullOrEmpty) {
       return;
    }
    final result = <T>[];
    for (var element in this!) {
      if (fun(element)) this?.remove(element);
    }
  }*/

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
  ///convert List to List of widget
  List<Widget> toWidgetList(Widget Function(T value) mapFunc) =>
      isNullOrEmpty ? [] : [...this!.map(mapFunc)];

  bool get isNullOrEmpty => this == null || (this?.isEmpty ?? true);

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

/*
///On List Of String Extension
extension CollectionStringExtension<T extends String> on List<T> {
  String joinToString(String separator,
      {String prefix = "", String postfix = ""}) {
    return prefix + this.join(separator) + postfix;
  }
}

///On List Of num Extension
extension CollectionNumExtension<T extends num> on List<T> {
  T max() {
    if (this.isNullOrEmpty()) throw Exception("Provide collection with items");
    this.sort();
    return this[this.length - 1];
  }

  T min() {
    if (this.isNullOrEmpty()) throw Exception("Provide collection with items");
    this.sort();
    return this[0];
  }

  double avg() {
    if (this.isNullOrEmpty()) throw Exception("Provide collection with items");
    return this.reduce((value, element) => value + element) / this.length;
  }
}
 */

// This Dart file defines an extension called StringExtension on List objects.
extension ListExtension<T> on List<T> {
  // This method groups the elements in the List by a specified key function.
  Map<K, List<T>> groupBy<K>(K Function(T) keyFunction) => fold(
        <K, List<T>>{},
        (Map<K, List<T>> map, T element) =>
            map..putIfAbsent(keyFunction(element), () => <T>[]).add(element),
      );

  // This getter checks if the List contains exactly one element.
  bool get isSingle => length == 1;
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

extension IntList<T extends num> on Iterable<T> {
  /// Calculates the sum of all elements in the list.
  ///
  /// If the list is empty, a [StateError] is thrown with the message 'No element'.
  ///
  /// Returns the sum of all elements in the list.
  ///
  /// Example:
  /// ```dart
  /// List<int> numbers = [1, 2, 3];
  /// print(numbers.sum); // Output: 6
  /// ```
  num get sum => length == 0
      ? throw StateError('No element')
      : fold(0, (current, next) => current + next);

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
  num get average =>
      length == 0 ? throw StateError('No element') : sum / length;

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
    if (length == 0) {
      throw Exception('List is empty');
    }
    final sorted = [...this]..sort();

    if (length.isEven) {
      return (sorted[length ~/ 2 - 1] + sorted[length ~/ 2]) / 2;
    }
    return sorted[length ~/ 2];
  }

  /// Returns the maximum value in the list.
  ///
  /// If the list is empty, a [StateError] is thrown with the message 'No element'.
  ///
  /// Returns the maximum value in the list.
  ///
  /// Example:
  /// ```dart
  /// List<int> numbers = [1, 2, 3];
  /// print(numbers.max); // Output: 3
  /// ```
  T get max => length == 0
      ? throw StateError('No element')
      : reduce((curr, next) => curr > next ? curr : next);

  /// Returns the minimum value in the list.
  ///
  /// If the list is empty, a [StateError] is thrown with the message 'No element'.
  ///
  /// Returns the minimum value in the list.
  ///
  /// Example:
  /// ```dart
  /// List<int> numbers = [1, 2, 3];
  /// print(numbers.min); // Output: 1
  /// ```
  T get min => length == 0
      ? throw StateError('No element')
      : reduce((curr, next) => curr < next ? curr : next);

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
  num get prod => length == 0
      ? throw StateError('No element')
      : fold(1, (current, next) => current * next);
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

extension IterableExtensions<T> on Iterable<T>? {
  /// Returns `true` if at least one element matches the given [predicate].
  // bool any(bool Function(T element) predicate) {
  //   if (isNullOrEmpty) return false;
  //   for (final element in this!) {
  //     if (predicate(element)) return true;
  //   }
  //   return false;
  // }

  /// Returns count of elements that matches the given [predicate].
  /// Returns -1 if iterable is null
  int countWhere(bool Function(T element) predicate) {
    if (this == null) return -1;
    return this!.where(predicate).length;
  }

  /// Convert iterable to set
  Set<T> toSet() => Set.from(this!);

  /// Returns a set containing all elements that are contained
  /// by both this set and the specified collection.
  Set<T> intersect(Iterable<T> other) => toSet()..retainAll(other);

  /// Returns a set containing all elements that are contained
  /// by this collection and not contained by the specified collection.
  Set<T> subtract(Iterable<T> other) => toSet()..removeAll(other);

  /// Returns a set containing all distinct elements from both collections.
  Set<T> union(Iterable<T> other) => toSet()..addAll(other);

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
  void forEachIndexed(void Function(T element, int index) action) {
    var index = 0;
    for (final element in this!) {
      action(element, index++);
    }
  }

  /// Groups elements of the original collection by the key returned by the given [keySelector] function
  /// applied to each element and returns a map where each group key is associated with a list of corresponding elements.
  ///
  /// The returned map preserves the entry iteration order of the keys produced from the original collection.
  Map<K, List<R>> groupBy<R, K>(K Function(R e) keySelector) {
    if (this == null) return {};
    final map = <K, List<R>>{};

    for (final element in this!) {
      map.putIfAbsent(keySelector(element as R), () => []).add(element);
    }
    return map;
  }

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

  /// Returns first element by given predicate or null otherwise
  T? firstWhereOrNull(bool Function(T element) test) {
    if (this == null) return null;
    final list = this!.where(test);
    return list.isEmpty ? null : list.first;
  }
}

/// Supercharged extensions on [Iterable<double>] like [List<double>] and [Set<double>].
extension IterableOfDoubleSC on Iterable<double> {
  /// Deprecation hint: Read the
  /// [migration guide](https://github.com/felixblaschke/supercharged/blob/master/migration_v2.md)
  /// for more details on migrating.
  ///
  /// Returns the sum of all elements.
  ///
  /// Example:
  /// ```dart
  /// [2.0, 6.0, 4.0, 8.0].sum(); // 20.0
  /// ```
  @Deprecated(
    'Dart natively supports this function. Read DartDoc comment for more info.',
  )
  double sumSC() => sumByDouble((n) => n);

  /// Deprecation hint: Read the
  /// [migration guide](https://github.com/felixblaschke/supercharged/blob/master/migration_v2.md)
  /// for more details on migrating.
  ///
  /// Returns the average value (arithmetic mean) of all elements.
  /// If collection is empty this returns `null`.
  ///
  /// Example:
  /// ```dart
  /// [2.0, 4.0, 6.0, 8.0].average(); // 5.0
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
  /// [9.0, 42.0, 3.0].max(); // 42.0
  /// ```
  double? max() => maxBy((a, b) => a.compareTo(b));

  /// Returns the lowest value of all elements
  /// If collection is empty this returns `null`.
  ///
  /// Example:
  /// ```dart
  /// [17.0, 13.0, 92.0].min(); // 13.0
  /// ```
  double? min() => minBy((a, b) => a.compareTo(b));
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

/// Function that returns `true` if element passes test.
typedef TestPredicate<E> = bool Function(E element);

/// Function that gets value [T] for that element.
typedef GetValue<E, T> = T Function(E element);

/// Function that returns value [T] for the element and index
typedef MapIndexedValue<E, T> = T Function(E element, int index);

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

extension NullableIterableExtensions<E> on Iterable<E>? {
  // // Common - Equality
  //
  // /// Returns `true` if iterable is `null` or empty.
  // bool get isNullOrEmpty {
  //   return this?.isEmpty ?? true;
  // }
  //
  // /// Returns `true` if iterable is not `null` and not empty.
  // bool get isNotNullOrEmpty {
  //   return this?.isNotEmpty ?? false;
  // }
}

/// Extension methods for [Iterable] of num.
extension NumIterableExtensions<E extends num> on Iterable<E> {
  // Math

  /// Returns max value of values.
  E max() => isEmpty ? _zero() : reduce(math.max);

  /// Returns min value of values.
  E min() => isEmpty ? _zero() : reduce(math.min);
}

extension BigIntIterableExtension on Iterable<BigInt> {
  /// Returns max value of values.
  BigInt min() {
    final min = isEmpty
        ? BigInt.zero
        : reduce((value, element) => value < element ? value : element);
    return min;
  }

  /// Returns min value of values.
  BigInt max() {
    final max = isEmpty
        ? BigInt.zero
        : reduce((value, element) => value > element ? value : element);
    return max;
  }
}

extension IterableExtension<E> on Iterable<E> {
  BigInt sumOfBigInt(GetValue<E, BigInt> getVal) =>
      fold(BigInt.zero, (sum, e) => sum + getVal(e));
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

/// Returns zero value for num, depends on required type.
///
/// It will be `0` for [int] and `0.0` for [double].
T _zero<T extends num>() => T == int ? 0 as T : 0.0 as T;

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

extension IterableExtension2<T> on Iterable<T> {
  /// Split one large list to limited sub lists
  /// ```dart
  /// [1, 2, 3, 4, 5, 6, 7, 8, 9].chunks(2)
  /// // => [[1, 2], [3, 4], [5, 6], [7, 8], [9]]
  /// ```
  Iterable<List<T>> chunks(int chunkSize) sync* {
    final len = length;

    for (int i = 0; i < len; i += chunkSize) {
      final start = i > len ? i - len : i;
      yield skip(start).take(chunkSize).toList();
    }
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

// /// Utility extension methods for the native [Iterable] class.
// extension IterableBasics<E> on Iterable<E> {
//   /// Alias for [Iterable]`.every`.
//   bool all(bool Function(E) test) => every(test);
//
//   /// Returns `true` if no element of [this] satisfies [test].
//   ///
//   /// Example:
//   /// ```dart
//   /// [1, 2, 3].none((e) => e > 4); // true
//   /// [1, 2, 3].none((e) => e > 2); // false
//   /// ```
//   bool none(bool Function(E) test) => !any(test);
//
//   /// Returns `true` if there is exactly one element of [this] which satisfies
//   /// [test].
//   ///
//   /// Example:
//   /// ```dart
//   /// [1, 2, 3].one((e) => e == 2); // 1 element satisfies. Returns true.
//   /// [1, 2, 3].one((e) => e > 4); // No element satisfies. Returns false.
//   /// [1, 2, 3].one((e) => e > 1); // >1 element satisfies. Returns false.
//   /// ```
//   bool one(bool Function(E) test) {
//     bool foundOne = false;
//     for (var e in this) {
//       if (test(e)) {
//         if (foundOne) return false;
//         foundOne = true;
//       }
//     }
//     return foundOne;
//   }
//
//   /// Returns `true` if [this] contains at least one element also contained in
//   /// [other].
//   ///
//   /// Example:
//   /// ```dart
//   /// [1, 2, 3].containsAny([5, 2]); // true
//   /// [1, 2, 3].containsAny([4, 5, 6]); // false
//   /// ```
//   bool containsAny(Iterable<E> other) => any(other.contains);
//
//   /// Returns true if every element in [other] also exists in [this].
//   ///
//   /// Example:
//   /// ```dart
//   /// [1, 2, 3].containsAll([1, 2]); // true
//   /// [1, 2].containsAll([1, 2, 3]); // false
//   /// ```
//   ///
//   /// If [collapseDuplicates] is true, only the presence of a value will be
//   /// considered, not the number of times it occurs. If [collapseDuplicates] is
//   /// false, the number of occurrences of a given value in [this] must be
//   /// greater than or equal to the number of occurrences of that value in
//   /// [other] for the result to be true.
//   ///
//   /// Example:
//   /// ```
//   /// [1, 2, 3].containsAll([1, 1, 1, 2]); // true
//   /// [1, 2, 3].containsAll([1, 1, 1, 2], collapseDuplicates: false); // false
//   /// [1, 1, 2, 3].containsAll([1, 1, 2], collapseDuplicates: false); // true
//   /// ```
//   bool containsAll(Iterable<E> other, {bool collapseDuplicates = true}) {
//     if (other.isEmpty) return true;
//     if (collapseDuplicates) {
//       return Set<E>.from(this).containsAll(Set<E>.from(other));
//     }
//
//     final thisElementCounts = _elementCountsIn<E>(this);
//     final otherElementCounts = _elementCountsIn<E>(other);
//
//     for (final element in otherElementCounts.keys) {
//       final countInThis = thisElementCounts[element] ?? 0;
//       final countInOther = otherElementCounts[element] ?? 0;
//       if (countInThis < countInOther) {
//         return false;
//       }
//     }
//     return true;
//   }
//
//   /// Returns the greatest element of [this] as ordered by [compare], or [null]
//   /// if [this] is empty.
//   ///
//   /// Example:
//   /// ```dart
//   /// ['a', 'aaa', 'aa']
//   ///   .max((a, b) => a.length.compareTo(b.length)).value; // 'aaa'
//   /// ```
//   E? max(Comparator<E> compare) =>
//       isEmpty ? null : reduce(_generateCustomMaxFunction<E>(compare));
//
//   /// Returns the smallest element of [this] as ordered by [compare], or [null]
//   /// if [this] is empty.
//   ///
//   /// Example:
//   /// ```dart
//   /// ['a', 'aaa', 'aa']
//   ///   .min((a, b) => a.length.compareTo(b.length)).value; // 'a'
//   /// ```
//   E? min(Comparator<E> compare) =>
//       isEmpty ? null : reduce(_generateCustomMinFunction<E>(compare));
//
//   /// Returns the element of [this] with the greatest value for [sortKey], or
//   /// [null] if [this] is empty.
//   ///
//   /// This method is guaranteed to calculate [sortKey] only once for each
//   /// element.
//   ///
//   /// Example:
//   /// ```dart
//   /// ['a', 'aaa', 'aa'].maxBy((e) => e.length).value; // 'aaa'
//   /// ```
//   E? maxBy(Comparable<dynamic> Function(E) sortKey) {
//     final sortKeyCache = <E, Comparable<dynamic>>{};
//     return this.max((a, b) => sortKeyCompare<E>(a, b, sortKey, sortKeyCache));
//   }
//
//   /// Returns the element of [this] with the least value for [sortKey], or
//   /// [null] if [this] is empty.
//   ///
//   /// This method is guaranteed to calculate [sortKey] only once for each
//   /// element.
//   ///
//   /// Example:
//   /// ```dart
//   /// ['a', 'aaa', 'aa'].minBy((e) => e.length).value; // 'a'
//   /// ```
//   E? minBy(Comparable<dynamic> Function(E) sortKey) {
//     final sortKeyCache = <E, Comparable<dynamic>>{};
//     return this.min((a, b) => sortKeyCompare<E>(a, b, sortKey, sortKeyCache));
//   }
//
//   /// Returns the sum of all the values in this iterable, as defined by
//   /// [addend].
//   ///
//   /// Returns 0 if [this] is empty.
//   ///
//   /// Example:
//   /// ```dart
//   /// ['a', 'aa', 'aaa'].sum((s) => s.length); // 6
//   /// ```
//   num sum(num Function(E) addend) => isEmpty
//       ? 0
//       : fold(0, (prev, element) => prev + addend(element));
//
//   /// Returns the average of all the values in this iterable, as defined by
//   /// [value].
//   ///
//   /// Returns null if [this] is empty.
//   ///
//   /// Example:
//   /// ```dart
//   /// ['a', 'aa', 'aaa'].average((s) => s.length); // 2
//   /// [].average(); // null
//   /// ```
//   num? average(num Function(E) value) {
//     if (isEmpty) return null;
//
//     return this.sum(value) / length;
//   }
//
//   /// Returns a random element of [this], or [null] if [this] is empty.
//   ///
//   /// If [seed] is provided, will be used as the random seed for determining
//   /// which element to select. (See [math.Random].)
//   E? getRandom({int? seed}) => isEmpty
//       ? null
//       : elementAt(math.Random(seed).nextInt(length));
//
//   /// Returns an [Iterable] containing the first [end] elements of [this],
//   /// excluding the first [start] elements.
//   ///
//   /// This method is a generalization of [List.getRange] to [Iterable]s,
//   /// and obeys the same contract.
//   ///
//   /// Example:
//   /// ```dart
//   /// {3, 8, 12, 4, 1}.range(2, 4); // [12, 4]
//   /// ```
//   Iterable<E> getRange(int start, int end) {
//     RangeError.checkValidRange(start, end, length);
//     return skip(start).take(end - start);
//   }
// }
//
// /// Utility extension methods for [Iterable]s containing [num]s.
// extension NumIterableBasics<E extends num> on Iterable<E> {
//   /// Returns the greatest number in [this], or [null] if [this] is empty.
//   ///
//   /// Example:
//   /// ```dart
//   /// [104, 3, 18].max().value; // 104
//   /// ```
//   ///
//   /// If [compare] is provided, it will be used to order the elements.
//   ///
//   /// Example:
//   /// ```dart
//   /// [-47, 10, 2].max((a, b) =>
//   ///     a.toString().length.compareTo(b.toString().length)).value; // -47
//   /// ```
//   E? max([Comparator<E>? compare]) => isEmpty
//       ? null
//       : reduce(
//           compare == null ? math.max : _generateCustomMaxFunction<E>(compare));
//
//   /// Returns the least number in [this], or [null] if [this] is empty.
//   ///
//   /// Example:
//   /// ```dart
//   /// [104, 3, 18].min().value; // 3
//   /// ```
//   ///
//   /// If [compare] is provided, it will be used to order the elements.
//   ///
//   /// Example:
//   /// ```dart
//   /// [-100, -200, 5].min((a, b) =>
//   ///     a.toString().length.compareTo(b.toString().length)).value; // 5
//   /// ```
//   E? min([Comparator<E>? compare]) => isEmpty
//       ? null
//       : reduce(
//           compare == null ? math.min : _generateCustomMinFunction<E>(compare));
//
//   /// Returns the sum of all the values in this iterable.
//   ///
//   /// If [addend] is provided, it will be used to compute the value to be
//   /// summed.
//   ///
//   /// Returns 0 if [this] is empty.
//   ///
//   /// Example:
//   /// ```dart
//   /// [1, 2, 3].sum(); // 6.
//   /// [2, 3, 4].sum((i) => i * 0.5); // 4.5.
//   /// [].sum() // 0.
//   /// ```
//   num sum([num Function(E)? addend]) {
//     if (isEmpty) return 0;
//     return addend == null
//         ? reduce((a, b) => (a + b) as E)
//         : fold(0, (prev, element) => prev + addend(element));
//   }
//
//   /// Returns the average of all the values in this iterable.
//   ///
//   /// If [value] is provided, it will be used to compute the value to be
//   /// averaged.
//   ///
//   /// Returns null if [this] is empty.
//   ///
//   /// Example:
//   /// ```dart
//   /// [2, 2, 4, 8].average(); // 4.
//   /// [2, 2, 4, 8].average((i) => i + 1); // 5.
//   /// [].average() // null.
//   /// ```
//   num? average([num Function(E)? value]) {
//     if (isEmpty) return null;
//
//     return this.sum(value) / length;
//   }
// }
//
// T Function(T, T) _generateCustomMaxFunction<T>(Comparator<T> compare) {
//   T max(T a, T b) {
//     if (compare(a, b) >= 0) return a;
//     return b;
//   }
//
//   return max;
// }
//
// T Function(T, T) _generateCustomMinFunction<T>(Comparator<T> compare) {
//   T min(T a, T b) {
//     if (compare(a, b) <= 0) return a;
//     return b;
//   }
//
//   return min;
// }
//
// Map<E, int> _elementCountsIn<E>(Iterable<E> iterable) {
//   final counts = <E, int>{};
//   for (final element in iterable) {
//     final currentCount = counts[element] ?? 0;
//     counts[element] = currentCount + 1;
//   }
//   return counts;
// }

///

// Copyright (c) 2019, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// import 'dart:math' as math;
//
// import 'src/slice_indices.dart';
// import 'src/sort_key_compare.dart';
//
// /// Utility extension methods for the native [List] class.
// extension ListBasics<E> on List<E> {
//   /// Returns a new list containing the elements of [this] from [start]
//   /// inclusive to [end] exclusive, skipping by [step].
//   ///
//   /// Example:
//   /// ```dart
//   /// [1, 2, 3, 4].slice(start: 1, end: 3); // [2, 3]
//   /// [1, 2, 3, 4].slice(start: 1, end: 4, step: 2); // [2, 4]
//   /// ```
//   ///
//   /// [start] defaults to the first element if [step] is positive and to the
//   /// last element if [step] is negative. [end] does the opposite.
//   ///
//   /// Example:
//   /// ```dart
//   /// [1, 2, 3, 4].slice(end: 2); // [1, 2]
//   /// [1, 2, 3, 4].slice(start: 1); // [2, 3, 4]
//   /// [1, 2, 3, 4].slice(end: 1, step: -1); // [4, 3]
//   /// [1, 2, 3, 4].slice(start: 2, step: -1); // [3, 2, 1]
//   /// ```
//   ///
//   /// If [start] or [end] is negative, it will be counted backwards from the
//   /// last element of [this]. If [step] is negative, the elements will be
//   /// returned in reverse order.
//   ///
//   /// Example:
//   /// ```dart
//   /// [1, 2, 3, 4].slice(start: -2); // [3, 4]
//   /// [1, 2, 3, 4].slice(end: -1); // [1, 2, 3]
//   /// [1, 2, 3, 4].slice(step: -1); // [4, 3, 2, 1]
//   /// ```
//   ///
//   /// Any out-of-range values for [start] or [end] will be truncated to the
//   /// maximum in-range value in that direction.
//   ///
//   /// Example:
//   /// ```dart
//   /// [1, 2, 3, 4].slice(start: -100); // [1, 2, 3, 4]
//   /// [1, 2, 3, 4].slice(end: 100); // [1, 2, 3, 4]
//   /// ```
//   ///
//   /// Will return an empty list if [start] and [end] are equal, [start] is
//   /// greater than [end] while [step] is positive, or [end] is greater than
//   /// [start] while [step] is negative.
//   ///
//   /// Example:
//   /// ```dart
//   /// [1, 2, 3, 4].slice(start: 1, end: -3); // []
//   /// [1, 2, 3, 4].slice(start: 3, end: 1); // []
//   /// [1, 2, 3, 4].slice(start: 1, end: 3, step: -1); // []
//   /// ```
//   List<E> slice({int? start, int? end, int step = 1}) {
//     final indices = sliceIndices(start, end, step, this.length);
//     if (indices == null) {
//       return <E>[];
//     }
//
//     final _start = indices.start;
//     final _end = indices.end;
//     final slice = <E>[];
//
//     if (step > 0) {
//       for (var i = _start; i < _end; i += step) {
//         slice.add(this[i]);
//       }
//     } else {
//       for (var i = _start; i > _end; i += step) {
//         slice.add(this[i]);
//       }
//     }
//     return slice;
//   }
//
//   /// Returns a sorted copy of this list.
//   List<E> sortedCopy() {
//     return List<E>.of(this)..sort();
//   }
//
//   /// Sorts this list by the value returned by [sortKey] for each element.
//   ///
//   /// This method is guaranteed to calculate [sortKey] only once for each
//   /// element.
//   ///
//   /// Example:
//   /// ```dart
//   /// var list = [-12, 3, 10];
//   /// list.sortBy((e) => e.toString().length); // list is now [3, 10, -12].
//   /// ```
//   void sortBy(Comparable<dynamic> Function(E) sortKey) {
//     final sortKeyCache = <E, Comparable<dynamic>>{};
//     this.sort((a, b) => sortKeyCompare(a, b, sortKey, sortKeyCache));
//   }
//
//   /// Returns a copy of this list sorted by the value returned by [sortKey] for
//   /// each element.
//   ///
//   /// This method is guaranteed to calculate [sortKey] only once for each
//   /// element.
//   ///
//   /// Example:
//   /// ```dart
//   /// var list = [-12, 3, 10];
//   /// var sorted = list.sortedCopyBy((e) => e.toString().length);
//   /// // list is still [-12, 3, 10]. sorted is [3, 10, -12].
//   /// ```
//   List<E> sortedCopyBy(Comparable<dynamic> Function(E) sortKey) {
//     return List<E>.of(this)..sortBy(sortKey);
//   }
//
//   /// Removes a random element of [this] and returns it.
//   ///
//   /// Returns [null] if [this] is empty.
//   ///
//   /// If [seed] is provided, will be used as the random seed for determining
//   /// which element to select. (See [math.Random].)
//   E? takeRandom({int? seed}) => this.isEmpty
//       ? null
//       : this.removeAt(math.Random(seed).nextInt(this.length));
// }

///

// import 'dart:math' as math;
//
// /// Utility extension methods for the native [Set] class.
// extension SetBasics<E> on Set<E> {
//   /// Returns `true` if [this] and [other] contain exactly the same elements.
//   ///
//   /// Example:
//   /// ```dart
//   /// var set = {'a', 'b', 'c'};
//   /// set.isEqualTo({'b', 'a', 'c'}); // true
//   /// set.isEqualTo({'b', 'a', 'f'}); // false
//   /// set.isEqualTo({'a', 'b'}); // false
//   /// set.isEqualTo({'a', 'b', 'c', 'd'}); // false
//   /// ```
//   bool isEqualTo(Set<Object> other) =>
//       this.length == other.length && this.containsAll(other);
//
//   /// Returns `true` if [this] and [other] have no elements in common.
//   ///
//   /// Example:
//   /// ```dart
//   /// var set = {'a', 'b', 'c'};
//   /// set.isDisjointWith({'d', 'e', 'f'}); // true
//   /// set.isDisjointWith({'d', 'e', 'b'}); // false
//   /// ```
//   bool isDisjointWith(Set<Object> other) => this.intersection(other).isEmpty;
//
//   /// Returns `true` if [this] and [other] have at least one element in common.
//   ///
//   /// Example:
//   /// ```dart
//   /// var set = {'a', 'b', 'c'};
//   /// set.isIntersectingWith({'d', 'e', 'b'}); // true
//   /// set.isIntersectingWith({'d', 'e', 'f'}); // false
//   /// ```
//   bool isIntersectingWith(Set<Object> other) =>
//       this.intersection(other).isNotEmpty;
//
//   /// Returns `true` if every element of [this] is contained in [other].
//   ///
//   /// Example:
//   /// ```dart
//   /// var set = {'a', 'b', 'c'};
//   /// set.isSubsetOf({'a', 'b', 'c', 'd'}); // true
//   /// set.isSubsetOf({'a', 'b', 'c'}); // true
//   /// set.isSubsetOf({'a', 'b', 'f'}); // false
//   /// ```
//   bool isSubsetOf(Set<Object> other) =>
//       this.length <= other.length && other.containsAll(this);
//
//   /// Returns `true` if every element of [other] is contained in [this].
//   ///
//   /// ```dart
//   /// var set = {'a', 'b', 'c'};
//   /// set.isSupersetOf({'a', 'b'}); // true
//   /// set.isSupersetOf({'a', 'b', 'c'}); // true
//   /// set.isSupersetOf({'a', 'b', 'f'}); // false
//   /// ```
//   bool isSupersetOf(Set<Object> other) =>
//       this.length >= other.length && this.containsAll(other);
//
//   /// Returns `true` if every element of [this] is contained in [other] and at
//   /// least one element of [other] is not contained in [this].
//   ///
//   /// Example:
//   /// ```dart
//   /// var set = {'a', 'b', 'c'};
//   /// set.isStrictSubsetOf({'a', 'b', 'c', 'd'}); // true
//   /// set.isStrictSubsetOf({'a', 'b', 'c'}); // false
//   /// set.isStrictSubsetOf({'a', 'b', 'f'}); // false
//   /// ```
//   bool isStrictSubsetOf(Set<Object> other) =>
//       this.length < other.length && other.containsAll(this);
//
//   /// Returns `true` if every element of [other] is contained in [this] and at
//   /// least one element of [this] is not contained in [other].
//   ///
//   /// ```dart
//   /// var set = {'a', 'b', 'c'};
//   /// set.isStrictSupersetOf({'a', 'b'}); // true
//   /// set.isStrictSupersetOf({'a', 'b', 'c'}); // false
//   /// set.isStrictSupersetOf({'a', 'b', 'f'}); // false
//   /// ```
//   bool isStrictSupersetOf(Set<Object> other) =>
//       this.length > other.length && this.containsAll(other);
//
//   /// Removes a random element of [this] and returns it.
//   ///
//   /// Returns [null] if [this] is empty.
//   ///
//   /// If [seed] is provided, will be used as the random seed for determining
//   /// which element to select. (See [math.Random].)
//   E? takeRandom({int? seed}) {
//     if (this.isEmpty) return null;
//     final element = this.elementAt(math.Random(seed).nextInt(this.length));
//     this.remove(element);
//     return element;
//   }
//
//   /// Returns a map grouping all elements of [this] with the same value for
//   /// [classifier].
//   ///
//   /// Example:
//   /// ```dart
//   /// {'aaa', 'bbb', 'cc', 'a', 'bb'}.classify<int>((e) => e.length);
//   /// // Returns {
//   /// //   1: {'a'},
//   /// //   2: {'cc', 'bb'},
//   /// //   3: {'aaa', 'bbb'}
//   /// // }
//   /// ```
//   Map<K, Set<E>> classify<K>(K classifier(E element)) {
//     final groups = <K, Set<E>>{};
//     for (var e in this) {
//       groups.putIfAbsent(classifier(e), () => <E>{}).add(e);
//     }
//     return groups;
//   }
// }

///

/// RIterable

extension RIterable<T> on Iterable<T> {
  /// * return the `length` of the NOT `null` elements
  int countNotNull() => count((e) => e != null);

  /// counter the element of certain value
  int countValue(T value) => count((e) => e == value);

  /// * async for each
  Future<void> loop(
    FutureOr<void> Function(T e) action,
  ) async {
    for (final item in this) {
      await action(item);
    }
  }

  /// * async Map
  Future<List<S>> asyncMap<S>(
    FutureOr<S> Function(T e) action,
  ) async {
    final list = <S>[];
    for (final item in this) {
      list.add(await action(item));
    }
    return list;
  }

  /// * return a new `List` without duplicated `elements`
  List<T> withoutDuplicate() => toSet().toList();

  /// * return a random element from list
  /// ! throws `StateError` if list is empty
  T get random => elementAt(Random().nextInt(length));

  /// * return a random element from list or the e if list is empty
  // T randomOr(T e) => isEmpty ? e : random;

  /// * return the first element
  /// * return `null` if isEmpty
  T? firstOrNull() => isEmpty ? null : first;

  /// * return first element if list is not empty
  /// * return `value` if isEmpty
  T firstOr(T value) => firstOrNull() ?? value;

  /// * return the last element
  /// * return `null` if isEmpty
  T? lastOrNull() => isEmpty ? null : last;

  /// * return the last element
  /// * return `value` if isEmpty
  T lastOr(T value) => lastOrNull() ?? value;

  /// * return element by index
  /// * return `null` if index out of range
  T? atOrNull(int index) => length - 1 >= index ? elementAt(index) : null;

  /// * return element by index
  /// * return `value` if index out of range
  T atOr(int index, T value) => length - 1 >= index ? elementAt(index) : value;

  /// * return the first match
  /// * return null if there is no match
  T? firstWhereOrNull(bool Function(T e) test) {
    try {
      return firstWhere(test);
    } catch (e) {
      if (e is StateError) return null;
      rethrow;
    }
  }

  /// * like `map()` function but now you have the index with the element
  List<E> mapWithIndex<E>(E Function(int index, T element) mapper) {
    final result = <E>[];
    for (int i = 0; i < length; i++) {
      result.add(mapper(i, elementAt(i)));
    }
    return result;
  }
}

/// *
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

///
extension RIterableString on Iterable<String> {
  /// return counter of empty elements in the iterable
  /// does not count the null values
  int countEmpty({bool trim = true}) => count(
        (e) => trim ? e.trim().isEmpty : e.isEmpty,
      );

  /// return counter of empty elements in the iterable
  /// does not count the null values
  int countNotEmpty() => count((e) => e.trim().isNotEmpty);
}

// /// provides extensions for Iterable
// extension IterableScrewDriver<E> on Iterable<E> {
//   /// Returns the second element in the iterable or
//   /// returns null if iterable is empty or has only 1 element.
//   E? get secondOrNull => length > 1 ? elementAt(1) : null;

//   /// Returns the third element in the iterable or
//   /// returns null if iterable is empty or has less than 3 elements.
//   E? get thirdOrNull => length > 2 ? elementAt(2) : null;

//   /// Returns the index of the last element in the collection.
//   int get lastIndex => length > 0 ? length - 1 : 0;

//   /// Returns true if the collection only has 1 element.
//   bool get hasOnlyOneElement => length == 1;

//   /// Appends all elements matching the given [predicate] to
//   /// the given [destination].
//   Iterable<E> filterTo(
//       List<E> destination, bool Function(E element) predicate) {
//     for (final element in this) {
//       if (predicate(element)) destination.add(element);
//     }
//     return destination;
//   }

//   /// alias for [Iterable.where]
//   Iterable<E> filter(bool Function(E element) predicate) =>
//       filterTo(<E>[], predicate);

//   /// alias for [whereIndexed] which returns a new lazy Iterable.
//   Iterable<E> filterIndexed(bool Function(int index, E element) test) sync* {
//     var index = 0;
//     for (var element in this) {
//       if (test(index++, element)) yield element;
//     }
//   }

//   /// alias for [Iterable.map]
//   Iterable<R> flatMap<R>(R Function(E element) transform) => map<R>(transform);

//   /// alias for [Iterable.skip]
//   Iterable<E> drop(int count) => skip(count);

//   /// alias for [Iterable.skip]
//   Iterable<E> takeLast(int count) {
//     assert(count > -1);
//     if (isEmpty) return [];
//     if (length <= count) return this;
//     return toList().sublist(length - count, length);
//   }

//   /// alias for [Iterable.skipWhile]
//   Iterable<E> dropWhile(bool Function(E element) test) => skipWhile(test);

//   /// alias for [Iterable.skip]
//   Iterable<E> dropLast(int count) {
//     assert(count > -1);
//     if (count == 0) return this;
//     if (count >= length) return [];
//     return toList().sublist(0, length - count);
//   }

//   /// alias for [Iterable.every]
//   bool all(bool Function(E element) test) => every(test);

//   /// Alias for [associate].
//   /// Returns a [Map] containing key-value pairs provided by [transform]
//   /// function applied to elements of the given List.
//   Map<K, V> toMap<K, V>((K, V) Function(E element) transform) =>
//       associate<K, V>(transform);

//   /// Returns a [Map] containing key-value pairs provided by [transform]
//   /// function applied to elements of the given List.
//   Map<K, V> associate<K, V>((K, V) Function(E element) transform) =>
//       associateTo(<K, V>{}, transform);

//   /// Populates and returns the [destination] map with key-value pairs
//   /// provided by [transform] function applied to each element
//   /// of the given iterable.
//   Map<K, V> associateTo<K, V>(
//       Map<K, V> destination, (K, V) Function(E element) transform) {
//     for (final element in this) {
//       destination + transform(element);
//     }
//     return destination;
//   }

//   /// Returns a [Map] containing the elements from the given List
//   /// indexed by the key returned from [keySelector] function applied
//   /// to each element.
//   Map<K, E> associateBy<K>(K Function(E element) keySelector) =>
//       associateByTo(<K, E>{}, keySelector);

//   /// Populates and returns the [destination] mutable map with key-value pairs,
//   /// where key is provided by the [keySelector] function applied to each
//   /// element of the given iterable and value is the element itself.
//   Map<K, E> associateByTo<K>(
//           Map<K, E> destination, K Function(E element) keySelector) =>
//       {for (final element in this) keySelector(element): element};

//   /// Returns a [Map] where keys are elements from the given iterable
//   /// and values are produced by the [valueSelector] function
//   /// applied to each element.
//   Map<E, V> associateWith<V>(V Function(E element) valueSelector) =>
//       associateWithTo(<E, V>{}, valueSelector);

//   /// Populates and returns the [destination] map with key-value
//   /// pairs for each element of the given iterable,
//   /// where key is the element itself and value is provided
//   /// by the [valueSelector] function applied to that key.
//   Map<E, V> associateWithTo<V>(
//           Map<E, V> destination, V Function(E element) valueSelector) =>
//       {for (final element in this) element: valueSelector(element)};

//   /// Groups elements of the original iterable by the key returned by
//   /// the given [keySelector] function applied to each element
//   /// and returns a map where each group key is associated with a
//   /// list of corresponding elements.
//   Map<K, List<E>> groupBy<K>(K Function(E element) keySelector) =>
//       groupByTo(<K, List<E>>{}, keySelector);

//   /// Groups elements of the original iterable by the key returned by
//   /// the given [keySelector] function applied to each element
//   /// and puts to the [destination] map each group key associated
//   /// with a list of corresponding elements.
//   Map<K, List<E>> groupByTo<K>(
//       Map<K, List<E>> destination, K Function(E element) keySelector) {
//     for (final element in this) {
//       final key = keySelector(element);
//       final list = destination.putIfAbsent(key, () => []);
//       list.add(element);
//     }
//     return destination;
//   }

//   /// Returns an iterable containing only distinct elements from
//   /// the given iterable.
//   Iterable<E> distinct() => toSet().toList();

//   /// Returns an iterable containing only elements from the given iterable
//   /// having distinct keys returned by the given [selector] function.
//   Iterable<E> distinctBy<K>(K Function(E element) selector) =>
//       distinctByTo(<E>[], selector);

//   /// Populates and returns the [destination] list with containing only
//   /// elements from the given iterable having distinct keys returned by
//   /// the given [selector] function.
//   Iterable<E> distinctByTo<K>(
//       List<E> destination, K Function(E element) selector) {
//     final set = HashSet<K>();
//     for (var element in this) {
//       final key = selector(element);
//       if (set.add(key)) destination.add(element);
//     }
//     return destination;
//   }

//   /// Returns a set containing all elements that are contained by both
//   /// [this] iterable and the [other] iterable.
//   Iterable<E> intersect(Iterable<E> other) =>
//       (toSet()..retainAll(other)).toList();

//   /// Returns a set containing all elements that are contained by [this]
//   /// iterable and not contained by the [other] iterable.
//   Iterable<E> subtract(Iterable<E> other) =>
//       (toSet()..removeAll(other)).toList();

//   /// Returns an iterable containing all distinct elements from both iterables.
//   Iterable<E> union(Iterable<E> other) => (toSet()..addAll(other)).toList();

//   /// Returns the number of elements matching the given [predicate].
//   int count(bool Function(E element) predicate) {
//     if (isEmpty) return 0;
//     var count = 0;
//     for (var element in this) {
//       if (predicate(element)) ++count;
//     }
//     return count;
//   }

//   /// Accumulates value starting with [initialValue] value and
//   /// applying [operation] from right to left to each element
//   /// and current accumulator value.
//   R foldRight<R>(
//       R initialValue, R Function(R previousValue, E element) operation) {
//     var accumulator = initialValue;
//     if (isNotEmpty) {
//       for (final element in toList().reversed) {
//         accumulator = operation(accumulator, element);
//       }
//     }
//     return accumulator;
//   }

//   /// Accumulates value starting with [initialValue] value and applying
//   /// [operation] from right to left to each element with its index in
//   /// the original list and current accumulator value.
//   R foldRightIndexed<R>(R initialValue,
//       R Function(int index, R previousValue, E element) operation) {
//     var accumulator = initialValue;
//     if (isNotEmpty) {
//       for (var index = length - 1; index >= 0; index--) {
//         accumulator = operation(index, accumulator, elementAt(index));
//       }
//     }
//     return accumulator;
//   }

//   /// Returns a random element from [this]. Returns null if no elements
//   /// are present.
//   E? randomOrNull([Random? random]) {
//     if (isEmpty) return null;
//     if (length == 1) return first;
//     return elementAt((random ?? Random()).nextInt(length));
//   }

//   /// Returns a random element from [this].
//   /// Throws [StateError] if there are no elements in the collection.
//   E random([Random? random]) {
//     if (isEmpty) throw StateError('no elements');
//     if (length == 1) return first;
//     return elementAt((random ?? Random()).nextInt(length));
//   }

//   /// Performs the given [action] on each element and returns the
//   /// iterable itself afterwards.
//   Iterable<E> onEach(void Function(E element) action) => this..forEach(action);

//   /// Returns the first element yielding the largest value of the given
//   /// function or `null` if there are no elements.
//   E? maxByOrNull<R extends Comparable<dynamic>>(
//       R Function(E element) selector) {
//     if (isEmpty) return null;
//     if (length == 1) return first;
//     var maxElement = first;
//     var maxValue = selector(maxElement);
//     for (final element in this) {
//       final value = selector(element);
//       if (maxValue < value) {
//         maxValue = value;
//         maxElement = element;
//       }
//     }
//     return maxElement;
//   }

//   /// Returns the first element yielding the largest value of the given
//   /// function.
//   /// Throws [StateError] if there are no elements in the collection.
//   E maxBy<R extends Comparable<dynamic>>(R Function(E element) selector) {
//     if (isEmpty) throw StateError('no elements');
//     if (length == 1) return first;
//     var maxElement = first;
//     var maxValue = selector(maxElement);
//     for (final element in this) {
//       final value = selector(element);
//       if (maxValue < value) {
//         maxValue = value;
//         maxElement = element;
//       }
//     }
//     return maxElement;
//   }

//   /// Returns the last element yielding the largest value of the given
//   /// function or `null` if there are no elements.
//   E? maxByLastOrNull<R extends Comparable<dynamic>>(
//       R Function(E element) selector) {
//     if (isEmpty) return null;
//     if (length == 1) return first;
//     var maxElement = first;
//     var maxValue = selector(maxElement);
//     for (final element in this) {
//       final value = selector(element);
//       if (maxValue <= value) {
//         maxValue = value;
//         maxElement = element;
//       }
//     }
//     return maxElement;
//   }

//   /// Returns the last element yielding the largest value of the given
//   /// function.
//   /// Throws [StateError] if there are no elements in the collection.
//   E maxByLast<R extends Comparable<dynamic>>(R Function(E element) selector) {
//     if (isEmpty) throw StateError('no elements');
//     if (length == 1) return first;
//     var maxElement = first;
//     var maxValue = selector(maxElement);
//     for (final element in this) {
//       final value = selector(element);
//       if (maxValue <= value) {
//         maxValue = value;
//         maxElement = element;
//       }
//     }
//     return maxElement;
//   }

//   /// Returns the first element yielding the smallest value of the given
//   /// function or `null` if there are no elements.
//   E? minByOrNull<R extends Comparable<dynamic>>(
//       R Function(E element) selector) {
//     if (isEmpty) return null;
//     if (length == 1) return first;
//     var minElement = first;
//     var minValue = selector(minElement);
//     for (final element in this) {
//       final value = selector(element);
//       if (minValue > value) {
//         minValue = value;
//         minElement = element;
//       }
//     }
//     return minElement;
//   }

//   /// Returns the first element yielding the smallest value of the given
//   /// function.
//   /// Throws [StateError] if there are no elements in the collection.
//   E minBy<R extends Comparable<dynamic>>(R Function(E element) selector) {
//     if (isEmpty) throw StateError('no elements');
//     if (length == 1) return first;
//     var minElement = first;
//     var minValue = selector(minElement);
//     for (final element in this) {
//       final value = selector(element);
//       if (minValue > value) {
//         minValue = value;
//         minElement = element;
//       }
//     }
//     return minElement;
//   }

//   /// Returns the last element yielding the smallest value of the given
//   /// function or `null` if there are no elements.
//   E? minByLastOrNull<R extends Comparable<dynamic>>(
//       R Function(E element) selector) {
//     if (isEmpty) return null;
//     if (length == 1) return first;
//     var minElement = first;
//     var minValue = selector(minElement);
//     for (final element in this) {
//       final value = selector(element);
//       if (minValue >= value) {
//         minValue = value;
//         minElement = element;
//       }
//     }
//     return minElement;
//   }

//   /// Returns the last element yielding the smallest value of the given
//   /// function.
//   /// Throws [StateError] if there are no elements in the collection.
//   E minByLast<R extends Comparable<dynamic>>(R Function(E element) selector) {
//     if (isEmpty) throw StateError('no elements');
//     if (length == 1) return first;
//     var minElement = first;
//     var minValue = selector(minElement);
//     for (final element in this) {
//       final value = selector(element);
//       if (minValue >= value) {
//         minValue = value;
//         minElement = element;
//       }
//     }
//     return minElement;
//   }

//   /// Returns the sum of all values produced by [selector] function
//   /// applied to each element in the collection.
//   R sumBy<R extends num>(R Function(E element) selector) => fold<R>(
//       (R == int ? 0 : 0.0) as R,
//       (previousValue, element) => previousValue + selector(element) as R);

//   /// Returns the average of all values produced by [selector] function
//   /// applied to each element in the collection.
//   double averageBy<R extends num>(R Function(E element) selector) {
//     if (isEmpty) return 0;
//     return sumBy(selector) / length;
//   }

//   /// Alias for [subtract].
//   Iterable<E> except(Iterable<E> other) => subtract(other);

//   /// Returns true if the collection contains all the elements
//   /// present in [other] collection.
//   bool containsAll(Iterable<E> other) => other.every(contains);

//   /// Returns true if the collection doesn't contain any of the elements
//   /// present in [other] collection.
//   bool containsNone(Iterable<E> other) =>
//       none((element) => other.contains(element));

//   /// Returns an iterable containing the items with their respective indices
//   /// in form of records.
//   ///
//   /// One of the use-cases includes iterating over the collection with access
//   /// to the index of each item in a for loop.
//   ///
//   /// e.g.
//   ///
//   /// for (final (index, item) in list.records) {
//   ///   print('$index: $item');
//   /// }
//   ///
//   Iterable<(int, E)> get records sync* {
//     for (int index = 0; index < length; index++) {
//       yield (index, elementAt(index));
//     }
//   }

//   /// Finds an element where the result of [selector] matches the [query].
//   /// Throws [StateError] if no element is found.
//   E findBy<S>(S query, S Function(E item) selector) {
//     for (final item in this) {
//       if (selector(item) == query) return item;
//     }
//     throw StateError('no element found');
//   }

//   /// Finds an element where the result of [selector] matches the [query].
//   /// Returns null if no element is found.
//   E? findByOrNull<C>(C query, C Function(E item) selector) {
//     for (final item in this) {
//       if (selector(item) == query) return item;
//     }
//     return null;
//   }

//   /// Finds all elements where the result of [selector] matches the [query].
//   /// Returns empty collection if no element is found.
//   Iterable<E> findAllBy<S>(S query, S Function(E item) selector) sync* {
//     for (final item in this) {
//       if (selector(item) == query) yield item;
//     }
//   }
// }

// /// provides extensions for nullable Iterable
// extension NullableIterableScrewDriver<E> on Iterable<E>? {
//   /// Returns true if [this] is either null or empty collection.
//   bool get isNullOrEmpty {
//     var iterable = this;
//     return iterable == null || iterable.isEmpty;
//   }

//   /// Alias for [isNullOrEmpty].
//   /// Returns true if [this] is either null or empty collection.
//   bool get isBlank => isNullOrEmpty;

//   /// Alias for [isNotNullOrEmpty].
//   /// Returns true if [this] is neither null nor empty collection.
//   bool get isNotBlank => isNotNullOrEmpty;

//   /// Returns true if [this] is neither null nor empty collection.
//   bool get isNotNullOrEmpty {
//     var iterable = this;
//     return iterable != null && iterable.isNotEmpty;
//   }
// }

// /// provides extensions for List of integers. e.g. bytes
// extension IntListScrewdriver on List<int> {
/// Converts the list of integers to a base64 encoded string. e.g. converting
/// bytes to base64 string.
//   String toBase64() => base64Encode(this);

//   /// Converts [this] list of integers to a [Uint8List].
//   Uint8List toUint8List() => Uint8List.fromList(this);

//   /// Converts [this] list of integers to a [Uint16List].
//   Uint16List toUint16List() => Uint16List.fromList(this);
// }

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

typedef IndexedPredicate<T> = bool Function(int index, T);

extension CollectionsNullableExtensions<T> on Iterable<T>? {
  /// Returns this Iterable if it's not `null` and the empty list otherwise.
  Iterable<T> orEmpty() => this ?? [];

  ///Returns `true` if this nullable iterable is either null or empty.
  bool get isEmptyOrNull => this?.isEmpty ?? true;

  /// Returns `true` if at least one element matches the given [predicate].
  bool any(bool Function(T element) predicate) {
    if (this.isEmptyOrNull) return false;
    for (final element in this.orEmpty()) {
      if (predicate(element)) return true;
    }
    return false;
  }

  /// Return a list concatenates the output of the current list and another [iterable]
  List<T> concatWithSingleList(Iterable<T> iterable) {
    if (isEmptyOrNull || iterable.isEmptyOrNull) return [];

    return <T>[...this.orEmpty(), ...iterable];
  }

  /// Return a list concatenates the output of the current list and multiple [iterables]
  List<T> concatWithMultipleList(List<Iterable<T>> iterables) {
    if (isEmptyOrNull || iterables.isEmptyOrNull) return [];
    final list = iterables.toList(growable: false).expand((i) => i);
    return <T>[...this.orEmpty(), ...list];
  }

  /// Zip is used to combine multiple iterables into a single list that contains
  /// the combination of them two.
  Iterable<void> zip<T>(Iterable<T> iterable) sync* {
    if (iterable.isEmptyOrNull) return;
    final iterables = List<Iterable>.empty()
      ..add(this.orEmpty())
      ..add(iterable);

    final iterators = iterables.map((e) => e.iterator).toList(growable: false);
    while (iterators.every((e) => e.moveNext())) {
      yield iterators.map((e) => e.current).toList(growable: false);
    }
  }
}

extension CollectionsExtensions<T> on Iterable<T> {
  /// Convert iterable to set
  Set<T> toMutableSet() => Set.from(this);

  /// Returns a set containing all elements that are contained
  /// by both this set and the specified collection.
  Set<T> intersect(Iterable<T> other) {
    final set = this.toMutableSet();
    set.addAll(other);
    return set;
  }

  /// Groups the elements in values by the value returned by key.
  ///
  /// Returns a map from keys computed by key to a list of all values for which
  /// key returns that key. The values appear in the list in the same
  /// relative order as in values.
  Map<K, List<T>> groupBy<T, K>(K Function(T e) key) {
    final map = <K, List<T>>{};

    for (final element in this) {
      final list = map.putIfAbsent(key(element as T), () => []);
      list.add(element);
    }
    return map;
  }

  /// Returns a list containing only elements matching the given [predicate].
  // List<T> filter(bool Function(T element) test) {
  //   final result = <T>[];
  //   forEach((e) {
  //     if (e != null && test(e)) {
  //       result.add(e);
  //     }
  //   });
  //   return result;
  // }

  /// Returns a list containing all elements not matching the given [predicate] and will filter nulls as well.
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

  // Retuns map operation as a List
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

  T getRandom() {
    final Random generator = Random();
    final index = generator.nextInt(length);
    return toList()[index];
  }

  /// get the first element return null
  T? get firstOrNull => _elementAtOrNull(0);

  /// get the last element if the list is not empty or return null
  T? get lastOrNull => isNotEmpty ? last : null;

  T lastOrDefault(T defaultValue) => lastOrNull ?? defaultValue;

  T? firstOrNullWhere(bool Function(T element) predicate) {
    for (final T element in this) {
      if (predicate(element)) return element;
    }
    return null;
  }

  /// get the first element or provider default
  /// example:
  /// var name = [danny, ronny, james].firstOrDefault["jack"]; // danny
  /// var name = [].firstOrDefault["jack"]; // jack
  T firstOrDefault(T defaultValue) => firstOrNull ?? defaultValue;

  /// Will retrun new [Iterable] with all elements that satisfy the predicate [predicate],
  Iterable<T> whereIndexed(IndexedPredicate<T> predicate) =>
      _IndexedWhereIterable(this, predicate);

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
  void forEachIndexed(void Function(T element, int index) action) {
    var index = 0;
    for (final element in this) {
      action(element, index++);
    }
  }

  /// Returns a new list with all elements sorted according to descending
  /// natural sort order.
  List<T> sortedDescending() {
    final list = toList();
    list.sort((a, b) => -(a as Comparable).compareTo(b));
    return list;
  }

  /// Checks if all elements in the specified [collection] are contained in
  /// this collection.
  bool containsAll(Iterable<T> collection) {
    for (final element in collection) {
      if (!contains(element)) return false;
    }
    return true;
  }

  /// Return a number of the existing elements by a specific predicate
  /// example:
  ///  final aboveTwenty = [
  ///    User(33, "chicko"),
  ///    User(45, "ronit"),
  ///    User(19, "amsalam"),
  ///  ].count((user) => user.age > 20); // 2
  // int count([bool Function(T element)? predicate]) {
  //   var count = 0;
  //   if (predicate == null) {
  //     return length;
  //   } else {
  //     for (final current in this) {
  //       if (predicate(current)) {
  //         count++;
  //       }
  //     }
  //   }

  //   return count;
  // }

  /// Returns `true` if all elements match the given predicate.
  /// Example:
  /// [5, 19, 2].all(isEven), isFalse)
  /// [6, 12, 2].all(isEven), isTrue)
  bool all(bool Function(T pred)? predicate) {
    for (final e in this) {
      if (!predicate!(e)) return false;
    }
    return true;
  }

  /// Returns a list containing only the elements from given collection having distinct keys.
  ///
  /// Basically it's just like distinct function but with a predicate
  /// example:
  /// [
  ///    User(22, "Sasha"),
  ///    User(23, "Mika"),
  ///    User(23, "Miryam"),
  ///    User(30, "Josh"),
  ///    User(36, "Ran"),
  ///  ].distinctBy((u) => u.age).forEach((user) {
  ///    print("${user.age} ${user.name}");
  ///  });
  ///
  /// result:
  /// 22 Sasha
  /// 23 Mika
  /// 30 Josh
  /// 36 Ran
  List<T> distinctBy(Function(T selector) predicate) {
    final set = HashSet();
    final List<T> list = [];
    toList().forEach((e) {
      final key = predicate(e);
      if (set.add(key)) {
        list.add(e);
      }
    });

    return list;
  }

// get an element at specific index or return null
  T? _elementAtOrNull(int index) => _elementOrNull(index, (_) => null);

  T? _elementOrNull(int index, T? Function(int index) defaultElement) {
    // if our index is smaller then 0 return the default
    if (index < 0) return defaultElement(index);

    var counter = 0;
    for (final element in this) {
      if (index == counter++) {
        return element;
      }
    }

    return defaultElement(index);
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
  Set subtract(Iterable<T> other) {
    final set = toSet();
    set.removeAll(other);
    return set;
  }

  /// will convert iterable into a Stack data structure
  /// example:
  ///  [1,2,3,4].toStack()
  ///  stack.pop()
  ///  stack.push(5)
  ///
  StackX<T> toStack() {
    final stack = StackX<T>();
    stack.addAll(this);
    return stack;
  }

  /// Creates a Map instance in which the keys and values are computed from the iterable.
  Map<dynamic, dynamic> associate(key(element), value(element)) =>
      Map.fromIterable(this, key: key, value: value);
}

// A lazy [Iterable] skip elements do **NOT** match the predicate [_f].
class _IndexedWhereIterable<E> extends Iterable<E> {
  _IndexedWhereIterable(this._iterable, this._f);
  final Iterable<E> _iterable;
  final IndexedPredicate<E> _f;

  @override
  Iterator<E> get iterator => _IndexedWhereIterator<E>(_iterable.iterator, _f);
}

/// [Iterator] for [_IndexedWhereIterable]
class _IndexedWhereIterator<E> implements Iterator<E> {
  _IndexedWhereIterator(this._iterator, this._f);
  final Iterator<E> _iterator;
  final IndexedPredicate<E> _f;
  int _index = 0;

  @override
  bool moveNext() {
    while (_iterator.moveNext()) {
      if (_f(_index++, _iterator.current)) {
        return true;
      }
    }
    return false;
  }

  @override
  E get current => _iterator.current;
}


// import 'dart:collection';
// import 'dart:math';

// import 'package:collection/collection.dart' as collection;
// import 'package:dartx/src/sorted_list.dart';

// extension IterableSecondItem<E> on Iterable<E> {
//   /// Second element.
//   ///
//   /// ```dart
//   /// [1, 2, 3].second; // 2
//   /// ```
//   E get second => elementAt(1);
// }

// extension IterableThirdItem<E> on Iterable<E> {
//   /// Third element.
//   ///
//   /// ```dart
//   /// [1, 2, 3].third; // 3
//   /// ```
//   E get third => elementAt(2);
// }

// extension IterableFourthItem<E> on Iterable<E> {
//   /// Fourth element.
//   ///
//   /// ```dart
//   /// [1, 2, 3, 4].fourth; // 4
//   /// ```
//   E get fourth => elementAt(3);
// }

// extension IterableElementAtOrNull<E> on Iterable<E> {
//   /// Returns an element at the given [index] or `null` if the [index] is out of
//   /// bounds of this collection.
//   ///
//   /// ```dart
//   /// final list = [1, 2, 3, 4];
//   /// final first = list.elementAtOrNull(0); // 1
//   /// final fifth = list.elementAtOrNull(4); // null
//   /// ```
//   E? elementAtOrNull(int index) {
//     if (index < 0) return null;
//     var count = 0;
//     for (final element in this) {
//       if (index == count++) return element;
//     }
//     return null;
//   }
// }

// extension IterableElementAtOrDefault<E> on Iterable<E> {
//   /// Returns an element at the given [index] or [defaultValue] if the [index]
//   /// is out of bounds of this collection.
//   ///
//   /// ```dart
//   /// final list = [1, 2, 3, 4];
//   /// final first = list.elementAtOrDefault(0, -1); // 1
//   /// final fifth = list.elementAtOrDefault(4, -1); // -1
//   /// ```
//   E elementAtOrDefault(int index, E defaultValue) {
//     return elementAtOrElse(index, (_) => defaultValue);
//   }
// }

// extension IterableElementAtOrElse<E> on Iterable<E> {
//   /// Returns an element at the given [index] or the result of calling the
//   /// [defaultValue] function if the [index] is out of bounds of this
//   /// collection.
//   ///
//   /// ```dart
//   /// final list = [1, 2, 3, 4];
//   /// final first = list.elementAtOrElse(0); // 1
//   /// final fifth = list.elementAtOrElse(4, -1); // -1
//   /// ```
//   E elementAtOrElse(int index, E Function(int index) defaultValue) {
//     if (index < 0) return defaultValue(index);
//     var count = 0;
//     for (final element in this) {
//       if (index == count++) return element;
//     }
//     return defaultValue(index);
//   }
// }

// extension IterableFirstOrNull<E> on Iterable<E> {
//   /// First element or `null` if the collection is empty.
//   ///
//   /// ```dart
//   /// final first = [1, 2, 3, 4].firstOrNull; // 1
//   /// final emptyFirst = [].firstOrNull; // null
//   /// ```
//   E? get firstOrNull => isNotEmpty ? first : null;
// }

// extension IterableFirstOrDefault<E> on Iterable<E> {
//   /// First element or `defaultValue` if the collection is empty.
//   ///
//   /// ```dart
//   /// final first = [1, 2, 3, 4].firstOrDefault(-1); // 1
//   /// final emptyFirst = [].firstOrDefault(-1); // -1
//   /// ```
//   E firstOrDefault(E defaultValue) => isNotEmpty ? first : defaultValue;
// }

// extension IterableFirstOrNullWhere<E> on Iterable<E> {
//   /// Returns the first element matching the given [predicate], or `null` if no
//   /// such element was found.
//   ///
//   /// ```dart
//   /// final list = ['a', 'Test'];
//   /// final firstLong= list.firstOrNullWhere((e) => e.length > 1); // 'Test'
//   /// final firstVeryLong = list.firstOrNullWhere((e) => e.length > 5); // null
//   /// ```
//   E? firstOrNullWhere(bool Function(E element) predicate) {
//     for (final element in this) {
//       if (predicate(element)) return element;
//     }
//     return null;
//   }
// }

// extension IterableLastOrNull<E> on Iterable<E> {
//   /// Last element or `null` if the collection is empty.
//   ///
//   /// ```dart
//   /// final last = [1, 2, 3, 4].lastOrNull; // 4
//   /// final emptyLast = [].firstOrNull; // null
//   /// ```
//   E? get lastOrNull => isNotEmpty ? last : null;
// }

// extension IterableLastOrElse<E> on Iterable<E> {
//   /// Last element or `defaultValue` if the collection is empty.
//   E lastOrElse(E defaultValue) =>
//       IterableLastOrNull(this).lastOrNull ?? defaultValue;
// }

// extension IterableLastOrNullWhere<E> on Iterable<E> {
//   /// Returns the last element matching the given [predicate], or `null` if no
//   /// such element was found.
//   E? lastOrNullWhere(bool Function(E element) predicate) {
//     E? match;
//     for (final e in this) {
//       if (predicate(e)) {
//         match = e;
//       }
//     }
//     return match;
//   }
// }

// extension IterableAll<E> on Iterable<E> {
//   /// Returns true if all elements match the given [predicate] or if the
//   /// collection is empty.
//   bool all(bool Function(E element) predicate) {
//     for (final element in this) {
//       if (!predicate(element)) {
//         return false;
//       }
//     }
//     return true;
//   }
// }

// extension IterableNone<E> on Iterable<E> {
//   /// Returns true if no entries match the given [predicate] or if the
//   /// collection is empty.
//   bool none(bool Function(E element) predicate) => !any(predicate);
// }

// extension IterableSlice<E> on Iterable<E> {
//   /// Returns a new list containing elements at indices between [start]
//   /// (inclusive) and [end] (inclusive).
//   ///
//   /// If [end] is omitted, it is being set to `lastIndex`.
//   List<E> slice(int start, [int end = -1]) {
//     final list = this is List ? this as List<E> : toList();
//     var _start = start;
//     var _end = end;

//     if (_start < 0) {
//       _start = _start + list.length;
//     }
//     if (_end < 0) {
//       _end = _end + list.length;
//     }

//     RangeError.checkValidRange(_start, _end, list.length);

//     return list.sublist(_start, _end + 1);
//   }
// }

// extension IterableForEachIndexed<E> on Iterable<E> {
//   /// Performs the given [action] on each element, providing sequential index
//   /// with the element.
//   void forEachIndexed(void Function(E element, int index) action) {
//     var index = 0;
//     for (final element in this) {
//       action(element, index++);
//     }
//   }
// }

// extension IterableContainsAll<E> on Iterable<E> {
//   /// Checks if all elements in the specified [collection] are contained in
//   /// this collection.
//   bool containsAll(Iterable<E> collection) {
//     for (final element in collection) {
//       if (!contains(element)) return false;
//     }
//     return true;
//   }
// }

// extension IterableContainsAny<E> on Iterable<E> {
//   /// Checks if any elements in the specified [collection] are contained in
//   /// this collection.
//   bool containsAny(Iterable<E> collection) {
//     for (final element in collection) {
//       if (contains(element)) return true;
//     }
//     return false;
//   }
// }

// extension IterableContentEquals<E> on Iterable<E> {
//   /// Returns true if this collection is structurally equal to the [other]
//   /// collection.
//   ///
//   /// I.e. contain the same number of the same elements in the same order.
//   ///
//   /// If [checkEqual] is provided, it is used to check if two elements are the
//   /// same.
//   bool contentEquals(Iterable<E> other, [bool Function(E a, E b)? checkEqual]) {
//     final it1 = iterator;
//     final it2 = other.iterator;
//     if (checkEqual != null) {
//       while (it1.moveNext()) {
//         if (!it2.moveNext()) return false;
//         if (!checkEqual(it1.current, it2.current)) return false;
//       }
//     } else {
//       while (it1.moveNext()) {
//         if (!it2.moveNext()) return false;
//         if (it1.current != it2.current) return false;
//       }
//     }
//     return !it2.moveNext();
//   }
// }

// extension IterableSorted<E> on Iterable<E> {
//   /// Returns a new list with all elements sorted according to natural sort
//   /// order.
//   List<E> sorted() {
//     final list = toList();
//     list.sort();
//     return list;
//   }
// }

// extension IterableSortedDescending<E> on Iterable<E> {
//   /// Returns a new list with all elements sorted according to descending
//   /// natural sort order.
//   List<E> sortedDescending() {
//     final list = toList();
//     list.sort((a, b) => -(a as Comparable).compareTo(b));
//     return list;
//   }
// }

// extension IterableSortedBy<E> on Iterable<E> {
//   /// Returns a new list with all elements sorted according to natural sort
//   /// order of the values returned by specified [selector] function.
//   ///
//   /// To sort by more than one property, `thenBy()` or `thenByDescending()` can
//   /// be called afterwards.
//   ///
//   /// **Note:** The actual sorting is performed when an element is accessed for
//   /// the first time.
//   SortedList<E> sortedBy(Comparable Function(E element) selector) {
//     return SortedList<E>.withSelector(this, selector, 1, null);
//   }
// }

// extension IterableSortedByDescending<E> on Iterable<E> {
//   /// Returns a new list with all elements sorted according to descending
//   /// natural sort order of the values returned by specified [selector]
//   /// function.
//   ///
//   /// To sort by more than one property, `thenBy()` or `thenByDescending` can
//   /// be called afterwards.
//   ///
//   /// **Note:** The actual sorting is performed when an element is accessed for
//   /// the first time.
//   SortedList<E> sortedByDescending(Comparable Function(E element) selector) {
//     return SortedList<E>.withSelector(this, selector, -1, null);
//   }
// }

// extension IterableSortedWith<E> on Iterable<E> {
//   /// Returns a new list with all elements sorted according to specified
//   /// [comparator].
//   ///
//   /// To sort by more than one property, `thenBy()` or `thenByDescending` can
//   /// be called afterwards.
//   ///
//   /// **Note:** The actual sorting is performed when an element is accessed for
//   /// the first time.
//   SortedList<E> sortedWith(Comparator<E> comparator) {
//     return SortedList<E>(this, comparator);
//   }
// }

// extension IterableJoinToString<E> on Iterable<E> {
//   /// Creates a string from all the elements separated using [separator] and
//   /// using the given [prefix] and [postfix] if supplied.
//   ///
//   /// If the collection could be huge, you can specify a non-negative value of
//   /// [limit], in which case only the first [limit] elements will be appended,
//   /// followed by the [truncated] string (which defaults to `'...'`).
//   String joinToString({
//     String separator = ', ',
//     String Function(E element)? transform,
//     String prefix = '',
//     String postfix = '',
//     int? limit,
//     String truncated = '...',
//   }) {
//     final buffer = StringBuffer();
//     var count = 0;
//     for (final element in this) {
//       if (limit != null && count >= limit) {
//         buffer.write(truncated);
//         return buffer.toString();
//       }
//       if (count > 0) {
//         buffer.write(separator);
//       }
//       buffer.write(prefix);
//       if (transform != null) {
//         buffer.write(transform(element));
//       } else {
//         buffer.write(element.toString());
//       }
//       buffer.write(postfix);

//       count++;
//     }
//     return buffer.toString();
//   }
// }

// extension IterableSumBy<E> on Iterable<E> {
//   /// Returns the sum of all values produced by [selector] function applied to
//   /// each element in the collection.
//   T sumBy<T extends num>(T Function(E element) selector) {
//     var sum = T == double ? 0.0 : 0;
//     for (final current in this) {
//       sum += selector(current);
//     }
//     return sum as T;
//   }
// }

// extension IterableAverageBy<E> on Iterable<E> {
//   /// Returns the average of values returned by [selector] for all elements in
//   /// the collection.
//   double averageBy(num Function(E element) selector) {
//     var count = 0;
//     num sum = 0;

//     for (final current in this) {
//       sum += selector(current);
//       count++;
//     }

//     if (count == 0) {
//       throw StateError('No elements in collection');
//     } else {
//       return sum / count;
//     }
//   }
// }

// extension InterableMin<E> on Iterable<E> {
//   /// Returns the smallest element or `null` if there are no elements.
//   ///
//   /// All elements must be of type [Comparable].
//   E? min() => _minMax(-1);
// }

// extension _MinMaxHelper<E> on Iterable<E> {
//   E? _minMax(int order) {
//     final it = iterator;
//     if (!it.moveNext()) {
//       return null;
//     }
//     var currentMin = it.current;

//     if (order < 0) {
//       while (it.moveNext()) {
//         if ((it.current as Comparable).compareTo(currentMin) <= order) {
//           currentMin = it.current;
//         }
//       }
//     } else {
//       while (it.moveNext()) {
//         if ((it.current as Comparable).compareTo(currentMin) >= order) {
//           currentMin = it.current;
//         }
//       }
//     }

//     return currentMin;
//   }

//   E? _minMaxBy(int order, Comparable Function(E element) selector) {
//     final it = iterator;
//     if (!it.moveNext()) {
//       return null;
//     }

//     var currentMin = it.current;
//     var currentMinValue = selector(it.current);
//     while (it.moveNext()) {
//       final comp = selector(it.current);
//       if (comp.compareTo(currentMinValue) == order) {
//         currentMin = it.current;
//         currentMinValue = comp;
//       }
//     }

//     return currentMin;
//   }

//   E? _minMaxWith(int order, Comparator<E> comparator) {
//     final it = iterator;
//     if (!it.moveNext()) {
//       return null;
//     }
//     var currentMin = it.current;

//     while (it.moveNext()) {
//       if (comparator(it.current, currentMin) == order) {
//         currentMin = it.current;
//       }
//     }

//     return currentMin;
//   }
// }

// extension IterableMinBy<E> on Iterable<E> {
//   /// Returns the first element yielding the smallest value of the given
//   /// [selector] or `null` if there are no elements.
//   E? minBy(Comparable Function(E element) selector) => _minMaxBy(-1, selector);
// }

// extension IterableMinWith<E> on Iterable<E> {
//   /// Returns the first element having the smallest value according to the
//   /// provided [comparator] or `null` if there are no elements.
//   E? minWith(Comparator<E> comparator) => _minMaxWith(-1, comparator);
// }

// extension IterableMax<E> on Iterable<E> {
//   /// Returns the largest element or `null` if there are no elements.
//   ///
//   /// All elements must be of type [Comparable].
//   E? max() => _minMax(1);
// }

// extension IterableMaxBy<E> on Iterable<E> {
//   /// Returns the first element yielding the largest value of the given
//   /// [selector] or `null` if there are no elements.
//   E? maxBy(Comparable Function(E element) selector) => _minMaxBy(1, selector);
// }

// extension IterableMaxWith<E> on Iterable<E> {
//   /// Returns the first element having the largest value according to the
//   /// provided [comparator] or `null` if there are no elements.
//   E? maxWith(Comparator<E> comparator) => _minMaxWith(1, comparator);
// }

// extension IterableCount<E> on Iterable<E> {
//   /// Returns the number of elements matching the given [predicate].
//   ///
//   /// If no [predicate] is given, this equals to [length].
//   int count([bool Function(E element)? predicate]) {
//     var count = 0;
//     if (predicate == null) {
//       return length;
//     } else {
//       for (final current in this) {
//         if (predicate(current)) {
//           count++;
//         }
//       }
//     }

//     return count;
//   }
// }

// extension IterableReversed<E> on Iterable<E> {
//   /// Returns an [Iterable] of the objects in this list in reverse order.
//   Iterable<E> get reversed {
//     return this is List<E> ? (this as List<E>).reversed : toList().reversed;
//   }
// }

// extension IterableTakeFirst<E> on Iterable<E> {
//   /// Returns a list containing first [n] elements.
//   ///
//   /// ```dart
//   /// val chars = [1, 2, 3, 4, 5, 6, 7, 8, 9];
//   /// print(chars.take(3)) // [1, 2, 3]
//   /// print(chars.takeWhile((it) => it < 5) // [1, 2, 3, 4]
//   /// print(chars.takeLast(2)) // [8, 9]
//   /// print(chars.takeLastWhile((it) => it > 5 }) // [6, 7, 8, 9]
//   /// ```
//   List<E> takeFirst(int n) {
//     final list = this is List<E> ? this as List<E> : toList();
//     return list.take(n).toList();
//   }
// }

// extension IterableTakeLast<E> on Iterable<E> {
//   /// Returns a list containing last [n] elements.
//   ///
//   /// ```dart
//   /// val chars = [1, 2, 3, 4, 5, 6, 7, 8, 9];
//   /// print(chars.take(3)) // [1, 2, 3]
//   /// print(chars.takeWhile((it) => it < 5) // [1, 2, 3, 4]
//   /// print(chars.takeLast(2)) // [8, 9]
//   /// print(chars.takeLastWhile((it) => it > 5 }) // [6, 7, 8, 9]
//   /// ```
//   List<E> takeLast(int n) {
//     final list = this is List<E> ? this as List<E> : toList();
//     return list.reversed.take(n).reversed.toList();
//   }
// }

// extension IterableFirstWhile<E> on Iterable<E> {
//   //// Returns the first elements satisfying the given [predicate].
//   ///
//   /// ```dart
//   /// val chars = [1, 2, 3, 4, 5, 6, 7, 8, 9];
//   /// print(chars.take(3)) // [1, 2, 3]
//   /// print(chars.takeWhile((it) => it < 5) // [1, 2, 3, 4]
//   /// print(chars.takeLast(2)) // [8, 9]
//   /// print(chars.takeLastWhile((it) => it > 5 }) // [6, 7, 8, 9]
//   /// ```
//   Iterable<E> firstWhile(bool Function(E element) predicate) sync* {
//     for (final element in this) {
//       if (!predicate(element)) break;
//       yield element;
//     }
//   }
// }

// extension IterableLastWhile<E> on Iterable<E> {
//   /// Returns the last elements satisfying the given [predicate].
//   ///
//   /// ```dart
//   /// val chars = [1, 2, 3, 4, 5, 6, 7, 8, 9];
//   /// print(chars.take(3)) // [1, 2, 3]
//   /// print(chars.takeWhile((it) => it < 5) // [1, 2, 3, 4]
//   /// print(chars.takeLast(2)) // [8, 9]
//   /// print(chars.takeLastWhile((it) => it > 5 }) // [6, 7, 8, 9]
//   /// ```
//   Iterable<E> lastWhile(bool Function(E element) predicate) {
//     final list = ListQueue<E>();
//     for (final element in reversed) {
//       if (!predicate(element)) break;
//       list.addFirst(element);
//     }
//     return list;
//   }
// }

// extension IterableFilter<E> on Iterable<E> {
//   /// Returns all elements matching the given [predicate].
//   Iterable<E> filter(bool Function(E element) predicate) => where(predicate);
// }

// extension IterableFilterIndexed<E> on Iterable<E> {
//   /// Returns all elements that satisfy the given [predicate].
//   Iterable<E> filterIndexed(bool Function(E element, int index) predicate) =>
//       IterableWhereIndexed(this).whereIndexed(predicate);
// }

// extension IterableFilterTo<E> on Iterable<E> {
//   /// Appends all elements matching the given [predicate] to the given
//   /// [destination].
//   void filterTo(List<E> destination, bool Function(E element) predicate) =>
//       whereTo(destination, predicate);
// }

// extension IterableFilterIndexedTo<E> on Iterable<E> {
//   /// Appends all elements matching the given [predicate] to the given
//   /// [destination].
//   void filterIndexedTo(
//     List<E> destination,
//     bool Function(E element, int index) predicate,
//   ) =>
//       whereIndexedTo(destination, predicate);
// }

// extension IterableFilterNot<E> on Iterable<E> {
//   /// Returns all elements not matching the given [predicate].
//   Iterable<E> filterNot(bool Function(E element) predicate) =>
//       IterableWhereNot(this).whereNot(predicate);
// }

// extension IterableFilterNotIndexed<E> on Iterable<E> {
//   /// Returns all elements not matching the given [predicate].
//   Iterable<E> filterNotIndexed(bool Function(E element, int index) predicate) =>
//       IterableWhereNotIndexed(this).whereNotIndexed(predicate);
// }

// extension IterableFilterNotTo<E> on Iterable<E> {
//   /// Appends all elements not matching the given [predicate] to the given
//   /// [destination].
//   void filterNotTo(List<E> destination, bool Function(E element) predicate) =>
//       whereNotTo(destination, predicate);
// }

// extension IterableFilterNotToIndexed<E> on Iterable<E> {
//   /// Appends all elements not matching the given [predicate] to the given
//   /// [destination].
//   void filterNotToIndexed(
//     List<E> destination,
//     bool Function(E element, int index) predicate,
//   ) =>
//       whereNotToIndexed(destination, predicate);
// }

// extension IterableFilterNotNull<E> on Iterable<E?> {
//   /// Returns a new lazy [Iterable] with all elements which are not null.
//   Iterable<E> filterNotNull() => whereNotNull();
// }

// extension IterableWhereIndexed<E> on Iterable<E> {
//   /// Returns all elements that satisfy the given [predicate].
//   Iterable<E> whereIndexed(
//     bool Function(E element, int index) predicate,
//   ) sync* {
//     var index = 0;
//     for (final element in this) {
//       if (predicate(element, index++)) {
//         yield element;
//       }
//     }
//   }
// }

// extension IterableWhereTo<E> on Iterable<E> {
//   /// Appends all elements matching the given [predicate] to the given
//   /// [destination].
//   void whereTo(List<E> destination, bool Function(E element) predicate) {
//     for (final element in this) {
//       if (predicate(element)) {
//         destination.add(element);
//       }
//     }
//   }
// }

// extension IterableWhereIndexedTo<E> on Iterable<E> {
//   /// Appends all elements matching the given [predicate] to the given
//   /// [destination].
//   void whereIndexedTo(
//     List<E> destination,
//     bool Function(E element, int index) predicate,
//   ) {
//     var index = 0;
//     for (final element in this) {
//       if (predicate(element, index++)) {
//         destination.add(element);
//       }
//     }
//   }
// }

// extension IterableWhereNot<E> on Iterable<E> {
//   /// Returns all elements not matching the given [predicate].
//   Iterable<E> whereNot(bool Function(E element) predicate) sync* {
//     for (final element in this) {
//       if (!predicate(element)) {
//         yield element;
//       }
//     }
//   }
// }

// extension IterableWhereNotIndexed<E> on Iterable<E> {
//   /// Returns all elements not matching the given [predicate].
//   Iterable<E> whereNotIndexed(
//     bool Function(E element, int index) predicate,
//   ) sync* {
//     var index = 0;
//     for (final element in this) {
//       if (!predicate(element, index++)) {
//         yield element;
//       }
//     }
//   }
// }

// extension IterableWhereNotTo<E> on Iterable<E> {
//   /// Appends all elements not matching the given [predicate] to the given
//   /// [destination].
//   void whereNotTo(List<E> destination, bool Function(E element) predicate) {
//     for (final element in this) {
//       if (!predicate(element)) {
//         destination.add(element);
//       }
//     }
//   }
// }

// extension IterableWhereNotToIndexed<E> on Iterable<E> {
//   /// Appends all elements not matching the given [predicate] to the given
//   /// [destination].
//   void whereNotToIndexed(
//     List<E> destination,
//     bool Function(E element, int index) predicate,
//   ) {
//     var index = 0;
//     for (final element in this) {
//       if (!predicate(element, index++)) {
//         destination.add(element);
//       }
//     }
//   }
// }

// extension IterableWhereNotNull<E> on Iterable<E?> {
//   /// Returns a new lazy [Iterable] with all elements which are not null.
//   Iterable<E> whereNotNull() => where((element) => element != null).cast<E>();
// }

// extension IterableMapNotNull<E> on Iterable<E> {
//   /// Returns a new lazy [Iterable] containing only the non-null results of
//   /// applying the given [transform] function to each element in the original
//   /// collection.
//   Iterable<R> mapNotNull<R>(R? Function(E element) transform) sync* {
//     for (final element in this) {
//       final result = transform(element);
//       if (result != null) {
//         yield result;
//       }
//     }
//   }
// }

// extension IterableMapIndexed<E> on Iterable<E> {
//   /// Returns a new lazy [Iterable] containing the results of applying the
//   /// given [transform] function to each element and its index in the original
//   /// collection.
//   Iterable<R> mapIndexed<R>(R Function(int index, E) transform) sync* {
//     var index = 0;
//     for (final element in this) {
//       yield transform(index++, element);
//     }
//   }
// }

// extension IterableMapIndexedNotNull<E> on Iterable<E> {
//   /// Returns a new lazy [Iterable] containing only the non-null results of
//   /// applying the given [transform] function to each element and its index
//   /// in the original collection.
//   Iterable<R> mapIndexedNotNull<R>(R? Function(int index, E) transform) sync* {
//     var index = 0;
//     for (final element in this) {
//       final result = transform(index++, element);
//       if (result != null) {
//         yield result;
//       }
//     }
//   }
// }

// extension IterableOnEach<E> on Iterable<E> {
//   /// Returns a new lazy [Iterable] which performs the given action on each
//   /// element.
//   Iterable<E> onEach(void Function(E element) action) sync* {
//     for (final element in this) {
//       action(element);
//       yield element;
//     }
//   }
// }

// extension IterableDistinct<E> on Iterable<E> {
//   /// Returns a new lazy [Iterable] containing only distinct elements from the
//   /// collection.
//   ///
//   /// The elements in the resulting list are in the same order as they were in
//   /// the source collection.
//   Iterable<E> distinct() sync* {
//     final existing = HashSet<E>();
//     for (final current in this) {
//       if (existing.add(current)) {
//         yield current;
//       }
//     }
//   }
// }

// extension IterableDistinctBy<E> on Iterable<E> {
//   /// Returns a new lazy [Iterable] containing only elements from the collection
//   /// having distinct keys returned by the given [selector] function.
//   ///
//   /// The elements in the resulting list are in the same order as they were in
//   /// the source collection.
//   Iterable<E> distinctBy<R>(R Function(E element) selector) sync* {
//     final existing = HashSet<R>();
//     for (final current in this) {
//       if (existing.add(selector(current))) {
//         yield current;
//       }
//     }
//   }
// }

// extension IterableChunked<E> on Iterable<E> {
//   /// Splits this collection into a new lazy [Iterable] of lists each not
//   /// exceeding the given [size].
//   ///
//   /// The last list in the resulting list may have less elements than the given
//   /// [size].
//   ///
//   /// [size] must be positive and can be greater than the number of elements in
//   /// this collection.
//   Iterable<List<E>> chunked(int size) sync* {
//     if (size < 1) {
//       throw ArgumentError('Requested chunk size $size is less than one.');
//     }

//     var currentChunk = <E>[];
//     for (final current in this) {
//       currentChunk.add(current);
//       if (currentChunk.length >= size) {
//         yield currentChunk;
//         currentChunk = <E>[];
//       }
//     }
//     if (currentChunk.isNotEmpty) {
//       yield currentChunk;
//     }
//   }
// }

// extension IterableChunkWhile<E> on Iterable<E> {
//   /// Splits this collection into a lazy [Iterable] of chunks, where chunks are
//   /// created as long as [predicate] is true for a pair of entries.
//   ///
//   /// For example, one-by-one increasing subsequences can be chunked as follows:
//   /// ```dart
//   /// final list = [1, 2, 4, 9, 10, 11, 12, 15, 16, 19, 20, 21];
//   /// final increasingSubSequences = list.chunkWhile((a, b) => a + 1 == b);
//   /// ```
//   ///
//   /// Here, `increasingSubSequences` would consist of `[1, 2]`, `[4]`,
//   /// `[9, 10, 11]`, `[12]`, `[15, 16]` and finally `[19, 20, 21]`.
//   ///
//   /// See also:
//   ///  - [splitWhen], which works similarly but with a reverted [predicate].
//   Iterable<List<E>> chunkWhile(bool Function(E, E) predicate) sync* {
//     var currentChunk = <E>[];
//     var hasPrevious = false;
//     late E previous;

//     for (final element in this) {
//       if (!hasPrevious || predicate(previous, element)) {
//         // keep element in current chunk
//         currentChunk.add(element);
//       } else {
//         // start a new chunk containing the new element
//         yield currentChunk;
//         currentChunk = [element];
//       }

//       previous = element;
//       hasPrevious = true;
//     }

//     if (currentChunk.isNotEmpty) yield currentChunk;
//   }
// }

// extension IterableSplitWhen<E> on Iterable<E> {
//   /// Splits this collection into a lazy [Iterable], where each split will be
//   /// make if [predicate] returns true for a pair of entries.
//   ///
//   /// For example, one could split the iterable at each changed value like this:
//   /// ```dart
//   /// final list = [1, 1, 1, 2, 2, 1, 4, 4];
//   /// final splitted = list.splitWhen((a, b) => a != b);
//   /// ```
//   ///
//   /// In that example, `splitted` would consist of `[1, 1, 1, 1]`, `[2, 2]`,
//   /// `[1]`, `[4, 4]`.
//   ///
//   /// See also:
//   ///  - [chunkWhile], which works similarly but with a reverted [predicate].
//   Iterable<List<E>> splitWhen(bool Function(E, E) predicate) {
//     return chunkWhile((a, b) => !predicate(a, b));
//   }
// }

// extension IterableWindowed<E> on Iterable<E> {
//   /// Returns a new lazy [Iterable] of windows of the given [size] sliding along
//   /// this collection with the given [step].
//   ///
//   /// The last list may have less elements than the given size.
//   ///
//   /// Both [size] and [step] must be positive and can be greater than the number
//   /// of elements in this collection.
//   Iterable<List<E>> windowed(
//     int size, {
//     int step = 1,
//     bool partialWindows = false,
//   }) sync* {
//     final gap = step - size;
//     if (gap >= 0) {
//       var buffer = <E>[];
//       var skip = 0;
//       for (final element in this) {
//         if (skip > 0) {
//           skip -= 1;
//           continue;
//         }
//         buffer.add(element);
//         if (buffer.length == size) {
//           yield buffer;
//           buffer = <E>[];
//           skip = gap;
//         }
//       }
//       if (buffer.isNotEmpty && (partialWindows || buffer.length == size)) {
//         yield buffer;
//       }
//     } else {
//       final buffer = ListQueue<E>(size);
//       for (final element in this) {
//         buffer.add(element);
//         if (buffer.length == size) {
//           yield buffer.toList();
//           for (var i = 0; i < step; i++) {
//             buffer.removeFirst();
//           }
//         }
//       }
//       if (partialWindows) {
//         while (buffer.length > step) {
//           yield buffer.toList();
//           for (var i = 0; i < step; i++) {
//             buffer.removeFirst();
//           }
//         }
//         if (buffer.isNotEmpty) {
//           yield buffer.toList();
//         }
//       }
//     }
//   }
// }

// extension IterableFlatMap<E> on Iterable<E> {
//   /// Returns a new lazy [Iterable] of all elements yielded from results of
//   /// [transform] function being invoked on each element of this collection.
//   Iterable<R> flatMap<R>(Iterable<R> Function(E element) transform) sync* {
//     for (final current in this) {
//       yield* transform(current);
//     }
//   }
// }

// extension IterableCycle<E> on Iterable<E> {
//   /// Returns a new lazy [Iterable] which iterates over this collection [n]
//   /// times.
//   ///
//   /// When it reaches the end, it jumps back to the beginning. Returns `null`
//   /// [n] times if the collection is empty.
//   ///
//   /// If [n] is omitted, the Iterable cycles forever.
//   Iterable<E> cycle([int? n]) sync* {
//     var it = iterator;
//     if (!it.moveNext()) {
//       return;
//     }
//     if (n == null) {
//       yield it.current;
//       // ignore: literal_only_boolean_expressions
//       while (true) {
//         while (it.moveNext()) {
//           yield it.current;
//         }
//         it = iterator;
//       }
//     } else {
//       var count = 0;
//       yield it.current;
//       while (count++ < n) {
//         while (it.moveNext()) {
//           yield it.current;
//         }
//         it = iterator;
//       }
//     }
//   }
// }

// extension IterableIntersect<E> on Iterable<E> {
//   /// Returns a new lazy [Iterable] containing all elements that are contained
//   /// by both this collection and the [other] collection.
//   ///
//   /// The returned collection preserves the element iteration order of the
//   /// this collection.
//   Iterable<E> intersect(Iterable<E> other) sync* {
//     final second = HashSet<E>.from(other);
//     final output = HashSet<E>();
//     for (final current in this) {
//       if (second.contains(current)) {
//         if (output.add(current)) {
//           yield current;
//         }
//       }
//     }
//   }
// }

// extension IterableExcept<E> on Iterable<E> {
//   /// Returns a new lazy [Iterable] containing all elements of this collection
//   /// except the elements contained in the given [elements] collection.
//   Iterable<E> except(Iterable<E> elements) sync* {
//     for (final current in this) {
//       if (!elements.contains(current)) yield current;
//     }
//   }
// }

// extension IterableMinus<E> on Iterable<E> {
//   /// Returns a new list containing all elements of this collection except the
//   /// elements contained in the given [elements] collection.
//   List<E> operator -(Iterable<E> elements) => except(elements).toList();
// }

// extension IterableExceptElement<E> on Iterable<E> {
//   /// Returns a new lazy [Iterable] containing all elements of this collection
//   /// except the given [element].
//   Iterable<E> exceptElement(E element) sync* {
//     for (final current in this) {
//       if (element != current) yield current;
//     }
//   }
// }

// extension IterablePrepend<E> on Iterable<E> {
//   /// Returns a new lazy [Iterable] containing all elements of this collection
//   /// and then all elements of the given [elements] collection.
//   Iterable<E> prepend(Iterable<E> elements) sync* {
//     yield* elements;
//     yield* this;
//   }
// }

// extension IterablePrependElement<E> on Iterable<E> {
//   /// Returns a new lazy [Iterable] containing all elements of this collection
//   /// and then the given [element].
//   Iterable<E> prependElement(E element) sync* {
//     yield element;
//     yield* this;
//   }
// }

// extension IterableAppend<E> on Iterable<E> {
//   /// Returns a new lazy [Iterable] containing all elements of the given
//   /// [elements] collection and then all elements of this collection.
//   Iterable<E> append(Iterable<E> elements) sync* {
//     yield* this;
//     yield* elements;
//   }
// }

// extension IterablePlus<E> on Iterable<E> {
//   /// Returns a new list containing all elements of the given [elements]
//   /// collection and then all elements of this collection.
//   List<E> operator +(Iterable<E> elements) => append(elements).toList();
// }

// extension IterableAppendElement<E> on Iterable<E> {
//   /// Returns a new lazy [Iterable] containing the given [element] and then all
//   /// elements of this collection.
//   Iterable<E> appendElement(E element) sync* {
//     yield* this;
//     yield element;
//   }
// }

// extension IterableUnion<E> on Iterable<E> {
//   /// Returns a new lazy [Iterable] containing all distinct elements from
//   /// both collections.
//   ///
//   /// The returned set preserves the element iteration order of this collection.
//   /// Those elements of the [other] collection that are unique are iterated in
//   /// the end in the order of the [other] collection.
//   Iterable<E> union(Iterable<E> other) sync* {
//     final existing = HashSet<E>();
//     for (final element in this) {
//       if (existing.add(element)) yield element;
//     }

//     for (final element in other) {
//       if (existing.add(element)) yield element;
//     }
//   }
// }

// extension IterableZip<E> on Iterable<E> {
//   /// Returns a new lazy [Iterable] of values built from the elements of this
//   /// collection and the [other] collection with the same index.
//   ///
//   /// Using the provided [transform] function applied to each pair of elements.
//   /// The returned list has length of the shortest collection.
//   ///
//   /// Example (with added type definitions for [transform] parameters):
//   ///
//   /// ```dart
//   ///final amounts = [2, 3, 4];
//   ///final animals = ['dogs', 'birds', 'cats'];
//   ///final all = amounts.zip(
//   ///  animals,
//   ///  (int amount, String animal) => '$amount $animal'
//   ///);  // returns: ['2 dogs', '3 birds', '4 cats']
//   /// ```
//   Iterable<V> zip<R, V>(
//     Iterable<R> other,
//     V Function(E a, R b) transform,
//   ) sync* {
//     final it1 = iterator;
//     final it2 = other.iterator;
//     while (it1.moveNext() && it2.moveNext()) {
//       yield transform(it1.current, it2.current);
//     }
//   }
// }

// extension IterableToIterable<E> on Iterable<E> {
//   /// Returns a new lazy [Iterable] with all elements of this collection.
//   Iterable<E> toIterable() sync* {
//     yield* this;
//   }
// }

// extension IterableAsStream<E> on Iterable<E> {
//   /// Returns a new [Stream] with all elements of this collection.
//   Stream<E> asStream() => Stream.fromIterable(this);
// }

// extension IterableToHashSet<E> on Iterable<E> {
//   /// Returns a new [HashSet] with all distinct elements of this collection.
//   HashSet<E> toHashSet() => HashSet.from(this);
// }

// extension IterableToUnmodifiable<E> on Iterable<E> {
//   /// Returns an unmodifiable List view of this collection.
//   List<E> toUnmodifiable() => collection.UnmodifiableListView(this);
// }

// extension IterableShuffled<E> on Iterable<E> {
//   /// Returns a new, randomly shuffled list.
//   ///
//   /// If [random] is given, it is being used for random number generation.
//   List<E> shuffled([Random? random]) => toList()..shuffle(random);
// }

// extension IterableAssociate<E> on Iterable<E> {
//   /// Returns a Map containing key-value pairs provided by [transform] function
//   /// applied to elements of this collection.
//   ///
//   /// If any of two pairs would have the same key the last one gets added to the
//   /// map.
//   Map<K, V> associate<K, V>(MapEntry<K, V> Function(E element) transform) {
//     final map = <K, V>{};
//     for (final element in this) {
//       final entry = transform(element);
//       map[entry.key] = entry.value;
//     }
//     return map;
//   }
// }

// extension IterableAssociateBy<E> on Iterable<E> {
//   /// Returns a Map containing the elements from the collection indexed by
//   /// the key returned from [keySelector] function applied to each element.
//   ///
//   /// If any two elements would have the same key returned by [keySelector] the
//   /// last one gets added to the map.
//   Map<K, E> associateBy<K>(K Function(E element) keySelector) {
//     final map = <K, E>{};
//     for (final current in this) {
//       map[keySelector(current)] = current;
//     }
//     return map;
//   }
// }

// extension IterableAssociateWith<E> on Iterable<E> {
//   /// Returns a Map containing the values returned from [valueSelector] function
//   /// applied to each element indexed by the elements from the collection.
//   ///
//   /// If any of elements (-> keys) would be the same the last one gets added
//   /// to the map.
//   Map<E, V> associateWith<V>(V Function(E element) valueSelector) {
//     final map = <E, V>{};
//     for (final current in this) {
//       map[current] = valueSelector(current);
//     }
//     return map;
//   }
// }

// extension IterableGroupBy<E> on Iterable<E> {
//   /// Groups elements of the original collection by the key returned by the
//   /// given [keySelector] function applied to each element and returns a map.
//   ///
//   /// Each group key is associated with a list of corresponding elements.
//   ///
//   /// The returned map preserves the entry iteration order of the keys produced
//   /// from the original collection.
//   Map<K, List<E>> groupBy<K>(K Function(E element) keySelector) {
//     return collection.groupBy(this, keySelector);
//   }
// }

// extension IterablePartition<E> on Iterable<E> {
//   /// Splits the collection into two lists according to [predicate].
//   ///
//   /// The first list contains elements for which [predicate] yielded true,
//   /// while the second list contains elements for which [predicate] yielded
//   /// false.
//   List<List<E>> partition(bool Function(E element) predicate) {
//     final t = <E>[];
//     final f = <E>[];
//     for (final element in this) {
//       if (predicate(element)) {
//         t.add(element);
//       } else {
//         f.add(element);
//       }
//     }
//     return [t, f];
//   }
// }

// extension IterableCached<E> on Iterable<E> {
//   /// Returns a new lazy [Iterable] that caches the computation of the current
//   /// [Iterable].
//   ///
//   /// This is an alternative to [toList] to not recompute the collection
//   /// multiple times, without having to lose the lazy loading aspect of
//   /// [Iterable].
//   Iterable<E> get cached => _CachedIterable<E>(this);
// }

// class _CachedIterable<T> extends IterableBase<T> {
//   _CachedIterable(Iterable<T> iterable)
//       : _uncomputedIterator = iterable.iterator;

//   final Iterator<T> _uncomputedIterator;
//   final _cache = _IterableCache<T>(null);

//   @override
//   Iterator<T> get iterator => _CachedIterator<T>(_cache, _uncomputedIterator);
// }

// class _CachedIterator<T> extends Iterator<T> {
//   _CachedIterator(_IterableCache<T> cache, this._uncomputedIterator)
//       // ignore: prefer_initializing_formals
//       : _cache = cache,
//         _latestValidCache = cache;

//   _IterableCache<T>? _cache;

//   /// A reference to the latest non-null [_cache].
//   ///
//   /// This allows adding new items to the cache
//   _IterableCache<T> _latestValidCache;
//   final Iterator<T> _uncomputedIterator;

//   @override
//   T get current => _current as T;
//   T? _current;

//   @override
//   bool moveNext() {
//     final next = _cache?.next;
//     _cache = next;
//     if (next != null) {
//       _current = next.value;
//       _latestValidCache = next;
//       return true;
//     }
//     if (_uncomputedIterator.moveNext()) {
//       _current = _uncomputedIterator.current;
//       assert(_latestValidCache.next == null);
//       _latestValidCache.next = _IterableCache(current);
//       _latestValidCache = _latestValidCache.next!;
//       return true;
//     }
//     return false;
//   }
// }

// /// A LinkedList that does not throw concurrent modification errors.
// class _IterableCache<T> {
//   _IterableCache(this.value);

//   _IterableCache<T>? next;
//   final T? value;
// }

// extension IterableIterableX<E> on Iterable<Iterable<E>> {
//   /// Returns a new lazy [Iterable] of all elements from all collections in this
//   /// collection.
//   ///
//   /// ```dart
//   /// final nestedList = List([[1, 2, 3], [4, 5, 6]]);
//   /// final flattened = nestedList.flatten(); // [1, 2, 3, 4, 5, 6]
//   /// ```
//   Iterable<E> flatten() sync* {
//     for (final current in this) {
//       yield* current;
//     }
//   }
// }

// extension IterableFutureX<E> on Iterable<Future<E>> {
//   /// Create a stream from a group of futures.
//   ///
//   /// The stream reports the results of the futures on the stream in the order
//   /// in which the futures complete.
//   /// Each future provides either a data event or an error event,
//   /// depending on how the future completes.
//   ///
//   /// If some futures have already completed when `Stream.fromFutures` is
//   /// called, their results will be emitted in some unspecified order.
//   ///
//   /// When all futures have completed, the stream is closed.
//   Stream<E> asStreamAwaited() => Stream.fromFutures(this);
// }

// extension IterableStartsWithExtension<E> on Iterable<E> {
//  /// Returns if this [Iterable] starts with the elements of [otherIterable].
  ///
  /// If [otherIterable] is empty, `true` is returned. If [otherIterable] has
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
//   bool startsWith(Iterable<E> otherIterable) {
//     final thisIterator = iterator;
//     final otherIterator = otherIterable.iterator;
//     if (!otherIterator.moveNext()) return true;
//     do {
//       // this iterator is empty or the current elements are different
//       if (!thisIterator.moveNext() ||
//           otherIterator.current != thisIterator.current) {
//         return false;
//       }
//     } while (otherIterator.moveNext());
//     return true;
//   }
// }

// import 'package:collection/collection.dart' as collection;

// extension ListExtension<E> on List<E> {
//   /// Index of the first element or -1 if the collection is empty.
//   ///
//   /// ```dart
//   /// [1, 2, 3].firstIndex; // 0
//   ///
//   /// [].firstIndex; // -1
//   /// ```
//   int get firstIndex => isNotEmpty ? 0 : -1;
// }

// extension ListLastIndexExtension<E> on List<E> {
//   /// Index of the last element or -1 if the collection is empty.
//   ///
//   /// ```dart
//   /// [1, 2, 3].lastIndex; // 2
//   ///
//   /// [].lastIndex; // -1
//   /// ```
//   int get lastIndex => length - 1;
// }

// extension ListElementAtOrNull<E> on List<E> {
//   /// Returns an element at the given [index] or `null` if the [index] is out of
//   /// bounds of this list.
//   ///
//   /// ```dart
//   /// final list = [1, 2, 3, 4];
//   /// final first = list.elementAtOrNull(0); // 1
//   /// final fifth = list.elementAtOrNull(4); // null
//   /// ```
//   E? elementAtOrNull(int index) {
//     if (index < 0) return null;
//     if (index >= length) return null;
//     return this[index];
//   }
// }

// extension ListIndicesExtension<E> on List<E> {
//   Iterable<int> get indices sync* {
//     var index = 0;
//     while (index <= lastIndex) {
//       yield index++;
//     }
//   }
// }

// extension ListDropExtension<E> on List<E> {
//   /// Returns a new list containing all elements except first [n] elements.
//   List<E> drop(int n) {
//     if (n < 0) {
//       throw ArgumentError('Requested element count $n is less than zero.');
//     }
//     if (n == 0) toList();

//     final resultSize = length - n;
//     if (resultSize <= 0) return [];
//     if (resultSize == 1) return [last!];
//     return sublist(n);
//   }
// }

// extension ListDropWhileExtension<E> on List<E> {
//   /// Returns a new list containing all elements except last elements that
//   /// satisfy the given [predicate].
//   List<E> dropWhile(bool Function(E element) predicate) {
//     int? startIndex;
//     for (var i = 0; i < length; i++) {
//       if (!predicate(this[i])) {
//         startIndex = i;
//         break;
//       }
//     }
//     if (startIndex == null) return [];
//     return sublist(startIndex);
//   }
// }

// extension ListDropLastExtension<E> on List<E> {
//   /// Returns a new list containing all elements except last [n] elements.
//   List<E> dropLast(int n) {
//     if (n < 0) {
//       throw ArgumentError('Requested element count $n is less than zero.');
//     }
//     if (n == 0) toList();

//     final resultSize = length - n;
//     if (resultSize <= 0) return [];
//     if (resultSize == 1) return [first];
//     return sublist(0, length - n);
//   }
// }

// extension ListDropLastWhileExtension<E> on List<E> {
//   /// Returns a new list containing all elements except last elements that
//   /// satisfy the given [predicate].
//   List<E> dropLastWhile(bool Function(E element) predicate) {
//     int? endIndex;
//     for (var i = lastIndex; i >= 0; i--) {
//       if (!predicate(this[i])) {
//         endIndex = i;
//         break;
//       }
//     }
//     if (endIndex == null) return [];
//     return sublist(0, endIndex + 1);
//   }
// }

// extension ListLowerBoundExtension<E> on List<E> {
//   /// Returns the first position in this list that does not compare less than
//   /// [value].
//   ///
//   /// If this list isn't sorted according to the [compare] function, the result
//   /// is unpredictable.
//   ///
//   /// If [compare] is omitted, this defaults to calling [Comparable.compareTo]
//   /// on the objects. If any object is not [Comparable], this throws a
//   /// [TypeError].
//   ///
//   /// Returns [length] if all the items in this list compare less than [value].
//   int lowerBound(E value, {int Function(E a, E b)? compare}) {
//     return collection.lowerBound(this, value, compare: compare);
//   }
// }

// extension ListBinarySearchExtension<E> on List<E> {
//   /// Returns a position of the [value] in this list, if it is there.
//   ///
//   /// If the list isn't sorted according to the [compare] function, the result
//   /// is unpredictable.
//   ///
//   /// If [compare] is omitted, this defaults to calling [Comparable.compareTo]
//   /// on the objects. If any object is not [Comparable], this throws a
//   /// [TypeError].
//   ///
//   /// Returns -1 if [value] is not in the list by default.
//   int binarySearch(E value, {int Function(E a, E b)? compare}) {
//     return collection.binarySearch(this, value, compare: compare);
//   }
// }

// extension ListInsertionSortExtension<E> on List<E> {
//   /// Sort this list between [start] (inclusive) and [end] (exclusive) using
//   /// insertion sort.
//   ///
//   /// If [comparator] is omitted, this defaults to calling
//   /// [Comparable.compareTo] on the objects. If any object is not [Comparable],
//   /// this throws a [TypeError].
//   ///
//   /// Insertion sort is a simple sorting algorithm. For `n` elements it does on
//   /// the order of `n * log(n)` comparisons but up to `n` squared moves. The
//   /// sorting is performed in-place, without using extra memory.
//   ///
//   /// For short lists the many moves have less impact than the simple algorithm,
//   /// and it is often the favored sorting algorithm for short lists.
//   ///
//   /// This insertion sort is stable: Equal elements end up in the same order
//   /// as they started in.
//   void insertionSort({Comparator<E>? comparator, int start = 0, int? end}) {
//     collection.insertionSort(this, compare: comparator, start: start, end: end);
//   }
// }

// extension ListMergeSortExtension<E> on List<E> {
//   /// Sorts this list between [start] (inclusive) and [end] (exclusive) using
//   /// the merge sort algorithm.
//   ///
//   /// If [comparator] is omitted, this defaults to calling
//   /// [Comparable.compareTo] on the objects. If any object is not [Comparable],
//   /// this throws a [CastError].
//   ///
//   /// Merge-sorting works by splitting the job into two parts, sorting each
//   /// recursively, and then merging the two sorted parts.
//   ///
//   /// This takes on the order of `n * log(n)` comparisons and moves to sort
//   /// `n` elements, but requires extra space of about the same size as the list
//   /// being sorted.
//   ///
//   /// This merge sort is stable: Equal elements end up in the same order
//   /// as they started in.
//   void mergeSort({int start = 0, int? end, Comparator<E>? comparator}) {
//     collection.mergeSort(this, start: start, end: end, compare: comparator);
//   }
// }

// extension ListSwapExtension<E> on List<E> {
//   /// Swaps the elements in the indices provided.
//   ///
//   /// ```dart
//   /// final list = [1, 2, 3, 4];
//   /// list.swap(0, 2); // [3, 2, 1, 4]
//   /// ```
//   void swap(int indexA, int indexB) {
//     final temp = this[indexA];
//     this[indexA] = this[indexB];
//     this[indexB] = temp;
//   }
// }

// extension ListFlattenExtension<E> on List<List<E>> {
//   /// Returns a new [List] of all elements from all lists in this
//   /// [List].
//   ///
//   /// ```dart
//   /// final nestedList = [[1, 2, 3], [4, 5, 6]];
//   /// final flattened = nestedList.flatten(); // [1, 2, 3, 4, 5, 6]
//   /// ```
//   ///
//   ///
//   /// This is a specialization of [IterableIterableX].flatten() which allows
//   /// accessing elements by index afterwards
//   ///
//   /// ```dart
//   /// final flat = [['a', 'b'], ['c', 'd']].flatten();
//   /// print(flat[2]); // prints "c"
//   /// ```
//   List<E> flatten() => [for (final list in this) ...list];
// }

