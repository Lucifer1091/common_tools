part of 'my_loader_icon.dart';

class _CardioLoader extends StatefulWidget {
  const _CardioLoader({required this.options, this.size});

  final double? size;
  final MyLoaderOptions options;

  @override
  State<_CardioLoader> createState() => _CardioLoaderState();
}

class _CardioLoaderState extends State<_CardioLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.options.duration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double get _size => widget.size ?? widget.options.size.value;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size(_size, _size * 0.625),
          painter: _CardioPainter(
            progress: _controller.value,
            color: widget.options.color ?? context.colorScheme.primary,
            trackColor:
                widget.options.backgroundColor ?? context.colorScheme.secondary,
            strokeWidth: widget.options.strokeWidth,
            strokeCap: widget.options.strokeCap,
          ),
        );
      },
    );
  }
}

class _CardioPainter extends CustomPainter {
  _CardioPainter({
    required this.progress,
    required this.color,
    required this.trackColor,
    this.strokeWidth,
    this.strokeCap,
  });

  final double progress;
  final Color color, trackColor;
  final double? strokeWidth;
  final StrokeCap? strokeCap;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint trackPaint =
        Paint()
          ..color = trackColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth ?? 4;

    final Paint strokePaint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth ?? 4
          ..strokeCap = strokeCap ?? StrokeCap.round;

    final Path path = _createCardioPath(size);
    canvas.drawPath(path, trackPaint);

    final PathMetric pathMetric = path.computeMetrics().first;
    final double pathLength = pathMetric.length;
    final double start = progress * pathLength;
    final double end = start + pathLength * 0.3;

    final Path extractedPath = pathMetric.extractPath(start, end);
    canvas.drawPath(extractedPath, strokePaint);
  }

  Path _createCardioPath(Size size) {
    final Path path =
        Path()
          ..moveTo(0.625, size.height * 0.7)
          ..relativeLineTo(size.width * 0.2, 0)
          ..relativeLineTo(size.width * 0.075, -size.height * 0.2)
          ..relativeLineTo(size.width * 0.15, size.height * 0.5)
          ..relativeLineTo(size.width * 0.2, -size.height)
          ..relativeLineTo(size.width * 0.15, size.height * 0.7)
          ..relativeLineTo(size.width * 0.2, 0);
    return path;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
