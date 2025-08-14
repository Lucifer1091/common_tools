import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../rendering/gap.dart';
import 'sliver_gap.dart';

/// A widget that takes a fixed amount of space in the direction of its parent.
///
/// It only works in the following cases:
/// - It is a descendant of a [Row], [Column], or [Flex],
/// and the path from the [Gap] widget to its enclosing [Row], [Column], or
/// [Flex] must contain only [StatelessWidget]s or [StatefulWidget]s (not other
/// kinds of widgets, like [RenderObjectWidget]s).
/// - It is a descendant of a [Scrollable].
///
/// See also:
///
///  * [MaxGap], a gap that can take, at most, the amount of space specified.
///  * [SliverGap], the sliver version of this widget.
class Gap extends StatelessWidget {
  /// Creates a widget that takes a fixed [mainAxisExtent] of space in the
  /// direction of its parent.
  ///
  /// The [mainAxisExtent] must not be null and must be positive.
  /// The [crossAxisExtent] must be either null or positive.
  const Gap(
    this.mainAxisExtent, {
    super.key,
    this.crossAxisExtent,
    this.color,
    this.direction,
  }) : assert(
         mainAxisExtent >= 0 && mainAxisExtent < double.infinity,
         'mainAxisExtent must be non-negative and less than infinity',
       ),
       assert(
         crossAxisExtent == null || crossAxisExtent >= 0,
         'crossAxisExtent must be null or non-negative',
       );

  /// Creates a widget that takes a fixed [mainAxisExtent] of space in the
  /// direction of its parent and expands in the cross axis direction.
  ///
  /// The [mainAxisExtent] must not be null and must be positive.
  const Gap.expand(double mainAxisExtent, {Key? key, Color? color})
    : this(
        mainAxisExtent,
        key: key,
        crossAxisExtent: double.infinity,
        color: color,
      );

  /// The amount of space this widget takes in the direction of its parent.
  ///
  /// For example:
  /// - If the parent is a [Column] this is the height of this widget.
  /// - If the parent is a [Row] this is the width of this widget.
  ///
  /// Must not be null and must be positive.
  final double mainAxisExtent;

  /// The amount of space this widget takes in the opposite direction of the
  /// parent.
  ///
  /// For example:
  /// - If the parent is a [Column] this is the width of this widget.
  /// - If the parent is a [Row] this is the height of this widget.
  ///
  /// Must be positive or null. If it's null (the default) the cross axis extent
  /// will be the same as the constraints of the parent in the opposite
  /// direction.
  final double? crossAxisExtent;

  /// The color used to fill the gap.
  final Color? color;

  /// Fallback direction for widgets like [RichText], [Wrap], [OverflowBar] etc.
  final Axis? direction;

  @override
  Widget build(BuildContext context) {
    if (direction != null) {
      return direction == Axis.horizontal
          ? SizedBox(width: mainAxisExtent)
          : SizedBox(height: mainAxisExtent);
    }

    final scrollableState = Scrollable.maybeOf(context);
    final AxisDirection? axisDirection = scrollableState?.axisDirection;
    final Axis? fallbackDirection =
        axisDirection == null ? null : axisDirectionToAxis(axisDirection);

    return _RawGap(
      mainAxisExtent,
      crossAxisExtent: crossAxisExtent,
      color: color,
      fallbackDirection: fallbackDirection,
    );
  }
}

/// A widget that takes, at most, an amount of space in a [Row], [Column],
/// or [Flex] widget.
///
/// A [MaxGap] widget must be a descendant of a [Row], [Column], or [Flex],
/// and the path from the [MaxGap] widget to its enclosing [Row], [Column], or
/// [Flex] must contain only [StatelessWidget]s or [StatefulWidget]s (not other
/// kinds of widgets, like [RenderObjectWidget]s).
///
/// See also:
///
///  * [Gap], the unflexible version of this widget.
class MaxGap extends StatelessWidget {
  /// Creates a widget that takes, at most, the specified [mainAxisExtent] of
  /// space in a [Row], [Column], or [Flex] widget.
  ///
  /// The [mainAxisExtent] must not be null and must be positive.
  /// The [crossAxisExtent] must be either null or positive.
  const MaxGap(
    this.mainAxisExtent, {
    super.key,
    this.crossAxisExtent,
    this.color,
    this.flex = 1,
  });

  /// Creates a widget that takes, at most, the specified [mainAxisExtent] of
  /// space in a [Row], [Column], or [Flex] widget and expands in the cross axis
  /// direction.
  ///
  /// The [mainAxisExtent] must not be null and must be positive.
  /// The [crossAxisExtent] must be either null or positive.
  const MaxGap.expand(double mainAxisExtent, {Key? key, Color? color})
    : this(
        mainAxisExtent,
        key: key,
        crossAxisExtent: double.infinity,
        color: color,
      );

  /// The amount of space this widget takes in the direction of the parent.
  ///
  /// If the parent is a [Column] this is the height of this widget.
  /// If the parent is a [Row] this is the width of this widget.
  ///
  /// Must not be null and must be positive.
  final double mainAxisExtent;

  /// The amount of space this widget takes in the opposite direction of the
  /// parent.
  ///
  /// If the parent is a [Column] this is the width of this widget.
  /// If the parent is a [Row] this is the height of this widget.
  ///
  /// Must be positive or null. If it's null (the default) the cross axis extent
  /// will be the same as the constraints of the parent in the opposite
  /// direction.
  final double? crossAxisExtent;

  /// The color used to fill the gap.
  final Color? color;

  /// The flex factor to use in determining how much space to take up.
  ///
  /// The amount of space the [MaxGap] can occupy in the main axis is determined
  /// by dividing the free space proportionately, after placing the inflexible
  /// children, according to the flex factors of the flexible children.
  ///
  /// Defaults to one.
  final int flex;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: flex,
      child: _RawGap(
        mainAxisExtent,
        crossAxisExtent: crossAxisExtent,
        color: color,
      ),
    );
  }
}

class MinGap extends StatelessWidget {
  /// Creates a widget that takes, at least, the specified [mainAxisExtent]
  /// of space in a [Row], [Column], or [Flex] widget.
  ///
  /// The [mainAxisExtent] must not be null and must be positive.
  /// The [crossAxisExtent] must be either null or positive.
  const MinGap(
    this.mainAxisExtent, {
    super.key,
    this.crossAxisExtent,
    this.color,
    this.flex = 1,
  }) : assert(
         mainAxisExtent >= 0 && mainAxisExtent < double.infinity,
         'mainAxisExtent must be non-negative and less than infinity',
       ),
       assert(
         crossAxisExtent == null || crossAxisExtent >= 0,
         'crossAxisExtent must be null or non-negative',
       );

  /// Creates a widget that takes, at least, the specified [mainAxisExtent]
  /// and expands in the cross axis direction.
  const MinGap.expand(double mainAxisExtent, {Key? key, Color? color})
    : this(
        mainAxisExtent,
        key: key,
        crossAxisExtent: double.infinity,
        color: color,
      );

  /// Minimum space in the main axis.
  final double mainAxisExtent;

  /// Space in the cross axis.
  final double? crossAxisExtent;

  /// Fill color for the gap.
  final Color? color;

  /// The flex factor to use in determining how much space to take up.
  ///
  /// The amount of space the [MinGap] can occupy in the main axis is determined
  /// by dividing the free space proportionately, after placing the inflexible
  /// children, according to the flex factors of the flexible children.
  ///
  /// Defaults to one.
  final int flex;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: flex,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth:
              _isHorizontal(context) ? mainAxisExtent : crossAxisExtent ?? 0,
          minHeight:
              _isHorizontal(context) ? crossAxisExtent ?? 0 : mainAxisExtent,
        ),
        child: _RawGap(
          mainAxisExtent,
          crossAxisExtent: crossAxisExtent,
          color: color,
        ),
      ),
    );
  }

  bool _isHorizontal(BuildContext context) {
    final direction = _getAxis(context);
    return direction == Axis.horizontal;
  }

  Axis _getAxis(BuildContext context) {
    final flex = context.findAncestorWidgetOfExactType<Flex>();
    return flex?.direction ?? Axis.horizontal;
  }
}

class _RawGap extends LeafRenderObjectWidget {
  const _RawGap(
    this.mainAxisExtent, {
    this.crossAxisExtent,
    this.color,
    this.fallbackDirection,
  }) : assert(
         mainAxisExtent >= 0 && mainAxisExtent < double.infinity,
         'mainAxisExtent must be non-negative and less than infinity',
       ),
       assert(
         crossAxisExtent == null || crossAxisExtent >= 0,
         'crossAxisExtent must be null or non-negative',
       );

  final double mainAxisExtent;

  final double? crossAxisExtent;

  final Color? color;

  final Axis? fallbackDirection;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderGap(
      mainAxisExtent: mainAxisExtent,
      crossAxisExtent: crossAxisExtent ?? 0,
      color: color,
      fallbackDirection: fallbackDirection,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderGap renderObject) {
    renderObject
      ..mainAxisExtent = mainAxisExtent
      ..crossAxisExtent = crossAxisExtent ?? 0
      ..color = color
      ..fallbackDirection = fallbackDirection;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DoubleProperty('mainAxisExtent', mainAxisExtent))
      ..add(DoubleProperty('crossAxisExtent', crossAxisExtent, defaultValue: 0))
      ..add(ColorProperty('color', color))
      ..add(EnumProperty<Axis>('fallbackDirection', fallbackDirection));
  }
}

/// Animated version of [Gap] that gradually changes its values over a period of time.
///
/// The [AnimatedGap] will automatically animate between the old and
/// new values of properties when they change using the provided curve and
/// duration. Properties that are null are not animated.
///
/// See also:
///
///  * [SliverAnimatedGap], the [RenderSliver] version of this widget.
class AnimatedGap extends ImplicitlyAnimatedWidget {
  /// Creates a [Gap] that animates its parameters implicitly.
  ///
  /// The [curve] and [duration] arguments must not be null.
  const AnimatedGap(
    this.mainAxisExtent, {
    required super.duration,
    super.key,
    this.crossAxisExtent,
    this.color,
    super.curve,
    super.onEnd,
  }) : assert(
         mainAxisExtent >= 0 && mainAxisExtent < double.infinity,
         'mainAxisExtent must be non-negative and less than infinity',
       ),
       assert(
         crossAxisExtent == null || crossAxisExtent >= 0,
         'crossAxisExtent must be null or non-negative',
       );

  /// {@macro gap.mainAxisExtent}
  final double mainAxisExtent;

  /// {@macro gap.crossAxisExtent}
  final double? crossAxisExtent;

  /// {@macro gap.color}
  final Color? color;

  @override
  AnimatedWidgetBaseState<AnimatedGap> createState() => _AnimatedGapState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DoubleProperty('mainAxisExtent', mainAxisExtent))
      ..add(
        DoubleProperty('crossAxisExtent', crossAxisExtent, defaultValue: null),
      )
      ..add(ColorProperty('color', color, defaultValue: null));
  }
}

class _AnimatedGapState extends AnimatedWidgetBaseState<AnimatedGap> {
  Tween<double>? _mainAxisExtent;
  Tween<double>? _crossAxisExtent;
  ColorTween? _color;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _mainAxisExtent =
        visitor(
              _mainAxisExtent,
              widget.mainAxisExtent,
              (value) => Tween<double>(begin: value as double),
            )
            as Tween<double>?;

    _crossAxisExtent =
        visitor(
              _crossAxisExtent,
              widget.crossAxisExtent,
              (value) => Tween<double>(begin: value as double),
            )
            as Tween<double>?;

    _color =
        visitor(
              _color,
              widget.color,
              (value) => ColorTween(begin: value as Color),
            )
            as ColorTween?;
  }

  @override
  Widget build(BuildContext context) {
    final mainAxisExtent = _mainAxisExtent
        ?.evaluate(animation)
        .clamp(0.0, double.infinity);

    final crossAxisExtent = _crossAxisExtent
        ?.evaluate(animation)
        .clamp(0.0, double.infinity);

    final color = _color?.evaluate(animation);

    return Gap(
      mainAxisExtent ?? 0,
      crossAxisExtent: crossAxisExtent,
      color: color,
    );
  }
}
