import 'dart:async';

import 'package:flutter/material.dart';

typedef StringMap = Map<String, String>;
typedef Json = Map<String, dynamic>;
typedef DynamicJson = Map<dynamic, dynamic>;

typedef Predicate<T> = bool Function(T value);
typedef SearchPredicate<T> = double Function(T value, String query);

typedef IsEqual<T> = bool Function(T a, T b);
typedef FutureOrCallback<T> = FutureOr<T> Function();

typedef BoolCallback = ValueChanged<bool>;
typedef NumCallback = ValueChanged<num>;
typedef IntCallback = ValueChanged<int>;
typedef DoubleCallback = ValueChanged<double>;
typedef StringCallback = ValueChanged<String>;
typedef ContextCallback = ValueChanged<BuildContext>;
typedef ContextValueChanged<T> = void Function(BuildContext context, T value);

typedef BottomSheetBuilder = Future<T?> Function<T>(Widget child);

/// Function that gets value [T] for that element.
typedef Transformer<E, T> = T Function(E element);

typedef MapIndexedValue<E, T> = T Function(int index, E element);

/// Function that returns value [T] for the element and index
typedef IndexedPredicate<T> = bool Function(int index, T element);

typedef UnaryOperator<T> = T Function(T value);

typedef BinaryOperator<T> = T Function(T a, T b);
