import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../../index.dart';

enum IndicatorType { small, medium, large }

/// Circular loading indicator, which spins to indicate that
/// the application is busy.
///
/// The [stops] parameter determines the stops for creating a sweep gradient,
/// while [lineWidth] controls the width of the [CircularLoadingIndicator].
/// The [size] parameter specifies the diameter of the [CircularLoadingIndicator],
/// and [duration] determines the speed of the animation.
/// Pre-built constructors are provided with preset values for small, medium, and large indicators,
/// offering convenience for common use cases.
///
///
/// Example of using [CircularLoadingIndicator].
/// ```dart
/// Column(
///   children:[
///     CircularLoadingIndicator.small(),
///     CircularLoadingIndicator.medium(),
///     CircularLoadingIndicator.large(),
///     CircularLoadingIndicator(
///       stops: const [0, 1],
///       lineWidth: 18,
///       size: 120,
///       duration: const Duration(
///       milliseconds: 1200,
///       ),
///     ),
///   ],
/// ),
/// ```
///
///
/// This sample produces variants of CircularLoadingIndicator.
///
/// See code in easydev_base_ui/example/lib/dartpad_examples/easydev_circular_loading_indicator_example.dart
class CircularLoadingIndicator extends StatefulWidget {
  /// Create circular loading indicator.
  const CircularLoadingIndicator({
    super.key,
    this.stops,
    this.lineWidth,
    this.size,
    this.duration = const Duration(milliseconds: 2000),
    this.type = IndicatorType.medium,
    this.color,
  });

  /// List of stops for creating sweep gradient using [SweepGradient].
  ///
  /// [SweepGradient] determined by [color] and surfaceColor that comes
  /// from theme.
  ///
  /// Length of stops must be equal to two and values in it
  /// must be between 0 and 1.
  final List<double>? stops;

  /// Width of this indicator.
  final double? lineWidth;

  /// Diameter of this circular indicator.
  final double? size;

  /// Duration that determines speed of this indicator.
  final Duration duration;

  /// Type of indicators for with presets.
  final IndicatorType type;

  /// Color of this indicator.
  final Color? color;

  @override
  State<CircularLoadingIndicator> createState() =>
      _CircularLoadingIndicatorState();
}

class _CircularLoadingIndicatorState extends State<CircularLoadingIndicator>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
  }

  @override
  void didUpdateWidget(covariant CircularLoadingIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.duration != oldWidget.duration) {
      _controller.duration = widget.duration;
      _controller.repeat();
    }
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: Tween<double>(begin: 0, end: 1).animate(_controller),
      child: Center(
        child: Transform.scale(
          scaleX: -1,
          child: CustomPaint(
            size: Size.square(widget.size ?? _getIndicatorSize(widget.type)),
            painter: CircularLoadingIndicatorPainter(
              color: _getColor(context),
              surfaceColor: context.colorScheme.secondary,
              stops: widget.stops ?? _getIndicatorStops(widget.type),
              lineWidth:
                  widget.lineWidth ?? _getIndicatorLineWidth(widget.type),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getColor(BuildContext context) {
    return widget.color ?? context.colorScheme.primary;
  }

  List<double> _getIndicatorStops(IndicatorType type) {
    switch (type) {
      case IndicatorType.small:
        return [0, 0.8];
      case IndicatorType.medium:
        return [0, 0.7];
      case IndicatorType.large:
        return [0, 1];
    }
  }

  double _getIndicatorLineWidth(IndicatorType type) {
    switch (type) {
      case IndicatorType.small:
        return 2;
      case IndicatorType.medium:
        return 4;
      case IndicatorType.large:
        return 18;
    }
  }

  double _getIndicatorSize(IndicatorType type) {
    switch (type) {
      case IndicatorType.small:
        return 18;
      case IndicatorType.medium:
        return 40;
      case IndicatorType.large:
        return 120;
    }
  }
}

/// Paints circle with rounded edges with width equals to [lineWidth]
/// and [SweepGradient] determined by [color], [surfaceColor] and [stops].
class CircularLoadingIndicatorPainter extends CustomPainter {
  CircularLoadingIndicatorPainter({
    required this.color,
    required this.surfaceColor,
    required this.stops,
    required this.lineWidth,
  });

  final Color color;
  final Color surfaceColor;
  final List<double> stops;
  final double lineWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final xCenter = size.width * 0.5;
    final yCenter = size.height * 0.5;
    final center = Offset(xCenter, yCenter);

    final Paint paint =
        Paint()
          ..color = color
          ..strokeCap = StrokeCap.round
          ..strokeWidth = lineWidth
          ..style = PaintingStyle.stroke
          ..shader = SweepGradient(
            colors: [color, surfaceColor],
            stops: stops,
          ).createShader(Rect.fromCircle(center: center, radius: 0));

    canvas.drawArc(
      Rect.fromCenter(
        center: center,
        width: size.width - lineWidth,
        height: size.height - lineWidth,
      ),
      0.12 * pi,
      1.76 * pi,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CircularLoadingIndicatorPainter oldDelegate) {
    return color != oldDelegate.color ||
        stops != oldDelegate.stops ||
        lineWidth != oldDelegate.lineWidth;
  }
}
