import 'package:flutter/material.dart';

typedef ValueBuilderCallback<T> =
    Widget Function(
      BuildContext context,
      T? Function(T? value) setValue,
      T? value,
    );

/// Owns a small local value and exposes a setter to [builder].
class ValueBuilder<T> extends StatefulWidget {
  const ValueBuilder({required this.builder, super.key, this.initialValue});

  final T? initialValue;
  final ValueBuilderCallback<T> builder;

  @override
  State<ValueBuilder<T>> createState() => _ValueBuilderState<T>();
}

class _ValueBuilderState<T> extends State<ValueBuilder<T>> {
  T? _value;
  bool _rebuildScheduled = false;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  void didUpdateWidget(covariant ValueBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      _value = widget.initialValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _setValue, _value);
  }

  T? _setValue(T? value) {
    if (_value == value) return value;

    _value = value;
    _scheduleRebuild();
    return value;
  }

  void _scheduleRebuild() {
    if (_rebuildScheduled) return;
    _rebuildScheduled = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _rebuildScheduled = false;
      if (!mounted) return;
      setState(() {});
    });
  }
}
