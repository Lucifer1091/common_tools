part of 'my_loader_icon.dart';

class _TriangleIndicator extends StatefulWidget {
  const _TriangleIndicator({required this.options, this.size});

  final double? size;
  final MyLoaderOptions options;

  @override
  _TriangleIndicatorState createState() => _TriangleIndicatorState();
}

class _TriangleIndicatorState extends State<_TriangleIndicator>
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
          painter: _TriangleIndicatorPainter(
            _controller.value,
            widget.options.backgroundColor ?? context.colorScheme.secondary,
            widget.options.color ?? context.colorScheme.primary,
            widget.options.strokeWidth ?? widget.options.size!.value / 9.5,
          ),
        );
      },
    );
  }
}

class _TriangleIndicatorPainter extends CustomPainter {
  _TriangleIndicatorPainter(
    this.animationValue,
    this.background,
    this.color,
    this.strokeWidth,
  );

  final Color background, color;
  final double animationValue;
  final double? strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint trackPaint = Paint()
      ..color = background
      ..strokeWidth = strokeWidth ?? 5
      ..style = PaintingStyle.stroke;

    final Paint carPaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth ?? 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final Path path = Path();
    final double sideLength = size.width - 5;
    final double height = (sqrt(3) / 2) * sideLength;
    final double offsetX = 2.5;
    final double offsetY = (size.height - height) / 2;

    path
      ..moveTo(offsetX + sideLength / 2, offsetY)
      ..lineTo(offsetX + sideLength, offsetY + height)
      ..lineTo(offsetX, offsetY + height)
      ..close();

    canvas.drawPath(path, trackPaint);

    final PathMetric pathMetric = path.computeMetrics().first;
    final double travelDistance = pathMetric.length * animationValue;
    final Tangent? tangent = pathMetric.getTangentForOffset(travelDistance);
    if (tangent != null) {
      canvas.drawCircle(tangent.position, 2, carPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
