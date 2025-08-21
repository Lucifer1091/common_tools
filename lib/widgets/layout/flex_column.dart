import 'package:flutter/widgets.dart';

import '../../index.dart';

/// A [FlexColumn] may be used in place of [Column].
class FlexColumn extends Flex {
  /// A [FlexColumn] may be used in place of [Column]. It has a [gap] property which ads a gap between the children.
  ///
  /// Example:
  /// ```dart
  /// FlexColumn(
  ///   gap: 16,
  ///   children: [
  ///     Container(
  ///       height: 100,
  ///       width: 100,
  ///       color: 'bada55'.toColor,
  ///     ),
  ///     Container(
  ///       height: 100,
  ///       width: 100,
  ///       color: '5eabed'.toColor,
  ///     ),
  ///     Container(
  ///       height: 100,
  ///       width: 100,
  ///       color: 'facade'.toColor,
  ///     ),
  ///   ],
  /// )
  /// ```
  FlexColumn({
    double gap = 0,
    bool reversed = false,
    List<Widget> children = const [],
    super.key,
    super.textDirection,
    super.textBaseline,
    super.clipBehavior,
    super.mainAxisSize,
    super.crossAxisAlignment,
    super.mainAxisAlignment,
    super.verticalDirection,
  }) : super(
         direction: Axis.vertical,
         children:
             (reversed ? children.reversed : children).indexed
                 .map((w) => gap > 0 && w.$1 > 0 ? [Gap(gap), w.$2] : [w.$2])
                 .expand((w) => w)
                 .toList(),
       );
}
