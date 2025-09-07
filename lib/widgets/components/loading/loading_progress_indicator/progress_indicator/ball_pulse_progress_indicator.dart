import 'package:flutter/widgets.dart';

import '../progress_indicator.dart';

class BallPulseProgressIndicator extends SpinnerIndicator {
  //scale x ,y
  final scaleDoubles = [0.3, 0.3, 0.3];
  final delays = [120, 120, 120];

  @override
  void paint(Canvas canvas, Paint? paint, Size size) {
    const circleSpacing = 4;
    final width = size.width;
    final height = size.height;
    final radius = width / 6;
    final x = width / 2 - (radius * 2 + circleSpacing);
    final y = height / 2;
    for (int i = 0; i < 3; i++) {
      canvas.save();
      final translateX = x + (radius * 2) * i + circleSpacing * i;
      canvas
        ..translate(translateX, y)
        ..scale(scaleDoubles[i], scaleDoubles[i])
        ..drawCircle(Offset.zero, radius, paint!)
        ..restore();
    }
  }

  @override
  List<AnimationController> animation() {
    final List<AnimationController> controllers = [];

    for (var i = 0; i < 3; i++) {
      final AnimationController sizeController = AnimationController(
        duration: const Duration(milliseconds: 750),
        vsync: context,
      );
      final delayedAnimation = Tween<double>(
        begin: 0.3,
        end: 1,
      ).animate(sizeController);
      delayedAnimation.addListener(() {
        scaleDoubles[i] = delayedAnimation.value;
        postInvalidate();
      });
      // size.
      controllers.add(sizeController);
    }
    return controllers;
  }

  @override
  void startAnim(AnimationController controller) {
    controller.repeat(reverse: true);
  }

  @override
  Future<void> startAnims(List<AnimationController> controllers) async {
    for (var i = 0; i < controllers.length; i++) {
      await Future.delayed(const Duration(milliseconds: 120), () {
        if (context.mounted) startAnim(controllers[i]);
      });
    }
  }
}
