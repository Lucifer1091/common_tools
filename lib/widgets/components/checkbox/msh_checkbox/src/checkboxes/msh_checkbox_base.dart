import 'package:flutter/material.dart';

import '../../../index.dart';

class MSHCheckboxBase extends StatelessWidget {
  final Animation<double> animation;
  final BuildContext context;
  final MSHCheckboxStyle style;
  final MSHColorConfig colorConfig;
  final bool isDisabled;
  final double size;
  final double strokeWidth;

  MSHCheckboxState get state => MSHCheckboxState(
        context: context,
        isDisabled: isDisabled,
        style: style,
      );

  const MSHCheckboxBase({
    Key? key,
    required this.animation,
    required this.colorConfig,
    required this.context,
    required this.isDisabled,
    required this.size,
    required this.strokeWidth,
    required this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (style) {
      case MSHCheckboxStyle.stroke:
        return StrokeCheckbox(parent: this);
      case MSHCheckboxStyle.fillScaleColor:
        return FillScaleColorCheckbox(parent: this);
      case MSHCheckboxStyle.fillScaleCheck:
        return FillScaleCheckCheckbox(parent: this);
      case MSHCheckboxStyle.fillFade:
        return FillFadeCheckbox(parent: this);
    }
  }

  Color fillColor() => colorConfig.fillColor(state);

  Color checkColor() => colorConfig.checkColor(state);

  Color tintColor() => colorConfig.tintColor(state);
}
