import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// Signature for the [ValueLayoutBuilder] builder function.
typedef ValueLayoutWidgetBuilder<T> =
    Widget Function(BuildContext context, BoxValueConstraints<T> constraints);

/// Constraints with an extra value.
class BoxValueConstraints<T> extends BoxConstraints {
  BoxValueConstraints({
    required this.value,
    required BoxConstraints constraints,
  }) : super(
         minWidth: constraints.minWidth,
         maxWidth: constraints.maxWidth,
         minHeight: constraints.minHeight,
         maxHeight: constraints.maxHeight,
       );

  final T value;

  @override
  bool operator ==(Object other) {
    assert(debugAssertIsValid(), 'BoxValueConstraints are not valid.');
    if (identical(this, other)) return true;
    if (other is! BoxValueConstraints<T>) return false;
    return value == other.value &&
        minWidth == other.minWidth &&
        maxWidth == other.maxWidth &&
        minHeight == other.minHeight &&
        maxHeight == other.maxHeight;
  }

  @override
  int get hashCode {
    assert(debugAssertIsValid(), 'BoxValueConstraints are not valid.');
    return Object.hash(minWidth, maxWidth, minHeight, maxHeight, value);
  }
}

/// Builds a widget tree that can depend on the parent widget's size and an extra value.
/// Similar to [LayoutBuilder], but the constraints contain an extra value.
class ValueLayoutBuilder<T>
    extends ConstrainedLayoutBuilder<BoxValueConstraints<T>> {
  /// Creates a widget that defers its building until layout.
  const ValueLayoutBuilder({required super.builder, super.key});

  @override
  _RenderValueLayoutBuilder<T> createRenderObject(BuildContext context) =>
      _RenderValueLayoutBuilder<T>();
}

class _RenderValueLayoutBuilder<T> extends RenderBox
    with
        RenderObjectWithChildMixin<RenderBox>,
        RenderObjectWithLayoutCallbackMixin,
        RenderAbstractLayoutBuilderMixin<BoxValueConstraints<T>, RenderBox> {
  @override
  double computeMinIntrinsicWidth(double height) {
    assert(() {
      _debugThrowIfNotCheckingIntrinsics();
      return true;
    }(), 'ValueLayoutBuilder does not support computeMinIntrinsicWidth.');
    return 0;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    assert(() {
      _debugThrowIfNotCheckingIntrinsics();
      return true;
    }(), 'ValueLayoutBuilder does not support computeMaxIntrinsicWidth.');
    return 0;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    assert(() {
      _debugThrowIfNotCheckingIntrinsics();
      return true;
    }(), 'ValueLayoutBuilder does not support computeMinIntrinsicHeight.');
    return 0;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    assert(() {
      _debugThrowIfNotCheckingIntrinsics();
      return true;
    }(), 'ValueLayoutBuilder does not support computeMaxIntrinsicHeight.');
    return 0;
  }

  @override
  void performLayout() {
    final constraints = this.constraints;
    runLayoutCallback();
    if (child != null) {
      child!.layout(constraints, parentUsesSize: true);
      size = constraints.constrain(child!.size);
    } else {
      size = constraints.biggest;
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return child?.hitTest(result, position: position) ?? false;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null) {
      context.paintChild(child!, offset);
    }
  }

  bool _debugThrowIfNotCheckingIntrinsics() {
    assert(
      () {
        if (!RenderObject.debugCheckingIntrinsics) {
          throw FlutterError(
            'ValueLayoutBuilder does not support returning intrinsic dimensions.\n'
            'Calculating the intrinsic dimensions would require running the layout '
            'callback speculatively, which might mutate the live render object tree.',
          );
        }
        return true;
      }(),
      'ValueLayoutBuilder does not support returning intrinsic dimensions.\n'
      'Calculating the intrinsic dimensions would require running the layout '
      'callback speculatively, which might mutate the live render object tree.',
    );
    return true;
  }
}
