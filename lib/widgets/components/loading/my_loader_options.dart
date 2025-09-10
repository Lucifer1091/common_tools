import 'package:flutter/material.dart';

enum MyLoaderSize {
  extraSmall(16),
  small(24),
  medium(32),
  large(48),
  extraLarge(64),
  custom(0);

  const MyLoaderSize(this.value);

  final double value;
}

/// Options class for configuring loaders.
///
/// This class defines common configuration options that can be applied
/// to all loader animations in this package.
class MyLoaderOptions {
  const MyLoaderOptions({
    this.color,
    this.size = MyLoaderSize.medium,
    this.duration = const Duration(milliseconds: 1500),
    this.backgroundColor,
    this.secondaryColor,
    this.tertiaryColor,
    this.strokeWidth ,
  });

  /// The primary color of the loader.
  final Color? color;

  /// The size of the loader.
  final MyLoaderSize size;

  /// The animation duration in milliseconds.
  final Duration duration;

  /// The background color of the loader (if applicable).
  final Color? backgroundColor;

  /// Secondary color for loaders that support multiple colors.
  final Color? secondaryColor;

  /// Tertiary color for loaders that support multiple colors.
  final Color? tertiaryColor;

  /// The stroke width for loaders that use strokes (like circle loaders).
  final double? strokeWidth;

  /// Creates a copy of this [MyLoaderOptions] with the given fields replaced by new values.
  MyLoaderOptions copyWith({
    Color? color,
    MyLoaderSize? size,
    Duration? duration,
    Color? backgroundColor,
    Color? secondaryColor,
    Color? tertiaryColor,
    double? strokeWidth,
  }) {
    return MyLoaderOptions(
      color: color ?? this.color,
      size: size ?? this.size,
      duration: duration ?? this.duration,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      tertiaryColor: tertiaryColor ?? this.tertiaryColor,
      strokeWidth: strokeWidth ?? this.strokeWidth,
    );
  }
}
