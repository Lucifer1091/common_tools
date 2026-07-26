import 'package:flutter/widgets.dart';

import './my_border.dart';

@immutable
class MyDecoration {
  const MyDecoration({
    this._canMerge = true,
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
  });

  // Internal flag for merge semantics.
  final bool _canMerge;
  bool get canMerge => _canMerge;

  static const MyDecoration none = MyDecoration(
    canMerge: false,
    border: MyBorder.none,
    focusedBorder: MyBorder.none,
    errorBorder: MyBorder.none,
    secondaryBorder: MyBorder.none,
    secondaryFocusedBorder: MyBorder.none,
    secondaryErrorBorder: MyBorder.none,
  );

  final TextStyle? labelStyle;
  final TextStyle? errorLabelStyle;
  final MyBorder? border;
  final MyBorder? focusedBorder;
  final MyBorder? errorBorder;
  final MyBorder? secondaryBorder;
  final MyBorder? secondaryFocusedBorder;
  final MyBorder? secondaryErrorBorder;
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

  /// Whether to fallback to [border] if no [focusedBorder]/[errorBorder] provided.
  /// Also applies to secondary borders.
  final bool? fallbackToBorder;

  /// Whether to fallback to [labelStyle] if no [errorLabelStyle] provided.
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
      border: MyBorder.lerp(a?.border, b?.border, t),
      focusedBorder: MyBorder.lerp(a?.focusedBorder, b?.focusedBorder, t),
      errorBorder: MyBorder.lerp(a?.errorBorder, b?.errorBorder, t),
      secondaryBorder: MyBorder.lerp(a?.secondaryBorder, b?.secondaryBorder, t),
      secondaryFocusedBorder: MyBorder.lerp(
        a?.secondaryFocusedBorder,
        b?.secondaryFocusedBorder,
        t,
      ),
      secondaryErrorBorder: MyBorder.lerp(
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
      // Keep list/enum-ish fields simple to avoid unintended mutations.
      shadows: t < 0.5 ? a?.shadows : b?.shadows,
      gradient: Gradient.lerp(a?.gradient, b?.gradient, t),
      backgroundBlendMode: t < 0.5
          ? a?.backgroundBlendMode
          : b?.backgroundBlendMode,
      shape: t < 0.5 ? a?.shape : b?.shape,
      hasError: t < 0.5 ? a?.hasError : b?.hasError,
      disableSecondaryBorder: t < 0.5
          ? a?.disableSecondaryBorder
          : b?.disableSecondaryBorder,
      fallbackToBorder: t < 0.5 ? a?.fallbackToBorder : b?.fallbackToBorder,
      fallbackToLabelStyle: t < 0.5
          ? a?.fallbackToLabelStyle
          : b?.fallbackToLabelStyle,
    );
  }

  MyDecoration copyWith({
    TextStyle? labelStyle,
    TextStyle? errorLabelStyle,
    MyBorder? border,
    MyBorder? focusedBorder,
    MyBorder? errorBorder,
    MyBorder? secondaryBorder,
    MyBorder? secondaryFocusedBorder,
    MyBorder? secondaryErrorBorder,
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
    bool? canMerge, // allow overriding the flag as well
  }) {
    return MyDecoration(
      canMerge: canMerge ?? _canMerge,
      labelStyle: labelStyle ?? this.labelStyle,
      errorLabelStyle: errorLabelStyle ?? this.errorLabelStyle,
      border: border ?? this.border,
      focusedBorder: focusedBorder ?? this.focusedBorder,
      errorBorder: errorBorder ?? this.errorBorder,
      secondaryBorder: secondaryBorder ?? this.secondaryBorder,
      secondaryFocusedBorder:
          secondaryFocusedBorder ?? this.secondaryFocusedBorder,
      secondaryErrorBorder: secondaryErrorBorder ?? this.secondaryErrorBorder,
      errorStyle: errorStyle ?? this.errorStyle,
      descriptionStyle: descriptionStyle ?? this.descriptionStyle,
      labelPadding: labelPadding ?? this.labelPadding,
      descriptionPadding: descriptionPadding ?? this.descriptionPadding,
      errorPadding: errorPadding ?? this.errorPadding,
      color: color ?? this.color,
      image: image ?? this.image,
      shadows: shadows ?? this.shadows,
      gradient: gradient ?? this.gradient,
      backgroundBlendMode: backgroundBlendMode ?? this.backgroundBlendMode,
      shape: shape ?? this.shape,
      hasError: hasError ?? this.hasError,
      disableSecondaryBorder:
          disableSecondaryBorder ?? this.disableSecondaryBorder,
      fallbackToBorder: fallbackToBorder ?? this.fallbackToBorder,
      fallbackToLabelStyle: fallbackToLabelStyle ?? this.fallbackToLabelStyle,
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
      border: border?.merge(other.border) ?? other.border,
      focusedBorder:
          focusedBorder?.merge(other.focusedBorder) ?? other.focusedBorder,
      errorBorder: errorBorder?.merge(other.errorBorder) ?? other.errorBorder,
      secondaryBorder:
          secondaryBorder?.merge(other.secondaryBorder) ??
          other.secondaryBorder,
      secondaryFocusedBorder:
          secondaryFocusedBorder?.merge(other.secondaryFocusedBorder) ??
          other.secondaryFocusedBorder,
      secondaryErrorBorder:
          secondaryErrorBorder?.merge(other.secondaryErrorBorder) ??
          other.secondaryErrorBorder,
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
      canMerge: _canMerge, // preserve current's canMerge unless explicitly set
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
        other.fallbackToLabelStyle == fallbackToLabelStyle &&
        other._canMerge == _canMerge;
  }

  @override
  int get hashCode {
    return Object.hashAll([
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
      _canMerge,
    ]);
  }

  @override
  String toString() {
    return 'MyDecoration('
        'border: $border, focusedBorder: $focusedBorder, errorBorder: $errorBorder, '
        'secondaryBorder: $secondaryBorder, secondaryFocusedBorder: $secondaryFocusedBorder, '
        'secondaryErrorBorder: $secondaryErrorBorder, labelStyle: $labelStyle, '
        'errorLabelStyle: $errorLabelStyle, errorStyle: $errorStyle, '
        'descriptionStyle: $descriptionStyle, labelPadding: $labelPadding, '
        'descriptionPadding: $descriptionPadding, errorPadding: $errorPadding, '
        'fallbackToBorder: $fallbackToBorder, color: $color, image: $image, '
        'shadows: $shadows, gradient: $gradient, backgroundBlendMode: $backgroundBlendMode, '
        'shape: $shape, hasError: $hasError, fallbackToLabelStyle: $fallbackToLabelStyle, '
        'disableSecondaryBorder: $disableSecondaryBorder, canMerge: $_canMerge'
        ')';
  }
}
