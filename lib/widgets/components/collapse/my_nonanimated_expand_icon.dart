
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../index.dart';

class MyNonAnimatedExpandIcon extends StatelessWidget {
  const MyNonAnimatedExpandIcon({
    required this.isExpanded,
    required this.padding,
    super.key,
  });

  final bool isExpanded;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: padding,
      iconSize: 16,
      onPressed: null,
      icon:
          isExpanded
              ? Icon(
                LucideIcons.chevronUp,
                color: context.colorScheme.mutedForeground,
              )
              : Icon(
                LucideIcons.chevronDown,
                color: context.colorScheme.mutedForeground,
              ),
    );
  }
}
