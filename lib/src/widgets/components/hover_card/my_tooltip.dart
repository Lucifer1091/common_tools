import 'package:flutter/material.dart';

import '../../../../extensions/context.dart';

class MyTooltip extends StatelessWidget {
  const MyTooltip({
    required this.child,
    super.key,
    this.message,
    this.richMessage,
    this.height,
    this.padding,
    this.margin,
    this.verticalOffset,
    this.preferBelow,
    this.excludeFromSemantics,
    this.decoration,
    this.textStyle,
    this.textAlign,
    this.waitDuration,
    this.showDuration,
    this.constraints,
    this.cursor,
  });

  final Widget child;
  final String? message;
  final InlineSpan? richMessage;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? verticalOffset;
  final bool? preferBelow;
  final bool? excludeFromSemantics;
  final Decoration? decoration;
  final TextStyle? textStyle;
  final TextAlign? textAlign;
  final Duration? waitDuration;
  final Duration? showDuration;
  final BoxConstraints? constraints;
  final MouseCursor? cursor;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      key: key,
      message: richMessage == null ? message ?? '' : null,
      richMessage: richMessage,
      constraints: constraints,
      mouseCursor: cursor,
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      margin: margin,
      verticalOffset: verticalOffset,
      preferBelow: preferBelow,
      excludeFromSemantics: excludeFromSemantics,
      decoration:
          decoration ??
          BoxDecoration(
            color: context.colorScheme.popover,
            border: Border.all(color: context.colorScheme.border),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(12),
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
          ),
      textStyle:
          textStyle ??
          context.bodySmall.copyWith(
            color: context.colorScheme.popoverForeground,
          ),
      textAlign: textAlign,
      waitDuration: waitDuration,
      showDuration: showDuration ?? const Duration(seconds: 4),
      triggerMode: TooltipTriggerMode.tap,
      child: child,
    );
  }
}
