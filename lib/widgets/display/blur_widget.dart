import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

/// Blur any widget
class Blur extends StatelessWidget {
  const Blur({
    this.child,
    this.height,
    this.width,
    this.blur = 5,
    this.elevation = 0,
    this.padding = EdgeInsets.zero,
    this.color = Colors.transparent,
    this.borderRadius,
    this.clipBehavior = Clip.antiAlias,
    super.key,
  });

  final Widget? child;
  final double? height;
  final double? width;
  final double elevation;
  final double blur;
  final EdgeInsetsGeometry padding;
  final Color color;
  final BorderRadius? borderRadius;
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: elevation,
      color: Colors.transparent,
      borderRadius: borderRadius,
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        clipBehavior: clipBehavior,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            height: height,
            width: width,
            padding: padding,
            color: color,
            child: child,
          ),
        ),
      ),
    );
  }
}

class BlurWidget extends StatelessWidget {
  const BlurWidget({
    required this.child,
    super.key,
    this.sigma = 1.5,
    this.enabled = true,
  });
  final bool enabled;
  final Widget child;
  final double sigma;

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;

    return Stack(
      children: [
        child,
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
                child: Container(color: Colors.black.withValues(alpha: 0)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
