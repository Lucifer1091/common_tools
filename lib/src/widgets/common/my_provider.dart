import 'package:flutter/widgets.dart';

extension ProviderReadExt on BuildContext {
  T read<T>() => MyProvider.of<T>(this, listen: false);

  T? maybeRead<T>() => MyProvider.maybeOf<T>(this, listen: false);
}

extension ProviderWatchExt on BuildContext {
  T watch<T>() => MyProvider.of<T>(this);

  T? maybeWatch<T>() => MyProvider.maybeOf<T>(this);
}

class MyProvider<T> extends InheritedWidget {
  const MyProvider({
    required super.child,
    required this.data,
    super.key,
    this.notifyUpdate,
  });

  /// The data to be provided
  final T data;

  /// Whether to notify the update of the provider, defaults to false
  final bool Function(MyProvider<T> oldWidget)? notifyUpdate;

  static T of<T>(BuildContext context, {bool listen = true}) {
    final inherited = maybeOf<T>(context, listen: listen);

    if (inherited == null) {
      throw FlutterError(
        'Could not find $T InheritedWidget in the ancestor widget tree.',
      );
    }

    return inherited;
  }

  static T? maybeOf<T>(BuildContext context, {bool listen = true}) {
    if (listen) {
      return context.dependOnInheritedWidgetOfExactType<MyProvider<T>>()?.data;
    }

    final provider = context
        .getElementForInheritedWidgetOfExactType<MyProvider<T>>()
        ?.widget;

    return (provider as MyProvider<T>?)?.data;
  }

  @override
  bool updateShouldNotify(covariant MyProvider<T> oldWidget) {
    return notifyUpdate?.call(oldWidget) ?? false;
  }
}
