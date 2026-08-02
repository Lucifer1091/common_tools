import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../common/my_decoration.dart';
import '../../common/portal.dart';
import '../popover/popover.dart';

class MyHoverCard extends StatefulWidget {
  const MyHoverCard({
    required this.child,
    required this.hoverBuilder,
    super.key,
    this.controller,
    this.wait,
    this.debounce,
    this.anchor,
    this.behavior,
    this.closeOnTapOutside = true,
    this.padding,
    this.decoration,
    this.shadows,
    this.requestFocusOnOpen = false,
  });

  final Widget child;
  final WidgetBuilder hoverBuilder;
  final MyPopoverController? controller;
  final Duration? wait;
  final Duration? debounce;
  final MyAnchorBase? anchor;
  final HitTestBehavior? behavior;
  final bool closeOnTapOutside;
  final EdgeInsetsGeometry? padding;
  final MyDecoration? decoration;
  final List<BoxShadow>? shadows;
  final bool requestFocusOnOpen;

  @override
  State<MyHoverCard> createState() => _MyHoverCardState();
}

class _MyHoverCardState extends State<MyHoverCard> {
  MyPopoverController? _controller;
  bool _triggerHovered = false;
  bool _contentHovered = false;
  int _hoverRevision = 0;
  Timer? _showTimer;
  Timer? _hideTimer;

  MyPopoverController get _effectiveController =>
      widget.controller ?? _controller!;

  Duration get _wait => widget.wait ?? const Duration(milliseconds: 250);

  Duration get _debounce =>
      widget.debounce ?? const Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) _controller = MyPopoverController();
  }

  @override
  void didUpdateWidget(covariant MyHoverCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller == widget.controller) return;

    if (widget.controller == null) {
      _controller = MyPopoverController(
        isOpen: oldWidget.controller?.isOpen ?? false,
      );
    } else {
      _controller?.dispose();
      _controller = null;
    }
  }

  @override
  void dispose() {
    _hoverRevision++;
    _showTimer?.cancel();
    _hideTimer?.cancel();
    _controller?.dispose();
    super.dispose();
  }

  void _handleTriggerEnter(PointerEnterEvent event) {
    _triggerHovered = true;
    _scheduleShow();
  }

  void _handleTriggerExit(PointerExitEvent event) {
    _triggerHovered = false;
    _scheduleHide();
  }

  void _handleContentEnter(PointerEnterEvent event) {
    _contentHovered = true;
    _hideTimer?.cancel();
    _hoverRevision++;
  }

  void _handleContentExit(PointerExitEvent event) {
    _contentHovered = false;
    _scheduleHide();
  }

  void _scheduleShow() {
    final revision = ++_hoverRevision;
    _hideTimer?.cancel();
    _showTimer?.cancel();
    _showTimer = Timer(_wait, () {
      if (!mounted || revision != _hoverRevision) return;
      if (_triggerHovered || _contentHovered) _effectiveController.show();
    });
  }

  void _scheduleHide() {
    final revision = ++_hoverRevision;
    _showTimer?.cancel();
    _hideTimer?.cancel();
    _hideTimer = Timer(_debounce, () {
      if (!mounted || revision != _hoverRevision) return;
      if (!_triggerHovered && !_contentHovered) _effectiveController.hide();
    });
  }

  void _showFromLongPress() {
    _hoverRevision++;
    _showTimer?.cancel();
    _hideTimer?.cancel();
    _effectiveController.show();
  }

  @override
  Widget build(BuildContext context) {
    return MyPopover(
      controller: _effectiveController,
      anchor:
          widget.anchor ??
          const MyAnchorAuto(
            offset: Offset(0, 8),
            targetAnchor: Alignment.bottomCenter,
            followerAnchor: Alignment.topCenter,
          ),
      closeOnTapOutside: widget.closeOnTapOutside,
      padding: widget.padding,
      decoration: widget.decoration,
      shadows: widget.shadows,
      requestFocusOnOpen: widget.requestFocusOnOpen,
      popover: (context) {
        return MouseRegion(
          onEnter: _handleContentEnter,
          onExit: _handleContentExit,
          child: widget.hoverBuilder(context),
        );
      },
      child: MouseRegion(
        hitTestBehavior: widget.behavior ?? HitTestBehavior.deferToChild,
        onEnter: _handleTriggerEnter,
        onExit: _handleTriggerExit,
        child: GestureDetector(
          behavior: widget.behavior,
          onLongPress: _showFromLongPress,
          child: widget.child,
        ),
      ),
    );
  }
}
