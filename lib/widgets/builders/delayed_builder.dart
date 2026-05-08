import 'dart:async';

import 'package:flutter/material.dart';

/// Delays showing [builder] and fades from [placeholder] to the built content.
class DelayedBuilder extends StatefulWidget {
  const DelayedBuilder({
    required this.builder,
    super.key,
    this.delay,
    this.placeholder,
    this.fadeDuration,
    this.stillLoading = false,
    this.alwaysTransition = false,
  });

  static Duration defaultDelay = const Duration(milliseconds: 200);
  static Duration defaultDuration = const Duration(milliseconds: 300);
  static Widget? defaultPlaceholder;

  final WidgetBuilder builder;
  final Duration? delay;
  final Duration? fadeDuration;
  final Widget? placeholder;
  final bool stillLoading;
  final bool alwaysTransition;

  @override
  State<DelayedBuilder> createState() => _DelayedBuilderState();
}

class _DelayedBuilderState extends State<DelayedBuilder> {
  Timer? _delayTimer;
  bool _showContent = false;

  @override
  void initState() {
    super.initState();
    _showContent = !widget.alwaysTransition && !widget.stillLoading;
    if (!_showContent) _startDelay();
  }

  @override
  void didUpdateWidget(covariant DelayedBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.stillLoading) return;

    final delayChanged = oldWidget.delay != widget.delay;
    final transitionEnabled = !_showContent && widget.alwaysTransition;
    if (delayChanged || transitionEnabled) _startDelay();
  }

  @override
  void dispose() {
    _delayTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final showPlaceholder = widget.stillLoading || !_showContent;
    final child =
        showPlaceholder
            ? widget.placeholder ??
                DelayedBuilder.defaultPlaceholder ??
                const SizedBox.shrink()
            : Builder(builder: widget.builder);

    return AnimatedSwitcher(
      duration: widget.fadeDuration ?? DelayedBuilder.defaultDuration,
      transitionBuilder: _fadeTransition,
      layoutBuilder: _asLayoutBuilder,
      child: child,
    );
  }

  void _startDelay() {
    _delayTimer?.cancel();

    final delay = widget.delay ?? DelayedBuilder.defaultDelay;
    if (delay <= Duration.zero) {
      _showDelayedContent();
      return;
    }

    _delayTimer = Timer(delay, _showDelayedContent);
  }

  void _showDelayedContent() {
    if (!mounted || _showContent) return;
    setState(() {
      _showContent = true;
    });
  }

  static Widget _fadeTransition(Widget child, Animation<double> animation) {
    return FadeTransition(opacity: animation, child: child);
  }

  static Widget _asLayoutBuilder(
    Widget? currentChild,
    List<Widget> previousChildren,
  ) {
    return Stack(
      children: [...previousChildren, if (currentChild != null) currentChild],
    );
  }
}
