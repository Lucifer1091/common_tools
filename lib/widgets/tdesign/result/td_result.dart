import 'package:flutter/material.dart';

import '../../../index.dart';
import '../text/td_text.dart';

enum TDResultTheme { defaultTheme, success, warning, error }

class TDResult extends StatelessWidget {
  const TDResult({
    super.key,
    this.description,
    this.icon,
    this.titleStyle,
    this.theme = TDResultTheme.defaultTheme,
    this.title = '',
  });

  final Widget? icon;

  final String title;

  final TextStyle? titleStyle;

  final String? description;

  final TDResultTheme theme;

  @override
  Widget build(BuildContext context) {
    final Widget displayIcon = icon ?? _getDefaultIconByTheme(context, theme);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(child: displayIcon),
        if (title.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 17),
            child: TDText(
              title,
              textColor: ThemeColors.neutral.shade900,
              style: (titleStyle ?? context.displayMedium)?.copyWith(
                color: ThemeColors.neutral.shade900,
              ),
            ),
          ),
        if (description?.isNotEmpty ?? false)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: TDText(
              description!,
              textColor: ThemeColors.neutral.shade800,
              style: context.titleSmall?.copyWith(
                color: ThemeColors.neutral.shade800,
              ),
            ),
          ),
      ],
    );
  }

  Widget _getDefaultIconByTheme(BuildContext context, TDResultTheme theme) {
    switch (theme) {
      case TDResultTheme.success:
        return Icon(
          Icons.check_circle_rounded,
          color: ThemeColors.success.shade400,
          size: 70,
        );
      case TDResultTheme.warning:
        return Icon(
          Icons.report_rounded,
          color: ThemeColors.warning.shade400,
          size: 70,
        );
      case TDResultTheme.error:
        return Icon(
          Icons.cancel_rounded,
          color: ThemeColors.error.shade600,
          size: 70,
        );
      case TDResultTheme.defaultTheme:
        return Icon(
          Icons.info_rounded,
          color: ThemeColors.blue.shade600,
          size: 70,
        );
    }
  }
}
