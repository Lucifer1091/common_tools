import 'package:flutter/material.dart';

/// Defines a direction along an axis, either vertical or horizontal.
///
/// This is similar to [AxisDirection] but includes support for directional
/// values (start/end) that resolve based on [TextDirection].
enum AxisDirectional {
  /// Up direction.
  up,

  /// Down direction.
  down,

  /// Start direction (left in LTR, right in RTL).
  start,

  /// End direction (right in LTR, left in RTL).
  end;

  /// Resolves the directional axis to a concrete [AxisDirection] based on the text direction.
  ///
  /// Parameters:
  /// - [textDirection] (`TextDirection`, required): The text direction to resolve against.
  ///
  /// Returns:
  /// An [AxisDirection] corresponding to the resolved direction.
  AxisDirection resolve(TextDirection textDirection) {
    return switch ((this, textDirection)) {
      (AxisDirectional.up, _) => AxisDirection.up,
      (AxisDirectional.down, _) => AxisDirection.down,
      (AxisDirectional.start, TextDirection.ltr) => AxisDirection.left,
      (AxisDirectional.start, TextDirection.rtl) => AxisDirection.right,
      (AxisDirectional.end, TextDirection.ltr) => AxisDirection.right,
      (AxisDirectional.end, TextDirection.rtl) => AxisDirection.left,
    };
  }

  /// Returns the reversed direction.
  AxisDirectional get reversed => switch (this) {
    AxisDirectional.up => AxisDirectional.down,
    AxisDirectional.down => AxisDirectional.up,
    AxisDirectional.start => AxisDirectional.end,
    AxisDirectional.end => AxisDirectional.start,
  };
}

/// Base class for axis-based insets.
///
/// This allows defining insets along a single axis (start/end) which can be
/// resolved to concrete values based on [TextDirection].
abstract class AxisInsetsGeometry {
  /// Creates an [AxisInsetsGeometry].
  const AxisInsetsGeometry();

  /// Resolves the insets to a concrete [AxisInsets] based on the text direction.
  ///
  /// Parameters:
  /// - [textDirection] (`TextDirection`, required): The text direction to resolve against.
  ///
  /// Returns:
  /// An [AxisInsets] with resolved start/end values.
  AxisInsets resolve(TextDirection textDirection);
}

/// Insets along an axis with support for directionality.
class AxisInsets extends AxisInsetsGeometry {
  /// The text direction, if any.
  final TextDirection? direction;

  /// The start value.
  final double start;

  /// The end value.
  final double end;

  /// Creates an [AxisInsets].
  ///
  /// Parameters:
  /// - [start] (`double`, required): The start value.
  /// - [end] (`double`, required): The end value.
  const AxisInsets({required this.start, required this.end}) : direction = null;
  const AxisInsets._(this.start, this.end, this.direction);

  /// Resolves the start and end values for a specific axis.
  ///
  /// Parameters:
  /// - [axis] (`Axis`, required): The axis to resolve for.
  ///
  /// Returns:
  /// A record containing the start and end values.
  ({double start, double end}) resolveValue(Axis axis) {
    return switch ((direction, axis)) {
      (TextDirection.ltr, Axis.horizontal) => (start: start, end: end),
      (TextDirection.rtl, Axis.horizontal) => (start: end, end: start),
      _ => (start: start, end: end),
    };
  }

  @override
  AxisInsets resolve(TextDirection textDirection) {
    return AxisInsets._(start, end, textDirection);
  }
}

/// Directional insets along an axis.
///
/// These insets are defined as start and end, and resolve to left/right or
/// right/left based on the [TextDirection].
class AxisInsetsDirectional extends AxisInsetsGeometry {
  /// The start value.
  final double start;

  /// The end value.
  final double end;

  /// Creates an [AxisInsetsDirectional].
  ///
  /// Parameters:
  /// - [start] (`double`, required): The start value.
  /// - [end] (`double`, required): The end value.
  const AxisInsetsDirectional({required this.start, required this.end});

  @override
  AxisInsets resolve(TextDirection textDirection) {
    return AxisInsets._(start, end, textDirection);
  }
}

/// Base class for axis-based alignment.
///
/// This allows defining alignment along a single axis which can be
/// resolved to concrete values based on [TextDirection].
abstract class AxisAlignmentGeometry {
  /// Creates an [AxisAlignmentGeometry].
  const AxisAlignmentGeometry();

  /// Resolves the alignment to a concrete [AxisAlignment] based on the text direction.
  ///
  /// Parameters:
  /// - [textDirection] (`TextDirection`, required): The text direction to resolve against.
  ///
  /// Returns:
  /// An [AxisAlignment] corresponding to the resolved alignment.
  AxisAlignment resolve(TextDirection textDirection);
}

/// Alignment along an axis.
///
/// Values range from -1.0 (start/left/top) to 1.0 (end/right/bottom).
class AxisAlignment extends AxisAlignmentGeometry {
  /// Alignment to the left (-1.0).
  static const AxisAlignment left = AxisAlignment(-1.0);

  /// Alignment to the right (1.0).
  static const AxisAlignment right = AxisAlignment(1.0);

  /// Alignment to the center (0.0).
  static const AxisAlignment center = AxisAlignment(0.0);

  /// The text direction, if any.
  final TextDirection? direction;

  /// The alignment value.
  final double value;

  const AxisAlignment._(this.direction, this.value);

  /// Creates an [AxisAlignment].
  ///
  /// Parameters:
  /// - [value] (`double`, required): The alignment value (-1.0 to 1.0).
  const AxisAlignment(this.value) : direction = null;

  /// Resolves the alignment value for a specific axis.
  ///
  /// Parameters:
  /// - [axis] (`Axis`, required): The axis to resolve for.
  ///
  /// Returns:
  /// The resolved alignment value.
  double resolveValue(Axis axis) {
    return switch ((direction, axis)) {
      (TextDirection.ltr, Axis.horizontal) => value,
      (TextDirection.rtl, Axis.horizontal) => value * -1,
      _ => value,
    };
  }

  /// Calculates the position along an axis for a given size.
  ///
  /// Parameters:
  /// - [axis] (`Axis`, required): The axis to calculate along.
  /// - [size] (`double`, required): The total size along the axis.
  ///
  /// Returns:
  /// The calculated position.
  double alongValue(Axis axis, double size) {
    final double center = size / 2;
    return center + resolveValue(axis) * center;
  }

  /// Converts this alignment to a standard [Alignment] with this as the horizontal component.
  ///
  /// Parameters:
  /// - [crossAxisAlignment] (`AxisAlignment`, required): The vertical alignment component.
  ///
  /// Returns:
  /// An [Alignment] combining this horizontal alignment with the given vertical alignment.
  Alignment asHorizontalAlignment(AxisAlignment crossAxisAlignment) {
    return Alignment(resolveValue(Axis.horizontal), crossAxisAlignment.value);
  }

  /// Converts this alignment to a standard [Alignment] with this as the vertical component.
  ///
  /// Parameters:
  /// - [crossAxisAlignment] (`AxisAlignment`, required): The horizontal alignment component.
  ///
  /// Returns:
  /// An [Alignment] combining this vertical alignment with the given horizontal alignment.
  Alignment asVerticalAlignment(AxisAlignment crossAxisAlignment) {
    return Alignment(crossAxisAlignment.value, resolveValue(Axis.vertical));
  }

  @override
  AxisAlignment resolve(TextDirection textDirection) {
    return AxisAlignment._(textDirection, value);
  }
}

/// Directional alignment along an axis.
///
/// Values range from -1.0 (start) to 1.0 (end).
class AxisAlignmentDirectional extends AxisAlignmentGeometry {
  /// Alignment to the start (-1.0).
  static const AxisAlignmentDirectional start = AxisAlignmentDirectional(-1.0);

  /// Alignment to the end (1.0).
  static const AxisAlignmentDirectional end = AxisAlignmentDirectional(1.0);

  /// Alignment to the center (0.0).
  static const AxisAlignmentDirectional center = AxisAlignmentDirectional(0.0);

  /// The alignment value.
  final double value;

  /// Creates an [AxisAlignmentDirectional].
  ///
  /// Parameters:
  /// - [value] (`double`, required): The alignment value (-1.0 to 1.0).
  const AxisAlignmentDirectional(this.value);

  @override
  AxisAlignment resolve(TextDirection textDirection) {
    return AxisAlignment._(textDirection, value);
  }
}
