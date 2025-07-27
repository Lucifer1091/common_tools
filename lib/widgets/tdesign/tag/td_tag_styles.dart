import 'package:flutter/material.dart';

import '../../../common_tools.dart';

enum TDTagTheme { defaultTheme, primary, warning, danger, success }

enum TDTagSize { extraLarge, large, medium, small, custom }

enum TDTagShape { square, round, mark }

class TDTagStyle {
  TDTagStyle({
    this.context,
    this.textColor,
    this.backgroundColor,
    this.style,
    this.fontWeight,
    this.border = 0,
    this.borderColor,
    this.borderRadius,
  });
  TDTagStyle.generateFillStyleByTheme(
    BuildContext this.context,
    TDTagTheme? theme,
    bool light,
    TDTagShape shape,
  ) {
    switch (theme) {
      case TDTagTheme.primary:
        textColor = light ? ThemeColors.blue.shade600 : Colors.white;
        backgroundColor =
            light ? ThemeColors.blue.shade50 : ThemeColors.blue.shade600;
      case TDTagTheme.warning:
        textColor = light ? ThemeColors.warning.shade400 : Colors.white;
        backgroundColor =
            light ? ThemeColors.warning.shade50 : ThemeColors.warning.shade400;
      case TDTagTheme.danger:
        textColor = light ? ThemeColors.error.shade500 : Colors.white;
        backgroundColor =
            light ? ThemeColors.error.shade50 : ThemeColors.error.shade500;
      case TDTagTheme.success:
        textColor = light ? ThemeColors.success.shade400 : Colors.white;
        backgroundColor =
            light ? ThemeColors.success.shade50 : ThemeColors.success.shade400;
      case TDTagTheme.defaultTheme:
      case null:
        textColor = ThemeColors.neutral.shade900;
        backgroundColor =
            light ? ThemeColors.neutral.shade50 : ThemeColors.neutral.shade200;
    }

    switch (shape) {
      case TDTagShape.square:
        borderRadius = BorderRadius.circular(3);
      case TDTagShape.round:
        borderRadius = BorderRadius.circular(9999);
      case TDTagShape.mark:
        borderRadius = BorderRadius.only(
          topRight: Radius.circular(9999),
          bottomRight: Radius.circular(9999),
        );
    }

    borderColor = backgroundColor;
  }

  TDTagStyle.generateOutlineStyleByTheme(
    BuildContext this.context,
    TDTagTheme? theme,
    bool light,
    TDTagShape shape,
  ) {
    switch (theme) {
      case TDTagTheme.primary:
        borderColor = ThemeColors.blue.shade600;
        textColor = ThemeColors.blue.shade600;
        backgroundColor = light ? ThemeColors.blue.shade50 : Colors.white;
      case TDTagTheme.warning:
        borderColor = ThemeColors.warning.shade400;
        textColor = ThemeColors.warning.shade400;
        backgroundColor = light ? ThemeColors.warning.shade50 : Colors.white;
      case TDTagTheme.danger:
        borderColor = ThemeColors.error.shade500;
        textColor = ThemeColors.error.shade500;
        backgroundColor = light ? ThemeColors.error.shade50 : Colors.white;
      case TDTagTheme.success:
        borderColor = ThemeColors.success.shade400;
        textColor = ThemeColors.success.shade400;
        backgroundColor = light ? ThemeColors.success.shade50 : Colors.white;
      case TDTagTheme.defaultTheme:
      case null:
        borderColor = ThemeColors.neutral.shade600;
        textColor = ThemeColors.neutral.shade900;
        backgroundColor = light ? ThemeColors.neutral.shade50 : Colors.white;
    }

    switch (shape) {
      case TDTagShape.square:
        borderRadius = BorderRadius.circular(3);
      case TDTagShape.round:
        borderRadius = BorderRadius.circular(9999);
      case TDTagShape.mark:
        borderRadius = BorderRadius.only(
          topRight: Radius.circular(9999),
          bottomRight: Radius.circular(9999),
        );
    }

    border = 1;
  }

  TDTagStyle.generateDisableSelectStyle(bool isOutline, TDTagShape shape) {
    borderColor = ThemeColors.neutral.shade300;
    textColor = ThemeColors.neutral.shade600;
    backgroundColor = ThemeColors.neutral.shade100;
    switch (shape) {
      case TDTagShape.square:
        borderRadius = BorderRadius.circular(3);
      case TDTagShape.round:
        borderRadius = BorderRadius.circular(9999);
      case TDTagShape.mark:
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
