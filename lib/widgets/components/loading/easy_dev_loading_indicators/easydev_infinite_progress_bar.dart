import 'dart:async';

import 'package:flutter/widgets.dart';

import '../../../../index.dart';

/// Infinite progress bar for indicating ongoing tasks or processes.
/// Its appearence can be customized with use of provided fields.
///
///
/// Example of using [EasyDevInfiniteProgressBar].
/// ```dart
/// EasyDevInfiniteProgressBar(
///   width: 202,
/// ),
/// ```
///
///
/// This sample produces variant of EasyDevInfiniteProgressBar.
///
/// See code in easydev_base_ui/example/lib/dartpad_examples/easydev_infinite_progress_bar_example.dart
class EasyDevInfiniteProgressBar extends StatefulWidget {
  /// Create infinite progress bar.
  const EasyDevInfiniteProgressBar({
    super.key,
    this.color,
    this.trackColor,
    this.padding = const EdgeInsets.all(16),
    this.width,
  });

  /// Color of the moving part of this indicator.
  final Color? color;

  /// Color of the track of this indicator.
  final Color? trackColor;

  /// Outer insets of this indicator.
  final EdgeInsets padding;

  /// Width of this indicator.
  final double? width;

  @override
  State<EasyDevInfiniteProgressBar> createState() =>
      _EasyDevInfiniteProgressBarState();
}

class _EasyDevInfiniteProgressBarState extends State<EasyDevInfiniteProgressBar>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 750),
            upperBound: 1.5,
          )
          ..forward()
          ..addStatusListener((status) async {
            if (status == AnimationStatus.completed) {
              await Future.delayed(const Duration(milliseconds: 1000));
              if (mounted) {
                unawaited(_controller.forward(from: 0));
              }
            }
          });
  }

  Color _getColor(BuildContext context) {
    return widget.color ?? context.colorScheme.primary;
  }

  Color _getTrackColor(BuildContext context) {
    return widget.trackColor ?? context.colorScheme.muted;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: AnimatedBuilder(
        animation: Tween<double>(
          begin: 0,
          end: 1.5,
        ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear)),
        builder: (context, _) {
          return Row(
            children: [
              Expanded(
                child: Container(
                  height: 8,
                  margin: widget.padding,
                  child: CustomPaint(
                    painter: InfiniteProgressBarPainter(
                      _getColor(context),
                      _getTrackColor(context),
                      _controller.value,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

/// Paints indicator with part with [trackColor]
/// in the [position].
class InfiniteProgressBarPainter extends CustomPainter {
  InfiniteProgressBarPainter(this.color, this.trackColor, this.position);

  final Color color;
  final Color trackColor;
  final double position;

  @override
  void paint(Canvas canvas, Size size) {
    final trackPainter =
        Paint()
          ..color = trackColor
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 8;

    final linePainter =
        Paint()
          ..color = color
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 8;

    const start = Offset(0, 4);
    final end = Offset(size.width, 4);

    canvas.drawLine(start, end, trackPainter);
    if (position <= 0.5 && position != 0) {
      canvas.drawLine(start, Offset(size.width * position, 4), linePainter);
    }
    if (position > 0.5 && position < 1) {
      canvas.drawLine(
        Offset(size.width * (position - 0.5), 4),
        Offset(size.width * position, 4),
        linePainter,
      );
    }
    if (position >= 1 && position != 1.5) {
      canvas.drawLine(
        Offset(size.width - ((1.5 - position) * size.width), 4),
        end,
        linePainter,
      );
    }
  }

  @override
  bool shouldRepaint(InfiniteProgressBarPainter oldDelegate) {
    return color != oldDelegate.color ||
        trackColor != oldDelegate.trackColor ||
        position != oldDelegate.position;
  }
}
