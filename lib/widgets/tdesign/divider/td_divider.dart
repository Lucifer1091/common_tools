import 'package:flutter/material.dart';

import '../../../common_tools.dart';
import '../text/td_text.dart';
import 'dashed_widget.dart';

enum TextAlignment { left, center, right }

class TDDivider extends StatelessWidget {
  const TDDivider({
    super.key,
    this.color,
    this.margin,
    this.width,
    this.height,
    this.text,
    this.textStyle,
    this.widget,
    this.gapPadding,
    this.hideLine = false,
    this.isDashed = false,
    this.alignment = TextAlignment.center,
    this.direction = Axis.horizontal,
  });

  final Color? color;

  final TextAlignment alignment;

  final EdgeInsetsGeometry? margin;

  final EdgeInsetsGeometry? gapPadding;

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
      return _buildLine(
        context,
        width: width,
        height: height,
        margin: margin,
        color: color,
      );
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

  Widget _buildDivider(BuildContext context, TextAlignment alignment) {
    switch (alignment) {
      case TextAlignment.left:
        return Container(
          width: width,
          margin: margin,
          child: Row(
            children: [
              _buildLine(
                context,
                width: 16,
                height: height ?? 0.5,
                color: color ?? ThemeColors.neutral.shade200,
              ),
              Padding(
                padding: gapPadding ?? const EdgeInsets.only(left: 8, right: 8),
                child: _buildMiddleWidget(context),
              ),
              Expanded(
                child: Center(
                  child: _buildLine(
                    context,
                    height: height ?? 0.5,
                    color: color ?? ThemeColors.neutral.shade200,
                  ),
                ),
              ),
            ],
          ),
        );
      case TextAlignment.center:
        return Container(
          width: width,
          margin: margin,
          child: Row(
            children: [
              Expanded(
                child: Center(
                  child: _buildLine(
                    context,
                    height: height ?? 0.5,
                    color: color ?? ThemeColors.neutral.shade200,
                  ),
                ),
              ),
              Padding(
                padding: gapPadding ?? const EdgeInsets.only(left: 8, right: 8),
                child: _buildMiddleWidget(context),
              ),
              Expanded(
                child: Center(
                  child: _buildLine(
                    context,
                    height: height ?? 0.5,
                    color: color ?? ThemeColors.neutral.shade200,
                  ),
                ),
              ),
            ],
          ),
        );
      case TextAlignment.right:
        return Container(
          width: width,
          margin: margin,
          child: Row(
            children: [
              Expanded(
                child: Center(
                  child: _buildLine(
                    context,
                    height: height ?? 0.5,
                    color: color ?? ThemeColors.neutral.shade200,
                  ),
                ),
              ),
              Padding(
                padding: gapPadding ?? const EdgeInsets.only(left: 8, right: 8),
                child: _buildMiddleWidget(context),
              ),
              _buildLine(
                context,
                width: 16,
                height: height ?? 0.5,
                color: color ?? ThemeColors.neutral.shade200,
              ),
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
          color: color ?? ThemeColors.neutral.shade200,
          direction: direction,
        ),
      );
    } else {
      return Container(
        width: width,
        height: height ?? 0.5,
        margin: margin,
        color: color ?? ThemeColors.neutral.shade200,
      );
    }
  }

  Widget _buildMiddleWidget(BuildContext context) {
    return widget ??
        TDText(
          text,
          textColor: ThemeColors.neutral.shade700,
          style: (textStyle ?? context.bodySmall)?.copyWith(
            color: ThemeColors.neutral.shade700,
          ),
        );
  }
}
