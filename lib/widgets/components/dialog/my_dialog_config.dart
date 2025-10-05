import 'package:flutter/material.dart';

import '../../../index.dart';

/// Dialog Button Styles
///
/// Used to configure button styles at the Dialog level.
/// Supports configurable styles for each button within the Dialog.
enum MyDialogButtonStyle { normal, text }

class MyDialogButtonOptions {
  MyDialogButtonOptions({
    required this.title,
    required this.action,
    this.titleColor,
    this.titleSize,
    this.style,
    this.type,
    this.height,
    this.fontWeight,
  });

  final String title;

  Color? titleColor;

  final double? titleSize;

  final FontWeight? fontWeight;

  /// Button Style
  /// Setting the style of a single button will override the default style of the Dialog
  final MyButtonStyle? style;

  final MyButtonType? type;

  final double? height;

  final VoidCallback? action;
}
