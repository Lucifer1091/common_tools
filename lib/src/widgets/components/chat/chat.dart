import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../../../theme.dart';
import '../../../../utilities.dart';
import '../../../extensions/index.dart';
import '../../common/my_provider.dart';
import 'axis_direction.dart';

/// Scoped styling defaults for chat widgets.
///
/// Values provided here are used when a [MyChatBubble] does not specify the same
/// property directly.
class MyChatTheme {
  /// Default alignment for chat bubbles.
  final AxisAlignmentGeometry? alignment;

  /// Default background color for chat bubbles.
  final Color? color;

  /// Default bubble type.
  final MyChatBubbleType? type;

  /// Default bubble border radius.
  final BorderRadiusGeometry? borderRadius;

  /// Default bubble padding.
  final EdgeInsetsGeometry? padding;

  /// Default bubble border.
  final BorderSide? border;

  /// Default bubble width factor.
  final double? widthFactor;

  /// Default text style for chat bubble content.
  final TextStyle? textStyle;

  /// Creates chat styling defaults.
  const MyChatTheme({
    this.alignment,
    this.color,
    this.type,
    this.borderRadius,
    this.padding,
    this.border,
    this.widthFactor,
    this.textStyle,
  });

  /// Creates a copy with selected values replaced.
  MyChatTheme copyWith({
    ValueGetter<AxisAlignmentGeometry?>? alignment,
    ValueGetter<Color?>? color,
    ValueGetter<MyChatBubbleType?>? type,
    ValueGetter<BorderRadiusGeometry?>? borderRadius,
    ValueGetter<EdgeInsetsGeometry?>? padding,
    ValueGetter<BorderSide?>? border,
    ValueGetter<double?>? widthFactor,
    ValueGetter<TextStyle?>? textStyle,
  }) {
    return MyChatTheme(
      alignment: alignment == null ? this.alignment : alignment(),
      color: color == null ? this.color : color(),
      type: type == null ? this.type : type(),
      borderRadius: borderRadius == null ? this.borderRadius : borderRadius(),
      padding: padding == null ? this.padding : padding(),
      border: border == null ? this.border : border(),
      widthFactor: widthFactor == null ? this.widthFactor : widthFactor(),
      textStyle: textStyle == null ? this.textStyle : textStyle(),
    );
  }

  /// Returns this theme with non-null values from [theme] layered on top.
  MyChatTheme merge(MyChatTheme theme) {
    return MyChatTheme(
      alignment: theme.alignment ?? alignment,
      color: theme.color ?? color,
      type: theme.type ?? type,
      borderRadius: theme.borderRadius ?? borderRadius,
      padding: theme.padding ?? padding,
      border: theme.border ?? border,
      widthFactor: theme.widthFactor ?? widthFactor,
      textStyle: theme.textStyle ?? textStyle,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MyChatTheme &&
        other.alignment == alignment &&
        other.color == color &&
        other.type == type &&
        other.borderRadius == borderRadius &&
        other.padding == padding &&
        other.border == border &&
        other.widthFactor == widthFactor &&
        other.textStyle == textStyle;
  }

  @override
  int get hashCode {
    return Object.hash(
      alignment,
      color,
      type,
      borderRadius,
      padding,
      border,
      widthFactor,
      textStyle,
    );
  }
}

Border? _borderFromSide(BorderSide? side) {
  if (side == null) return null;
  return Border.all(
    color: side.color,
    width: side.width,
    strokeAlign: side.strokeAlign,
    style: side.style,
  );
}

/// A widget that constrains the width of its child based on a factor and aligns it.
///
/// This widget is used by [MyChatBubble] to limit the width of the bubble relative to
/// the available width and to align it within that space.
///
/// Parameters:
/// - [widthFactor] (`double`, required): The fraction of the available width that the child should occupy.
/// - [alignment] (`AxisAlignmentGeometry`, required): The alignment of the child within the available space.
/// - [child] (`Widget`, required): The widget below this widget in the tree.
class _ChatConstrainedBox extends SingleChildRenderObjectWidget {
  /// The fraction of the available width that the child should occupy.
  final double widthFactor;

  /// The alignment of the child within the available space.
  final AxisAlignmentGeometry alignment;

  /// Creates a [_ChatConstrainedBox].
  const _ChatConstrainedBox({
    required this.widthFactor,
    required this.alignment,
    required super.child,
  });

  @override
  _RenderChatConstrainedBox createRenderObject(BuildContext context) {
    return _RenderChatConstrainedBox(
      widthFactor: widthFactor,
      alignment: alignment.resolve(
        Directionality.maybeOf(context) ?? TextDirection.ltr,
      ),
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderChatConstrainedBox renderObject,
  ) {
    renderObject
      ..widthFactor = widthFactor
      ..alignment = alignment.resolve(
        Directionality.maybeOf(context) ?? TextDirection.ltr,
      );
  }
}

/// A render object that constrains the width of its child and aligns it.
///
/// This render object implements the layout logic for [_ChatConstrainedBox].
class _RenderChatConstrainedBox extends RenderShiftedBox {
  double _widthFactor;
  AxisAlignment _alignment;

  /// Creates a [_RenderChatConstrainedBox].
  ///
  /// Parameters:
  /// - [_widthFactor] (`double`, required): The fraction of the available width that the child should occupy.
  /// - [_alignment] (`AxisAlignment`, required): The alignment of the child within the available space.
  /// - [child] (`RenderBox?`, optional): The child render object.
  _RenderChatConstrainedBox({
    required this._widthFactor,
    required this._alignment,
    RenderBox? child,
  }) : super(child);

  /// The fraction of the available width that the child should occupy.
  double get widthFactor => _widthFactor;

  /// The alignment of the child within the available space.
  AxisAlignment get alignment => _alignment;

  /// Sets the width factor.
  set widthFactor(double value) {
    if (_widthFactor != value) {
      _widthFactor = value;
      markNeedsLayout();
    }
  }

  /// Sets the alignment.
  set alignment(AxisAlignment value) {
    if (_alignment != value) {
      _alignment = value;
      markNeedsLayout();
    }
  }

  @override
  void performLayout() {
    if (child == null) {
      size = this.constraints.smallest;
      return;
    }
    var constraints = this.constraints;
    final newMaxWidth = constraints.maxWidth * _widthFactor;
    constraints = constraints.copyWith(maxWidth: newMaxWidth, minWidth: 0);
    child!.layout(constraints, parentUsesSize: true);
    size = this.constraints.constrain(
      Size(this.constraints.maxWidth, child!.size.height),
    );
    final double x = _alignment.alongValue(
      Axis.horizontal,
      this.constraints.maxWidth - child!.size.width,
    );
    final data = child!.parentData as BoxParentData;
    data.offset = Offset(x, 0);
  }

  @override
  Size computeDryLayout(covariant BoxConstraints constraints) {
    if (child == null) {
      return constraints.smallest;
    }
    final newMaxWidth = constraints.maxWidth * _widthFactor;
    final newConstraints = constraints.copyWith(
      maxWidth: newMaxWidth,
      minWidth: 0,
    );
    final Size childSize = child!.getDryLayout(newConstraints);
    return constraints.constrain(Size(constraints.maxWidth, childSize.height));
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return super.computeMaxIntrinsicHeight(width * _widthFactor);
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    return super.computeMinIntrinsicHeight(width * _widthFactor);
  }
}

/// A widget that groups multiple [MyChatBubble]s together.
///
/// This widget handles the layout and styling of a group of chat bubbles,
/// including avatar positioning and spacing.
///
/// Example:
/// ```dart
/// ChatGroup(
///   avatarPrefix: Avatar(child: Text('A')),
///   children: [
///     ChatBubble(child: Text('Hello')),
///     ChatBubble(child: Text('How are you?')),
///   ],
/// )
/// ```
class MyChatGroup extends StatelessWidget {
  /// The widget to display before the chat bubbles (e.g., an avatar).
  final Widget? avatarPrefix;

  /// The widget to display after the chat bubbles.
  final Widget? avatarSuffix;

  /// The list of chat bubbles to display.
  final List<Widget> children;

  /// The alignment of the chat bubbles within the group.
  final AxisAlignmentGeometry? alignment;

  /// The background color of the chat bubbles.
  final Color? color;

  /// The type of the chat bubbles.
  final MyChatBubbleType? type;

  /// The border radius of the chat bubbles.
  final BorderRadiusGeometry? borderRadius;

  /// The padding inside the chat bubbles.
  final EdgeInsetsGeometry? padding;

  /// The border of the chat bubbles.
  final BorderSide? border;

  /// The spacing between chat bubbles.
  final double? spacing;

  /// The alignment of the avatar.
  final AxisAlignmentGeometry? avatarAlignment;

  /// The spacing between the avatar and the chat bubbles.
  final double? avatarSpacing;

  /// The text style for chat bubble content.
  final TextStyle? textStyle;

  /// Creates a [MyChatGroup].
  ///
  /// Parameters:
  /// - [children] (`List<Widget>`, required): The list of chat bubbles to display.
  /// - [alignment] (`AxisAlignmentGeometry?`, optional): The alignment of the chat bubbles within the group.
  /// - [color] (`Color?`, optional): The background color of the chat bubbles.
  /// - [type] (`ChatBubbleType?`, optional): The type of the chat bubbles.
  /// - [borderRadius] (`BorderRadiusGeometry?`, optional): The border radius of the chat bubbles.
  /// - [padding] (`EdgeInsetsGeometry?`, optional): The padding inside the chat bubbles.
  /// - [border] (`BorderSide?`, optional): The border of the chat bubbles.
  /// - [spacing] (`double?`, optional): The spacing between chat bubbles.
  /// - [avatarPrefix] (`Widget?`, optional): The widget to display before the chat bubbles.
  /// - [avatarSuffix] (`Widget?`, optional): The widget to display after the chat bubbles.
  /// - [avatarAlignment] (`AxisAlignmentGeometry?`, optional): The alignment of the avatar.
  /// - [avatarSpacing] (`double?`, optional): The spacing between the avatar and the chat bubbles.
  /// - [textStyle] (`TextStyle?`, optional): The text style for chat bubble content.
  const MyChatGroup({
    super.key,
    required this.children,
    this.alignment,
    this.color,
    this.type,
    this.borderRadius,
    this.padding,
    this.border,
    this.spacing,
    this.avatarPrefix,
    this.avatarSuffix,
    this.avatarAlignment,
    this.avatarSpacing,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final inheritedTheme =
        context.maybeWatch<MyChatTheme>() ?? const MyChatTheme();
    final effectiveTheme = inheritedTheme.merge(
      MyChatTheme(
        alignment: alignment,
        color: color,
        type: type,
        borderRadius: borderRadius,
        padding: padding,
        border: border,
        textStyle: textStyle,
      ),
    );
    final avatarAlignment =
        (this.avatarAlignment ?? AxisAlignmentDirectional.end)
            .resolve(Directionality.maybeOf(context) ?? TextDirection.ltr)
            .asVerticalAlignment(AxisAlignment.center);

    final group = IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: avatarSpacing ?? 8,
        children: [
          if (avatarPrefix != null)
            Align(alignment: avatarAlignment, child: avatarPrefix!),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: spacing ?? 2.0,
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int i = 0; i < children.length; i++)
                  MyProvider<MyChatBubbleData>(
                    data: MyChatBubbleData(index: i, length: children.length),
                    notifyUpdate: (oldWidget) =>
                        oldWidget.data !=
                        MyChatBubbleData(index: i, length: children.length),
                    child: children[i],
                  ),
              ],
            ),
          ),
          if (avatarSuffix != null)
            Align(alignment: avatarAlignment, child: avatarSuffix!),
        ],
      ),
    );

    return MyProvider<MyChatTheme>(
      data: effectiveTheme,
      notifyUpdate: (oldWidget) => oldWidget.data != effectiveTheme,
      child: group,
    );
  }
}

/// Defines the type of a [MyChatBubble].
///
/// This abstract class allows for different visual styles of chat bubbles,
/// such as plain bubbles or bubbles with tails.
abstract class MyChatBubbleType {
  /// A plain bubble with no tail.
  static const plain = MyPlainChatBubbleType();

  /// A bubble with an external triangular tail.
  static const tail = MyTailChatBubbleType();

  /// A bubble with one sharp corner instead of rounded.
  static const sharpCorner = MySharpCornerChatBubbleType();

  /// Creates a [MyChatBubbleType].
  const MyChatBubbleType();

  /// Wraps the child widget with the bubble styling.
  ///
  /// Parameters:
  /// - [context] (`BuildContext`, required): The build context.
  /// - [child] (`Widget`, required): The child widget to wrap.
  /// - [data] (`ChatBubbleData`, required): The data associated with the bubble.
  /// - [chat] (`ChatBubble`, required): The chat bubble widget itself.
  ///
  /// Returns:
  /// A [Widget] that wraps the child with the bubble styling.
  Widget wrap(
    BuildContext context,
    Widget child,
    MyChatBubbleData data,
    MyChatBubble chat,
  );
}

/// Defines the corner of a [MyChatBubble] where a tail might be attached.
enum MyChatBubbleCorner {
  /// The top-left corner.
  topLeft,

  /// The top-right corner.
  topRight,

  /// The bottom-left corner.
  bottomLeft,

  /// The bottom-right corner.
  bottomRight,
}

/// Defines the directional corner of a [MyChatBubble].
///
/// This is used to support RTL languages by defining corners in terms of
/// start and end instead of left and right.
enum MyChatBubbleCornerDirectional {
  /// The top-start corner (top-left in LTR, top-right in RTL).
  topStart,

  /// The top-end corner (top-right in LTR, top-left in RTL).
  topEnd,

  /// The bottom-start corner (bottom-left in LTR, bottom-right in RTL).
  bottomStart,

  /// The bottom-end corner (bottom-right in LTR, bottom-left in RTL).
  bottomEnd;

  /// Resolves the directional corner to a concrete [MyChatBubbleCorner] based on the text direction.
  MyChatBubbleCorner resolve(TextDirection direction) {
    return switch ((this, direction)) {
      (MyChatBubbleCornerDirectional.topStart, TextDirection.ltr) =>
        MyChatBubbleCorner.topLeft,
      (MyChatBubbleCornerDirectional.topStart, TextDirection.rtl) =>
        MyChatBubbleCorner.topRight,
      (MyChatBubbleCornerDirectional.topEnd, TextDirection.ltr) =>
        MyChatBubbleCorner.topRight,
      (MyChatBubbleCornerDirectional.topEnd, TextDirection.rtl) =>
        MyChatBubbleCorner.topLeft,
      (MyChatBubbleCornerDirectional.bottomStart, TextDirection.ltr) =>
        MyChatBubbleCorner.bottomLeft,
      (MyChatBubbleCornerDirectional.bottomStart, TextDirection.rtl) =>
        MyChatBubbleCorner.bottomRight,
      (MyChatBubbleCornerDirectional.bottomEnd, TextDirection.ltr) =>
        MyChatBubbleCorner.bottomRight,
      (MyChatBubbleCornerDirectional.bottomEnd, TextDirection.rtl) =>
        MyChatBubbleCorner.bottomLeft,
    };
  }
}

/// A [MyChatBubbleType] that makes one corner sharp instead of rounded.
///
/// This style modifies the border radius of one corner to create a pointed
/// corner effect, similar to a speech bubble tail.
class MySharpCornerChatBubbleType extends MyChatBubbleType {
  /// The corner where the tail should be applied.
  final MyChatBubbleCornerDirectional? corner;

  /// The border radius of the bubble.
  final BorderRadiusGeometry? borderRadius;

  /// The padding inside the bubble.
  final EdgeInsetsGeometry? padding;

  /// The behavior determining when to show the tail.
  final MyTailBehavior? tailBehavior;

  /// Creates a [MySharpCornerChatBubbleType].
  ///
  /// Parameters:
  /// - [corner] (`ChatBubbleCornerDirectional?`, optional): The corner that should be sharp.
  /// - [borderRadius] (`BorderRadiusGeometry?`, optional): The border radius of the bubble.
  /// - [padding] (`EdgeInsetsGeometry?`, optional): The padding inside the bubble.
  /// - [tailBehavior] (`TailBehavior?`, optional): The behavior determining when to show the sharp corner.
  const MySharpCornerChatBubbleType({
    this.corner,
    this.borderRadius,
    this.padding,
    this.tailBehavior,
  });

  /// Creates a copy of this bubble type with the given fields replaced with the new values.
  ///
  /// Parameters:
  /// - [corner] (`ValueGetter<ChatBubbleCornerDirectional?>?`, optional): New corner value.
  /// - [borderRadius] (`ValueGetter<BorderRadiusGeometry?>?`, optional): New border radius value.
  /// - [padding] (`ValueGetter<EdgeInsetsGeometry?>?`, optional): New padding value.
  /// - [tailBehavior] (`ValueGetter<TailBehavior?>?`, optional): New tail behavior value.
  ///
  /// Returns:
  /// A new [MySharpCornerChatBubbleType] with the specified values updated.
  MySharpCornerChatBubbleType copyWith({
    ValueGetter<MyChatBubbleCornerDirectional?>? corner,
    ValueGetter<BorderRadiusGeometry?>? borderRadius,
    ValueGetter<EdgeInsetsGeometry?>? padding,
    ValueGetter<MyTailBehavior?>? tailBehavior,
  }) {
    return MySharpCornerChatBubbleType(
      corner: corner == null ? this.corner : corner(),
      borderRadius: borderRadius == null ? this.borderRadius : borderRadius(),
      padding: padding == null ? this.padding : padding(),
      tailBehavior: tailBehavior == null ? this.tailBehavior : tailBehavior(),
    );
  }

  @override
  Widget wrap(
    BuildContext context,
    Widget child,
    MyChatBubbleData data,
    MyChatBubble chat,
  ) {
    final textDirection = Directionality.maybeOf(context) ?? TextDirection.ltr;
    final padding = chat.effectivePadding(context, this.padding);
    final color = chat.effectiveColor(context);
    final border = chat.effectiveBorder(context, null);
    var radius = chat
        .effectiveBorderRadius(context, borderRadius)
        .resolve(textDirection);
    final tailBehavior = this.tailBehavior ?? MyTailBehavior.last;
    if (tailBehavior.wrapWithTail(data)) {
      MyChatBubbleCorner? corner = this.corner?.resolve(textDirection);
      if (corner == null) {
        final alignment = (chat.alignment ?? AxisAlignmentDirectional.end)
            .resolve(textDirection);
        if (alignment.value > 0) {
          corner = MyChatBubbleCorner.bottomRight;
        } else {
          corner = MyChatBubbleCorner.bottomLeft;
        }
      }
      switch (corner) {
        case MyChatBubbleCorner.topLeft:
          radius = radius.copyWith(topLeft: Radius.zero);
          break;
        case MyChatBubbleCorner.topRight:
          radius = radius.copyWith(topRight: Radius.zero);
          break;
        case MyChatBubbleCorner.bottomLeft:
          radius = radius.copyWith(bottomLeft: Radius.zero);
          break;
        case MyChatBubbleCorner.bottomRight:
          radius = radius.copyWith(bottomRight: Radius.zero);
          break;
      }
    }
    return Container(
      decoration: BoxDecoration(
        borderRadius: radius,
        border: _borderFromSide(border),
        color: color,
      ),
      padding: padding,
      child: child,
    );
  }
}

/// A simple [MyChatBubbleType] with no tail.
class MyPlainChatBubbleType extends MyChatBubbleType {
  /// The border radius of the bubble.
  final BorderRadiusGeometry? borderRadius;

  /// The border of the bubble.
  final BorderSide? border;

  /// The padding inside the bubble.
  final EdgeInsetsGeometry? padding;

  /// Creates a [MyPlainChatBubbleType].
  ///
  /// Parameters:
  /// - [borderRadius] (`BorderRadiusGeometry?`, optional): The border radius of the bubble.
  /// - [border] (`BorderSide?`, optional): The border of the bubble.
  /// - [padding] (`EdgeInsetsGeometry?`, optional): The padding inside the bubble.
  const MyPlainChatBubbleType({this.borderRadius, this.border, this.padding});
  @override
  Widget wrap(
    BuildContext context,
    Widget child,
    MyChatBubbleData data,
    MyChatBubble chat,
  ) {
    final border = chat.effectiveBorder(context, this.border);
    final padding = chat.effectivePadding(context, this.padding);
    final color = chat.effectiveColor(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: chat.effectiveBorderRadius(context, borderRadius),
        border: _borderFromSide(border),
        color: color,
      ),
      padding: padding,
      child: child,
    );
  }
}

/// Defines when a tail should be shown on a [MyChatBubble].
abstract class MyTailBehavior {
  /// Shows a tail on the first bubble in a group.
  static const first = _ChatTailBehavior(_first);

  /// Shows a tail on the middle bubble in a group.
  static const middle = _ChatTailBehavior(_middle);

  /// Shows a tail on the last bubble in a group.
  static const last = _ChatTailBehavior(_last);
  static bool _first(MyChatBubbleData data) => data.index == 0;
  static bool _middle(MyChatBubbleData data) =>
      data.index == (data.length - 1) ~/ 2;
  static bool _last(MyChatBubbleData data) => data.index == data.length - 1;

  /// Determines whether the bubble at the given index should have a tail.
  bool wrapWithTail(MyChatBubbleData data);
}

class _ChatTailBehavior implements MyTailBehavior {
  final bool Function(MyChatBubbleData data) shouldHaveTail;
  const _ChatTailBehavior(this.shouldHaveTail);
  @override
  bool wrapWithTail(MyChatBubbleData data) {
    return shouldHaveTail(data);
  }
}

/// A [MyChatBubbleType] that draws an external triangular tail.
class MyTailChatBubbleType extends MyChatBubbleType {
  /// The alignment of the tail along the bubble's edge.
  final AxisAlignmentGeometry? tailAlignment;

  /// The position of the tail relative to the bubble.
  final AxisDirectional? position;

  /// The size of the tail.
  final Size? size;

  /// The border radius of the bubble.
  final BorderRadiusGeometry? borderRadius;

  /// The radius of the tail's curve.
  final double? tailRadius;

  /// The behavior determining when to show the tail.
  final MyTailBehavior? tailBehavior;

  /// The padding inside the bubble.
  final EdgeInsetsGeometry? padding;

  /// Creates a [MyTailChatBubbleType].
  ///
  /// Parameters:
  /// - [tailAlignment] (`AxisAlignmentGeometry?`, optional): The alignment of the tail along the bubble's edge.
  /// - [position] (`AxisDirectional?`, optional): The position of the tail relative to the bubble.
  /// - [size] (`Size?`, optional): The size of the tail.
  /// - [borderRadius] (`BorderRadiusGeometry?`, optional): The border radius of the bubble.
  /// - [tailRadius] (`double?`, optional): The radius of the tail's curve.
  /// - [tailBehavior] (`TailBehavior?`, optional): The behavior determining when to show the tail.
  /// - [padding] (`EdgeInsetsGeometry?`, optional): The padding inside the bubble.
  const MyTailChatBubbleType({
    this.tailAlignment,
    this.position,
    this.size,
    this.borderRadius,
    this.tailRadius,
    this.tailBehavior,
    this.padding,
  });

  /// Creates a copy of this bubble type with the given fields replaced with the new values.
  ///
  /// Parameters:
  /// - [tailAlignment] (`ValueGetter<AxisAlignmentGeometry>?`, optional): New tail alignment value.
  /// - [position] (`ValueGetter<AxisDirectional>?`, optional): New position value.
  /// - [size] (`ValueGetter<Size>?`, optional): New size value.
  /// - [borderRadius] (`ValueGetter<BorderRadiusGeometry>?`, optional): New border radius value.
  /// - [tailRadius] (`ValueGetter<double>?`, optional): New tail radius value.
  /// - [tailBehavior] (`ValueGetter<TailBehavior>?`, optional): New tail behavior value.
  ///
  /// Returns:
  /// A new [MyTailChatBubbleType] with the specified values updated.
  MyTailChatBubbleType copyWith({
    ValueGetter<AxisAlignmentGeometry>? tailAlignment,
    ValueGetter<AxisDirectional>? position,
    ValueGetter<Size>? size,
    ValueGetter<BorderRadiusGeometry>? borderRadius,
    ValueGetter<double>? tailRadius,
    ValueGetter<MyTailBehavior>? tailBehavior,
  }) {
    return MyTailChatBubbleType(
      tailAlignment: tailAlignment?.call() ?? this.tailAlignment,
      position: position?.call() ?? this.position,
      size: size?.call() ?? this.size,
      borderRadius: borderRadius?.call() ?? this.borderRadius,
      tailRadius: tailRadius?.call() ?? this.tailRadius,
      tailBehavior: tailBehavior?.call() ?? this.tailBehavior,
    );
  }

  @override
  Widget wrap(
    BuildContext context,
    Widget child,
    MyChatBubbleData data,
    MyChatBubble chat,
  ) {
    final textDirection = Directionality.maybeOf(context) ?? TextDirection.ltr;
    final tailBehavior = this.tailBehavior ?? MyTailBehavior.last;
    final color = chat.effectiveColor(context);
    final radius = chat
        .effectiveBorderRadius(context, borderRadius)
        .resolve(textDirection);
    final border = chat.effectiveBorder(context, null);
    final padding = chat.effectivePadding(context, this.padding);
    child = Container(
      decoration: BoxDecoration(
        borderRadius: radius,
        border: _borderFromSide(border),
        color: color,
      ),
      padding: padding,
      child: child,
    );

    double leftPadding;
    double rightPadding;
    double topPadding;
    double bottomPadding;
    final size = this.size ?? const Size(8, 8);
    final position = (this.position ?? AxisDirectional.end).resolve(
      textDirection,
    );
    final bool wrapWithTail = tailBehavior.wrapWithTail(data);
    switch ((position, wrapWithTail)) {
      case (AxisDirection.left, _):
        topPadding = 0;
        leftPadding = size.width;
        rightPadding = 0;
        bottomPadding = 0;
        break;
      case (AxisDirection.right, _):
        topPadding = 0;
        leftPadding = 0;
        rightPadding = size.width;
        bottomPadding = 0;
        break;
      case (AxisDirection.up, true):
        topPadding = size.height;
        leftPadding = 0;
        rightPadding = 0;
        bottomPadding = 0;
        break;
      case (AxisDirection.down, true):
        topPadding = 0;
        leftPadding = 0;
        rightPadding = 0;
        bottomPadding = size.height;
        break;
      case (_, _):
        topPadding = 0;
        leftPadding = 0;
        rightPadding = 0;
        bottomPadding = 0;
        break;
    }

    if (tailBehavior.wrapWithTail(data)) {
      final tailSize = size;
      final tailRadius = this.tailRadius ?? MyRadius.small;
      final tailAlignment = (this.tailAlignment ?? AxisAlignmentDirectional.end)
          .resolve(textDirection);
      final position = (this.position ?? AxisDirectional.down).resolve(
        textDirection,
      );
      child = CustomPaint(
        painter: _TailPainter(
          color: color,
          radius: radius,
          tailSize: tailSize,
          position: position,
          tailAlignment: tailAlignment,
          tailRadius: tailRadius,
        ),
        child: child,
      );
    }
    return Padding(
      padding: EdgeInsets.only(
        top: topPadding,
        left: leftPadding,
        right: rightPadding,
        bottom: bottomPadding,
      ),
      child: child,
    );
  }
}

class _TailPainter extends CustomPainter {
  final Color color;
  final BorderRadius radius;
  final Size tailSize;
  final AxisDirection position;
  final AxisAlignment tailAlignment;
  final double tailRadius;

  const _TailPainter({
    required this.color,
    required this.radius,
    required this.tailSize,
    required this.position,
    required this.tailAlignment,
    required this.tailRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    // create tail shape
    final Axis axis = switch (position) {
      AxisDirection.up => Axis.vertical,
      AxisDirection.down => Axis.vertical,
      AxisDirection.left => Axis.horizontal,
      AxisDirection.right => Axis.horizontal,
    };

    final double horizontalOffset =
        tailAlignment.alongValue(axis, size.width) -
        tailAlignment.alongValue(axis, tailSize.width);
    final double verticalOffset =
        tailAlignment.alongValue(axis, size.height) -
        tailAlignment.alongValue(axis, tailSize.height);
    final double alignVal = tailAlignment.resolveValue(axis);
    final double t = (alignVal + 1) / 2;

    Offset base1, base2, tip;

    // Get corner radius - the bubble extends beyond the painter bounds
    final double cornerRadius = switch (position) {
      AxisDirection.up => max(radius.topLeft.y, radius.topRight.y),
      AxisDirection.down => max(radius.bottomLeft.y, radius.bottomRight.y),
      AxisDirection.left => max(radius.topLeft.x, radius.bottomLeft.x),
      AxisDirection.right => max(radius.topRight.x, radius.bottomRight.x),
    };

    // Calculate initial base positions at the edge
    Offset initialBase1, initialBase2;
    switch (position) {
      case AxisDirection.up:
        initialBase1 = Offset(horizontalOffset, 0);
        initialBase2 = Offset(horizontalOffset + tailSize.width, 0);
        tip = Offset(horizontalOffset + t * tailSize.width, -tailSize.height);
        break;
      case AxisDirection.down:
        initialBase1 = Offset(horizontalOffset, size.height);
        initialBase2 = Offset(horizontalOffset + tailSize.width, size.height);
        tip = Offset(
          horizontalOffset + t * tailSize.width,
          size.height + tailSize.height,
        );
        break;
      case AxisDirection.left:
        initialBase1 = Offset(0, verticalOffset);
        initialBase2 = Offset(0, verticalOffset + tailSize.height);
        tip = Offset(-tailSize.width, verticalOffset + t * tailSize.height);
        break;
      case AxisDirection.right:
        initialBase1 = Offset(size.width, verticalOffset);
        initialBase2 = Offset(size.width, verticalOffset + tailSize.height);
        tip = Offset(
          size.width + tailSize.width,
          verticalOffset + t * tailSize.height,
        );
        break;
    }

    // Extend base points along the tail-to-base vectors by cornerRadius
    Offset v1 = initialBase1 - tip;
    Offset v2 = initialBase2 - tip;
    double d1 = v1.distance;
    double d2 = v2.distance;

    // Move base1 and base2 outward along their respective vectors
    base1 = d1 == 0 ? initialBase1 : tip + v1 * ((d1 + cornerRadius) / d1);
    base2 = d2 == 0 ? initialBase2 : tip + v2 * ((d2 + cornerRadius) / d2);

    // Recalculate vectors for the rounded tip
    v1 = base1 - tip;
    v2 = base2 - tip;
    d1 = v1.distance;
    d2 = v2.distance;

    final Offset pathBeforeTail = d1 == 0
        ? tip
        : tip + v1 * (min(d1, tailRadius) / d1);
    final Offset pathAfterTail = d2 == 0
        ? tip
        : tip + v2 * (min(d2, tailRadius) / d2);

    path.moveTo(base1.dx, base1.dy);
    path.lineTo(pathBeforeTail.dx, pathBeforeTail.dy);
    path.quadraticBezierTo(tip.dx, tip.dy, pathAfterTail.dx, pathAfterTail.dy);
    path.lineTo(base2.dx, base2.dy);
    path.close();
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _TailPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.radius != radius ||
        oldDelegate.tailSize != tailSize ||
        oldDelegate.position != position ||
        oldDelegate.tailAlignment != tailAlignment;
  }
}

/// Data associated with a [MyChatBubble] within a [MyChatGroup].
class MyChatBubbleData {
  /// The index of the bubble in the group.
  final int index;

  /// The total number of bubbles in the group.
  final int length;

  /// Creates a [MyChatBubbleData].
  ///
  /// Parameters:
  /// - [index] (`int`, required): The index of the bubble in the group.
  /// - [length] (`int`, required): The total number of bubbles in the group.
  const MyChatBubbleData({required this.index, required this.length});

  /// Creates a copy of this data with the given fields replaced with the new values.
  ///
  /// Parameters:
  /// - [index] (`int?`, optional): New index value.
  /// - [length] (`int?`, optional): New length value.
  ///
  /// Returns:
  /// A new [MyChatBubbleData] with the specified values updated.
  MyChatBubbleData copyWith({int? index, int? length}) {
    return MyChatBubbleData(
      index: index ?? this.index,
      length: length ?? this.length,
    );
  }

  @override
  String toString() {
    return 'ChatBubbleData(index: $index, length: $length)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MyChatBubbleData &&
        other.index == index &&
        other.length == length;
  }

  @override
  int get hashCode {
    return Object.hash(index, length);
  }
}

/// A widget that displays a single chat message or content.
///
/// This widget renders a chat bubble with customizable styling, including
/// background color, alignment, and tail behavior.
///
/// Example:
/// ```dart
/// ChatBubble(
///   child: Text('Hello World'),
///   alignment: AxisAlignment.right,
///   color: Colors.blue,
/// )
/// ```
class MyChatBubble extends StatelessWidget {
  /// The content of the chat bubble.
  final Widget child;

  /// The type of the chat bubble.
  final MyChatBubbleType? type;

  /// The background color of the chat bubble.
  final Color? color;

  /// The alignment of the chat bubble.
  final AxisAlignmentGeometry? alignment;

  /// The border of the chat bubble.
  final BorderSide? border;

  /// The padding inside the chat bubble.
  final EdgeInsetsGeometry? padding;

  /// The border radius of the chat bubble.
  final BorderRadiusGeometry? borderRadius;

  /// The width factor of the chat bubble.
  final double? widthFactor;

  /// The text style for chat bubble content.
  final TextStyle? textStyle;

  /// Creates a [MyChatBubble].
  ///
  /// Parameters:
  /// - [child] (`Widget`, required): The content of the chat bubble.
  /// - [type] (`ChatBubbleType?`, optional): The type of the chat bubble.
  /// - [color] (`Color?`, optional): The background color of the chat bubble.
  /// - [alignment] (`AxisAlignmentGeometry?`, optional): The alignment of the chat bubble.
  /// - [border] (`BorderSide?`, optional): The border of the chat bubble.
  /// - [padding] (`EdgeInsetsGeometry?`, optional): The padding inside the chat bubble.
  /// - [borderRadius] (`BorderRadiusGeometry?`, optional): The border radius of the chat bubble.
  /// - [widthFactor] (`double?`, optional): The width factor of the chat bubble.
  /// - [textStyle] (`TextStyle?`, optional): The text style for chat bubble content.
  const MyChatBubble({
    super.key,
    required this.child,
    this.type,
    this.color,
    this.alignment,
    this.border,
    this.padding,
    this.borderRadius,
    this.widthFactor,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final alignment = effectiveAlignment(context);
    final type = effectiveType(context);
    final effectiveData =
        context.maybeWatch<MyChatBubbleData>() ??
        const MyChatBubbleData(index: 0, length: 1);
    final widthFactor = effectiveWidthFactor(context);
    final textStyle = effectiveTextStyle(context);
    final effectiveChild = textStyle == null
        ? child
        : DefaultTextStyle.merge(style: textStyle, child: child);
    return _ChatConstrainedBox(
      widthFactor: widthFactor,
      alignment: alignment,
      child: Builder(
        builder: (context) {
          return type.wrap(context, effectiveChild, effectiveData, this);
        },
      ),
    );
  }

  /// Resolves the bubble alignment using direct values, scoped defaults, then
  /// the built-in fallback.
  AxisAlignmentGeometry effectiveAlignment(BuildContext context) {
    return alignment ??
        context.maybeWatch<MyChatTheme>()?.alignment ??
        AxisAlignmentDirectional.end;
  }

  /// Resolves the bubble type using direct values, scoped defaults, then the
  /// built-in fallback.
  MyChatBubbleType effectiveType(BuildContext context) {
    return type ??
        context.maybeWatch<MyChatTheme>()?.type ??
        MyChatBubbleType.tail;
  }

  /// Resolves the bubble color using direct values, scoped defaults, then the
  /// active design-system color.
  Color effectiveColor(BuildContext context) {
    return color ??
        context.maybeWatch<MyChatTheme>()?.color ??
        MyTheme.of(context).colorScheme.primary;
  }

  /// Resolves the bubble padding.
  EdgeInsetsGeometry effectivePadding(
    BuildContext context,
    EdgeInsetsGeometry? typePadding,
  ) {
    return padding ??
        typePadding ??
        context.maybeWatch<MyChatTheme>()?.padding ??
        const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
  }

  /// Resolves the bubble border radius.
  BorderRadiusGeometry effectiveBorderRadius(
    BuildContext context,
    BorderRadiusGeometry? typeBorderRadius,
  ) {
    return borderRadius ??
        typeBorderRadius ??
        context.maybeWatch<MyChatTheme>()?.borderRadius ??
        MyBorderRadius.large;
  }

  /// Resolves the bubble border.
  BorderSide? effectiveBorder(BuildContext context, BorderSide? typeBorder) {
    return border ?? typeBorder ?? context.maybeWatch<MyChatTheme>()?.border;
  }

  /// Resolves the bubble width factor.
  double effectiveWidthFactor(BuildContext context) {
    return widthFactor ?? context.maybeWatch<MyChatTheme>()?.widthFactor ?? 0.5;
  }

  /// Resolves the content text style.
  TextStyle? effectiveTextStyle(BuildContext context) {
    return textStyle ?? context.maybeWatch<MyChatTheme>()?.textStyle;
  }
}

class MyChatReaction extends StatelessWidget {
  final Widget child;

  /// The alignment used to infer the reaction corner when [corner] is not set.
  final AxisAlignmentGeometry? alignment;

  final MyChatBubbleCornerDirectional? corner;
  final Widget reaction;

  /// The minimum extra width the bubble keeps beyond the reaction when the
  /// reaction is wider than the bubble.
  final double? extraWidth;

  const MyChatReaction({
    super.key,
    this.alignment,
    this.corner,
    this.extraWidth,
    required this.reaction,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final textDirection = Directionality.maybeOf(context) ?? TextDirection.ltr;
    final chatTheme = context.maybeWatch<MyChatTheme>() ?? const MyChatTheme();

    // The bubble's alignment within the chat row (defaults to end/right).
    final resolvedAlignment =
        (alignment ?? chatTheme.alignment ?? AxisAlignmentDirectional.end)
            .resolve(textDirection);
    final alignmentValue = resolvedAlignment.resolveValue(Axis.horizontal);

    // Resolve the corner: explicit widget/theme corner first, otherwise place
    // the reaction on the side opposite the bubble's alignment (a right-aligned
    // bubble gets its reaction on the left, and vice versa).
    final directionalCorner = corner;
    final MyChatBubbleCorner resolvedCorner;
    if (directionalCorner != null) {
      resolvedCorner = directionalCorner.resolve(textDirection);
    } else {
      resolvedCorner = alignmentValue > 0
          ? MyChatBubbleCorner.bottomLeft
          : MyChatBubbleCorner.bottomRight;
    }

    final chatPadding =
        (chatTheme.padding ??
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8))
            .resolve(textDirection);
    final reactionPadding = switch (resolvedCorner) {
      MyChatBubbleCorner.topLeft => EdgeInsets.only(left: 12, top: 12),
      MyChatBubbleCorner.topRight => EdgeInsets.only(right: 12, top: 12),
      MyChatBubbleCorner.bottomLeft => EdgeInsets.only(left: 12, bottom: 12),
      MyChatBubbleCorner.bottomRight => EdgeInsets.only(right: 12, bottom: 12),
    };
    final newChatPadding =
        chatPadding +
        EdgeInsets.only(
          top: reactionPadding.top * (2 / 3),
          bottom: reactionPadding.bottom * (2 / 3),
        );
    final reactionChatTheme = chatTheme.copyWith(
      alignment: () => alignment ?? chatTheme.alignment,
      padding: () => newChatPadding,
      widthFactor: () => 1.0,
    );

    return _ChatReaction(
      corner: resolvedCorner,
      alignment: resolvedAlignment,
      extraWidth: extraWidth ?? 8,
      padding: reactionPadding,
      children: [
        MyProvider<MyChatTheme>(
          // Force the bubble to hug its content (widthFactor 1.0) so it isn't
          // squeezed to half-width by its own ChatConstrainedBox when the
          // reaction render object tightens it to its natural width.
          data: reactionChatTheme,
          notifyUpdate: (oldWidget) => oldWidget.data != reactionChatTheme,
          child: child,
        ),
        reaction,
      ],
    );
  }
}

class MyChatReactionContainer extends StatelessWidget {
  final Widget child;
  const MyChatReactionContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final t = MyTheme.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: MyBorderRadius.round,
        color: t.colorScheme.muted.lighten(0.05),
        border: Border.all(color: t.colorScheme.muted.darken(0.1), width: 3),
      ),
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      child: child,
    );
  }
}

class _ChatReaction extends MultiChildRenderObjectWidget {
  final MyChatBubbleCorner corner;
  final EdgeInsets padding;
  final double extraWidth;
  final AxisAlignment alignment;
  const _ChatReaction({
    required this.corner,
    required this.padding,
    required this.extraWidth,
    required this.alignment,
    required super.children,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _ChatReactionRenderObject(
      corner: corner,
      padding: padding,
      extraWidth: extraWidth,
      alignment: alignment,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _ChatReactionRenderObject renderObject,
  ) {
    if (renderObject.corner != corner) {
      renderObject.corner = corner;
      renderObject.markNeedsLayout();
    }
    if (renderObject.padding != padding) {
      renderObject.padding = padding;
      renderObject.markNeedsLayout();
    }
    if (renderObject.extraWidth != extraWidth) {
      renderObject.extraWidth = extraWidth;
      renderObject.markNeedsLayout();
    }
    if (renderObject.alignment != alignment) {
      renderObject.alignment = alignment;
      renderObject.markNeedsLayout();
    }
  }
}

class _ChatReactionParentData extends ContainerBoxParentData<RenderBox> {}

/// Lays out a chat bubble with a reaction badge protruding from one of its
/// corners.
///
/// The first child is the bubble and the second child is the reaction. The
/// bubble and reaction each size themselves; if the reaction is wider than the
/// bubble, the bubble is expanded to at least the reaction width plus
/// [extraWidth]. The reaction is then anchored to [corner] — above the bubble
/// for the top corners and below it for the bottom corners — with [padding]
/// pulling it toward the widget's center. The render box grows to contain both
/// children so nothing is clipped.
class _ChatReactionRenderObject extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _ChatReactionParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _ChatReactionParentData> {
  MyChatBubbleCorner corner;
  EdgeInsets padding;
  double extraWidth;
  AxisAlignment alignment;
  _ChatReactionRenderObject({
    required this.corner,
    required this.padding,
    required this.extraWidth,
    required this.alignment,
  });

  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! _ChatReactionParentData) {
      child.parentData = _ChatReactionParentData();
    }
  }

  /// Computes the reaction offset relative to the bubble's top-left corner.
  Offset _reactionOffset(Size bubbleSize, Size reactionSize) {
    return switch (corner) {
      MyChatBubbleCorner.topLeft => Offset(
        padding.left,
        padding.top - reactionSize.height,
      ),
      MyChatBubbleCorner.topRight => Offset(
        bubbleSize.width - reactionSize.width - padding.right,
        padding.top - reactionSize.height,
      ),
      MyChatBubbleCorner.bottomLeft => Offset(
        padding.left,
        bubbleSize.height - padding.bottom,
      ),
      MyChatBubbleCorner.bottomRight => Offset(
        bubbleSize.width - reactionSize.width - padding.right,
        bubbleSize.height - padding.bottom,
      ),
    };
  }

  double _constrainedBubbleWidth(
    RenderBox bubbleChild,
    Size reactionSize,
    BoxConstraints constraints,
  ) {
    final intrinsicWidth = bubbleChild.getMaxIntrinsicWidth(double.infinity);
    final desiredWidth = max(intrinsicWidth, reactionSize.width + extraWidth);
    return constraints.constrainWidth(desiredWidth);
  }

  @override
  void performLayout() {
    final bubbleChild = firstChild!;
    final reactionChild = childAfter(bubbleChild)!;
    final childConstraints = constraints.loosen();

    reactionChild.layout(childConstraints, parentUsesSize: true);
    final reactionSize = reactionChild.size;
    final bubbleWidth = _constrainedBubbleWidth(
      bubbleChild,
      reactionSize,
      childConstraints,
    );
    bubbleChild.layout(
      childConstraints.tighten(width: bubbleWidth),
      parentUsesSize: true,
    );
    final bubbleSize = bubbleChild.size;

    // Anchor the reaction to the corner, then shift both children so the
    // combined bounds start at the origin (nothing is clipped).
    final reactionOffset = _reactionOffset(bubbleSize, reactionSize);
    final union = (Offset.zero & bubbleSize).expandToInclude(
      reactionOffset & reactionSize,
    );
    var shift = -union.topLeft;

    // Fill the available width (like a bare ChatBubble) and align the assembly
    // to the bubble's side, so the parent doesn't center a narrow box.
    final double width;
    if (constraints.hasBoundedWidth) {
      width = constraints.maxWidth;
      shift += Offset(
        alignment.alongValue(Axis.horizontal, width - union.width),
        0,
      );
    } else {
      width = union.width;
    }

    (bubbleChild.parentData! as _ChatReactionParentData).offset = shift;
    (reactionChild.parentData! as _ChatReactionParentData).offset =
        reactionOffset + shift;

    size = constraints.constrain(Size(width, union.height));
  }

  @override
  Size computeDryLayout(covariant BoxConstraints constraints) {
    final bubbleChild = firstChild;
    if (bubbleChild == null) return constraints.smallest;
    final reactionChild = childAfter(bubbleChild)!;
    final childConstraints = constraints.loosen();

    final reactionSize = reactionChild.getDryLayout(childConstraints);
    final bubbleWidth = _constrainedBubbleWidth(
      bubbleChild,
      reactionSize,
      childConstraints,
    );
    final bubbleSize = bubbleChild.getDryLayout(
      childConstraints.tighten(width: bubbleWidth),
    );

    final reactionOffset = _reactionOffset(bubbleSize, reactionSize);
    final union = (Offset.zero & bubbleSize).expandToInclude(
      reactionOffset & reactionSize,
    );
    final width = constraints.hasBoundedWidth
        ? constraints.maxWidth
        : union.width;
    return constraints.constrain(Size(width, union.height));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    // Paints the bubble first, then the reaction badge on top.
    defaultPaint(context, offset);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }

  /// The extra height the reaction adds beyond the bubble edge for [corner].
  double _protrusion(double reactionHeight) {
    final overlap = switch (corner) {
      MyChatBubbleCorner.topLeft || MyChatBubbleCorner.topRight => padding.top,
      MyChatBubbleCorner.bottomLeft ||
      MyChatBubbleCorner.bottomRight => padding.bottom,
    };
    return max(0.0, reactionHeight - overlap);
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    final bubbleChild = firstChild;
    if (bubbleChild == null) return 0.0;
    final reactionChild = childAfter(bubbleChild)!;
    return bubbleChild.getMaxIntrinsicHeight(width) +
        _protrusion(reactionChild.getMaxIntrinsicHeight(double.infinity));
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    final bubbleChild = firstChild;
    if (bubbleChild == null) return 0.0;
    final reactionChild = childAfter(bubbleChild)!;
    return bubbleChild.getMinIntrinsicHeight(width) +
        _protrusion(reactionChild.getMinIntrinsicHeight(double.infinity));
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    final bubbleChild = firstChild;
    if (bubbleChild == null) return 0.0;
    final reactionChild = childAfter(bubbleChild)!;
    final bubbleWidth = bubbleChild.getMaxIntrinsicWidth(height);
    final reactionWidth = reactionChild.getMaxIntrinsicWidth(double.infinity);
    // The bubble expands to the reaction width plus [extraWidth] when narrower.
    return reactionWidth > bubbleWidth
        ? reactionWidth + extraWidth
        : bubbleWidth;
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    final bubbleChild = firstChild;
    if (bubbleChild == null) return 0.0;
    final reactionChild = childAfter(bubbleChild)!;
    final bubbleWidth = bubbleChild.getMinIntrinsicWidth(height);
    final reactionWidth = reactionChild.getMinIntrinsicWidth(double.infinity);
    return reactionWidth > bubbleWidth
        ? reactionWidth + extraWidth
        : bubbleWidth;
  }
}

class MyChatCollapsible extends StatelessWidget {
  final Widget child;
  final bool collapsed;

  const MyChatCollapsible({
    super.key,
    required this.collapsed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
