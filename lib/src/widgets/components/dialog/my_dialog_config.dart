import 'package:flutter/material.dart';

import '../button/my_button.dart';
import '../button/my_button_style.dart';

class MyDialogButtonOptions {
  MyDialogButtonOptions({
    required this.title,
    this.action,
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
  final MyButtonStyle? style;
  final MyButtonType? type;
  final double? height;
  final VoidCallback? action;
}
