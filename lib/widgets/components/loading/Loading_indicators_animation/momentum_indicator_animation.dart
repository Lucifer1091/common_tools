import 'dart:math';
import 'package:flutter/material.dart';

class MomentumLoader extends StatefulWidget {
  final double size;
  final Color color;
  final Duration duration;

  const MomentumLoader({
    Key? key,
    this.size = 40.0,
    this.color = Colors.black,
    this.duration = const Duration(milliseconds: 1100),
  }) : super(key: key);

  @override
  _MomentumLoaderState createState() => _MomentumLoaderState();
}

class _MomentumLoaderState extends State<MomentumLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotation;
  late Animation<double> _wobble1;
  late Animation<double> _wobble2;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();

    _rotation = Tween<double>(begin: 0, end: 2 * pi).animate(_controller);

    _wobble1 = Tween<double>(begin: -widget.size * 0.2, end: widget.size * 0.2)
        .animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _wobble2 = Tween<double>(begin: widget.size * 0.2, end: -widget.size * 0.2)
        .animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
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
          return Transform.rotate(
            angle: _rotation.value,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Transform.translate(
                  offset: Offset(_wobble1.value, 0),
                  child: _buildDot(),
                ),
                SizedBox(width: widget.size * 0.1),
                Transform.translate(
                  offset: Offset(_wobble2.value, 0),
                  child: _buildDot(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDot() {
    return Container(
      width: widget.size * 0.25,
      height: widget.size * 0.25,
      decoration: BoxDecoration(
        color: widget.color,
        shape: BoxShape.circle,
      ),
    );
  }
}
