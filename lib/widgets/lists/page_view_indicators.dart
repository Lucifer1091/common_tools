import 'package:flutter/material.dart';

class PageViewIndicators extends StatelessWidget {
  const PageViewIndicators({
    required this.index,
    required this.length,
    super.key,
    this.space,
    this.width,
    this.height,
    this.shrinkIndicator = false,
    this.selectedColor,
    this.unselectedColor,
  });

  final int index;
  final int length;
  final double? space;
  final double? width;
  final double? height;
  final bool shrinkIndicator;
  final Color? selectedColor;
  final Color? unselectedColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          length,
          (index) => Container(
            margin: EdgeInsets.only(right: space ?? 8),
            child: _buildIndicator(index),
          ),
        ),
      ),
    );
  }

  AnimatedContainer _buildIndicator(int i) {
    return AnimatedContainer(
      duration: Durations.short4,
      height: _height,
      width: _width(i),
      decoration: BoxDecoration(
        color: i == index ? _selected : _unselected,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }

  Color get _selected => selectedColor ?? Colors.blue;

  Color get _unselected => unselectedColor ?? Colors.grey;

  double _width(int i) =>
      shrinkIndicator
          ? i == index
              ? width ?? 40
              : height ?? 5
          : width ?? 30;

  double get _height => height ?? (shrinkIndicator ? 5 : 3);
}
