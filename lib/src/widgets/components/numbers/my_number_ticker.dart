import 'package:flutter/material.dart';

import '../../../constants/types.dart';
import '../../animations/animated_value_builder.dart';
import '../text/my_text.dart';

typedef NumberTickerBuilder =
    Widget Function(BuildContext context, num number, Widget? child);

class MyNumberTicker extends StatelessWidget {
  const MyNumberTicker({
    required this.number,
    required this.formatter,
    super.key,
    this.initialNumber,
    this.duration,
    this.curve,
    this.style,
  }) : builder = null,
       child = null;

  const MyNumberTicker.builder({
    required this.number,
    required this.builder,
    super.key,
    this.initialNumber,
    this.child,
    this.duration,
    this.curve,
  }) : formatter = null,
       style = null;

  final num? initialNumber;
  final num number;
  final NumberTickerBuilder? builder;
  final Widget? child;
  final Transformer<num, String>? formatter;
  final Duration? duration;
  final Curve? curve;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final duration = this.duration ?? const Duration(milliseconds: 500);
    final curve = this.curve ?? Curves.easeInOut;

    if (formatter != null) {
      final textStyle = style;
      return AnimatedValueBuilder(
        value: number.toDouble(),
        duration: duration,
        curve: curve,
        initialValue: initialNumber?.toDouble(),
        builder: (context, value, child) {
          return MyText(formatter!(value), style: textStyle);
        },
      );
    }

    return AnimatedValueBuilder(
      value: number.toDouble(),
      duration: duration,
      curve: curve,
      initialValue: initialNumber?.toDouble(),
      builder: (context, value, child) {
        return builder!(context, value, child);
      },
      child: child,
    );
  }
}
