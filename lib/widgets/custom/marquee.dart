import 'dart:async';

import 'package:flutter/material.dart';

class MarqueeSpeed {
  static const double normal = 150.0;
}

class CustomMarquee extends StatefulWidget {
  const CustomMarquee({
    required this.child,
    super.key,
    this.marginLeft,
    this.betweenSpacing,
    this.width,
    this.height,
    this.speedRate = 1,
    this.scrollFromEnd = true,
    this.reverse = true,
    this.scrollDirection = Axis.horizontal,
    this.delayedStart = const Duration(seconds: 0),
  });

  final double? marginLeft;
  final double? betweenSpacing;
  final Widget child;
  final double? width;
  final double? height;
  final double speedRate;
  final bool scrollFromEnd;
  final bool reverse;
  final Axis scrollDirection;
  final Duration delayedStart;

  @override
  State<StatefulWidget> createState() => _CustomMarqueeState();
}

class _CustomMarqueeState extends State<CustomMarquee> {
  Timer? _anyMarqueeTimer;
  ScrollController? _scrollController;

  double? marginLeft;
  double? betweenSpacing;
  double? width;
  double? height;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Future.delayed(widget.delayedStart);
      startTimer();
    });
  }

  void startTimer() {
    _anyMarqueeTimer = Timer.periodic(
      const Duration(microseconds: 16),
      (timer) {
        if (_scrollController?.hasClients ?? false) {
          final distance = _scrollController?.offset ?? 0;
          _scrollController
              ?.jumpTo(distance + (1 / MarqueeSpeed.normal) * widget.speedRate);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScrollNotificationInterceptor(
      child: RepaintBoundary(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final biggestWidth = constraints.biggest.width;
            final biggestHeight = constraints.biggest.height;
            marginLeft ??= widget.marginLeft ?? biggestWidth;
            betweenSpacing ??= widget.betweenSpacing ?? biggestWidth;
            width ??= widget.width ?? biggestWidth;
            height ??= widget.height ?? biggestHeight;

            return Container(
              width: width,
              height: height,
              alignment: Alignment.center,
              child: RepaintBoundary(
                child: ListView.builder(
                  reverse: widget.reverse,
                  scrollDirection: widget.scrollDirection,
                  itemCount: double.maxFinite.toInt(),
                  itemBuilder: (context, index) {
                    final distance = (index == 0 ? marginLeft : betweenSpacing);
                    return Container(
                      padding: EdgeInsets.only(
                        left: widget.scrollFromEnd ? distance ?? 0 : 0,
                      ),
                      alignment: Alignment.center,
                      child: widget.child,
                    );
                  },
                  controller: _scrollController,
                  physics: const NeverScrollableScrollPhysics(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _anyMarqueeTimer?.cancel();
    super.dispose();
    _scrollController?.dispose();
  }
}

class ScrollNotificationInterceptor extends StatelessWidget {
  final Widget child;

  const ScrollNotificationInterceptor({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: (ScrollNotification notification) => true,
      child: child,
    );
  }
}
