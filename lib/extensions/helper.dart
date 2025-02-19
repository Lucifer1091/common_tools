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
