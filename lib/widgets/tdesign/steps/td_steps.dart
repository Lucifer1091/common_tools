import 'package:flutter/material.dart';

import 'td_steps_horizontal.dart';
import 'td_steps_vertical.dart';

class TDStepsItemData {
  TDStepsItemData({
    this.title,
    this.content,
    this.successIcon,
    this.errorIcon,
    this.customContent,
    this.customTitle,
  }) {
    _validate();
  }

  final String? title;

  final String? content;

  final IconData? successIcon;

  final IconData? errorIcon;

  final Widget? customContent;

  final Widget? customTitle;

  void _validate() {
    if (title == null &&
        customTitle == null &&
        content == null &&
        customContent == null) {
      throw ArgumentError(
        'title, content, customContent needs at least one non-empty value',
      );
    }
  }
}

enum TDStepsDirection { horizontal, vertical }

enum TDStepsStatus { success, error }

class TDSteps extends StatefulWidget {
  const TDSteps({
    required this.steps,
    super.key,
    this.activeIndex = 0,
    this.direction = TDStepsDirection.horizontal,
    this.status = TDStepsStatus.success,
    this.simple = false,
    this.readOnly = false,
    this.verticalSelect = false,
  });

  final List<TDStepsItemData> steps;

  final TDStepsDirection direction;

  final int activeIndex;

  final TDStepsStatus status;

  final bool simple;

  final bool readOnly;

  final bool verticalSelect;

  @override
  _TDStepsState createState() => _TDStepsState();
}

class _TDStepsState extends State<TDSteps> {
  @override
  Widget build(BuildContext context) {
    final currentActiveIndex =
        widget.activeIndex < 0
            ? 0
            : (widget.activeIndex >= widget.steps.length
                ? widget.steps.length - 1
                : widget.activeIndex);
    return widget.direction == TDStepsDirection.horizontal
        ? TDStepsHorizontal(
          steps: widget.steps,
          activeIndex: currentActiveIndex,
          status: widget.status,
          simple: widget.simple,
          readOnly: widget.readOnly,
        )
        : TDStepsVertical(
          steps: widget.steps,
          activeIndex: currentActiveIndex,
          status: widget.status,
          simple: widget.simple,
          readOnly: widget.readOnly,
          verticalSelect: widget.verticalSelect,
        );
  }
}
