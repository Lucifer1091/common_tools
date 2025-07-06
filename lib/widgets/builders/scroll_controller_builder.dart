import 'package:flutter/material.dart';

/// {@template ScrollControllerBuilder}
/// A widget that exposes a ScrollController to the child, thereby allowing
/// widgets that require a ScrollController to be fully declarative.
/// {@endtemplate}
class ScrollControllerBuilder extends StatefulWidget {
  /// {@macro ScrollControllerBuilder}
  const ScrollControllerBuilder({required this.builder, super.key});

  final Widget Function(BuildContext context, ScrollController controller)
  builder;

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
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, controller);
  }
}
