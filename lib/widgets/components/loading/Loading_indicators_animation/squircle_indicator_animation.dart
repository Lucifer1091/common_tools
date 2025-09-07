import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:math' as math;

class SquircleLoaderScreen extends StatefulWidget {
  @override
  _SquircleLoaderScreenState createState() => _SquircleLoaderScreenState();
}

class _SquircleLoaderScreenState extends State<SquircleLoaderScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              size: Size(40, 40),
              painter: SquircleLoaderPainter(_controller.value),
            );
          },
        ),
      ),
    );
  }
}

class SquircleLoaderPainter extends CustomPainter {
  final double animationValue;
  SquircleLoaderPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint trackPaint = Paint()
      ..color = Colors.black.withOpacity(0.1)
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    final Paint carPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Path path = Path();
    path.moveTo(0.37 * size.width, 0.5 * size.height);
    path.cubicTo(
      0.37 * size.width, 0.15 * size.height,
      0.15 * size.width, 0.37 * size.height,
      0.5 * size.width, 0.37 * size.height,
    );
    path.cubicTo(
      0.85 * size.width, 0.37 * size.height,
      0.63 * size.width, 0.15 * size.height,
      0.63 * size.width, 0.5 * size.height,
    );
    path.cubicTo(
      0.63 * size.width, 0.85 * size.height,
      0.85 * size.width, 0.63 * size.height,
      0.5 * size.width, 0.63 * size.height,
    );
    path.cubicTo(
      0.15 * size.width, 0.63 * size.height,
      0.37 * size.width, 0.85 * size.height,
      0.37 * size.width, 0.5 * size.height,
    );

    canvas.drawPath(path, trackPaint);

    final PathMetric pathMetric = path.computeMetrics().first;
    final double travelDistance = pathMetric.length * animationValue;
    final Tangent? tangent = pathMetric.getTangentForOffset(travelDistance);
    if (tangent != null) {
      canvas.drawCircle(tangent.position, 2, carPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
