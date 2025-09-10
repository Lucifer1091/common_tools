import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as math;

class SquareLoaderScreen extends StatefulWidget {
  @override
  _SquareLoaderScreenState createState() => _SquareLoaderScreenState();
}

class _SquareLoaderScreenState extends State<SquareLoaderScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
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
              painter: SquareLoaderPainter(_controller.value),
            );
          },
        ),
      ),
    );
  }
}

class SquareLoaderPainter extends CustomPainter {
  final double animationValue;
  SquareLoaderPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint trackPaint =
        Paint()
          ..color = Colors.black.withOpacity(0.1)
          ..strokeWidth = 5
          ..style = PaintingStyle.stroke;

    final Paint carPaint =
        Paint()
          ..color = Colors.black
          ..strokeWidth = 5
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    Path path =
        Path()
          ..moveTo(2.5, 2.5)
          ..lineTo(size.width - 2.5, 2.5)
          ..lineTo(size.width - 2.5, size.height - 2.5)
          ..lineTo(2.5, size.height - 2.5)
          ..close();

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
