import 'package:flutter/material.dart';

import '../../../index.dart';

enum MyTextAlignment { left, center, right }

enum MyDividerType { solid, dotted, dashed, wavy }

class MyDivider extends StatelessWidget {
  const MyDivider({
    super.key,
    this.color,
    this.margin,
    this.width,
    this.height,
    this.text,
    this.textStyle,
    this.widget,
    this.gap,
    this.hideLine = false,
    this.isDashed = false,
    this.alignment = MyTextAlignment.center,
    this.direction = Axis.horizontal,
  });

  final Color? color;

  final MyTextAlignment alignment;

  final EdgeInsets? margin;

  final EdgeInsets? gap;

  final double? width;

  final double? height;

  final String? text;

  final TextStyle? textStyle;

  final Widget? widget;

  final bool hideLine;

  final bool isDashed;

  final Axis direction;

  @override
  Widget build(BuildContext context) {
    if (widget == null && text == null) {
      return _buildLine(context, width: width, height: height, margin: margin);
    }

    if (hideLine) {
      return Container(
        width: width,
        height: height,
        margin: margin,
        child: _buildMiddleWidget(context),
      );
    }

    return _buildDivider(context, alignment);
  }

  Widget _buildDivider(BuildContext context, MyTextAlignment alignment) {
    switch (alignment) {
      case MyTextAlignment.left:
        return Container(
          width: width,
          margin: margin,
          child: Row(
            children: [
              _buildLine(context, width: 16, height: height ?? 0.5),
              Padding(
                padding: gap ?? const EdgeInsets.only(left: 8, right: 8),
                child: _buildMiddleWidget(context),
              ),
              Expanded(
                child: Center(
                  child: _buildLine(context, height: height ?? 0.5),
                ),
              ),
            ],
          ),
        );
      case MyTextAlignment.center:
        return Container(
          width: width,
          margin: margin,
          child: Row(
            children: [
              Expanded(
                child: Center(
                  child: _buildLine(context, height: height ?? 0.5),
                ),
              ),
              Padding(
                padding: gap ?? const EdgeInsets.only(left: 8, right: 8),
                child: _buildMiddleWidget(context),
              ),
              Expanded(
                child: Center(
                  child: _buildLine(context, height: height ?? 0.5),
                ),
              ),
            ],
          ),
        );
      case MyTextAlignment.right:
        return Container(
          width: width,
          margin: margin,
          child: Row(
            children: [
              Expanded(
                child: Center(
                  child: _buildLine(context, height: height ?? 0.5),
                ),
              ),
              Padding(
                padding: gap ?? const EdgeInsets.only(left: 8, right: 8),
                child: _buildMiddleWidget(context),
              ),
              _buildLine(context, width: 16, height: height ?? 0.5),
            ],
          ),
        );
    }
  }

  Container _buildLine(
    BuildContext context, {
    double? width,
    double? height,
    EdgeInsetsGeometry? margin,
    Color? color,
  }) {
    if (isDashed) {
      return Container(
        width: width,
        margin: margin,
        child: DashedWidget(
          width: width,
          height: height,
          color: color ?? context.colorScheme.border,
          direction: direction,
        ),
      );
    } else {
      return Container(
        width: width,
        height: height ?? 0.5,
        margin: margin,
        color: color ?? context.colorScheme.border,
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
