import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class _ClipShadowPainter extends CustomPainter {
  const _ClipShadowPainter({required this.clipper, required this.boxShadows});

  final CustomClipper<Path> clipper;
  final List<BoxShadow> boxShadows;

  @override
  void paint(Canvas canvas, Size size) {
    if (boxShadows.isEmpty || size.isEmpty) return;

    for (final shadow in boxShadows) {
      final spreadRadius = shadow.spreadRadius;
      final spreadSize = Size(
        (size.width + spreadRadius * 2).clamp(0.0, double.infinity),
        (size.height + spreadRadius * 2).clamp(0.0, double.infinity),
      );
      final clipPath = clipper
          .getClip(spreadSize)
          .shift(
            Offset(
              shadow.offset.dx - spreadRadius,
              shadow.offset.dy - spreadRadius,
            ),
          );
      canvas.drawPath(clipPath, shadow.toPaint());
    }
  }

  @override
  bool shouldRepaint(covariant _ClipShadowPainter oldDelegate) {
    return clipper != oldDelegate.clipper ||
        clipper.shouldReclip(oldDelegate.clipper) ||
        !listEquals(boxShadows, oldDelegate.boxShadows);
  }
}

class MyClipShadow extends StatelessWidget {
  const MyClipShadow({
    required this.boxShadow,
    required this.clipper,
    required this.child,
    super.key,
  });

  /// A list of shadows cast by this box behind the box.
  final List<BoxShadow> boxShadow;

  /// If non-null, determines which clip to use.
  final CustomClipper<Path> clipper;

  /// The [Widget] below this widget in the tree.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final clippedChild = ClipPath(
      clipper: clipper,
      child: RepaintBoundary(child: child),
    );

    if (boxShadow.isEmpty) return clippedChild;

    return CustomPaint(
      isComplex: true,
      painter: _ClipShadowPainter(boxShadows: boxShadow, clipper: clipper),
      child: clippedChild,
    );
  }
}
