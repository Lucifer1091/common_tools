import 'package:flutter/material.dart';

import '../../../extensions/context/theme.dart';

/// {@template modalDrawerHandle}
/// A customizable 'handle' intended for use with modal [BottomSheet] widgets.
/// {@endtemplate}
class ModalDrawerHandle extends StatelessWidget {
  /// {@macro modalDrawerHandle}
  const ModalDrawerHandle({
    super.key,
    this.rowAlignment = MainAxisAlignment.center,
    this.height = 5.0,
    this.width = 25.0,
    this.color,
    this.borderRadius = const BorderRadius.all(Radius.circular(10)),
  });

  /// The MainAxisAlignment of the Row that contains the handle.
  ///
  /// Defaults to [MainAxisAlignment.center]
  final MainAxisAlignment rowAlignment;

  /// The height of the handle. Defaults to `5.0`.
  final double height;

  /// The height of the handle.
  ///
  /// Defaults to `25.0`
  final double width;

  /// The color of the handle.
  ///
  /// Defaults to `#EEEEEE`
  final Color? color;

  /// The [BorderRadius] of the handle.
  ///
  /// Best used for rounding the corners of the handle. Defaults to
  /// `const BorderRadius.all(Radius.circular(10.0))`. Note that when using a
  /// custom [BorderRadius], you need to pass in a [Radius], not a double.
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: rowAlignment,
      children: <Widget>[
        Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: color ?? context.colorScheme.border,
            borderRadius: borderRadius,
          ),
        ),
      ],
    );
  }
}
