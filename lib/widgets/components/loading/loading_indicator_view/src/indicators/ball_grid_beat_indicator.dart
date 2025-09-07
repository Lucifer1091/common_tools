import 'dart:math';

import 'package:flutter/material.dart';

import '../infinite_progress.dart';

class BallGridBeatIndicator extends StatefulWidget {
  const BallGridBeatIndicator({
    super.key,
    this.minAlpha = 51,
    this.maxAlpha = 255,
    this.radius = 7.2,
    this.spacing = 3,
    this.ballColor = Colors.white,
    this.duration = const Duration(milliseconds: 400),
  });

  final int minAlpha;
  final int maxAlpha;
  final double radius;
  final double spacing;
  final Color ballColor;
  final Duration duration;

  @override
  State<StatefulWidget> createState() => _BallGridBeatIndicatorState();
}

class _BallGridBeatIndicatorState extends State<BallGridBeatIndicator>
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
    final size = widget.radius * 2 * 3 + widget.spacing * 2;
    return Size(size, size);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return CustomPaint(
          size: measureSize(),
          painter: _BallGridBeatIndicatorPainter(
            animationValue: animationValue,
            radius: widget.radius,
            minAlpha: widget.minAlpha,
            maxAlpha: widget.maxAlpha,
            spacing: widget.spacing,
            ballColor: widget.ballColor,
          ),
        );
      },
    );
  }
}

double _progress = 0;
double _lastExtent = 0;

class _BallGridBeatIndicatorPainter extends CustomPainter {
  _BallGridBeatIndicatorPainter({
    required this.animationValue,
    required this.radius,
    required this.minAlpha,
    required this.maxAlpha,
    required this.spacing,
    required this.ballColor,
  }) : alphaList = <double>[
         minAlpha + (maxAlpha - minAlpha) * 0.9,
         minAlpha + (maxAlpha - minAlpha) * 0.8,
         minAlpha + (maxAlpha - minAlpha) * 0.7,
         minAlpha + (maxAlpha - minAlpha) * 0.6,
         minAlpha + (maxAlpha - minAlpha) * 0.5,
         minAlpha + (maxAlpha - minAlpha) * 0.4,
         minAlpha + (maxAlpha - minAlpha) * 0.3,
         minAlpha + (maxAlpha - minAlpha) * 0.2,
         minAlpha + (maxAlpha - minAlpha) * 0.1,
       ];

  final double animationValue;
  final double radius;
  final int minAlpha;
  final int maxAlpha;
  final double spacing;
  final Color ballColor;
  final List<double> alphaList;

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..isAntiAlias = true
          ..style = PaintingStyle.fill
          ..strokeJoin = StrokeJoin.round
          ..strokeCap = StrokeCap.round;

    _progress += (_lastExtent - animationValue).abs();
    _lastExtent = animationValue;
    if (_progress >= double.maxFinite) {
      _progress = .0;
      _lastExtent = .0;
    }

    final diffAlpha = maxAlpha - minAlpha;
    for (int i = 0; i < alphaList.length; i++) {
      canvas.save();
      final int row = i ~/ 3;
      final int column = i % 3;

      final dx = radius + 2 * column * radius + column * spacing;
      final dy = (2 * row + 1) * radius + row * spacing;
      final offset = Offset(dx, dy);

      final offsetAlpha = asin((alphaList[i] - minAlpha) / diffAlpha);
      final beatAlpha =
          sin(_progress * pi / 180 + offsetAlpha).abs() * diffAlpha + minAlpha;
      paint.color = Color.fromARGB(
        beatAlpha.round(),
        (ballColor.r * 255.0).round() & 0xff,
        (ballColor.g * 255.0).round() & 0xff,
        (ballColor.b * 255.0).round() & 0xff,
      );

      canvas
        ..drawCircle(offset, radius, paint)
        ..restore();
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
