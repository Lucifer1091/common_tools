import 'package:common_tools/themes/color_schemes/blue.dart';
import 'package:common_tools/themes/my_color_scheme.dart';
import 'package:common_tools/themes/my_theme.dart';
import 'package:common_tools/themes/my_typography.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'base/example_route.dart';
import 'base/intl_resource_delegate.dart';
import 'config.dart';
import 'home.dart';
import 'localizations/app_localizations.dart';
import 'package:common_tools/common_tools.dart';

void main() {
  runApp(const MyApp());

  exampleMap.forEach((key, value) {
    for (var model in value) {
      examplePageList.add(model);
    }
  });
  sideBarExamplePage.forEach(examplePageList.add);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late MyThemeData _themeData;
  // Locale? locale = const Locale('zh');

  @override
  void initState() {
    super.initState();
    // if (kIsWeb) {
    //   if (widget.disableBrowserContextMenu) {
    //     BrowserContextMenu.disableContextMenu();
    //   } else {
    //     BrowserContextMenu.enableContextMenu();
    //   }
    // }

    _themeData = MyThemeData(
      colorScheme: MyBlueColorScheme.light(),
      typography: const MyTypography.geist(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // var delegate = IntlResourceDelegate(context);

    return MaterialApp(
      title: 'TDesign Flutter Example',
      home: PlatformChecker.isWeb
          ? null
          : Builder(
              builder: (context) {
                // TDTheme.setResourceBuilder(
                //   (context) => delegate..updateContext(context),
                //   needAlwaysBuild: true,
                // );
                return MyHomePage(
                  title: AppLocalizations.of(context)?.components ?? '',
                  // locale: locale,
                  // onLocaleChange: (locale) {
                  //   setState(() {
                  //     this.locale = locale;
                  //   });
                  // },
                  onThemeChange: (themeData) {
                    setState(() {
                      _themeData = themeData;
                    });
                  },
                );
              },
            ),
      // locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      onGenerateRoute: TDExampleRoute.onGenerateRoute,
      routes: _getRoutes(),
    );
  }

  Map<String, WidgetBuilder> _getRoutes() {
    if (PlatformChecker.isWeb) {
      return {
        for (var model in examplePageList)
          model.name: (context) => model.pageBuilder.call(context, model),
      }..putIfAbsent(
        '/',
        () =>
            (context) => const MyHomePage(title: 'TDesign Flutter 组件库'),
      );
    } else {
      return const {};
    }
  }
}
