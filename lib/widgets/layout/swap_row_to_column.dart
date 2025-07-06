import 'package:flutter/material.dart';

/// A widget that displays its children in a row or column based on the value of isVertical (toggle switch type).
class SwapRowToColumn extends StatelessWidget {
  const SwapRowToColumn({
    required this.children,
    required this.isVertical,
    super.key,
    this.isColumnToRow,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  final List<Widget> children;
  final bool isVertical;
  final bool? isColumnToRow;

  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return ((isColumnToRow ?? false) ? isVertical : !isVertical)
        ? Row(
          mainAxisAlignment: mainAxisAlignment,
          mainAxisSize: mainAxisSize,
          crossAxisAlignment: crossAxisAlignment,
          children: children,
        )
        : Column(
          mainAxisAlignment: mainAxisAlignment,
          mainAxisSize: mainAxisSize,
          crossAxisAlignment: crossAxisAlignment,
          children: children,
        );
  }
}
