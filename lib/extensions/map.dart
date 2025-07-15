part of 'extensions.dart';

/// Supercharged extensions on [Map].
extension MapSC<K, V> on Map<K, V> {
  // /// Returns a new [Iterable<MapEntry<K,V>>] with all elements that satisfy the
  // /// predicate [test].
  // ///
  // /// Example:
  // /// ```dart
  // /// {'a': 1, 'b': 2, 'c': 3}.filter((e) => e.key == 'a').toMap(); // {'a': 1}
  // /// ```
  // Iterable<MapEntry<K, V>> filter(bool Function(MapEntry<K, V>) test) =>
  //     entries.filter(test);

  // /// Returns the number of entries that matches the [test].
  // ///
  // /// If [test] is not specified it will count every entry.
  // ///
  // /// Example:
  // /// ```dart
  // /// [1, 2, 3, 13, 14, 15].count();             // 6
  // /// [1, 2, 3, 13, 14, 15].count((n) => n > 9); // 3
  // /// ```
  // int count([bool Function(MapEntry<K, V> element)? test]) =>
  //     entries.count(test);

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
      map[key.toString().camelCase!] = this[key] as V;
    }
    return map;
  }

  /// Camel case all values in the map.
  /// Returns a new map with camel cased values.
  Map<K, String> camelCaseValues() {
    final map = <K, String>{};
    for (final key in keys) {
      map[key] = this[key].toString().camelCase!;
    }
    return map;
  }

  /// Snake case all keys in the map.
  /// Returns a new map with snake cased keys.
  Map<String, V> snakeCaseKeys() {
    final map = <String, V>{};
    for (final key in keys) {
      map[key.toString().snakeCase!] = this[key] as V;
    }
    return map;
  }

  /// Snake case all values in the map.
  /// Returns a new map with snake cased values.

  Map<K, String> snakeCaseValues() {
    final map = <K, String>{};
    for (final key in keys) {
      map[key] = this[key].toString().snakeCase!;
    }
    return map;
  }

  /// Kebab case all keys in the map.
  /// Returns a new map with kebab cased keys.
  Map<String, V> kebabCaseKeys() {
    final map = <String, V>{};
    for (final key in keys) {
      map[key.toString().paramCase!] = this[key] as V;
    }
    return map;
  }

  /// Kebab case all values in the map.
  /// Returns a new map with kebab cased values.
  Map<K, String> kebabCaseValues() {
    final map = <K, String>{};
    for (final key in keys) {
      map[key] = this[key].toString().paramCase!;
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

///
extension RMap<K, V> on Map<K, V> {
  /// * return a new map with the `null` values from the original map only
  Map<K, V> whereNull() {
    final map = <K, V>{};
    for (final entry in entries) {
      if (entry.value == null) {
        map[entry.key] = entry.value;
      }
    }
    return map;
  }

  /// * return a new `Map` with only keys you need it
  Map<K, V?> only(List<K> keys) {
    final holder = <K, V?>{};
    for (final key in keys) {
      holder[key] = this[key];
    }
    return holder;
  }

  /// * return the map without some keys
  Map<K, V?> expect(List<K> keys) {
    final holder = Map<K, V?>.of(this);
    keys.forEach(holder.remove);
    return holder;
  }

  /// * swaps the collection's keys with their corresponding values
  Map<V, K> flip() {
    final Map<V, K> flippedMap = {};
    forEach((key, value) {
      flippedMap[value] = key;
    });
    return flippedMap;
  }

  /// * return the map without key of null values
  Map<K, V> exceptNull() {
    final holder = Map<K, V>.of(this)
      ..removeWhere((key, value) => value == null);
    return holder;
  }

  /// * return the map without  key of null values and empty
  Map<K, V?> exceptNullAndEmpty() {
    final holder = Map<K, V?>.of(this)..removeWhere(
      (key, value) => value == null || value is String && value.isEmpty,
    );
    return holder;
  }

  /// * return the map without  key of empty values
  Map<K, V?> exceptEmpty() {
    final holder = Map<K, V?>.of(this)
      ..removeWhere((key, value) => value is String && value.isEmpty);
    return holder;
  }
}

/// provides extensions for map
extension MapScrewdriver<K, V> on Map<K, V> {
  /// Allows to add a record entry to [this].
  void operator +((K, V) entry) => this[entry.$1] = entry.$2;

  /// Allows to add [MapEntry] to [this].
  void operator <<(MapEntry<K, V> entry) => this[entry.key] = entry.value;

  /// Converts [this] map into a JSON string.
  String toJson() => json.encode(this);

  /// Returns a new [Map] with the same keys and values as [this] except
  /// keys present [keys].
  Map<K, V> except(Iterable<K> keys) =>
      Map.fromEntries(entries.where((entry) => !keys.contains(entry.key)));

  /// Returns a new [Map] with the same keys and values but only contains
  /// the keys present in [keys].
  Map<K, V> only(Iterable<K> keys) => {
    for (final MapEntry(:key, :value) in entries)
      if (keys.contains(key)) key: value,
  };

  /// Returns a new [Map] with the same keys and values as [this] where the
  /// key-value pair satisfies the [test] function. Similar to [Iterable.where].
  Map<K, V> where(bool Function(K key, V value) test) => {
    for (final MapEntry(:key, :value) in entries)
      if (test(key, value)) key: value,
  };

  /// Returns a new [Map] with the same keys and values as [this] where the
  /// key-value pair doesn't satisfy the [test] function.
  Map<K, V> whereNot(bool Function(K key, V value) test) => {
    for (final MapEntry(:key, :value) in entries)
      if (!test(key, value)) key: value,
  };

  /// Similar to [Map.entries] but returns an iterable of records instead of
  /// [MapEntry].
  ///
  /// One of the use-cases includes iterating over the collection with access
  /// to the key of each item in a for loop.
  /// e.g.
  ///
  /// for (final (key, value) in map.records) {
  ///   print('$key: $value');
  /// }
  Iterable<(K key, V value)> get records sync* {
    for (final entry in entries) {
      yield (entry.key, entry.value);
    }
  }

  /// Removes all the keys present in [keys] from [this] map. If [this] is
  /// an instance of [UnmodifiableMapBase], it will return a new map with
  /// the same keys and values except the keys present in [keys].
  Map<K, V> removeKeys(Iterable<K> keys) {
    if (this is UnmodifiableMapBase) return except(keys);
    return this..removeWhere((key, value) => keys.contains(key));
  }
}

// extension MapAll<K, V> on Map<K, V> {
//   /// Returns true if all entries match the given [predicate].
//   /// [predicate] must not be null.
//   bool all(bool Function(K key, V value) predicate) {
//     if (isEmpty) {
//       return true;
//     }
//     for (final MapEntry<K, V> entry in entries) {
//       if (!predicate(entry.key, entry.value)) {
//         return false;
//       }
//     }
//     return true;
//   }
// }

// extension MapAny<K, V> on Map<K, V> {
//   /// Returns true if there is at least one entry that matches the given [predicate].
//   /// [predicate] must not be null.
//   bool any(bool Function(K key, V value) predicate) {
//     if (isEmpty) {
//       return false;
//     }
//     for (final MapEntry<K, V> entry in entries) {
//       if (predicate(entry.key, entry.value)) {
//         return true;
//       }
//     }
//     return false;
//   }
// }

// extension MapCount<K, V> on Map<K, V> {
//   /// Returns the number of entries matching the given [predicate] or the number
//   /// of entries when `predicate = null`.
//   int count([bool Function(MapEntry<K, V>)? predicate]) {
//     if (predicate == null) {
//       return length;
//     }
//     var count = 0;

//     final i = entries.iterator;
//     while (i.moveNext()) {
//       if (predicate(i.current)) {
//         count++;
//       }
//     }
//     return count;
//   }
// }

// extension MapFilter<K, V> on Map<K, V> {
//   /// Returns a new map containing all key-value pairs matching the given [predicate].
//   ///
//   /// The returned map preserves the entry iteration order of the original map.
//   Map<K, V> filter(bool Function(MapEntry<K, V> entry) predicate) {
//     final result = <K, V>{};
//     for (final entry in entries) {
//       if (predicate(entry)) {
//         result[entry.key] = entry.value;
//       }
//     }
//     return result;
//   }
// }

// extension MapFilterKeys<K, V> on Map<K, V> {
//   /// Returns a map containing all key-value pairs with keys matching the given [predicate].
//   ///
//   /// The returned map preserves the entry iteration order of the original map.
//   Map<K, V> filterKeys(bool Function(K) predicate) {
//     final result = <K, V>{};
//     for (final entry in entries) {
//       if (predicate(entry.key)) {
//         result[entry.key] = entry.value;
//       }
//     }
//     return result;
//   }
// }

// extension MapFilterNot<K, V> on Map<K, V> {
//   /// Returns a new map containing all key-value pairs not matching the given [predicate].
//   ///
//   /// The returned map preserves the entry iteration order of the original map.
//   Map<K, V> filterNot(bool Function(MapEntry<K, V> entry) predicate) {
//     final result = <K, V>{};
//     for (final entry in entries) {
//       if (!predicate(entry)) {
//         result[entry.key] = entry.value;
//       }
//     }
//     return result;
//   }
// }

// extension MapFilterValues<K, V> on Map<K, V> {
//   /// Returns a map containing all key-value pairs with values matching the given [predicate].
//   ///
//   /// The returned map preserves the entry iteration order of the original map.
//   Map<K, V> filterValues(bool Function(V) predicate) {
//     final result = <K, V>{};
//     for (final entry in entries) {
//       if (predicate(entry.value)) {
//         result[entry.key] = entry.value;
//       }
//     }
//     return result;
//   }
// }

extension MapGetOrElse<K, V> on Map<K, V> {
  /// Returns the value for the given key, or the result of the [defaultValue] function if there was no entry for the given key.
  V getOrElse(K key, V Function() defaultValue) {
    return this[key] ?? defaultValue();
  }
}

extension JsonGetters<K, V> on Map<K, V> {
  /// Parses the value for the given [key] to type [T].
  /// If the value is not found or cannot be parsed, it returns the provided [value
  T parse<T>(String key, {required T value}) {
    return parseOrNull<T>(key) ?? value;
  }

  /// Parses the value for the given [key] to type [T].
  /// If the value is not found or cannot be parsed, it returns `null`.
  T? parseOrNull<T>(String key) {
    if (!containsKey(key)) return null;

    final data = this[key];

    if (data is T) {
      return data;
    } else if (data is String && T == DateTime) {
      return ParseDateTime.parse(data) as T;
    } else if (data is String && T == num) {
      return data.toNumOrNull() as T;
    } else if (data is String && T == int) {
      return data.toIntOrNull() as T;
    } else if (data is String && T == double) {
      return data.toDoubleOrNull() as T;
    } else if (data is String && T == bool) {
      return data.toBoolOrNull() as T;
    } else {
      return null;
    }
  }

  String getString(String key, {required String value}) {
    return getStringOrNull(key) ?? value;
  }

  String? getStringOrNull(String key) {
    if (!containsKey(key)) return null;

    final data = this[key];

    if (data is String) {
      return data;
    } else if (data is num || data is bool) {
      return data.toString();
    } else {
      return null;
    }
  }

  num getNum(String key, {required num value}) {
    return getNumOrNull(key) ?? value;
  }

  num? getNumOrNull(String key) {
    if (!containsKey(key)) return null;

    final data = this[key];

    if (data is num) {
      return data;
    } else if (data is String) {
      return data.toNumOrNull();
    } else {
      return null;
    }
  }

  int getInt(String key, {required int value}) {
    return getIntOrNull(key) ?? value;
  }

  int? getIntOrNull(String key) {
    if (!containsKey(key)) return null;

    final data = this[key];

    if (data is int) {
      return data;
    } else if (data is String) {
      return data.toIntOrNull();
    } else {
      return null;
    }
  }

  double getDouble(String key, {required double value}) {
    return getDoubleOrNull(key) ?? value;
  }

  double? getDoubleOrNull(String key) {
    if (!containsKey(key)) return null;

    final data = this[key];

    if (data is double) {
      return data;
    } else if (data is String) {
      return data.toDoubleOrNull();
    } else {
      return null;
    }
  }

  bool getBool(String key, {required bool value}) {
    return getBoolOrNull(key) ?? value;
  }

  bool? getBoolOrNull(String key) {
    if (!containsKey(key)) return null;

    final data = this[key];

    if (data is bool) {
      return data;
    } else if (data is String) {
      return data.toBoolOrNull();
    } else {
      return null;
    }
  }

  DateTime getDateTime(String key, {required DateTime value}) {
    return getDateTimeOrNull(key) ?? value;
  }

  DateTime? getDateTimeOrNull(String key) {
    if (!containsKey(key)) return null;

    final data = this[key];

    if (data is DateTime) {
      return data;
    } else if (data is String) {
      return ParseDateTime.parse(data);
    } else {
      return null;
    }
  }

  List<T> getList<T>(String key, {required List<T> value}) {
    return getListOrNull<T>(key) ?? value;
  }

  List<T>? getListOrNull<T>(String key) {
    if (!containsKey(key)) return null;

    final data = this[key];

    if (data is List<T>) {
      return data;
    } else {
      return null;
    }
  }

  Map<String, dynamic> getMap(
    String key, {
    required Map<String, dynamic> value,
  }) {
    return getMapOrNull(key) ?? value;
  }

  Map<String, dynamic>? getMapOrNull(String key) {
    if (!containsKey(key)) return null;

    final data = this[key];

    if (data is Map<String, dynamic>) {
      return data;
    } else {
      return null;
    }
  }
}

// extension MapEntries<K, V> on Map<K, V> {
//   /// Maps [entries] in this map to a [List<R>]
//   Iterable<R> mapEntries<R>(R Function(MapEntry<K, V>) transform) sync* {
//     for (final entry in entries) {
//       yield transform(entry);
//     }
//   }
// }

// extension MapMapKeys<K, V> on Map<K, V> {
//   /// Returns a new Map with entries having the keys obtained by applying the [transform] function to each entry in this
//   /// [Map] and the values of this map.
//   ///
//   /// In case if any two entries are mapped to the equal keys, the value of the latter one will overwrite
//   /// the value associated with the former one.
//   ///
//   /// The returned map preserves the entry iteration order of the original map.
//   Map<R, V> mapKeys<R>(R Function(MapEntry<K, V>) transform) {
//     return map((key, value) {
//       return MapEntry(transform(MapEntry(key, value)), value);
//     });
//   }
// }

// extension MapMapValues<K, V> on Map<K, V> {
//   /// Returns a new map with entries having the keys of this map and the values obtained by applying the [transform]
//   /// function to each entry in this [Map].
//   ///
//   /// The returned map preserves the entry iteration order of the original map.
//   Map<K, R> mapValues<R>(R Function(MapEntry<K, V>) transform) {
//     return map((key, value) {
//       return MapEntry(key, transform(MapEntry(key, value)));
//     });
//   }
// }

// extension MapMaxBy<K, V> on Map<K, V> {
//   /// Returns the first entry yielding the largest value of the given function or `null` if there are no entries.
//   MapEntry<K, V>? maxBy<R extends Comparable>(
//     R Function(MapEntry<K, V>) selector,
//   ) {
//     final i = entries.iterator;
//     if (!i.moveNext()) return null;
//     MapEntry<K, V> maxElement = i.current;
//     R maxValue = selector(maxElement);
//     while (i.moveNext()) {
//       final e = i.current;
//       final v = selector(e);
//       if (maxValue.compareTo(v) < 0) {
//         maxElement = e;
//         maxValue = v;
//       }
//     }
//     return maxElement;
//   }
// }

// extension MapMaxWith<K, V> on Map<K, V> {
//   /// Returns the first entry having the largest value according to the provided [comparator] or `null` if there are no entries.
//   MapEntry<K, V>? maxWith(Comparator<MapEntry<K, V>> comparator) {
//     final i = entries.iterator;
//     if (!i.moveNext()) return null;
//     var max = i.current;
//     while (i.moveNext()) {
//       final e = i.current;
//       if (comparator(max, e) < 0) {
//         max = e;
//       }
//     }
//     return max;
//   }
// }

// extension MapMinBy<K, V> on Map<K, V> {
//   /// Returns the first entry yielding the smallest value of the given function or `null` if there are no entries.
//   MapEntry<K, V>? minBy<R extends Comparable>(
//     R Function(MapEntry<K, V>) selector,
//   ) {
//     final i = entries.iterator;
//     if (!i.moveNext()) return null;
//     MapEntry<K, V> minElement = i.current;
//     R minValue = selector(minElement);
//     while (i.moveNext()) {
//       final e = i.current;
//       final v = selector(e);
//       if (minValue.compareTo(v) > 0) {
//         minElement = e;
//         minValue = v;
//       }
//     }
//     return minElement;
//   }
// }

// extension MapMinWith<K, V> on Map<K, V> {
//   /// Returns the first entry having the smallest value according to the provided [comparator] or `null` if there are no entries.
//   MapEntry<K, V>? minWith(Comparator<MapEntry<K, V>> comparator) {
//     final i = entries.iterator;
//     if (!i.moveNext()) return null;
//     var min = i.current;
//     while (i.moveNext()) {
//       final e = i.current;
//       if (comparator(min, e) > 0) {
//         min = e;
//       }
//     }
//     return min;
//   }
// }

// extension MapNone<K, V> on Map<K, V> {
//   /// Returns `true` if there is no entries in the map that match the given [predicate].
//   /// [predicate] must not be null.
//   bool none(bool Function(K key, V value) predicate) {
//     if (isEmpty) {
//       return true;
//     }
//     for (final MapEntry<K, V> entry in entries) {
//       if (predicate(entry.key, entry.value)) {
//         return false;
//       }
//     }
//     return true;
//   }
// }

// extension MapToList<K, V> on Map<K, V> {
//   /// Returns a list of map entries
//   List<Pair<K, V>> toList() {
//     return mapEntries((e) => Pair<K, V>(e.key, e.value)).toList();
//   }
// }

// extension MapToMap<K, V> on Map<K, V> {
//   /// Returns a new map containing all key-value pairs from the original map.
//   ///
//   /// The returned map preserves the entry iteration order of the original map.
//   Map<K, V> toMap() {
//     return Map.of(this);
//   }
// }

// extension MapOrEmpty<K, V> on Map<K, V>? {
//   /// Returns the [Map] if its not `null`, or the empty [Map] otherwise.
//   Map<K, V> orEmpty() => this ?? <K, V>{};
// }

// /// Represents a generic pair of two values.
// ///
// /// There is no meaning attached to values in this class, it can be used for any purpose.
// /// Pair exhibits value semantics, i.e. two pairs are equal if both components are equal.
// ///
// /// @param A type of the first value.
// /// @param B type of the second value.
// /// @property first First value.
// /// @property second Second value.
// class Pair<A, B> {
//   const Pair(this.first, this.second);

//   final A first;
//   final B second;

//   @override
//   String toString() => '($first, $second)';

//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is Pair &&
//           runtimeType == other.runtimeType &&
//           first == other.first &&
//           second == other.second;

//   @override
//   int get hashCode => first.hashCode ^ second.hashCode;
// }

// extension PairDeconstruction<T> on Pair<T, T> {
//   /// Converts this pair into a list.
//   List<T> toList() => [first, second];
// }

///
/// Map的一些扩展工具方法
///
extension MapExt<K, V> on Map<K, V> {
  /// 获取整形值
  int getInt(String key, {int defaultValue = 0}) {
    var r = getNum(key, defaultValue: defaultValue);
    if (r is int) {
      return r;
    }
    return r.toInt();
  }

  /// 获取一个数字字段
  num getNum(String key, {num defaultValue = 0}) {
    try {
      final value = this[key];

      if (value != null && value is num) {
        return value;
      }

      return num.parse(value.toString());
    } catch (e) {
      return defaultValue;
    }
  }

  /// get double value from map
  double getDouble(String key, {double defaultValue = 0}) {
    final value = this[key];
    try {
      if (value != null && value is double) {
        return value;
      }

      return double.parse(value.toString());
    } catch (e) {
      return defaultValue;
    }
  }

  ///
  /// get bool value from map
  ///
  /// 该方法兼容字符串'true'和'false'
  ///
  bool getBool(String key, {bool defaultValue = false}) {
    final value = this[key];
    try {
      if (value != null && value is bool) {
        return value;
      }

      if (value is num) {
        if (value > 0) {
          return true;
        } else if (value == 0) {
          return false;
        }
      }

      if ('true' == value) {
        return true;
      }
      if ('false' == value) {
        return false;
      }
    } catch (e) {
      return defaultValue;
    }
    return defaultValue;
  }

  ///
  /// 从map中获取一个字符串
  ///
  String? getString(String key, {String? defaultValue}) {
    try {
      final value = this[key];
      // print('getStringValue:key :$key, value:$value, valueType:${value.runtimeType}');
      if (value == null) {
        return defaultValue;
      }
      return value.toString();
    } catch (e) {
      return defaultValue;
    }
  }

  ///
  /// 从map中获取一个字符串,默认返回空字符串。
  /// 用于解决getString函数返回值可空而导致调用端代码不简洁的问题。
  ///
  String optString(String key, [String defaultValue = '']) {
    try {
      final value = this[key];
      // print('getStringValue:key :$key, value:$value, valueType:${value.runtimeType}');
      if (value == null) {
        return defaultValue;
      }
      return value.toString();
    } catch (e) {
      return defaultValue;
    }
  }

  /// 获取一个List字段
  List<T>? getList<T>(String key, {List<T>? defaultValue}) {
    final value = this[key];

    if (value is List<T>) {
      return value;
    }

    if (value is List) {
      // 如果是数字，需要逐个转换
      return value.map((e) {
        // print('e is num:${e is num}, T is double:${T is double}');

        if (e is num) {
          if (T == double) {
            return e.toDouble() as T;
          } else if (T == int) {
            return e.toInt() as T;
          }
        }
        return e as T;
      }).toList();
    }

    if (value != null && value is String) {
      final json = jsonDecode(value);
      if (json is List<T>) {
        return json;
      }
    }

    return defaultValue;
  }

  /// 获取一个Map字段
  Map? getMap(String key) {
    final value = this[key];
    if (value is Map) {
      return value;
    }
    if (value != null && value is String) {
      final json = jsonDecode(value);
      if (json is Map) {
        return json;
      }
    }
    return null;
  }

  /// 获取一个value值
  T? getValue<T>(String? key, {T? defaultValue}) {
    var r = defaultValue;
    try {
      dynamic value = this[key];
      if (value is T) {
        r = value;
      }
    } catch (e) {
      // ignore
    }
    return r;
  }

  ///
  /// 格式化map
  ///
  /// -  divider 分割符
  /// -
  ///
  String join2({
    String divider = ', ',
    String? prefix,
    String? suffix,
    String Function(K key, V? value)? convert,
  }) {
    var sb = StringBuffer();
    if (prefix != null) {
      sb.write(prefix);
    }

    final keys = this.keys;
    for (var i = 0; i < keys.length; i++) {
      final key = keys.elementAt(i);
      final value = this[key];
      sb.write(convert != null ? convert(key, value) : value.toString());
      if (i != length - 1) {
        sb.write(divider);
      }
    }

    if (suffix != null) {
      sb.write(suffix);
    }

    return sb.toString();
  }

  ///
  /// 获取字典中满足条件的元素的个数
  ///
  int count(bool Function(K k, V v) test) {
    var count = 0;
    forEach((key, value) {
      if (test(key, value)) {
        count++;
      }
    });
    return count;
  }

  ///
  ///  条件过滤
  ///
  Map<K, V> where(bool Function(K k, V v) test) {
    var r = <K, V>{};
    forEach((key, value) {
      if (test(key, value)) {
        r[key] = value;
      }
    });
    return r;
  }

  ///
  /// 可中断遍历，如果action返回true，表示中断遍历
  ///
  void forEachCanBreak(bool Function(K k, V v) action) {
    final it = keys.iterator;
    while (it.moveNext()) {
      final k = it.current;
      if (action(k, this[k]!)) {
        break;
      }
    }
  }
}
