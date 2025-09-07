import 'dart:math';

import 'package:flutter/material.dart';

import '../infinite_progress.dart';

///
/// author: Vans Z
/// date: 2019-05-31
///

class BallBeatIndicator extends StatefulWidget {
  const BallBeatIndicator({
    super.key,
    this.minAlpha = 51,
    this.maxAlpha = 255,
    this.minRadius = 5.6,
    this.maxRadius = 7.2,
    this.spacing = 3,
    this.ballColor = Colors.white,
    this.duration = const Duration(milliseconds: 400),
  });

  final int minAlpha;
  final int maxAlpha;
  final double minRadius;
  final double maxRadius;
  final double spacing;
  final Color ballColor;
  final Duration duration;

  @override
  State<StatefulWidget> createState() => _BallBeatIndicatorState();
}

class _BallBeatIndicatorState extends State<BallBeatIndicator>
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
          painter: _BallBeatIndicatorPainter(
            animationValue: animationValue,
            minRadius: widget.minRadius,
            maxRadius: widget.maxRadius,
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

double progress = 0;
double lastExtent = 0;

class _BallBeatIndicatorPainter extends CustomPainter {
  _BallBeatIndicatorPainter({
    required this.animationValue,
    required this.minRadius,
    required this.maxRadius,
    required this.minAlpha,
    required this.maxAlpha,
    required this.spacing,
    required this.ballColor,
  }) : alphaList = <double>[
         minAlpha + (maxAlpha - minAlpha) * 0.9,
         minAlpha + (maxAlpha - minAlpha) * 0.1,
         minAlpha + (maxAlpha - minAlpha) * 0.9,
       ],
       radiusList = <double>[
         minRadius + (maxRadius - minRadius) * 0.9,
         minRadius + (maxRadius - minRadius) * 0.63,
         minRadius + (maxRadius - minRadius) * 0.9,
       ];

  final double animationValue;
  final double minRadius;
  final double maxRadius;
  final int minAlpha;
  final int maxAlpha;
  final double spacing;
  final Color ballColor;
  final List<double> alphaList;
  final List<double> radiusList;

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..isAntiAlias = true
          ..style = PaintingStyle.fill
          ..strokeJoin = StrokeJoin.round
          ..strokeCap = StrokeCap.round;

    progress += (lastExtent - animationValue).abs();
    lastExtent = animationValue;
    if (progress >= double.maxFinite) {
      progress = .0;
      lastExtent = .0;
    }

    final diffAlpha = maxAlpha - minAlpha;
    final diffRadius = maxRadius - minRadius;
    for (int i = 0; i < radiusList.length; i++) {
      final offsetAlpha = asin((alphaList[i] - minAlpha) / diffAlpha);
      final beatAlpha =
          sin(progress * pi / 180 + offsetAlpha).abs() * diffAlpha + minAlpha;
      paint.color = Color.fromARGB(
        beatAlpha.round(),
        (ballColor.r * 255.0).round() & 0xff,
        (ballColor.g * 255.0).round() & 0xff,
        (ballColor.b * 255.0).round() & 0xff,
      );

      final dx = maxRadius + 2 * i * maxRadius + i * spacing;
      final offset = Offset(dx, maxRadius);
      final offsetExtent = asin((radiusList[i] - minRadius) / diffRadius);
      final scaleRadius =
          sin(progress * pi / 180 + offsetExtent).abs() * diffRadius +
          minRadius;
      canvas.drawCircle(offset, scaleRadius, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
