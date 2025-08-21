import 'dart:async';

import 'package:flutter/material.dart';

import '../../../index.dart';
import '../../../extensions/iterable/index.dart';
import '../text/my_text.dart';
import 'td_swipe_cell_inherited.dart';
import 'td_swipe_cell_panel.dart';

class TDSwipeCellAction extends StatelessWidget {
  const TDSwipeCellAction({
    super.key,
    this.flex = 1,
    this.backgroundColor,
    this.autoClose = true,
    this.onPressed,
    this.icon,
    this.iconColor,
    this.iconSize = 18,
    this.spacing = 2,
    this.label,
    this.labelStyle,
    this.direction = Axis.horizontal,
    this.confirmIndex,
    this.builder,
  }) : assert((flex ?? 1) > 0, 'flex must be greater than 0'),
       assert(icon != null || label != null, 'icon or label must not be null');

  /// Width ratio, default is 1, invalid under [TDSwipeCellPanel.confirms]
  /// (missing occupies the entire [TDSwipeCellPanel] width)
  final int? flex;

  final Color? backgroundColor;

  final bool? autoClose;

  final void Function(BuildContext context)? onPressed;

  final IconData? icon;

  final Color? iconColor;

  final double? iconSize;

  final double? spacing;

  final String? label;

  final TextStyle? labelStyle;

  final Axis? direction;

  /// Specify the index of [TDSwipeCellPanel.children] to open the [TDSwipeCellAction]
  /// This parameter is only configured under the [TDSwipeCellPanel.confirms] parameter
  final List<int>? confirmIndex;

  final WidgetBuilder? builder;

  @override
  Widget build(BuildContext context) {
    final style =
        context.labelMedium ??
        TextStyle(fontSize: 14, height: 22, fontWeight: FontWeight.w600);

    final children = <Widget>[
      if (icon != null)
        Icon(
          icon,
          size: iconSize ?? 18,
          color: labelStyle?.color ?? Colors.white,
        ),

      if (icon != null && label != null) SizedBox(width: spacing ?? 2),

      if (label != null)
        Flexible(
          child: MyText(
            label,
            textColor: Colors.white,
            style: labelStyle ?? style,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
    ];

    final child = GestureDetector(
      onTap: () {
        _handleTap(context);
      },
      child:
          builder?.call(context) ??
          Container(
            width: double.infinity,
            height: double.infinity,
            color: backgroundColor,
            child: Flex(
              mainAxisAlignment: MainAxisAlignment.center,
              direction: direction ?? Axis.horizontal,
              children: children,
            ),
          ),
    );

    return confirmIndex.isNotBlank
        ? child
        : Expanded(flex: flex ?? 1, child: child);
  }

  void _handleTap(BuildContext context) {
    final swipeInherited = TDSwipeCellInherited.of(context)!;
    final openConfirm = swipeInherited.actionClick(this);

    if (openConfirm) return;

    onPressed?.call(context);

    if (autoClose ?? true) {
      unawaited(
        swipeInherited.controller.close(duration: swipeInherited.duration),
      );
    }
  }
}
