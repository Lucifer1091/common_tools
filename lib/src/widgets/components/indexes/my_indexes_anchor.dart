import 'package:flutter/material.dart';

import '../../../constants/my_radius.dart';
import '../../../extensions/context/theme.dart';
import '../../../extensions/context/typography.dart';
import '../../../extensions/widget.dart';
import '../text/my_text.dart';

class MyIndexesAnchor extends StatelessWidget {
  const MyIndexesAnchor({
    required this.sticky,
    required this.text,
    required this.capsuleTheme,
    required this.activeIndex,
    super.key,
    this.anchorBuilder,
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
  anchorBuilder;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: activeIndex,
      builder: (context, value, child) {
        final isPinned = value == text;
        final customAnchor = anchorBuilder?.call(context, text, isPinned);
        return customAnchor ??
            Container(
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
              margin: capsuleTheme
                  ? EdgeInsets.symmetric(horizontal: 8).except(top: 8)
                  : null,
              decoration: BoxDecoration(
                color: isPinned
                    ? context.colorScheme.primary
                    : context.colorScheme.secondary,
                borderRadius: capsuleTheme ? MyBorderRadius.round : null,
                border: isPinned
                    ? capsuleTheme
                          ? Border.all(color: context.colorScheme.border)
                          : Border(
                              bottom: BorderSide(
                                color: context.colorScheme.border,
                              ),
                            )
                    : null,
              ),
              child: MyText(
                text,
                textColor: isPinned
                    ? context.colorScheme.primaryForeground
                    : null,
                style: (isPinned ? context.labelMedium : context.titleSmall),
              ),
            );
      },
    );
  }
}
