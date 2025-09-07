import 'dart:math';
import 'package:flutter/material.dart';


class QuantumLoader extends StatefulWidget {
  @override
  _QuantumLoaderState createState() => _QuantumLoaderState();
}

class _QuantumLoaderState extends State<QuantumLoader> with SingleTickerProviderStateMixin {
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
  Widget build(BuildContext context) {
    return SizedBox(
      width: 65,
      height: 65,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: QuantumPainter(progress: _controller.value),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class QuantumPainter extends CustomPainter {
  final double progress;
  QuantumPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    final double radius = size.width / 2;
    final int particleCount = 13;

    for (int i = 0; i < particleCount; i++) {
      double angle = (2 * pi * i / particleCount) + (progress * 2 * pi);
      double x = radius + radius * 0.7 * cos(angle);
      double y = radius + radius * 0.7 * sin(angle);

      canvas.drawCircle(Offset(x, y), size.width * 0.1, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
