import 'package:flutter/material.dart';
import 'dart:math';

class WobbleAnimationScreen extends StatefulWidget {
  const WobbleAnimationScreen({super.key});

  @override
  State<WobbleAnimationScreen> createState() => _WobbleAnimationScreenState();
}

class _WobbleAnimationScreenState extends State<WobbleAnimationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 75).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
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
          width: 45,
          height: 12,
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return CustomPaint(
                painter: WobblePainter(_animation.value),
              );
            },
          ),
        ),
      ),
    );
  }
}

class WobblePainter extends CustomPainter {
  final double xOffset;

  WobblePainter(this.xOffset);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black;

    canvas.drawCircle(
      Offset(xOffset, size.height / 2), // Moves the ball back and forth
      size.height / 2, // Ball size
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
