import 'package:flutter/material.dart';

import '../../../index.dart';
import 'td_button.dart';

class TDButtonStyle {
  TDButtonStyle({
    this.backgroundColor,
    this.borderColor,
    this.textColor,
    this.borderWidth,
    this.radius,
  });

  TDButtonStyle.fill(
    BuildContext context,
    TDButtonTheme? theme,
    TDButtonStatus status,
  ) {
    switch (theme) {
      case TDButtonTheme.primary:
        textColor = ThemeColors.neutral.shade900;
        backgroundColor = _getBrandColor(context, status);
      case TDButtonTheme.danger:
        textColor = ThemeColors.neutral.shade900;
        backgroundColor = _getErrorColor(context, status);
      case TDButtonTheme.light:
        textColor = _getBrandColor(context, status);
        backgroundColor = _getLightColor(context, status);
      case TDButtonTheme.defaultTheme:
      case null:
        textColor = _getDefaultTextColor(context, status);
        backgroundColor = _getDefaultBgColor(context, status);
    }
    borderColor = backgroundColor;
  }

  TDButtonStyle.outline(
    BuildContext context,
    TDButtonTheme? theme,
    TDButtonStatus status,
  ) {
    switch (theme) {
      case TDButtonTheme.primary:
        textColor = _getBrandColor(context, status);
        backgroundColor =
            status == TDButtonStatus.active
                ? ThemeColors.neutral.shade200
                : Colors.white;
        borderColor = textColor;
      case TDButtonTheme.danger:
        textColor = _getErrorColor(context, status);
        backgroundColor =
            status == TDButtonStatus.active
                ? ThemeColors.neutral.shade200
                : Colors.white;
        borderColor = textColor;
      case TDButtonTheme.light:
        textColor = _getBrandColor(context, status);
        backgroundColor = _getLightColor(context, status);
        borderColor = textColor;
      case TDButtonTheme.defaultTheme:
      case null:
        textColor = _getDefaultTextColor(context, status);
        backgroundColor = _getOutlineDefaultBgColor(context, status);
        borderColor = ThemeColors.neutral.shade300;
    }
    borderWidth = 1;
  }

  TDButtonStyle.text(
    BuildContext context,
    TDButtonTheme? theme,
    TDButtonStatus status,
  ) {
    switch (theme) {
      case TDButtonTheme.primary:
        textColor = _getBrandColor(context, status);
        backgroundColor =
            status == TDButtonStatus.active
                ? ThemeColors.neutral.shade200
                : Colors.transparent;
      case TDButtonTheme.danger:
        textColor = _getErrorColor(context, status);
        backgroundColor =
            status == TDButtonStatus.active
                ? ThemeColors.neutral.shade200
                : Colors.transparent;
      case TDButtonTheme.light:
        textColor = _getBrandColor(context, status);
        backgroundColor =
            status == TDButtonStatus.active
                ? ThemeColors.neutral.shade200
                : Colors.transparent;
      case TDButtonTheme.defaultTheme:
      case null:
        textColor = _getDefaultTextColor(context, status);
        backgroundColor =
            status == TDButtonStatus.active
                ? ThemeColors.neutral.shade200
                : Colors.transparent;
    }
    borderColor = backgroundColor;
  }

  TDButtonStyle.ghost(
    BuildContext context,
    TDButtonTheme? theme,
    TDButtonStatus status,
  ) {
    switch (theme) {
      case TDButtonTheme.primary:
        textColor =
            status == TDButtonStatus.disable
                ? ThemeColors.neutral.shade600
                : _getBrandColor(context, status);
      case TDButtonTheme.danger:
        textColor =
            status == TDButtonStatus.disable
                ? ThemeColors.neutral.shade600
                : _getErrorColor(context, status);
      case TDButtonTheme.light:
        textColor =
            status == TDButtonStatus.disable
                ? ThemeColors.neutral.shade600
                : _getBrandColor(context, status);
      case TDButtonTheme.defaultTheme:
      case null:
        switch (status) {
          case TDButtonStatus.active:
            textColor = ThemeColors.neutral.shade800;
          case TDButtonStatus.disable:
            textColor = ThemeColors.neutral.shade600;
          case TDButtonStatus.defaultState:
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

  Color _getBrandColor(BuildContext context, TDButtonStatus status) {
    switch (status) {
      case TDButtonStatus.defaultState:
        return ThemeColors.blue.shade600;
      case TDButtonStatus.active:
        return ThemeColors.blue.shade700;
      case TDButtonStatus.disable:
        return ThemeColors.blue.shade200;
    }
  }

  Color _getLightColor(BuildContext context, TDButtonStatus status) {
    switch (status) {
      case TDButtonStatus.defaultState:
      case TDButtonStatus.disable:
        return ThemeColors.blue.shade50;
      case TDButtonStatus.active:
        return ThemeColors.blue.shade100;
    }
  }

  Color _getErrorColor(BuildContext context, TDButtonStatus status) {
    switch (status) {
      case TDButtonStatus.defaultState:
        return ThemeColors.error.shade500;
      case TDButtonStatus.active:
        return ThemeColors.error.shade600;
      case TDButtonStatus.disable:
        return ThemeColors.error.shade200;
    }
  }

  Color _getDefaultBgColor(BuildContext context, TDButtonStatus status) {
    switch (status) {
      case TDButtonStatus.defaultState:
        return ThemeColors.neutral.shade200;
      case TDButtonStatus.active:
        return ThemeColors.neutral.shade400;
      case TDButtonStatus.disable:
        return ThemeColors.neutral.shade100;
    }
  }

  Color _getDefaultTextColor(BuildContext context, TDButtonStatus status) {
    switch (status) {
      case TDButtonStatus.defaultState:
      case TDButtonStatus.active:
        return ThemeColors.neutral.shade900;
      case TDButtonStatus.disable:
        return ThemeColors.neutral.shade600;
    }
  }

  Color _getOutlineDefaultBgColor(BuildContext context, TDButtonStatus status) {
    switch (status) {
      case TDButtonStatus.defaultState:
        return Colors.white;
      case TDButtonStatus.active:
        return ThemeColors.neutral.shade200;
      case TDButtonStatus.disable:
        return ThemeColors.neutral.shade100;
    }
  }
}
