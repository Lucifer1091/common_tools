import 'package:flutter/widgets.dart';

/// A widget which is not in the layout and does nothing.
/// It is useful when you have to return a widget and can't return null.
class EmptyPlaceholder extends Widget {
  /// Creates a [EmptyPlaceholder] widget.
  const EmptyPlaceholder({super.key});

  @override
  Element createElement() => _EmptyPlaceholderElement(this);
}

class _EmptyPlaceholderElement extends Element {
  _EmptyPlaceholderElement(EmptyPlaceholder super.widget);

  @override
  bool get debugDoingBuild => false;

  @override
  void mount(Element? parent, Object? newSlot) {
    assert(parent is! MultiChildRenderObjectElement, """
        You are using EmptyPlaceholder under a MultiChildRenderObjectElement.
        This suggests a possibility that the EmptyPlaceholder is not needed or is being used improperly.
        Make sure it can't be replaced with an inline conditional or
        omission of the target widget from a list.
        """);

    super.mount(parent, newSlot);
  }

  @override
  void performRebuild() {
    super.performRebuild();
  }
}
