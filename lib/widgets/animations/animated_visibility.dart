import 'package:flutter/widgets.dart';

import '../layout/no_widget.dart';

/// Widget that animates the visibility of child widget by updating widget opacity and hide the old widget.
class AnimatedVisibility extends StatefulWidget {
  const AnimatedVisibility({
    required this.visible,
    required this.child,
    this.placeholder = const NoWidget(),
    this.duration = const Duration(milliseconds: 250),
    this.opacityBeforeBeingInvisible = 0.0,
    super.key,
  });

  final bool visible;
  final Widget child;
  final Widget placeholder;
  final Duration duration;
  final double opacityBeforeBeingInvisible;

  @override
  State<AnimatedVisibility> createState() => _AnimatedVisibilityState();
}

class _AnimatedVisibilityState extends State<AnimatedVisibility> {
  bool _visible = true;

  @override
  void initState() {
    _visible = widget.visible;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: widget.visible ? 1 : widget.opacityBeforeBeingInvisible,
      duration: widget.duration,
      onEnd: () {
        setState(() {
          _visible = widget.visible;
        });
      },
      child: Visibility(
        visible: _visible,
        replacement: widget.placeholder,
        child: widget.child,
      ),
    );
  }
}
