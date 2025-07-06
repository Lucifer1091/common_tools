import 'package:flutter/widgets.dart';

/// A widget which is not in the layout and does nothing.
/// It is useful when you have to return a widget and can't return null.
class NoWidget extends Widget {
  const NoWidget({super.key});

  @override
  Element createElement() => _NoWidgetElement(this);
}

class _NoWidgetElement extends Element {
  _NoWidgetElement(NoWidget super.widget);

  @override
  bool get debugDoingBuild => false;

  @override
  void mount(Element? parent, Object? newSlot) {
    assert(parent is! MultiChildRenderObjectElement, """
        You are using NoWidget under a MultiChildRenderObjectElement.
        This suggests a possibility that the NoWidget is not needed or is being used improperly.
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
