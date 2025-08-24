import 'package:flutter/material.dart';

import '../badge/my_badge.dart';
import 'td_action_sheet.dart';

class ActionSheetItem {
  ActionSheetItem({
    required this.label,
    this.textStyle,
    this.icon,
    this.badge,
    this.disabled = false,
    this.iconSize,
    this.group,
  });

  final String label;

  final TextStyle? textStyle;

  final Widget? icon;

  final MyBadge? badge;

  final bool disabled;

  final double? iconSize;

  /// Group, used for multi-line scroll grid with description.
  /// Only effective when [TDActionSheet.theme] equals [TDActionSheetTheme.group].
  /// If this value is not set, the entire [ActionSheetItem] will be ignored and not displayed.
  final String? group;
}
