import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../index.dart';

enum MyLinkType { basic, withUnderline, withPrefix, withSuffix }

enum MyLinkStyle { defaults, primary, danger, warning, success }

enum MyLinkSize { small, medium, large }

class MyLink extends StatelessWidget {
  const MyLink({
    required this.text,
    this.enabled = true,
    super.key,
    this.uri,
    this.icon,
    this.onTap,
    this.type = MyLinkType.basic,
    this.style = MyLinkStyle.defaults,
    this.size = MyLinkSize.medium,
    this.color,
    this.iconSize,
    this.fontSize,
    this.gap,
  });

  final bool enabled;

  final String text;

  final Uri? uri;

  final MyLinkType type;

  final MyLinkStyle style;

  final MyLinkSize size;

  final Icon? icon;

  final Color? color;

  final double? iconSize;

  final double? fontSize;

  final double? gap;

  final ValueChanged<Uri?>? onTap;

  @override
  Widget build(BuildContext context) {
    if (type == MyLinkType.withPrefix) {
      return Row(
        spacing: _getGap(context),
        children: [_getDefaultIcon(context), _buildLink(context)],
      );
    } else if (type == MyLinkType.withSuffix) {
      return Row(
        spacing: _getGap(context),
        children: [_buildLink(context), _getDefaultIcon(context)],
      );
    }

    return _buildLink(context);
  }

  Color getColor(BuildContext context) {
    if (color != null) return color!;

    final colorMap = {
      true: {
        MyLinkStyle.primary: context.colorScheme.primary,
        MyLinkStyle.danger: context.colorScheme.destructive,
        MyLinkStyle.warning: MyColors.warning,
        MyLinkStyle.success: MyColors.success,
        MyLinkStyle.defaults: context.colorScheme.foreground,
      },
      false: {
        MyLinkStyle.primary: context.colorScheme.mutedForeground,
        MyLinkStyle.danger: context.themed(
          MyColors.error.shade300,
          MyColors.error.shade700,
        ),
        MyLinkStyle.warning: context.themed(
          MyColors.warning.shade300,
          MyColors.warning.shade700,
        ),
        MyLinkStyle.success: context.themed(
          MyColors.success.shade300,
          MyColors.success.shade700,
        ),
        MyLinkStyle.defaults: context.colorScheme.mutedForeground,
      },
    };

    return colorMap[enabled]?[style] ?? context.colorScheme.foreground;
  }

  Widget _getDefaultIcon(BuildContext context) {
    return icon ??
        Icon(
          type == MyLinkType.withPrefix
              ? LucideIcons.link
              : LucideIcons.squareArrowOutUpRight,
          size: _getIconSize(context),
          color: getColor(context),
        );
  }

  Widget _buildLink(BuildContext context) {
    return InkWell(
      onTap: !enabled ? null : () => onTap?.call(uri),
      child: MyText(
        text,
        style: TextStyle(
          fontSize: _getFontSize(context),
          color: getColor(context),
          decoration:
              type == MyLinkType.withUnderline
                  ? TextDecoration.underline
                  : null,
          decorationColor: getColor(context),
        ),
      ),
    );
  }

  double _getIconSize(BuildContext context) {
    return iconSize ??
        switch (size) {
          MyLinkSize.large => 16,
          MyLinkSize.medium => 14,
          MyLinkSize.small => 12,
        };
  }

  double _getFontSize(BuildContext context) {
    return fontSize ??
        switch (size) {
          MyLinkSize.large => 16,
          MyLinkSize.medium => 14,
          MyLinkSize.small => 12,
        };
  }

  double _getGap(BuildContext context) {
    return gap ??
        switch (size) {
          MyLinkSize.large => 9,
          MyLinkSize.medium => 8,
          MyLinkSize.small => 7,
        };
  }
}
