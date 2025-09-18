import 'package:flutter/material.dart';

import '../../../index.dart';
import 'msh_checkbox_base.dart' show MSHCheckboxBase;

class FillScaleColorCheckbox extends StatelessWidget {
  final MSHCheckboxBase parent;

  const FillScaleColorCheckbox({Key? key, required this.parent})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final animation = parent.animation.drive(
      Tween(
        begin: 0.0,
        end: parent.size + parent.strokeWidth,
      ).chain(CurveTween(curve: Curves.easeOutCirc)),
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: animation.value,
              width: animation.value,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: parent.fillColor(),
              ),
            ),
            Opacity(
              opacity: parent.animation.value,
              child: Check(
                color: parent.checkColor(),
                fillPercentage: 1,
                size: parent.size * 0.4,
                strokeWidth: parent.strokeWidth,
              ),
            ),
          ],
        );
      },
    );
  }
}
