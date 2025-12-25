import 'package:flutter/material.dart';

import '../../../index.dart';

enum MyTagTheme { defaults, primary, warning, danger, success }

enum MyTagSize { small, medium, large, extraLarge, custom }

enum MyTagShape { square, round, mark }

class MyTagStyle {
  MyTagStyle({
    required this.context,
    this.textColor,
    this.backgroundColor,
    this.style,
    this.fontWeight,
    this.border = 0,
    this.borderColor,
    this.borderRadius,
  });

  MyTagStyle.generateFillStyleByTheme(
    this.context,
    MyTagTheme? theme,
    MyTagShape shape,
  ) {
    switch (theme) {
      case MyTagTheme.primary:
        textColor = Colors.white;
        backgroundColor = context.colorScheme.primary;
      case MyTagTheme.warning:
        textColor = Colors.white;
        backgroundColor = MyColors.warning;
      case MyTagTheme.danger:
        textColor = Colors.white;
        backgroundColor = context.colorScheme.destructive;
      case MyTagTheme.success:
        textColor = Colors.white;
        backgroundColor = MyColors.success;
      case MyTagTheme.defaults:
      case null:
        textColor = context.colorScheme.secondaryForeground;
        backgroundColor = context.colorScheme.secondary;
    }

    switch (shape) {
      case MyTagShape.square:
        borderRadius = MyBorderRadius.small;
      case MyTagShape.round:
        borderRadius = MyBorderRadius.round;
      case MyTagShape.mark:
        borderRadius = BorderRadius.only(
          topRight: MyRadi.round,
          bottomRight: MyRadi.round,
        );
    }

    borderColor = backgroundColor;
  }

  MyTagStyle.generateOutlineStyleByTheme(
    this.context,
    MyTagTheme? theme,
    MyTagShape shape,
  ) {
    switch (theme) {
      case MyTagTheme.primary:
        borderColor = context.colorScheme.primary;
        textColor = context.colorScheme.primary;
        backgroundColor = context.colorScheme.background;
      case MyTagTheme.warning:
        borderColor = MyColors.warning;
        textColor = MyColors.warning;
        backgroundColor = context.colorScheme.background;
      case MyTagTheme.danger:
        borderColor = context.colorScheme.destructive;
        textColor = context.colorScheme.destructive;
        backgroundColor = context.colorScheme.background;
      case MyTagTheme.success:
        borderColor = MyColors.success;
        textColor = MyColors.success;
        backgroundColor = context.colorScheme.background;
      case MyTagTheme.defaults:
      case null:
        borderColor = context.colorScheme.border;
        textColor = context.colorScheme.foreground;
        backgroundColor = context.colorScheme.background;
    }

    switch (shape) {
      case MyTagShape.square:
        borderRadius = MyBorderRadius.small;
      case MyTagShape.round:
        borderRadius = MyBorderRadius.round;
      case MyTagShape.mark:
        borderRadius = BorderRadius.only(
          topRight: MyRadi.round,
          bottomRight: MyRadi.round,
        );
    }

    border = 1;
  }

  MyTagStyle.generateDisableSelectStyle(
    this.context,
    bool isOutline,
    MyTagShape shape,
  ) {
    borderColor = context.colorScheme.muted;
    textColor = context.colorScheme.mutedForeground;
    backgroundColor = context.colorScheme.muted;

    switch (shape) {
      case MyTagShape.square:
        borderRadius = MyBorderRadius.small;
      case MyTagShape.round:
        borderRadius = MyBorderRadius.round;
      case MyTagShape.mark:
        borderRadius = BorderRadius.only(
          topRight: MyRadi.round,
          bottomRight: MyRadi.round,
        );
    }
    border = isOutline ? 1 : 0;
  }

  BuildContext context;
  Color? textColor;
  Color? backgroundColor;
  Color? borderColor;
  BorderRadiusGeometry? borderRadius;
  TextStyle? style;
  FontWeight? fontWeight;

  double border = 0;

  Color get getTextColor => textColor ?? Colors.white;

  Color get getBackgroundColor =>
      backgroundColor ?? context.colorScheme.primary;

  Color get getBorderColor => borderColor ?? Colors.transparent;

  BorderRadiusGeometry get getBorderRadius =>
      borderRadius ?? BorderRadius.circular(0);
}
