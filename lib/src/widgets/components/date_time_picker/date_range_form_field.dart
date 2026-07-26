import 'package:flutter/material.dart';

import '../../form/field.dart';
import '../button/my_button.dart';
import './date_field.dart';

/// A form field that wraps [MyDateField], integrating it with the form
/// infrastructure (MyFormBuilderField).
class MyDateRangeFormField extends MyFormBuilderField<DateTimeRange?> {
  MyDateRangeFormField({
    super.initialValue,
    super.id,
    super.key,
    super.onSaved,
    super.forceErrorText,
    super.label,
    super.error,
    super.description,
    super.valueTransformer,
    super.onReset,
    super.enabled,
    super.autovalidateMode,
    super.restorationId,
    super.focusNode,

    // MyDateField params
    String? placeholder,
    ValueChanged<DateTimeRange?>? onChanged,
    String Function(DateTimeRange)? formatDateRange,
    bool? showOutsideDays,
    DateTime? firstDate,
    DateTime? lastDate,
    int? min,
    int? max,
    bool Function(DateTime day)? selectableDayPredicate,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    Widget? leading,
    Widget? trailing,
    Widget? child,
    MyButtonType? type,
    MyButtonSize? size,
    double? width,
    double? height,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    bool autofocus = false,
    List<BoxShadow>? shadows,
    Gradient? gradient,
    double? gap,
    MainAxisAlignment? mainAxisAlignment,
    MyButtonShape? shape,
    ValueChanged<bool>? onFocusChange,
    bool? expands,
    TextStyle? textStyle,

    String? Function(DateTimeRange?)? validator,
  }) : super(
         onChanged: onChanged == null ? null : (v) => onChanged(v),
         validator: validator == null ? null : (v) => validator(v),
         builder: (field) {
           // field is the FormFieldState created by MyFormBuilderField.
           final state =
               field
                   as MyFormBuilderFieldState<
                     MyDateRangeFormField,
                     DateTimeRange?
                   >;

           return MyDateField(
             mode: DateTimeFieldPickerMode.range,
             placeholder: placeholder,
             // selected value comes from the form field state
             selectedRange: state.value,
             formatDateRange: formatDateRange,
             onRangeChanged: state.didChange,
             showOutsideDays: showOutsideDays,
             firstDate: firstDate,
             lastDate: lastDate,
             min: min,
             max: max,
             selectableDayPredicate: selectableDayPredicate,
             onTap: onTap,
             onLongPress: onLongPress,
             leading: leading,
             trailing: trailing,
             type: type,
             size: size,
             width: width,
             height: height,
             margin: margin,
             padding: padding,
             autofocus: autofocus,
             focusNode: state.widget.focusNode ?? state.focusNode,
             shadows: shadows,
             gradient: gradient,
             enabled: enabled && state.enabled,
             gap: gap,
             mainAxisAlignment: mainAxisAlignment,
             shape: shape,
             onFocusChange: onFocusChange,
             expands: expands,
             textStyle: textStyle,
             child: child,
           );
         },
       );

  @override
  MyFormBuilderFieldState<MyDateRangeFormField, DateTimeRange?> createState() =>
      _MyFormBuilderDateFieldState();
}

class _MyFormBuilderDateFieldState
    extends MyFormBuilderFieldState<MyDateRangeFormField, DateTimeRange?> {}
