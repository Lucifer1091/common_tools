part of 'my_loader_icon.dart';

class _TextLoader extends StatefulWidget {
  const _TextLoader({required this.options, this.size, this.style});

  final double? size;
  final TextStyle? style;
  final MyLoaderOptions options;

  @override
  State<_TextLoader> createState() => _TextLoaderState();
}

class _TextLoaderState extends State<_TextLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> animation;
  late Animation<double> animationOp;

  bool _firstAnimation = true;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: widget.options.duration,
      vsync: this,
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _firstAnimation = false;
        _animationController.reset();
      }
      if (status == AnimationStatus.dismissed) {
        _firstAnimation = true;
        _animationController.forward();
      }
    });

    animation = Tween<double>(
      begin: 0,
      end: 2 * pi,
    ).animate(_animationController)..addListener(() {
      setState(() {});
    });

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color get main => widget.options.color ?? context.colorScheme.foreground;
  Color get secondary =>
      widget.options.secondaryColor ?? context.colorScheme.primary;

  double get size => widget.size ?? widget.options.size.value;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'L',
            style:
                widget.style ??
                context.bodyMedium.copyWith(
                  fontSize: size,
                  fontWeight: FontWeight.w600,
                  color: main,
                  fontStyle: FontStyle.normal,
                ),
            textHeightBehavior: TextHeightBehavior(
              applyHeightToFirstAscent: false,
              applyHeightToLastDescent: false,
            ),
          ),
          CustomPaint(
            size: Size.square(size),
            painter: _TextLoaderPainter(
              _firstAnimation ? animation.value : animationOp.value,
              size / 2.9,
              main,
              secondary,
            ),
          ),
          Text(
            'ADING',
            style:
                widget.style ??
                context.bodyMedium.copyWith(
                  fontSize: size,
                  fontWeight: FontWeight.w600,
                  color: main,
                  fontStyle: FontStyle.normal,
                ),
            textHeightBehavior: TextHeightBehavior(
              applyHeightToFirstAscent: false,
              applyHeightToLastDescent: false,
            ),
          ),
          Text(
            '...',
            style: TextStyle(
              fontSize: size,
              fontWeight: FontWeight.w900,
              color: secondary,
              fontStyle: FontStyle.normal,
              fontFamily: 'sans-serif',
            ),
            textHeightBehavior: TextHeightBehavior(
              applyHeightToFirstAscent: false,
              applyHeightToLastDescent: false,
            ),
          ),
        ],
      ),
    );
  }
}

class _TextLoaderPainter extends CustomPainter {
  _TextLoaderPainter(
    this.angle,
    this.size,
    this.mainColor,
    this.secondaryColor,
  );
  late double size;
  late double angle;
  late Color mainColor;
  late Color secondaryColor;

  @override
  void paint(Canvas canvas, Size size) {
    final painter = Paint()..style = PaintingStyle.fill;

    final Offset c = Offset(size.width / 2, size.height / 2);

    canvas
      ..drawArc(
        Rect.fromCircle(center: c, radius: this.size),
        7 * pi / 4 + angle,
        3 * pi / 4,
        false,
        painter
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..color = secondaryColor
          ..strokeWidth = this.size / 3.5,
      )
      ..drawArc(
        Rect.fromCircle(center: c, radius: this.size),
        3 * pi / 4 + angle,
        3 * pi / 4,
        false,
        painter
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..color = mainColor
          ..strokeWidth = this.size / 3.5,
      );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
