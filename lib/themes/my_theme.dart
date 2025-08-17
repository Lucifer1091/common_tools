import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../index.dart';

class MyThemeData {
  MyThemeData({
    required this.colorScheme,
    this.typography = const MyTypography.geist(),
  });

  MyThemeData.defaults()
    : colorScheme = MyBlueColorScheme.light(),
      typography = MyTypography.geist();

  final MyColorScheme colorScheme;
  final MyTypography typography;

  Brightness get brightness => colorScheme.brightness;

  MyThemeData copyWith({MyColorScheme? colorScheme, MyTypography? typography}) {
    return MyThemeData(
      colorScheme: colorScheme ?? this.colorScheme,
      typography: typography ?? this.typography,
    );
  }

  static MyThemeData lerp(MyThemeData a, MyThemeData b, double t) {
    return MyThemeData(
      colorScheme: MyColorScheme.lerp(a.colorScheme, b.colorScheme, t),
      typography: MyTypography.lerp(a.typography, b.typography, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MyThemeData &&
        other.colorScheme == colorScheme &&
        other.typography == typography;
  }

  @override
  int get hashCode {
    return Object.hash(colorScheme, typography);
  }

  @override
  String toString() {
    return 'MyThemeData(colorScheme: $colorScheme, typography: $typography)';
  }
}

class MyTheme extends InheritedTheme {
  const MyTheme({required this.data, required super.child, super.key});

  final MyThemeData data;

  static MyThemeData of(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<MyTheme>();
    assert(theme != null, 'No MyTheme found in context');
    return theme!.data;
  }

  @override
  bool updateShouldNotify(covariant MyTheme oldWidget) {
    return oldWidget.data != data;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    final MyTheme? ancestorTheme =
        context.findAncestorWidgetOfExactType<MyTheme>();

    return identical(this, ancestorTheme)
        ? child
        : MyTheme(data: data, child: child);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<MyThemeData>('data', data));
  }
}

class MyThemeDataTween extends Tween<MyThemeData> {
  MyThemeDataTween({required MyThemeData super.begin, required super.end});

  @override
  MyThemeData lerp(double t) {
    if (end == null) return begin!;

    return MyThemeData.lerp(begin!, end!, t);
  }
}

class MyThemeAnimation extends ImplicitlyAnimatedWidget {
  const MyThemeAnimation({
    required this.data,
    required super.duration,
    required this.child,
    super.key,
    super.curve,
  });
  final MyThemeData data;
  final Widget child;

  @override
  _AnimatedThemeState createState() => _AnimatedThemeState();
}

class _AnimatedThemeState extends AnimatedWidgetBaseState<MyThemeAnimation> {
  MyThemeDataTween? _data;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _data =
        visitor(
              _data,
              widget.data,
              (value) =>
                  MyThemeDataTween(begin: value as MyThemeData, end: null),
            )
            as MyThemeDataTween?;
  }

  @override
  Widget build(BuildContext context) {
    final theme = _data!.evaluate(animation);
    return MyTheme(data: theme, child: widget.child);
  }
}
