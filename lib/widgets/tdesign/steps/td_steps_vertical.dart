import 'package:flutter/material.dart';

import 'td_steps.dart';
import 'td_steps_vertical_item.dart';

class TDStepsVertical extends StatelessWidget {
  const TDStepsVertical({
    required this.steps,
    required this.activeIndex,
    required this.status,
    required this.simple,
    required this.readOnly,
    required this.verticalSelect,
    super.key,
  });

  final List<TDStepsItemData> steps;
  final int activeIndex;
  final TDStepsStatus status;
  final bool simple;
  final bool readOnly;
  final bool verticalSelect;

  @override
  Widget build(BuildContext context) {
    final stepsCount = steps.length;
    final List<Widget> stepsVerticalItem =
        steps.asMap().entries.map((item) {
          return TDStepsVerticalItem(
            index: item.key,
            data: item.value,
            stepsCount: stepsCount,
            activeIndex: activeIndex,
            status: status,
            simple: simple,
            readOnly: readOnly,
            verticalSelect: verticalSelect,
          );
        }).toList();

    return Column(children: stepsVerticalItem);
  }
}
