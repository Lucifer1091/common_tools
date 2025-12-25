import 'package:flutter/material.dart';

import '../../../index.dart';

enum MyTagTheme { defaultTheme, primary, warning, danger, success }

enum MyTagSize { extraLarge, large, medium, small, custom }

enum MyTagShape { square, round, mark }

class MyTagStyle {
  MyTagStyle({
    this.context,
    this.textColor,
    this.backgroundColor,
    this.style,
    this.fontWeight,
    this.border = 0,
    this.borderColor,
    this.borderRadius,
  });
  MyTagStyle.generateFillStyleByTheme(
    BuildContext this.context,
    MyTagTheme? theme,
    bool light,
    MyTagShape shape,
  ) {
    switch (theme) {
      case MyTagTheme.primary:
        textColor = light ? ThemeColors.blue.shade600 : Colors.white;
        backgroundColor =
            light ? ThemeColors.blue.shade50 : ThemeColors.blue.shade600;
      case MyTagTheme.warning:
        textColor = light ? ThemeColors.warning.shade400 : Colors.white;
        backgroundColor =
            light ? ThemeColors.warning.shade50 : ThemeColors.warning.shade400;
      case MyTagTheme.danger:
        textColor = light ? ThemeColors.error.shade500 : Colors.white;
        backgroundColor =
            light ? ThemeColors.error.shade50 : ThemeColors.error.shade500;
      case MyTagTheme.success:
        textColor = light ? ThemeColors.success.shade400 : Colors.white;
        backgroundColor =
            light ? ThemeColors.success.shade50 : ThemeColors.success.shade400;
      case MyTagTheme.defaultTheme:
      case null:
        textColor = ThemeColors.neutral.shade900;
        backgroundColor =
            light ? ThemeColors.neutral.shade50 : ThemeColors.neutral.shade200;
    }

    switch (shape) {
      case MyTagShape.square:
        borderRadius = BorderRadius.circular(3);
      case MyTagShape.round:
        borderRadius = BorderRadius.circular(9999);
      case MyTagShape.mark:
        borderRadius = BorderRadius.only(
          topRight: Radius.circular(9999),
          bottomRight: Radius.circular(9999),
        );
    }

    borderColor = backgroundColor;
  }

  MyTagStyle.generateOutlineStyleByTheme(
    BuildContext this.context,
    MyTagTheme? theme,
    bool light,
    MyTagShape shape,
  ) {
    switch (theme) {
      case MyTagTheme.primary:
        borderColor = ThemeColors.blue.shade600;
        textColor = ThemeColors.blue.shade600;
        backgroundColor = light ? ThemeColors.blue.shade50 : Colors.white;
      case MyTagTheme.warning:
        borderColor = ThemeColors.warning.shade400;
        textColor = ThemeColors.warning.shade400;
        backgroundColor = light ? ThemeColors.warning.shade50 : Colors.white;
      case MyTagTheme.danger:
        borderColor = ThemeColors.error.shade500;
        textColor = ThemeColors.error.shade500;
        backgroundColor = light ? ThemeColors.error.shade50 : Colors.white;
      case MyTagTheme.success:
        borderColor = ThemeColors.success.shade400;
        textColor = ThemeColors.success.shade400;
        backgroundColor = light ? ThemeColors.success.shade50 : Colors.white;
      case MyTagTheme.defaultTheme:
      case null:
        borderColor = ThemeColors.neutral.shade600;
        textColor = ThemeColors.neutral.shade900;
        backgroundColor = light ? ThemeColors.neutral.shade50 : Colors.white;
    }

    switch (shape) {
      case MyTagShape.square:
        borderRadius = BorderRadius.circular(3);
      case MyTagShape.round:
        borderRadius = BorderRadius.circular(9999);
      case MyTagShape.mark:
        borderRadius = BorderRadius.only(
          topRight: Radius.circular(9999),
          bottomRight: Radius.circular(9999),
        );
    }

    border = 1;
  }

  MyTagStyle.generateDisableSelectStyle(bool isOutline, MyTagShape shape) {
    borderColor = ThemeColors.neutral.shade300;
    textColor = ThemeColors.neutral.shade600;
    backgroundColor = ThemeColors.neutral.shade100;
    switch (shape) {
      case MyTagShape.square:
        borderRadius = BorderRadius.circular(3);
      case MyTagShape.round:
        borderRadius = BorderRadius.circular(9999);
      case MyTagShape.mark:
        borderRadius = BorderRadius.only(
          topRight: Radius.circular(9999),
          bottomRight: Radius.circular(9999),
        );
    }
    border = isOutline ? 1 : 0;
  }

  BuildContext? context;
  Color? textColor;
  Color? backgroundColor;
  Color? borderColor;
  BorderRadiusGeometry? borderRadius;
  TextStyle? style;
  FontWeight? fontWeight;

  double border = 0;

  Color get getTextColor => textColor ?? Colors.white;

  Color get getBackgroundColor => backgroundColor ?? ThemeColors.blue.shade600;

  Color get getBorderColor => borderColor ?? Colors.transparent;

  BorderRadiusGeometry get getBorderRadius =>
      borderRadius ?? BorderRadius.circular(0);
}
