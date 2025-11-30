import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../../index.dart';

class MyCheckboxFormField extends MyFormBuilderField<bool> {
  MyCheckboxFormField({
    required bool initialValue,

    super.id,
    super.key,
    super.onSaved,
    super.forceErrorText,
    super.label,
    super.error,
    super.description,
    void Function(bool)? onChanged,
    super.valueTransformer,
    super.onReset,
    super.enabled,
    super.autovalidateMode,
    super.restorationId,
    super.focusNode,

    String? title,
    String? subtitle,
    MyCheckboxShape? shape,
    bool showDivider = false,
    String? Function(bool)? validator,
    MyCheckboxSize size = MyCheckboxSize.small,
    Duration? duration,
  }) : super(
         initialValue: initialValue,
         onChanged: onChanged == null ? null : (v) => onChanged(v ?? false),
         validator: validator == null ? null : (v) => validator(v ?? false),
         builder: (field) {
           final state = field as _MyFormBuilderCheckboxState;
           return MyCheckbox(
             checked: state.value,
             onChanged: state.didChange,
             enabled: state.enabled,
             size: size,
             duration: duration,
             title: title,
             subtitle: subtitle,
             shape: shape,
             showDivider: showDivider,
             checkBoxLeftSpace: 0,
             insetSpacing: 0,
             subtitlePadding: EdgeInsets.only(right: 16, left: 32),
             margin: EdgeInsets.zero,
           );
         },
       );

  @override
  MyFormBuilderFieldState<MyCheckboxFormField, bool> createState() =>
      _MyFormBuilderCheckboxState();
}

class _MyFormBuilderCheckboxState
    extends MyFormBuilderFieldState<MyCheckboxFormField, bool> {}
