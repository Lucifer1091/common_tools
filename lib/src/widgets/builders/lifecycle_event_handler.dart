import 'package:flutter/material.dart';

mixin LifecycleMixin<T extends StatefulWidget> on State<T> {
  LifecycleEventHandler? _lifecycleHandler;

  void onChangeLifecycleState(AppLifecycleState lifecycleState) {}

  @override
  void initState() {
    super.initState();

    _lifecycleHandler = LifecycleEventHandler.listenLifecycle(
      onChangeState: onChangeLifecycleState,
    );
  }

  @override
  void dispose() {
    final handler = _lifecycleHandler;
    if (handler != null) {
      LifecycleEventHandler.unlistenLifecycle(handler);
      _lifecycleHandler = null;
    }
    super.dispose();
  }
}

class LifecycleEventHandler extends WidgetsBindingObserver {
  LifecycleEventHandler({required this.onChangeState});

  final void Function(AppLifecycleState) onChangeState;

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    _statePrevious = _stateCurrent;
    _stateCurrent = state;
    isPaused = state.isPause;

    onChangeState(state);
  }

  static LifecycleEventHandler listenLifecycle({
    required void Function(AppLifecycleState) onChangeState,
  }) {
    final observer = LifecycleEventHandler(onChangeState: onChangeState);
    WidgetsBinding.instance.addObserver(observer);
    return observer;
  }

  static void unlistenLifecycle(LifecycleEventHandler observer) {
    WidgetsBinding.instance.removeObserver(observer);
  }

  static AppLifecycleState _statePrevious = AppLifecycleState.resumed;
  static AppLifecycleState _stateCurrent = AppLifecycleState.resumed;

  static AppLifecycleState get statePrevious => _statePrevious;
  static AppLifecycleState get stateCurrent => _stateCurrent;
  static bool isPaused = false;
}

extension AppLifecycleStateExt on AppLifecycleState {
  bool get isInactive => this == AppLifecycleState.inactive;
  bool get isPause =>
      [AppLifecycleState.hidden, AppLifecycleState.paused].contains(this);

  bool get isResume => [AppLifecycleState.resumed].contains(this);
}
