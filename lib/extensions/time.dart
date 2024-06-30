part of 'extensions.dart';

extension TimeConversions on TimeOfDay? {
  /// Checks if the [TimeOfDay] value is null.
  bool get isNull => this == null;

  /// Checks if the [TimeOfDay] value is not null.
  bool get isNotNull => !isNull;

  DateTime? toDateTime() {
    if (isNull) return null;

    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, this!.hour, this!.minute);
  }

  String? timeToString() {
    if (isNull) return null;

    final timeFormat = DateFormat.jm();
    return timeFormat.format(this!.toDateTime()!);
  }
}
