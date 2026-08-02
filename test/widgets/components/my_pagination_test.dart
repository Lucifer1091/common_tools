import 'package:common_tools/components.dart';
import 'package:common_tools/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('computes visible windows for small and large totals', () {
    final small = MyPagination(page: 2, totalPages: 3, onPageChanged: (_) {});
    expect(small.pages, [1, 2, 3]);
    expect(small.firstShownPage, 1);
    expect(small.lastShownPage, 3);
    expect(small.hasMorePreviousPages, isFalse);
    expect(small.hasMoreNextPages, isFalse);

    final large = MyPagination(
      page: 50,
      totalPages: 100,
      maxPages: 5,
      onPageChanged: (_) {},
    );
    expect(large.pages, [48, 49, 50, 51, 52]);
    expect(large.hasMorePreviousPages, isTrue);
    expect(large.hasMoreNextPages, isTrue);
  });

  testWidgets('active page uses active button style', (tester) async {
    await tester.pumpWidget(
      _ThemeHarness(
        child: MyPagination(page: 2, totalPages: 4, onPageChanged: (_) {}),
      ),
    );

    expect(
      tester
          .widget<MyButton>(find.byKey(const ValueKey('my_pagination.page.2')))
          .type,
      MyButtonType.outline,
    );
    expect(
      tester
          .widget<MyButton>(find.byKey(const ValueKey('my_pagination.page.1')))
          .type,
      MyButtonType.ghost,
    );
  });

  testWidgets('page buttons call onPageChanged with selected page', (
    tester,
  ) async {
    int? selectedPage;

    await tester.pumpWidget(
      _ThemeHarness(
        child: MyPagination(
          page: 1,
          totalPages: 5,
          maxPages: 5,
          onPageChanged: (page) => selectedPage = page,
        ),
      ),
    );

    await tester.tap(find.text('3'));
    expect(selectedPage, 3);

    selectedPage = null;
    await tester.tap(find.text('1'));
    expect(selectedPage, isNull);
  });

  testWidgets('previous and next disable or hide at boundaries', (
    tester,
  ) async {
    await tester.pumpWidget(
      _ThemeHarness(
        child: Column(
          children: [
            MyPagination(page: 1, totalPages: 3, onPageChanged: (_) {}),
            MyPagination(
              page: 1,
              totalPages: 3,
              hidePreviousOnFirstPage: true,
              onPageChanged: (_) {},
            ),
          ],
        ),
      ),
    );

    final previousButtons = tester.widgetList<MyButton>(
      find.byKey(const ValueKey('my_pagination.previous')),
    );
    expect(previousButtons.length, 1);
    expect(previousButtons.single.enabled, isFalse);

    await tester.pumpWidget(
      _ThemeHarness(
        child: MyPagination(
          page: 3,
          totalPages: 3,
          hideNextOnLastPage: true,
          onPageChanged: (_) {},
        ),
      ),
    );
    expect(find.byKey(const ValueKey('my_pagination.next')), findsNothing);
  });

  testWidgets('first and last shortcut buttons select page edges', (
    tester,
  ) async {
    final selectedPages = <int>[];

    await tester.pumpWidget(
      _ThemeHarness(
        child: MyPagination(
          page: 6,
          totalPages: 12,
          maxPages: 3,
          onPageChanged: selectedPages.add,
        ),
      ),
    );

    await tester.tap(find.byKey(const ValueKey('my_pagination.first')));
    await tester.tap(find.byKey(const ValueKey('my_pagination.last')));

    expect(selectedPages, [1, 12]);
  });

  testWidgets('ellipsis buttons jump before and after the visible window', (
    tester,
  ) async {
    final selectedPages = <int>[];

    await tester.pumpWidget(
      _ThemeHarness(
        child: MyPagination(
          page: 6,
          totalPages: 12,
          maxPages: 3,
          onPageChanged: selectedPages.add,
        ),
      ),
    );

    await tester.tap(find.byKey(const ValueKey('my_pagination.previous_more')));
    await tester.tap(find.byKey(const ValueKey('my_pagination.next_more')));

    expect(selectedPages, [4, 8]);
  });

  testWidgets('showLabel false hides labels while keeping navigation buttons', (
    tester,
  ) async {
    await tester.pumpWidget(
      _ThemeHarness(
        child: MyPagination(
          page: 2,
          totalPages: 4,
          showLabel: false,
          onPageChanged: (_) {},
        ),
      ),
    );

    expect(find.text('Previous'), findsNothing);
    expect(find.text('Next'), findsNothing);
    expect(
      find.byKey(const ValueKey('my_pagination.previous')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('my_pagination.next')), findsOneWidget);
  });

  testWidgets('invalid values are clamped without exceptions', (tester) async {
    await tester.pumpWidget(
      _ThemeHarness(
        child: MyPagination(
          page: 99,
          totalPages: -4,
          maxPages: 0,
          onPageChanged: (_) {},
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('narrow width wraps without overflow', (tester) async {
    await tester.pumpWidget(
      _ThemeHarness(
        child: SizedBox(
          width: 90,
          child: MyPagination(
            page: 6,
            totalPages: 12,
            maxPages: 5,
            showLabel: false,
            onPageChanged: (_) {},
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(
      tester.getTopLeft(find.byKey(const ValueKey('my_pagination.next'))).dy,
      greaterThan(
        tester
            .getTopLeft(find.byKey(const ValueKey('my_pagination.previous')))
            .dy,
      ),
    );
  });

  testWidgets('RTL layout renders without exceptions', (tester) async {
    await tester.pumpWidget(
      _ThemeHarness(
        textDirection: TextDirection.rtl,
        child: MyPagination(page: 2, totalPages: 5, onPageChanged: (_) {}),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('2'), findsOneWidget);
  });
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
