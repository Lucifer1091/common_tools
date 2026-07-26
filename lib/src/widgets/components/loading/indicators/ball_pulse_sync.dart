part of 'my_loader_icon.dart';

class _BallPulseSync extends StatefulWidget {
  const _BallPulseSync({
    required this.options,
    this.radius,
    this.extent,
    this.spacing,
  });

  final double? radius;
  final double? extent;
  final double? spacing;
  final MyLoaderOptions options;

  @override
  State<StatefulWidget> createState() => _BallPulseSyncState();
}

class _BallPulseSyncState extends State<_BallPulseSync>
    with TickerProviderStateMixin, InfiniteProgressMixin {
  double _progress = 0;
  double _lastExtent = 0;

  @override
  void initState() {
    startEngine(
      this,
      widget.options.duration ?? const Duration(milliseconds: 400),
    );
    super.initState();
  }

  @override
  void dispose() {
    closeEngine();
    super.dispose();
  }

  double get _radius => widget.radius ?? widget.options.size!.value / 6.5;
  double get _extent => widget.extent ?? widget.options.size!.value / 3;
  double get _spacing => widget.spacing ?? 3;

  @override
  Size measureSize() {
    final width = _radius * 2 * 3 + _spacing * 2;
    final height = _extent + _radius * 2;
    return Size(width, height);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        // 👇 Accumulate progress here (stateful)
        _progress = (_progress + (_lastExtent - animationValue).abs()) % 360.0;
        _lastExtent = animationValue;

        return CustomPaint(
          size: measureSize(),
          painter: _BallPulseSyncIndicatorPainter(
            progress: _progress,
            extent: _extent,
            radius: _radius,
            spacing: _spacing,
            ballColor: widget.options.color ?? context.colorScheme.primary,
          ),
        );
      },
    );
  }
}

class _BallPulseSyncIndicatorPainter extends CustomPainter {
  _BallPulseSyncIndicatorPainter({
    required this.progress,
    required this.extent,
    required this.radius,
    required this.spacing,
    required this.ballColor,
  }) : extentList = <double>[extent * 0.9, extent * 0.6, extent * 0.3];

  final double progress;
  final double extent;
  final double radius;
  final double spacing;
  final Color ballColor;
  final List<double> extentList;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill
      ..color = ballColor
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < extentList.length; i++) {
      final dx = radius + 2 * i * radius + i * spacing;
      final offsetExtent = asin(extentList[i] / extent);
      final offsetY =
          sin(progress * pi / 180 + offsetExtent).abs() * extent + radius;
      final offset = Offset(dx, offsetY);
      canvas.drawCircle(offset, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _BallPulseSyncIndicatorPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.ballColor != ballColor;
  }
}
