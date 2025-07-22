import 'package:flutter/material.dart';

import '../../../common_tools.dart';

enum TDNoticeBarTheme { info, success, warning, error }

class TDNoticeBarStyle {
  TDNoticeBarStyle({
    this.context,
    this.backgroundColor,
    this.textStyle,
    this.leftIconColor,
    this.rightIconColor,
    this.padding,
  });

  TDNoticeBarStyle.generateTheme({
    TDNoticeBarTheme? theme = TDNoticeBarTheme.info,
  }) {
    rightIconColor = ThemeColors.neutral.shade600;

    switch (theme) {
      case TDNoticeBarTheme.warning:
        leftIconColor = ThemeColors.warning.shade400;
        backgroundColor = ThemeColors.warning.shade50;
      case TDNoticeBarTheme.error:
        leftIconColor = ThemeColors.error.shade500;
        backgroundColor = ThemeColors.error.shade50;
      case TDNoticeBarTheme.success:
        leftIconColor = ThemeColors.success.shade400;
        backgroundColor = ThemeColors.success.shade50;
      case TDNoticeBarTheme.info:
      case null:
        leftIconColor = ThemeColors.blue.shade600;
        backgroundColor = ThemeColors.blue.shade50;
    }
  }

  BuildContext? context;

  Color? backgroundColor;

  Color? leftIconColor;

  Color? rightIconColor;

  EdgeInsetsGeometry? padding;

  TextStyle? textStyle;

  EdgeInsetsGeometry get getPadding =>
      padding ??
      const EdgeInsets.only(top: 13, bottom: 13, left: 16, right: 12);

  TextStyle get getTextStyle =>
      textStyle ??
      TextStyle(
        color: ThemeColors.neutral.shade900,
        fontSize: 14,
        height: 1,
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.normal,
      );
}
