import 'dart:math';
import 'dart:ui' as ui show TextHeightBehavior;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'td_font_loader.dart';

/// Text widget
/// Design principles:
/// 1. For easier usage, extensions to system components must be compatible with all system widget features, so users don't abandon TDesign due to missing system features.
/// 2. For non-system properties, add comments where possible.
///
/// Requirements: Flatten some properties from TextStyle to the outer layer.
/// 1. Expose all system properties and support all system operations.
/// 2. Restrict usage to several fonts configured by the theme.
/// 3. Provide a method to convert to system Text, so components that only accept system Text can use it (same for Image).
/// 4. Support custom TextStyle.
/// 5. Compatible with TextSpan.
///
/// Tips:
/// Regex for replacing named parameters:
/// Step 1: Copy all optional parameters from Text and format like:
/// Text(data,
/// this.style,
/// this.strutStyle,
/// ...)
/// Step 2: Regex replace:
/// Match (with and without default values): this\.([a-z|A-Z]+)[ ]*[\=]+[ ]*[a-z|A-Z]+\,|this\.([a-z|A-Z]+)\,
/// Replace: $1$2: this.$1$2,
///
class TDText extends StatelessWidget {
  const TDText(
    this.data, {
    this.font,
    this.fontWeight,
    this.fontFamily,
    this.textColor = Colors.black,
    this.backgroundColor,
    this.isTextThrough = false,
    this.lineThroughColor = Colors.white,
    this.package,
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
    this.forceVerticalCenter = false,
    this.isInFontLoader = false,
    this.fontFamilyUrl,
    super.key,
  }) : textSpan = null;

  /// 富文本构造方法
  const TDText.rich(
    this.textSpan, {
    this.font,
    this.fontWeight,
    this.fontFamily,
    this.textColor = Colors.black,
    this.backgroundColor,
    this.isTextThrough = false,
    this.lineThroughColor = Colors.white,
    this.package,
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
    this.forceVerticalCenter = false,
    this.isInFontLoader = false,
    this.fontFamilyUrl,
  }) : data = null;

  /// 字体尺寸，包含大小size和行高height
  final Font? font;

  /// 字体粗细
  final FontWeight? fontWeight;

  /// 字体ttf
  final FontFamily? fontFamily;

  /// 文本颜色
  final Color textColor;

  /// 背景颜色
  final Color? backgroundColor;

  /// 字体包名
  final String? package;

  /// 是否是横线穿过样式(删除线)
  final bool? isTextThrough;

  /// 删除线颜色，对应TestStyle的decorationColor
  final Color? lineThroughColor;

  /// 自定义的TextStyle，其中指定的属性，将覆盖扩展的外层属性
  final TextStyle? style;

  /// 以下系统text属性，释义请参考系统[Text]中注释
  final data;

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

  final InlineSpan? textSpan;

  /// 是否强制居中
  final bool forceVerticalCenter;

  /// 是否在FontLoader中使用
  final bool isInFontLoader;

  /// 是否禁用懒加载FontFamily的能力
  final String? fontFamilyUrl;

  @override
  Widget build(BuildContext context) {
    if (fontFamilyUrl?.isNotEmpty ?? false) {
      // 如果设置了Url,则使用TGFontLoader
      return TDFontLoaderWidget(
        textWidget: this,
        fontFamilyUrl: fontFamilyUrl!,
      );
    }

    if (forceVerticalCenter && kTextForceVerticalCenterEnable) {
      final config = getConfiguration(context);
      var paddingConfig = config?.paddingConfig;

      final textFont =
          font ??
          TDTheme.of(context).fontBodyLarge ??
          Font(size: 16, lineHeight: 24);
      final fontSize = style?.fontSize ?? textFont.size;
      final height = style?.height ?? textFont.height;

      paddingConfig ??= TDTextPaddingConfig.getDefaultConfig();
      final showHeight = min(paddingConfig.heightRate, height);
      return Container(
        color: style?.backgroundColor ?? backgroundColor,
        height: fontSize * height,
        padding: paddingConfig.getPadding(data, fontSize, height),
        child: _getRawText(
          context: context,
          textStyle: getTextStyle(context, height: showHeight),
        ),
      );
    }
    final bgColor = style?.backgroundColor ?? backgroundColor;
    if (bgColor == null) {
      return _getRawText(context: context);
    }
    return ColoredBox(color: bgColor, child: _getRawText(context: context));
  }

  /// 提取成方法，允许业务定义自己的TDTextConfiguration
  TDTextConfiguration? getConfiguration(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TDTextConfiguration>();
  }

  TextStyle? getTextStyle(
    BuildContext context, {
    double? height,
    Color? backgroundColor,
  }) {
    final textFont =
        font ??
        TDTheme.of(context).fontBodyLarge ??
        Font(size: 16, lineHeight: 24);

    var stylePackage = package ?? fontFamily?.package;
    var styleFontFamily = style?.fontFamily ?? fontFamily?.fontFamily;
    if (kTextNeedGlobalFontFamily) {
      final globalFontFamily = getConfiguration(context)?.globalFontFamily;
      styleFontFamily ??= globalFontFamily?.fontFamily;
      stylePackage ??= globalFontFamily?.package;
    }
    final realFontWeight = style?.fontWeight ?? fontWeight;
    // Flutter 3.0之后，iOS w500之下字体不生效，需要替换字体
    if (PlatformUtil.isIOS &&
        (styleFontFamily == null || styleFontFamily.isEmpty) &&
        realFontWeight != null &&
        realFontWeight.index <= FontWeight.w500.index) {
      stylePackage = null;
      styleFontFamily = 'PingFang SC';
    }
    return TextStyle(
      inherit: style?.inherit ?? true,
      color: style?.color ?? textColor,
      backgroundColor: backgroundColor,
      fontSize: style?.fontSize ?? textFont.size,
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
      fontFamily: styleFontFamily,
      fontFamilyFallback: style?.fontFamilyFallback,
      package: isInFontLoader ? null : stylePackage,
    );
  }

  /// 获取系统原始Text，以便使用到只能接收系统Text组件的地方
  /// 转化为系统原始Text后，将失去padding和background属性
  Text getRawText({required BuildContext context}) {
    return _getRawText(context: context, backgroundColor: backgroundColor);
  }

  Text _getRawText({
    required BuildContext context,
    TextStyle? textStyle,
    Color? backgroundColor,
  }) {
    return textSpan == null
        ? Text(
          data,
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
        );
  }
}

/// TextSpan的TDesign扩展，将部分TextStyle中的参数扁平化。
class TDTextSpan extends TextSpan {
  /// 构造参数，扩展参数释义可参考[TDText]中字段注释
  TDTextSpan({
    BuildContext?
    context, // 如果未设置font，且不想使用默认的fontBodyLarge尺寸时，需设置context，否则可省略
    Font? font,
    FontWeight? fontWeight,
    FontFamily? fontFamily,
    Color textColor = Colors.black,
    bool? isTextThrough = false,
    Color? lineThroughColor = Colors.white,
    String? package,
    String? text,
    List<InlineSpan>? children,
    TextStyle? style,
    GestureRecognizer? recognizer,
    MouseCursor? mouseCursor,
    PointerEnterEventListener? onEnter,
    PointerExitEventListener? onExit,
    String? semanticsLabel,
  }) : super(
         text: text,
         children: children,
         style: _getTextStyle(
           context,
           style,
           font,
           fontWeight,
           fontFamily,
           textColor,
           isTextThrough,
           lineThroughColor,
           package,
         ),
         recognizer: recognizer,
         mouseCursor: mouseCursor,
         onEnter: onEnter,
         onExit: onExit,
         semanticsLabel: semanticsLabel,
       );

  static TextStyle? _getTextStyle(
    BuildContext? context,
    TextStyle? style,
    Font? font,
    FontWeight? fontWeight,
    FontFamily? fontFamily,
    Color textColor,
    bool? isTextThrough,
    Color? lineThroughColor,
    String? package,
  ) {
    final textFont =
        font ??
        TDTheme.of(context).fontBodyLarge ??
        Font(size: 16, lineHeight: 24);
    return TextStyle(
      inherit: style?.inherit ?? true,
      color: style?.color ?? textColor,
      backgroundColor: style?.backgroundColor,
      fontSize: style?.fontSize ?? textFont.size,
      fontWeight: style?.fontWeight ?? fontWeight ?? textFont.fontWeight,
      fontStyle: style?.fontStyle,
      letterSpacing: style?.letterSpacing,
      wordSpacing: style?.wordSpacing,
      textBaseline: style?.textBaseline,
      height: style?.height ?? textFont.height,
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
      fontFamily: style?.fontFamily ?? fontFamily?.fontFamily,
      fontFamilyFallback: style?.fontFamilyFallback,
      package: package,
    );
  }
}
