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

    final date = await MyDatePicker.date(
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
          hour: initial?.hour ?? 0,
          minute: initial?.minute ?? 0,
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

  static Future<DateTimeRange?> range(
    {
      required  BuildContext context,
    DateTimeRange? initialDateRange,
    DateTime? firstDate,
    DateTime? lastDate,
    List<MyQuickDateRange>? ranges,
  }) async {
    if (initialDateRange != null) {
      if (firstDate != null && initialDateRange.start.isBefore(firstDate)) {
        firstDate = initialDateRange.start;
      }
      if (lastDate != null && initialDateRange.end.isAfter(lastDate)) {
        lastDate = initialDateRange.end;
      }
    }

    return showFancyDateRangePicker(
      context: context,
      initialDateRange: initialDateRange,
      firstDate: firstDate ?? kDefaultFirstSelectableDate,
      lastDate: lastDate ?? kDefaultLastSelectableDate,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );
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

  //  static Future<DateTime?> show({
  //     required BuildContext context,
  //     required DateTimeFieldPickerMode mode,
  //     DateTime? initialDate,
  //     DateTime? firstDate,
  //     DateTime? lastDate,
  //     OnDateTimeSelect? onDateTimeSelect,
  //     DatePickerMode? initialDatePickerMode,
  //   }) async {
  //     DateTime? selectedDateTime = initialDate ?? DateTime.now();

  //     selectedDateTime = _getInitialDate(
  //       initialDate,
  //       firstDate ?? kDefaultFirstSelectableDate,
  //       lastDate ?? kDefaultLastSelectableDate,
  //     );

  //     switch (mode) {
  //       // TODO : Break Month and Year Pickers in Separate Cases
  //       case DateTimeFieldPickerMode.year:
  //         final date = await getYear(
  //           context,
  //           initialDate: selectedDateTime,
  //           firstDate: firstDate,
  //           lastDate: lastDate,
  //         );
  //         onDateTimeSelect?.call(date, null);
  //         return date;
  //       case DateTimeFieldPickerMode.month:
  //       case DateTimeFieldPickerMode.monthYear:
  //         final date = await getMonthYear(
  //           context,
  //           initialDate: selectedDateTime,
  //           firstDate: firstDate,
  //           lastDate: lastDate,
  //           // initialMonthPickerMode: initialMonthPickerMode,
  //         );
  //         onDateTimeSelect?.call(date, null);
  //         return date;

  //       case DateTimeFieldPickerMode.date:
  //         final date = await getDate(
  //           context,
  //           initialDate: selectedDateTime,
  //           firstDate: firstDate,
  //           lastDate: lastDate,
  //           initialDatePickerMode: initialDatePickerMode,
  //         );
  //         onDateTimeSelect?.call(date, null);
  //         return date;

  //       case DateTimeFieldPickerMode.time:
  //         DateTime date0 = _getInitialTime(
  //           initialDate,
  //           firstDate ?? kDefaultFirstSelectableDate,
  //           lastDate ?? kDefaultLastSelectableDate,
  //         );

  //         final timeOfDay = await getTime(
  //           context,
  //           initialTime: TimeOfDay.fromDateTime(date0),
  //         );
  //         onDateTimeSelect?.call(null, timeOfDay);
  //         return convert(timeOfDay);

  //       case DateTimeFieldPickerMode.dateTime:
  //         TimeOfDay? timeOfDay;

  //         final date = await getDate(
  //           context,
  //           initialDate: selectedDateTime,
  //           firstDate: firstDate,
  //           lastDate: lastDate,
  //           initialDatePickerMode: initialDatePickerMode,
  //         ).then((date) async {
  //           if (date != null) {
  //             DateTime date0 = _getInitialTime(
  //               initialDate,
  //               firstDate ?? kDefaultFirstSelectableDate,
  //               lastDate ?? kDefaultLastSelectableDate,
  //             );

  //             timeOfDay = await getTime(
  //               context,
  //               initialTime: TimeOfDay.fromDateTime(date0),
  //             );
  //           }
  //           return date;
  //         });
  //         onDateTimeSelect?.call(combine(date, timeOfDay), timeOfDay);
  //         return combine(date, timeOfDay);
  //     }
  //   }
}
