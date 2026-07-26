import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class MyDraggableDialog extends StatefulWidget {
  const MyDraggableDialog({
    super.key,
    this.onDrag,
    this.child,
    this.autoCenter = true,
    this.enableDragAnimation = true,
    this.keepInBounds = true,
    this.dialogLeft,
    this.dialogTop,
  });

  final void Function(double x, double y)? onDrag;
  final Widget? child;
  final bool enableDragAnimation;
  final bool autoCenter;
  final bool keepInBounds;
  final double? dialogLeft;
  final double? dialogTop;

  @override
  MyDraggableDialogState createState() => MyDraggableDialogState();
}

class MyDraggableDialogState extends State<MyDraggableDialog> {
  bool _dragging = false;
  double _xOffset = -1;
  double _yOffset = -1;
  Size _dialogSize = Size.zero;
  final widgetKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback(postFrameCallback);
  }

  void postFrameCallback(_) {
    final context = widgetKey.currentContext;
    if (context == null) return;

    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox != null && _dialogSize == Size.zero) {
      _dialogSize = renderBox.size;
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);

    if (_dialogSize != Size.zero && widget.autoCenter && _xOffset == -1) {
      _xOffset = (screenSize.width - _dialogSize.width) / 2;
      _yOffset = (screenSize.height - _dialogSize.height) / 2;
    } else {
      if (_xOffset == -1 &&
          widget.dialogLeft != null &&
          widget.dialogTop != null) {
        _xOffset = widget.dialogLeft!;
        _yOffset = widget.dialogTop!;
      }
    }

    return Opacity(
      opacity: (widget.autoCenter && _dialogSize == Size.zero) ? 0 : 1,
      child: Stack(
        children: [
          Positioned(
            left: _xOffset == -1 ? 0 : _xOffset,
            top: _yOffset == -1 ? 0 : _yOffset,
            child: GestureDetector(
              onPanStart: (_) {
                if (mounted) setState(() => _dragging = true);
              },
              onPanUpdate: (details) {
                if (!mounted) return;

                _xOffset += details.delta.dx;
                _yOffset += details.delta.dy;

                if (widget.keepInBounds && _dialogSize != Size.zero) {
                  final maxX = screenSize.width - _dialogSize.width;
                  final maxY = screenSize.height - _dialogSize.height;

                  // Only clamp if dialog fits within screen
                  if (maxX > 0) {
                    _xOffset = _xOffset.clamp(0.0, maxX);
                  } else {
                    // Dialog is wider than screen — stick to 0
                    _xOffset = 0.0;
                  }

                  if (maxY > 0) {
                    _yOffset = _yOffset.clamp(0.0, maxY);
                  } else {
                    // Dialog is taller than screen — stick to 0
                    _yOffset = 0.0;
                  }
                }

                widget.onDrag?.call(_xOffset, _yOffset);
                setState(() {});
              },
              onPanEnd: (_) {
                if (widget.keepInBounds && _dialogSize != Size.zero) {
                  final maxX = screenSize.width - _dialogSize.width;
                  final maxY = screenSize.height - _dialogSize.height;

                  // Only clamp if dialog fits within screen
                  if (maxX > 0) {
                    _xOffset = _xOffset.clamp(0.0, maxX);
                  } else {
                    // Dialog is wider than screen — stick to 0
                    _xOffset = 0.0;
                  }

                  if (maxY > 0) {
                    _yOffset = _yOffset.clamp(0.0, maxY);
                  } else {
                    // Dialog is taller than screen — stick to 0
                    _yOffset = 0.0;
                  }
                }

                if (mounted) setState(() => _dragging = false);
              },
              child: AnimatedOpacity(
                duration: Duration(milliseconds: _dragging ? 0 : 400),
                opacity: _dragging && widget.enableDragAnimation ? 0.8 : 1.0,
                child: LayoutBuilder(
                  key: widgetKey,
                  builder: (_, _) {
                    return widget.child ??
                        const SizedBox(height: 100, width: 100);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
