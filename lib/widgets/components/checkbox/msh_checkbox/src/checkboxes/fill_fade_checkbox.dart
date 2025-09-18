import 'package:flutter/material.dart';

import '../../../index.dart';

class FillFadeCheckbox extends StatelessWidget {
  const FillFadeCheckbox({required this.parent, super.key});

  final MSHCheckboxBase parent;

  @override
  Widget build(BuildContext context) {
    final animation = parent.animation.drive(CurveTween(curve: Curves.ease));

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Opacity(
          opacity: animation.value,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: parent.size + parent.strokeWidth,
                width: parent.size + parent.strokeWidth,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: parent.fillColor(),
                ),
              ),
              Check(
                color: parent.checkColor(),
                fillPercentage: 1,
                size: parent.size * 0.4,
                strokeWidth: parent.strokeWidth,
              ),
            ],
          ),
        );
      },
    );
  }
}
