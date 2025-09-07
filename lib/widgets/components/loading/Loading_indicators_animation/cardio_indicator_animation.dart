import 'dart:ui';
import 'package:flutter/material.dart';
import 'dart:math';

class CardioLoader extends StatefulWidget {
  final double size;
  final Color color;
  final double speed;

  const CardioLoader({
    super.key,
    this.size = 50,
    this.color = Colors.black,
    this.speed = 1.75,
  });

  @override
  State<CardioLoader> createState() => _CardioLoaderState();
}

class _CardioLoaderState extends State<CardioLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (widget.speed * 1000).toInt()),
    )..repeat(reverse: false);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Center(
          child: CustomPaint(
            size: Size(widget.size, widget.size * 0.625),
            painter: CardioPainter(
              progress: _controller.value,
              color: widget.color,
            ),
          ),
        );
      },
    );
  }
}

class CardioPainter extends CustomPainter {
  final double progress;
  final Color color;

  CardioPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint trackPaint = Paint()
      ..color = color.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    final Paint strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final Path path = _createCardioPath(size);
    canvas.drawPath(path, trackPaint);

    PathMetric pathMetric = path.computeMetrics().first;
    double pathLength = pathMetric.length;
    double start = progress * pathLength;
    double end = start + pathLength * 0.3;

    Path extractedPath = pathMetric.extractPath(start, end);
    canvas.drawPath(extractedPath, strokePaint);
  }

  Path _createCardioPath(Size size) {
    Path path = Path();
    path.moveTo(0.625, size.height * 0.7);
    path.relativeLineTo(size.width * 0.2, 0);
    path.relativeLineTo(size.width * 0.075, -size.height * 0.2);
    path.relativeLineTo(size.width * 0.15, size.height * 0.5);
    path.relativeLineTo(size.width * 0.2, -size.height);
    path.relativeLineTo(size.width * 0.15, size.height * 0.7);
    path.relativeLineTo(size.width * 0.2, 0);
    return path;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
