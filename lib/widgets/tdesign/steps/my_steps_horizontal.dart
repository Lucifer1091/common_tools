import 'package:flutter/material.dart';

import 'my_steps.dart';
import 'my_steps_horizontal_item.dart';

class TDStepsHorizontal extends StatelessWidget {
  const TDStepsHorizontal({
    required this.steps,
    required this.activeIndex,
    required this.status,
    required this.simple,
    required this.readOnly,
    super.key,
  });

  final List<TDStepsItemData> steps;
  final int activeIndex;
  final TDStepsStatus status;
  final bool simple;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    final stepsCount = steps.length;
    final List<Widget> stepsHorizontalItem =
        steps.asMap().entries.map((item) {
          return Expanded(
            flex: 1,
            child: TDStepsHorizontalItem(
              index: item.key,
              data: item.value,
              stepsCount: stepsCount,
              activeIndex: activeIndex,
              status: status,
              simple: simple,
              readOnly: readOnly,
            ),
          );
        }).toList();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: stepsHorizontalItem,
    );
  }
}
