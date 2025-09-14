part of 'my_loader_icon.dart';

class _PacmanIndicator extends StatefulWidget {
  const _PacmanIndicator({
    required this.options,
    this.radius,
    this.beanRadius,
  });

  final double? radius;
  final double? beanRadius;
  final MyLoaderOptions options;

  @override
  State<StatefulWidget> createState() => _PacmanIndicatorState();
}

class _PacmanIndicatorState extends State<_PacmanIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> pacman;
  late Animation<double> bean;

  double _progress = 0.0;
  double _lastExtent = 0.0;

  double get _radius => widget.radius ?? 16;
  double get _beanRadius => widget.beanRadius ?? 4;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: widget.options.duration,
    );
    pacman = Tween<double>(
      begin: 0,
      end: 90,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
    bean = Tween<double>(
      begin: 0,
      end: _radius * .5,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

    _controller
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      })
      ..forward();

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Size _measureSize() {
    final width = (_radius + _beanRadius) * 2;
    final height = _radius * 2;
    return Size(width, height);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => CustomPaint(
        size: _measureSize(),
        painter: _PacmanIndicatorPainter(
          pacmanAngle: pacman.value,
          beanTransX: bean.value,
          radius: _radius,
          beanRadius: _beanRadius,
          color: widget.options.color ?? context.colorScheme.primary,
          progress: _progress,
          lastExtent: _lastExtent,
          onUpdate: (newProgress, newLastExtent) {
            _progress = newProgress;
            _lastExtent = newLastExtent;
          },
        ),
      ),
    );
  }
}

class _PacmanIndicatorPainter extends CustomPainter {
  _PacmanIndicatorPainter({
    required this.pacmanAngle,
    required this.beanTransX,
    required this.radius,
    required this.beanRadius,
    required this.color,
    required this.progress,
    required this.lastExtent,
    required this.onUpdate,
  });

  final double pacmanAngle;
  final double beanTransX;
  final double radius;
  final double beanRadius;
  final Color color;
  double progress;
  double lastExtent;
  final void Function(double, double) onUpdate;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill
      ..color = color;

    final width = radius * 2;
    final height = radius * 2;
    final radian = pi / 180;
    final Rect rect = Rect.fromLTWH(0, 0, width, height);

    // Pacman mouth
    canvas.drawArc(
      rect,
      (0 + pacmanAngle * .5) * radian,
      (360 - pacmanAngle) * radian,
      true,
      paint,
    );

    // Update bean progress
    progress += (lastExtent - beanTransX).abs();
    lastExtent = beanTransX;
    if (progress >= radius) {
      progress = .0;
      lastExtent = .0;
    }
    onUpdate(progress, lastExtent);

    // Bean fading effect
    final beanAlpha = 255 - (122.5 * progress / radius);
    paint.color = Color.fromARGB(
      beanAlpha.round(),
      (color.r * 255.0).round() & 0xff,
      (color.g * 255.0).round() & 0xff,
      (color.b * 255.0).round() & 0xff,
    );

    // Bean position
    final cx = width + beanRadius;
    final cy = size.height * .5;
    canvas.drawCircle(Offset(cx - progress, cy), beanRadius, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
