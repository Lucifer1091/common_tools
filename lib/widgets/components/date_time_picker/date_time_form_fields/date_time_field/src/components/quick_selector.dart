import 'package:flutter/material.dart';

import '../../../../../../../index.dart';

/// A model that represents a quick selection dateRange in the quick selection widget.
/// The date range is required but can be null. If null, the quick selection
/// will reset the selected date range.
class QuickDateRange {
  const QuickDateRange({required this.range, required this.label});

  final DateTimeRange? range;
  final String label;
}

/// A widget that displays a list of quick dateRanges that can be selected.
class QuickSelectorWidget extends StatelessWidget {
  const QuickSelectorWidget({
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
  final List<QuickDateRange> ranges;

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
            label: Text(
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
                  ? Colors.red
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
                  Row(
                    children: [
                      const SizedBox(width: 16),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: buildInkWell(context, range),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          Row(
            children: [
              const SizedBox(width: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: buildInkWell(context, ranges.first),
                ),
              ),
            ],
          ),
          const Gap(16),
        ],
      ),
    );
  }

  InkWell buildInkWell(BuildContext context, QuickDateRange range) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => onChanged(range.range),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color:
              range.range == null
                  ? Colors.red
                  : selected == range.range
                  ? selectedColor ?? (context.colorScheme.primary)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            range.label,
            textAlign: TextAlign.left,
            style:
                style ??
                context.bodyMedium.copyWith(
                  color: range.range == null ? Colors.white : null,
                ),
          ),
        ),
      ),
    );
  }
}
