import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../extensions/context/typography.dart';
import '../button/my_button.dart';

class MyPagination extends StatelessWidget {
  const MyPagination({
    required this.page,
    required this.totalPages,
    required this.onPageChanged,
    super.key,
    this.maxPages = 3,
    this.showSkipToFirstPage = true,
    this.showSkipToLastPage = true,
    this.hidePreviousOnFirstPage = false,
    this.hideNextOnLastPage = false,
    this.showLabel = true,
    this.gap = 4,
    this.alignment = WrapAlignment.center,
    this.buttonSize = MyButtonSize.small,
    this.activeButtonType = MyButtonType.outline,
    this.inactiveButtonType = MyButtonType.ghost,
    this.navigationButtonType = MyButtonType.ghost,
    this.previousLabel = 'Previous',
    this.nextLabel = 'Next',
    this.ellipsis,
    this.previousIcon = LucideIcons.chevronLeft,
    this.nextIcon = LucideIcons.chevronRight,
    this.firstIcon = LucideIcons.chevronsLeft,
    this.lastIcon = LucideIcons.chevronsRight,
  });

  final int page;
  final int totalPages;
  final ValueChanged<int> onPageChanged;
  final int maxPages;
  final bool showSkipToFirstPage;
  final bool showSkipToLastPage;
  final bool hidePreviousOnFirstPage;
  final bool hideNextOnLastPage;
  final bool showLabel;
  final double gap;
  final WrapAlignment alignment;
  final MyButtonSize buttonSize;
  final MyButtonType activeButtonType;
  final MyButtonType inactiveButtonType;
  final MyButtonType navigationButtonType;
  final String previousLabel;
  final String nextLabel;
  final Widget? ellipsis;
  final IconData previousIcon;
  final IconData nextIcon;
  final IconData firstIcon;
  final IconData lastIcon;

  int get effectiveTotalPages => math.max(1, totalPages);

  int get effectiveMaxPages => math.max(1, maxPages);

  int get effectivePage => page.clamp(1, effectiveTotalPages);

  bool get hasPrevious => effectivePage > 1;

  bool get hasNext => effectivePage < effectiveTotalPages;

  List<int> get pages {
    final visibleCount = math.min(effectiveMaxPages, effectiveTotalPages);
    var start = effectivePage - visibleCount ~/ 2;
    var end = start + visibleCount - 1;

    if (start < 1) {
      start = 1;
      end = visibleCount;
    }

    if (end > effectiveTotalPages) {
      end = effectiveTotalPages;
      start = effectiveTotalPages - visibleCount + 1;
    }

    return List<int>.generate(end - start + 1, (index) => start + index);
  }

  int get firstShownPage => pages.first;

  int get lastShownPage => pages.last;

  bool get hasMorePreviousPages => firstShownPage > 1;

  bool get hasMoreNextPages => lastShownPage < effectiveTotalPages;

  @override
  Widget build(BuildContext context) {
    final controls = <Widget>[
      if (!hidePreviousOnFirstPage || hasPrevious)
        _navigationButton(
          key: const ValueKey('my_pagination.previous'),
          icon: previousIcon,
          label: showLabel ? previousLabel : null,
          enabled: hasPrevious,
          onTap: () => _selectPage(effectivePage - 1),
        ),
      if (hasMorePreviousPages) ...[
        if (showSkipToFirstPage && firstShownPage > 2)
          _iconButton(
            key: const ValueKey('my_pagination.first'),
            icon: firstIcon,
            onTap: () => _selectPage(1),
            tooltip: 'First page',
          ),
        _ellipsisButton(
          key: const ValueKey('my_pagination.previous_more'),
          onTap: () => _selectPage(firstShownPage - 1),
        ),
      ],
      for (final currentPage in pages) _pageButton(context, currentPage),
      if (hasMoreNextPages) ...[
        _ellipsisButton(
          key: const ValueKey('my_pagination.next_more'),
          onTap: () => _selectPage(lastShownPage + 1),
        ),
        if (showSkipToLastPage && lastShownPage < effectiveTotalPages - 1)
          _iconButton(
            key: const ValueKey('my_pagination.last'),
            icon: lastIcon,
            onTap: () => _selectPage(effectiveTotalPages),
            tooltip: 'Last page',
          ),
      ],
      if (!hideNextOnLastPage || hasNext)
        _navigationButton(
          key: const ValueKey('my_pagination.next'),
          icon: nextIcon,
          label: showLabel ? nextLabel : null,
          iconPosition: MyButtonIconPosition.right,
          enabled: hasNext,
          onTap: () => _selectPage(effectivePage + 1),
        ),
    ];

    return Wrap(
      alignment: alignment,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: gap,
      runSpacing: gap,
      children: controls,
    );
  }

  Widget _pageButton(BuildContext context, int currentPage) {
    final selected = currentPage == effectivePage;
    return MyButton(
      key: ValueKey('my_pagination.page.$currentPage'),
      type: selected ? activeButtonType : inactiveButtonType,
      size: buttonSize,
      width: _buttonExtent,
      padding: EdgeInsets.zero,
      textStyle: context.bodySmall,
      onTap: selected ? null : () => _selectPage(currentPage),
      text: '$currentPage',
    );
  }

  Widget _navigationButton({
    required Key key,
    required IconData icon,
    required bool enabled,
    required VoidCallback onTap,
    String? label,
    MyButtonIconPosition iconPosition = MyButtonIconPosition.left,
  }) {
    return MyButton(
      key: key,
      type: navigationButtonType,
      size: buttonSize,
      enabled: enabled,
      icon: icon,
      iconPosition: iconPosition,
      text: label,
      padding: label == null ? EdgeInsets.zero : null,
      width: label == null ? _buttonExtent : null,
      onTap: onTap,
    );
  }

  Widget _iconButton({
    required Key key,
    required IconData icon,
    required VoidCallback onTap,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: MyButton(
        key: key,
        type: inactiveButtonType,
        size: buttonSize,
        width: _buttonExtent,
        padding: EdgeInsets.zero,
        icon: icon,
        onTap: onTap,
      ),
    );
  }

  Widget _ellipsisButton({required Key key, required VoidCallback onTap}) {
    return MyButton(
      key: key,
      type: inactiveButtonType,
      size: buttonSize,
      width: _buttonExtent,
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: ellipsis ?? const Icon(LucideIcons.ellipsis, size: 16),
    );
  }

  void _selectPage(int requestedPage) {
    final selectedPage = requestedPage.clamp(1, effectiveTotalPages);
    if (selectedPage == effectivePage) return;
    onPageChanged(selectedPage);
  }

  double get _buttonExtent {
    return switch (buttonSize) {
      MyButtonSize.extraLarge => 48,
      MyButtonSize.large => 40,
      MyButtonSize.medium => 36,
      MyButtonSize.small => 32,
      MyButtonSize.extraSmall => 28,
    };
  }
}
