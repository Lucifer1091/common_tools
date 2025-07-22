import 'package:flutter/material.dart';

import '../../../common_tools.dart';
import '../text/td_text.dart';
import 'td_activity_indicator.dart';
import 'td_circle_indicator.dart';
import 'td_point_indicator.dart';

enum TDLoadingSize { small, medium, large }

enum TDLoadingIcon { circle, point, activity }

class TDLoading extends StatelessWidget {
  const TDLoading({
    super.key,
    this.size = TDLoadingSize.medium,
    this.icon = TDLoadingIcon.circle,
    this.iconColor,
    this.axis = Axis.vertical,
    this.text,
    this.refreshWidget,
    this.customIcon,
    this.textColor = Colors.black,
    this.duration = 2000,
  });

  final TDLoadingSize size;

  final TDLoadingIcon? icon;

  final Color? iconColor;

  final String? text;

  final Widget? refreshWidget;

  final Color textColor;

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
          case TDLoadingIcon.activity:
            indicator = TDCupertinoActivityIndicator(
              activeColor: iconColor,
              radius:
                  size == TDLoadingSize.small
                      ? 10
                      : (size == TDLoadingSize.medium ? 11 : 13),
              duration: _innerDuration,
            );
          case TDLoadingIcon.circle:
            indicator = _getCircleIndicator();
          case TDLoadingIcon.point:
            indicator = TDPointBounceIndicator(
              color: iconColor,
              size:
                  size == TDLoadingSize.small
                      ? 12
                      : (size == TDLoadingSize.medium ? 16 : 20),
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
      case TDLoadingSize.large:
        return TDCircleIndicator(
          color: iconColor,
          size: 24,
          lineWidth: 3 * 4 / 3,
          duration: _innerDuration,
        );
      case TDLoadingSize.medium:
        return TDCircleIndicator(
          color: iconColor,
          size: 21,
          lineWidth: 3 * 7 / 6,
          duration: _innerDuration,
        );
      case TDLoadingSize.small:
        return TDCircleIndicator(
          color: iconColor,
          size: 18,
          duration: _innerDuration,
        );
    }
  }

  double _getPaddingWidth() {
    switch (size) {
      case TDLoadingSize.large:
        return 10;
      case TDLoadingSize.medium:
        return 8;
      case TDLoadingSize.small:
        return 6;
    }
  }

  TextStyle _getStlye(BuildContext context) {
    return switch (size) {
      TDLoadingSize.large =>
        context.bodyLarge ?? TextStyle(fontSize: 16, height: 24),
      TDLoadingSize.medium =>
        context.bodyMedium ?? TextStyle(fontSize: 14, height: 22),
      TDLoadingSize.small =>
        context.bodySmall ?? TextStyle(fontSize: 12, height: 20),
    };
  }

  Widget textWidget(BuildContext context) {
    Widget result = TDText(
      text,
      textColor: textColor,
      fontWeight: FontWeight.w400,
      style: _getStlye(
        context,
      ).copyWith(color: textColor, fontWeight: FontWeight.w400),
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
