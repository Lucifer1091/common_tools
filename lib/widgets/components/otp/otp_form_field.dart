import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../../index.dart';

class MyOtpFormField extends MyFormBuilderField<String> {
  MyOtpFormField({
    /// {@macro MyOtp.maxLength}
    required int maxLength,

    /// {@macro MyOtp.children}
    required List<Widget> children,

    super.id,
    super.key,
    super.onSaved,
    super.forceErrorText,

    /// {@macro MyFormBuilderField.validator}
    String? Function(String)? validator,

    /// {@macro MyOtp.initialValue}
    super.initialValue,

    /// {@macro MyOtp.enabled}
    super.enabled,
    super.autovalidateMode,
    super.restorationId,
    super.label,
    super.error,
    super.description,

    /// {@macro MyOtp.onChanged}
    void Function(String)? onChanged,
    super.valueTransformer,
    super.onReset,
    super.readOnly,

    /// {@macro MyOtp.gap}
    double? gap,

    /// {@macro MyOtp.jumpToNextWhenFilled}
    bool jumpToNextWhenFilled = true,

    /// {@macro MyOtp.inputFormatters}
    List<TextInputFormatter>? inputFormatters,

    /// {@macro MyOtp.keyboardType}
    TextInputType? keyboardType,
  }) : super(
         validator:
             validator == null
                 ? null
                 : (v) => validator(v ?? ''.padRight(maxLength)),
         onChanged:
             onChanged == null
                 ? null
                 : (v) => onChanged(v ?? ''.padRight(maxLength)),
         builder: (field) {
           final state =
               field
                   as MyFormBuilderFieldState<
                     MyFormBuilderField<String>,
                     String
                   >;
           return MyOtp(
             enabled: state.enabled,
             keyboardType: keyboardType,
             inputFormatters: inputFormatters,
             gap: gap,
             maxLength: maxLength,
             jumpToNextWhenFilled: jumpToNextWhenFilled,
             onChanged: state.didChange,
             initialValue: state.initialValue,
             children: children,
           );
         },
       );
}
