import 'dart:ui' as ui show TextHeightBehavior;

import 'package:flutter/material.dart';

import '../../../index.dart';

class MyText extends StatelessWidget {
  const MyText(
    this.text, {
    this.fontSize,
    this.fontWeight,
    this.fontFamily,
    this.textColor,
    this.isTextThrough = false,
    this.lineThroughColor,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.backgroundColor,
    this.selectionColor,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaler,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
    super.key,
  }) : textSpan = null;

  const MyText.rich(
    this.textSpan, {
    this.fontSize,
    this.fontWeight,
    this.fontFamily,
    this.textColor,
    this.isTextThrough = false,
    this.lineThroughColor,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.backgroundColor,
    this.selectionColor,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaler,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
    super.key,
  }) : text = null;

  final double? fontSize;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final Color? textColor;
  final bool isTextThrough;
  final Color? lineThroughColor;
  final TextStyle? style;
  final String? text;
  final StrutStyle? strutStyle;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Color? backgroundColor;
  final Color? selectionColor;
  final Locale? locale;
  final bool? softWrap;
  final TextOverflow? overflow;
  final double? textScaler;
  final int? maxLines;
  final String? semanticsLabel;
  final TextWidthBasis? textWidthBasis;
  final ui.TextHeightBehavior? textHeightBehavior;
  final MyTextSpan? textSpan;

  @override
  Widget build(BuildContext context) {
    final bgColor = style?.backgroundColor ?? backgroundColor;

    if (text == null && textSpan == null) {
      return const NoWidget();
    }

    final textWidget = _getRawText(context: context);

    if (bgColor == null) return textWidget;

    return ColoredBox(color: bgColor, child: textWidget);
  }

  Text _getRawText({required BuildContext context, TextStyle? textStyle}) {
    final effectiveTextStyle = textStyle ?? _getTextStyle(context);

    if (textSpan == null) {
      return Text(
        text!,
        key: key,
        style: effectiveTextStyle,
        strutStyle: strutStyle,
        textAlign: textAlign,
        textDirection: textDirection,
        locale: locale,
        softWrap: softWrap,
        overflow: overflow,
        textScaler:
            textScaler != null
                ? TextScaler.linear(textScaler!)
                : TextScaler.noScaling,
        maxLines: maxLines,
        semanticsLabel: semanticsLabel,
        textWidthBasis: textWidthBasis,
        textHeightBehavior: textHeightBehavior,
        selectionColor: selectionColor,
      );
    } else {
      return Text.rich(
        textSpan!,
        style: effectiveTextStyle,
        strutStyle: strutStyle,
        textAlign: textAlign,
        textDirection: textDirection,
        locale: locale,
        softWrap: softWrap,
        overflow: overflow,
        textScaler:
            textScaler != null
                ? TextScaler.linear(textScaler!)
                : TextScaler.noScaling,
        maxLines: maxLines,
        semanticsLabel: semanticsLabel,
        textWidthBasis: textWidthBasis,
        textHeightBehavior: textHeightBehavior,
        selectionColor: selectionColor,
      );
    }
  }

  TextStyle _getTextStyle(BuildContext context) {
    final defaults = context.bodyLarge;

    return TextStyle(
      inherit: style?.inherit ?? true,
      overflow: style?.overflow ?? overflow ?? defaults.overflow,
      color: style?.color ?? textColor ?? context.colorScheme.foreground,
      backgroundColor: style?.backgroundColor ?? backgroundColor,
      fontSize: style?.fontSize ?? fontSize ?? defaults.fontSize,
      fontWeight: style?.fontWeight ?? fontWeight ?? defaults.fontWeight,
      fontStyle: style?.fontStyle,
      letterSpacing: style?.letterSpacing,
      wordSpacing: style?.wordSpacing,
      textBaseline: style?.textBaseline,
      height: style?.height ?? defaults.height,
      leadingDistribution: style?.leadingDistribution,
      locale: style?.locale,
      foreground: style?.foreground,
      background: style?.background,
      shadows: style?.shadows,
      fontFeatures: style?.fontFeatures,
      decoration:
          style?.decoration ??
          (isTextThrough ? TextDecoration.lineThrough : TextDecoration.none),
      decorationColor: style?.decorationColor ?? lineThroughColor,
      decorationStyle: style?.decorationStyle,
      decorationThickness: style?.decorationThickness,
      debugLabel: style?.debugLabel,
      fontFamily: style?.fontFamily ?? fontFamily ?? defaults.fontFamily,
      fontFamilyFallback:
          style?.fontFamilyFallback ?? defaults.fontFamilyFallback,
    );
  }
}

/// Extension of TextSpan, flattens some parameters in TextStyle.
class MyTextSpan extends TextSpan {
  MyTextSpan({
    BuildContext? context,
    double? fontSize,
    FontWeight? fontWeight,
    String? fontFamily,
    Color? textColor,
    bool isTextThrough = false,
    Color? lineThroughColor,
    super.text,
    super.children,
    TextStyle? style,
    super.recognizer,
    super.mouseCursor,
    super.onEnter,
    super.onExit,
    super.semanticsLabel,
  }) : super(
         style: _getTextStyle(
           context,
           style,
           fontSize,
           fontWeight,
           fontFamily,
           textColor,
           isTextThrough,
           lineThroughColor,
         ),
       );

  static TextStyle _getTextStyle(
    BuildContext? context,
    TextStyle? style,
    double? fontSize,
    FontWeight? fontWeight,
    String? fontFamily,
    Color? textColor,
    bool isTextThrough,
    Color? lineThroughColor,
  ) {
    final defaults = context?.bodyLarge ?? MyTypography.geist().bodyLarge;

    return TextStyle(
      inherit: style?.inherit ?? true,
      color: style?.color ?? textColor ?? context?.colorScheme.foreground,
      backgroundColor: style?.backgroundColor,
      fontSize: style?.fontSize ?? fontSize ?? defaults.fontSize,
      fontWeight: style?.fontWeight ?? fontWeight ?? defaults.fontWeight,
      fontStyle: style?.fontStyle,
      letterSpacing: style?.letterSpacing,
      wordSpacing: style?.wordSpacing,
      textBaseline: style?.textBaseline,
      height: style?.height ?? defaults.height,
      leadingDistribution: style?.leadingDistribution,
      locale: style?.locale,
      foreground: style?.foreground,
      background: style?.background,
      shadows: style?.shadows,
      fontFeatures: style?.fontFeatures,
      decoration:
          style?.decoration ??
          (isTextThrough ? TextDecoration.lineThrough : TextDecoration.none),
      decorationColor: style?.decorationColor ?? lineThroughColor,
      decorationStyle: style?.decorationStyle,
      decorationThickness: style?.decorationThickness,
      debugLabel: style?.debugLabel,
      fontFamily: style?.fontFamily ?? fontFamily ?? defaults.fontFamily,
      fontFamilyFallback:
          style?.fontFamilyFallback ?? defaults.fontFamilyFallback,
    );
  }
}
