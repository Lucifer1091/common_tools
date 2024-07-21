part of 'extensions.dart';

/// Supercharged extensions on [Map].
extension MapSC<K, V> on Map<K, V> {
  /// Returns a new [Iterable<MapEntry<K,V>>] with all elements that satisfy the
  /// predicate [test].
  ///
  /// Example:
  /// ```dart
  /// {'a': 1, 'b': 2, 'c': 3}.filter((e) => e.key == 'a').toMap(); // {'a': 1}
  /// ```
  Iterable<MapEntry<K, V>> filter(bool Function(MapEntry<K, V>) test) =>
      entries.filter(test);

  /// Returns the number of entries that matches the [test].
  ///
  /// If [test] is not specified it will count every entry.
  ///
  /// Example:
  /// ```dart
  /// [1, 2, 3, 13, 14, 15].count();             // 6
  /// [1, 2, 3, 13, 14, 15].count((n) => n > 9); // 3
  /// ```
  int count([bool Function(MapEntry<K, V> element)? test]) =>
      entries.count(test);

  /// Converts this map into a JSON string.
  ///
  /// Use optional parameter [toEncodable] to convert types that are not a
  /// number, boolean, string, null, list or a map with string keys.
  ///
  /// See [jsonEncode].
  ///
  /// Example:
  /// ```dart
  /// {'a': 1, 'b': 2}.toJSON(); // '''{'a':1,'b':2}'''
  /// ```
  String toJSON({Object? Function(Object? nonEncodable)? toEncodable}) =>
      jsonEncode(this, toEncodable: toEncodable);
}

extension MapUtils<K, V> on Map<K, V> {
  /// Returns `true` if the map is empty, `false` otherwise.
  bool get isEmpty => length == 0;

  /// Returns `true` if the map contains the specified [key] and [value], `false` otherwise.
  bool contains(Object key, Object value) =>
      containsKey(key) && this[key] == value;

  /// Returns `true` if the map contains the specified
  /// [key] and [value] and removes the entry, `false` otherwise.
  bool removeExact({required K key, required V? value}) {
    if (containsKey(key) && this[key] == value) {
      remove(key);
      return true;
    }
    return false;
  }

  /// Add prefix to all keys in the map.
  /// Returns a new map with prefixed keys.
  Map<String, V> prefixKeys(V prefix) {
    final map = <String, V>{};
    for (final key in keys) {
      map['$prefix$key'] = this[key] as V;
    }
    return map;
  }

  /// Add suffix to all keys in the map.
  /// Returns a new map with suffixed keys.
  Map<String, V> suffixKeys(V suffix) {
    final map = <String, V>{};
    for (final key in keys) {
      map['$key$suffix'] = this[key] as V;
    }
    return map;
  }

  /// Add prefix to all values in the map.
  /// Returns a new map with prefixed values.
  Map<K, String> prefixValues(K prefix) {
    final map = <K, String>{};
    for (final key in keys) {
      map[key] = '$prefix${this[key]}';
    }
    return map;
  }

  /// Add suffix to all values in the map.
  /// Returns a new map with suffixed values.
  Map<K, String> suffixValues(K suffix) {
    final map = <K, String>{};
    for (final key in keys) {
      map[key] = '${this[key]}$suffix';
    }
    return map;
  }

  /// Capitalize all keys in the map.
  /// Returns a new map with capitalized keys.
  Map<String, V> capitalizeKeys() {
    final map = <String, V>{};
    for (final key in keys) {
      map[key.toString().capitalize!] = this[key] as V;
    }
    return map;
  }

  /// Capitalize all values in the map.
  /// Returns a new map with capitalized values.
  Map<K, String> capitalizeValues() {
    final map = <K, String>{};
    for (final key in keys) {
      map[key] = this[key].toString().capitalize!;
    }
    return map;
  }

  /// Camel case all keys in the map.
  /// Returns a new map with camel cased keys.
  Map<String, V> camelCaseKeys() {
    final map = <String, V>{};
    for (final key in keys) {
      map[key.toString().toCamelCase!] = this[key] as V;
    }
    return map;
  }

  /// Camel case all values in the map.
  /// Returns a new map with camel cased values.
  Map<K, String> camelCaseValues() {
    final map = <K, String>{};
    for (final key in keys) {
      map[key] = this[key].toString().toCamelCase!;
    }
    return map;
  }

  /// Snake case all keys in the map.
  /// Returns a new map with snake cased keys.
  Map<String, V> snakeCaseKeys() {
    final map = <String, V>{};
    for (final key in keys) {
      map[key.toString().toSnakeCase!] = this[key] as V;
    }
    return map;
  }

  /// Snake case all values in the map.
  /// Returns a new map with snake cased values.

  Map<K, String> snakeCaseValues() {
    final map = <K, String>{};
    for (final key in keys) {
      map[key] = this[key].toString().toSnakeCase!;
    }
    return map;
  }

  /// Kebab case all keys in the map.
  /// Returns a new map with kebab cased keys.
  Map<String, V> kebabCaseKeys() {
    final map = <String, V>{};
    for (final key in keys) {
      map[key.toString().toKebabCase!] = this[key] as V;
    }
    return map;
  }

  /// Kebab case all values in the map.
  /// Returns a new map with kebab cased values.
  Map<K, String> kebabCaseValues() {
    final map = <K, String>{};
    for (final key in keys) {
      map[key] = this[key].toString().toKebabCase!;
    }
    return map;
  }

  /// Returns a new map with all entries that satisfy the given [predicate].
  /// The entries in the resulting map preserve the order of the original map.
  Map<K, V> filter(bool Function(K key, V value) predicate) {
    final map = <K, V>{};
    for (final key in keys) {
      if (predicate(key, this[key] as V)) {
        map[key] = this[key] as V;
      }
    }
    return map;
  }

  /// Returns a new map with all entries that do not satisfy the given [predicate].
  /// The entries in the resulting map preserve the order of the original map.
  Map<K, V> reject(bool Function(K key, V value) predicate) {
    final map = <K, V>{};
    for (final key in keys) {
      if (!predicate(key, this[key] as V)) {
        map[key] = this[key] as V;
      }
    }
    return map;
  }

  /// Filter null values from the map.
  /// Returns a new map with non-null values.
  Map<K, V> filterNull() {
    final map = <K, V>{};
    for (final key in keys) {
      if (this[key] != null) {
        map[key] = this[key] as V;
      }
    }
    return map;
  }

  /// Filter empty values from the map.
  /// Returns a new map with non-empty values.
  Map<K, V> filterEmpty() {
    final map = <K, V>{};
    for (final key in keys) {
      if (this[key] != null && this[key].toString().isNotEmpty) {
        map[key] = this[key] as V;
      }
    }
    return map;
  }

  /// Shift the first entry from the map.
  MapEntry<K, V?> shift() {
    final key = keys.first;
    final value = this[key];
    removeExact(key: key, value: value);
    return MapEntry(key, value);
  }

  /// Filter where the key is in the given [keys].
  /// Returns a new map with filtered entries.
  Map<K, V> filterKeys(Iterable<K> keys) {
    final map = <K, V>{};
    for (final key in keys) {
      if (containsKey(key)) {
        map[key] = this[key] as V;
      }
    }
    return map;
  }

  /// Filter where the value is in the given [values].
  /// Returns a new map with filtered entries.
  Map<K, V> filterValues(Iterable<V> values) {
    final map = <K, V>{};
    for (final key in keys) {
      if (values.contains(this[key])) {
        map[key] = this[key] as V;
      }
    }
    return map;
  }

  /// Filter where the key is not in the given [keys].
  /// Returns a new map with filtered entries.
  Map<K, V> rejectKeys(Iterable<K> keys) {
    final map = <K, V>{};
    for (final key in keys) {
      if (!containsKey(key)) {
        map[key] = this[key] as V;
      }
    }
    return map;
  }

  /// Filter where the value is not in the given [values].
  /// Returns a new map with filtered entries.
  Map<K, V> rejectValues(Iterable<V> values) {
    final map = <K, V>{};
    for (final key in keys) {
      if (!values.contains(this[key])) {
        map[key] = this[key] as V;
      }
    }
    return map;
  }

  /// Returns a new map with all entries that satisfy the given [predicate].
  /// The entries in the resulting map do not preserve the order of the original map.
  Map<K, V> filterNot(bool Function(K key, V value) predicate) {
    final map = <K, V>{};
    for (final key in keys) {
      if (!predicate(key, this[key] as V)) {
        map[key] = this[key] as V;
      }
    }
    return map;
  }

  /// Returns a new map with all entries that do not satisfy the given [predicate].
  /// The entries in the resulting map do not
  /// preserve the order of the original map.
  Map<K, V> rejectNot(bool Function(K key, V value) predicate) {
    final map = <K, V>{};
    for (final key in keys) {
      if (predicate(key, this[key] as V)) {
        map[key] = this[key] as V;
      }
    }
    return map;
  }

  /// debug print the map with [label] and [separator].
  /// [label] is the label for the map.
  /// [separator] is the separator between key and value.
  /// [indent] is the indent for each line.

  void printDebug({
    String label = 'Map',
    String separator = ': ',
    String indent = '  ',
  }) {
    final sb = StringBuffer()..writeln('$label:');
    for (final key in keys) {
      sb.writeln('$indent$key$separator${this[key]}');
    }
    debugPrint(sb.toString());
  }

  /// Remove duplicate values from the map.
  /// Returns a new map with unique values.
  Map<K, V> uniqueValues() {
    final map = <K, V>{};
    for (final key in keys) {
      if (!map.containsValue(this[key])) {
        map[key] = this[key] as V;
      }
    }
    return map;
  }
}

/// Utility extension methods for the native [Map] class.
extension MapBasics<K, V> on Map<K, V> {
  /// A type-checked version of [operator []] that additionally supports
  /// returning a default value.
  ///
  /// Returns [defaultValue] if the key is not found.  This is slightly
  /// different from `map[key] ?? defaultValue` if the [Map] stores `null`
  /// values.
  //
  // Remove if implemented upstream:
  // https://github.com/dart-lang/sdk/issues/37392
  V? get(K key, {V? defaultValue}) =>
      containsKey(key) ? this[key] : defaultValue;

  /// Returns a new [Map] containing all the entries of this for which the key
  /// satisfies [test].
  ///
  /// Example:
  /// ```dart
  /// var map = {'a': 1, 'bb': 2, 'ccc': 3}
  /// map.whereKey((key) => key.length > 1); // {'bb': 2, 'ccc': 3}
  /// ```
  Map<K, V> whereKey(bool Function(K) test) =>
      // Entries do not need to be cloned because they are const.
      Map.fromEntries(entries.where((entry) => test(entry.key)));

  /// Returns a new [Map] containing all the entries of this for which the
  /// value satisfies [test].
  ///
  /// Example:
  /// ```dart
  /// var map = {'a': 1, 'b': 2, 'c': 3};
  /// map.whereValue((value) => value > 1); // {'b': 2, 'c': 3}
  /// ```
  Map<K, V> whereValue(bool Function(V) test) =>
      // Entries do not need to be cloned because they are const.
      Map.fromEntries(entries.where((entry) => test(entry.value)));

  /// Returns a new [Map] where each entry is inverted, with the key becoming
  /// the value and the value becoming the key.
  ///
  /// Example:
  /// ```dart
  /// var map = {'a': 1, 'b': 2, 'c': 3};
  /// map.invert(); // {1: 'a', 2: 'b', 3: 'c'}
  /// ```
  ///
  /// As Map does not guarantee an order of iteration over entries, this method
  /// does not guarantee which key will be preserved as the value in the case
  /// where more than one key is associated with the same value.
  ///
  /// Example:
  /// ```dart
  /// var map = {'a': 1, 'b': 2, 'c': 2};
  /// map.invert(); // May return {1: 'a', 2: 'b'} or {1: 'a', 2: 'c'}.
  /// ```
  Map<V, K> invert() =>
      Map.fromEntries(entries.map((entry) => MapEntry(entry.value, entry.key)));
}
