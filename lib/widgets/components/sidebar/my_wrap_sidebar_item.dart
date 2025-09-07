import 'package:flutter/material.dart';

import '../../../index.dart';

class MyWrapSideBarItem extends StatelessWidget {
  const MyWrapSideBarItem({
    required this.enabled,
    required this.style,
    super.key,
    this.badge,
    this.icon,
    this.label = '',
    this.contentPadding,
    this.textStyle,
    this.selectedTextStyle,
    this.value = -1,
    this.selected = false,
    this.selectedColor,
    this.topAdjacent = false,
    this.bottomAdjacent = false,
    this.onTap,
    this.selectedBgColor,
    this.unSelectedBgColor,
  });

  final MyBadge? badge;
  final bool enabled;
  final IconData? icon;
  final String label;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? textStyle, selectedTextStyle;
  final int value;
  final bool selected;
  final Color? selectedColor;
  final Color? selectedBgColor;
  final Color? unSelectedBgColor;
  final bool topAdjacent;
  final bool bottomAdjacent;
  final VoidCallback? onTap;
  final MySideBarStyle style;

  static const double preLineWidth = 3.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child:
          style == MySideBarStyle.normal
              ? renderNormalItem(context)
              : renderOutlineItem(context),
    );
  }

  Widget renderNormalItem(BuildContext context) {
    final selectedBg = selectedBgColor ?? context.colorScheme.background;
    return DecoratedBox(
      decoration: BoxDecoration(color: selectedBg),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color:
              selected
                  ? selectedBg
                  : (unSelectedBgColor ?? context.colorScheme.secondary),
          borderRadius:
              bottomAdjacent || topAdjacent
                  ? bottomAdjacent
                      ? const BorderRadius.only(bottomRight: MyRadi.large)
                      : const BorderRadius.only(topRight: MyRadi.large)
                  : null,
        ),
        child: Row(
          children: [
            renderPreLine(context),
            Expanded(
              child: Padding(
                padding:
                    contentPadding ??
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: renderMainContent(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget renderOutlineItem(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 56),
      child: Container(
        decoration: BoxDecoration(color: context.colorScheme.secondary),
        padding: const EdgeInsets.all(8),
        child: Container(
          decoration: BoxDecoration(
            color: selected && enabled ? context.colorScheme.background : null,
            borderRadius: MyBorderRadius.medium,
          ),
          padding: const EdgeInsets.all(8),
          child: renderMainContent(context),
        ),
      ),
    );
  }

  Widget renderMainContent(BuildContext context) {
    return Row(
      children: [renderIcon(context), Expanded(child: renderLabel(context))],
    );
  }

  Widget renderPreLine(BuildContext context) {
    return Visibility(
      visible: enabled && selected,
      replacement: const SizedBox(width: preLineWidth),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: preLineWidth,
            height: 16,
            decoration: BoxDecoration(
              color:
                  selectedTextStyle != null
                      ? selectedTextStyle?.color
                      : (selectedColor ?? context.colorScheme.primary),
              borderRadius: MyBorderRadius.small,
            ),
          ),
        ],
      ),
    );
  }

  Widget renderIcon(BuildContext context) {
    return Visibility(
      visible: icon != null,
      child: Padding(
        padding: const EdgeInsets.only(right: 2),
        child: Icon(
          icon,
          size: 20,
          color:
              !enabled
                  ? context.colorScheme.mutedForeground
                  : selected
                  ? selectedTextStyle != null
                      ? selectedTextStyle?.color
                      : (selectedColor ?? context.colorScheme.primary)
                  : context.colorScheme.secondaryForeground,
        ),
      ),
    );
  }

  Widget renderLabel(BuildContext context) {
    return MyBadgeWrapper(
      badge: badge,
      top: 0,
      right: badge?.type == MyBadgeType.redPoint ? 4 : -4,
      child: MyText(
        label,
        style: selected ? (selectedTextStyle ?? context.bodyLarge) : textStyle,
        fontWeight: selected && enabled ? FontWeight.w600 : FontWeight.w400,
        softWrap: true,
        textColor:
            !enabled
                ? context.colorScheme.mutedForeground
                : selected
                ? selectedColor ?? context.colorScheme.primary
                : context.colorScheme.secondaryForeground,
        //
      ),
    );
  }
}
