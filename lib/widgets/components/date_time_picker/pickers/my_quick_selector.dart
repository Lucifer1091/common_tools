import 'package:flutter/material.dart';

import '../../../../index.dart';

/// A model that represents a quick selection dateRange in the quick selection widget.
/// The date range is required but can be null. If null, the quick selection
/// will reset the selected date range.
class MyQuickDateRange {
  const MyQuickDateRange({required this.range, required this.label});

  final DateTimeRange? range;
  final String label;
}

/// A widget that displays a list of quick dateRanges that can be selected.
class MyQuickSelectorWidget extends StatelessWidget {
  const MyQuickSelectorWidget({
    required this.selected,
    required this.ranges,
    required this.onChanged,
    super.key,
    this.selectedColor,
    this.style,
    this.showChips = false,
  });

  /// The dateRange that is currently selected. A line will be displayed on the left
  /// using the [selectedColor] color.
  final DateTimeRange? selected;

  /// The list of quick dateRanges to display.
  final List<MyQuickDateRange> ranges;

  /// Called when a quick dateRange is selected.
  final ValueChanged<DateTimeRange?> onChanged;

  final Color? selectedColor;

  final TextStyle? style;

  final bool showChips;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !showChips,
      replacement: buildWrap(context),
      child: buildListView(context),
    );
  }

  Widget buildWrap(BuildContext context) {
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: [
        for (final range in ranges.sublist(1))
          InputChip(
            label: MyText(
              range.label,
              style:
                  style ??
                  context.bodySmall.copyWith(fontWeight: FontWeight.w400),
            ),
            pressElevation: 0,
            selected: selected == range.range,
            checkmarkColor: context.colorScheme.primary,
            color: WidgetStatePropertyAll(
              range.range == null
                  ? context.colorScheme.destructive
                  : selected == range.range
                  ? selectedColor ?? context.colorScheme.primary
                  : Colors.transparent,
            ),
            onPressed: () => onChanged(range.range),
          ),
      ],
    );
  }

  SizedBox buildListView(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              children: [
                for (final range in ranges.sublist(1))
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: _buildButton(context, range),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: _buildButton(context, ranges.first),
          ),
          const Gap(16),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context, MyQuickDateRange range) {
    final bool isSelected = selected == range.range;
    final bool isClear = range.range == null;

    final MyButtonType type =
        isClear
            ? MyButtonType.destructive
            : isSelected
            ? MyButtonType.primary
            : MyButtonType.ghost;

    return MyButton(
      type: type,
      text: range.label,
      width: double.maxFinite,
      onTap: () => onChanged(range.range),
    );
  }
}
