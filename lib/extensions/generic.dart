part of 'extensions.dart';

extension GenericExtension<T> on T {
  /// Checks for null, empty or default conditions for various built-in types
  bool get isTrue {
    if (this == null) return false;
    if (this is bool) return this == true;
    if (this is num) return this != 0;
    if (this is String) return (this as String).isNotEmpty;
    if (this is Iterable) return (this as Iterable).isNotEmpty;
    if (this is Map) return (this as Map).isNotEmpty;
    return true;
  }

  bool get isFalse => !isTrue;
}
