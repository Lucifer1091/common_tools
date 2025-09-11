import 'dart:math';
import 'package:flutter/material.dart';

import '../../../../index.dart';

class TextLoader extends StatefulWidget {
  const TextLoader({
    super.key,
    this.size = 60,
    this.duration = const Duration(seconds: 1, milliseconds: 500),
    this.mainColor,
    this.secondaryColor,
  });

  final double size;
  final Duration duration;
  final Color? mainColor;
  final Color? secondaryColor;

  @override
  State<TextLoader> createState() => _TextLoaderState();
}

class _TextLoaderState extends State<TextLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> animation;
  late Animation<double> animationOp;

  bool _firstAnimation = true;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: widget.duration,
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

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'L',
            style: context.bodyMedium.copyWith(
              fontSize: widget.size,
              fontWeight: FontWeight.w600,
              color: widget.mainColor ?? context.colorScheme.foreground,
              fontStyle: FontStyle.normal,
            ),
          ),
          CustomPaint(
            painter: MyTextPainter(
              _firstAnimation ? animation.value : animationOp.value,
              widget.size / 2.8,
              widget.mainColor ?? context.colorScheme.foreground,
              widget.secondaryColor ?? context.colorScheme.primary,
            ),
            child: SizedBox(height: widget.size, width: widget.size),
          ),
          Text(
            'ADING',
            style: context.bodyMedium.copyWith(
              fontSize: widget.size,
              fontWeight: FontWeight.w600,
              color: widget.mainColor ?? context.colorScheme.foreground,
              fontStyle: FontStyle.normal,
            ),
          ),
          Text(
            '...',
            style: TextStyle(
              fontSize: widget.size,
              fontWeight: FontWeight.w900,
              color: widget.secondaryColor ?? context.colorScheme.primary,
              fontStyle: FontStyle.normal,
              fontFamily: 'sans-serif',
            ),
          ),
        ],
      ),
    );
  }
}

class MyTextPainter extends CustomPainter {
  MyTextPainter(this.angle, this.size, this.mainColor, this.secondaryColor);
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
          ..color = mainColor
          ..strokeWidth = this.size / 3.5,
      );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
