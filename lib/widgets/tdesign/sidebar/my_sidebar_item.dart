import 'package:flutter/material.dart';

import '../badge/my_badge.dart';

class MySideBarItem {
  const MySideBarItem({
    this.badge,
    this.disabled = false,
    this.icon,
    this.textStyle,
    this.label = '',
    this.value = -1,
  });

  final MyBadge? badge;

  final bool disabled;

  final IconData? icon;

  final String label;

  final TextStyle? textStyle;

  final int value;
}
