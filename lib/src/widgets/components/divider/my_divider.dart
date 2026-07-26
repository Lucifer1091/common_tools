library;

import 'package:flutter/material.dart';

import '../../../extensions/context/theme.dart';
import '../../../extensions/context/typography.dart';
import '../text/my_text.dart';
part 'dashed_line.dart';
part 'wavy_divider.dart';

enum MyTextAlignment { left, center, right }

enum MyDividerType { solid, dotted, dashed, wavy }

class MyDivider extends StatelessWidget {
  const MyDivider({
    super.key,
    this.thickness,
    this.width,
    this.height,
    this.color,
    this.margin,
    this.text,
    this.textStyle,
    this.widget,
    this.gap,
    this.hideLine = false,
    this.type = MyDividerType.solid,
    this.alignment = MyTextAlignment.center,
    this.direction = Axis.horizontal,
    this.dashLength,
    this.dashSpace,
    this.waveLength,
    this.waveHeight,
  });

  final Color? color;

  final MyTextAlignment alignment;

  final MyDividerType type;

  final EdgeInsetsGeometry? margin;

  /// Gap between the divider and the middle surrounding content.
  final EdgeInsetsGeometry? gap;

  final double? thickness;

  final double? width;

  final double? height;

  final String? text;

  final TextStyle? textStyle;

  final Widget? widget;

  final bool hideLine;

  final Axis direction;

  final double? dashLength;

  final double? dashSpace;

  final double? waveLength;

  final double? waveHeight;

  @override
  Widget build(BuildContext context) {
    if (widget == null && text == null) return _buildLine(context);

    if (hideLine) {
      return Container(
        width: direction == Axis.horizontal ? height : thickness,
        height: direction == Axis.horizontal ? thickness : height,
        margin: margin,
        child: _buildMiddleWidget(context),
      );
    }

    // Handle vertical divider with text or widget
    if (direction == Axis.vertical) {
      return _buildVerticalDividerWithContent(context);
    }

    return _buildDivider(context);
  }

  Widget _buildVerticalDividerWithContent(BuildContext context) {
    final gap = this.gap ?? const EdgeInsets.only(top: 8, bottom: 8);

    final Widget middle = Padding(
      padding: gap,
      child: RotatedBox(
        quarterTurns: widget == null ? 3 : 0,
        child: _buildMiddleWidget(context),
      ),
    );

    switch (alignment) {
      case MyTextAlignment.left:
        // For vertical, "left" means content at the top
        return Column(
          children: [
            _buildLine(context, fixedLength: 16),
            middle,
            Expanded(child: Center(child: _buildLine(context))),
          ],
        );
      case MyTextAlignment.center:
        return Column(
          children: [
            Expanded(child: Center(child: _buildLine(context))),
            middle,
            Expanded(child: Center(child: _buildLine(context))),
          ],
        );
      case MyTextAlignment.right:
        // For vertical, "right" means content at the bottom
        return Column(
          children: [
            Expanded(child: Center(child: _buildLine(context))),
            middle,
            _buildLine(context, fixedLength: 16),
          ],
        );
    }
  }

  Widget _buildDivider(BuildContext context) {
    final gap = this.gap ?? const EdgeInsets.only(left: 8, right: 8);

    final Row? row;

    switch (alignment) {
      case MyTextAlignment.left:
        row = Row(
          children: [
            _buildLine(context, fixedLength: 16),
            Padding(padding: gap, child: _buildMiddleWidget(context)),
            Expanded(child: Center(child: _buildLine(context))),
          ],
        );
      case MyTextAlignment.center:
        row = Row(
          children: [
            Expanded(child: Center(child: _buildLine(context))),
            Padding(padding: gap, child: _buildMiddleWidget(context)),
            Expanded(child: Center(child: _buildLine(context))),
          ],
        );
      case MyTextAlignment.right:
        row = Row(
          children: [
            Expanded(child: Center(child: _buildLine(context))),
            Padding(padding: gap, child: _buildMiddleWidget(context)),
            _buildLine(context, fixedLength: 16),
          ],
        );
    }

    return Container(margin: margin, child: row);
  }

  Widget _buildLine(BuildContext context, {double? fixedLength}) {
    final lineColor = color ?? context.colorScheme.border;
    final horizontal = direction == Axis.horizontal;
    final lineThickness = thickness ?? 0.75;
    final lineLength = fixedLength ?? (horizontal ? null : height);

    switch (type) {
      case MyDividerType.solid:
        return Container(
          width: horizontal ? lineLength : lineThickness,
          height: horizontal ? lineThickness : lineLength ?? double.maxFinite,
          margin: margin,
          color: lineColor,
        );
      case MyDividerType.dotted:
        return Padding(
          padding: margin ?? EdgeInsets.zero,
          child: _DashedLine(
            width: fixedLength ?? width,
            height: horizontal ? height : fixedLength ?? height,
            thickness: lineThickness,
            dashLength: 2,
            dashSpace: 2,
            color: lineColor,
            direction: direction,
          ),
        );
      case MyDividerType.dashed:
        return Padding(
          padding: margin ?? EdgeInsets.zero,
          child: _DashedLine(
            width: fixedLength ?? width,
            height: horizontal ? height : fixedLength ?? height,
            thickness: lineThickness,
            dashLength: dashLength ?? 8,
            dashSpace: dashSpace ?? 3,
            color: lineColor,
            direction: direction,
          ),
        );
      case MyDividerType.wavy:
        return Padding(
          padding: margin ?? EdgeInsets.zero,
          child: _WavyDivider(
            color: lineColor,
            length: horizontal
                ? lineLength ?? width ?? double.infinity
                : fixedLength ?? height,
            thickness: lineThickness,
            direction: direction,
            waveLength: waveLength ?? 20,
            waveHeight: waveHeight ?? 6,
          ),
        );
    }
  }

  Widget _buildMiddleWidget(BuildContext context) {
    return widget ??
        MyText(
          text,
          style:
              textStyle ??
              context.bodySmall.copyWith(
                color: context.colorScheme.mutedForeground,
              ),
        );
  }
}
