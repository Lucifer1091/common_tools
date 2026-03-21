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
    ThemeState theme = ref.watch(themeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return MyUILayer(
          themeMode: theme.mode,
          theme: MyColorScheme.fromName(theme.color),
          darkTheme: MyColorScheme.fromName(
            theme.color,
            brightness: Brightness.dark,
          ),
          child: child,
        );
      },
      home: MyHomePage(title: 'My Components'),
      onGenerateRoute: MyRoute.onGenerateRoute,
    );
  }
}
