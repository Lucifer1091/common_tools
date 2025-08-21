import 'dart:ui' as ui show TextHeightBehavior;

import 'package:flutter/material.dart';

import '../../../index.dart';

class MyText extends StatelessWidget {
  const MyText(
    this.data, {
    this.fontSize,
    this.fontWeight,
    this.fontFamily,
    this.textColor,
    this.backgroundColor,
    this.selectionColor,
    this.isTextThrough = false,
    this.lineThroughColor,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
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
    this.backgroundColor,
    this.selectionColor,
    this.isTextThrough = false,
    this.lineThroughColor,
    super.key,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaler,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
  }) : data = null;

  final double? fontSize;

  final FontWeight? fontWeight;

  final String? fontFamily;

  final Color? textColor;

  final Color? backgroundColor;

  final Color? selectionColor;

  final bool? isTextThrough;

  final Color? lineThroughColor;

  final TextStyle? style;

  final String? data;

  final StrutStyle? strutStyle;

  final TextAlign? textAlign;

  final TextDirection? textDirection;

  final Locale? locale;

  final bool? softWrap;

  final TextOverflow? overflow;

  final double? textScaler;

  final int? maxLines;

  final String? semanticsLabel;

  final TextWidthBasis? textWidthBasis;

  final ui.TextHeightBehavior? textHeightBehavior;

  final TDTextSpan? textSpan;

  @override
  Widget build(BuildContext context) {
    final bgColor = style?.backgroundColor ?? backgroundColor;

    if (bgColor == null) return _getRawText(context: context);

    return ColoredBox(color: bgColor, child: _getRawText(context: context));
  }

  TextStyle? getTextStyle(
    BuildContext context, {
    double? height,
    Color? backgroundColor,
  }) {
    final textFont = context.bodyLarge;

    return TextStyle(
      inherit: style?.inherit ?? true,
      overflow: style?.overflow ?? overflow ?? textFont.overflow,
      color: style?.color ?? textColor ?? context.colorScheme.foreground,
      backgroundColor: backgroundColor,
      fontSize: style?.fontSize ?? fontSize ?? textFont.fontSize,
      fontWeight: style?.fontWeight ?? fontWeight ?? textFont.fontWeight,
      fontStyle: style?.fontStyle,
      letterSpacing: style?.letterSpacing,
      wordSpacing: style?.wordSpacing,
      textBaseline: style?.textBaseline,
      height: height ?? style?.height ?? textFont.height,
      leadingDistribution: style?.leadingDistribution,
      locale: style?.locale,
      foreground: style?.foreground,
      background: style?.background,
      shadows: style?.shadows,
      fontFeatures: style?.fontFeatures,
      decoration:
          style?.decoration ??
          (isTextThrough! ? TextDecoration.lineThrough : TextDecoration.none),
      decorationColor: style?.decorationColor ?? lineThroughColor,
      decorationStyle: style?.decorationStyle,
      decorationThickness: style?.decorationThickness,
      debugLabel: style?.debugLabel,
      fontFamily: style?.fontFamily ?? fontFamily ?? textFont.fontFamily,
      fontFamilyFallback:
          style?.fontFamilyFallback ?? textFont.fontFamilyFallback,
    );
  }

  Text _getRawText({
    required BuildContext context,
    TextStyle? textStyle,
    Color? backgroundColor,
  }) {
    return textSpan == null
        ? Text(
          data ?? '',
          key: key,
          style:
              textStyle ??
              getTextStyle(context, backgroundColor: backgroundColor),
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
        )
        : Text.rich(
          textSpan!,
          style:
              textStyle ??
              getTextStyle(context, backgroundColor: backgroundColor),
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

/// TDesign extension of TextSpan, flattens some parameters in TextStyle.
class TDTextSpan extends TextSpan {
  TDTextSpan({
    BuildContext? context,
    FontWeight? fontWeight,
    String? fontFamily,
    Color? textColor,
    bool? isTextThrough = false,
    Color? lineThroughColor,
    String? package,
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
           context ,
           style,
           fontWeight,
           fontFamily,
           textColor,
           isTextThrough,
           lineThroughColor,
           package,
         ),
       );

  static TextStyle? _getTextStyle(
    BuildContext? context,
    TextStyle? style,
    FontWeight? fontWeight,
    String? fontFamily,
    Color? textColor,
    bool? isTextThrough,
    Color? lineThroughColor,
    String? package,
  ) {
    final textFont = context?.bodyLarge;

    return TextStyle(
      inherit: style?.inherit ?? true,
      color: style?.color ?? textColor ?? context?.colorScheme.foreground,
      backgroundColor: style?.backgroundColor,
      fontSize: style?.fontSize ?? textFont?.fontSize,
      fontWeight: style?.fontWeight ?? fontWeight ?? textFont?.fontWeight,
      fontStyle: style?.fontStyle,
      letterSpacing: style?.letterSpacing,
      wordSpacing: style?.wordSpacing,
      textBaseline: style?.textBaseline,
      height: style?.height ?? textFont?.height,
      leadingDistribution: style?.leadingDistribution,
      locale: style?.locale,
      foreground: style?.foreground,
      background: style?.background,
      shadows: style?.shadows,
      fontFeatures: style?.fontFeatures,
      decoration:
          style?.decoration ??
          (isTextThrough! ? TextDecoration.lineThrough : TextDecoration.none),
      decorationColor: style?.decorationColor ?? lineThroughColor,
      decorationStyle: style?.decorationStyle,
      decorationThickness: style?.decorationThickness,
      debugLabel: style?.debugLabel,
      fontFamily: style?.fontFamily ?? fontFamily ?? textFont?.fontFamily,
      fontFamilyFallback: style?.fontFamilyFallback ?? textFont?.fontFamilyFallback,
      package: package,
    );
  }
}
