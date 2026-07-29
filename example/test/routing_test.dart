import 'package:example/base/example_route.dart';
import 'package:example/base/example_base.dart';
import 'package:example/common_tools_catalog.dart';
import 'package:example/config.dart';
import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(configureExampleApp);

  test('route registry includes catalog and sidebar examples', () {
    expect(MyRoute.pageModelList.containsKey('button'), isTrue);
    expect(MyRoute.pageModelList.containsKey('SideBarAnchor'), isTrue);
    expect(MyRoute.pageModelList.containsKey('about'), isTrue);
    expect(examplePageList, isNotEmpty);
  });

  test('component route helper creates browser-friendly paths', () {
    final button = MyRoute.pageModelList['button']!;

    expect(MyRoute.pagePath(button), '/components/button');
    expect(MyRoute.namedPagePath('SideBarAnchor'), '/components/SideBarAnchor');
  });

  test('legacy query routes ignore showAction parameters', () {
    final button = MyRoute.pageModelList['button']!;
    expect(button.showAction, isFalse);

    MyRoute.onGenerateRoute(const RouteSettings(name: 'button?showAction=1'));

    expect(button.showAction, isFalse);
  });

  test('component routes resolve without hitting the not found path', () {
    final route = MyRoute.onGenerateRoute(
      const RouteSettings(name: '/components/button'),
    );

    expect(route.settings.name, '/components/button');
    expect(route, isA<MaterialPageRoute<dynamic>>());
  });

  testWidgets('root route renders the example app home', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1200, 1200);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const _RouteHarness(initialRoute: MyRoute.homePath),
    );
    await tester.pumpAndSettle();

    expect(find.text('My Components'), findsOneWidget);
  });

  testWidgets('components index route renders the example app home', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1200, 1200);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const _RouteHarness(initialRoute: '/components'));
    await tester.pumpAndSettle();

    expect(find.text('My Components'), findsOneWidget);
    expect(find.text('Page not found'), findsNothing);
  });

  testWidgets('component deep links can go back to the components index', (
    tester,
  ) async {
    MyRoute.add(
      ExamplePageModel(
        text: 'Routing Fixture',
        name: 'routing-fixture',
        pageBuilder: (context, model) =>
            const Scaffold(body: Text('Routing fixture')),
      ),
    );
    final navigatorKey = GlobalKey<NavigatorState>();
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1200, 1200);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      _RouteHarness(
        initialRoute: '/components/routing-fixture',
        navigatorKey: navigatorKey,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Routing fixture'), findsOneWidget);
    expect(find.text('Page not found'), findsNothing);

    navigatorKey.currentState!.pop();
    await tester.pump();

    expect(find.text('My Components'), findsOneWidget);
    expect(find.text('Page not found'), findsNothing);
  });

  testWidgets('unknown routes render a not found page', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1200, 1200);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const _RouteHarness(initialRoute: '/components/not-a-real-page'),
    );
    await tester.pumpAndSettle();

    expect(find.text('Page not found'), findsOneWidget);
    expect(find.textContaining('No example page matches'), findsOneWidget);
  });
}

class _RouteHarness extends StatelessWidget {
  const _RouteHarness({required this.initialRoute, this.navigatorKey});

  final String initialRoute;
  final GlobalKey<NavigatorState>? navigatorKey;

  @override
  Widget build(BuildContext context) {
    const typography = MyTypography.geist();
    final lightScheme = MyColorScheme.fromName(
      'blue',
      brightness: Brightness.light,
    );
    final darkScheme = MyColorScheme.fromName(
      'blue',
      brightness: Brightness.dark,
    );

    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        initialRoute: initialRoute,
        theme: lightScheme.toMaterialTheme(typography: typography),
        darkTheme: darkScheme.toMaterialTheme(typography: typography),
        builder: (context, child) {
          return MyUILayer(
            theme: lightScheme,
            darkTheme: darkScheme,
            typography: typography,
            child: child,
          );
        },
        onGenerateRoute: MyRoute.onGenerateRoute,
      ),
    );
  }
}
