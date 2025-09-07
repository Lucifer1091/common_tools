import 'package:flutter/material.dart';
import 'dart:math';

class ChaoticOrbitLoader extends StatefulWidget {
  const ChaoticOrbitLoader({super.key});

  @override
  State<ChaoticOrbitLoader> createState() => _ChaoticOrbitLoaderState();
}

class _ChaoticOrbitLoaderState extends State<ChaoticOrbitLoader>
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
          width: 50,
          height: 50,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: ChaoticOrbitPainter(_controller.value),
              );
            },
          ),
        ),
      ),
    );
  }
}

class ChaoticOrbitPainter extends CustomPainter {
  final double animationValue;
  final double orbitRadius = 20;
  final double dotSize = 8;

  ChaoticOrbitPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = Colors.black;
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;

    double angle1 = 2 * pi * animationValue;
    double angle2 = angle1 + pi;

    Offset dot1 = Offset(
      centerX + orbitRadius * cos(angle1) * randomFactor(angle1),
      centerY + orbitRadius * sin(angle1) * randomFactor(angle1),
    );

    Offset dot2 = Offset(
      centerX + orbitRadius * cos(angle2) * randomFactor(angle2),
      centerY + orbitRadius * sin(angle2) * randomFactor(angle2),
    );

    canvas.drawCircle(dot1, dotSize / 2, paint);
    canvas.drawCircle(dot2, dotSize / 2, paint);
  }

  double randomFactor(double angle) {
    return 0.7 + 0.3 * sin(angle * 3); // Creates chaotic movement
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
