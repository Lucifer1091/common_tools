import 'package:flutter/material.dart';

import 'my_steps_horizontal.dart';
import 'my_steps_vertical.dart';

class MyStepItem {
  MyStepItem({
    this.title,
    this.content,
    this.successIcon,
    this.errorIcon,
    this.customContent,
    this.customTitle,
  }) : assert(
         title != null ||
             customTitle != null ||
             content != null ||
             customContent != null,
         'At least one of title, customTitle, content, or customContent must be non-null',
       );

  final String? title;
  final String? content;
  final IconData? successIcon;
  final IconData? errorIcon;
  final Widget? customContent;
  final Widget? customTitle;
}

enum MyStepsDirection { horizontal, vertical }

enum MyStepsStatus { success, error }

class MySteps extends StatefulWidget {
  const MySteps({
    required this.steps,
    super.key,
    this.activeIndex = 0,
    this.direction = MyStepsDirection.horizontal,
    this.status = MyStepsStatus.success,
    this.simple = false,
    this.readOnly = false,
    this.verticalSelect = false,
  });

  final int activeIndex;
  final List<MyStepItem> steps;
  final MyStepsDirection direction;
  final MyStepsStatus status;
  final bool simple;
  final bool readOnly;
  final bool verticalSelect;

  @override
  _MyStepsState createState() => _MyStepsState();
}

class _MyStepsState extends State<MySteps> {
  @override
  Widget build(BuildContext context) {
    final currentActiveIndex =
        widget.activeIndex < 0
            ? 0
            : (widget.activeIndex >= widget.steps.length
                ? widget.steps.length - 1
                : widget.activeIndex);

    return widget.direction == MyStepsDirection.horizontal
        ? MyStepsHorizontal(
          steps: widget.steps,
          activeIndex: currentActiveIndex,
          status: widget.status,
          simple: widget.simple,
          readOnly: widget.readOnly,
        )
        : MyStepsVertical(
          steps: widget.steps,
          activeIndex: currentActiveIndex,
          status: widget.status,
          simple: widget.simple,
          readOnly: widget.readOnly,
          verticalSelect: widget.verticalSelect,
        );
  }
}
