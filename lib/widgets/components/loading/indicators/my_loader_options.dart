import 'package:flutter/material.dart';

enum MyLoaderSize {
  extraSmall(16),
  small(24),
  medium(32),
  large(48),
  extraLarge(64);

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
    this.strokeWidth,
    this.strokeCap,
  });

  final Color? color;
  final MyLoaderSize size;
  final Duration duration;
  final Color? backgroundColor;
  final Color? secondaryColor;
  final Color? tertiaryColor;
  final double? strokeWidth;
  final StrokeCap? strokeCap;

  MyLoaderOptions copyWith({
    Color? color,
    MyLoaderSize? size,
    Duration? duration,
    Color? backgroundColor,
    Color? secondaryColor,
    Color? tertiaryColor,
    double? strokeWidth,
    StrokeCap? strokeCap,
  }) {
    return MyLoaderOptions(
      color: color ?? this.color,
      size: size ?? this.size,
      duration: duration ?? this.duration,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      tertiaryColor: tertiaryColor ?? this.tertiaryColor,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      strokeCap: strokeCap ?? this.strokeCap,
    );
  }
}
