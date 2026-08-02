import 'package:common_tools/components.dart';
import 'package:common_tools/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

void main() {
  testWidgets(
    'renders children in order and inserts separators between items',
    (tester) async {
      await tester.pumpWidget(
        const _ThemeHarness(
          child: MyBreadcrumb(
            children: [Text('Home'), Text('Components'), Text('Breadcrumb')],
          ),
        ),
      );

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Components'), findsOneWidget);
      expect(find.text('Breadcrumb'), findsOneWidget);
      expect(find.byType(MyBreadcrumbSeparator), findsNWidgets(2));

      final homeX = tester.getTopLeft(find.text('Home')).dx;
      final componentsX = tester.getTopLeft(find.text('Components')).dx;
      final breadcrumbX = tester.getTopLeft(find.text('Breadcrumb')).dx;

      expect(homeX, lessThan(componentsX));
      expect(componentsX, lessThan(breadcrumbX));
    },
  );

  testWidgets('last item receives current-page styling', (tester) async {
    await tester.pumpWidget(
      const _ThemeHarness(
        child: MyBreadcrumb(
          textStyle: TextStyle(color: Colors.red),
          currentTextStyle: TextStyle(color: Colors.green),
          children: [Text('Home'), Text('Current')],
        ),
      ),
    );

    expect(
      DefaultTextStyle.of(tester.element(find.text('Home'))).style.color,
      Colors.red,
    );
    expect(
      DefaultTextStyle.of(tester.element(find.text('Current'))).style.color,
      Colors.green,
    );
  });

  testWidgets('custom separator is used', (tester) async {
    await tester.pumpWidget(
      const _ThemeHarness(
        child: MyBreadcrumb(
          separator: Icon(LucideIcons.dot),
          children: [Text('One'), Text('Two'), Text('Three')],
        ),
      ),
    );

    expect(find.byIcon(LucideIcons.dot), findsNWidgets(2));
    expect(find.byIcon(LucideIcons.chevronRight), findsNothing);
  });

  testWidgets('link invokes onTap and disabled link ignores taps', (
    tester,
  ) async {
    var enabledTaps = 0;
    var disabledTaps = 0;

    await tester.pumpWidget(
      _ThemeHarness(
        child: Column(
          children: [
            MyBreadcrumbLink(text: 'Enabled', onTap: () => enabledTaps++),
            MyBreadcrumbLink(
              text: 'Disabled',
              enabled: false,
              onTap: () => disabledTaps++,
            ),
          ],
        ),
      ),
    );

    await tester.tap(find.text('Enabled'));
    await tester.tap(find.text('Disabled'));

    expect(enabledTaps, 1);
    expect(disabledTaps, 0);
  });

  testWidgets('long trails wrap instead of overflowing', (tester) async {
    await tester.pumpWidget(
      const _ThemeHarness(
        child: SizedBox(
          width: 130,
          child: MyBreadcrumb(
            children: [
              Text('Workspace'),
              Text('Product'),
              Text('Design System'),
              Text('End'),
            ],
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(
      tester.getTopLeft(find.text('End')).dy,
      greaterThan(tester.getTopLeft(find.text('Workspace')).dy),
    );
  });

  testWidgets('dropdown opens with MyPopover and menu item taps work', (
    tester,
  ) async {
    var tapped = false;

    await tester.pumpWidget(
      _ThemeHarness(
        child: MyBreadcrumb(
          children: [
            const Text('Home'),
            MyBreadcrumbDropdown(
              child: const MyBreadcrumbEllipsis(),
              items: [
                MyBreadcrumbMenuItem(
                  text: 'Hidden route',
                  onTap: () => tapped = true,
                ),
              ],
            ),
            const Text('Current'),
          ],
        ),
      ),
    );

    expect(find.text('Hidden route'), findsNothing);

    await tester.tap(find.byType(MyBreadcrumbEllipsis));
    await _pumpPopover(tester);
    expect(find.text('Hidden route'), findsOneWidget);

    await tester.tap(find.text('Hidden route'));
    await tester.pump();
    expect(tapped, isTrue);
  });

  testWidgets('RTL direction mirrors the start side', (tester) async {
    await tester.pumpWidget(
      const _ThemeHarness(
        textDirection: TextDirection.rtl,
        child: SizedBox(
          width: 420,
          child: MyBreadcrumb(
            textDirection: TextDirection.rtl,
            children: [Text('Home'), Text('Components'), Text('Current')],
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(
      tester.getTopLeft(find.text('Home')).dx,
      greaterThan(tester.getTopLeft(find.text('Current')).dx),
    );
  });
}

Future<void> _pumpPopover(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 200));
  for (var frame = 0; frame < 12; frame++) {
    await tester.pump(const Duration(milliseconds: 16));
  }
}

class _ThemeHarness extends StatelessWidget {
  const _ThemeHarness({
    required this.child,
    this.textDirection = TextDirection.ltr,
  });

  final Widget child;
  final TextDirection textDirection;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyTheme(
        data: MyThemeData(
          colorScheme: MyColorScheme.fromParts(
            base: MyBaseColor.neutral,
            accent: MyAccentColor.blue,
          ),
          typography: const MyTypography.geist(),
        ),
        child: Directionality(
          textDirection: textDirection,
          child: Scaffold(
            body: Align(alignment: Alignment.topLeft, child: child),
          ),
        ),
      ),
    );
  }
}
