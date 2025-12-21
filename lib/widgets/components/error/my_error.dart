import 'package:flutter/material.dart';

import '../../../index.dart';

enum MyErrorType { generic, empty, noInternet, restricted, pageNotFound }

class MyError extends StatelessWidget {
  const MyError({
    this.type = MyErrorType.generic,
    this.icon,
    this.iconSize,
    this.iconColor,
    this.title,
    this.subtitle,
    this.titleStyle,
    this.subtitleStyle,
    this.action,
    this.onAction,
    this.buttonText,
    this.buttonType,
    super.key,
  });

  const MyError.generic({
    this.icon,
    this.iconSize,
    this.iconColor,
    this.title = 'Something Went Wrong !!',
    this.subtitle =
        'The application has encountered an unknown error.\nPlease try again later.',
    this.titleStyle,
    this.subtitleStyle,
    this.action,
    this.onAction,
    this.buttonText,
    this.buttonType,
    super.key,
  }) : type = MyErrorType.generic;

  const MyError.empty({
    this.icon,
    this.iconSize,
    this.iconColor,
    this.title = 'No Records Found !!',
    this.subtitle =
        'If using a custom view, try adjusting the filters.\n'
            'Otherwise, create some data !',
    this.titleStyle,
    this.subtitleStyle,
    this.action,
    this.onAction,
    this.buttonText,
    this.buttonType,
    super.key,
  }) : type = MyErrorType.empty;

  const MyError.noInternet({
    this.icon,
    this.iconSize,
    this.iconColor,
    this.title = 'No Internet Connection !!',
    this.subtitle = 'Please check your internet connection and try again.',
    this.titleStyle,
    this.subtitleStyle,
    this.action,
    this.onAction,
    this.buttonText,
    this.buttonType,
    super.key,
  }) : type = MyErrorType.noInternet;

  const MyError.restricted({
    this.icon,
    this.iconSize,
    this.iconColor,
    this.title = 'Restricted Access !!',
    this.subtitle = 'Please refer to your system administrator.',
    this.titleStyle,
    this.subtitleStyle,
    this.action,
    this.onAction,
    this.buttonText,
    this.buttonType,
    super.key,
  }) : type = MyErrorType.restricted;

  const MyError.pageNotFound({
    this.icon,
    this.iconSize,
    this.iconColor,
    this.title = '404, Page Not Found !!',
    this.subtitle = "The page you are looking for doesn't seem to exist.",
    this.titleStyle,
    this.subtitleStyle,
    this.action,
    this.onAction,
    this.buttonText,
    this.buttonType,
    super.key,
  }) : type = MyErrorType.pageNotFound;

  final MyErrorType type;
  final Widget? icon;
  final double? iconSize;
  final Color? iconColor;
  final String? title, subtitle;
  final TextStyle? titleStyle, subtitleStyle;
  final Widget? action;
  final VoidCallback? onAction;
  final String? buttonText;
  final MyButtonType? buttonType;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        icon ?? _getIcon(context),
        const Gap(16),
        if (title != null) ...[
          MyText(
            title,
            style: titleStyle ?? context.titleMedium,
            textAlign: TextAlign.center,
          ),
          const Gap(4),
        ],
        if (subtitle != null) ...[
          MyText(
            subtitle,
            style: subtitleStyle ?? context.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
        if (action != null || onAction != null) ...[
          const Gap(24),
          action ??
              MyButton(
                text: buttonText ?? 'Try Again',
                type: buttonType ?? MyButtonType.primary,
                onTap: onAction,
              ),
        ],
      ],
    );
  }

  Icon _getIcon(BuildContext context) {
    final size = iconSize ?? 96.0;
    final color =
        iconColor ?? context.colorScheme.mutedForeground.scaleAlpha(0.4);

    return switch (type) {
      MyErrorType.generic => Icon(
        Icons.error_rounded,
        size: size,
        color: color,
      ),
      MyErrorType.empty => Icon(Icons.report_rounded, size: size, color: color),
      MyErrorType.noInternet => Icon(
        Icons.perm_scan_wifi_rounded,
        size: size,
        color: color,
      ),
      MyErrorType.restricted => Icon(
        Icons.gpp_maybe_rounded,
        size: size,
        color: color,
      ),
      MyErrorType.pageNotFound => Icon(
        Icons.warning_rounded,
        size: size,
        color: color,
      ),
    };
  }
}
