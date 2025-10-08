import 'package:flutter/material.dart';

import '../../../index.dart';

class MyDatePicker {
  MyDatePicker._();

  /// {@tool snippet} Show a dialog with time unconditionally displayed in 24 hour
  /// format.
  ///
  /// ```dart
  /// Future<TimeOfDay?> selectedTime24Hour = MyDatePicker.time(
  ///   context: context,
  ///   initialTime: const TimeOfDay(hour: 10, minute: 47),
  ///   builder: (BuildContext context, Widget? child) {
  ///     return MediaQuery(
  ///       data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
  ///       child: child!,
  ///     );
  ///   },
  /// );
  /// ```
  /// {@end-tool}
  ///
  static Future<TimeOfDay?> time({
    required BuildContext context,
    required TimeOfDay initialTime,
    TransitionBuilder? builder,
    bool barrierDismissible = true,
    String? cancelText,
    String? confirmText,
    String? helpText,
    String? errorInvalidText,
    String? hourLabelText,
    String? minuteLabelText,
  }) async {
    assert(debugCheckHasMaterialLocalizations(context), '');

    final Widget dialog = MyTimePickerDialog(
      initialTime: initialTime,
      cancelText: cancelText,
      confirmText: confirmText,
      helpText: helpText,
      errorInvalidText: errorInvalidText,
      hourLabelText: hourLabelText,
      minuteLabelText: minuteLabelText,
    );
    return MyDialog.show<TimeOfDay>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return builder == null ? dialog : builder(context, dialog);
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
