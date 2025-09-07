library;

import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../index.dart';

part 'my_steps_item.dart';

enum MyStepType { indexed, icon, simple, line, steps, timeline }

enum MyStepState { success, error }

enum MyStepSize { large, medium, small, extraSmall }

class MySteps extends StatelessWidget {
  const MySteps({
    required this.steps,
    this.controller,
    super.key,
    this.direction = Axis.horizontal,
    this.size = MyStepSize.extraSmall,
    this.type = MyStepType.indexed,
    this.readOnly = false,
    this.clickable = false,
  });

  final List<MyStepItem> steps;
  final MyStepController? controller;
  final Axis direction;
  final MyStepSize size;
  final MyStepType type;
  final bool readOnly;
  final bool clickable;

  @override
  Widget build(BuildContext context) {
    final controller0 = controller ?? MyStepController(total: steps.length);

    final direction0 =
        type == MyStepType.steps || type == MyStepType.timeline
            ? Axis.vertical
            : direction;

    final List<Widget> stepItems =
        steps.asMap().entries.map((item) {
          final listener = ValueListenableBuilder<MyStepValue>(
            valueListenable: controller0,
            builder: (context, value, child) {
              return _MyStepsItems(
                direction: direction0,
                index: item.key,
                data: item.value,
                current: value.current,
                stepsCount: steps.length,
                state: value.states[value.current],
                type: type,
                size: size,
                readOnly: readOnly,
                onTap: readOnly || !clickable ? null : controller0.jumpTo,
              );
            },
          );

          if (direction0 == Axis.horizontal) {
            return Expanded(child: listener);
          }

          return listener;
        }).toList();

    if (direction0 == Axis.horizontal) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: stepItems,
      );
    }

    return Column(children: stepItems);
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
    this.time,
    this.customTime,
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
  final String? time;
  final Widget? customTime;
}
