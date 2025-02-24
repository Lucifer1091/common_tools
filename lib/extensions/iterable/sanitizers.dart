extension IterableSanitizers<T> on Iterable<T> {
  Iterable<T> sortByAsc<TSelected extends Comparable<TSelected>>(
    TSelected Function(T) selector,
  ) =>
      toList()..sort((a, b) => selector(a).compareTo(selector(b)));

  Iterable<T> sortByDesc<TSelected extends Comparable<TSelected>>(
    TSelected Function(T) selector,
  ) =>
      toList()..sort((a, b) => selector(b).compareTo(selector(a)));

  Iterable<E> mapWithIndex<E>(E Function(int index, T value) f) =>
      Iterable<int>.generate(length).map((int i) => f(i, elementAt(i)));

  // returns only distinct elements
  Iterable<T> distinctBy(Object Function(T element) compare) {
    final result = <T>[];
    forEach(
      (element) {
        if (!result.any((x) => compare(x) == compare(element))) {
          result.add(element);
        }
      },
    );
    return result;
  }
}
