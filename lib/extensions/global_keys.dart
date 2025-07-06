import 'package:flutter/material.dart';

/// Common extensions for [GlobalKey]s
extension GlobalKeyExt on GlobalKey<State<StatefulWidget>> {
  /// Returns the global offset of the widget attached to this key.
  Offset? get offset {
    try {
      if (currentState?.mounted == false) return null;

      final renderBox = currentContext?.findRenderObject() as RenderBox?;
      final translation = renderBox?.getTransformTo(null).getTranslation();

      if (translation == null) return null;

      return Offset(translation.x, translation.y);
    } catch (er) {
      return null;
    }
  }

  /// Returns the size of the widget attached to this key.
  Size? get size {
    try {
      if (currentState?.mounted == false) return null;

      final renderBox = currentContext?.findRenderObject() as RenderBox?;

      return renderBox?.size;
    } catch (er) {
      return null;
    }
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
