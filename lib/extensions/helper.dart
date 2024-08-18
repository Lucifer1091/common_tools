import 'dart:convert';

/// A safe json decode function that uses [jsonDecode] and returns null if
/// decoding fails.
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

/// Throws [IllegalStateException] if [argument] is `null`.
/// If [name] is supplied, it is used as the parameter name
/// in the error message.
/// Returns the [argument] if it is not null.
T checkNotNull<T>(T argument, [String? message]) =>
    argument ??
    (throw IllegalStateException(message ?? 'Argument cannot be null'));

/// Throws [IllegalStateException] if [value] is false.
// ignore: avoid_positional_boolean_parameters
void check(bool value, [String? message]) {
  if (!value) {
    throw IllegalStateException(message ?? 'value cannot be false');
  }
}

/// Throws [IllegalArgumentException] if [argument] is `null`.
/// If [message] is supplied, it is used as the error message.
/// Returns the [argument] if it is not null.
T requireNotNull<T>(T argument, [String? message]) =>
    argument ??
    (throw IllegalArgumentException(
      message ?? 'Argument requires to be non-null',
    ));

/// Throws [IllegalArgumentException] if [value] is false.
/// If [message] is supplied, it is used as the error message.
// ignore: avoid_positional_boolean_parameters
void require(bool value, [String? message]) {
  if (!value) {
    throw IllegalArgumentException(message ?? 'Value is required to be true');
  }
}

/// Thrown to indicate that a method has been passed an illegal or
/// inappropriate argument.
class IllegalArgumentException implements Exception {
  /// factory constructor that allows to pass a message
  IllegalArgumentException(this.message);

  /// message explaining why this occurred
  final String message;

  @override
  String toString() => 'IllegalArgumentException: $message';
}

/// Signals that a method has been invoked at an illegal or
/// inappropriate time.
class IllegalStateException implements Exception {
  /// factory constructor that allows to pass a message
  IllegalStateException(this.message);

  /// message explaining why this occurred
  final String message;

  @override
  String toString() => 'IllegalStateException: $message';
}
