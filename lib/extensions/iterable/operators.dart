extension IterableOptionalExt<T> on Iterable<T?> {
  /// Returns a new list the the non-null items.
  ///
  /// Same as `where((el) => el != null)`
  List<T> removeNull() {
    final list = <T>[];
    for (final element in this) {
      if (element != null) list.add(element);
    }
    return list;
  }
}
