import 'package:flutter/material.dart';
import 'dart:math' as math;

class DotSpinnerLoader extends StatefulWidget {
  @override
  _DotSpinnerLoaderState createState() => _DotSpinnerLoaderState();
}

class _DotSpinnerLoaderState extends State<DotSpinnerLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 900),
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
              painter: DotSpinnerPainter(_controller.value),
            );
          },
        ),
      ),
    );
  }
}

class DotSpinnerPainter extends CustomPainter {
  final double animationValue;
  DotSpinnerPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint dotPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final double radius = size.width / 2;
    final int numDots = 8;
    final double angleStep = (2 * math.pi) / numDots;

    for (int i = 0; i < numDots; i++) {
      double angle = (animationValue * 2 * math.pi) - (i * angleStep);
      double x = size.width / 2 + radius * 0.7 * math.cos(angle);
      double y = size.height / 2 + radius * 0.7 * math.sin(angle);
      double scale = (math.sin(animationValue * 2 * math.pi - (i * angleStep)) + 1) / 2;
      double opacity = (scale * 0.5) + 0.5;

      canvas.drawCircle(
          Offset(x, y),
          4 * scale,
          dotPaint..color = Colors.black.withOpacity(opacity));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
