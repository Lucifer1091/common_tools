import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

class TrefoilLoader extends StatefulWidget {
  final double size;
  final Color color;
  final double speed;

  const TrefoilLoader({
    super.key,
    this.size = 40,
    this.color = Colors.black,
    this.speed = 1.4,
  });

  @override
  State<TrefoilLoader> createState() => _TrefoilLoaderState();
}

class _TrefoilLoaderState extends State<TrefoilLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (widget.speed * 1000).toInt()),
    )..repeat();
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
            size: Size(widget.size, widget.size),
            painter: TrefoilPainter(
              progress: _controller.value,
              color: widget.color,
            ),
          ),
        );
      },
    );
  }
}

class TrefoilPainter extends CustomPainter {
  final double progress;
  final Color color;

  TrefoilPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint trackPaint =
        Paint()
          ..color = color.withOpacity(0.1)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4;

    final Paint strokePaint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4
          ..strokeCap = StrokeCap.round;

    final Path path = _createTrefoilPath(size);
    canvas.drawPath(path, trackPaint);

    PathMetric pathMetric = path.computeMetrics().first;
    double pathLength = pathMetric.length;
    double start = progress * pathLength;
    double end = start + pathLength * 0.15;

    Path extractedPath = pathMetric.extractPath(start, end);
    canvas.drawPath(extractedPath, strokePaint);
  }

  Path _createTrefoilPath(Size size) {
    double w = size.width / 2;
    double h = size.height / 2;

    Path path = Path();
    for (double t = 0; t < 2 * pi; t += 0.02) {
      double x = w + w * sin(3 * t) * cos(t);
      double y = h + h * sin(3 * t) * sin(t);
      if (t == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    return path;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
