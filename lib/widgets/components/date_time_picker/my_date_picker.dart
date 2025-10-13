import 'package:flutter/material.dart';

import '../../../index.dart';

class MyDatePicker {
  MyDatePicker._();

  static Future<DateTime?> date({
    required BuildContext context,
    DateTime? initial,
    bool barrierDismissible = true,
    DateTime? firstDate,
    DateTime? lastDate,
    bool showOutsideDays = true,
    bool hideNavigation = false,
    DateStateBuilder? stateBuilder,
  }) async {
    assert(debugCheckHasMaterialLocalizations(context), '');

    final dialog = MyCalendarPickerDialog(
      selectionMode: CalendarSelectionMode.single,
      initial: CalendarValue.single(initial ?? DateTime.now()),
      firstDate: firstDate,
      lastDate: lastDate,
      showOutsideDays: showOutsideDays,
      hideNavigation: hideNavigation,
      stateBuilder: stateBuilder,
    );

    final CalendarValue? result = await MyDialog.show<CalendarValue?>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (ctx) => dialog,
    );

    if (result == null) return null;
    final single = result.toSingle();
    return single.date;
  }

  /// Opens a dialog that lets the user pick multiple dates (or months/years if you change [viewType]).
  /// Returns the full set as a [List<DateTime>], or null if cancelled.
  static Future<List<DateTime>?> dates({
    required BuildContext context,
    List<DateTime>? initial,
    CalendarViewType viewType = CalendarViewType.date,
    bool barrierDismissible = true,
    int? min,
    int? max,
    DateTime? firstDate,
    DateTime? lastDate,
    bool showOutsideDays = true,
    bool hideNavigation = false,
    DateStateBuilder? stateBuilder,
  }) async {
    assert(debugCheckHasMaterialLocalizations(context), '');

    final dialog = MyCalendarPickerDialog(
      selectionMode: CalendarSelectionMode.multi,
      initial: CalendarValue.multi(List<DateTime>.from(initial ?? const [])),
      min: min,
      max: max,
      firstDate: firstDate,
      lastDate: lastDate,
      showOutsideDays: showOutsideDays,
      hideNavigation: hideNavigation,
      stateBuilder: stateBuilder,
    );

    final CalendarValue? result = await MyDialog.show<CalendarValue?>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (ctx) => dialog,
    );

    if (result == null) return null;
    final multi = result.toMulti();
    // Return a copy to avoid exposing internal list
    return List<DateTime>.from(multi.dates);
  }

  /// Pick a month, return the selected month as a DateTime (day=1), or null if cancelled.
  static Future<DateTime?> month({
    required BuildContext context,
    DateTime? initialMonth,
    DateTime? firstDate,
    DateTime? lastDate,
    bool hideNavigation = false,
    bool barrierDismissible = true,
    DateStateBuilder? stateBuilder,
  }) async {
    // Coerce initial inside bounds if provided
    DateTime init = initialMonth ?? DateTime.now();

    if (firstDate != null &&
        (init.year < firstDate.year ||
            (init.year == firstDate.year && init.month < firstDate.month))) {
      init = DateTime(firstDate.year, firstDate.month);
    }

    if (lastDate != null &&
        (init.year > lastDate.year ||
            (init.year == lastDate.year && init.month > lastDate.month))) {
      init = DateTime(lastDate.year, lastDate.month);
    }

    return MyDialog.show<DateTime?>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder:
          (_) => MonthPickerDialog(
            initialMonth: init,
            firstDate: firstDate,
            lastDate: lastDate,
            hideNavigation: hideNavigation,
            stateBuilder: stateBuilder,
          ),
    );
  }

  /// Pick a year, return the selected year as an int, or null if cancelled.
  static Future<int?> year({
    required BuildContext context,
    int? initialYear,
    DateTime? firstDate,
    DateTime? lastDate,
    bool hideNavigation = false,
    bool barrierDismissible = true,
    DateStateBuilder? stateBuilder,
  }) async {
    final int initYear =
        initialYear ??
        DateTime.now().year.clamp(
          firstDate?.year ?? -999999,
          lastDate?.year ?? 999999,
        );

    return MyDialog.show<int?>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder:
          (_) => YearPickerDialog(
            initialYear: initYear,
            firstDate: firstDate,
            lastDate: lastDate,
            hideNavigation: hideNavigation,
            stateBuilder: stateBuilder,
          ),
    );
  }

  static Future<TimeOfDay?> time({
    required BuildContext context,
    required TimeOfDay initial,
    bool use24HrFormat = false,
    bool barrierDismissible = true,
  }) async {
    assert(debugCheckHasMaterialLocalizations(context), '');

    final Widget dialog = MyTimePickerDialog(initialTime: initial);

    return MyDialog.show<TimeOfDay>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return use24HrFormat
            ? MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(alwaysUse24HourFormat: true),
              child: dialog,
            )
            : dialog;
      },
    );
  }

  static Future<TimeRange?> timeRange({
    required BuildContext context,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    bool? autoAdjust,
    bool use24HrFormat = false,
    bool barrierDismissible = true,
  }) {
    assert(debugCheckHasMaterialLocalizations(context), '');

    final Widget dialog = MyTimeRangeDialog(
      autoAdjust: autoAdjust ?? true,
      startTime: startTime,
      endTime: endTime,
    );

    return MyDialog.show<TimeRange>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return use24HrFormat
            ? MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(alwaysUse24HourFormat: true),
              child: dialog,
            )
            : dialog;
      },
    );
  }

  /// Shows a dialog containing the duration picker.
  ///
  /// The returned Future resolves to the duration selected by the user when the user
  /// closes the dialog. If the user cancels the dialog, null is returned.
  ///
  /// To show a dialog with [initial] equal to the current time:
  ///
  /// ```dart
  /// MyDatePicker.duration(
  ///   initial: new Duration.now(),
  ///   context: context,
  /// );
  /// ```
  static Future<Duration?> duration({
    required BuildContext context,
    Duration? initial,
    BaseUnit baseUnit = BaseUnit.minute,
    BoxDecoration? decoration,
    Duration? upperBound,
    Duration? lowerBound,
    int? snapTo,
  }) async {
    return MyDialog.show<Duration>(
      context: context,
      builder: (context) {
        return MyDurationPickerDialog(
          initialTime: initial ?? Duration.zero,
          baseUnit: baseUnit,
          decoration: decoration,
          upperBound: upperBound,
          lowerBound: lowerBound,
          snapTo: snapTo,
        );
      },
    );
  }
}
