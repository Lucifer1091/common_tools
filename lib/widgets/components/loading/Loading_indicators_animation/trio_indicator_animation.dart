import 'package:flutter/material.dart';
import 'dart:math';

class TrioLoader extends StatefulWidget {
  final double size;
  final Color color;
  final Duration duration;

  const TrioLoader({
    Key? key,
    this.size = 40.0,
    this.color = Colors.black,
    this.duration = const Duration(milliseconds: 1300),
  }) : super(key: key);

  @override
  _TrioLoaderState createState() => _TrioLoaderState();
}

class _TrioLoaderState extends State<TrioLoader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.size,
      width: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.rotate(
            angle: _controller.value * 2 * pi,
            child: Stack(
              alignment: Alignment.center,
              children: List.generate(3, (index) {
                final angle = index * 2 * pi / 3;
                return Transform(
                  transform: Matrix4.identity()
                    ..translate(widget.size / 2 * cos(angle), widget.size / 2 * sin(angle)),
                  child: _Dot(color: widget.color, size: widget.size * 0.25, controller: _controller),
                );
              }),
            ),
          );
        },
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final Color color;
  final double size;
  final AnimationController controller;

  const _Dot({required this.color, required this.size, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final wobbleValue = sin(controller.value * 2 * pi) * (size * 0.65);
        return Transform.translate(
          offset: Offset(0, wobbleValue),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
}
