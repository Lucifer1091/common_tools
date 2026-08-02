import 'package:common_tools/components.dart';
import 'package:common_tools/theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('hover enter waits before opening', (tester) async {
    await tester.pumpWidget(
      _ThemeHarness(
        child: _TestHoverCard(
          wait: const Duration(milliseconds: 100),
          debounce: Duration.zero,
        ),
      ),
    );

    final mouse = await _hoverTrigger(tester);
    await tester.pump(const Duration(milliseconds: 99));
    expect(find.text('Hover content'), findsNothing);

    await tester.pump(const Duration(milliseconds: 1));
    await _pumpPopover(tester);
    expect(find.text('Hover content'), findsOneWidget);

    await mouse.removePointer();
  });

  testWidgets('exiting before wait prevents opening', (tester) async {
    await tester.pumpWidget(
      _ThemeHarness(
        child: _TestHoverCard(
          wait: const Duration(milliseconds: 100),
          debounce: Duration.zero,
        ),
      ),
    );

    final mouse = await _hoverTrigger(tester);
    await tester.pump(const Duration(milliseconds: 50));
    await mouse.moveTo(const Offset(500, 500));
    await tester.pump(const Duration(milliseconds: 100));
    await _pumpPopover(tester);

    expect(find.text('Hover content'), findsNothing);
    await mouse.removePointer();
  });

  testWidgets('hover exit closes only after debounce', (tester) async {
    await tester.pumpWidget(
      _ThemeHarness(
        child: _TestHoverCard(
          wait: Duration.zero,
          debounce: const Duration(milliseconds: 100),
        ),
      ),
    );

    final mouse = await _openWithHover(tester);
    await mouse.moveTo(const Offset(500, 500));
    await tester.pump(const Duration(milliseconds: 99));
    expect(find.text('Hover content'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 1));
    await _pumpPopover(tester);
    expect(find.text('Hover content'), findsNothing);

    await mouse.removePointer();
  });

  testWidgets('moving from trigger into content keeps the card open', (
    tester,
  ) async {
    await tester.pumpWidget(
      _ThemeHarness(
        child: _TestHoverCard(
          wait: Duration.zero,
          debounce: const Duration(milliseconds: 100),
        ),
      ),
    );

    final mouse = await _openWithHover(tester);
    await mouse.moveTo(tester.getCenter(find.text('Hover content')));
    await tester.pump(const Duration(milliseconds: 150));

    expect(find.text('Hover content'), findsOneWidget);
    await mouse.removePointer();
  });

  testWidgets('long press opens the hover card', (tester) async {
    await tester.pumpWidget(
      const _ThemeHarness(
        child: _TestHoverCard(
          wait: Duration(milliseconds: 500),
          debounce: Duration.zero,
        ),
      ),
    );

    await tester.longPress(find.byKey(_triggerKey));
    await _pumpPopover(tester);

    expect(find.text('Hover content'), findsOneWidget);
  });

  testWidgets('provided controller can show and hide programmatically', (
    tester,
  ) async {
    final controller = MyPopoverController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      _ThemeHarness(child: _TestHoverCard(controller: controller)),
    );

    controller.show();
    await _pumpPopover(tester);
    expect(find.text('Hover content'), findsOneWidget);

    controller.hide();
    await _pumpPopover(tester);
    expect(find.text('Hover content'), findsNothing);

    await tester.pumpWidget(const SizedBox.shrink());
    controller.show();
    controller.hide();
    expect(tester.takeException(), isNull);
  });

  testWidgets('pending delayed callbacks do not throw after dispose', (
    tester,
  ) async {
    await tester.pumpWidget(
      _ThemeHarness(
        child: _TestHoverCard(
          wait: const Duration(milliseconds: 100),
          debounce: const Duration(milliseconds: 100),
        ),
      ),
    );

    await _hoverTrigger(tester);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 200));

    expect(tester.takeException(), isNull);
  });

  testWidgets('InfoWidget renders child trigger', (tester) async {
    await tester.pumpWidget(
      const _ThemeHarness(
        child: MyTooltip(message: 'More details', child: Text('Info trigger')),
      ),
    );

    expect(find.text('Info trigger'), findsOneWidget);
    expect(find.text('More details'), findsNothing);
  });

  testWidgets('InfoWidget tap trigger displays tooltip message', (
    tester,
  ) async {
    await tester.pumpWidget(
      const _ThemeHarness(
        child: MyTooltip(message: 'Tap details', child: _InfoTrigger()),
      ),
    );

    await _tapInfoTrigger(tester);

    expect(find.text('Tap details'), findsOneWidget);
  });

  testWidgets('InfoWidget rich message renders without exceptions', (
    tester,
  ) async {
    await tester.pumpWidget(
      const _ThemeHarness(
        child: MyTooltip(
          richMessage: TextSpan(
            children: [
              TextSpan(text: 'Rich '),
              TextSpan(text: 'details'),
            ],
          ),
          child: _InfoTrigger(),
        ),
      ),
    );

    await _tapInfoTrigger(tester);

    expect(tester.takeException(), isNull);
  });

  testWidgets('InfoWidget accepts custom decoration and constraints', (
    tester,
  ) async {
    await tester.pumpWidget(
      _ThemeHarness(
        child: MyTooltip(
          message: 'Custom details',
          constraints: const BoxConstraints(maxWidth: 120),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(color: Colors.white),
          child: const _InfoTrigger(),
        ),
      ),
    );

    await _tapInfoTrigger(tester);

    expect(find.text('Custom details'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

Future<TestGesture> _hoverTrigger(WidgetTester tester) async {
  final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
  await mouse.addPointer(location: const Offset(1, 1));
  await tester.pump();
  await mouse.moveTo(tester.getCenter(find.byKey(_triggerKey)));
  await tester.pump();
  return mouse;
}

Future<TestGesture> _openWithHover(WidgetTester tester) async {
  final mouse = await _hoverTrigger(tester);
  await tester.pump();
  await _pumpPopover(tester);
  expect(find.text('Hover content'), findsOneWidget);
  return mouse;
}

Future<void> _pumpPopover(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 200));
  await tester.pump();
}

Future<void> _tapInfoTrigger(WidgetTester tester) async {
  await tester.tap(find.byKey(_infoTriggerKey));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 200));
  await tester.pump();
}

const _triggerKey = ValueKey('hover-card-trigger');
const _infoTriggerKey = ValueKey('info-widget-trigger');

class _TestHoverCard extends StatelessWidget {
  const _TestHoverCard({
    this.controller,
    this.wait = Duration.zero,
    this.debounce = Duration.zero,
  });

  final MyPopoverController? controller;
  final Duration wait;
  final Duration debounce;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: MyHoverCard(
        controller: controller,
        wait: wait,
        debounce: debounce,
        hoverBuilder: (context) {
          return const SizedBox(
            width: 160,
            height: 48,
            child: ColoredBox(
              color: Colors.white,
              child: Center(child: Text('Hover content')),
            ),
          );
        },
        child: const SizedBox(
          key: _triggerKey,
          width: 120,
          height: 40,
          child: ColoredBox(
            color: Colors.blue,
            child: Center(child: Text('Trigger')),
          ),
        ),
      ),
    );
  }
}

class _ThemeHarness extends StatelessWidget {
  const _ThemeHarness({required this.child});

  final Widget child;

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
        child: Scaffold(body: child),
      ),
    );
  }
}

class _InfoTrigger extends StatelessWidget {
  const _InfoTrigger();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      key: _infoTriggerKey,
      width: 120,
      height: 40,
      child: ColoredBox(
        color: Colors.blue,
        child: Center(child: Text('Info')),
      ),
    );
  }
}
