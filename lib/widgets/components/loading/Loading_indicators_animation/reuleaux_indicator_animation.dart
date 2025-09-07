import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as math;

class ReuleauxLoaderScreen extends StatefulWidget {
  @override
  _ReuleauxLoaderScreenState createState() => _ReuleauxLoaderScreenState();
}

class _ReuleauxLoaderScreenState extends State<ReuleauxLoaderScreen>
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
              painter: ReuleauxLoaderPainter(_controller.value),
            );
          },
        ),
      ),
    );
  }
}

class ReuleauxLoaderPainter extends CustomPainter {
  final double animationValue;
  ReuleauxLoaderPainter(this.animationValue);

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
    double sideLength = size.width - 5;
    double height = (math.sqrt(3) / 2) * sideLength;
    double offsetX = 2.5;
    double offsetY = (size.height - height) / 2;

    path.moveTo(offsetX + sideLength / 2, offsetY);
    path.lineTo(offsetX + sideLength, offsetY + height);
    path.lineTo(offsetX, offsetY + height);
    path.close();

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
