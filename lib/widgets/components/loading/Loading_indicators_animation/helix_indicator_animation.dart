import 'package:flutter/material.dart';
import 'dart:math';

class HelixLoader extends StatefulWidget {
  final double size;
  final Color color;
  final Duration duration;

  const HelixLoader({
    Key? key,
    this.size = 45.0,
    this.color = Colors.black,
    this.duration = const Duration(seconds: 2),
  }) : super(key: key);

  @override
  _HelixLoaderState createState() => _HelixLoaderState();
}

class _HelixLoaderState extends State<HelixLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: HelixPainter(_controller.value, widget.color),
            );
          },
        ),
      ),
    );
  }
}

class HelixPainter extends CustomPainter {
  final double progress;
  final Color color;

  HelixPainter(this.progress, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 3;
    const int totalCircles = 6;

    for (int i = 0; i < totalCircles; i++) {
      double angle = (i / totalCircles) * 2 * pi + (progress * 2 * pi);
      Offset offset = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );
      canvas.drawCircle(offset, size.width * 0.07, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
