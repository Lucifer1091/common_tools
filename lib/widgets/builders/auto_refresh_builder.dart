import 'dart:async';
import 'package:flutter/material.dart';

class AutoRefreshBuilder extends StatefulWidget {
  const AutoRefreshBuilder({
    super.key,
    this.run,
    this.builder,
    this.child,
    this.duration = const Duration(seconds: 10),
    this.initialDelay,
    this.enableWidgetBindingObserver = false,
    this.enableTimer = true,
  }) : assert(
         builder != null || child != null,
         'Either builder or child must be provided.',
       );

  /// Called every [duration] if provided.
  final VoidCallback? run;

  /// Called every [duration] with the current tick count if provided.
  final Widget Function(int tick)? builder;

  /// Static child (shown if [builder] is not provided).
  final Widget? child;

  /// Duration between ticks/callbacks.
  final Duration duration;

  /// Initial delay in seconds before starting the timer.
  final int? initialDelay;

  /// Whether to observe app lifecycle and pause/resume timer.
  final bool enableWidgetBindingObserver;

  /// Whether the timer is enabled.
  final bool enableTimer;

  @override
  State<AutoRefreshBuilder> createState() => _AutoRefreshBuilderState();
}

class _AutoRefreshBuilderState extends State<AutoRefreshBuilder>
    with WidgetsBindingObserver {
  Timer? _timer;
  int _tick = 0;

  @override
  void initState() {
    super.initState();
    if (widget.enableWidgetBindingObserver) {
      WidgetsBinding.instance.addObserver(this);
    }
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _tick = 0;

    if (widget.initialDelay != null) {
      Future.delayed(Duration(seconds: widget.initialDelay!), _runPeriodic);
    } else {
      _runPeriodic();
    }
  }

  void _runPeriodic() {
    if (!widget.enableTimer) return;

    _timer = Timer.periodic(widget.duration, (timer) {
      _tick = timer.tick;
      widget.run?.call();
      if (widget.builder != null) setState(() {});
    });
  }

  @override
  void didUpdateWidget(covariant AutoRefreshBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.duration != widget.duration ||
        oldWidget.enableTimer != widget.enableTimer ||
        oldWidget.initialDelay != widget.initialDelay) {
      _startTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    if (widget.enableWidgetBindingObserver) {
      WidgetsBinding.instance.removeObserver(this);
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!widget.enableWidgetBindingObserver) return;
    if (state == AppLifecycleState.resumed) {
      _startTimer();
    } else if (state == AppLifecycleState.paused) {
      _timer?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder?.call(_tick) ??
        widget.child ??
        const SizedBox.shrink();
  }
}
