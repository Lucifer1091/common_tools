import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../index.dart';

class MyBorderBeam extends StatefulWidget {
  const MyBorderBeam({
    required this.child,
    super.key,
    this.duration = const Duration(seconds: 5),
    this.borderWidth = 1.5,
    this.colorFrom = const Color(0xFFFFAA40),
    this.colorTo = const Color(0xFF9C40FF),
    this.staticBorderColor,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.padding = EdgeInsets.zero,
  }) : assert(borderWidth >= 0, 'borderWidth must be non-negative');

  final Widget child;
  final Duration duration;
  final double borderWidth;
  final Color colorFrom;
  final Color colorTo;
  final Color? staticBorderColor;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry padding;

  @override
  _MyBorderBeamState createState() => _MyBorderBeamState();
}

class _MyBorderBeamState extends State<MyBorderBeam>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    unawaited(_controller.repeat());
  }

  @override
  void didUpdateWidget(covariant MyBorderBeam oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (_controller.duration != widget.duration) {
      _controller.duration = widget.duration;
      if (_controller.isAnimating) {
        unawaited(_controller.repeat(min: _controller.value));
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _BorderBeamPainter(
        progress: _controller,
        borderWidth: widget.borderWidth,
        colorFrom: widget.colorFrom,
        colorTo: widget.colorTo,
        staticBorderColor:
            widget.staticBorderColor ?? context.colorScheme.border,
        borderRadius: widget.borderRadius,
      ),
      isComplex: true,
      willChange: true,
      child: Padding(
        padding: widget.padding,
        child: RepaintBoundary(child: widget.child),
      ),
    );
  }
}

class _BorderBeamPainter extends CustomPainter {
  _BorderBeamPainter({
    required this.progress,
    required this.borderWidth,
    required this.colorFrom,
    required this.colorTo,
    required this.staticBorderColor,
    required this.borderRadius,
  }) : _staticPaint =
           Paint()
             ..style = PaintingStyle.stroke
             ..isAntiAlias = true,
       _beamPaint =
           Paint()
             ..style = PaintingStyle.stroke
             ..isAntiAlias = true,
       super(repaint: progress);

  final Animation<double> progress;
  final double borderWidth;
  final Color colorFrom;
  final Color colorTo;
  final Color staticBorderColor;
  final BorderRadius borderRadius;
  final Paint _staticPaint;
  final Paint _beamPaint;

  static const _beamCoverage = 0.25;
  static const _gradientCoverage = 0.125;

  Size? _cachedSize;
  late RRect _cachedRRect;
  late ui.PathMetric _cachedMetric;
  late double _cachedPathLength;

  void _updateCachedGeometry(Size size) {
    if (_cachedSize == size) return;

    final rect = Offset.zero & size;
    _cachedRRect = borderRadius.toRRect(rect);
    final path = Path()..addRRect(_cachedRRect);
    _cachedMetric = path.computeMetrics().first;
    _cachedPathLength = _cachedMetric.length;
    _cachedSize = size;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty || borderWidth <= 0) return;

    _updateCachedGeometry(size);

    _staticPaint
      ..strokeWidth = borderWidth
      ..color = staticBorderColor;
    canvas.drawRRect(_cachedRRect, _staticPaint);

    final pathLength = _cachedPathLength;
    final animationProgress = progress.value % 1.0;
    final start = animationProgress * pathLength;
    final end = (start + pathLength * _beamCoverage) % pathLength;

    Path extractPath;
    if (end > start) {
      extractPath = _cachedMetric.extractPath(start, end);
    } else {
      extractPath = _cachedMetric.extractPath(start, pathLength)
        ..addPath(_cachedMetric.extractPath(0, end), Offset.zero);
    }

    final gradientStart =
        _cachedMetric.getTangentForOffset(start)?.position ?? Offset.zero;
    final gradientEnd =
        _cachedMetric
            .getTangentForOffset(
              (start + pathLength * _gradientCoverage) % pathLength,
            )
            ?.position ??
        Offset.zero;

    _beamPaint
      ..strokeWidth = borderWidth
      ..shader = ui.Gradient.linear(
        gradientStart,
        gradientEnd,
        [colorTo.withValues(alpha: 0), colorTo, colorFrom],
        const [0.0, 0.3, 1.0],
      );

    canvas.drawPath(extractPath, _beamPaint);
  }

  @override
  bool shouldRepaint(covariant _BorderBeamPainter oldDelegate) {
    return oldDelegate.borderWidth != borderWidth ||
        oldDelegate.colorFrom != colorFrom ||
        oldDelegate.colorTo != colorTo ||
        oldDelegate.staticBorderColor != staticBorderColor ||
        oldDelegate.borderRadius != borderRadius ||
        oldDelegate.progress != progress;
  }
}
