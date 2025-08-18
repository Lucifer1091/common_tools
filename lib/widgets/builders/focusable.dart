import 'package:flutter/widgets.dart';

import '../../index.dart';

typedef FocusWidgetBuilder =
    Widget Function(BuildContext context, bool focused, Widget? child);

class MyFocusable extends StatefulWidget {
  const MyFocusable({
    required this.builder,
    super.key,
    this.focusNode,
    this.canRequestFocus = true,
    this.autofocus = false,
    this.child,
    this.onFocusChange,
    this.onKeyEvent,
    this.skipTraversal,
    this.descendantsAreFocusable,
    this.descendantsAreTraversable,
    this.includeSemantics = true,
    this.debugLabel,
  });

  final bool canRequestFocus;
  final bool autofocus;
  final FocusNode? focusNode;
  final FocusWidgetBuilder builder;
  final Widget? child;
  final ValueChanged<bool>? onFocusChange;
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

  FocusNode get focusNode => widget.focusNode ?? _internal!;

  @override
  void initState() {
    super.initState();
    if (widget.focusNode == null) _internal = FocusNode();
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
    widget.onFocusChange?.call(isFocused.value);
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: widget.autofocus,
      canRequestFocus: widget.canRequestFocus,
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

class MyFocusOutline extends StatelessWidget {
  const MyFocusOutline({
    super.key,
    this.enabled = true,
    this.child,
    this.focused = false,
    this.padding,
    this.borderWidth,
    this.offset,
    this.radius,
  });

  /// The child to decorate.
  final Widget? child;

  /// Whether the child has focus, defaults to false.
  final bool focused;

  /// Whether to show border around the child, defaults to true.
  final bool enabled;

  /// The padding around the child, defaults to 1.0.
  final double? padding;

  /// The width of the border around the child, defaults to 1.0.
  final double? borderWidth;

  /// The offset of the border around the child, defaults to 0.0.
  final double? offset;

  /// The radius of the border around the child, defaults to 0.0.
  final BorderRadius? radius;

  @override
  Widget build(BuildContext context) {
    Widget padded = Padding(padding: const EdgeInsets.all(1), child: child);
    final textDirection = Directionality.of(context);

    if (enabled) {
      padded = Padding(
        padding: padding != null ? EdgeInsets.all(padding!) : EdgeInsets.zero,
        child: CustomPaint(
          foregroundPainter: _MyOutwardBorderPainter(
            border: Border.all(
              color: context.colorScheme.ring,
              width: borderWidth ?? 1,
            ),
            offset: offset ?? 0,
            radius: radius ?? BorderRadius.zero,
            textDirection: textDirection,
          ),
          child: padded,
        ),
      );
    }

    return padded;
  }
}

/// A [CustomPainter] that paints a border outward from the given rectangle.
class _MyOutwardBorderPainter extends CustomPainter {
  const _MyOutwardBorderPainter({
    required this.border,
    required this.offset,
    required this.radius,
    required this.textDirection,
  });

  /// The border to paint.
  final Border border;

  /// The offset to inflate the border by.
  final double offset;

  /// The radius of the border.
  final BorderRadius? radius;

  /// The text direction to use when painting the border.
  final TextDirection? textDirection;

  @override
  void paint(Canvas canvas, Size size) {
    border.paint(
      canvas,
      (Offset.zero & size).inflate(offset),
      borderRadius: radius,
      textDirection: textDirection,
    );
  }

  @override
  bool shouldRepaint(covariant _MyOutwardBorderPainter oldDelegate) {
    return border != oldDelegate.border ||
        offset != oldDelegate.offset ||
        radius != oldDelegate.radius ||
        textDirection != oldDelegate.textDirection;
  }
}
