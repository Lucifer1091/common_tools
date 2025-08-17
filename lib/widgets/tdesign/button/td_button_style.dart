import 'package:flutter/material.dart';

import '../../../index.dart';

class MyButtonStyle {
  MyButtonStyle({
    this.backgroundColor,
    this.borderColor,
    this.textColor,
    this.borderWidth,
    this.radius,
  });

  MyButtonStyle.fill(
    BuildContext context,
    MyButtonTheme? theme,
    MyButtonState status,
  ) {
    switch (theme) {
      case MyButtonTheme.primary:
        textColor = ThemeColors.neutral.shade900;
        backgroundColor = _getBrandColor(context, status);
      case MyButtonTheme.danger:
        textColor = ThemeColors.neutral.shade900;
        backgroundColor = _getErrorColor(context, status);
      case MyButtonTheme.light:
        textColor = _getBrandColor(context, status);
        backgroundColor = _getLightColor(context, status);
      case MyButtonTheme.defaults:
      case null:
        textColor = _getDefaultTextColor(context, status);
        backgroundColor = _getDefaultBgColor(context, status);
    }
    borderColor = backgroundColor;
  }

  MyButtonStyle.outline(
    BuildContext context,
    MyButtonTheme? theme,
    MyButtonState status,
  ) {
    switch (theme) {
      case MyButtonTheme.primary:
        textColor = _getBrandColor(context, status);
        backgroundColor =
            status == MyButtonState.pressed
                ? ThemeColors.neutral.shade200
                : Colors.white;
        borderColor = textColor;
      case MyButtonTheme.danger:
        textColor = _getErrorColor(context, status);
        backgroundColor =
            status == MyButtonState.pressed
                ? ThemeColors.neutral.shade200
                : Colors.white;
        borderColor = textColor;
      case MyButtonTheme.light:
        textColor = _getBrandColor(context, status);
        backgroundColor = _getLightColor(context, status);
        borderColor = textColor;
      case MyButtonTheme.defaults:
      case null:
        textColor = _getDefaultTextColor(context, status);
        backgroundColor = _getOutlineDefaultBgColor(context, status);
        borderColor = ThemeColors.neutral.shade300;
    }
    borderWidth = 1;
  }

  MyButtonStyle.text(
    BuildContext context,
    MyButtonTheme? theme,
    MyButtonState status,
  ) {
    switch (theme) {
      case MyButtonTheme.primary:
        textColor = _getBrandColor(context, status);
        backgroundColor =
            status == MyButtonState.pressed
                ? ThemeColors.neutral.shade200
                : Colors.transparent;
      case MyButtonTheme.danger:
        textColor = _getErrorColor(context, status);
        backgroundColor =
            status == MyButtonState.pressed
                ? ThemeColors.neutral.shade200
                : Colors.transparent;
      case MyButtonTheme.light:
        textColor = _getBrandColor(context, status);
        backgroundColor =
            status == MyButtonState.pressed
                ? ThemeColors.neutral.shade200
                : Colors.transparent;
      case MyButtonTheme.defaults:
      case null:
        textColor = _getDefaultTextColor(context, status);
        backgroundColor =
            status == MyButtonState.pressed
                ? ThemeColors.neutral.shade200
                : Colors.transparent;
    }
    borderColor = backgroundColor;
  }

  MyButtonStyle.ghost(
    BuildContext context,
    MyButtonTheme? theme,
    MyButtonState status,
  ) {
    switch (theme) {
      case MyButtonTheme.primary:
        textColor =
            status == MyButtonState.disabled
                ? ThemeColors.neutral.shade600
                : _getBrandColor(context, status);
      case MyButtonTheme.danger:
        textColor =
            status == MyButtonState.disabled
                ? ThemeColors.neutral.shade600
                : _getErrorColor(context, status);
      case MyButtonTheme.light:
        textColor =
            status == MyButtonState.disabled
                ? ThemeColors.neutral.shade600
                : _getBrandColor(context, status);
      case MyButtonTheme.defaults:
      case null:
        switch (status) {
          case MyButtonState.pressed:
            textColor = ThemeColors.neutral.shade800;
          case MyButtonState.disabled:
            textColor = ThemeColors.neutral.shade600;
          case MyButtonState.defaults:
            textColor = ThemeColors.neutral.shade900;
        }
    }
    backgroundColor = Colors.transparent;
    borderColor = textColor;
    borderWidth = 1;
  }

  Color? backgroundColor;

  Color? borderColor;

  Color? textColor;

  double? borderWidth;

  BorderRadiusGeometry? radius;

  Color _getBrandColor(BuildContext context, MyButtonState status) {
    switch (status) {
      case MyButtonState.defaults:
        return ThemeColors.blue.shade600;
      case MyButtonState.pressed:
        return ThemeColors.blue.shade700;
      case MyButtonState.disabled:
        return ThemeColors.blue.shade200;
    }
  }

  Color _getLightColor(BuildContext context, MyButtonState status) {
    switch (status) {
      case MyButtonState.defaults:
      case MyButtonState.disabled:
        return ThemeColors.blue.shade50;
      case MyButtonState.pressed:
        return ThemeColors.blue.shade100;
    }
  }

  Color _getErrorColor(BuildContext context, MyButtonState status) {
    switch (status) {
      case MyButtonState.defaults:
        return ThemeColors.error.shade500;
      case MyButtonState.pressed:
        return ThemeColors.error.shade600;
      case MyButtonState.disabled:
        return ThemeColors.error.shade200;
    }
  }

  Color _getDefaultBgColor(BuildContext context, MyButtonState status) {
    switch (status) {
      case MyButtonState.defaults:
        return ThemeColors.neutral.shade200;
      case MyButtonState.pressed:
        return ThemeColors.neutral.shade400;
      case MyButtonState.disabled:
        return ThemeColors.neutral.shade100;
    }
  }

  Color _getDefaultTextColor(BuildContext context, MyButtonState status) {
    switch (status) {
      case MyButtonState.defaults:
      case MyButtonState.pressed:
        return ThemeColors.neutral.shade900;
      case MyButtonState.disabled:
        return ThemeColors.neutral.shade600;
    }
  }

  Color _getOutlineDefaultBgColor(BuildContext context, MyButtonState status) {
    switch (status) {
      case MyButtonState.defaults:
        return Colors.white;
      case MyButtonState.pressed:
        return ThemeColors.neutral.shade200;
      case MyButtonState.disabled:
        return ThemeColors.neutral.shade100;
    }
  }
}
