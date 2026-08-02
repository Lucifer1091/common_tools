import 'package:common_tools/components.dart';
import 'package:common_tools/theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

const _targetKey = ValueKey<String>('context-menu-target');
const _profileKey = ValueKey<String>('context-profile-item');

void main() {
  testWidgets('secondary tap opens menu at the pointer location', (
    tester,
  ) async {
    await tester.pumpWidget(
      const _ThemeHarness(
        child: _TestContextMenu(
          items: [MyMenuButton(key: _profileKey, text: 'Profile')],
        ),
      ),
    );

    await tester.tapAt(const Offset(120, 90), buttons: kSecondaryMouseButton);
    await _pumpPopover(tester);

    expect(find.text('Profile'), findsOneWidget);
    final item = tester.getRect(_itemSurface(_profileKey));
    expect(item.left, closeTo(125, 0.01));
    expect(item.top, closeTo(95, 0.01));
  });

  testWidgets('long press opens the context menu', (tester) async {
    await tester.pumpWidget(
      const _ThemeHarness(
        child: _TestContextMenu(
          items: [MyMenuButton(key: _profileKey, text: 'Profile')],
        ),
      ),
    );

    await tester.longPressAt(const Offset(120, 90));
    await _pumpPopover(tester);

    expect(find.text('Profile'), findsOneWidget);
  });

  testWidgets('normal tap does not open the context menu', (tester) async {
    await tester.pumpWidget(
      const _ThemeHarness(
        child: _TestContextMenu(
          items: [MyMenuButton(key: _profileKey, text: 'Profile')],
        ),
      ),
    );

    await tester.tap(find.byKey(_targetKey));
    await _pumpPopover(tester);

    expect(find.text('Profile'), findsNothing);
  });

  testWidgets('escape and outside tap close the context menu', (tester) async {
    await tester.pumpWidget(
      const _ThemeHarness(
        child: _TestContextMenu(
          items: [MyMenuButton(key: _profileKey, text: 'Profile')],
        ),
      ),
    );

    await _openContextMenu(tester);
    expect(find.text('Profile'), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await _pumpPopover(tester);
    expect(find.text('Profile'), findsNothing);

    await _openContextMenu(tester);
    await tester.tapAt(const Offset(780, 580));
    await _pumpPopover(tester);
    expect(find.text('Profile'), findsNothing);
  });

  testWidgets('leaf item invokes callback and closes by default', (
    tester,
  ) async {
    var tapped = false;
    await tester.pumpWidget(
      _ThemeHarness(
        child: _TestContextMenu(
          items: [
            MyMenuButton(
              key: _profileKey,
              text: 'Profile',
              onPressed: () => tapped = true,
            ),
          ],
        ),
      ),
    );

    await _openContextMenu(tester);
    await tester.tap(find.text('Profile'));
    await _pumpPopover(tester);

    expect(tapped, isTrue);
    expect(find.text('Profile'), findsNothing);
  });

  testWidgets('autoClose false keeps the context menu open', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      _ThemeHarness(
        child: _TestContextMenu(
          closeOnSelect: false,
          items: [
            MyMenuButton(
              key: _profileKey,
              text: 'Profile',
              autoClose: false,
              onPressed: () => tapped = true,
            ),
          ],
        ),
      ),
    );

    await _openContextMenu(tester);
    await tester.tap(find.text('Profile'));
    await tester.pump();

    expect(tapped, isTrue);
    expect(find.text('Profile'), findsOneWidget);
  });

  testWidgets('disabled item does not invoke callbacks', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      _ThemeHarness(
        child: _TestContextMenu(
          items: [
            MyMenuButton(
              key: _profileKey,
              text: 'Profile',
              enabled: false,
              onPressed: () => tapped = true,
            ),
          ],
        ),
      ),
    );

    await _openContextMenu(tester);
    await tester.tap(find.text('Profile'));
    await tester.pump();

    expect(tapped, isFalse);
    expect(find.text('Profile'), findsOneWidget);
  });

  testWidgets('submenu opens on hover and tap', (tester) async {
    const shareKey = ValueKey<String>('context-share-item');
    await tester.pumpWidget(
      const _ThemeHarness(
        child: _TestContextMenu(
          items: [
            MyMenuButton(
              key: shareKey,
              text: 'Share',
              subMenu: [MyMenuButton(text: 'Email')],
            ),
          ],
        ),
      ),
    );

    await _openContextMenu(tester);
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(tester.getCenter(_itemSurface(shareKey)));
    await _pumpPopover(tester);
    expect(find.text('Email'), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await _pumpPopover(tester);
    await _openContextMenu(tester);
    await tester.tap(find.text('Share'));
    await _pumpPopover(tester);
    expect(find.text('Email'), findsOneWidget);
    await mouse.removePointer();
  });

  testWidgets('checkbox radio and shortcut items work', (tester) async {
    var checked = false;
    var selected = 'One';
    await tester.pumpWidget(
      _ThemeHarness(
        child: StatefulBuilder(
          builder: (context, setState) {
            return _TestContextMenu(
              items: [
                MyMenuCheckbox(
                  value: checked,
                  text: 'Show toolbar',
                  autoClose: false,
                  onChanged: (value) => setState(() => checked = value),
                ),
                MyMenuRadioGroup<String>(
                  value: selected,
                  onChanged: (value) => setState(() => selected = value),
                  children: const [
                    MyMenuRadio(value: 'One', text: 'One', autoClose: false),
                    MyMenuRadio(value: 'Two', text: 'Two', autoClose: false),
                  ],
                ),
                const MyMenuButton(
                  text: 'Reload',
                  trailing: MyMenuShortcut(
                    activator: SingleActivator(
                      LogicalKeyboardKey.keyR,
                      control: true,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );

    await _openContextMenu(tester);
    expect(find.text('Ctrl + R'), findsOneWidget);

    await tester.tap(find.text('Show toolbar'));
    await tester.pump();
    expect(checked, isTrue);
    expect(find.text('Show toolbar'), findsOneWidget);

    await tester.tap(find.text('Two'));
    await tester.pump();
    expect(selected, 'Two');
    expect(find.text('Two'), findsOneWidget);
  });

  testWidgets('provided controller is not disposed by the widget', (
    tester,
  ) async {
    final controller = MyPopoverController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      _ThemeHarness(
        child: _TestContextMenu(
          controller: controller,
          items: const [MyMenuButton(key: _profileKey, text: 'Profile')],
        ),
      ),
    );

    controller.show();
    await _pumpPopover(tester);
    expect(find.text('Profile'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    controller.hide();
    controller.show();
    expect(tester.takeException(), isNull);
  });

  testWidgets('root close resets supplied submenu controllers', (tester) async {
    final rootController = MyPopoverController();
    final submenuController = MyPopoverController();
    addTearDown(rootController.dispose);
    addTearDown(submenuController.dispose);
    await tester.pumpWidget(
      _ThemeHarness(
        child: _TestContextMenu(
          controller: rootController,
          items: [
            MyMenuButton(
              text: 'Share',
              submenuController: submenuController,
              subMenu: const [MyMenuButton(text: 'Email')],
            ),
          ],
        ),
      ),
    );

    rootController.show();
    await _pumpPopover(tester);
    submenuController.show();
    await _pumpPopover(tester);
    expect(find.text('Email'), findsOneWidget);

    rootController.hide();
    await _pumpPopover(tester);
    expect(submenuController.isOpen, isFalse);
  });

  testWidgets('default browser context menu suppression does not throw', (
    tester,
  ) async {
    await tester.pumpWidget(
      const _ThemeHarness(
        child: _TestContextMenu(
          items: [MyMenuButton(key: _profileKey, text: 'Profile')],
        ),
      ),
    );
    await tester.pumpWidget(const SizedBox.shrink());

    expect(tester.takeException(), isNull);
  });

  testWidgets('toggling browser context menu suppression does not throw', (
    tester,
  ) async {
    var suppress = false;
    await tester.pumpWidget(
      _ThemeHarness(
        child: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              children: [
                _TestContextMenu(
                  suppressBrowserContextMenu: suppress,
                  items: const [
                    MyMenuButton(key: _profileKey, text: 'Profile'),
                  ],
                ),
                TextButton(
                  onPressed: () => setState(() => suppress = !suppress),
                  child: const Text('Toggle suppression'),
                ),
              ],
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Toggle suppression'));
    await tester.pump();
    await tester.tap(find.text('Toggle suppression'));
    await tester.pump();
    await tester.pumpWidget(const SizedBox.shrink());

    expect(tester.takeException(), isNull);
  });

  testWidgets('disposing multiple suppressing context menus does not throw', (
    tester,
  ) async {
    await tester.pumpWidget(
      const _ThemeHarness(
        child: Column(
          children: [
            MyContextMenu(
              items: [MyMenuButton(text: 'First')],
              child: SizedBox(
                key: ValueKey<String>('first-context-target'),
                width: 100,
                height: 60,
              ),
            ),
            MyContextMenu(
              items: [MyMenuButton(text: 'Second')],
              child: SizedBox(
                key: ValueKey<String>('second-context-target'),
                width: 100,
                height: 60,
              ),
            ),
          ],
        ),
      ),
    );
    await tester.pumpWidget(const SizedBox.shrink());

    expect(tester.takeException(), isNull);
  });
}

Finder _itemSurface(Key key) {
  return find
      .descendant(of: find.byKey(key), matching: find.byType(DecoratedBox))
      .first;
}

Future<void> _openContextMenu(WidgetTester tester) async {
  await tester.tapAt(const Offset(120, 90), buttons: kSecondaryMouseButton);
  await _pumpPopover(tester);
}

Future<void> _pumpPopover(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 200));
  for (var frame = 0; frame < 12; frame++) {
    await tester.pump(const Duration(milliseconds: 16));
  }
}

class _TestContextMenu extends StatelessWidget {
  const _TestContextMenu({
    required this.items,
    this.controller,
    this.closeOnSelect = true,
    this.suppressBrowserContextMenu = true,
  });

  final List<MyMenuItem> items;
  final MyPopoverController? controller;
  final bool closeOnSelect;
  final bool suppressBrowserContextMenu;

  @override
  Widget build(BuildContext context) {
    return MyContextMenu(
      controller: controller,
      closeOnSelect: closeOnSelect,
      suppressBrowserContextMenu: suppressBrowserContextMenu,
      items: items,
      child: const SizedBox(
        key: _targetKey,
        width: 300,
        height: 200,
        child: Center(child: Text('Context target')),
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
        child: Scaffold(
          body: Align(alignment: Alignment.topLeft, child: child),
        ),
      ),
    );
  }
}
