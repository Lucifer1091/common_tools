import 'package:flutter/material.dart';

import '../../../data_types/time_range.dart';
import '../../../extensions/date/misc.dart';
import '../../../extensions/date/sanitizers.dart';
import '../dialog/my_dialog.dart';
import './pickers/my_calendar_picker.dart';
import './pickers/my_date_range_picker.dart';
import './pickers/my_duration_picker.dart';
import './pickers/my_quick_selector.dart';
import './pickers/my_time_picker.dart';

class MyDatePicker {
  MyDatePicker._();

  static Future<DateTime?> date({
    required BuildContext context,
    DateTime? initial,
    bool barrierDismissible = true,
    DateTime? firstDate,
    DateTime? lastDate,
    bool showOutsideDays = true,
    MyDateStateBuilder? stateBuilder,
  }) async {
    assert(debugCheckHasMaterialLocalizations(context), '');

    final dialog = MyCalendarPickerDialog(
      selectionMode: MyCalendarSelectionMode.single,
      initial: CalendarValue.single(initial ?? DateTime.now()),
      firstDate: firstDate,
      lastDate: lastDate,
      showOutsideDays: showOutsideDays,
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

  /// Opens a dialog that lets the user pick multiple dates.
  /// Returns the full set as a [List<DateTime>], or null if cancelled.
  static Future<List<DateTime>?> dates({
    required BuildContext context,
    List<DateTime>? initial,
    bool barrierDismissible = true,
    int? min,
    int? max,
    DateTime? firstDate,
    DateTime? lastDate,
    bool showOutsideDays = true,
    MyDateStateBuilder? stateBuilder,
  }) async {
    assert(debugCheckHasMaterialLocalizations(context), '');

    final dialog = MyCalendarPickerDialog(
      selectionMode: MyCalendarSelectionMode.multi,
      initial: CalendarValue.multi(List<DateTime>.from(initial ?? const [])),
      min: min,
      max: max,
      firstDate: firstDate,
      lastDate: lastDate,
      showOutsideDays: showOutsideDays,
      stateBuilder: stateBuilder,
    );

    final CalendarValue? result = await MyDialog.show<CalendarValue?>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (ctx) => dialog,
    );

    if (result == null) return null;
    final multi = result.toMulti();
    return List<DateTime>.from(multi.dates);
  }

  static Future<DateTime?> month({
    required BuildContext context,
    DateTime? initialMonth,
    DateTime? firstDate,
    DateTime? lastDate,
    bool barrierDismissible = true,
    MyDateStateBuilder? stateBuilder,
  }) async {
    return MyDialog.show<DateTime?>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (_) {
        return MyMonthPickerDialog(
          initialMonth: initialMonth ?? DateTime.now(),
          firstDate: firstDate,
          lastDate: lastDate,
          stateBuilder: stateBuilder,
        );
      },
    );
  }

  static Future<int?> year({
    required BuildContext context,
    int? initialYear,
    DateTime? firstDate,
    DateTime? lastDate,
    bool barrierDismissible = true,
    MyDateStateBuilder? stateBuilder,
  }) async {
    return MyDialog.show<int?>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (_) {
        return MyYearPickerDialog(
          initialYear: initialYear ?? DateTime.now().year,
          firstDate: firstDate,
          lastDate: lastDate,
          stateBuilder: stateBuilder,
        );
      },
    );
  }

  static Future<DateTime?> dateTime({
    required BuildContext context,
    DateTime? initial,
    DateTime? firstDate,
    DateTime? lastDate,
    bool showOutsideDays = true,
    bool use24HrFormat = false,
    MyDateStateBuilder? stateBuilder,
    bool barrierDismissible = true,
  }) async {
    TimeOfDay? time;

    final date =
        await MyDatePicker.date(
          context: context,
          initial: initial,
          firstDate: firstDate,
          lastDate: lastDate,
          barrierDismissible: barrierDismissible,
          showOutsideDays: showOutsideDays,
          stateBuilder: stateBuilder,
        ).then((date) async {
          if (date != null) {
            final initialTime = TimeOfDay(
              hour: initial?.hour ?? DateTime.now().hour,
              minute: initial?.minute ?? DateTime.now().minute,
            );
            if (context.mounted) {
              time = await MyDatePicker.time(
                context: context,
                initial: initialTime,
                barrierDismissible: barrierDismissible,
                use24HrFormat: use24HrFormat,
              );
            }
          }
          return date;
        });

    return date?.copyTime(time);
  }

  static Future<DateTimeRange?> range({
    required BuildContext context,
    DateTime? firstDate,
    DateTime? lastDate,
    DateTimeRange? initialDateRange,
    DateTime? currentDate,
    bool barrierDismissible = true,
    SelectableDayForRangePredicate? selectableDayPredicate,
    bool? showQuickSelector,
    int? minRangeDays,
    int? maxRangeDays,
    List<MyQuickDateRange>? ranges,
  }) async {
    firstDate ??= DateTime(1960);
    lastDate ??= DateTime(2099);

    assert(debugCheckHasMaterialLocalizations(context), '');

    initialDateRange = initialDateRange == null
        ? null
        : DateUtils.datesOnly(initialDateRange);
    firstDate = DateUtils.dateOnly(firstDate);
    lastDate = DateUtils.dateOnly(lastDate);

    currentDate = DateUtils.dateOnly(currentDate ?? MyDate.now());

    SelectableDayForRangePredicate? combinedSelectable;

    if (selectableDayPredicate != null ||
        minRangeDays != null ||
        maxRangeDays != null) {
      combinedSelectable = (DateTime day, DateTime? start, DateTime? end) {
        final bool baseOk =
            selectableDayPredicate?.call(day, start, end) ?? true;
        if (!baseOk) return false;

        if (start != null && end == null && !DateUtils.isSameDay(day, start)) {
          if (minRangeDays != null) {
            final earliestAllowedEnd = start.add(
              Duration(days: minRangeDays - 1),
            );
            if (day.isBefore(earliestAllowedEnd)) return false;
          }
          if (maxRangeDays != null) {
            final latestAllowedEnd = start.add(
              Duration(days: maxRangeDays - 1),
            );
            if (day.isAfter(latestAllowedEnd)) return false;
          }
        }

        return true;
      };
    }

    final Widget dialog = MyDateRangePickerDialog(
      initialDateRange: initialDateRange,
      firstDate: firstDate,
      lastDate: lastDate,
      currentDate: currentDate,
      selectableDayPredicate: combinedSelectable ?? selectableDayPredicate,
      showQuickSelector: showQuickSelector,
    );

    final DateTimeRange? picked = await MyDialog.show<DateTimeRange>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return dialog;
      },
    );

    // Final safety check (in case the dialog allows confirming outside the predicate)
    if (picked != null && (minRangeDays != null || maxRangeDays != null)) {
      final selLen = picked.end.difference(picked.start).inDays + 1;
      if ((minRangeDays != null && selLen < minRangeDays) ||
          (maxRangeDays != null && selLen > maxRangeDays)) {
        return null;
      }
    }

    return picked;
  }

  static Future<TimeOfDay?> time({
    required BuildContext context,
    TimeOfDay? initial,
    bool use24HrFormat = false,
    bool barrierDismissible = true,
  }) async {
    assert(debugCheckHasMaterialLocalizations(context), '');

    final Widget dialog = MyTimePickerDialog(
      initialTime: initial ?? TimeOfDay.now(),
    );

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
  ///   initial: Duration.zero,
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
