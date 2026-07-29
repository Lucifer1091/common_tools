import 'package:example/common_tools_catalog.dart';
import 'package:example/theme_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'base/example_route.dart';
import 'config.dart';

void main() {
  configureExampleApp();
  usePathUrlStrategy();
  runApp(const ProviderScope(child: MyApp()));
}

void configureExampleApp() {
  examplePageList
    ..clear()
    ..addAll(exampleMap.values.expand((models) => models))
    ..addAll(sideBarExamplePage);
  MyRoute.init();
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    final typography = const MyTypography.geist();
    final lightScheme = themeState.colorScheme(brightness: Brightness.light);
    final darkScheme = themeState.colorScheme(brightness: Brightness.dark);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightScheme.toMaterialTheme(typography: typography),
      darkTheme: darkScheme.toMaterialTheme(typography: typography),
      themeMode: themeState.mode,
      builder: (context, child) {
        return MyUILayer(
          themeMode: themeState.mode,
          theme: lightScheme,
          darkTheme: darkScheme,
          typography: typography,
          child: child,
        );
      },
      onGenerateRoute: MyRoute.onGenerateRoute,
    );
  }
}
