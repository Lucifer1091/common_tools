import 'package:flutter/material.dart';

import '../../../index.dart';

enum MyTimeCounterDirection { down, up }

enum MyTimeCounterSize { small, medium, large }

enum MyTimeCounterTheme { defaultTheme, round, square }

class MyTimeCounterStyle {
  MyTimeCounterStyle({
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.decoration,
    this.fontSize,
    this.fontHeight,
    this.fontWeight,
    this.color,
    this.splitFontSize,
    this.splitFontHeight,
    this.splitFontWeight,
    this.splitColor,
    this.space,
  });

  MyTimeCounterStyle.generateStyle(
    BuildContext context, {
    MyTimeCounterSize? size,
    MyTimeCounterTheme? theme,
    bool? splitWithUnit,
  }) {
    late TextStyle? font;
    switch (size ?? MyTimeCounterSize.medium) {
      case MyTimeCounterSize.small:
        if (theme == MyTimeCounterTheme.defaultTheme) {
          width = height = null;
          font = context.bodyMedium;
          fontSize = splitFontSize = font.fontSize ?? 14;
          fontHeight = splitFontHeight = font.height ?? (22 / fontSize!);
        } else {
          width = height = 20;
          font = context.bodySmall;
          fontSize = splitFontSize = font.fontSize ?? 12;
          fontHeight = splitFontHeight = null;
        }
        space = 2;
      case MyTimeCounterSize.medium:
        if (theme == MyTimeCounterTheme.defaultTheme) {
          width = height = null;
          font = context.bodyLarge;
          fontSize = splitFontSize = font.fontSize ?? 16;
          fontHeight = splitFontHeight = font.height ?? (24 / fontSize!);
        } else {
          width = height = 24;
          font = context.bodyMedium;
          fontSize = splitFontSize = font.fontSize ?? 14;
          fontHeight = splitFontHeight = null;
        }
        space = 4;
      case MyTimeCounterSize.large:
        if (theme == MyTimeCounterTheme.defaultTheme) {
          width = height = null;
          font = context.titleSmall;
          fontSize = splitFontSize = font.fontSize ?? 18;
          fontHeight = splitFontHeight = font.height ?? (26 / fontSize!);
        } else {
          width = height = 28;
          font = context.bodyLarge;
          fontSize = splitFontSize = font.fontSize ?? 16;
          fontHeight = splitFontHeight = null;
        }
        space = 6;
    }

    switch (theme ?? MyTimeCounterTheme.defaultTheme) {
      case MyTimeCounterTheme.round:
        decoration = BoxDecoration(
          shape: BoxShape.circle,
          color: context.colorScheme.destructive,
        );
        color = context.colorScheme.destructiveForeground;
        splitColor = context.colorScheme.destructive;
      case MyTimeCounterTheme.square:
        decoration = BoxDecoration(
          borderRadius: MyBorderRadius.small,
          color: context.colorScheme.destructive,
        );
        color = context.colorScheme.destructiveForeground;
        splitColor = context.colorScheme.destructive;
      case MyTimeCounterTheme.defaultTheme:
        decoration = null;
        color = splitColor = context.colorScheme.foreground;
        width = null;
        height = null;
    }

    if (splitWithUnit ?? false) {
      splitColor = context.colorScheme.mutedForeground;
    }
  }

  double? width;
  double? height;
  EdgeInsets? padding;
  EdgeInsets? margin;
  BoxDecoration? decoration;
  double? fontSize;
  double? fontHeight;
  FontWeight? fontWeight;
  Color? color;
  double? splitFontSize;
  double? splitFontHeight;
  FontWeight? splitFontWeight;
  Color? splitColor;
  double? space;
}
