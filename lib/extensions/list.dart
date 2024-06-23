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

  T? firstWhereOrNull(bool Function(T element) comparator) {
    try {
      return firstWhere(comparator);
    } on StateError catch (_) {
      return null;
    }
  }
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
