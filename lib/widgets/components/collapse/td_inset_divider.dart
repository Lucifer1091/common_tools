import 'package:flutter/material.dart';

import '../../../constants/theme_colors.dart';

class TDInsetDivider extends StatelessWidget {
  const TDInsetDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 1,
      child: Divider(
        color: ThemeColors.neutral.shade200,
        indent: 16,
        endIndent: 0,
        height: 1,
        thickness: 0.5,
      ),
    );
  }
}
