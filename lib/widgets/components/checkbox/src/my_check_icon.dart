library;

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../index.dart';


part 'my_check_icon_base.dart';

///
/// A shaped checkbox which nicely animates changes to its value.
///
class MyCheckboxIcon extends StatefulWidget {
  const MyCheckboxIcon({
    required this.value,
    required this.colors,
    super.key,
    this.disabled = false,
    this.size = 18,
    this.duration,
    this.style = MyCheckboxStyle.stroke,
    this.shape = MyCheckboxShape.circle,
    this.borderRadius,
  });

  final bool value;
  final bool disabled;
  final MyCheckboxColors colors;
  final double size;
  final Duration? duration;
  final MyCheckboxStyle style;
  final MyCheckboxShape shape;
  final BorderRadius? borderRadius;

  @override
  State<MyCheckboxIcon> createState() => _MSHCheckboxState();
}

class _MSHCheckboxState extends State<MyCheckboxIcon>
    with SingleTickerProviderStateMixin {
  double get _strokeWidth => 3.5 * (widget.size / 60);

  late final animationController = AnimationController(
    vsync: this,
    duration: duration,
  );

  Duration get duration {
    return widget.duration ??
        switch (widget.style) {
          MyCheckboxStyle.stroke => const Duration(milliseconds: 500),
          MyCheckboxStyle.fillScaleColor => const Duration(milliseconds: 400),
          MyCheckboxStyle.fillScaleCheck => const Duration(milliseconds: 500),
          MyCheckboxStyle.fillFade => const Duration(milliseconds: 300),
        };
  }

  @override
  void initState() {
    super.initState();
    if (widget.value) animationController.value = 1;
  }

  @override
  void didUpdateWidget(covariant MyCheckboxIcon oldWidget) {
    super.didUpdateWidget(oldWidget);

    animationController.duration = duration;

    if (widget.value != oldWidget.value) {
      if (widget.value) {
        unawaited(animationController.forward());
      } else {
        unawaited(animationController.reverse());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final BorderRadius? radius =
        widget.shape == MyCheckboxShape.circle
            ? null
            : widget.borderRadius ?? MyBorderRadius.small;

    final state = MyCheckboxIconState(
      context: context,
      disabled: widget.disabled,
      style: widget.style,
    );

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: widget.size + _strokeWidth,
          width: widget.size + _strokeWidth,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: radius,
              shape:
                  widget.shape == MyCheckboxShape.circle
                      ? BoxShape.circle
                      : BoxShape.rectangle,
              border: Border.all(
                color: widget.colors.borderColor(state),
                width: _strokeWidth,
              ),
            ),
          ),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: widget.size,
            minWidth: widget.size,
          ),
          child: _MyCheckboxIconBase(
            context: context,
            style: widget.style,
            disabled: widget.disabled,
            colors: widget.colors,
            animation: animationController,
            strokeWidth: _strokeWidth,
            size: widget.size,
            shape: widget.shape,
            borderRadius: radius,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    animationController.dispose();

    super.dispose();
  }
}
