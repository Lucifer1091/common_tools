import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

/// Applies a backdrop blur behind this widget's paint bounds.
///
/// If you only need to blur the child itself, prefer [ImageFiltered] because
/// it is usually cheaper than a [BackdropFilter].
class MyBlur extends StatelessWidget {
  const MyBlur({
    super.key,
    this.child,
    this.height,
    this.width,
    this.blur = 5,
    this.elevation = 0,
    this.padding = EdgeInsets.zero,
    this.color = Colors.transparent,
    this.borderRadius,
    this.clipBehavior = Clip.antiAlias,
  }) : assert(blur >= 0, 'blur must be non-negative'),
       assert(elevation >= 0, 'elevation must be non-negative');

  final Widget? child;
  final double? height;
  final double? width;
  final double elevation;
  final double blur;
  final EdgeInsetsGeometry padding;
  final Color color;
  final BorderRadius? borderRadius;
  final Clip clipBehavior;

  static const _kMinVisibleBlur = 0.001;

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      height: height,
      width: width,
      padding: padding,
      color: color,
      child: child,
    );

    if (blur > _kMinVisibleBlur) {
      content = BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: content,
      );
    }

    if (clipBehavior != Clip.none) {
      final hasRoundedCorners =
          borderRadius != null && borderRadius != BorderRadius.zero;

      content = hasRoundedCorners
          ? ClipRRect(
              borderRadius: borderRadius!,
              clipBehavior: clipBehavior,
              child: content,
            )
          : ClipRect(clipBehavior: clipBehavior, child: content);
    }

    if (elevation <= 0) return content;

    return Material(
      elevation: elevation,
      color: Colors.transparent,
      borderRadius: borderRadius,
      child: content,
    );
  }
}
