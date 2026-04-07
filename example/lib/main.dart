import 'package:example/theme_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'base/example_route.dart';
import 'config.dart';
import 'home.dart';
import 'package:common_tools/index.dart';

void main() {
  Logger.configure();
  runApp(const ProviderScope(child: MyApp()));

  exampleMap.forEach((key, value) {
    for (var model in value) {
      examplePageList.add(model);
    }
  });
  sideBarExamplePage.forEach(examplePageList.add);
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    final typography = const MyTypography.geist();
    final lightScheme = MyColorScheme.fromName(themeState.color);
    final darkScheme = MyColorScheme.fromName(
      themeState.color,
      brightness: Brightness.dark,
    );

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
      home: MyHomePage(title: 'My Components'),
      onGenerateRoute: MyRoute.onGenerateRoute,
    );
  }
}
