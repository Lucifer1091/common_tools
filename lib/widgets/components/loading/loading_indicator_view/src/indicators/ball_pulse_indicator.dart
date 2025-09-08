import 'dart:math';

import 'package:flutter/material.dart';

import '../infinite_progress.dart';

class BallPulseIndicator extends StatefulWidget {
  const BallPulseIndicator({
    super.key,
    this.minRadius = 2.4,
    this.maxRadius = 7.2,
    this.spacing = 3,
    this.ballColor = Colors.white,
    this.duration = const Duration(milliseconds: 400),
  });

  final double minRadius;
  final double maxRadius;
  final double spacing;
  final Color ballColor;
  final Duration duration;

  @override
  State<StatefulWidget> createState() => _BallPulseIndicatorState();
}

class _BallPulseIndicatorState extends State<BallPulseIndicator>
    with SingleTickerProviderStateMixin, InfiniteProgressMixin {
  @override
  void initState() {
    startEngine(this, widget.duration);
    super.initState();
  }

  @override
  void dispose() {
    closeEngine();
    super.dispose();
  }

  @override
  Size measureSize() {
    final width = widget.maxRadius * 2 * 3 + widget.spacing * 2;
    final height = widget.maxRadius * 2;
    return Size(width, height);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return CustomPaint(
          size: measureSize(),
          painter: _BallPulseIndicatorPainter(
            animationValue: animationValue,
            minRadius: widget.minRadius,
            maxRadius: widget.maxRadius,
            spacing: widget.spacing,
            ballColor: widget.ballColor,
          ),
        );
      },
    );
  }
}

double _progress = .0;
double _lastExtent = .0;

class _BallPulseIndicatorPainter extends CustomPainter {
  _BallPulseIndicatorPainter({
    required this.animationValue,
    required this.minRadius,
    required this.maxRadius,
    required this.spacing,
    required this.ballColor,
  }) : radiusList = <double>[
         minRadius + (maxRadius - minRadius) * 0.9,
         minRadius + (maxRadius - minRadius) * 0.6,
         minRadius + (maxRadius - minRadius) * 0.3,
       ];

  final double animationValue;
  final double minRadius;
  final double maxRadius;
  final double spacing;
  final Color ballColor;
  final List<double> radiusList;

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..isAntiAlias = true
          ..style = PaintingStyle.fill
          ..color = ballColor
          ..strokeJoin = StrokeJoin.round
          ..strokeCap = StrokeCap.round;

    _progress += (_lastExtent - animationValue).abs();
    _lastExtent = animationValue;
    if (_progress >= double.maxFinite) {
      _progress = .0;
      _lastExtent = .0;
    }

    final diffRadius = maxRadius - minRadius;
    for (int i = 0; i < radiusList.length; i++) {
      final dx = maxRadius + 2 * i * maxRadius + i * spacing;
      final offset = Offset(dx, maxRadius);

      final offsetExtent = asin((radiusList[i] - minRadius) / diffRadius);
      final scaleRadius =
          sin(_progress * pi / 180 + offsetExtent).abs() * diffRadius +
          minRadius;
      canvas.drawCircle(offset, scaleRadius, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
