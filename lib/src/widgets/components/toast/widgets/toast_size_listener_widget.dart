import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class ToastSizeListenerWidget extends SingleChildRenderObjectWidget {
  const ToastSizeListenerWidget({
    required this.onSizeChanged,
    super.key,
    super.child,
  });

  final ValueChanged<Size> onSizeChanged;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderToastSizeListener(onSizeChanged);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderToastSizeListener renderObject,
  ) {
    renderObject.onSizeChanged = onSizeChanged;
  }
}

class RenderToastSizeListener extends RenderProxyBox {
  RenderToastSizeListener(this.onSizeChanged);

  ValueChanged<Size> onSizeChanged;
  Size? _lastSize;

  @override
  void performLayout() {
    super.performLayout();

    final Size newSize = child?.size ?? Size.zero;
    if (_lastSize == newSize) return;

    _lastSize = newSize;
    WidgetsBinding.instance.addPostFrameCallback((_) => onSizeChanged(newSize));
  }
}
