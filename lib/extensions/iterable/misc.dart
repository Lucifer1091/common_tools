import '../../index.dart';

/// String-building helpers for iterables.
///
/// Provides a configurable alternative to [Iterable.join] with support for
/// element transforms, limits, and truncation markers.
extension IterableJoinToString<T> on Iterable<T> {
  /// Creates a string from all the elements separated using [separator] and
  /// using the given [prefix] and [postfix] if supplied.
  ///
  /// If the collection could be huge, you can specify a non-negative value of
  /// [limit], in which case only the first [limit] elements will be appended,
  /// followed by the [truncated] string (which defaults to `'...'`).
  String joinToString({
    String separator = ', ',
    Transformer<T, String>? transform,
    String prefix = '',
    String postfix = '',
    int? limit,
    String truncated = '...',
  }) {
    final buffer = StringBuffer();
    var count = 0;

    for (final element in this) {
      if (limit != null && count >= limit) {
        buffer.write(truncated);
        return buffer.toString();
      }

      if (count > 0) buffer.write(separator);

      buffer.write(prefix);

      if (transform != null) {
        buffer.write(transform(element));
      } else {
        buffer.write(element.toString());
      }
      buffer.write(postfix);

      count++;
    }

    return buffer.toString();
  }
}
