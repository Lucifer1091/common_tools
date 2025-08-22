import 'package:flutter/material.dart';

import '../../../index.dart';

/// Limit the function type to prevent the wrong function from being passed,
/// which may cause parameter mismatch.
typedef LinkClick = void Function(Uri? uri);

enum MyLinkType { basic, withUnderline, withPrefix, withSuffix }

enum MyLinkStyle { primary, defaultStyle, danger, warning, success }

enum MyLinkState { normal, active, disabled }

enum MyLinkSize { small, medium, large }

class TDLink extends StatelessWidget {
  const TDLink({
    required this.label,
    super.key,
    this.uri,
    this.prefixIcon,
    this.suffixIcon,
    this.linkClick,
    this.type = MyLinkType.basic,
    this.style = MyLinkStyle.defaultStyle,
    this.state = MyLinkState.normal,
    this.size = MyLinkSize.medium,
    this.color,
    this.iconSize,
    this.fontSize,
    this.leftGapWithIcon,
    this.rightGapWithIcon,
  });

  final String label;

  final Uri? uri;

  final MyLinkType type;

  final MyLinkStyle style;

  final MyLinkState state;

  final MyLinkSize size;

  final Icon? prefixIcon;

  final Icon? suffixIcon;

  final Color? color;

  final double? iconSize;

  final double? fontSize;

  final double? leftGapWithIcon;

  final double? rightGapWithIcon;

  final LinkClick? linkClick;

  @override
  Widget build(BuildContext context) {
    if (type == MyLinkType.withPrefix) {
      return Row(
        children: [
          if (prefixIcon == null) _getDefaultIcon(context) else prefixIcon!,
          SizedBox(width: _getLeftGapSize(context)),
          _buildLink(context),
        ],
      );
    } else if (type == MyLinkType.withSuffix) {
      return Row(
        children: [
          _buildLink(context),
          SizedBox(width: _getRightGapSize(context)),
          if (suffixIcon == null) _getDefaultIcon(context) else suffixIcon!,
        ],
      );
    }

    return _buildLink(context);
  }

  Color getColor(BuildContext context) {
    if (color != null) return color!;

    final colorMap = {
      MyLinkState.normal: {
        MyLinkStyle.primary: context.colorScheme.primary,
        MyLinkStyle.danger: ThemeColors.error.shade500,
        MyLinkStyle.warning: ThemeColors.warning.shade400,
        MyLinkStyle.success: ThemeColors.success.shade400,
        MyLinkStyle.defaultStyle: ThemeColors.neutral.shade900,
      },
      MyLinkState.active: {
        MyLinkStyle.primary: ThemeColors.blue.shade700,
        MyLinkStyle.danger: ThemeColors.error.shade600,
        MyLinkStyle.warning: ThemeColors.warning.shade500,
        MyLinkStyle.success: MyColors.success.shade500,
        MyLinkStyle.defaultStyle: ThemeColors.blue.shade700,
      },
      MyLinkState.disabled: {
        MyLinkStyle.primary: ThemeColors.blue.shade200,
        MyLinkStyle.danger: ThemeColors.error.shade200,
        MyLinkStyle.warning: ThemeColors.warning.shade200,
        MyLinkStyle.success: ThemeColors.success.shade200,
        MyLinkStyle.defaultStyle: ThemeColors.neutral.shade600,
      },
    };

    return colorMap[state]?[style] ?? ThemeColors.neutral.shade900;
  }

  Widget _getDefaultIcon(BuildContext context) {
    return Icon(
      type == MyLinkType.withPrefix
          ? Icons.link_rounded
          : Icons.open_in_new_rounded,
      size: _getIconSize(context),
      color: getColor(context),
    );
  }

  Widget _buildLink(BuildContext context) {
    return InkWell(
      onTap: () {
        if (state == MyLinkState.disabled) return;

        linkClick?.call(uri);
      },
      child: MyText(
        label,
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
          MyLinkSize.large => 18,
          MyLinkSize.medium => 16,
          MyLinkSize.small => 14,
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

  double _getLeftGapSize(BuildContext context) {
    return leftGapWithIcon ??
        switch (size) {
          MyLinkSize.large => 14.64,
          MyLinkSize.medium => 6.05,
          MyLinkSize.small => 6.34,
        };
  }

  double _getRightGapSize(BuildContext context) {
    return rightGapWithIcon ??
        switch (size) {
          MyLinkSize.large => 15.37,
          MyLinkSize.medium => 6.63,
          MyLinkSize.small => 7,
        };
  }
}
