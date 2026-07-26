import 'dart:async';

import 'package:flutter/material.dart';

/// A map with [String] keys and [String] values.
///
/// Useful for query parameters, headers, and key-value form data.
typedef StringMap = Map<String, String>;

/// A JSON-like map with [String] keys and dynamic values.
///
/// This is the most common shape used for serialized API payloads.
typedef Json = Map<String, dynamic>;

/// A dynamic key/value map for loosely typed payloads.
///
/// Prefer [Json] when possible to keep keys strongly typed.
typedef DynamicJson = Map<dynamic, dynamic>;

/// A synchronous boolean condition for a given value.
///
/// Example:
/// ```dart
/// final Predicate<int> isEven = (value) => value % 2 == 0;
/// ```
typedef Predicate<T> = bool Function(T value);

/// An async/sync boolean condition for an optional value.
///
/// Example:
/// ```dart
/// final FuturePredicate<String> hasText = (value) async => value != null && value.isNotEmpty;
/// ```
typedef FuturePredicate<T> = FutureOr<bool> Function(T? value);

/// A scoring function used for search and ranking.
///
/// Higher values usually indicate a better match.
///
/// Example:
/// ```dart
/// final SearchPredicate<String> score = (value, query) => value.contains(query) ? 1.0 : 0.0;
/// ```
typedef SearchPredicate<T> = double Function(T value, String query);

/// Compares two values for equality.
typedef IsEqual<T> = bool Function(T a, T b);

/// A callback that returns either a value immediately or asynchronously.
typedef FutureOrCallback<T> = FutureOr<T> Function();

/// Callback that emits a [bool] value.
typedef BoolCallback = ValueChanged<bool>;

/// Callback that emits a [num] value.
typedef NumCallback = ValueChanged<num>;

/// Callback that emits an [int] value.
typedef IntCallback = ValueChanged<int>;

/// Callback that emits a [double] value.
typedef DoubleCallback = ValueChanged<double>;

/// Callback that emits a [String] value.
typedef StringCallback = ValueChanged<String>;

/// Callback that emits a [BuildContext].
typedef ContextCallback = ValueChanged<BuildContext>;

/// Callback that receives a [BuildContext] and a value.
///
/// Useful in widgets where both context and payload are required.
typedef ContextValueChanged<T> = void Function(BuildContext context, T value);

/// Builder signature for showing a bottom sheet with a custom child.
///
/// Example:
/// ```dart
/// final BottomSheetBuilder builder = <T>(Widget child) {
///   return showModalBottomSheet<T>(
///     context: context,
///     builder: (_) => child,
///   );
/// };
/// ```
typedef BottomSheetBuilder = Future<T?> Function<T>(Widget child);

/// Maps an [E] element into a value of type [T].
///
/// Example:
/// ```dart
/// final Transformer<String, int> lengthOf = (text) => text.length;
/// ```
typedef Transformer<E, T> = T Function(E element);

/// Transforms an element with its index into a value of type [T].
///
/// Example:
/// ```dart
/// final MapIndexedValue<String, String> label =
///     (index, value) => '$index: $value';
/// ```
typedef MapIndexedValue<E, T> = T Function(int index, E element);

/// Predicate that checks an element using its index.
///
/// Example:
/// ```dart
/// final IndexedPredicate<int> isEvenIndexAndValueEven =
///     (index, element) => index.isEven && element.isEven;
/// ```
typedef IndexedPredicate<T> = bool Function(int index, T element);

/// A single-argument operator that returns the same type.
///
/// Example:
/// ```dart
/// final UnaryOperator<int> square = (value) => value * value;
/// ```
typedef UnaryOperator<T> = T Function(T value);

/// A two-argument operator that returns the same type.
///
/// Example:
/// ```dart
/// final BinaryOperator<int> sum = (a, b) => a + b;
/// ```
typedef BinaryOperator<T> = T Function(T a, T b);
