import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'my_steps_horizontal.dart';
import 'my_steps_vertical.dart';

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

enum MyStepsDirection { horizontal, vertical }

enum MyStepState { success, error, disabled }

class MySteps extends StatefulWidget {
  const MySteps({
    required this.steps,
    super.key,
    this.activeIndex = 0,
    this.direction = MyStepsDirection.horizontal,
    this.status = MyStepState.success,
    this.simple = false,
    this.readOnly = false,
    this.verticalSelect = false,
  });

  final int activeIndex;
  final List<MyStepItem> steps;
  final MyStepsDirection direction;
  final MyStepState status;
  final bool simple;
  final bool readOnly;
  final bool verticalSelect;

  @override
  _MyStepsState createState() => _MyStepsState();
}

class _MyStepsState extends State<MySteps> {
  @override
  Widget build(BuildContext context) {
    final currentActiveIndex =
        widget.activeIndex < 0
            ? 0
            : (widget.activeIndex >= widget.steps.length
                ? widget.steps.length - 1
                : widget.activeIndex);

    return widget.direction == MyStepsDirection.horizontal
        ? MyStepsHorizontal(
          steps: widget.steps,
          activeIndex: currentActiveIndex,
          status: widget.status,
          simple: widget.simple,
          readOnly: widget.readOnly,
        )
        : MyStepsVertical(
          steps: widget.steps,
          activeIndex: currentActiveIndex,
          status: widget.status,
          simple: widget.simple,
          readOnly: widget.readOnly,
          verticalSelect: widget.verticalSelect,
        );
  }
}

class MyStepController extends ValueNotifier<MyStepValue> {
  MyStepController({Map<int, MyStepState>? stepStates, int? currentStep})
    : super(MyStepValue(states: stepStates ?? {}, current: currentStep ?? 0));

  void next() {
    value = MyStepValue(states: value.states, current: value.current + 1);
  }

  void previous() {
    value = MyStepValue(states: value.states, current: value.current - 1);
  }

  void setState(int step, MyStepState? state) {
    final Map<int, MyStepState> newStates = Map.from(value.states);
    if (state == null) {
      newStates.remove(step);
    } else {
      newStates[step] = state;
    }
    value = MyStepValue(states: newStates, current: value.current);
  }

  void jumpTo(int step) {
    value = MyStepValue(states: value.states, current: step);
  }
}

class MyStepValue {
  MyStepValue({required this.states, required this.current});

  final Map<int, MyStepState> states;
  final int current;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MyStepValue &&
        mapEquals(other.states, states) &&
        other.current == current;
  }

  @override
  int get hashCode => Object.hash(states, current);

  @override
  String toString() {
    return 'MyStepValue{states: $states, current: $current}';
  }
}
