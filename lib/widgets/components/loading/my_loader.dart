library;

import 'dart:math';
import 'package:flutter/material.dart';
import '../../../index.dart';

part 'indicators/ball_clip_rotate_multiple.dart';
part 'indicators/ball_clip_rotate_pulse.dart';

enum MyLoaderIcon { circle, circle2, circle3, point, activity }

class MyLoader extends StatelessWidget {
  const MyLoader({
    super.key,
    this.icon = MyLoaderIcon.circle,
    this.axis = Axis.vertical,
    this.text,
    this.textColor,
    this.refreshWidget,
    this.customIcon,
    this.options = const MyLoaderOptions(),
  });

  final MyLoaderIcon? icon;

  final String? text;

  final Color? textColor;

  final Widget? refreshWidget;

  final Axis axis;

  final Widget? customIcon;

  final MyLoaderOptions options;

  @override
  Widget build(BuildContext context) {
    return Wrap(children: [_contentWidget(context)]);
  }

  Widget _contentWidget(BuildContext context) {
    if (icon == null) {
      return textWidget(context);
    } else {
      Widget? indicator;

      if (customIcon != null) {
        indicator = customIcon;
      } else {
        switch (icon!) {
          case MyLoaderIcon.circle2:
            return _BallClipRotateMultiple(options: options);
          case MyLoaderIcon.circle3:
            return _BallClipRotatePulse(options: options);
          // case MyLoaderIcon.activity:
          //   indicator = MyCupertinoActivityIndicator(
          //     activeColor: iconColor,
          //     radius:
          //         size == MyLoaderSize.small
          //             ? 10
          //             : (size == MyLoaderSize.medium ? 11 : 13),
          //     duration: _innerDuration,
          //   );
          case MyLoaderIcon.circle:
          case _:
            indicator = _getCircleIndicator();
          // case MyLoaderIcon.point:
          //   indicator = MyPointBounceIndicator(
          //     color: iconColor,
          //     size:
          //         size == MyLoaderSize.small
          //             ? 12
          //             : (size == MyLoaderSize.medium ? 16 : 20),
          //     duration: _innerDuration,
          //   );
        }
      }

      if (text == null) {
        return indicator!;
      } else if (axis == Axis.vertical) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            indicator!,
            // SizedBox(height: _getPaddingWidth()),
            textWidget(context),
          ],
        );
      } else {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            indicator!,
            // SizedBox(width: _getPaddingWidth()),
            textWidget(context),
          ],
        );
      }
    }
  }

  Widget _getCircleIndicator() {
    // switch (size) {
    //   case MyLoaderSize.large:
    //     return MyCircleIndicator(
    //       color: iconColor,
    //       size: 24,
    //       lineWidth: 3 * 4 / 3,
    //       duration: _innerDuration,
    //     );
    //   case MyLoaderSize.medium:
    //     return MyCircleIndicator(
    //       color: iconColor,
    //       size: 21,
    //       lineWidth: 3 * 7 / 6,
    //       duration: _innerDuration,
    //     );
    //   case MyLoaderSize.small:
    //   case _:
    //     return MyCircleIndicator(
    //       color: iconColor,
    //       size: 18,
    //       duration: _innerDuration,
    //     );
    // }

    return Placeholder();
  }

  // double _getPaddingWidth() {
  //   return switch (size) {
  //     MyLoaderSize.large => 10,
  //     MyLoaderSize.medium => 8,
  //     MyLoaderSize.small => 6,
  //     _ => 10,
  //   };
  // }

  // TextStyle _getStlye(BuildContext context) {
  //   return switch (size) {
  //     MyLoaderSize.large => context.bodyLarge,
  //     MyLoaderSize.medium => context.bodyMedium,
  //     MyLoaderSize.small => context.bodySmall,
  //     _ => context.bodyLarge,
  //   };
  // }

  Widget textWidget(BuildContext context) {
    Widget result = MyText(
      text,
      fontWeight: FontWeight.w400,
      // style: _getStlye(context).copyWith(
      //   color: textColor ?? context.colorScheme.foreground,
      //   fontWeight: FontWeight.w400,
      // ),
      textAlign: TextAlign.center,
    );

    if (refreshWidget != null) {
      result = Row(
        mainAxisSize: MainAxisSize.min,
        children: [result, const Gap(8), refreshWidget!],
      );
    }

    return result;
  }
}
