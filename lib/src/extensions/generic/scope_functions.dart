import 'dart:async';
import 'dart:convert';

/// Extension on nullable types providing scope functions similar to Kotlin.
extension ScopeFunction<T> on T? {
  /// Checks whether the value is "truthy", meaning:
  /// - `true` for boolean values
  /// - Non-zero for numeric values
  /// - Non-empty for strings, iterables, and maps
  /// - `false` otherwise
  ///
  /// Example:
  /// ```dart
  /// print(0.isTruthy); // false
  /// print('Hello'.isTruthy); // true
  /// print([].isTruthy); // false
  /// ```
  bool get isTruthy => switch (this) {
    final bool value => value,
    final num value => value != 0,
    final String value => value.isNotEmpty,
    final Iterable<dynamic> value => value.isNotEmpty,
    final Map<dynamic, dynamic> value => value.isNotEmpty,
    _ => false,
  };

  /// Checks whether the value is "falsy" (opposite of `isTruthy`).
  bool get isFalsy => !isTruthy;

  /// Returns [fallback] when this value is `null`, otherwise returns `this`.
  ///
  /// Example:
  /// ```dart
  /// String? name;
  /// print(name.orDefault('guest')); // guest
  /// ```
  T orDefault(T fallback) => this ?? fallback;

  /// Calls the specified function [callback] with `this` as its argument and returns its result.
  ///
  /// Example:
  /// ```dart
  /// int? number = 5;
  /// String? result = number.let((it) => 'Number is $it');
  /// print(result); // Output: Number is 5
  /// ```
  R? let<R>(R Function(T it) callback) {
    if (this == null) return null;
    return callback(this as T);
  }

  /// Calls the specified function [callback] with `this` as its argument and returns `this`.
  ///
  /// Example:
  /// ```dart
  /// final numbers = <int>[1, 2, 3].also((it) => it.add(4));
  /// print(numbers); // [1, 2, 3, 4]
  /// ```
  T? also(void Function(T it) callback) {
    if (this == null) return null;
    callback(this as T);
    return this;
  }

  /// Calls the specified function [op] with `this` as its argument and returns its result.
  ///
  /// Example:
  /// ```dart
  /// var result = 'Hello'.run((it) => '$it World');
  /// print(result); // Output: Hello World
  /// ```
  R? run<R>(R Function(T it) op) {
    if (this == null) return null;
    return op(this as T);
  }

  /// Calls the specified function [op] with `this` as its argument and returns `this`,
  /// useful for chaining.
  ///
  /// Example:
  /// ```dart
  /// final list = <int>[1, 2, 3].apply((it) => print('List has ${it.length} elements'));
  /// ```
  T? apply(void Function(T it) op) {
    if (this == null) return null;
    op(this as T);
    return this;
  }

  /// Returns `this` if it satisfies the given predicate [test], otherwise returns `null`.
  ///
  /// Example:
  /// ```dart
  /// int? number = 5.takeIf((it) => it > 3);
  /// print(number); // Output: 5
  ///
  /// number = 5.takeIf((it) => it > 6);
  /// print(number); // Output: null
  /// ```
  T? takeIf(bool Function(T it) test) {
    if (this != null && test(this as T)) return this;
    return null;
  }

  /// Returns `this` if it does **not** satisfy the given predicate [test], otherwise returns `null`.
  ///
  /// Example:
  /// ```dart
  /// int? number = 5.takeUnless((it) => it > 6);
  /// print(number); // Output: 5
  ///
  /// number = 5.takeUnless((it) => it > 3);
  /// print(number); // Output: null
  /// ```
  T? takeUnless(bool Function(T it) test) {
    if (this != null && !test(this as T)) return this;
    return null;
  }

  /// Attempts to cast `this` to the specified type [R].
  ///
  /// Returns `this` as `R` if possible, otherwise returns `null`.
  ///
  /// Example:
  /// ```dart
  /// var str = 'Hello';
  /// var number = str.cast<int>(); // null
  ///
  /// var value = 42;
  /// var castedValue = value.cast<num>(); // 42
  /// ```
  R? cast<R>() {
    if (this is R) return this as R;
    return null;
  }
}

/// Throws the object returned by [errorFactoryFunc] if [test] evaluates to `true`.
///
/// Example:
/// ```dart
/// final n = 0;
/// throwIf(n < 1, () => ArgumentError('n must be greater than 0'));
/// ```
void throwIf(bool test, Object Function() errorFactoryFunc) {
  if (test) {
    // ignore: only_throw_errors
    throw errorFactoryFunc();
  }
}

/// Throws the object returned by [errorFactoryFunc] if [test] evaluates to `false`.
///
/// Example:
/// ```dart
/// final n = 1;
/// throwIfNot(n > 1, () => ArgumentError('n must be greater than 1'));
/// ```
void throwIfNot(bool test, Object Function() errorFactoryFunc) {
  if (!test) {
    // ignore: only_throw_errors
    throw errorFactoryFunc();
  }
}

/// Executes a provided action and handles potential errors.
///
/// If an exception occurs, the optional [onError] callback is invoked.
/// If [onError] is not provided or returns `null`, the error is swallowed and
/// `null` is returned.
///
/// Example:
/// ```dart
/// var result = runCaching(() => int.parse('123'));
/// print(result); // 123
///
/// var errorResult = runCaching(() => int.parse('abc'), onError: (e, s) => 0);
/// print(errorResult); // 0
/// ```
FutureOr<T?> runCaching<T>(
  FutureOr<T?> Function() action, {
  FutureOr<T?> Function(Object error, StackTrace stackTrace)? onError,
}) {
  FutureOr<T?> handleError(Object error, StackTrace stackTrace) {
    if (onError == null) return null;

    try {
      return onError(error, stackTrace);
    } catch (_) {
      return null;
    }
  }

  try {
    final result = action.call();

    if (result is Future<T?>) {
      return result.then<T?>(
        (value) => value,
        onError: (Object error, StackTrace stackTrace) =>
            Future<T?>.value(handleError(error, stackTrace)),
      );
    }

    return result;
  } catch (error, stacktrace) {
    return handleError(error, stacktrace);
  }
}

/// A safe JSON decoding function that returns `null` if decoding fails.
///
/// Example:
/// ```dart
/// var jsonData = tryJsonDecode('{"name": "John"}');
/// print(jsonData?['name']); // John
///
/// var invalidJson = tryJsonDecode('invalid json');
/// print(invalidJson); // null
/// ```
dynamic tryJsonDecode(
  String value, {
  Object? Function(Object? key, Object? value)? reviver,
}) {
  try {
    return jsonDecode(value, reviver: reviver);
  } catch (e) {
    return null;
  }
}
