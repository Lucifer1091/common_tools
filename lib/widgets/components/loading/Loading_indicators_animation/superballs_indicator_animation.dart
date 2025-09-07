import 'package:flutter/material.dart';
import 'dart:math';


class ChaoticOrbitLoaders extends StatefulWidget {
  const ChaoticOrbitLoaders({super.key});

  @override
  _ChaoticOrbitLoadersState createState() => _ChaoticOrbitLoadersState();
}

class _ChaoticOrbitLoadersState extends State<ChaoticOrbitLoaders>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
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
        child: SizedBox(
          width: 80,
          height: 80,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Stack(
                children: [
                  _buildElectron(angle: _controller.value * 2 * pi, isClockwise: true),
                  _buildElectron(angle: _controller.value * 2 * pi, isClockwise: false),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildElectron({required double angle, required bool isClockwise}) {
    final double orbitRadius = 30;
    final double offsetAngle = isClockwise ? pi / 4 : -pi / 4;
    return Transform.translate(
      offset: Offset(
        cos(angle + offsetAngle) * orbitRadius,
        sin(angle + offsetAngle) * orbitRadius,
      ),
      child: Align(
        alignment: Alignment.center,
        child: Container(
          width: 16,
          height: 16,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
