import 'package:flutter/material.dart';

class Shimmer extends StatefulWidget {
  const Shimmer({
    super.key,
    this.height = 20,
    this.width = 200,
    this.radius = 4,
  });

  final double height;
  final double width;
  final double radius;

  @override
  ShimmerState createState() => ShimmerState();
}

class ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  late Animation<double> gradientPosition;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    gradientPosition = Tween<double>(begin: -3, end: 10).animate(
      CurvedAnimation(parent: _controller!, curve: Curves.linear),
    )..addListener(() {
      setState(() {});
    });

    _controller!.repeat();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.radius),
        gradient: LinearGradient(
          begin: Alignment(gradientPosition.value, 0),
          end: Alignment.centerLeft,
          colors:
              isDarkTheme
                  ? [
                    const Color(0x66000000),
                    const Color(0x99000000),
                    const Color(0x66000000),
                  ]
                  : [
                    const Color(0x0D000000),
                    const Color(0x1A000000),
                    const Color(0x0D000000),
                  ],
        ),
      ),
    );
  }
}
