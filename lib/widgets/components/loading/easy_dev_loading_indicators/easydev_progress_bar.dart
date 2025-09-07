import 'package:flutter/widgets.dart';

import '../../../../index.dart';
import 'progress_bar_painter.dart';

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
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 8,
            margin: padding,
            child: CustomPaint(
              painter: ProgressBarPainter(
                _getColor(context),
                progressColor ?? context.colorScheme.primary,
                percentage,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
