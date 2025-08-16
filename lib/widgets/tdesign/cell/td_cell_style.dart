import 'package:flutter/material.dart';

import '../../../index.dart';

class TDCellStyle {
  TDCellStyle({
    this.context,
    this.leftIconColor,
    this.rightIconColor,
    this.titleStyle,
    this.requiredStyle,
    this.descriptionStyle,
    this.noteStyle,
    this.arrowColor,
    this.borderedColor,
    this.groupBorderedColor,
    this.backgroundColor,
    this.clickBackgroundColor,
    this.groupTitleStyle,
    this.padding,
    this.cardBorderRadius,
    this.cardPadding,
    this.titlePadding,
    this.titleBackgroundColor,
  }) {
    if (context != null) defaultStyle(context!);
  }

  TDCellStyle.cellStyle(BuildContext context) {
    defaultStyle(context);
  }

  BuildContext? context;

  Color? leftIconColor;

  Color? rightIconColor;

  TextStyle? titleStyle;

  TextStyle? requiredStyle;

  TextStyle? descriptionStyle;

  TextStyle? noteStyle;

  Color? arrowColor;

  Color? borderedColor;

  Color? groupBorderedColor;

  Color? backgroundColor;

  Color? clickBackgroundColor;

  TextStyle? groupTitleStyle;

  EdgeInsets? padding;

  BorderRadius? cardBorderRadius;

  EdgeInsets? cardPadding;

  EdgeInsets? titlePadding;

  Color? titleBackgroundColor;

  void defaultStyle(BuildContext context) {
    backgroundColor = Colors.white;
    clickBackgroundColor = ThemeColors.neutral.shade50;
    leftIconColor = ThemeColors.blue.shade600;
    rightIconColor = ThemeColors.blue.shade600;
    titleStyle = TextStyle(
      color: ThemeColors.neutral.shade900,
      fontSize: context.bodyLarge?.fontSize ?? 16,
      height: context.bodyLarge?.height ?? 24,
      fontWeight: FontWeight.w400,
    );
    requiredStyle = titleStyle?.copyWith(color: ThemeColors.error.shade500);
    descriptionStyle = TextStyle(
      color: ThemeColors.neutral.shade800,
      fontSize: context.bodyMedium?.fontSize ?? 14,
      height: context.bodyMedium?.height ?? 22,
      fontWeight: FontWeight.w400,
    );
    noteStyle = titleStyle!.copyWith(color: ThemeColors.neutral.shade700);
    arrowColor = ThemeColors.neutral.shade700;
    groupBorderedColor = ThemeColors.neutral.shade200;
    borderedColor = ThemeColors.neutral.shade200;
    groupTitleStyle = TextStyle(
      color: ThemeColors.neutral.shade900,
      fontSize: context.titleLarge?.fontSize ?? 18,
      height: context.titleLarge?.height ?? 26,
      fontWeight: context.titleLarge?.fontWeight ?? FontWeight.w600,
    );
    padding = const EdgeInsets.all(16);
    cardBorderRadius = BorderRadius.all(Radius.circular(9));
    cardPadding = const EdgeInsets.only(left: 16, right: 16);
    titlePadding = const EdgeInsets.only(
      left: 16,
      right: 16,
      top: 24,
      bottom: 8,
    );
    titleBackgroundColor = const Color.fromARGB(0, 184, 157, 157);
  }
}
