import 'package:flutter/material.dart';

import '../../../index.dart';
import '../text/td_text.dart';

class TDIndexesAnchor extends StatelessWidget {
  const TDIndexesAnchor({
    required this.sticky,
    required this.text,
    required this.capsuleTheme,
    required this.activeIndex,
    super.key,
    this.builderAnchor,
  });

  final bool sticky;

  final String text;

  final bool capsuleTheme;

  final ValueNotifier<String> activeIndex;

  final Widget? Function(
    BuildContext context,
    String index,
    bool isPinnedToTop,
  )?
  builderAnchor;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: activeIndex,
      builder: (context, value, child) {
        final isPinned = value == text;
        final customAnchor = builderAnchor?.call(context, text, isPinned);
        return customAnchor ??
            Container(
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
              margin: capsuleTheme ? EdgeInsets.symmetric(horizontal: 8) : null,
              decoration: BoxDecoration(
                color: isPinned ? Colors.white : ThemeColors.neutral.shade50,
                borderRadius: capsuleTheme ? BorderRadius.circular(9999) : null,
                border:
                    isPinned
                        ? capsuleTheme
                            ? Border.all(color: ThemeColors.neutral.shade50)
                            : Border(
                              bottom: BorderSide(
                                color: ThemeColors.neutral.shade50,
                              ),
                            )
                        : null,
              ),
              child: TDText(
                text,
                style: (isPinned ? context.labelMedium : context.titleSmall)
                    ?.copyWith(
                      color:
                          isPinned
                              ? ThemeColors.blue.shade600
                              : ThemeColors.neutral.shade900,
                    ),
                textColor:
                    isPinned
                        ? ThemeColors.blue.shade600
                        : ThemeColors.neutral.shade900,
              ),
            );
      },
    );
  }
}
