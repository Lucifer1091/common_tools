import 'package:flutter/material.dart';

import '../../../index.dart';

class MyDatePicker {
  MyDatePicker._();

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
    bool? unSelectedEmpty,
    TimeRangeViewType? timeRangeViewType,
    ValueChanged<TimeOfDay>? onStartTimeChange,
    ValueChanged<TimeOfDay>? onEndTimeChange,
    VoidCallback? onCancel,
    bool use24HrFormat = false,
    bool barrierDismissible = true,
  }) {
    assert(debugCheckHasMaterialLocalizations(context), '');

    final Widget dialog = MyTimeRangeDialog(
      okLabel: 'OK',
      cancelLabel: 'CANCEL',
      unSelectedEmpty: unSelectedEmpty ?? false,
      headerDefaultStartLabel: 'START',
      headerDefaultEndLabel: 'END',
      autoAdjust: autoAdjust ?? true,
      timeRangeViewType: timeRangeViewType ?? TimeRangeViewType.start,
      onStartTimeChange: onStartTimeChange,
      onEndTimeChange: onEndTimeChange,
      startTime: startTime,
      endTime: endTime,
      onSubmitted: (_) {},
      onCancel: onCancel,
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
