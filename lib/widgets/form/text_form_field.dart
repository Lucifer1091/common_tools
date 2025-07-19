import 'package:common_tools/common_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../layout/spaces.dart';

class CustomTextFormField extends StatelessWidget {
  final String? initialValue;
  final TextEditingController? controller;
  final String? validationKey;

  final FocusNode? focusNode;
  final bool? autofocus;

  final String? labelText;
  final FloatingLabelBehavior floatingLabelBehavior;
  final Color? labelColor;
  final TextStyle? labelStyle;

  final String? hintText;
  final TextStyle? hintStyle;

  final bool? readOnly;
  final bool? enabled;
  final bool isRequired;
  final bool? obscureText;
  final String obscuringCharacter;
  final String requiredLabelCharacter;
  final Color? requiredLabelColor;

  final BoxConstraints? prefixIconConstraints;
  final Widget? prefixWidget;
  final IconData? prefixIcon;
  final Color? prefixIconColor;
  final double? prefixIconSize;
  final IconData? suffixIcon;
  final Widget? suffixWidget;
  final double? suffixIconSize;
  final Color? suffixIconColor;

  final void Function(String?)? onChanged;
  final VoidCallback? onEditingComplete;
  final VoidCallback? onSuffixTap;
  final VoidCallback? onTap;
  final void Function(String?)? onSave;
  final void Function(String?)? onFieldSubmit;

  final int? maxLines;
  final int? maxLength;

  final String? Function(String?)? validator;
  final String? requiredErrorMessage;
  final List<TextInputFormatter>? inputFormatters;

  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;

  final Color? textColor;
  final TextStyle? textStyle;

  final Color? fillColor;
  final Color? cursorColor;
  final Color? errorColor;

  final TextCapitalization? textCapitalization;

  final double height;
  final double? width;
  final double verticalPadding;

  final Color? enableBorderColor;
  final Color? focusBorderColor;
  final Color? errorBorderColor;
  final Color? disableBorderColor;
  final double? borderRadius;

  final bool onTapSelectAll;

  final double? errorFontSize;
  final InputDecoration? inputDecoration;
  final bool showValidator;
  final BorderRadius? customBorderRadius;

  const CustomTextFormField({
    super.key,
    this.initialValue,
    this.validationKey,
    this.controller,
    this.isRequired = false,
    this.requiredLabelColor,
    this.requiredLabelCharacter = '*',
    this.labelText,
    this.floatingLabelBehavior = FloatingLabelBehavior.auto,
    this.labelColor,
    this.labelStyle,
    this.hintText,
    this.hintStyle,
    this.prefixIcon,
    this.prefixIconSize,
    this.prefixIconColor,
    this.prefixIconConstraints,
    this.prefixWidget,
    this.suffixIcon,
    this.suffixWidget,
    this.suffixIconSize,
    this.suffixIconColor,
    this.obscureText,
    this.obscuringCharacter = '*',
    this.onChanged,
    this.onSuffixTap,
    this.validator,
    this.requiredErrorMessage,
    this.onSave,
    this.inputFormatters,
    this.textInputAction,
    this.autofillHints,
    this.keyboardType,
    this.onEditingComplete,
    this.onFieldSubmit,
    this.readOnly,
    this.focusNode,
    this.maxLines,
    this.maxLength,
    this.fillColor,
    this.autofocus,
    this.textCapitalization,
    this.textColor,
    this.textStyle,
    this.verticalPadding = 6,
    this.width,
    this.enableBorderColor,
    this.focusBorderColor,
    this.errorBorderColor,
    this.cursorColor,
    this.errorColor,
    this.onTap,
    this.height = 8,
    this.borderRadius,
    this.onTapSelectAll = false,
    this.errorFontSize,
    this.inputDecoration,
    this.disableBorderColor,
    this.enabled,
    this.showValidator = true,
    this.customBorderRadius,
  }) : assert(
         initialValue == null || controller == null,
         'Use either initialValue or controller.',
       ),
       assert(
         labelStyle == null || labelColor == null,
         'Cannot provide both a labelStyle and a labelColor\n'
         'To provide custom, use "labelStyle: TextStyle()".',
       ),
       assert(
         textStyle == null || textColor == null,
         'Cannot provide both a textStyle and a textColor\n'
         'To provide custom, use "textStyle: TextStyle()".',
       ),
       assert(
         prefixWidget == null || prefixIcon == null,
         'Cannot provide both a prefixWidget and a prefixIconData\n'
         'To provide custom, use "prefixWidget".',
       ),
       assert(
         prefixWidget == null || prefixIconColor == null,
         'Cannot provide both a prefixWidget and a prefixIconColor\n'
         'To provide custom, use "prefixWidget".',
       ),
       assert(
         suffixWidget == null || suffixIcon == null,
         'Cannot provide both a suffixWidget and a suffixIconData\n'
         'To provide custom, use "suffixWidget".',
       ),
       assert(
         suffixWidget == null || suffixIconColor == null,
         'Cannot provide both a suffixWidget and a suffixIconColor\n'
         'To provide custom, use "suffixWidget".',
       ),
       assert(
         !onTapSelectAll || onTap == null,
         'Cannot provide onTap when onTapSelectAll is true.',
       );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: verticalPadding),
        child: FormBuilderTextField(
          textAlign: TextAlign.left,
          name: validationKey ?? labelText ?? '',
          controller: controller,
          cursorColor: cursorColor ?? Colors.blue,
          cursorRadius: const Radius.circular(32),
          cursorWidth: 2,
          decoration: inputDecoration ?? buildInputDecoration(context),
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
          autofocus: autofocus ?? false,
          focusNode: focusNode,
          readOnly: _readOnly,
          // Necessary to Avoid Text Field break Focus on TextInputAction.next
          enabled: enabled ?? !_readOnly,
          initialValue: initialValue,
          onTap:
              onTap ??
              (onTapSelectAll
                  ? () {
                    controller?.selection = TextSelection(
                      baseOffset: 0,
                      extentOffset: controller?.text.length ?? 0,
                    );
                  }
                  : null),
          onSubmitted: onFieldSubmit,
          maxLines: maxLines ?? 1,
          maxLength: maxLength,
          buildCounter:
              (_, {required currentLength, maxLength, required isFocused}) =>
                  null,
          scrollPadding: const EdgeInsets.all(8),
          textCapitalization: textCapitalization ?? TextCapitalization.words,
          onEditingComplete: onEditingComplete,
          textInputAction: textInputAction,
          inputFormatters: inputFormatters,
          autovalidateMode: AutovalidateMode.disabled,
          enableSuggestions: true,
          onSaved: onSave,
          validator: (value) {
            if (isRequired && showValidator) {
              if (value?.trim().isEmpty ?? true) {
                return '${(requiredErrorMessage ?? labelText)} is required.';
              }

              if (validator != null) return validator!(value?.trim());
            } else {
              if ((value?.trim().isNotEmpty ?? false) && showValidator) {
                if (validator != null) return validator!(value?.trim());
              } else if (!showValidator) {
                return validator?.call(value?.trim());
              }
            }

            return null;
          },
          autofillHints: autofillHints,
          keyboardType: keyboardType ?? TextInputType.text,
          onChanged: onChanged,
          obscureText: obscureText ?? false,
          style:
              textStyle ??
              context.titleMedium?.copyWith(
                color: textColor ?? Colors.black,
                fontWeight: FontWeight.w400,
              ),
          obscuringCharacter: obscuringCharacter,
        ),
      ),
    );
  }

  bool get _readOnly => readOnly ?? false;

  InputDecoration buildInputDecoration(BuildContext context) {
    return InputDecoration(
      contentPadding: EdgeInsets.only(
        left: 8,
        right: 2,
        top: height,
        bottom: height,
      ),
      floatingLabelBehavior: floatingLabelBehavior,
      floatingLabelAlignment: FloatingLabelAlignment.start,
      label: RichText(
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        text: TextSpan(
          style:
              labelStyle ??
              context.bodyLarge?.copyWith(
                color: labelColor ?? (_readOnly ? Colors.black : Colors.black),
                fontWeight: FontWeight.w400,
              ),
          children: [
            TextSpan(text: labelText),
            if (isRequired) ...[
              if (requiredLabelCharacter != '')
                const WidgetSpan(child: Space.w4()),
              TextSpan(
                text: requiredLabelCharacter,
                style: context.titleLarge?.copyWith(
                  color: requiredLabelColor ?? const Color(0xFFF1291A),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
      hintText: hintText,
      hintStyle: hintStyle,
      prefixIconConstraints: prefixIconConstraints,
      prefixIcon:
          prefixWidget ??
          (prefixIcon != null
              ? Icon(
                prefixIcon,
                size: prefixIconSize ?? 22,
                color: prefixIconColor ?? Colors.grey,
              )
              : null),
      suffixIcon:
          suffixIcon != null
              ? GestureDetector(
                onTap: onSuffixTap,
                child: Icon(
                  suffixIcon,
                  size: suffixIconSize ?? 22,
                  color: suffixIconColor ?? Colors.grey,
                ),
              ).mouseRegion
              : suffixWidget,
      enabledBorder:
          borderRadius != null || customBorderRadius != null
              ? OutlineInputBorder(
                borderRadius:
                    customBorderRadius ??
                    BorderRadius.circular(borderRadius ?? 4),
                borderSide: BorderSide(
                  color:
                      enableBorderColor ??
                      context.enabledBorder.borderSide.color,
                  width: context.enabledBorder.borderSide.width,
                ),
              )
              : context.enabledBorder.copyWith(
                borderSide: BorderSide(
                  color:
                      enableBorderColor ??
                      context.enabledBorder.borderSide.color,
                  width: context.enabledBorder.borderSide.width,
                ),
              ),
      focusedBorder:
          borderRadius != null || customBorderRadius != null
              ? OutlineInputBorder(
                borderRadius:
                    customBorderRadius ??
                    BorderRadius.circular(borderRadius ?? 4),
                borderSide: BorderSide(
                  color:
                      _readOnly
                          ? enableBorderColor ?? Colors.grey
                          : focusBorderColor ??
                              context.focusedBorder.borderSide.color,
                  width: context.focusedBorder.borderSide.width,
                ),
              )
              : context.focusedBorder.copyWith(
                borderSide: BorderSide(
                  color:
                      _readOnly
                          ? enableBorderColor ?? Colors.grey
                          : focusBorderColor ??
                              context.focusedBorder.borderSide.color,
                  width: context.focusedBorder.borderSide.width,
                ),
              ),
      errorBorder:
          borderRadius != null || customBorderRadius != null
              ? OutlineInputBorder(
                borderRadius:
                    customBorderRadius ??
                    BorderRadius.circular(borderRadius ?? 4),
                borderSide: BorderSide(
                  color:
                      errorBorderColor ?? context.errorBorder.borderSide.color,
                  width: context.errorBorder.borderSide.width,
                ),
              )
              : context.errorBorder.copyWith(
                borderSide: BorderSide(
                  color:
                      errorBorderColor ?? context.errorBorder.borderSide.color,
                  width: context.errorBorder.borderSide.width,
                ),
              ),
      focusedErrorBorder:
          borderRadius != null
              ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 4),
                borderSide: BorderSide(
                  color:
                      errorBorderColor ??
                      context.focusedErrorBorder.borderSide.color,
                  width: context.focusedErrorBorder.borderSide.width,
                ),
              )
              : context.focusedErrorBorder.copyWith(
                borderSide: BorderSide(
                  color:
                      errorBorderColor ??
                      context.focusedErrorBorder.borderSide.color,
                  width: context.focusedErrorBorder.borderSide.width,
                ),
              ),
      disabledBorder:
          borderRadius != null
              ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 4),
                borderSide: BorderSide(
                  color:
                      disableBorderColor ??
                      context.disableBorder.borderSide.color,
                  width: context.disableBorder.borderSide.width,
                ),
              )
              : context.disableBorder.copyWith(
                borderSide: BorderSide(
                  color:
                      disableBorderColor ??
                      context.disableBorder.borderSide.color,
                  width: context.disableBorder.borderSide.width,
                ),
              ),
      fillColor:
          _readOnly && fillColor == null
              ? const Color(0xfff5f5f5)
              : fillColor ?? context.fillColor,
      filled: true,
      alignLabelWithHint: true,
      focusColor: context.primary,
      errorStyle: context.bodySmall?.copyWith(
        fontSize: errorFontSize,
        color: errorColor ?? context.errorColor,
      ),
      errorMaxLines: 2,
    );
  }
}

class KeyBoardType {
  static TextInputType get number =>
      PlatformChecker.isIOS
          ? const TextInputType.numberWithOptions(signed: true)
          : TextInputType.number;
}
