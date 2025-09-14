part of 'my_loader_icon.dart';

class _ClockIndicator extends StatefulWidget {
  const _ClockIndicator({required this.options, this.size});

  final double? size;
  final MyLoaderOptions options;

  @override
  State<_ClockIndicator> createState() => _ClockIndicatorState();
}

class _ClockIndicatorState extends State<_ClockIndicator>
    with TickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;
  final Tween<double> _rotationTween = Tween(begin: 0, end: 2 * pi);

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: widget.options.duration,
    );

    animation =
        _rotationTween.animate(controller)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              controller.repeat();
            } else if (status == AnimationStatus.dismissed) {
              controller.forward();
            }
          });

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  double get _size => widget.size ?? widget.options.size.value;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return CustomPaint(
          size: Size.square(_size),
          painter: _ClockShapePainter(
            animation.value * 2,
            animation.value,
            widget.options.backgroundColor ?? context.colorScheme.muted,
            widget.options.color ?? context.colorScheme.destructive,
            widget.options.secondaryColor ?? context.colorScheme.primary,
            widget.options.tertiaryColor ?? context.colorScheme.mutedForeground,
            widget.options.strokeWidth ?? 3,
          ),
        );
      },
    );
  }
}

class _ClockShapePainter extends CustomPainter {
  _ClockShapePainter(
    this.angle,
    this.angle2,
    this.frameColor,
    this.minuteColor,
    this.hourColor,
    this.dotColor,
    this.strokeWidth,
  );

  double angle;
  double angle2;
  final Color frameColor;
  final Color minuteColor;
  final Color hourColor;
  final Color dotColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint1 =
        Paint()
          ..color = frameColor
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;
    final paint2 =
        Paint()
          ..color = minuteColor
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;
    final paint3 =
        Paint()
          ..color = hourColor
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;
    final paint4 =
        Paint()
          ..color = dotColor
          ..strokeWidth = strokeWidth * 1.5
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    final double radius = size.height * 0.4;
    final double radius2 = size.height * 0.2;
    final Offset startingPoint = Offset(size.width / 2, size.height / 2);
    final Offset endingPoint = Offset(
      radius2 * cos(angle2) + startingPoint.dx,
      radius2 * sin(angle2) + startingPoint.dy,
    );
    final Offset endingPoint2 = Offset(
      radius * cos(angle) + startingPoint.dx,
      radius * sin(angle) + startingPoint.dy,
    );
    final Offset center = Offset(size.width / 2, size.height / 2);

    canvas
      ..drawCircle(center, size.height / 2, paint1)
      ..drawLine(startingPoint, endingPoint2, paint2)
      ..drawLine(startingPoint, endingPoint, paint3)
      ..drawLine(startingPoint, startingPoint, paint4);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
