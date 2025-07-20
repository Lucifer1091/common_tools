import 'package:flutter/material.dart';

import '../../../common_tools.dart';
import '../button/td_button.dart';
import '../text/td_text.dart';

typedef TDTapEvent = void Function();

enum TDEmptyType { plain, operation }

class TDEmpty extends StatelessWidget {
  const TDEmpty({
    this.type = TDEmptyType.plain,
    this.image,
    this.emptyText,
    this.operationText,
    this.operationTheme,
    this.onTapEvent,
    this.emptyTextColor,
    this.emptyTextFont,
    this.customOperationWidget,
    super.key,
  });

  final TDTapEvent? onTapEvent;

  final Widget? image;

  final String? emptyText;

  final Color? emptyTextColor;

  final TextStyle? emptyTextFont;

  final String? operationText;

  final TDButtonTheme? operationTheme;

  final TDEmptyType type;

  final Widget? customOperationWidget;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          image ??
              Icon(
                Icons.info_rounded,
                size: 96,
                color: ThemeColors.neutral.shade700,
              ),
          Padding(padding: EdgeInsets.only(top: image == null ? 22 : 16)),
          TDText(
            emptyText ?? '',
            fontWeight: FontWeight.w400,
            style:
                emptyTextFont ??
                context.bodyMedium?.copyWith(
                  color:
                      emptyTextColor ??
                      ThemeColors.neutral.shade800.withValues(alpha: 0.6),
                ),
            textColor:
                emptyTextColor ??
                ThemeColors.neutral.shade800.withValues(alpha: 0.6),
          ),
          if (type == TDEmptyType.operation)
            customOperationWidget ??
                Padding(
                  padding: const EdgeInsets.only(top: 32),
                  child: TDButton(
                    text: operationText ?? '',
                    size: TDButtonSize.large,
                    theme: operationTheme ?? TDButtonTheme.primary,
                    width: 179,
                    onTap: onTapEvent,
                  ),
                ),
        ],
      ),
    );
  }
}
