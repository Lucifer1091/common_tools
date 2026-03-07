import 'package:flutter/material.dart';

/// Common extensions for [GlobalKey]s
extension GlobalKeyExt on GlobalKey<State<StatefulWidget>> {
  /// Returns the global offset of the widget attached to this key.
  Offset? get offset {
    if (currentState?.mounted == false) return null;

    final renderObject = currentContext?.findRenderObject();
    if (renderObject is! RenderBox) return null;

    final translation = renderObject.getTransformTo(null).getTranslation();
    return Offset(translation.x, translation.y);
  }

  /// Returns the size of the widget attached to this key.
  Size? get size {
    if (currentState?.mounted == false) return null;

    final renderObject = currentContext?.findRenderObject();
    if (renderObject is! RenderBox) return null;

    return renderObject.size;
  }

  /// Returns a Rect of this widget based on the global offset and its size.
  Rect? get rect {
    final offset0 = offset;
    if (offset0 == null) return null;

    final size0 = size;
    if (size0 == null) return null;

    return offset0 & size0;
  }
}
