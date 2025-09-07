import 'package:flutter/material.dart';
import 'dart:math' as math;

class LineSpinnerLoaderScreen extends StatefulWidget {
  @override
  _LineSpinnerLoaderScreenState createState() => _LineSpinnerLoaderScreenState();
}

class _LineSpinnerLoaderScreenState extends State<LineSpinnerLoaderScreen>
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
              painter: LineSpinnerPainter(_controller.value),
            );
          },
        ),
      ),
    );
  }
}

class LineSpinnerPainter extends CustomPainter {
  final double animationValue;
  LineSpinnerPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final int numLines = 12;
    final double radius = size.width / 2;
    final Offset center = Offset(size.width / 2, size.height / 2);

    for (int i = 0; i < numLines; i++) {
      final double angle = (2 * math.pi / numLines) * i;
      final double opacity = (animationValue - (i / numLines)).abs();
      final double lineOpacity = (1 - opacity).clamp(0.0, 1.0);
      final double startX = center.dx + radius * math.cos(angle);
      final double startY = center.dy + radius * math.sin(angle);
      final double endX = center.dx + (radius - 10) * math.cos(angle);
      final double endY = center.dy + (radius - 10) * math.sin(angle);

      paint.color = Colors.black.withOpacity(lineOpacity);
      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
