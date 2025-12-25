import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../index.dart';

enum MyResultTheme { primary, success, warning, error }

class MyResult extends StatelessWidget {
  const MyResult({
    super.key,
    this.theme = MyResultTheme.primary,
    this.icon,
    this.iconSize,
    this.iconColor,
    this.title = '',
    this.subtitle,
    this.titleStyle,
    this.subtitleStyle,
  });

  final MyResultTheme theme;
  final Widget? icon;
  final String title;
  final TextStyle? titleStyle, subtitleStyle;
  final String? subtitle;
  final double? iconSize;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final Widget displayIcon = icon ?? _getDefaultIconByTheme(context, theme);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        displayIcon,
        const Gap(16),
        MyText(
          title,
          style: titleStyle ?? context.titleLarge,
          textAlign: TextAlign.center,
        ),
        const Gap(4),
        if (subtitle != null) ...[
          MyText(
            subtitle,
            style: subtitleStyle ?? context.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  Widget _getDefaultIconByTheme(BuildContext context, MyResultTheme theme) {
    switch (theme) {
      case MyResultTheme.success:
        return Icon(
          CupertinoIcons.check_mark_circled_solid,
          color: MyColors.success,
          size: 70,
        );
      case MyResultTheme.error:
        return Icon(
          CupertinoIcons.xmark_circle_fill,
          color: context.colorScheme.destructive,
          size: 70,
        );
      case MyResultTheme.warning:
        return Icon(
          CupertinoIcons.exclamationmark_triangle_fill,
          color: MyColors.warning,
          size: 70,
        );
      case MyResultTheme.primary:
        return Icon(
          Icons.info_rounded,
          color: context.colorScheme.primary,
          size: 70,
        );
    }
  }
}
