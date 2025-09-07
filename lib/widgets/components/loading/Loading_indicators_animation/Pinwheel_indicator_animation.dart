import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class PinwheelLoaderScreen extends StatefulWidget {
  const PinwheelLoaderScreen({super.key});

  @override
  _PinwheelLoaderScreenState createState() => _PinwheelLoaderScreenState();
}

class _PinwheelLoaderScreenState extends State<PinwheelLoaderScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900), // Same as your CSS --uib-speed
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
              angle: _controller.value * math.pi, // Rotating by 180 degrees like CSS keyframes
              child: CustomPaint(
                size: const Size(35, 35), // Same as --uib-size
                painter: PinwheelPainter(),
              ),
            );
          },
        ),
      ),
    );
  }
}

class PinwheelPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.black // Same as --uib-color
      ..strokeWidth = 3.5 // Same as --uib-stroke
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 6; i++) {
      double opacity = (1 - (i * 0.2)).clamp(0.1, 1.0); // Same opacity logic as CSS
      paint.color = Colors.black.withOpacity(opacity);

      double angle = i * (math.pi / 6);
      double lineLength = size.width / 2;

      canvas.drawLine(
        Offset(size.width / 2, size.height / 2),
        Offset(
          size.width / 2 + lineLength * math.cos(angle),
          size.height / 2 + lineLength * math.sin(angle),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}