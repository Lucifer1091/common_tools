import 'package:flutter/material.dart';

import '../../../extensions/context/theme.dart';
import '../../../extensions/context/typography.dart';
import '../../../themes/my_colors.dart';

enum MyNoticeBarTheme { info, success, warning, error }

class MyNoticeBarStyle {
  MyNoticeBarStyle({
    required this.context,
    this.backgroundColor,
    this.textStyle,
    this.leftIconColor,
    this.rightIconColor,
    this.padding,
  });

  MyNoticeBarStyle.generateTheme({
    required this.context,
    MyNoticeBarTheme? theme = MyNoticeBarTheme.info,
  }) {
    rightIconColor = context.colorScheme.secondaryForeground;

    switch (theme) {
      case MyNoticeBarTheme.warning:
        if (context.colorScheme.brightness == Brightness.dark) {
          leftIconColor = MyColors.warning.shade50;
          backgroundColor = MyColors.warning.shade900;
        } else {
          leftIconColor = MyColors.warning;
          backgroundColor = MyColors.warning.shade50;
        }
      case MyNoticeBarTheme.error:
        if (context.colorScheme.brightness == Brightness.dark) {
          leftIconColor = MyColors.error.shade50;
          backgroundColor = MyColors.error.shade700;
        } else {
          leftIconColor = MyColors.error.shade500;
          backgroundColor = MyColors.error.shade50;
        }
      case MyNoticeBarTheme.success:
        if (context.colorScheme.brightness == Brightness.dark) {
          leftIconColor = MyColors.green.shade50;
          backgroundColor = MyColors.green.shade900;
        } else {
          leftIconColor = MyColors.green.shade600;
          backgroundColor = MyColors.green.shade50;
        }
      case MyNoticeBarTheme.info:
      case null:
        if (context.colorScheme.brightness == Brightness.dark) {
          leftIconColor = MyColors.blue.shade50;
          backgroundColor = MyColors.blue.shade900;
        } else {
          leftIconColor = MyColors.blue;
          backgroundColor = MyColors.blue.shade50;
        }
    }
  }

  BuildContext context;
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
      context.bodyMedium.copyWith(color: context.colorScheme.foreground);
}
