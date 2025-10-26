import 'package:flutter/widgets.dart';

class MyFocusableParams {
  const MyFocusableParams({
    this.autofocus = false,
    this.canRequestFocus = true,
    this.focusOutline = true,
    this.enableFeedback = true,
    this.focusNode,
    this.onFocusChange,
  });

  final bool autofocus;
  final bool canRequestFocus;
  final bool focusOutline;
  final bool enableFeedback;
  final FocusNode? focusNode;
  final ValueChanged<bool>? onFocusChange;

  MyFocusableParams copyWith({
    bool? autofocus,
    bool? canRequestFocus,
    FocusNode? focusNode,
    ValueChanged<bool>? onFocusChange,
  }) {
    return MyFocusableParams(
      autofocus: autofocus ?? this.autofocus,
      canRequestFocus: canRequestFocus ?? this.canRequestFocus,
      focusNode: focusNode ?? this.focusNode,
      onFocusChange: onFocusChange ?? this.onFocusChange,
    );
  }
}

typedef FocusWidgetBuilder =
    Widget Function(BuildContext context, bool focused, Widget? child);

class MyFocusable extends StatefulWidget {
  const MyFocusable({
    required this.builder,
    super.key,
    this.params = const MyFocusableParams(),
    this.child,
    this.onKeyEvent,
    this.skipTraversal,
    this.descendantsAreFocusable,
    this.descendantsAreTraversable,
    this.includeSemantics = true,
    this.debugLabel,
  });

  final MyFocusableParams params;
  final FocusWidgetBuilder builder;
  final Widget? child;
  final FocusOnKeyEventCallback? onKeyEvent;
  final bool? skipTraversal;
  final bool? descendantsAreFocusable;
  final bool? descendantsAreTraversable;
  final bool includeSemantics;
  final String? debugLabel;

  @override
  State<MyFocusable> createState() => _MyFocusableState();
}

class _MyFocusableState extends State<MyFocusable> {
  FocusNode? _internal;

  final isFocused = ValueNotifier(false);

  FocusNode get focusNode => widget.params.focusNode ?? _internal!;

  @override
  void initState() {
    super.initState();
    if (widget.params.focusNode == null) _internal = FocusNode();
    isFocused
      ..value = focusNode.hasFocus
      ..addListener(onFocusChange);
  }

  @override
  void dispose() {
    isFocused.removeListener(onFocusChange);
    _internal?.dispose();
    isFocused.dispose();
    super.dispose();
  }

  void onFocusChange() {
    widget.params.onFocusChange?.call(isFocused.value);
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: widget.params.autofocus,
      canRequestFocus: widget.params.canRequestFocus,
      onFocusChange: (value) => isFocused.value = value,
      focusNode: focusNode,
      onKeyEvent: widget.onKeyEvent,
      skipTraversal: widget.skipTraversal,
      descendantsAreFocusable: widget.descendantsAreFocusable,
      descendantsAreTraversable: widget.descendantsAreTraversable,
      includeSemantics: widget.includeSemantics,
      debugLabel: widget.debugLabel,
      child: ValueListenableBuilder(
        valueListenable: isFocused,
        builder:
            (context, value, child) => widget.builder(context, value, child),
        child: widget.child,
      ),
    );
  }
}
