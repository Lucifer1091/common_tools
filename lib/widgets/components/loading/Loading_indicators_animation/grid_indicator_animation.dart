import 'package:flutter/material.dart';
import 'dart:math';

class AnimatedGridLoader extends StatefulWidget {
  const AnimatedGridLoader({super.key});

  @override
  _AnimatedGridLoaderState createState() => _AnimatedGridLoaderState();
}

class _AnimatedGridLoaderState extends State<AnimatedGridLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 100,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: GridPainter(_controller.value),
          );
        },
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  final double animationValue;
  GridPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    const int rows = 4;
    const int cols = 4;
    final double spacing = size.width / cols;
    final double dotSize = spacing * 0.3;

    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        double dx = j * spacing + spacing / 2;
        double dy = i * spacing + spacing / 2;

        double jump = sin(animationValue * pi * 2 + (i + j) * 0.5) * 10;

        canvas.drawCircle(Offset(dx, dy + jump), dotSize, paint);
      }
    }
  }

  @override
  bool shouldRepaint(GridPainter oldDelegate) => true;
}
