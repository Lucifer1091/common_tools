import 'package:flutter/material.dart';

import '../../../index.dart';
import '../text/my_text.dart';

/// Limit the function type to prevent the wrong function from being passed,
/// which may cause parameter mismatch.
typedef LinkClick = void Function(Uri? uri);

enum TDLinkType { basic, withUnderline, withPrefixIcon, withSuffixIcon }

enum TDLinkStyle { primary, defaultStyle, danger, warning, success }

enum TDLinkState { normal, active, disabled }

enum TDLinkSize { small, medium, large }

class TDLink extends StatelessWidget {
  const TDLink({
    required this.label,
    super.key,
    this.uri,
    this.prefixIcon,
    this.suffixIcon,
    this.linkClick,
    this.type = TDLinkType.basic,
    this.style = TDLinkStyle.defaultStyle,
    this.state = TDLinkState.normal,
    this.size = TDLinkSize.medium,
    this.color,
    this.iconSize,
    this.fontSize,
    this.leftGapWithIcon,
    this.rightGapWithIcon,
  });

  final String label;

  final Uri? uri;

  final TDLinkType type;

  final TDLinkStyle style;

  final TDLinkState state;

  final TDLinkSize size;

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
    if (type == TDLinkType.withPrefixIcon) {
      return Row(
        children: [
          if (prefixIcon == null) _getDefaultIcon(context) else prefixIcon!,
          SizedBox(width: _getLeftGapSize(context)),
          _buildLink(context),
        ],
      );
    } else if (type == TDLinkType.withSuffixIcon) {
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
      TDLinkState.normal: {
        TDLinkStyle.primary: ThemeColors.blue.shade600,
        TDLinkStyle.danger: ThemeColors.error.shade500,
        TDLinkStyle.warning: ThemeColors.warning.shade400,
        TDLinkStyle.success: ThemeColors.success.shade400,
        TDLinkStyle.defaultStyle: ThemeColors.neutral.shade900,
      },
      TDLinkState.active: {
        TDLinkStyle.primary: ThemeColors.blue.shade700,
        TDLinkStyle.danger: ThemeColors.error.shade600,
        TDLinkStyle.warning: ThemeColors.warning.shade500,
        TDLinkStyle.success: ThemeColors.success.shade500,
        TDLinkStyle.defaultStyle: ThemeColors.blue.shade700,
      },
      TDLinkState.disabled: {
        TDLinkStyle.primary: ThemeColors.blue.shade200,
        TDLinkStyle.danger: ThemeColors.error.shade200,
        TDLinkStyle.warning: ThemeColors.warning.shade200,
        TDLinkStyle.success: ThemeColors.success.shade200,
        TDLinkStyle.defaultStyle: ThemeColors.neutral.shade600,
      },
    };

    return colorMap[state]?[style] ?? ThemeColors.neutral.shade900;
  }

  Widget _getDefaultIcon(BuildContext context) {
    return Icon(
      type == TDLinkType.withPrefixIcon
          ? Icons.link_rounded
          : Icons.open_in_new_rounded,
      size: _getIconSize(context),
      color: getColor(context),
    );
  }

  Widget _buildLink(BuildContext context) {
    return InkWell(
      onTap: () {
        if (state == TDLinkState.disabled) return;

        linkClick?.call(uri);
      },
      child: MyText(
        label,
        style: TextStyle(
          fontSize: _getFontSize(context),
          color: getColor(context),
          decoration:
              type == TDLinkType.withUnderline
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
          TDLinkSize.large => 18,
          TDLinkSize.medium => 16,
          TDLinkSize.small => 14,
        };
  }

  double _getFontSize(BuildContext context) {
    return fontSize ??
        switch (size) {
          TDLinkSize.large => 16,
          TDLinkSize.medium => 14,
          TDLinkSize.small => 12,
        };
  }

  double _getLeftGapSize(BuildContext context) {
    return leftGapWithIcon ??
        switch (size) {
          TDLinkSize.large => 14.64,
          TDLinkSize.medium => 6.05,
          TDLinkSize.small => 6.34,
        };
  }

  double _getRightGapSize(BuildContext context) {
    return rightGapWithIcon ??
        switch (size) {
          TDLinkSize.large => 15.37,
          TDLinkSize.medium => 6.63,
          TDLinkSize.small => 7,
        };
  }
}
