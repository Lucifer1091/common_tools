part of 'utilities.dart';

/// A utility class for generating random UUID and ULID strings.
///
/// The `Uuid` class provides static methods to generate random UUID and ULID strings
/// of a specified length using alphanumeric characters.
///
/// Example usage:
/// ```dart
/// // Generate a UUID with the default length of 48 characters
/// String uuid = Uuid.create();
///
/// // Generate a UUID with a custom length
/// String customUuid = Uuid.create(32);
///
/// // Generate a ULID
/// String ulid = Uuid.createUlid();
/// ```
class Guid {
  Guid._();

  // Random number generator used for generating UUIDs and ULIDs.
  static final _random = Random();

  /// Creates a UUID (Universally Unique Identifier) string of the specified [len].
  ///
  /// The UUID string is composed of uppercase and lowercase letters
  /// and numbers.
  ///
  /// - [len]: The length of the UUID string to be generated. Defaults to 36.
  ///
  /// Returns a randomly generated UUID string of the specified length.
  ///
  /// Example usage:
  /// ```dart
  /// // Generate a UUID with the default length of 36 characters
  /// String uuid = Uuid.create();
  ///
  /// // Generate a UUID with a custom length of 32 characters
  /// String customUuid = Uuid.create(32);
  /// ```
  static String uuid([int len = 36]) {
    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    final buffer = StringBuffer();
    for (var i = 0; i < len; i++) {
      buffer.write(chars[_random.nextInt(chars.length)]);
    }
    return buffer.toString();
  }

  /// Creates a ULID (Universally Unique Lexicographically Sortable Identifier) string.
  ///
  /// The ULID string is composed of 26 characters including uppercase letters
  /// and numbers, ensuring lexicographical order.
  ///
  /// Returns a randomly generated ULID string.
  ///
  /// Example usage:
  /// ```dart
  /// // Generate a ULID
  /// String ulid = Uuid.createUlid();
  /// ```
  static String ulid() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    const encodingChars = '0123456789ABCDEFGHJKMNPQRSTVWXYZ';
    String encodeTime(int time, int length) {
      final buffer = StringBuffer();
      for (var i = length - 1; i >= 0; i--) {
        buffer.write(encodingChars[(time >> (i * 5)) & 0x1f]);
      }
      return buffer.toString();
    }

    final timePart = encodeTime(timestamp, 10);
    final randomPart = List.generate(
      16,
      (_) => encodingChars[_random.nextInt(encodingChars.length)],
    ).join();

    return timePart + randomPart;
  }
}
