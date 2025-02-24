import 'dart:math' as math;

import 'index.dart';

extension IterableConverters<T> on Iterable<T>? {
  T? get random {
    if (isNotNullOrEmpty) return null;

    final random = math.Random();
    final int index = random.nextInt(this!.length);
    return this!.elementAt(index);
  }

  T? firstWhereOrNull(bool Function(T element) comparator) {
    if (isNotNullOrEmpty) return null;

    try {
      return this!.firstWhere(comparator);
    } on StateError catch (_) {
      return null;
    }
  }
}
