import 'package:flutter/material.dart';

import '../../index.dart';

enum MyPageIndicatorType { dot, bar }

/// A generic page indicator that can render dots or bars.
///
/// Pass [onTap] to make the indicators interactive. Without [onTap], the
/// widget is purely visual and can be driven by any external indexed state.
class MyPageIndicator extends StatelessWidget {
  const MyPageIndicator({
    required this.length,
    required this.currentIndex,
    super.key,
    this.type = MyPageIndicatorType.dot,
    this.onTap,
    this.spacing = 8,
    this.alignment = Alignment.center,
    this.padding = EdgeInsets.zero,
    this.duration = Durations.short4,
    this.curve = Curves.linear,
    this.selectedColor,
    this.unselectedColor,
    this.size,
    this.selectedSize,
    this.selectedWidth,
    this.boxShape,
    this.selectedBoxShape,
    this.borderRadius,
    this.selectedBorderRadius,
    this.width,
    this.height,
    this.shrinkIndicator = false,
  });

  final int length;
  final int currentIndex;
  final MyPageIndicatorType type;
  final ValueChanged<int>? onTap;
  final double spacing;
  final AlignmentGeometry alignment;
  final EdgeInsetsGeometry padding;
  final Duration duration;
  final Curve curve;
  final Color? selectedColor;
  final Color? unselectedColor;

  /// Dot size when [type] is [MyPageIndicatorType.dot].
  final double? size;

  /// Selected dot height when [type] is [MyPageIndicatorType.dot].
  final double? selectedSize;

  /// Selected dot width when [type] is [MyPageIndicatorType.dot].
  final double? selectedWidth;
  final BoxShape? boxShape;
  final BoxShape? selectedBoxShape;
  final BorderRadiusGeometry? borderRadius;
  final BorderRadiusGeometry? selectedBorderRadius;

  /// Bar width when [type] is [MyPageIndicatorType.bar].
  final double? width;

  /// Bar height when [type] is [MyPageIndicatorType.bar].
  final double? height;

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
    final indicatorShape = _resolvedShape(isSelected);

    Widget indicator = AnimatedContainer(
      duration: duration,
      curve: curve,
      height: indicatorHeight,
      width: indicatorWidth,
      decoration: BoxDecoration(
        color: _resolvedColor(context, isSelected),
        shape: indicatorShape,
        borderRadius: _resolvedBorderRadius(
          isSelected,
          indicatorShape,
          indicatorHeight,
        ),
      ),
    );

    if (type == MyPageIndicatorType.dot) {
      indicator = SizedBox(
        width: _dotSlotWidth,
        height: _dotSlotHeight,
        child: Center(child: indicator),
      );
    }

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

    if (type == MyPageIndicatorType.dot) {
      return context.colorScheme.mutedForeground.withValues(alpha: 0.4);
    }

    return context.colorScheme.primary.withValues(alpha: 0.16);
  }

  double _resolvedHeight(bool isSelected) {
    if (type == MyPageIndicatorType.bar) {
      return height ?? (shrinkIndicator ? 5 : 3);
    }

    if (isSelected) return selectedSize ?? size ?? 14;

    return size ?? 8;
  }

  double _resolvedWidth(bool isSelected, double resolvedHeight) {
    if (type == MyPageIndicatorType.bar) {
      if (!shrinkIndicator) return width ?? 30;
      return isSelected ? width ?? 40 : resolvedHeight;
    }

    if (isSelected) return selectedWidth ?? selectedSize ?? size ?? 14;

    return size ?? 8;
  }

  double get _dotSlotWidth {
    final inactiveWidth = size ?? 8;
    final activeWidth = selectedWidth ?? selectedSize ?? size ?? 14;
    return activeWidth > inactiveWidth ? activeWidth : inactiveWidth;
  }

  double get _dotSlotHeight {
    final inactiveHeight = size ?? 8;
    final activeHeight = selectedSize ?? size ?? 14;
    return activeHeight > inactiveHeight ? activeHeight : inactiveHeight;
  }

  BoxShape _resolvedShape(bool isSelected) {
    if (type == MyPageIndicatorType.bar) return BoxShape.rectangle;

    if (isSelected) {
      if (selectedBoxShape != null) return selectedBoxShape!;
      if (selectedBorderRadius != null || selectedWidth != null) {
        return BoxShape.rectangle;
      }
      return BoxShape.circle;
    }

    if (boxShape != null) return boxShape!;
    if (borderRadius != null) return BoxShape.rectangle;

    return BoxShape.circle;
  }

  BorderRadiusGeometry? _resolvedBorderRadius(
    bool isSelected,
    BoxShape shape,
    double resolvedHeight,
  ) {
    if (shape == BoxShape.circle) return null;

    if (type == MyPageIndicatorType.bar) {
      return BorderRadius.circular(resolvedHeight / 2);
    }

    return isSelected
        ? selectedBorderRadius ?? BorderRadius.circular(resolvedHeight / 2)
        : borderRadius ?? BorderRadius.circular(resolvedHeight / 2);
  }
}
