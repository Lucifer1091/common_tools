import 'package:flutter/widgets.dart';

import '../progress_indicator.dart';

class LineScaleProgressIndicator extends SpinnerIndicator {
  final scaleYDoubles = [1.0, 1.0, 1.0, 1.0, 1.0];

  @override
  void paint(Canvas canvas, Paint? paint, Size size) {
    final translateX = size.width / 11;
    final translateY = size.height / 2;
    for (int i = 0; i < 5; i++) {
      canvas
        ..save()
        ..translate((2 + i * 2) * translateX - translateX / 2, translateY)
        ..scale(1, scaleYDoubles[i]);
      final rectF = RRect.fromLTRBR(
        -translateX / 2,
        -size.height / 2.5,
        translateX / 2,
        size.height / 2.5,
        const Radius.circular(5),
      );
      canvas
        ..drawRRect(rectF, paint!)
        ..restore();
    }
  }

  @override
  List<AnimationController> animation() {
    final List<AnimationController> controllers = [];
    for (int i = 0; i < 5; i++) {
      final sizeController = AnimationController(
        duration: const Duration(milliseconds: 500),
        vsync: context,
      );
      final alphaTween = Tween<double>(
        begin: 1,
        end: 0.4,
      ).animate(sizeController);
      sizeController.addListener(() {
        scaleYDoubles[i] = alphaTween.value;
        postInvalidate();
      });
      controllers.add(sizeController);
    }
    return controllers;
  }

  @override
  void startAnims(List<AnimationController> controllers) {
    final delays = [100, 200, 300, 400, 500];
    for (var i = 0; i < controllers.length; i++) {
      Future.delayed(Duration(milliseconds: delays[i]), () {
        if (context.mounted) controllers[i].repeat(reverse: true);
      });
    }
  }
}
