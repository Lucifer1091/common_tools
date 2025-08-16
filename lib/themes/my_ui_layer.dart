import 'package:flutter/material.dart';

import '../widgets/builders/scrollview.dart';
import '../widgets/layout/no_widget.dart';
import 'my_theme.dart';

const kDefaultDuration = Duration(milliseconds: 150);

class MyUILayer extends StatelessWidget {
  const MyUILayer({
    required this.theme,
    super.key,
    this.child,
    this.builder,
    this.enableScrollInterception = false,
    this.darkTheme,
    this.themeMode = ThemeMode.system,
    this.enableThemeAnimation = true,
    this.duration,
  });

  final Widget? child;
  final MyThemeData theme;
  final MyThemeData? darkTheme;
  final ThemeMode themeMode;
  final Widget Function(BuildContext context, Widget? child)? builder;
  final bool enableScrollInterception;
  final bool enableThemeAnimation;
  final Duration? duration;

  @override
  Widget build(BuildContext context) {
    final platformBrightness = MediaQuery.platformBrightnessOf(context);
    final scaledTheme =
        themeMode == ThemeMode.dark ||
                (themeMode == ThemeMode.system &&
                    platformBrightness == Brightness.dark)
            ? darkTheme ?? theme
            : theme;

    return MyAnimatedTheme(
      enableThemeAnimation: enableThemeAnimation,
      duration: duration ?? kDefaultDuration,
      data: scaledTheme,
      child: Builder(
        builder: (context) {
          final theme = MyTheme.of(context);
          return ScrollViewInterceptor(
            enabled: enableScrollInterception,
            child: DefaultTextStyle.merge(
              style: theme.typography.bodyLarge.copyWith(
                color: theme.colorScheme.foreground,
              ),
              child: IconTheme.merge(
                data: IconThemeData(color: theme.colorScheme.foreground),
                child:
                    builder != null
                        ? Builder(
                          builder: (BuildContext context) {
                            return builder!(context, child);
                          },
                        )
                        : child ?? const NoWidget(),
              ),
            ),
          );
        },
      ),
    );
  }
}

class MyAnimatedTheme extends StatelessWidget {
  const MyAnimatedTheme({
    required this.data,
    required this.duration,
    required this.child,
    super.key,
    this.curve = Curves.linear,
    this.onEnd,
    this.enableThemeAnimation = true,
  });

  final Widget child;
  final MyThemeData data;
  final Duration duration;
  final Curve curve;
  final VoidCallback? onEnd;
  final bool enableThemeAnimation;

  @override
  Widget build(BuildContext context) {
    if (!enableThemeAnimation || duration == Duration.zero) {
      return MyTheme(data: data, child: child);
    }

    return MyThemeAnimation(
      data: data,
      duration: duration,
      curve: curve,
      child: child,
    );
  }
}
