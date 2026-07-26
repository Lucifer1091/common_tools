import 'package:flutter/widgets.dart';

import '../widgets/components/loading/my_loading_overlay.dart';
import '../widgets/components/toast/my_toast.dart';

/// Provides overlay controllers owned by one application root.
class MyOverlayScope extends InheritedWidget {
  const MyOverlayScope({
    required this.toast,
    required this.loading,
    required super.child,
    super.key,
  });

  final MyToastController toast;
  final MyLoadingController loading;

  static MyOverlayScope of(BuildContext context) {
    final scope = maybeOf(context);
    if (scope == null) {
      throw FlutterError(
        'No MyOverlayScope found. Wrap the app with MyUILayer.',
      );
    }
    return scope;
  }

  static MyOverlayScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MyOverlayScope>();
  }

  @override
  bool updateShouldNotify(MyOverlayScope oldWidget) {
    return toast != oldWidget.toast || loading != oldWidget.loading;
  }
}

/// Owns and disposes one isolated pair of app overlay controllers.
class MyOverlayScopeHost extends StatefulWidget {
  const MyOverlayScopeHost({required this.child, super.key});

  final Widget child;

  @override
  State<MyOverlayScopeHost> createState() => _MyOverlayScopeHostState();
}

class _MyOverlayScopeHostState extends State<MyOverlayScopeHost> {
  late final MyToastController _toast = MyToastController();
  late final MyLoadingController _loading = MyLoadingController();

  @override
  void dispose() {
    _toast.dispose();
    _loading.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyOverlayScope(
      toast: _toast,
      loading: _loading,
      child: widget.child,
    );
  }
}
