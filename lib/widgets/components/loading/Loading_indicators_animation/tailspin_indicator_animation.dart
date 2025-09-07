import 'package:flutter/material.dart';
import 'dart:math' as math;

class TailspinLoaderScreen extends StatefulWidget {
  @override
  _TailspinLoaderScreenState createState() => _TailspinLoaderScreenState();
}

class _TailspinLoaderScreenState extends State<TailspinLoaderScreen>
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
            return Transform.rotate(
              angle: _controller.value * 2 * math.pi,
              child: CustomPaint(
                size: Size(40, 40),
                painter: TailspinPainter(),
              ),
            );
          },
        ),
      ),
    );
  }
}

class TailspinPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    final double strokeWidth = 5;
    final double radius = (size.width - strokeWidth) / 2;
    final Offset center = Offset(size.width / 2, size.height / 2);

    final Path path = Path()
      ..addArc(
        Rect.fromCircle(center: center, radius: radius),
        0,
        1.5 * math.pi,
      );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
