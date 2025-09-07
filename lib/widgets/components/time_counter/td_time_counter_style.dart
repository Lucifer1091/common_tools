import 'package:flutter/material.dart';

import '../../../index.dart';
import '../../../extensions/context/index.dart';

enum TDTimeCounterDirection { down, up }

enum TDTimeCounterSize { small, medium, large }

enum TDTimeCounterTheme { defaultTheme, round, square }

class TDTimeCounterStyle {
  TDTimeCounterStyle({
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

  TDTimeCounterStyle.generateStyle(
    BuildContext context, {
    TDTimeCounterSize? size,
    TDTimeCounterTheme? theme,
    bool? splitWithUnit,
  }) {
    late TextStyle? font;
    switch (size ?? TDTimeCounterSize.medium) {
      case TDTimeCounterSize.small:
        if (theme == TDTimeCounterTheme.defaultTheme) {
          timeWidth = timeHeight = null;
          font = context.bodyMedium;
          timeFontSize = splitFontSize = font?.fontSize ?? 14;
          timeFontHeight =
              splitFontHeight = font?.height ?? (22 / timeFontSize!);
        } else {
          timeWidth = timeHeight = 20;
          font = context.bodySmall;
          timeFontSize = splitFontSize = font?.fontSize ?? 12;
          timeFontHeight = splitFontHeight = null;
        }
        space = 2;
      case TDTimeCounterSize.medium:
        if (theme == TDTimeCounterTheme.defaultTheme) {
          timeWidth = timeHeight = null;
          font = context.bodyLarge;
          timeFontSize = splitFontSize = font?.fontSize ?? 16;
          timeFontHeight =
              splitFontHeight = font?.height ?? (24 / timeFontSize!);
        } else {
          timeWidth = timeHeight = 24;
          font = context.bodyMedium;
          timeFontSize = splitFontSize = font?.fontSize ?? 14;
          timeFontHeight = splitFontHeight = null;
        }
        space = 4;
      case TDTimeCounterSize.large:
        if (theme == TDTimeCounterTheme.defaultTheme) {
          timeWidth = timeHeight = null;
          font = context.titleSmall;
          timeFontSize = splitFontSize = font?.fontSize ?? 18;
          timeFontHeight =
              splitFontHeight = font?.height ?? (26 / timeFontSize!);
        } else {
          timeWidth = timeHeight = 28;
          font = context.bodyLarge;
          timeFontSize = splitFontSize = font?.fontSize ?? 16;
          timeFontHeight = splitFontHeight = null;
        }
        space = 6;
    }

    switch (theme ?? TDTimeCounterTheme.defaultTheme) {
      case TDTimeCounterTheme.round:
        timeBox = BoxDecoration(
          shape: BoxShape.circle,
          color: ThemeColors.error.shade500,
        );
        timeColor = Colors.white;
        splitColor = ThemeColors.error.shade500;
      case TDTimeCounterTheme.square:
        timeBox = BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          color: ThemeColors.error.shade500,
        );
        timeColor = Colors.white;
        splitColor = ThemeColors.error.shade500;
      case TDTimeCounterTheme.defaultTheme:
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
