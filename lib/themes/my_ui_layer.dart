import 'package:flutter/material.dart';

import '../index.dart';

const kDefaultDuration = Duration(milliseconds: 150);

class MyUILayer extends StatelessWidget {
  const MyUILayer({
    required this.theme,
    super.key,
    this.child,
    this.builder,
    this.darkTheme,
    this.themeMode = ThemeMode.system,
    this.typography,
    this.enableThemeAnimation = true,
    this.enableFocusOutline = true,
    this.duration,
  });

  final Widget? child;
  final MyColorScheme theme;
  final MyColorScheme? darkTheme;
  final MyTypography? typography;
  final ThemeMode themeMode;
  final Widget Function(BuildContext context, Widget? child)? builder;
  final bool enableThemeAnimation;
  final bool enableFocusOutline;
  final Duration? duration;

  @override
  Widget build(BuildContext context) {
    final platformBrightness = MediaQuery.platformBrightnessOf(context);
    final myTheme =
        themeMode == ThemeMode.dark ||
                (themeMode == ThemeMode.system &&
                    platformBrightness == Brightness.dark)
            ? darkTheme ?? theme
            : theme;

    return MyAnimatedTheme(
      enableThemeAnimation: enableThemeAnimation,
      duration: duration ?? kDefaultDuration,
      data: MyThemeData(
        colorScheme: myTheme,
        enableFocusOutline: enableFocusOutline,
        typography: typography ?? MyTypography.geist(),
      ),
      child: Builder(
        builder: (context) {
          final theme = MyTheme.of(context);
          return MyScrollWrapper(
            scrollbars: MyPlatform.isDesktopOrWeb,
            child: IconTheme.merge(
              data: IconThemeData(color: theme.colorScheme.foreground),
              child:
                  builder != null
                      ? Builder(builder: (context) => builder!(context, child))
                      : child ?? const SizedBox.shrink(),
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
