import 'package:flutter/widgets.dart';

import '../../index.dart';

class MyAnimationParams {
  const MyAnimationParams({
    this.enabled = true,
    this.duration = kDefaultDuration,
    this.curve = Curves.linear,
    this.value = 1.0,
  });

  final bool enabled;
  final Duration duration;
  final Curve curve;
  final double value;
}

class AnimationBuilder extends StatefulWidget {
  const AnimationBuilder({
    required this.duration,
    required this.builder,
    super.key,
  });

  final Duration duration;
  final Widget Function(BuildContext context, AnimationController controller)
  builder;

  @override
  State<AnimationBuilder> createState() => _AnimationBuilderState();
}

class _AnimationBuilderState extends State<AnimationBuilder>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(duration: widget.duration, vsync: this);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return widget.builder(context, controller);
      },
    );
  }
}
