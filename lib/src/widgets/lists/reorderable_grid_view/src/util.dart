import 'dart:ui' as ui show Image;

import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

Future<ui.Image?> takeScreenShot(State state) async {
  final renderObject = state.context.findRenderObject();
  if (renderObject is RenderRepaintBoundary) {
    final RenderRepaintBoundary renderRepaintBoundary = renderObject;
    final devicePixelRatio = MediaQuery.of(state.context).devicePixelRatio;
    return renderRepaintBoundary.toImage(pixelRatio: devicePixelRatio);
  }
  return null;
}
