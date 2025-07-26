import 'package:flutter/material.dart';

import '../badge/td_badge.dart';

class TDSideBarItem {
  const TDSideBarItem({
    this.badge,
    this.disabled = false,
    this.icon,
    this.textStyle,
    this.label = '',
    this.value = -1,
  });

  final TDBadge? badge;

  final bool disabled;

  final IconData? icon;

  final String label;

  final TextStyle? textStyle;

  final int value;
}
