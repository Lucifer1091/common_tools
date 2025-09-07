import 'package:flutter/material.dart';
import 'dart:math' as math;

class BouncyLoader extends StatefulWidget {
  @override
  _BouncyLoaderState createState() => _BouncyLoaderState();
}

class _BouncyLoaderState extends State<BouncyLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1750),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            return AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, -50 * math.sin((_controller.value - (index * 0.2)) * 2 * math.pi)),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }
}
