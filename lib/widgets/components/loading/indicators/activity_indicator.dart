part of 'my_loader_icon.dart';

class _ActivityIndicator extends StatefulWidget {
  const _ActivityIndicator({
    required this.options,
    this.radius,
    this.minLineWidth,
    this.maxLineWidth,
    this.minLineHeight,
    this.maxLineHeight,
    this.minBallAlpha,
    this.maxBallAlpha,
  });

  final double? radius;
  final double? minLineWidth;
  final double? maxLineWidth;
  final double? minLineHeight;
  final double? maxLineHeight;
  final double? minBallAlpha;
  final double? maxBallAlpha;
  final MyLoaderOptions options;

  @override
  State<StatefulWidget> createState() => _ActivityIndicatorState();
}

class _ActivityIndicatorState extends State<_ActivityIndicator>
    with SingleTickerProviderStateMixin, InfiniteProgressMixin {
  @override
  void initState() {
    startEngine(this, widget.options.duration!);
    super.initState();
  }

  @override
  void dispose() {
    closeEngine();
    super.dispose();
  }

  double get _radius => widget.radius ?? 18;
  double get _minLineWidth => widget.minLineWidth ?? 2.4;
  double get _maxLineWidth => widget.maxLineWidth ?? 4.8;
  double get _minLineHeight => widget.minLineHeight ?? 4.8;
  double get _maxLineHeight => widget.maxLineHeight ?? 9.6;
  double get _minBallAlpha => widget.minBallAlpha ?? 77;
  double get _maxBallAlpha => widget.maxBallAlpha ?? 255;

  double _progress = 0;
  double _lastExtent = 0;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        // 👇 Accumulate here (stateful, not in painter)
        _progress += (_lastExtent - animationValue).abs();
        _lastExtent = animationValue;
        if (_progress >= double.maxFinite) {
          _progress = 0.0;
          _lastExtent = 0.0;
        }

        return CustomPaint(
          size: measureSize(),
          painter: _ActivityIndicatorPainter(
            progress: _progress,
            // animationValue: animationValue,
            minLineWidth: _minLineWidth,
            maxLineWidth: _maxLineWidth,
            minLineHeight: _minLineHeight,
            maxLineHeight: _maxLineHeight,
            minAlpha: _minBallAlpha,
            maxAlpha: _maxBallAlpha,
            ballColor: widget.options.color ?? context.colorScheme.primary,
          ),
        );
      },
    );
  }

  @override
  Size measureSize() {
    return Size(2 * _radius, 2 * _radius);
  }
}

class _ActivityIndicatorPainter extends CustomPainter {
  _ActivityIndicatorPainter({
    required this.progress,
    required this.minLineWidth,
    required this.maxLineWidth,
    required this.minLineHeight,
    required this.maxLineHeight,
    required this.minAlpha,
    required this.maxAlpha,
    required this.ballColor,
  });

  final double progress;
  final double minLineWidth;
  final double maxLineWidth;
  final double minLineHeight;
  final double maxLineHeight;
  final double minAlpha;
  final double maxAlpha;
  final Color ballColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..isAntiAlias = true
          ..style = PaintingStyle.fill;

    final diffAlpha = maxAlpha - minAlpha;
    final diffWidth = maxLineWidth - minLineWidth;
    final diffHeight = maxLineHeight - minLineHeight;

    for (int i = 0; i < 8; i++) {
      canvas.save();

      final newProgress = progress - i * 22.5;

      final beatAlpha =
          sin(newProgress * pi / 180).abs() * diffAlpha + minAlpha;

      paint.color = Color.fromARGB(
        beatAlpha.round().clamp(0, 255),
        (ballColor.r * 255.0).round() & 0xff,
        (ballColor.g * 255.0).round() & 0xff,
        (ballColor.b * 255.0).round() & 0xff,
      );

      final scaleWidth =
          sin(newProgress * pi / 180).abs() * diffWidth + minLineWidth;
      final scaleHeight =
          sin(newProgress * pi / 180).abs() * diffHeight + minLineHeight;

      final point = _circleAt(
        size.width * .5,
        size.height * .5,
        size.width * .5 - maxLineWidth,
        i * pi / 4,
      );

      canvas
        ..translate(point.dx, point.dy)
        ..rotate((90 + (i * 45)) * pi / 180);

      final rect = Rect.fromLTWH(
        -scaleWidth * .5,
        -scaleHeight * .5,
        scaleWidth,
        scaleHeight,
      );

      final rRect = RRect.fromRectAndRadius(rect, const Radius.circular(4));
      canvas
        ..drawRRect(rRect, paint)
        ..restore();
    }
  }

  Offset _circleAt(double width, double height, double radius, double angle) {
    final x = width + radius * cos(angle);
    final y = height + radius * sin(angle);
    return Offset(x, y);
  }

  @override
  bool shouldRepaint(
    covariant _ActivityIndicatorPainter oldDelegate,
  ) {
    return oldDelegate.progress != progress ||
        oldDelegate.ballColor != ballColor;
  }
}
