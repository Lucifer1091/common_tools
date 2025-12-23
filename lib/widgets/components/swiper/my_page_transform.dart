import 'package:flutter/material.dart';

import 'flutter_swiper/src/transformer_page_view/transformer_page_view.dart';

class MyPageTransformer extends PageTransformer {
  MyPageTransformer({this.fade, this.scale, this.margin});

  MyPageTransformer.margin({this.margin = 6.0}) : fade = 1, scale = 1;

  MyPageTransformer.scaleAndFade({this.fade = 1, this.scale = 0.8})
    : margin = 0.0;

  final double? scale;
  final double? fade;
  final double? margin;

  @override
  Widget transform(Widget item, TransformInfo info) {
    final position = info.position;

    var child = item;
    if (scale != null) {
      final scaleFactor = (1 - position.abs()) * (1 - scale!);
      final rawScale = scale! + scaleFactor;

      child = Transform.scale(scale: rawScale, child: item);
    }

    if (fade != null) {
      final fadeFactor = (1 - position.abs()) * (1 - fade!);
      final opacity = fade! + fadeFactor;
      child = Opacity(opacity: opacity, child: child);
    }
    if (margin != null) {
      child = Container(
        margin: EdgeInsets.only(left: margin!, right: margin!),
        child: child,
      );
    }
    return child;
  }
}
