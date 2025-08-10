import 'package:flutter/material.dart';

import '../button/td_button.dart';
import '../button/td_button_style.dart';

export 'td_alert_dialog.dart';
export 'td_confirm_dialog.dart';
export 'td_image_dialog.dart';
export 'td_input_dialog.dart';

/// Dialog Button Styles
///
/// Used to configure button styles at the Dialog level.
/// Supports configurable styles for each button within the Dialog.
enum TDDialogButtonStyle { normal, text }

class TDDialogButtonOptions {
  TDDialogButtonOptions({
    required this.title,
    required this.action,
    this.titleColor,
    this.titleSize,
    this.style,
    this.type,
    this.theme,
    this.height,
    this.fontWeight,
  });

  final String title;

  Color? titleColor;

  final double? titleSize;

  final FontWeight? fontWeight;

  /// Button Style
  /// Setting the style of a single button will override the default style of the Dialog
  final TDButtonStyle? style;

  final TDButtonType? type;

  final TDButtonTheme? theme;

  final double? height;

  final VoidCallback? action;
}
