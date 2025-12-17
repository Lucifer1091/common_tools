import 'package:flutter/material.dart';

import '../../../index.dart';

enum MyTimeCounterDirection { down, up }

enum MyTimeCounterSize { small, medium, large }

enum MyTimeCounterTheme { defaultTheme, round, square }

class MyTimeCounterStyle {
  MyTimeCounterStyle({
    this.timeWidth,
    this.timeHeight,
    this.timePadding,
    this.timeMargin,
    this.timeBox,
    this.timeFontSize,
    this.timeFontHeight,
    this.timeFontWeight,
    this.timeColor,
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
          timeWidth = timeHeight = null;
          font = context.bodyMedium;
          timeFontSize = splitFontSize = font.fontSize ?? 14;
          timeFontHeight =
              splitFontHeight = font.height ?? (22 / timeFontSize!);
        } else {
          timeWidth = timeHeight = 20;
          font = context.bodySmall;
          timeFontSize = splitFontSize = font.fontSize ?? 12;
          timeFontHeight = splitFontHeight = null;
        }
        space = 2;
      case MyTimeCounterSize.medium:
        if (theme == MyTimeCounterTheme.defaultTheme) {
          timeWidth = timeHeight = null;
          font = context.bodyLarge;
          timeFontSize = splitFontSize = font.fontSize ?? 16;
          timeFontHeight =
              splitFontHeight = font.height ?? (24 / timeFontSize!);
        } else {
          timeWidth = timeHeight = 24;
          font = context.bodyMedium;
          timeFontSize = splitFontSize = font.fontSize ?? 14;
          timeFontHeight = splitFontHeight = null;
        }
        space = 4;
      case MyTimeCounterSize.large:
        if (theme == MyTimeCounterTheme.defaultTheme) {
          timeWidth = timeHeight = null;
          font = context.titleSmall;
          timeFontSize = splitFontSize = font.fontSize ?? 18;
          timeFontHeight =
              splitFontHeight = font.height ?? (26 / timeFontSize!);
        } else {
          timeWidth = timeHeight = 28;
          font = context.bodyLarge;
          timeFontSize = splitFontSize = font.fontSize ?? 16;
          timeFontHeight = splitFontHeight = null;
        }
        space = 6;
    }

    switch (theme ?? MyTimeCounterTheme.defaultTheme) {
      case MyTimeCounterTheme.round:
        timeBox = BoxDecoration(
          shape: BoxShape.circle,
          color: ThemeColors.error.shade500,
        );
        timeColor = Colors.white;
        splitColor = ThemeColors.error.shade500;
      case MyTimeCounterTheme.square:
        timeBox = BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          color: ThemeColors.error.shade500,
        );
        timeColor = Colors.white;
        splitColor = ThemeColors.error.shade500;
      case MyTimeCounterTheme.defaultTheme:
        timeBox = null;
        timeColor = splitColor = Colors.white;
        timeWidth = null;
        timeHeight = null;
    }

    if (splitWithUnit ?? false) {
      splitColor = ThemeColors.neutral.shade900;
    }
  }

  double? timeWidth;
  double? timeHeight;
  EdgeInsets? timePadding;
  EdgeInsets? timeMargin;
  BoxDecoration? timeBox;
  double? timeFontSize;
  double? timeFontHeight;
  FontWeight? timeFontWeight;
  Color? timeColor;
  double? splitFontSize;
  double? splitFontHeight;
  FontWeight? splitFontWeight;
  Color? splitColor;
  double? space;
}
