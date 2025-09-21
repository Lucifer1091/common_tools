import 'dart:math';
import 'dart:ui' show PathMetrics, PathMetric;

import 'package:flutter/material.dart';

class MyArc extends StatelessWidget {
  const MyArc({
    required this.startAngle,
    required this.sweepAngle,
    required this.strokeWidth,
    required this.color,
    super.key,
    this.size = 30,
  });

  final double startAngle;
  final double sweepAngle;
  final double strokeWidth;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ArcPainter(
        startAngle: startAngle,
        sweepAngle: sweepAngle,
        strokeWidth: strokeWidth,
        color: color,
      ),
      size: Size(size, size),
    );
  }
}

class _ArcPainter extends CustomPainter {
  _ArcPainter({
    required this.startAngle,
    required this.sweepAngle,
    required this.strokeWidth,
    required this.color,
  });
  final double startAngle;
  final double sweepAngle;
  final double strokeWidth;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Path path =
        Path()..addArc(Offset.zero & size, startAngle - pi / 2, sweepAngle);

    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class MyRoundShape extends StatelessWidget {
  const MyRoundShape({
    required this.startAngle,
    required this.sweepAngle,
    required this.strokeWidth,
    required this.color,
    super.key,
    this.size = 30,
    this.borderRadius = BorderRadius.zero,
  });

  final double startAngle;
  final double sweepAngle;
  final double strokeWidth;
  final double size;
  final Color color;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ShapePainter(
        startAngle: startAngle,
        sweepAngle: sweepAngle,
        strokeWidth: strokeWidth,
        color: color,
        borderRadius: borderRadius,
      ),
      size: Size(size, size),
    );
  }
}

class _ShapePainter extends CustomPainter {
  _ShapePainter({
    required this.startAngle,
    required this.sweepAngle,
    required this.strokeWidth,
    required this.color,
    required this.borderRadius,
  });

  final double startAngle;
  final double sweepAngle;
  final double strokeWidth;
  final Color color;
  final BorderRadius borderRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint =
        Paint()
          ..color = color
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke;

    final Path path =
        Path()..addRRect(
          RRect.fromRectAndRadius(
            Offset.zero & size,
            Radius.circular(borderRadius.topLeft.x),
          ),
        );

    final PathMetrics pathMetrics = path.computeMetrics();
    final PathMetric pathMetric = pathMetrics.first;

    final Path dashPath = Path();
    final double totalLength = pathMetric.length;
    final double currentLength = totalLength * (sweepAngle / (2 * pi));

    // Adjust start angle to begin from top-right (315 degrees or -45 degrees)
    // Convert angle to path position (0 to 1 ratio)
    final double angleOffset = startAngle % (2 * pi);
    final double startPosition = (angleOffset / (2 * pi)) * totalLength;

    final double endPosition = startPosition + currentLength;

    if (endPosition > totalLength) {
      dashPath
        ..addPath(
          pathMetric.extractPath(startPosition, totalLength),
          Offset.zero,
        )
        ..addPath(
          pathMetric.extractPath(0, endPosition - totalLength),
          Offset.zero,
        );
    } else {
      dashPath.addPath(
        pathMetric.extractPath(startPosition + 0.2, endPosition),
        Offset.zero,
      );
    }

    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
