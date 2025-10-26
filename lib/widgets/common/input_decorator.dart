import 'package:flutter/widgets.dart';

import '../../index.dart';

class MyInputDecorator extends StatelessWidget {
  const MyInputDecorator({
    super.key,
    this.child,
    this.label,
    this.error,
    this.description,
    this.decoration,
  });

  final Widget? child;
  final Widget? label;
  final Widget? error;
  final Widget? description;
  final MyDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    final theme = MyTheme.of(context);
    final effectiveDecoration =
        decoration ??
        MyDecoration(border: MyBorder.all(color: theme.colorScheme.border));

    final hasError = effectiveDecoration.hasError ?? false;

    final defaultErrorStyle = theme.typography.bodyMedium.copyWith(
      fontWeight: FontWeight.w500,
      color: theme.colorScheme.destructive,
    );

    final defaultLabelStyle = theme.typography.bodyMedium.copyWith(
      fontWeight: FontWeight.w500,
      color: theme.colorScheme.foreground,
    );

    final effectiveErrorStyle =
        effectiveDecoration.errorStyle ?? defaultErrorStyle;

    final effectiveLabelStyle = switch (hasError) {
      true => effectiveDecoration.errorLabelStyle ?? defaultErrorStyle,
      false => effectiveDecoration.labelStyle ?? defaultLabelStyle,
    };

    final effectiveDescriptionStyle = (effectiveDecoration.descriptionStyle ??
            theme.typography.bodyMedium)
        .fallback(color: theme.colorScheme.mutedForeground);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Padding(
            padding:
                effectiveDecoration.labelPadding ??
                const EdgeInsets.only(bottom: 8),
            child: DefaultTextStyle(style: effectiveLabelStyle, child: label!),
          ),
        if (child != null) child!,
        if (description != null)
          Padding(
            padding:
                effectiveDecoration.descriptionPadding ??
                const EdgeInsets.only(top: 8),
            child: DefaultTextStyle(
              style: effectiveDescriptionStyle,
              child: description!,
            ),
          ),
        if (error != null)
          Padding(
            padding:
                effectiveDecoration.errorPadding ??
                const EdgeInsets.only(top: 8),
            child: DefaultTextStyle(style: effectiveErrorStyle, child: error!),
          ),
      ],
    );
  }
}

extension TextStyleExtension on TextStyle {
  /// Returns a new TextStyle where any null property is replaced by the
  /// corresponding property if passed as a parameter. If both are null, the
  /// property remains null.
  TextStyle fallback({
    Color? color,
    Color? backgroundColor,
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? letterSpacing,
    double? wordSpacing,
    TextBaseline? textBaseline,
    double? height,
    TextLeadingDistribution? leadingDistribution,
    Locale? locale,
    Paint? foreground,
    Paint? background,
    List<Shadow>? shadows,
    List<FontFeature>? fontFeatures,
    List<FontVariation>? fontVariations,
    TextDecoration? decoration,
    Color? decorationColor,
    TextDecorationStyle? decorationStyle,
    double? decorationThickness,
    String? debugLabel,
    String? fontFamily,
    List<String>? fontFamilyFallback,
    TextOverflow? overflow,
  }) {
    T? fallback<T>(T? currentValue, T? newValue) {
      return currentValue == null && newValue != null ? newValue : currentValue;
    }

    return TextStyle(
      color: fallback(this.color, color),
      backgroundColor: fallback(this.backgroundColor, backgroundColor),
      fontSize: fallback(this.fontSize, fontSize),
      fontWeight: fallback(this.fontWeight, fontWeight),
      fontStyle: fallback(this.fontStyle, fontStyle),
      letterSpacing: fallback(this.letterSpacing, letterSpacing),
      wordSpacing: fallback(this.wordSpacing, wordSpacing),
      textBaseline: fallback(this.textBaseline, textBaseline),
      height: fallback(this.height, height),
      leadingDistribution: fallback(
        this.leadingDistribution,
        leadingDistribution,
      ),
      locale: fallback(this.locale, locale),
      foreground: fallback(this.foreground, foreground),
      background: fallback(this.background, background),
      shadows: fallback(this.shadows, shadows),
      fontFeatures: fallback(this.fontFeatures, fontFeatures),
      fontVariations: fallback(this.fontVariations, fontVariations),
      decoration: fallback(this.decoration, decoration),
      decorationColor: fallback(this.decorationColor, decorationColor),
      decorationStyle: fallback(this.decorationStyle, decorationStyle),
      decorationThickness: fallback(
        this.decorationThickness,
        decorationThickness,
      ),
      debugLabel: fallback(this.debugLabel, debugLabel),
      fontFamily: fallback(this.fontFamily, fontFamily),
      fontFamilyFallback: fallback(this.fontFamilyFallback, fontFamilyFallback),
      overflow: fallback(this.overflow, overflow),
    );
  }
}
