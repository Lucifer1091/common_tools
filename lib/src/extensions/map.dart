import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';

import './string/converters.dart';
import 'date/converters.dart';

/// Utility transforms and filters for maps.
extension MapUtils<K, V> on Map<K, V> {
  /// Returns true when the map contains [key] and its value equals [value].
  bool contains(Object key, Object? value) =>
      containsKey(key) && this[key] == value;

  /// Removes [key] only when the current value matches [value].
  bool removeExact({required K key, required V? value}) {
    if (containsKey(key) && this[key] == value) {
      remove(key);
      return true;
    }
    return false;
  }

  /// Returns a new map with [prefix] prepended to all keys.
  Map<String, V> prefixKeys(Object prefix) => {
    for (final MapEntry(:key, :value) in entries) '$prefix$key': value,
  };

  /// Returns a new map with [suffix] appended to all keys.
  Map<String, V> suffixKeys(Object suffix) => {
    for (final MapEntry(:key, :value) in entries) '$key$suffix': value,
  };

  /// Returns a new map with [prefix] prepended to all values.
  Map<K, String> prefixValues(Object prefix) => {
    for (final MapEntry(:key, :value) in entries) key: '$prefix$value',
  };

  /// Returns a new map with [suffix] appended to all values.
  Map<K, String> suffixValues(Object suffix) => {
    for (final MapEntry(:key, :value) in entries) key: '$value$suffix',
  };

  /// Returns a new map with transformed key casing.
  Map<String, V> capitalizeKeys() => {
    for (final MapEntry(:key, :value) in entries)
      key.toString().capitalize!: value,
  };

  /// Returns a new map with transformed value casing.
  Map<K, String> capitalizeValues() => {
    for (final MapEntry(:key, :value) in entries)
      key: value.toString().capitalize!,
  };

  /// Returns a new map with camelCase keys.
  Map<String, V> camelCaseKeys() => {
    for (final MapEntry(:key, :value) in entries)
      key.toString().camelCase!: value,
  };

  /// Returns a new map with camelCase values.
  Map<K, String> camelCaseValues() => {
    for (final MapEntry(:key, :value) in entries)
      key: value.toString().camelCase!,
  };

  /// Returns a new map with snake_case keys.
  Map<String, V> snakeCaseKeys() => {
    for (final MapEntry(:key, :value) in entries)
      key.toString().snakeCase!: value,
  };

  /// Returns a new map with snake_case values.
  Map<K, String> snakeCaseValues() => {
    for (final MapEntry(:key, :value) in entries)
      key: value.toString().snakeCase!,
  };

  /// Returns a new map with kebab-case keys.
  Map<String, V> kebabCaseKeys() => {
    for (final MapEntry(:key, :value) in entries)
      key.toString().paramCase!: value,
  };

  /// Returns a new map with kebab-case values.
  Map<K, String> kebabCaseValues() => {
    for (final MapEntry(:key, :value) in entries)
      key: value.toString().paramCase!,
  };

  /// Returns entries that satisfy [predicate].
  Map<K, V> filter(bool Function(K key, V value) predicate) => {
    for (final MapEntry(:key, :value) in entries)
      if (predicate(key, value)) key: value,
  };

  /// Returns entries that do not satisfy [predicate].
  Map<K, V> reject(bool Function(K key, V value) predicate) => {
    for (final MapEntry(:key, :value) in entries)
      if (!predicate(key, value)) key: value,
  };

  /// Returns entries whose values are not null.
  Map<K, V> filterNull() => {
    for (final MapEntry(:key, :value) in entries) key: ?value,
  };

  /// Returns entries whose stringified value is not empty.
  Map<K, V> filterEmpty() => {
    for (final MapEntry(:key, :value) in entries)
      if (value != null && value.toString().isNotEmpty) key: value,
  };

  /// Removes and returns the first map entry, or null when empty.
  MapEntry<K, V>? shift() {
    if (isEmpty) return null;

    final entry = entries.first;
    remove(entry.key);
    return entry;
  }

  /// Returns entries where key exists in [keys].
  Map<K, V> filterKeys(Iterable<K> keys) {
    final keySet = keys.toSet();
    return {
      for (final MapEntry(:key, :value) in entries)
        if (keySet.contains(key)) key: value,
    };
  }

  /// Returns entries where value exists in [values].
  Map<K, V> filterValues(Iterable<V> values) {
    final valueSet = values.toSet();
    return {
      for (final MapEntry(:key, :value) in entries)
        if (valueSet.contains(value)) key: value,
    };
  }

  /// Returns entries where key does not exist in [keys].
  Map<K, V> rejectKeys(Iterable<K> keys) {
    final keySet = keys.toSet();
    return {
      for (final MapEntry(:key, :value) in entries)
        if (!keySet.contains(key)) key: value,
    };
  }

  /// Returns entries where value does not exist in [values].
  Map<K, V> rejectValues(Iterable<V> values) {
    final valueSet = values.toSet();
    return {
      for (final MapEntry(:key, :value) in entries)
        if (!valueSet.contains(value)) key: value,
    };
  }

  /// Prints the map in a readable multi-line format.
  void printDebug({
    String label = 'Map',
    String separator = ': ',
    String indent = '  ',
  }) {
    final sb = StringBuffer()..writeln('$label:');
    for (final MapEntry(:key, :value) in entries) {
      sb.writeln('$indent$key$separator$value');
    }
    debugPrint(sb.toString());
  }

  /// Returns a map keeping only the first key for each unique value.
  Map<K, V> uniqueValues() {
    final seen = <V>{};
    final result = <K, V>{};
    for (final MapEntry(:key, :value) in entries) {
      if (seen.add(value)) {
        result[key] = value;
      }
    }
    return result;
  }
}

/// Fundamental querying helpers for maps.
extension MapBasics<K, V> on Map<K, V> {
  /// Type-safe get with fallback when key is absent.
  V? get(K key, {V? defaultValue}) =>
      containsKey(key) ? this[key] : defaultValue;

  /// Returns entries where key satisfies [test].
  Map<K, V> whereKey(bool Function(K key) test) => {
    for (final MapEntry(:key, :value) in entries)
      if (test(key)) key: value,
  };

  /// Returns entries where value satisfies [test].
  Map<K, V> whereValue(bool Function(V value) test) => {
    for (final MapEntry(:key, :value) in entries)
      if (test(value)) key: value,
  };

  /// Returns a key-value inverted map.
  Map<V, K> invert() => {
    for (final MapEntry(:key, :value) in entries) value: key,
  };
}

/// Operator-style and structural helpers for maps.
extension MapScrewdriver<K, V> on Map<K, V> {
  /// Adds a record entry to this map.
  void operator +((K, V) entry) => this[entry.$1] = entry.$2;

  /// Adds a [MapEntry] to this map.
  void operator <<(MapEntry<K, V> entry) => this[entry.key] = entry.value;

  /// Converts this map into a JSON string.
  String toJson({Object? Function(Object? nonEncodable)? toEncodable}) =>
      jsonEncode(this, toEncodable: toEncodable);

  /// Returns a new map excluding keys present in [keys].
  Map<K, V> except(Iterable<K> keys) {
    final keySet = keys.toSet();
    return {
      for (final MapEntry(:key, :value) in entries)
        if (!keySet.contains(key)) key: value,
    };
  }

  /// Returns a new map containing only keys present in [keys].
  Map<K, V> only(Iterable<K> keys) {
    final keySet = keys.toSet();
    return {
      for (final MapEntry(:key, :value) in entries)
        if (keySet.contains(key)) key: value,
    };
  }

  /// Returns entries satisfying [test].
  Map<K, V> where(bool Function(K key, V value) test) => {
    for (final MapEntry(:key, :value) in entries)
      if (test(key, value)) key: value,
  };

  /// Returns entries not satisfying [test].
  Map<K, V> whereNot(bool Function(K key, V value) test) => {
    for (final MapEntry(:key, :value) in entries)
      if (!test(key, value)) key: value,
  };

  /// Iterates map entries as records.
  Iterable<(K key, V value)> get records sync* {
    for (final entry in entries) {
      yield (entry.key, entry.value);
    }
  }

  /// Removes [keys] from this map.
  ///
  /// For unmodifiable maps, it returns a new filtered map.
  Map<K, V> removeKeys(Iterable<K> keys) {
    final keySet = keys.toSet();
    if (this is UnmodifiableMapBase) {
      return {
        for (final MapEntry(:key, :value) in entries)
          if (!keySet.contains(key)) key: value,
      };
    }
    removeWhere((key, _) => keySet.contains(key));
    return this;
  }
}

/// Lazy fallback getter for maps.
extension MapGetOrElse<K, V> on Map<K, V> {
  /// Returns the value for [key], or result of [defaultValue] when key is absent.
  V getOrElse(K key, V Function() defaultValue) {
    if (containsKey(key)) return this[key] as V;
    return defaultValue();
  }
}

num? _asNum(Object? value) {
  if (value is num) return value;
  if (value is String) return value.toNumOrNull();
  return null;
}

int? _asInt(Object? value) {
  if (value is int) return value;
  if (value is num) {
    final doubleValue = value.toDouble();
    if (!doubleValue.isFinite ||
        doubleValue.truncateToDouble() != doubleValue) {
      return null;
    }
    return doubleValue.toInt();
  }
  if (value is String) return value.toIntOrNull();
  return null;
}

double? _asDouble(Object? value) {
  if (value is num) return value.toDouble();
  if (value is String) return value.toDoubleOrNull();
  return null;
}

bool? _asBool(Object? value) {
  if (value is bool) return value;
  if (value is String) return value.toBoolOrNull();
  if (value is num) {
    if (value == 0) return false;
    if (value == 1) return true;
  }
  return null;
}

List<T>? _asList<T>(Object? value) {
  if (value is List<T>) return value;
  if (value is! List) return null;

  final result = <T>[];
  for (final item in value) {
    if (item is T) {
      result.add(item);
      continue;
    }
    if (item is num && T == int) {
      result.add(item.toInt() as T);
      continue;
    }
    if (item is num && T == double) {
      result.add(item.toDouble() as T);
      continue;
    }
    return null;
  }
  return result;
}

Map<String, dynamic>? _asMap(Object? value) {
  if (value is Map<String, dynamic>) return value;
  if (value is! Map) return null;
  try {
    return Map<String, dynamic>.from(value);
  } catch (_) {
    return null;
  }
}

/// Safe typed extraction helpers for loosely typed JSON-like maps.
extension JsonGetters<K, V> on Map<K, V> {
  /// Parses [key] to [T], returning [value] as fallback.
  T parse<T>(String key, {required T value}) => parseOrNull<T>(key) ?? value;

  /// Parses [key] to [T], returning null when not possible.
  T? parseOrNull<T>(String key) {
    if (!containsKey(key)) return null;

    final data = this[key];
    if (data is T) return data;

    if (T == DateTime && data is String) {
      return ParseDateTime.parse(data) as T?;
    }
    if (T == num) return _asNum(data) as T?;
    if (T == int) return _asInt(data) as T?;
    if (T == double) return _asDouble(data) as T?;
    if (T == bool) return _asBool(data) as T?;

    return null;
  }

  String getString(String key, {required String value}) =>
      getStringOrNull(key) ?? value;

  /// Returns value at [key] as [String], or `null` when conversion is not possible.
  String? getStringOrNull(String key) {
    if (!containsKey(key)) return null;

    final data = this[key];
    if (data is String) return data;
    if (data is num || data is bool) return data.toString();
    return null;
  }

  num getNum(String key, {required num value}) => getNumOrNull(key) ?? value;

  /// Returns value at [key] as [num], or `null` when conversion is not possible.
  num? getNumOrNull(String key) {
    if (!containsKey(key)) return null;
    return _asNum(this[key]);
  }

  int getInt(String key, {required int value}) => getIntOrNull(key) ?? value;

  /// Returns value at [key] as [int], or `null` when conversion is not possible.
  int? getIntOrNull(String key) {
    if (!containsKey(key)) return null;
    return _asInt(this[key]);
  }

  double getDouble(String key, {required double value}) =>
      getDoubleOrNull(key) ?? value;

  /// Returns value at [key] as [double], or `null` when conversion is not possible.
  double? getDoubleOrNull(String key) {
    if (!containsKey(key)) return null;
    return _asDouble(this[key]);
  }

  bool getBool(String key, {required bool value}) =>
      getBoolOrNull(key) ?? value;

  /// Returns value at [key] as [bool], or `null` when conversion is not possible.
  bool? getBoolOrNull(String key) {
    if (!containsKey(key)) return null;
    return _asBool(this[key]);
  }

  DateTime getDateTime(String key, {required DateTime value}) =>
      getDateTimeOrNull(key) ?? value;

  /// Returns value at [key] as [DateTime], or `null` when conversion is not possible.
  DateTime? getDateTimeOrNull(String key) {
    if (!containsKey(key)) return null;

    final data = this[key];
    if (data is DateTime) return data;
    if (data is String) return ParseDateTime.parse(data);
    return null;
  }

  List<T> getList<T>(String key, {required List<T> value}) =>
      getListOrNull<T>(key) ?? value;

  /// Returns value at [key] as `List<T>`, or `null` when conversion is not possible.
  ///
  /// Accepts:
  /// - a list value
  /// - a JSON string that decodes to a list
  List<T>? getListOrNull<T>(String key) {
    if (!containsKey(key)) return null;

    final data = this[key];
    final list = _asList<T>(data);
    if (list != null) return list;

    if (data is String) {
      try {
        return _asList<T>(jsonDecode(data));
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  Map<String, dynamic> getMap(
    String key, {
    required Map<String, dynamic> value,
  }) => getMapOrNull(key) ?? value;

  /// Returns value at [key] as `Map<String, dynamic>`, or `null` on failure.
  ///
  /// Accepts:
  /// - a map value
  /// - a JSON string that decodes to a map
  Map<String, dynamic>? getMapOrNull(String key) {
    if (!containsKey(key)) return null;

    final data = this[key];
    final map = _asMap(data);
    if (map != null) return map;

    if (data is String) {
      try {
        return _asMap(jsonDecode(data));
      } catch (_) {
        return null;
      }
    }
    return null;
  }
}

/// Miscellaneous helpers for map joining, counting, and typed access.
extension MapExt<K, V> on Map<K, V> {
  /// Returns typed value at [key], or [defaultValue] if absent or wrong type.
  T? getValue<T>(K key, {T? defaultValue}) {
    final value = this[key];
    return value is T ? value : defaultValue;
  }

  /// Joins map values with an optional formatter.
  String join2({
    String divider = ', ',
    String? prefix,
    String? suffix,
    String Function(K key, V value)? convert,
  }) {
    final sb = StringBuffer();
    if (prefix != null) sb.write(prefix);

    var first = true;
    for (final MapEntry(:key, :value) in entries) {
      if (!first) sb.write(divider);
      sb.write(convert != null ? convert(key, value) : value.toString());
      first = false;
    }

    if (suffix != null) sb.write(suffix);
    return sb.toString();
  }

  /// Counts entries that satisfy [test].
  int count(bool Function(K k, V v) test) {
    var total = 0;
    for (final MapEntry(:key, :value) in entries) {
      if (test(key, value)) {
        total++;
      }
    }
    return total;
  }

  /// Iterates entries and stops when [action] returns true.
  void forEachCanBreak(bool Function(K k, V v) action) {
    for (final MapEntry(:key, :value) in entries) {
      if (action(key, value)) {
        break;
      }
    }
  }
}
