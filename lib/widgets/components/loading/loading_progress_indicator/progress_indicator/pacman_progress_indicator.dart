import 'package:flutter/widgets.dart';

import '../progress_indicator.dart';

class PacmanProgressIndicator extends SpinnerIndicator {
  double translateX = 0;
  int alpha = 0;
  double degrees1 = 0;
  double degrees2 = 0;

  @override
  void paint(Canvas canvas, Paint? paint, Size size) {
    final x = size.width / 2;
    final y = size.height / 2;

    canvas
      ..save()
      ..translate(x, y)
      ..rotate(degrees1);
    paint!.color = paint.color.withAlpha(255);
    final Rect rectF1 = Rect.fromLTRB(-x / 1.7, -y / 1.7, x / 1.7, y / 1.7);
    canvas
      ..drawArc(rectF1, 0, 270, false, paint)
      ..restore()
      ..save()
      ..translate(x, y)
      ..rotate(degrees2);
    paint.color = paint.color.withAlpha(255);

    final Rect rectF2 = Rect.fromLTRB(-x / 1.7, -y / 1.7, x / 1.7, y / 1.7);

    canvas
      ..drawArc(rectF2, 90, 270, false, paint)
      ..restore();

    final radius = size.width / 11;
    paint.color = paint.color.withAlpha(alpha);
    canvas.drawCircle(
      Offset((1 - translateX) * size.width, size.height / 2),
      radius,
      paint,
    );
  }

  @override
  List<AnimationController> animation() {
    final List<AnimationController> controllers = [];

    final controller = AnimationController(
      duration: const Duration(milliseconds: 325),
      vsync: context,
    );

    final translateTween = Tween<double>(
      begin: 0,
      end: 0.5,
    ).animate(controller);
    final alphaTween = IntTween(begin: 255, end: 122).animate(controller);
    final rotateTween1 = Tween<double>(begin: 0, end: 45).animate(controller);
    final rotateTween2 = Tween<double>(begin: 0, end: -45).animate(controller);

    controller.addListener(() {
      translateX = translateTween.value;
      alpha = alphaTween.value;
      degrees1 = rotateTween1.value;
      degrees2 = rotateTween2.value;
      postInvalidate();
    });

    controllers.add(controller);
    return controllers;
  }

  @override
  void startAnim(AnimationController controller) {
    controller.repeat(reverse: true);
  }
}
