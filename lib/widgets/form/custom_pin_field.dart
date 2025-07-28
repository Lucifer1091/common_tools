import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';

import '../../common_tools.dart';
import '../layout/spaces.dart';
import 'text_form_field.dart';

class CustomPinField extends StatelessWidget {
  const CustomPinField({
    required this.controller,
    super.key,
    this.onCompleted,
    this.onSubmitted,
    this.isRequired = false,
    this.textInputAction,
    this.title,
    this.titleStyle,
    this.height,
    this.width,
    this.textStyle,
    this.length,
    this.margin,
    this.radius,
    this.focusNode,
    this.onChanged,
    this.errorMsg,
    this.errorTextStyle,
  });

  final TextEditingController controller;
  final void Function(String)? onCompleted;
  final void Function(String)? onSubmitted;

  final bool isRequired;
  final TextInputAction? textInputAction;

  final String? title;
  final TextStyle? titleStyle;
  final double? height;
  final double? width;
  final TextStyle? textStyle;
  final int? length;
  final EdgeInsetsGeometry? margin;
  final double? radius;
  final FocusNode? focusNode;
  final void Function(String)? onChanged;
  final String? errorMsg;
  final TextStyle? errorTextStyle;

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      height: height ?? 100,
      width: width ?? 90,
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 8 / 2),
      textStyle:
          textStyle ??
          TextStyle(
            fontSize: context.headlineMedium?.fontSize!,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
      decoration: BoxDecoration(
        color: context.background,
        border: Border.all(color: const Color(0xFFCECECE), width: 1.27),
        borderRadius: BorderRadius.circular(radius ?? 14),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      color: context.background,
      border: Border.all(color: context.primary, width: 2),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: context.background,
        border: Border.all(color: const Color(0xFFCECECE), width: 1.27),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              title ?? '',
              style:
                  titleStyle ??
                  context.titleMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
          const Space.h16(),
        ],
        Pinput(
          length: length ?? 4,
          controller: controller,
          defaultPinTheme: defaultPinTheme,
          focusedPinTheme: focusedPinTheme,
          submittedPinTheme: submittedPinTheme,
          cursor: Text(
            '|',
            style:
                textStyle ??
                context.headlineMedium?.copyWith(fontWeight: FontWeight.w300),
          ),
          onCompleted: onCompleted,
          onSubmitted: onSubmitted,
          closeKeyboardWhenCompleted: false,
          textInputAction: textInputAction,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          errorTextStyle: errorTextStyle,
          keyboardType: KeyBoardType.number,
          validator: (value) {
            if (!isRequired) {
              return null;
            } else if (value == null || value.isEmpty) {
              return errorMsg ?? 'Pin is required.';
            }
            return null;
          },
          focusNode: focusNode,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
