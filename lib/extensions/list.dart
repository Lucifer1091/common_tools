part of 'extensions.dart';

extension IterableWithIndex<T> on Iterable<T> {
  Iterable<T> sortByAsc<TSelected extends Comparable<TSelected>>(
          TSelected Function(T) selector) =>
      toList()..sort((a, b) => selector(a).compareTo(selector(b)));

  Iterable<T> sortByDesc<TSelected extends Comparable<TSelected>>(
          TSelected Function(T) selector) =>
      toList()..sort((a, b) => selector(b).compareTo(selector(a)));

  Iterable<E> mapWithIndex<E>(E Function(int index, T value) f) {
    return Iterable.generate(length).map((i) => f(i, elementAt(i)));
  }

  // returns only distinct elements
  Iterable<T> distinctBy(Object Function(T e) getCompareValue) {
    var result = <T>[];
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
    int index = random.nextInt(length);
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
  Iterable<T> hugBy(T hugger) {
    return [
      hugger,
      ...this,
      hugger,
    ];
  }

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
  bool anyType<S extends T>() {
    return whereType<S>().isNotEmpty;
  }

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
  // T? firstWhereOrNull(bool Function(T element) test) {
  //   for (final element in this) {
  //     if (test(element)) return element;
  //   }
  //   return null;
  // }

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
    for (final item in this) {
      l.addAll(item);
    }
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

  /// Returns the last element matching the given [predicate], or null if element was not found.
  ///  ["Flutter", "Dart", "Java", "IOS", "Android","web"].lastOrNullIf((it) => it.length == 9); // null
  ///  ["Flutter", "Dart", "Java", "IOS", "Android","web"].lastOrNullIf((it) => it.length == 3); // IOS
  T? firstWhereOrNull(bool Function(T element) test) {
    if (isNullOrEmpty) {
      return null;
    }
    final list = this!.where(test);
    return list.isEmpty ? null : list.first;
  }

  /// Returns the last element matching the given [predicate], or null if element was not found.
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
    List<T> list = [];
    if (isNullOrEmpty) return list;
    var thisList = this!.toList();
    return thisList..removeAt(0);
  }

  //remove Last element in [list]
  List<T> get removeLastElement {
    List<T> list = [];
    if (isNullOrEmpty) return list;
    var thisList = this!.toList();
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

    var list = <T>[];
    if (this is Iterable) {
      if (n >= this!.length) return this!.toList();

      var count = 0;
      var thisList = this!.toList();
      for (var item in thisList) {
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

  /// Returns a list containing only elements matching the given [predicate]
  Iterable<T> filterOrNewList(bool Function(T e) fun) {
    if (isNullOrEmpty) {
      return [];
    }
    final result = <T>[];
    for (var element in this!) {
      if (fun(element)) result.add(element);
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

  /// Returns a list containing all elements not matching the given [predicate]
  Iterable<T> filterNot(bool Function(T element) fun) {
    if (isNullOrEmpty) {
      return [];
    }
    final result = <T>[];
    for (var element in this!) {
      if (!fun(element)) result.add(element);
    }
    return result;
  }
}

extension ListExt<T> on List<T>? {
  ///convert List to List of widget
  List<Widget> toWidgetList(Widget Function(T value) mapFunc) =>
      isNullOrEmpty ? [] : [...this!.map(mapFunc)];

  bool get isNullOrEmpty =>
      (this == null || (this?.isEmpty ?? true)) ? true : false;

  int? get lastIndex => isNullOrEmpty ? this!.length - 1 : null;

  /// Remove all occurrences of [item] from the list.
  void removeAll(T item) {
    if (isNullOrEmpty) return;
    while (this!.contains(item)) {
      this!.remove(item);
    }
  }

  /// Counts the elements for whichs the predicate holds.
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
    List<T> list = <T>[];
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
    List<List<T>> nestedLists = [];
    List<T> currentSublist = [];
    if (isNullOrEmpty) return [];

    for (T element in this ?? []) {
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
      throw ArgumentError("Range size must be greater than zero.");
    }

    List<List<T>> nestedLists = [];

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
  Map<K, List<T>> groupBy<K>(K Function(T) keyFunction) {
    return fold(
      <K, List<T>>{},
      (Map<K, List<T>> map, T element) {
        return map..putIfAbsent(keyFunction(element), () => <T>[]).add(element);
      },
    );
  }

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
    List<E> result = [];
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
  List<E> operator +(List<E> data) {
    return [...this, ...data];
  }
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
    var sorted = [...this]..sort();
    if (length % 2 == 0) {
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
    for (var element in this!) {
      action(element!, index++);
    }
  }

  /// Example:
  /// ```dart
  /// [1, 3, 7].sumBy((n) => n);                 // 11
  /// ['hello', 'world'].sumBy((s) => s.length); // 10
  /// ```
  int sumBy(int Function(T) selector) {
    return this.validate().map(selector).fold(0, (prev, curr) => prev + curr);
  }

  /// Example:
  /// ```dart
  /// [1.5, 2.5].sumByDouble((d) => 0.5 * d); // 2.0
  /// ```
  double sumByDouble(num Function(T) selector) {
    return this.validate().map(selector).fold(0.0, (prev, curr) => prev + curr);
  }

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
  bool any(bool Function(T element) predicate) {
    if (isNullOrEmpty) return false;
    for (final element in this!) {
      if (predicate(element)) return true;
    }
    return false;
  }

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
  Set<T> intersect(Iterable other) {
    final set = this.toSet();
    set.retainAll(other);
    return set;
  }

  /// Returns a set containing all elements that are contained
  /// by this collection and not contained by the specified collection.
  Set<T> subtract(Iterable<T> other) {
    final set = toSet();
    set.removeAll(other);
    return set;
  }

  /// Returns a set containing all distinct elements from both collections.
  Set<T> union(Iterable<T> other) {
    final set = toSet();
    set.addAll(other);
    return set;
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
  void forEachIndexed(void Function(T element, int index) action) {
    var index = 0;
    for (var element in this!) {
      action(element, index++);
    }
  }

  /// Groups elements of the original collection by the key returned by the given [keySelector] function
  /// applied to each element and returns a map where each group key is associated with a list of corresponding elements.
  ///
  /// The returned map preserves the entry iteration order of the keys produced from the original collection.
  Map<K, List<R>> groupBy<R, K>(K Function(R e) keySelector) {
    if (this == null) return {};
    var map = <K, List<R>>{};

    for (final element in this!) {
      var list = map.putIfAbsent(keySelector(element as R), () => []);
      list.add(element);
    }
    return map;
  }

  /// Returns a list containing only elements matching the given [predicate!]
  List<T> filter(bool Function(T element) test) {
    if (this == null) return <T>[];
    final result = <T>[];
    for (var e in this!) {
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
    for (var e in this!) {
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
    for (var e in this!) {
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

    var list = <T>[];
    if (this is Iterable) {
      if (n >= this!.length) return this!.toList();

      var count = 0;
      var thisList = this!.toList();
      for (var item in thisList) {
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
      'Dart natively supports this function. Read DartDoc comment for more info.')
  double sumSC() {
    return sumByDouble((n) => n);
  }

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
      'Dart natively supports this function. Read DartDoc comment for more info.')
  double? averageSC() {
    return averageBy((n) => n);
  }

  /// Returns the largest value of all elements
  /// If collection is empty this returns `null`.
  ///
  /// Example:
  /// ```dart
  /// [9.0, 42.0, 3.0].max(); // 42.0
  /// ```
  double? max() {
    return maxBy((a, b) => a.compareTo(b));
  }

  /// Returns the lowest value of all elements
  /// If collection is empty this returns `null`.
  ///
  /// Example:
  /// ```dart
  /// [17.0, 13.0, 92.0].min(); // 13.0
  /// ```
  double? min() {
    return minBy((a, b) => a.compareTo(b));
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
      'Dart natively supports this function. Read DartDoc comment for more info.')
  int sumSC() {
    return sumBy((n) => n);
  }

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
      'Dart natively supports this function. Read DartDoc comment for more info.')
  double? averageSC() {
    return averageBy((n) => n);
  }

  /// Returns the largest value of all elements
  /// If collection is empty this returns `null`.
  ///
  /// Example:
  /// ```dart
  /// [9, 42, 3].max(); // 42
  /// ```
  int? max() {
    return maxBy((a, b) => a.compareTo(b));
  }

  /// Returns the lowest value of all elements
  /// If collection is empty this returns `null`.
  ///
  /// Example:
  /// ```dart
  /// [17, 13, 92].min(); // 13
  /// ```
  int? min() {
    return minBy((a, b) => a.compareTo(b));
  }
}

/// Supercharged extensions on [Iterables] like [List] and [Set].
extension IterableSC<T> on Iterable<T> {
  /// Returns the sum of all values produced by the [selector] function that is
  /// applied to each element.
  ///
  /// Example:
  /// ```dart
  /// [2, 4, 6].sumBy((n) => n);                   // 12
  /// ['hello', 'flutter'].sumBy((s) => s.length); // 12
  /// ```
  int sumBy(int Function(T) selector) {
    return map(selector).fold(0, (prev, curr) => prev + curr);
  }

  /// Returns the sum of all values produced by the [selector] function that is
  /// applied to each element.
  ///
  /// Example:
  /// ```dart
  /// [1.5, 2.5].sumByDouble((d) => 0.5 * d); // 2.0
  /// ```
  double sumByDouble(num Function(T) selector) {
    return map(selector).fold(0.0, (prev, curr) => prev + curr);
  }

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

    var countOfChunks = (length / size.toDouble()).ceil();

    return Iterable.generate(countOfChunks, (int index) {
      var chunk = skip(index * size).take(size).toList();

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
  /// If not [test] is specified it will count every element.
  ///
  /// Example:
  /// ```dart
  /// [1, 2, 3, 13, 14, 15].count();             // 6
  /// [1, 2, 3, 13, 14, 15].count((n) => n > 9); // 3
  /// ```
  int count([bool Function(T element)? test]) {
    final testFn = test ?? (_) => true;

    if (isEmpty) {
      return 0;
    }

    return map((element) => testFn(element) ? 1 : 0)
        .reduce((value, element) => value + element);
  }

  /// Returns a new [Iterable] with all elements that satisfy the
  /// predicate [test].
  ///
  /// Example:
  /// ```dart
  /// [1, 2, 3, 4].filter((n) => n < 3).toList(); // [1,2]
  /// ```
  ///
  /// This method is an alias for [where].
  Iterable<T> filter(bool Function(T element) test) {
    return where(test);
  }

  /// Deprecation hint: Read the
  /// [migration guide](https://github.com/felixblaschke/supercharged/blob/master/migration_v2.md)
  /// for more details on migrating.
  ///
  /// Applies the function [funcIndexValue] to each element of this collection
  /// in iteration order. The function receives the element index as first
  /// parameter [index] and the [element] as the second parameter.
  ///
  /// Applies the function [funcIndexValue] to each element of this collection
  /// in iteration order. The function receives the element index as first
  /// parameter [index] and the [element] as the second parameter.
  ///
  /// Example:
  /// ```dart
  /// ['a', 'b', 'c'].forEachIndex((index, value) {
  ///   print('$index : $value'); // '0 : a', '1: b', '2: c'
  /// });
  /// ```
  @Deprecated(
      'Dart natively supports this function. Read DartDoc comment for more info.')
  void forEachIndexedSC(void Function(int index, T element) funcIndexValue) {
    var index = 0;
    var iter = iterator;
    while (iter.moveNext()) {
      funcIndexValue(index++, iter.current);
    }
  }

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
    } catch (error) {
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
  T firstOrElse(T Function() orElse) {
    return firstWhere((_) => true, orElse: orElse);
  }

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
      'Dart natively supports this function. Read DartDoc comment for more info.')
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
  T lastOrElse(T Function() orElse) {
    return lastWhere((_) => true, orElse: orElse);
  }

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
      'Dart natively supports this function. Read DartDoc comment for more info.')
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
  Map<K, List<V>> groupBy<K, V>(K Function(T element) keySelector,
      {V Function(T element)? valueTransform}) {
    final transformFn = valueTransform ?? (element) => element as V;

    var map = <K, List<V>>{};

    forEach((element) {
      var key = keySelector(element);

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
  Map<K, V> associate<K, V>(MapEntry<K, V> Function(T element) transform) {
    return Map.fromEntries(map(transform));
  }

  /// Returns a map where every [element] is associated by a key produced from
  /// the [keySelector] function.
  ///
  /// If two elements share the same key, the last one gets added to the map.
  ///
  /// Example:
  /// ```dart
  /// ['a', 'ab', 'abc'].associateBy((e) => e.length); // {1: 'a', 2: 'ab', 3: 'abc'}
  /// ```
  Map<K, T> associateBy<K>(K Function(T element) keySelector) {
    var map = <K, T>{};
    forEach((element) {
      var key = keySelector(element);
      map[key] = element;
    });
    return map;
  }

  /// Returns a map where every [element] is used as a key that is associated
  /// with a value produced by the [valueSelector] function.
  ///
  /// Example:
  /// ```dart
  /// [1, 2, 3].associateWith((e) => e * 1000); // {1: 1000, 2: 2000, 3: 3000}
  /// ```
  Map<T, V> associateWith<V>(V Function(T element) valueSelector) {
    var map = <T, V>{};
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
        (value, element) => comparator(value, element) < 0 ? value : element);
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
        (value, element) => comparator(value, element) > 0 ? value : element);
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
      'Dart natively supports this function. Read DartDoc comment for more info.')
  List<T> sortedBySC(Comparator<T> comparator) {
    var list = toList();
    list.sort(comparator);
    return list;
  }

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
      'Dart natively supports this function. Read DartDoc comment for more info.')
  List<T> sortedByNumSC(num Function(T element) valueProvider) {
    return sortedBySC((a, b) => valueProvider(a).compareTo(valueProvider(b)));
  }

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
      'Dart natively supports this function. Read DartDoc comment for more info.')
  List<T> sortedByStringSC(String Function(T element) valueProvider) {
    return sortedBySC((a, b) => valueProvider(a).compareTo(valueProvider(b)));
  }

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
    var iter = iterator;

    iter.moveNext(); // eat the first

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
    var iter = iterator;

    var hasFirst = iter.moveNext();

    if (!hasFirst) {
      return;
    }

    while (true) {
      var value = iter.current;
      var isLastOne = !iter.moveNext();
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

  /// Deprecation hint: Read the
  /// [migration guide](https://github.com/felixblaschke/supercharged/blob/master/migration_v2.md)
  /// for more details on migrating.
  ///
  /// Applies the function [funcIndexValue] to each element of this collection
  /// in iteration order. The function receives the element index as first
  /// parameter [index] and the [element] as the second parameter.
  ///
  /// Just like [map], but with access to the element's current index.
  ///
  /// Example
  /// ```dart
  /// [1, 2, 3].mapIndexed((number, index) => number * 2); // [2, 4, 6]
  /// ```
  @Deprecated(
      'Dart natively supports this function. Read DartDoc comment for more info.')
  Iterable<U> mapIndexedSC<U>(
    U Function(T currentValue, int index) transformer,
  ) sync* {
    final it = iterator;
    var index = 0;
    while (it.moveNext()) {
      yield transformer(it.current, index++);
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
  /// parameter [index] matching the element index.
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
    var list = toList();
    list.shuffle(random);
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
    var list = toList();
    list.shuffle(random);
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
  void removeAllList(List<T> items) {
    for (final item in items) {
      removeAll(item);
    }
  }

  /// Remove all occurrences of [Set] [items] from the list.
  void removeAllSet(Set<T> items) {
    for (final item in items) {
      removeAll(item);
    }
  }

  /// Remove all occurrences of [Iterable] [items] from the list.
  void removeAllIterable(Iterable<T> items) {
    for (final item in items) {
      removeAll(item);
    }
  }

  /// Remove all occurrences of [Map] [items] keys from the list.

  void removeAllMapKeys(Map<T, dynamic> items) {
    for (final item in items.keys) {
      removeAll(item);
    }
  }

  /// Remove all occurrences of [Map] [items] values from the list.

  void removeAllMapValues(Map<T, dynamic> items) {
    for (final item in items.values) {
      removeAll(item);
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
    final list = <T>[];
    list.addAll(this);
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
    final list = <T>[];
    list.addAll(this);
    list.sort((a, b) {
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
        return valueA.compareTo(valueB);
      } else if (valueA is String) {
        return valueA.compareTo(valueB);
      } else if (valueA is bool) {
        return valueA == valueB ? 0 : (valueA ? 1 : -1);
      } else if (valueA is DateTime) {
        return valueA.compareTo(valueB);
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
    final list = <T>[];
    list.addAll(this);
    list.sort((a, b) {
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
        return valueA.compareTo(valueB);
      } else if (valueA is String) {
        return valueA.compareTo(valueB);
      } else if (valueA is bool) {
        return valueA == valueB ? 0 : (valueA ? -1 : 1);
      } else if (valueA is DateTime) {
        return valueA.compareTo(valueB);
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
    final buffer = StringBuffer();
    buffer.write(prefix);
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
