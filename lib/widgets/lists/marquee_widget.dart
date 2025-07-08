import 'package:flutter/cupertino.dart';

enum MarqueeDirection { oneDirection, twoDirection }

// Marquee widget to make any widget scroll horizontally automatically.
class MarqueeWidget extends StatefulWidget {
  const MarqueeWidget({
    required this.child,
    super.key,
    this.direction = Axis.horizontal,
    this.textDirection = TextDirection.ltr,
    this.marqueedirection = MarqueeDirection.twoDirection,
    this.animationDuration = const Duration(milliseconds: 3000),
    this.backDuration = const Duration(milliseconds: 3000),
    this.pauseDuration = const Duration(milliseconds: 1200),
  });

  final Widget child;
  final Axis direction;
  final TextDirection textDirection;
  final MarqueeDirection marqueedirection;
  final Duration animationDuration, backDuration, pauseDuration;

  @override
  State<MarqueeWidget> createState() => _MarqueeWidgetState();
}

class _MarqueeWidgetState extends State<MarqueeWidget> {
  late ScrollController _controller;

  @override
  void initState() {
    _controller = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback(scroll);
    super.initState();
  }

  Future<void> scroll(_) async {
    while (_controller.hasClients) {
      await Future<void>.delayed(widget.pauseDuration);

      if (_controller.hasClients) {
        await _controller.animateTo(
          _controller.position.maxScrollExtent,
          duration: widget.animationDuration,
          curve: Curves.linear,
        );
      }

      await Future<void>.delayed(widget.pauseDuration);

      if (_controller.hasClients) {
        switch (widget.marqueedirection) {
          case MarqueeDirection.oneDirection:
            _controller.jumpTo(0);
          case MarqueeDirection.twoDirection:
            await _controller.animateTo(
              0,
              duration: widget.backDuration,
              curve: Curves.linear,
            );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: widget.textDirection,
      child: SingleChildScrollView(
        scrollDirection: widget.direction,
        controller: _controller,
        child: widget.child,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
