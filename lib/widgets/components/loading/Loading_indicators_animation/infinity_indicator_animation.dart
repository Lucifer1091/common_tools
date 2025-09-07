import 'dart:ui';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class InfinityLoader extends StatefulWidget {
  @override
  _InfinityLoaderState createState() => _InfinityLoaderState();
}

class _InfinityLoaderState extends State<InfinityLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2), // Adjust speed
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Center(
          child: CustomPaint(
            size: Size(50, 50), // Size of loader
            painter: InfinityPainter(_controller.value),
          ),
        );
      },
    );
  }
}

class InfinityPainter extends CustomPainter {
  final double progress;
  InfinityPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    Paint trackPaint = Paint()
      ..color = Colors.black.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    Paint movingPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    Path path = Path();
    double w = size.width, h = size.height;
    path.moveTo(w * 0.25, h * 0.5);
    path.cubicTo(w * 0.0, h * 1.0, w * 0.5, h * 1.0, w * 0.5, h * 0.5);
    path.cubicTo(w * 0.5, h * 1.0, w * 1.0, h * 1.0, w * 0.75, h * 0.5);
    path.cubicTo(w * 1.0, h * 0.0, w * 0.5, h * 0.0, w * 0.5, h * 0.5);
    path.cubicTo(w * 0.5, h * 0.0, w * 0.0, h * 0.0, w * 0.25, h * 0.5);

    canvas.drawPath(path, trackPaint);

    PathMetric pathMetric = path.computeMetrics().first;
    double pathLength = pathMetric.length;
    double dashStart = progress * pathLength;
    double dashEnd = dashStart + pathLength * 0.15;

    Path extractedPath = pathMetric.extractPath(dashStart, dashEnd);
    canvas.drawPath(extractedPath, movingPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
