// ignore: file_names
import 'dart:math';
import 'package:flutter/material.dart';

/// A one-of-a-kind dynamic loader combining ripples, rotation wobble,
/// color-shifting gradients, and a pulsing central icon.
class TanyaLoader extends StatefulWidget {
  const TanyaLoader({
    super.key,
    this.rippleCount = 4,
    this.size = 100,
    this.icon = Icons.shopping_cart,
    this.colors = const [Colors.black, Colors.grey],
    this.duration = const Duration(seconds: 3),
  });

  /// Number of ripple rings
  final int rippleCount;

  /// Base size of the widget (width == height)
  final double size;

  /// Base icon in center
  final IconData icon;

  /// List of colors for gradient animation
  final List<Color> colors;

  /// Duration of full animation cycle
  final Duration duration;

  @override
  // ignore: library_private_types_in_public_api
  _OneOfAKindLoaderState createState() => _OneOfAKindLoaderState();
}

class _OneOfAKindLoaderState extends State<TanyaLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final progress = _controller.value;
          // Wobble rotation: ±5 degrees
          final wobble = sin(progress * 2 * pi) * (pi / 36);
          return Transform.rotate(
            angle: wobble,
            child: CustomPaint(
              painter: _GradientRipplePainter(
                progress: progress,
                rippleCount: widget.rippleCount,
                colors: widget.colors,
              ),
              child: Center(
                child: Transform.scale(
                  scale: 0.8 + 0.2 * sin(progress * 2 * pi),
                  child: Icon(
                    widget.icon,
                    size: widget.size * 0.3,
                    color: widget.colors.first,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _GradientRipplePainter extends CustomPainter {
  _GradientRipplePainter({
    required this.progress,
    required this.rippleCount,
    required this.colors,
  });
  
  final double progress;
  final int rippleCount;
  final List<Color> colors;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final maxRadius = size.width / 2;
    final baseStroke = size.width * 0.04;

    for (int i = 0; i < rippleCount; i++) {
      final fraction = (progress + i / rippleCount) % 1.0;
      final radius = maxRadius * fraction;
      final stroke = baseStroke * (1 - fraction) + 1;
      final alpha = ((1 - fraction) * 255).clamp(0, 255).toInt();

      // Gradient from color1 to color2 per ripple
      final paint =
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = stroke
            ..shader = SweepGradient(
              colors: colors.map((c) => c.withAlpha(alpha)).toList(),
            ).createShader(
              Rect.fromCircle(center: center, radius: radius + stroke),
            );

      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GradientRipplePainter old) {
    return old.progress != progress || old.colors != colors;
  }
}
