library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../index.dart';

part 'my_steps_horizontal.dart';
part 'my_steps_vertical.dart';

enum MyStepType { indexed, icon, simple, line }

enum MyStepsDirection { horizontal, vertical }

enum MyStepState { success, error }

enum MyStepSize { large, medium, small }

class MySteps extends StatelessWidget {
  const MySteps({
    required this.steps,
    required this.controller,
    super.key,
    this.direction = MyStepsDirection.horizontal,
    this.size = MyStepSize.medium,
    this.type = MyStepType.indexed,
    this.readOnly = false,
    this.verticalSelect = false,
  });

  final List<MyStepItem> steps;
  final MyStepController controller;
  final MyStepsDirection direction;
  final MyStepSize size;
  final MyStepType type;
  final bool readOnly;
  final bool verticalSelect;

  @override
  Widget build(BuildContext context) {
    return direction == MyStepsDirection.horizontal
        ? _MyStepsHorizontal(
          steps: steps,
          controller: controller,
          size: size,
          type: type,
          readOnly: readOnly,
        )
        : _MyStepsVertical(
          steps: steps,
          activeIndex: 0,
          size: MyStepState.success,
          type: true,
          readOnly: readOnly,
          verticalSelect: verticalSelect,
        );
  }
}

class MyStepController extends ValueNotifier<MyStepValue> {
  MyStepController({
    required int total,
    Map<int, MyStepState>? states,
    int? current,
  }) : super(
         MyStepValue(total: total, states: states ?? {}, current: current ?? 0),
       );

  void next() {
    if (value.current < value.total) {
      value = MyStepValue(
        states: value.states,
        current: value.current + 1,
        total: value.total,
      );
    }
  }

  void previous() {
    if (value.current != 0) {
      value = MyStepValue(
        states: value.states,
        current: value.current - 1,
        total: value.total,
      );
    }
  }

  void setState(int step, MyStepState? state) {
    final Map<int, MyStepState> newStates = Map.from(value.states);
    if (state == null) {
      newStates.remove(step);
    } else {
      newStates[step] = state;
    }
    value = MyStepValue(
      states: newStates,
      current: value.current,
      total: value.total,
    );
  }

  void jumpTo(int step) {
    value = MyStepValue(
      states: value.states,
      current: step,
      total: value.total,
    );
  }
}

class MyStepValue {
  MyStepValue({
    required this.states,
    required this.current,
    required this.total,
  });

  final Map<int, MyStepState> states;
  final int current;
  final int total;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MyStepValue &&
        mapEquals(other.states, states) &&
        other.current == current &&
        other.total == total;
  }

  @override
  int get hashCode => Object.hash(states, current, total);

  @override
  String toString() {
    return 'MyStepValue{states: $states, current: $current, total: $total}';
  }
}

class MyStepItem {
  MyStepItem({
    this.title,
    this.content,
    this.successIcon,
    this.errorIcon,
    this.customContent,
    this.customTitle,
  }) : assert(
         title != null ||
             customTitle != null ||
             content != null ||
             customContent != null,
         'At least one of title, customTitle, content, or customContent must be non-null',
       );

  final String? title;
  final String? content;
  final IconData? successIcon;
  final IconData? errorIcon;
  final Widget? customContent;
  final Widget? customTitle;
}
