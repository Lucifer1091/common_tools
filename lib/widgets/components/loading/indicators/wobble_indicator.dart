part of 'my_loader_icon.dart';

class _LineWobbleIndicator extends StatefulWidget {
  const _LineWobbleIndicator({required this.options, this.height, this.width});

  final double? height, width;
  final MyLoaderOptions options;

  @override
  State<_LineWobbleIndicator> createState() => _LineWobbleIndicatorState();
}

class _LineWobbleIndicatorState extends State<_LineWobbleIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.options.duration,
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: -1,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(
        widget.width ?? 80,
        widget.height ?? widget.options.size!.value / 6.4,
      ),
      painter: LineWobblePainter(
        _animation,
        widget.options.backgroundColor ?? context.colorScheme.secondary,
        widget.options.color ?? context.colorScheme.primary,
      ),
    );
  }
}

class LineWobblePainter extends CustomPainter {
  LineWobblePainter(this.animation, this.background, this.color)
    : super(repaint: animation);

  final Color background, color;
  final Animation<double> animation;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint backgroundPaint =
        Paint()
          ..color = background
          ..style = PaintingStyle.fill;

    final Paint movingBarPaint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    // Draw static background bar
    final RRect backgroundBar = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(size.height / 2),
    );
    canvas.drawRRect(backgroundBar, backgroundPaint);

    // Calculate moving bar position (matches wobble effect)
    final double barWidth = size.width * 0.4; // 40% of total width
    final double xOffset =
        (size.width - barWidth) * ((animation.value + 1) / 2);

    final RRect movingBar = RRect.fromRectAndRadius(
      Rect.fromLTWH(xOffset, 0, barWidth, size.height),
      Radius.circular(size.height / 2),
    );

    canvas.drawRRect(movingBar, movingBarPaint);
  }

  @override
  bool shouldRepaint(LineWobblePainter oldDelegate) => true;
}
