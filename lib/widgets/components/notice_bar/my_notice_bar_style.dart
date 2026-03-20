import 'package:flutter/material.dart';

import '../../../index.dart';

enum MyNoticeBarTheme { info, success, warning, error }

class MyNoticeBarStyle {
  MyNoticeBarStyle({
    this.context,
    this.backgroundColor,
    this.textStyle,
    this.leftIconColor,
    this.rightIconColor,
    this.padding,
  });

  MyNoticeBarStyle.generateTheme({
    MyNoticeBarTheme? theme = MyNoticeBarTheme.info,
  }) {
    rightIconColor = ThemeColors.neutral.shade600;

    switch (theme) {
      case MyNoticeBarTheme.warning:
        leftIconColor = MyColors.warning.shade400;
        backgroundColor = MyColors.warning.shade50;
      case MyNoticeBarTheme.error:
        leftIconColor = ThemeColors.error.shade500;
        backgroundColor = ThemeColors.error.shade50;
      case MyNoticeBarTheme.success:
        leftIconColor = ThemeColors.success.shade400;
        backgroundColor = ThemeColors.success.shade50;
      case MyNoticeBarTheme.info:
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
