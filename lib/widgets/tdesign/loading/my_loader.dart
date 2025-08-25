import 'package:flutter/material.dart';

import '../../../index.dart';

enum MyLoaderSize { small, medium, large }

enum MyLoaderIcon { circle, point, activity }

class MyLoader extends StatelessWidget {
  const MyLoader({
    super.key,
    this.size = MyLoaderSize.medium,
    this.icon = MyLoaderIcon.circle,
    this.iconColor,
    this.axis = Axis.vertical,
    this.text,
    this.refreshWidget,
    this.customIcon,
    this.textColor,
    this.duration = 2000,
  });

  final MyLoaderSize size;

  final MyLoaderIcon? icon;

  final Color? iconColor;

  final String? text;

  final Widget? refreshWidget;

  final Color? textColor;

  final Axis axis;

  final Widget? customIcon;

  final int duration;

  int get _innerDuration => duration > 0 ? duration : 1;

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
          case MyLoaderIcon.activity:
            indicator = MyCupertinoActivityIndicator(
              activeColor: iconColor,
              radius:
                  size == MyLoaderSize.small
                      ? 10
                      : (size == MyLoaderSize.medium ? 11 : 13),
              duration: _innerDuration,
            );
          case MyLoaderIcon.circle:
            indicator = _getCircleIndicator();
          case MyLoaderIcon.point:
            indicator = MyPointBounceIndicator(
              color: iconColor,
              size:
                  size == MyLoaderSize.small
                      ? 12
                      : (size == MyLoaderSize.medium ? 16 : 20),
              duration: _innerDuration,
            );
        }
      }

      if (text == null) {
        return indicator!;
      } else if (axis == Axis.vertical) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            indicator!,
            SizedBox(height: _getPaddingWidth()),
            textWidget(context),
          ],
        );
      } else {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            indicator!,
            SizedBox(width: _getPaddingWidth()),
            textWidget(context),
          ],
        );
      }
    }
  }

  Widget _getCircleIndicator() {
    switch (size) {
      case MyLoaderSize.large:
        return MyCircleIndicator(
          color: iconColor,
          size: 24,
          lineWidth: 3 * 4 / 3,
          duration: _innerDuration,
        );
      case MyLoaderSize.medium:
        return MyCircleIndicator(
          color: iconColor,
          size: 21,
          lineWidth: 3 * 7 / 6,
          duration: _innerDuration,
        );
      case MyLoaderSize.small:
        return MyCircleIndicator(
          color: iconColor,
          size: 18,
          duration: _innerDuration,
        );
    }
  }

  double _getPaddingWidth() {
    return switch (size) {
      MyLoaderSize.large => 10,
      MyLoaderSize.medium => 8,
      MyLoaderSize.small => 6,
    };
  }

  TextStyle _getStlye(BuildContext context) {
    return switch (size) {
      MyLoaderSize.large => context.bodyLarge,
      MyLoaderSize.medium => context.bodyMedium,
      MyLoaderSize.small => context.bodySmall,
    };
  }

  Widget textWidget(BuildContext context) {
    Widget result = MyText(
      text,
      fontWeight: FontWeight.w400,
      style: _getStlye(context).copyWith(
        color: textColor ?? context.colorScheme.foreground,
        fontWeight: FontWeight.w400,
      ),
      textAlign: TextAlign.center,
    );

    if (refreshWidget != null) {
      result = Row(
        mainAxisSize: MainAxisSize.min,
        children: [result, const SizedBox(width: 8), refreshWidget!],
      );
    }

    return result;
  }
}
