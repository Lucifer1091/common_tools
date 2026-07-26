import 'package:flutter/material.dart';

import '../../extensions/context/theme.dart';
import '../common/my_gesture_detector.dart';

class MyPageIndicator extends StatelessWidget {
  const MyPageIndicator({
    required this.length,
    required this.currentIndex,
    super.key,
    this.onTap,
    this.spacing = 4,
    this.alignment = Alignment.center,
    this.padding = EdgeInsets.zero,
    this.duration = Durations.short4,
    this.curve = Curves.linear,
    this.selectedColor,
    this.unselectedColor,
    this.width,
    this.height,
    this.selectedHeight,
    this.selectedWidth,
    this.borderRadius,
    this.shrinkIndicator = false,
  });

  final int length;
  final int currentIndex;
  final ValueChanged<int>? onTap;
  final double spacing;
  final AlignmentGeometry alignment;
  final EdgeInsetsGeometry padding;
  final Duration duration;
  final Curve curve;
  final Color? selectedColor;
  final Color? unselectedColor;
  final double? width;
  final double? height;
  final double? selectedHeight;
  final double? selectedWidth;
  final BorderRadiusGeometry? borderRadius;

  /// When true, inactive bars use the indicator height as their width.
  final bool shrinkIndicator;

  @override
  Widget build(BuildContext context) {
    if (length <= 0) return const SizedBox.shrink();

    final selectedIndex = _normalizedIndex();
    final gap = spacing < 0 ? 0.0 : spacing;

    return Padding(
      padding: padding,
      child: Align(
        alignment: alignment,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: gap,
          children: [
            for (int index = 0; index < length; index++) ...[
              _buildIndicator(context, index, index == selectedIndex),
            ],
          ],
        ),
      ),
    );
  }

  int _normalizedIndex() {
    if (currentIndex < 0) return 0;
    if (currentIndex >= length) return length - 1;
    return currentIndex;
  }

  Widget _buildIndicator(BuildContext context, int index, bool isSelected) {
    final indicatorHeight = _resolvedHeight(isSelected);
    final indicatorWidth = _resolvedWidth(isSelected, indicatorHeight);

    final Widget indicator = AnimatedContainer(
      duration: duration,
      curve: curve,
      height: indicatorHeight,
      width: indicatorWidth,
      decoration: BoxDecoration(
        color: _resolvedColor(context, isSelected),
        borderRadius:
            borderRadius ?? BorderRadius.circular(indicatorHeight / 2),
      ),
    );

    final tapHandler = onTap;
    if (tapHandler == null) return indicator;

    return Semantics(
      button: true,
      selected: isSelected,
      label: 'Indicator ${index + 1} of $length',
      child: MyGestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => tapHandler(index),
        child: indicator,
      ),
    );
  }

  Color _resolvedColor(BuildContext context, bool isSelected) {
    if (isSelected) {
      return selectedColor ?? context.colorScheme.primary;
    }

    if (unselectedColor != null) return unselectedColor!;

    return context.colorScheme.secondary;
  }

  double _resolvedHeight(bool isSelected) {
    if (isSelected && selectedHeight != null) return selectedHeight!;

    return height ?? (shrinkIndicator ? 6 : 4);
  }

  double _resolvedWidth(bool isSelected, double resolvedHeight) {
    if (isSelected && selectedWidth != null) return selectedWidth!;

    if (!shrinkIndicator) return width ?? 20;
    return isSelected ? width ?? 30 : resolvedHeight;
  }
}
