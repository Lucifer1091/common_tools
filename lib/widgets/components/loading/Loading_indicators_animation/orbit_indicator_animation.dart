import 'package:flutter/material.dart';
import 'dart:math';

class OrbitAnimationScreen extends StatefulWidget {
  const OrbitAnimationScreen({super.key});

  @override
  State<OrbitAnimationScreen> createState() => _OrbitAnimationScreenState();
}

class _OrbitAnimationScreenState extends State<OrbitAnimationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
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
        child: SizedBox(
          width: 35,
          height: 35,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: OrbitPainter(_controller.value),
              );
            },
          ),
        ),
      ),
    );
  }
}

class OrbitPainter extends CustomPainter {
  final double animationValue;
  final double orbitRadius = 15;
  final double dotSize = 10;

  OrbitPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = Colors.black;

    final double centerX = size.width / 2;
    final double centerY = size.height / 2;

    // Calculate positions for two orbiting dots
    double angle1 = 2 * pi * animationValue;
    double angle2 = angle1 + pi; // Opposite direction

    Offset dot1 = Offset(
      centerX + orbitRadius * cos(angle1),
      centerY + orbitRadius * sin(angle1),
    );

    Offset dot2 = Offset(
      centerX + orbitRadius * cos(angle2),
      centerY + orbitRadius * sin(angle2),
    );

    // Draw orbiting dots
    canvas.drawCircle(dot1, dotSize / 2, paint);
    canvas.drawCircle(dot2, dotSize / 2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
