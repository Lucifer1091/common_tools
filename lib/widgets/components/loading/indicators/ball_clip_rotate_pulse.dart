part of '../my_loader.dart';

class _BallClipRotatePulse extends StatefulWidget {
  const _BallClipRotatePulse({this.options = const MyLoaderOptions()});

  final MyLoaderOptions options;

  @override
  State<_BallClipRotatePulse> createState() => _BallClipRotatePulseState();
}

class _BallClipRotatePulseState extends State<_BallClipRotatePulse>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _radius;
  late Animation<double> _rotate;

  double get radius => widget.options.size.value;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.options.duration,
      vsync: this,
    );
    _initAnimations();
    _controller
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      })
      ..forward();
  }

  void _initAnimations() {
    _radius = Tween<double>(begin: radius / 2, end: radius).animate(
      CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn),
    );
    _rotate = Tween<double>(begin: 0, end: 180).animate(
      CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn),
    );
  }

  @override
  void didUpdateWidget(covariant _BallClipRotatePulse oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update controller duration if changed
    if (oldWidget.options.duration != widget.options.duration) {
      _controller.duration = widget.options.duration;
    }

    // Update animations if size or duration changed
    if (oldWidget.options.size != widget.options.size ||
        oldWidget.options.duration != widget.options.duration) {
      _initAnimations();
    }
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
          size: Size.square(2 * radius),
          painter: _BallClipRotatePulsePainter(
            angle: _rotate.value,
            radius: _radius.value,
            minRadius: radius / 2,
            maxRadius: radius,
            solidCircleRadius: radius / 2,
            startAngle: -5,
            color: widget.options.color ?? context.colorScheme.primary,
            strokeWidth: widget.options.strokeWidth ?? 2,
          ),
        );
      },
    );
  }
}

class _BallClipRotatePulsePainter extends CustomPainter {
  _BallClipRotatePulsePainter({
    required this.angle,
    required this.radius,
    required this.minRadius,
    required this.maxRadius,
    required this.solidCircleRadius,
    required this.startAngle,
    required this.color,
    required this.strokeWidth,
  });

  final double angle;
  final double radius;
  final double minRadius;
  final double maxRadius;
  final double solidCircleRadius;
  final double startAngle;
  final Color color;
  final double strokeWidth;

  static const List<double> _startAngles = [225, 45];

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..isAntiAlias = true
          ..color = color
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round;

    final halfWidth = size.width * 0.5;
    final halfHeight = size.height * 0.5;

    canvas
      ..save()
      ..translate(halfWidth, halfHeight)
      ..rotate((angle + startAngle) * pi / 180);

    final preScale = minRadius / maxRadius;
    final scale = preScale + (radius - minRadius) / maxRadius;
    canvas.scale(scale);

    paint.style = PaintingStyle.stroke;
    for (final start in _startAngles) {
      final rect = Rect.fromLTWH(
        -halfWidth,
        -halfHeight,
        size.width,
        size.height,
      );
      canvas.drawArc(rect, start * pi / 180, 90 * pi / 180, false, paint);
    }

    paint.style = PaintingStyle.fill;
    canvas
      ..drawCircle(Offset.zero, solidCircleRadius, paint)
      ..restore();
  }

  @override
  bool shouldRepaint(covariant _BallClipRotatePulsePainter oldDelegate) {
    return angle != oldDelegate.angle ||
        radius != oldDelegate.radius ||
        color != oldDelegate.color ||
        strokeWidth != oldDelegate.strokeWidth;
  }
}
