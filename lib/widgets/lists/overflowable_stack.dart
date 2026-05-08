import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// A [Stack] that lets overflowing children receive pointer events.
class OverflowableStack extends Stack {
  const OverflowableStack({
    super.key,
    super.alignment,
    super.textDirection,
    super.fit,
    super.clipBehavior = Clip.none,
    super.children,
  });

  @override
  RenderStack createRenderObject(BuildContext context) {
    return _RenderOverflowableStack(
      alignment: alignment,
      textDirection: textDirection ?? Directionality.of(context),
      fit: fit,
      clipBehavior: clipBehavior,
    );
  }
}

class _RenderOverflowableStack extends RenderStack {
  _RenderOverflowableStack({
    super.alignment,
    super.textDirection,
    super.fit,
    super.clipBehavior = Clip.none,
  });

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    if (hitTestChildren(result, position: position) || hitTestSelf(position)) {
      result.add(BoxHitTestEntry(this, position));
      return true;
    }
    return false;
  }
}
