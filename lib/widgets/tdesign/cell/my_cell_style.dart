import 'package:flutter/material.dart';

import '../../../index.dart';

class MyCellStyle {
  MyCellStyle({
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
    this.hoverColor,
    this.groupTitleStyle,
    this.padding,
    this.cardBorderRadius,
    this.cardPadding,
    this.titlePadding,
    this.titleBackgroundColor,
  }) {
    if (context != null) defaultStyle(context!);
  }

  MyCellStyle.style(BuildContext context) {
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

  Color? hoverColor;

  TextStyle? groupTitleStyle;

  EdgeInsets? padding;

  BorderRadius? cardBorderRadius;

  EdgeInsets? cardPadding;

  EdgeInsets? titlePadding;

  Color? titleBackgroundColor;

  void defaultStyle(BuildContext context) {
    backgroundColor = context.colorScheme.background;
    hoverColor = context.colorScheme.muted.scaleAlpha(0.8);
    leftIconColor = context.colorScheme.primary;
    rightIconColor = context.colorScheme.primary;
    titleStyle = context.bodyLarge.copyWith(
      color: context.colorScheme.foreground,
    );
    requiredStyle = titleStyle?.copyWith(
      color: context.colorScheme.destructive,
    );
    descriptionStyle = context.bodyMedium.copyWith(
      color: context.colorScheme.mutedForeground,
    );
    noteStyle = titleStyle!.copyWith(
      color: context.colorScheme.mutedForeground,
    );
    arrowColor = context.colorScheme.mutedForeground;
    groupBorderedColor = context.colorScheme.border;
    borderedColor = context.colorScheme.border;
    groupTitleStyle = context.titleLarge.copyWith(
      color: context.colorScheme.foreground,
      fontWeight: FontWeight.w600,
    );
    padding = const EdgeInsets.all(16);
    cardBorderRadius = MyBorderRadius.large;
    cardPadding = const EdgeInsets.only(left: 16, right: 16);
    titlePadding = const EdgeInsets.only(
      left: 16,
      right: 16,
      top: 24,
      bottom: 8,
    );
    titleBackgroundColor = const Color.fromARGB(0, 184, 157, 157);
  }

  MyCellStyle copyWith({
    BuildContext? context,
    Color? leftIconColor,
    Color? rightIconColor,
    TextStyle? titleStyle,
    TextStyle? requiredStyle,
    TextStyle? descriptionStyle,
    TextStyle? noteStyle,
    Color? arrowColor,
    Color? borderedColor,
    Color? groupBorderedColor,
    Color? backgroundColor,
    Color? hoverColor,
    TextStyle? groupTitleStyle,
    EdgeInsets? padding,
    BorderRadius? cardBorderRadius,
    EdgeInsets? cardPadding,
    EdgeInsets? titlePadding,
    Color? titleBackgroundColor,
  }) {
    return MyCellStyle(
      context: context ?? this.context,
      leftIconColor: leftIconColor ?? this.leftIconColor,
      rightIconColor: rightIconColor ?? this.rightIconColor,
      titleStyle: titleStyle ?? this.titleStyle,
      requiredStyle: requiredStyle ?? this.requiredStyle,
      descriptionStyle: descriptionStyle ?? this.descriptionStyle,
      noteStyle: noteStyle ?? this.noteStyle,
      arrowColor: arrowColor ?? this.arrowColor,
      borderedColor: borderedColor ?? this.borderedColor,
      groupBorderedColor: groupBorderedColor ?? this.groupBorderedColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      hoverColor: hoverColor ?? this.hoverColor,
      groupTitleStyle: groupTitleStyle ?? this.groupTitleStyle,
      padding: padding ?? this.padding,
      cardBorderRadius: cardBorderRadius ?? this.cardBorderRadius,
      cardPadding: cardPadding ?? this.cardPadding,
      titlePadding: titlePadding ?? this.titlePadding,
      titleBackgroundColor: titleBackgroundColor ?? this.titleBackgroundColor,
    );
  }
}
