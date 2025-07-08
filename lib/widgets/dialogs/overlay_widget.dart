import 'dart:async';

import 'package:flutter/material.dart';

/// Show custom widget on a widget click
class OverlayCustomWidget extends StatelessWidget {
  const OverlayCustomWidget({
    required this.overlayBuilder,
    required this.child,
    super.key,
    this.showOverlay = false,
  });

  final bool showOverlay;
  final Widget Function(BuildContext, Offset anchor) overlayBuilder;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return OverlayBuilder(
          showOverlay: showOverlay,
          overlayBuilder: (BuildContext overlayContext) {
            final RenderBox box = context.findRenderObject()! as RenderBox;
            final center = box.size.center(box.localToGlobal(Offset.zero));

            return overlayBuilder(overlayContext, center);
          },
          child: child,
        );
      },
    );
  }
}

/// OverlayBuilder widget
class OverlayBuilder extends StatefulWidget {
  const OverlayBuilder({
    super.key,
    this.showOverlay = false,
    this.overlayBuilder,
    this.child,
  });
  final bool showOverlay;
  final Widget Function(BuildContext)? overlayBuilder;
  final Widget? child;

  @override
  _OverlayBuilderState createState() => _OverlayBuilderState();
}

class _OverlayBuilderState extends State<OverlayBuilder> {
  OverlayEntry? overlayEntry;

  @override
  void initState() {
    super.initState();

    if (widget.showOverlay) {
      WidgetsBinding.instance.addPostFrameCallback((_) => showOverlay());
    }
  }

  @override
  void didUpdateWidget(OverlayBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);

    WidgetsBinding.instance.addPostFrameCallback((_) => syncWidgetAndOverlay());
  }

  @override
  void reassemble() {
    super.reassemble();

    WidgetsBinding.instance.addPostFrameCallback((_) => syncWidgetAndOverlay());
  }

  @override
  void dispose() {
    if (isShowingOverlay()) hideOverlay();

    super.dispose();
  }

  bool isShowingOverlay() => overlayEntry != null;

  void showOverlay() {
    overlayEntry = OverlayEntry(builder: widget.overlayBuilder!);
    unawaited(addToOverlay(overlayEntry!));
  }

  Future<void> addToOverlay(OverlayEntry entry) async {
    Overlay.of(context).insert(entry);
  }

  void hideOverlay() {
    overlayEntry!.remove();
    overlayEntry = null;
  }

  void syncWidgetAndOverlay() {
    if (isShowingOverlay() && !widget.showOverlay) {
      hideOverlay();
    } else if (!isShowingOverlay() && widget.showOverlay) {
      showOverlay();
    }
  }

  @override
  Widget build(BuildContext context) => widget.child!;
}

/// OverlayOffsetWidget
class OverlayOffsetWidget extends StatelessWidget {
  const OverlayOffsetWidget({super.key, this.position, this.child});

  final Offset? position;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: position!.dy,
      left: position!.dx,
      child: FractionalTranslation(
        translation: const Offset(-0.5, -0.5),
        child: child,
      ),
    );
  }
}
