import 'dart:async';

import 'package:flutter/cupertino.dart';

enum MyMarqueeDirection { oneDirection, twoDirection }

// Marquee widget to make any widget scroll horizontally automatically.
class MyMarqueeWidget extends StatefulWidget {
  const MyMarqueeWidget({
    required this.child,
    super.key,
    this.direction = Axis.horizontal,
    this.textDirection = TextDirection.ltr,
    this.marqueedirection = MyMarqueeDirection.twoDirection,
    this.animationDuration = const Duration(milliseconds: 3000),
    this.backDuration = const Duration(milliseconds: 3000),
    this.pauseDuration = const Duration(milliseconds: 1200),
  });

  final Widget child;
  final Axis direction;
  final TextDirection textDirection;
  final MyMarqueeDirection marqueedirection;
  final Duration animationDuration, backDuration, pauseDuration;

  @override
  State<MyMarqueeWidget> createState() => _MyMarqueeWidgetState();
}

class _MyMarqueeWidgetState extends State<MyMarqueeWidget> {
  late final ScrollController _controller;
  int _scrollSession = 0;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _scheduleScrollRestart();
  }

  @override
  void didUpdateWidget(covariant MyMarqueeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.child != widget.child ||
        oldWidget.direction != widget.direction ||
        oldWidget.textDirection != widget.textDirection ||
        oldWidget.marqueedirection != widget.marqueedirection ||
        oldWidget.animationDuration != widget.animationDuration ||
        oldWidget.backDuration != widget.backDuration ||
        oldWidget.pauseDuration != widget.pauseDuration) {
      _scheduleScrollRestart();
    }
  }

  bool _isSessionActive(int session) {
    return mounted && _controller.hasClients && _scrollSession == session;
  }

  void _scheduleScrollRestart() {
    _scrollSession++;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      unawaited(_startScrollLoop(_scrollSession));
    });
  }

  Future<void> _startScrollLoop(int session) async {
    if (!_isSessionActive(session)) return;

    final initialMaxScrollExtent = _controller.position.maxScrollExtent;
    if (initialMaxScrollExtent <= 0) return;

    while (_isSessionActive(session)) {
      final maxScrollExtent = _controller.position.maxScrollExtent;
      if (maxScrollExtent <= 0) return;

      await Future<void>.delayed(widget.pauseDuration);
      if (!_isSessionActive(session)) return;

      if (_controller.offset != maxScrollExtent) {
        await _controller.animateTo(
          maxScrollExtent,
          duration: widget.animationDuration,
          curve: Curves.linear,
        );
        if (!_isSessionActive(session)) return;
      }

      await Future<void>.delayed(widget.pauseDuration);
      if (!_isSessionActive(session)) return;

      switch (widget.marqueedirection) {
        case MyMarqueeDirection.oneDirection:
          _controller.jumpTo(0);
        case MyMarqueeDirection.twoDirection:
          if (_controller.offset != 0) {
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
      child: NotificationListener<ScrollMetricsNotification>(
        onNotification: (notification) {
          _scheduleScrollRestart();
          return false;
        },
        child: SingleChildScrollView(
          scrollDirection: widget.direction,
          controller: _controller,
          child: widget.child,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollSession++;
    _controller.dispose();
    super.dispose();
  }
}
