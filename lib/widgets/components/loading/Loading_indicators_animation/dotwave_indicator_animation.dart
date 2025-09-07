import 'package:flutter/material.dart';

class DotWaveLoader extends StatefulWidget {
  final double size;
  final Color color;
  final Duration duration;

  const DotWaveLoader({
    Key? key,
    this.size = 47.0,
    this.color = Colors.black,
    this.duration = const Duration(milliseconds: 1000),
  }) : super(key: key);

  @override
  _DotWaveLoaderState createState() => _DotWaveLoaderState();
}

class _DotWaveLoaderState extends State<DotWaveLoader>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();

    _controllers = List.generate(4, (index) {
      return AnimationController(
        vsync: this,
        duration: widget.duration,
      )..repeat(reverse: true);
    });

    _animations = List.generate(4, (index) {
      // Alternate motion: Even index starts low -> moves up, Odd index starts high -> moves down
      bool startsFromUp = index.isOdd;
      return Tween<double>(
        begin: startsFromUp ? -widget.size * 0.25 : widget.size * 0.25,
        end: startsFromUp ? widget.size * 0.25 : -widget.size * 0.25,
      ).animate(
        CurvedAnimation(
          parent: _controllers[index],
          curve: Interval(
            index * 0.15, // Delay each dot for wave effect
            1.0,
            curve: Curves.easeInOut,
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(4, (index) {
          return AnimatedBuilder(
            animation: _controllers[index],
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _animations[index].value),
                child: _buildDot(),
              );
            },
          );
        }),
      ),
    );
  }

  Widget _buildDot() {
    return Container(
      width: widget.size * 0.17,
      height: widget.size * 0.17,
      decoration: BoxDecoration(
        color: widget.color,
        shape: BoxShape.circle,
      ),
    );
  }
}
