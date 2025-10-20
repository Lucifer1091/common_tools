import 'package:flutter/widgets.dart';

import '../../index.dart';

@immutable
class MyDecoration {
  const MyDecoration({
    bool canMerge = true,
    this.border,
    this.focusedBorder,
    this.errorBorder,
    this.secondaryBorder,
    this.secondaryFocusedBorder,
    this.secondaryErrorBorder,
    this.labelStyle,
    this.errorLabelStyle,
    this.errorStyle,
    this.descriptionStyle,
    this.labelPadding,
    this.descriptionPadding,
    this.errorPadding,
    this.fallbackToBorder,
    this.color,
    this.image,
    this.shadows,
    this.gradient,
    this.backgroundBlendMode,
    this.shape,
    this.hasError,
    this.fallbackToLabelStyle,
    this.disableSecondaryBorder,
  }) : _canMerge = canMerge;

  // Private storage; intentionally excluded from == / hashCode.
  final bool _canMerge;

  /// Whether this instance should participate in merge() with another instance.
  bool get canMerge => _canMerge;

  static const MyDecoration none = MyDecoration(
    canMerge: false,
    border: Border(),
    focusedBorder: Border(),
    errorBorder: Border(),
    secondaryBorder: Border(),
    secondaryFocusedBorder: Border(),
    secondaryErrorBorder: Border(),
  );

  final TextStyle? labelStyle;
  final TextStyle? errorLabelStyle;
  final Border? border;
  final Border? focusedBorder;
  final Border? errorBorder;
  final Border? secondaryBorder;
  final Border? secondaryFocusedBorder;
  final Border? secondaryErrorBorder;
  final TextStyle? errorStyle;
  final TextStyle? descriptionStyle;
  final EdgeInsetsGeometry? labelPadding;
  final EdgeInsetsGeometry? descriptionPadding;
  final EdgeInsetsGeometry? errorPadding;
  final Color? color;
  final DecorationImage? image;
  final List<BoxShadow>? shadows;
  final Gradient? gradient;
  final BlendMode? backgroundBlendMode;
  final BoxShape? shape;
  final bool? hasError;
  final bool? disableSecondaryBorder;

  /// Whether to fallback to the [border] if no [focusedBorder] or [errorBorder]
  /// is provided, defaults to true.
  ///
  /// This also affects the [secondaryBorder] with the same conditions.
  final bool? fallbackToBorder;

  /// Whether to fallback to the [labelStyle] if no [errorLabelStyle] is
  /// provided, defaults to true.
  final bool? fallbackToLabelStyle;

  static MyDecoration? lerp(MyDecoration? a, MyDecoration? b, double t) {
    if (a == null && b == null) return null;

    return MyDecoration(
      labelStyle: TextStyle.lerp(a?.labelStyle, b?.labelStyle, t),
      errorLabelStyle: TextStyle.lerp(
        a?.errorLabelStyle,
        b?.errorLabelStyle,
        t,
      ),
      border: Border.lerp(a?.border, b?.border, t),
      focusedBorder: Border.lerp(a?.focusedBorder, b?.focusedBorder, t),
      errorBorder: Border.lerp(a?.errorBorder, b?.errorBorder, t),
      secondaryBorder: Border.lerp(a?.secondaryBorder, b?.secondaryBorder, t),
      secondaryFocusedBorder: Border.lerp(
        a?.secondaryFocusedBorder,
        b?.secondaryFocusedBorder,
        t,
      ),
      secondaryErrorBorder: Border.lerp(
        a?.secondaryErrorBorder,
        b?.secondaryErrorBorder,
        t,
      ),
      errorStyle: TextStyle.lerp(a?.errorStyle, b?.errorStyle, t),
      descriptionStyle: TextStyle.lerp(
        a?.descriptionStyle,
        b?.descriptionStyle,
        t,
      ),
      labelPadding: EdgeInsetsGeometry.lerp(
        a?.labelPadding,
        b?.labelPadding,
        t,
      ),
      descriptionPadding: EdgeInsetsGeometry.lerp(
        a?.descriptionPadding,
        b?.descriptionPadding,
        t,
      ),
      errorPadding: EdgeInsetsGeometry.lerp(
        a?.errorPadding,
        b?.errorPadding,
        t,
      ),
      color: Color.lerp(a?.color, b?.color, t),
      image: DecorationImage.lerp(a?.image, b?.image, t),
      // Non-lerpable/nullable fields: pick a/b based on t for stable behavior.
      shadows: t < 0.5 ? a?.shadows : b?.shadows,
      gradient: Gradient.lerp(a?.gradient, b?.gradient, t),
      backgroundBlendMode:
          t < 0.5 ? a?.backgroundBlendMode : b?.backgroundBlendMode,
      shape: t < 0.5 ? a?.shape : b?.shape,
      hasError: t < 0.5 ? a?.hasError : b?.hasError,
      disableSecondaryBorder:
          t < 0.5 ? a?.disableSecondaryBorder : b?.disableSecondaryBorder,
      fallbackToBorder: t < 0.5 ? a?.fallbackToBorder : b?.fallbackToBorder,
      fallbackToLabelStyle:
          t < 0.5 ? a?.fallbackToLabelStyle : b?.fallbackToLabelStyle,
    );
  }

  MyDecoration copyWith({
    TextStyle? labelStyle,
    TextStyle? errorLabelStyle,
    Border? border,
    Border? focusedBorder,
    Border? errorBorder,
    Border? secondaryBorder,
    Border? secondaryFocusedBorder,
    Border? secondaryErrorBorder,
    TextStyle? errorStyle,
    TextStyle? descriptionStyle,
    EdgeInsetsGeometry? labelPadding,
    EdgeInsetsGeometry? descriptionPadding,
    EdgeInsetsGeometry? errorPadding,
    Color? color,
    DecorationImage? image,
    List<BoxShadow>? shadows,
    Gradient? gradient,
    BlendMode? backgroundBlendMode,
    BoxShape? shape,
    bool? hasError,
    bool? disableSecondaryBorder,
    bool? fallbackToBorder,
    bool? fallbackToLabelStyle,
    bool? canMerge, // allow toggling merge behavior in the copy
  }) {
    final a = this;

    return MyDecoration(
      canMerge: canMerge ?? a.canMerge,
      labelStyle: labelStyle ?? a.labelStyle,
      errorLabelStyle: errorLabelStyle ?? a.errorLabelStyle,
      border: border ?? a.border,
      focusedBorder: focusedBorder ?? a.focusedBorder,
      errorBorder: errorBorder ?? a.errorBorder,
      secondaryBorder: secondaryBorder ?? a.secondaryBorder,
      secondaryFocusedBorder:
          secondaryFocusedBorder ?? a.secondaryFocusedBorder,
      secondaryErrorBorder: secondaryErrorBorder ?? a.secondaryErrorBorder,
      errorStyle: errorStyle ?? a.errorStyle,
      descriptionStyle: descriptionStyle ?? a.descriptionStyle,
      labelPadding: labelPadding ?? a.labelPadding,
      descriptionPadding: descriptionPadding ?? a.descriptionPadding,
      errorPadding: errorPadding ?? a.errorPadding,
      color: color ?? a.color,
      image: image ?? a.image,
      shadows: shadows ?? a.shadows,
      gradient: gradient ?? a.gradient,
      backgroundBlendMode: backgroundBlendMode ?? a.backgroundBlendMode,
      shape: shape ?? a.shape,
      hasError: hasError ?? a.hasError,
      disableSecondaryBorder:
          disableSecondaryBorder ?? a.disableSecondaryBorder,
      fallbackToBorder: fallbackToBorder ?? a.fallbackToBorder,
      fallbackToLabelStyle: fallbackToLabelStyle ?? a.fallbackToLabelStyle,
    );
  }

  MyDecoration merge(MyDecoration? other) {
    if (other == null) return this;
    if (!other.canMerge) return other;

    return copyWith(
      labelStyle: labelStyle?.merge(other.labelStyle) ?? other.labelStyle,
      errorLabelStyle:
          errorLabelStyle?.merge(other.errorLabelStyle) ??
          other.errorLabelStyle,
      border: Border.merge(border ?? Border(), other.border ?? Border()),
      focusedBorder: Border.merge(
        focusedBorder ?? Border(),
        other.focusedBorder ?? Border(),
      ),
      errorBorder: Border.merge(
        errorBorder ?? Border(),
        other.errorBorder ?? Border(),
      ),
      secondaryBorder: Border.merge(
        secondaryBorder ?? Border(),
        other.secondaryBorder ?? Border(),
      ),

      secondaryFocusedBorder: Border.merge(
        secondaryFocusedBorder ?? Border(),
        other.secondaryFocusedBorder ?? Border(),
      ),
      secondaryErrorBorder: Border.merge(
        secondaryErrorBorder ?? Border(),
        other.secondaryErrorBorder ?? Border(),
      ),
      errorStyle: errorStyle?.merge(other.errorStyle) ?? other.errorStyle,
      descriptionStyle:
          descriptionStyle?.merge(other.descriptionStyle) ??
          other.descriptionStyle,
      labelPadding: other.labelPadding,
      descriptionPadding: other.descriptionPadding,
      errorPadding: other.errorPadding,
      color: other.color,
      image: other.image,
      shadows: other.shadows,
      gradient: other.gradient,
      backgroundBlendMode: other.backgroundBlendMode,
      shape: other.shape,
      hasError: other.hasError,
      disableSecondaryBorder: other.disableSecondaryBorder,
      fallbackToBorder: other.fallbackToBorder,
      fallbackToLabelStyle: other.fallbackToLabelStyle,
      canMerge: canMerge,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;

    return other is MyDecoration &&
        other.labelStyle == labelStyle &&
        other.errorLabelStyle == errorLabelStyle &&
        other.border == border &&
        other.focusedBorder == focusedBorder &&
        other.errorBorder == errorBorder &&
        other.secondaryBorder == secondaryBorder &&
        other.secondaryFocusedBorder == secondaryFocusedBorder &&
        other.secondaryErrorBorder == secondaryErrorBorder &&
        other.errorStyle == errorStyle &&
        other.descriptionStyle == descriptionStyle &&
        other.labelPadding == labelPadding &&
        other.descriptionPadding == descriptionPadding &&
        other.errorPadding == errorPadding &&
        other.color == color &&
        other.image == image &&
        other.shadows == shadows &&
        other.gradient == gradient &&
        other.backgroundBlendMode == backgroundBlendMode &&
        other.shape == shape &&
        other.hasError == hasError &&
        other.disableSecondaryBorder == disableSecondaryBorder &&
        other.fallbackToBorder == fallbackToBorder &&
        other.fallbackToLabelStyle == fallbackToLabelStyle;
  }

  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    labelStyle,
    errorLabelStyle,
    border,
    focusedBorder,
    errorBorder,
    secondaryBorder,
    secondaryFocusedBorder,
    secondaryErrorBorder,
    errorStyle,
    descriptionStyle,
    labelPadding,
    descriptionPadding,
    errorPadding,
    color,
    image,
    shadows,
    gradient,
    backgroundBlendMode,
    shape,
    hasError,
    disableSecondaryBorder,
    fallbackToBorder,
    fallbackToLabelStyle,
  ]);

  @override
  String toString() {
    return 'MyDecoration('
        'border: $border, '
        'focusedBorder: $focusedBorder, '
        'errorBorder: $errorBorder, '
        'secondaryBorder: $secondaryBorder, '
        'secondaryFocusedBorder: $secondaryFocusedBorder, '
        'secondaryErrorBorder: $secondaryErrorBorder, '
        'labelStyle: $labelStyle, '
        'errorLabelStyle: $errorLabelStyle, '
        'errorStyle: $errorStyle, '
        'descriptionStyle: $descriptionStyle, '
        'labelPadding: $labelPadding, '
        'descriptionPadding: $descriptionPadding, '
        'errorPadding: $errorPadding, '
        'fallbackToBorder: $fallbackToBorder, '
        'color: $color, '
        'image: $image, '
        'shadows: $shadows, '
        'gradient: $gradient, '
        'backgroundBlendMode: $backgroundBlendMode, '
        'shape: $shape, '
        'hasError: $hasError, '
        'fallbackToLabelStyle: $fallbackToLabelStyle, '
        'disableSecondaryBorder: $disableSecondaryBorder'
        ')';
  }
}

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
        MyDecoration(border: Border.all(color: theme.colorScheme.border));

    final hasError = effectiveDecoration.hasError ?? false;

    final effectiveFallbackToLabelStyle =
        effectiveDecoration.fallbackToLabelStyle ?? true;

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

    var effectiveLabelStyle = switch (hasError) {
      true => effectiveDecoration.errorLabelStyle,
      false => effectiveDecoration.labelStyle,
    };

    if (effectiveFallbackToLabelStyle && effectiveLabelStyle == null) {
      effectiveLabelStyle =
          effectiveDecoration.labelStyle ??
          switch (hasError) {
            true => defaultErrorStyle,
            false => defaultLabelStyle,
          };
    }

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
            child: DefaultTextStyle(style: effectiveLabelStyle!, child: label!),
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
