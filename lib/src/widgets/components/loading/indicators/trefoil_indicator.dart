part of 'my_loader_icon.dart';

class _TrefoilLoader extends StatefulWidget {
  const _TrefoilLoader({required this.options, this.size});

  final double? size;
  final MyLoaderOptions options;

  @override
  State<_TrefoilLoader> createState() => _TrefoilLoaderState();
}

class _TrefoilLoaderState extends State<_TrefoilLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.options.duration,
    );
    unawaited(_controller.repeat());
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
        return CustomPaint(
          size: Size.square(widget.size ?? widget.options.size!.value),
          painter: _TrefoilPainter(
            progress: _controller.value,
            color: widget.options.color ?? context.colorScheme.primary,
            trackColor: widget.options.color ?? context.colorScheme.secondary,
            strokeWidth: widget.options.strokeWidth,
          ),
        );
      },
    );
  }
}

class _TrefoilPainter extends CustomPainter {
  _TrefoilPainter({
    required this.progress,
    required this.color,
    required this.trackColor,
    this.strokeWidth,
  });

  final double progress;
  final double? strokeWidth;
  final Color color, trackColor;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth ?? 4;

    final Paint strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth ?? 4
      ..strokeCap = StrokeCap.round;

    final Path path = _createTrefoilPath(size);
    canvas.drawPath(path, trackPaint);

    final PathMetric pathMetric = path.computeMetrics().first;
    final double pathLength = pathMetric.length;
    final double start = progress * pathLength;
    final double end = start + pathLength * 0.15;

    final Path extractedPath = pathMetric.extractPath(start, end);
    canvas.drawPath(extractedPath, strokePaint);
  }

  Path _createTrefoilPath(Size size) {
    final double w = size.width / 2;
    final double h = size.height / 2;

    final Path path = Path();
    for (double t = 0; t < 2 * pi; t += 0.02) {
      final double x = w + w * sin(3 * t) * cos(t);
      final double y = h + h * sin(3 * t) * sin(t);
      if (t == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    return path;
  }

  @override
  bool shouldRepaint(covariant _TrefoilPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
