import 'package:flutter/material.dart';
import '../../../index.dart';

typedef MyPickerItemBuilder =
    Widget? Function(
      /// Context
      BuildContext context,

      /// Text content
      String content,

      /// Column number
      int colIndex,

      /// Row number
      int index,

      /// Calculate font color, transparency, thickness based on distance
      ItemDistanceCalculator itemDistanceCalculator,

      /// The distance of the subitem from the center at this time
      double distance,
    );

/// All selector subcomponents
class MyPickerItem extends StatefulWidget {
  const MyPickerItem({
    required this.fixedExtentScrollController,
    required this.colIndex,
    required this.index,
    required this.content,
    required this.itemHeight,
    this.itemDistanceCalculator,
    this.itemBuilder,
    super.key,
  });

  final String content;
  final FixedExtentScrollController fixedExtentScrollController;
  final int colIndex;
  final int index;
  final double itemHeight;
  final ItemDistanceCalculator? itemDistanceCalculator;
  final MyPickerItemBuilder? itemBuilder;

  @override
  _MyPickerItemState createState() => _MyPickerItemState();
}

class _MyPickerItemState extends State<MyPickerItem> {
  /// The child item listens to scrolling to refresh its own color
  VoidCallback? listener;
  ItemDistanceCalculator? _itemDistanceCalculator;

  @override
  void initState() {
    super.initState();
    listener = () => setState(() {});
    _itemDistanceCalculator = widget.itemDistanceCalculator;

    /// Sub-item registration scrolling monitor
    widget.fixedExtentScrollController.addListener(listener!);
  }

  @override
  Widget build(BuildContext context) {
    /// The distance of the child item from the center at this time
    /// Do not use widget.fixedExtentScrollController.selectedItem
    /// The selectedItem will report an error because minScrollExtent is empty at the beginning
    final distance =
        (widget.fixedExtentScrollController.offset / widget.itemHeight -
                widget.index)
            .abs();

    _itemDistanceCalculator ??= ItemDistanceCalculator();

    return widget.itemBuilder?.call(
          context,
          widget.content,
          widget.colIndex,
          widget.index,
          _itemDistanceCalculator!,
          distance,
        ) ??
        MyText(
          widget.content,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: _itemDistanceCalculator!.calculateFontWeight(
              context,
              distance,
            ),
            fontSize: _itemDistanceCalculator!.calculateFont(context, distance),
            color: _itemDistanceCalculator!.calculateColor(context, distance),
          ),
        );
  }

  @override
  void dispose() {
    /// Complete monitoring cancellation before destruction
    widget.fixedExtentScrollController.removeListener(listener!);
    super.dispose();
  }
}

class ItemDistanceCalculator {
  ItemDistanceCalculator();

  Color calculateColor(BuildContext context, double distance) {
    /// Linear interpolation
    if (distance < 0.5) {
      return context.colorScheme.popoverForeground;
    } else {
      return context.colorScheme.popoverForeground.withValues(alpha: 0.5);
    }
  }

  FontWeight calculateFontWeight(BuildContext context, double distance) {
    if (distance < 0.5) {
      return FontWeight.w600;
    } else {
      return FontWeight.w400;
    }
  }

  double calculateFont(BuildContext context, double distance) {
    return context.bodyLarge.fontSize ?? 14;
  }
}
