/// Common Operations for Iterables with nullable items.
extension IterableValidators<T> on Iterable<T>? {
  /// Returns `true` if this nullable iterable is either `null` or empty.
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  /// Returns `false` if this nullable iterable is either `null` or empty.
  bool get isNotNullOrEmpty => this != null && this!.isNotEmpty;

  // This getter checks if the List contains exactly one element.
  bool get isSingle => isNotNullOrEmpty && this!.length == 1;

  /// Returns `true` if the iterable is has an element of type [S].
  bool anyType<S extends T>() => this?.whereType<S>().isNotEmpty ?? false;
}
