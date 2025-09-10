import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../../index.dart';

/// Progress bar used to visualize completion status or progression of tasks.
/// The [percentage] parameter specifies the proportion of the progress bar that
/// should be filled, ranging from 0 to 1. Other fields can be used to customize [EasyDevProgressBar] appearence.
///
/// Example of using [EasyDevProgressBar].
/// ```dart
/// EasyDevProgressBar(
///   percentage: 0.5,
/// ),
/// ```
///
///
/// This sample produces variant of EasyDevProgressBar.
///
/// See code in easydev_base_ui/example/lib/dartpad_examples/easydev_progress_bar_example.dart
class EasyDevProgressBar extends StatelessWidget {
  /// Create progress bar.
  const EasyDevProgressBar({
    required this.percentage,
    super.key,
    this.color,
    this.progressColor,
    this.padding = const EdgeInsets.all(16),
  }) : assert(
         percentage >= 0 && percentage <= 1,
         'Percentage should be equal or more than zero and equal or less than one',
       );

  /// Color for empty part of progress bar.
  final Color? color;

  /// Color for part of progress bar that shows progress.
  final Color? progressColor;

  /// Percentage of indicator that must be filled with [progressColor].
  ///
  /// Must be between zero and one.
  final double percentage;

  /// Outer insets of progress bar.
  final EdgeInsets padding;

  Color _getColor(BuildContext context) {
    return color ?? context.colorScheme.secondary;
  }

  @override
  Widget build(BuildContext context) {
    // return Padding(
    //   padding: const EdgeInsets.all(16),
    //   child: LinearProgressIndicator(
    //     minHeight: 8,
    //     value: value,
    //     borderRadius: BorderRadius.circular(50),
    //     color: context.colorScheme.primary,
    //     backgroundColor: context.colorScheme.secondary,
    //   ),
    // );

    return Container(
      height: 8,
      width: double.maxFinite,
      margin: padding,
      child: CustomPaint(
        painter: ProgressBarPainter(
          _getColor(context),
          progressColor ?? context.colorScheme.primary,
          percentage,
        ),
      ),
    );
  }
}

/// Paints line with rounded edges with a [percentage]
/// of the [progressColor] and the rest of the [color].
class ProgressBarPainter extends CustomPainter {
  const ProgressBarPainter(this.color, this.progressColor, this.percentage);

  final Color color;
  final Color progressColor;
  final double percentage;

  @override
  void paint(Canvas canvas, Size size) {
    final progressPaint =
        Paint()
          ..color = progressColor
          ..strokeWidth = 1;

    final backgroundPaint =
        Paint()
          ..color = color
          ..strokeWidth = 1;

    _paintEmptyLine(canvas, size, backgroundPaint);
    _paintFillLine(canvas, size, progressPaint, percentage);
  }

  @override
  bool shouldRepaint(ProgressBarPainter oldDelegate) {
    return color != oldDelegate.color ||
        progressColor != oldDelegate.progressColor ||
        percentage != oldDelegate.percentage;
  }

  void _paintEmptyLine(Canvas canvas, Size size, Paint paint) {
    final Path path =
        Path()
          ..moveTo(4, 0)
          ..lineTo(size.width - 8, 0)
          ..arcTo(
            Rect.fromLTRB(size.width - 8, 0, size.width, 8),
            3 * pi / 2,
            pi,
            false,
          )
          ..lineTo(8, 8)
          ..arcTo(const Rect.fromLTRB(0, 0, 8, 8), pi / 2, pi, false);
    canvas
      ..drawPath(path, paint)
      ..clipPath(path);
  }

  void _paintFillLine(
    Canvas canvas,
    Size size,
    Paint paint,
    double percentage,
  ) {
    final Path path =
        Path()
          ..moveTo(0, 0)
          ..lineTo(size.width * percentage - 8, 0)
          ..arcTo(
            Rect.fromLTRB(
              size.width * percentage - 8,
              0,
              size.width * percentage,
              8,
            ),
            3 * pi / 2,
            pi,
            false,
          )
          ..lineTo(0, 8);
    canvas.drawPath(path, paint);
  }
}
