part of 'my_loader_icon.dart';

class _BallSpinFade extends StatefulWidget {
  const _BallSpinFade({
    required this.options,
    this.radius,
    this.minBallRadius,
    this.maxBallRadius,
    this.minBallAlpha,
    this.maxBallAlpha,
  });

  final double? radius;
  final double? minBallRadius;
  final double? maxBallRadius;
  final double? minBallAlpha;
  final double? maxBallAlpha;
  final MyLoaderOptions options;

  @override
  State<StatefulWidget> createState() => _BallSpinFadeState();
}

class _BallSpinFadeState extends State<_BallSpinFade>
    with SingleTickerProviderStateMixin, InfiniteProgressMixin {
  double _progress = 0;
  double _lastExtent = 0;

  @override
  void initState() {
    startEngine(this, widget.options.duration);
    super.initState();
  }

  @override
  void dispose() {
    closeEngine();
    super.dispose();
  }

  double get _radius => widget.radius ?? 24;
  double get _minBallRadius => widget.minBallRadius ?? 1.6;
  double get _maxBallRadius => widget.maxBallRadius ?? 5;
  double get _minBallAlpha => widget.minBallAlpha ?? 77;
  double get _maxBallAlpha => widget.maxBallAlpha ?? 255;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        // 👇 accumulate progress in state, not painter
        _progress = (_progress + (_lastExtent - animationValue).abs()) % 360.0;
        _lastExtent = animationValue;

        return CustomPaint(
          size: measureSize(),
          painter: _BallSpinFadeLoaderIndicatorPainter(
            progress: _progress,
            minRadius: _minBallRadius,
            maxRadius: _maxBallRadius,
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

class _BallSpinFadeLoaderIndicatorPainter extends CustomPainter {
  _BallSpinFadeLoaderIndicatorPainter({
    required this.progress,
    required this.minRadius,
    required this.maxRadius,
    required this.minAlpha,
    required this.maxAlpha,
    required this.ballColor,
  });

  final double progress;
  final double minRadius;
  final double maxRadius;
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
    final diffRadius = maxRadius - minRadius;

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

      final scaleRadius =
          sin(newProgress * pi / 180).abs() * diffRadius + minRadius;

      final point = _circleAt(
        size.width * .5,
        size.height * .5,
        size.width * .5 - maxRadius,
        i * pi / 4,
      );

      canvas
        ..drawCircle(point, scaleRadius, paint)
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
    covariant _BallSpinFadeLoaderIndicatorPainter oldDelegate,
  ) {
    return oldDelegate.progress != progress ||
        oldDelegate.ballColor != ballColor;
  }
}
