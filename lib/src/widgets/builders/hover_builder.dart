import 'package:flutter/material.dart';

typedef BoolWidgetBuilder =
    Widget Function(BuildContext context, bool isHovering);

/// Hover Widget is useful is web platform
class HoverBuilder extends StatefulWidget {
  const HoverBuilder({
    required this.builder,
    this.opaque,
    this.cursor,
    super.key,
  });

  final BoolWidgetBuilder builder;
  final bool? opaque;
  final MouseCursor? cursor;

  @override
  State<HoverBuilder> createState() => _HoverBuilderState();
}

class _HoverBuilderState extends State<HoverBuilder> {
  bool isHovering = false;

  void onEvent(bool value) {
    isHovering = value;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.cursor ?? MouseCursor.defer,
      onEnter: (event) => onEvent(true),
      onExit: (event) => onEvent(false),
      onHover: (event) => onEvent(true),
      opaque: widget.opaque ?? true,
      child: widget.builder.call(context, isHovering),
    );
  }
}
