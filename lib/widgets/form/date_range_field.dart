import 'package:common_tools/common_tools.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';

import '../custom/spaces.dart';
import '../widgets.dart';

class CustomDateRangeField extends StatelessWidget {
  final DateFormat? format;

  final String? labelText;
  final FloatingLabelBehavior floatingLabelBehavior;
  final Color? labelColor;
  final TextStyle? labelStyle;

  final bool enabled;
  final bool isRequired;
  final String requiredLabelCharacter;
  final Color? requiredLabelColor;

  final BoxConstraints? prefixIconConstraints;
  final Widget? prefixWidget;
  final IconData? prefixIcon;
  final Color? prefixIconColor;
  final IconData? suffixIcon;
  final Color? suffixIconColor;
  final double? prefixIconSize;
  final Widget? suffixWidget;
  final double? suffixIconSize;
  final VoidCallback? onSuffixTap;

  final void Function(DateTimeRange?)? onChanged;
  final void Function(DateTimeRange?)? onSave;

  final String? Function(DateTimeRange?)? validator;

  final Color? textColor;
  final TextStyle? textStyle;

  final Color? fillColor;
  final Color? errorColor;

  final double height;
  final double? width;
  final double verticalPadding;

  final Color? enableBorderColor;
  final Color? focusBorderColor;
  final Color? errorBorderColor;
  final double? borderRadius;

  final DateTimeRange? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final DatePickerEntryMode? initialDatePickerMode;

  const CustomDateRangeField({
    super.key,
    this.format,
    this.isRequired = false,
    this.requiredLabelColor,
    this.requiredLabelCharacter = '*',
    this.labelText,
    this.floatingLabelBehavior = FloatingLabelBehavior.auto,
    this.labelColor,
    this.labelStyle,
    this.prefixIconConstraints,
    this.prefixWidget,
    this.prefixIcon,
    this.prefixIconColor,
    this.suffixIcon,
    this.suffixIconColor,
    this.onChanged,
    this.validator,
    this.onSave,
    this.enabled = true,
    this.fillColor,
    this.errorColor,
    this.textColor,
    this.textStyle,
    this.verticalPadding = 6,
    this.width,
    this.enableBorderColor,
    this.focusBorderColor,
    this.errorBorderColor,
    this.borderRadius,
    this.height = 8,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.initialDatePickerMode,
    this.prefixIconSize,
    this.suffixWidget,
    this.suffixIconSize,
    this.onSuffixTap,
  })  : assert(
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
        );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: verticalPadding),
        child: Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: context.primaryColor,
              onSurface: context.primaryColor,
            ),
            dialogTheme: DialogTheme(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            timePickerTheme: TimePickerThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              helpTextStyle:
                  context.bodyMedium?.copyWith(color: context.primaryColor),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: context.primaryColor,
              ),
            ),
          ),
          child: DateRangeField(
            enabled: enabled,
            dateFormat: format ?? DateFormat.yMMMd(),
            initialValue: initialDate,
            firstDate: firstDate,
            lastDate: lastDate,
            margin: EdgeInsets.symmetric(vertical: verticalPadding),
            decoration: buildInputDecoration(context),
            onSaved: onSave,
            initialEntryMode: initialDatePickerMode,
            validator: (value) {
              if (isRequired) {
                if (value == null) return '${(labelText)} is required.';
              }

              if (validator != null) return validator!(value);

              return null;
            },
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }

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
        text: TextSpan(
          style: labelStyle ??
              context.bodyLarge?.copyWith(
                color: labelColor ?? Colors.black,
                fontWeight: FontWeight.w400,
              ),
          children: [
            TextSpan(text: labelText),
            if (isRequired) ...[
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
      hintStyle: textStyle ??
          context.titleMedium?.copyWith(
            color: textColor ?? Colors.black,
            fontWeight: FontWeight.w400,
          ),
      prefixIconConstraints: prefixIconConstraints,
      prefixIcon: prefixWidget ??
          (prefixIcon != null
              ? Icon(
                  prefixIcon,
                  size: 22,
                  color: prefixIconColor ?? Colors.grey,
                )
              : null),
      suffixIcon: suffixIcon != null
          ? GestureDetector(
              onTap: onSuffixTap,
              child: Icon(
                suffixIcon,
                size: 20,
                color: suffixIconColor ?? Colors.grey,
              ),
            ).mouseRegion
          : suffixWidget,
      enabledBorder: borderRadius != null
          ? OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 6),
              borderSide: BorderSide(
                color:
                    enableBorderColor ?? context.enabledBorder.borderSide.color,
                width: context.enabledBorder.borderSide.width,
              ),
            )
          : context.enabledBorder.copyWith(
              borderSide: BorderSide(
                color:
                    enableBorderColor ?? context.enabledBorder.borderSide.color,
                width: context.enabledBorder.borderSide.width,
              ),
            ),
      focusedBorder: borderRadius != null
          ? OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 6),
              borderSide: BorderSide(
                color:
                    focusBorderColor ?? context.focusedBorder.borderSide.color,
                width: context.focusedBorder.borderSide.width,
              ),
            )
          : context.focusedBorder.copyWith(
              borderSide: BorderSide(
                color:
                    focusBorderColor ?? context.focusedBorder.borderSide.color,
                width: context.focusedBorder.borderSide.width,
              ),
            ),
      errorBorder: borderRadius != null
          ? OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 6),
              borderSide: BorderSide(
                color: errorBorderColor ?? context.errorBorder.borderSide.color,
                width: context.errorBorder.borderSide.width,
              ),
            )
          : context.errorBorder.copyWith(
              borderSide: BorderSide(
                color: errorBorderColor ?? context.errorBorder.borderSide.color,
                width: context.errorBorder.borderSide.width,
              ),
            ),
      focusedErrorBorder: borderRadius != null
          ? OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 6),
              borderSide: BorderSide(
                color: errorBorderColor ??
                    context.focusedErrorBorder.borderSide.color,
                width: context.focusedErrorBorder.borderSide.width,
              ),
            )
          : context.focusedErrorBorder.copyWith(
              borderSide: BorderSide(
                color: errorBorderColor ??
                    context.focusedErrorBorder.borderSide.color,
                width: context.focusedErrorBorder.borderSide.width,
              ),
            ),
      fillColor: fillColor ?? context.fillColor,
      filled: true,
      alignLabelWithHint: true,
      focusColor: context.primaryColor,
      errorStyle: context.bodySmall?.copyWith(
        color: errorColor ?? context.errorColor,
      ),
      errorMaxLines: 2,
    );
  }
}
