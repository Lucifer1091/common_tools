import 'package:flutter/material.dart';

/// {@template ScrollControllerBuilder}
/// A widget that exposes a ScrollController to the child, thereby allowing
/// widgets that require a ScrollController to be fully declarative.
/// {@endtemplate}
class ScrollControllerBuilder extends StatefulWidget {
  /// {@macro ScrollControllerBuilder}
  const ScrollControllerBuilder({
    required this.builder,
    super.key,
    this.listener,
  });

  final Widget Function(BuildContext context, ScrollController controller)
  builder;

  final void Function(ScrollController controller)? listener;

  @override
  State<ScrollControllerBuilder> createState() =>
      _ScrollControllerBuilderState();
}

class _ScrollControllerBuilderState extends State<ScrollControllerBuilder> {
  late ScrollController controller;

  @override
  void initState() {
    super.initState();
    controller = ScrollController();
    if (widget.listener != null) {
      controller.addListener(() => widget.listener!(controller));
    }
  }

  @override
  void dispose() {
    if (widget.listener != null) {
      controller.removeListener(() => widget.listener!(controller));
    }
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, controller);
  }
}
