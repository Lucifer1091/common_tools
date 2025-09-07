import 'package:flutter/material.dart';
import 'dart:math' as math;

class TailChaseLoader extends StatefulWidget {
  @override
  _TailChaseLoaderState createState() => _TailChaseLoaderState();
}

class _TailChaseLoaderState extends State<TailChaseLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
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
              size: Size(50, 50),
              painter: TailChasePainter(_controller.value),
            );
          },
        ),
      ),
    );
  }
}

class TailChasePainter extends CustomPainter {
  final double animationValue;
  TailChasePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint dotPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final double radius = size.width / 2;
    final int numDots = 6;
    final double angleStep = (2 * math.pi) / numDots;

    for (int i = 0; i < numDots; i++) {
      double angle = (animationValue * 2 * math.pi) - (i * angleStep);
      double x = size.width / 2 + radius * 0.7 * math.cos(angle);
      double y = size.height / 2 + radius * 0.7 * math.sin(angle);
      canvas.drawCircle(Offset(x, y), 4, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
