import 'package:flutter/material.dart';

class PreventMultiTap extends StatefulWidget {
  const PreventMultiTap({
    super.key,
    required this.child,
    required this.onSafeTap,
    this.intervalMs = 250,
  });

  final Widget child;
  final VoidCallback? onSafeTap;
  final int intervalMs;

  @override
  PreventMultiTapState createState() => PreventMultiTapState();
}

class PreventMultiTapState extends State<PreventMultiTap> {
  int lastTimeClicked = 0;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        // TODO: For horizontal drag behaviour uncomment the code below

        // onHorizontalDragUpdate: (dragStartDetails) {
        //   if (dragStartDetails.delta.dx < -20) {
        //     log.e(dragStartDetails.delta.dx);
        //     final now = DateTime.now().millisecondsSinceEpoch;
        //     if (now - lastTimeClicked < widget.intervalMs) {
        //       return;
        //     }
        //     lastTimeClicked = now;
        //     widget.onSafeTap();
        //   }
        // },
        onTap: () {
          final now = DateTime.now().millisecondsSinceEpoch;
          if (now - lastTimeClicked < widget.intervalMs) {
            return;
          }
          lastTimeClicked = now;
          widget.onSafeTap?.call();
        },
        child: widget.child,
      ),
    );
  }
}
