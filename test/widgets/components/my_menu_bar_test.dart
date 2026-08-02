import 'package:common_tools/components.dart';
import 'package:common_tools/theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

const _fileKey = ValueKey<String>('menu-bar-file');
const _editKey = ValueKey<String>('menu-bar-edit');
const _newTabKey = ValueKey<String>('menu-bar-new-tab');

void main() {
  testWidgets('top-level items render horizontally', (tester) async {
    await tester.pumpWidget(const _ThemeHarness(child: _TestMenuBar()));

    expect(find.text('File'), findsOneWidget);
    expect(find.text('Edit'), findsOneWidget);
    expect(
      tester.getTopLeft(find.text('File')).dx,
      lessThan(tester.getTopLeft(find.text('Edit')).dx),
    );
    expect(
      tester.getTopLeft(find.text('File')).dy,
      closeTo(tester.getTopLeft(find.text('Edit')).dy, 0.01),
    );
  });

  testWidgets('tapping File opens its menu below the trigger', (tester) async {
    await tester.pumpWidget(
      const _ThemeHarness(
        child: Padding(
          padding: EdgeInsets.only(left: 40, top: 30),
          child: _TestMenuBar(),
        ),
      ),
    );

    await tester.tap(find.byKey(_fileKey));
    await _pumpPopover(tester);

    expect(find.text('New Tab'), findsOneWidget);
    final trigger = tester.getRect(find.byKey(_fileKey));
    final item = tester.getRect(_itemSurface(_newTabKey));
    expect(item.left, closeTo(trigger.left + 5, 0.01));
    expect(item.top, closeTo(trigger.bottom + 9, 0.01));
  });

  testWidgets('hovering another top-level item while open switches menus', (
    tester,
  ) async {
    await tester.pumpWidget(const _ThemeHarness(child: _TestMenuBar()));
    await tester.tap(find.byKey(_fileKey));
    await _pumpPopover(tester);
    expect(find.text('New Tab'), findsOneWidget);

    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(tester.getCenter(_topLevelSurface(_editKey)));
    await _pumpPopover(tester);

    expect(find.text('New Tab'), findsNothing);
    expect(find.text('Undo'), findsOneWidget);
    await mouse.removePointer();
  });

  testWidgets('only one top-level menu remains open', (tester) async {
    await tester.pumpWidget(const _ThemeHarness(child: _TestMenuBar()));

    await tester.tap(find.byKey(_fileKey));
    await _pumpPopover(tester);
    await tester.tap(find.byKey(_editKey));
    await _pumpPopover(tester);

    expect(find.text('New Tab'), findsNothing);
    expect(find.text('Undo'), findsOneWidget);
  });

  testWidgets('leaf item invokes callback and closes by default', (
    tester,
  ) async {
    var tapped = false;
    await tester.pumpWidget(
      _ThemeHarness(
        child: MyMenuBar(
          items: [
            MyMenuBarItem(
              key: _fileKey,
              text: 'File',
              items: [
                MyMenuButton(
                  key: _newTabKey,
                  text: 'New Tab',
                  onPressed: () => tapped = true,
                ),
              ],
            ),
          ],
        ),
      ),
    );

    await tester.tap(find.byKey(_fileKey));
    await _pumpPopover(tester);
    await tester.tap(find.text('New Tab'));
    await _pumpPopover(tester);

    expect(tapped, isTrue);
    expect(find.text('New Tab'), findsNothing);
  });

  testWidgets('autoClose false checkbox and radio keep the menu open', (
    tester,
  ) async {
    var checked = false;
    var selected = 'One';
    await tester.pumpWidget(
      _ThemeHarness(
        child: StatefulBuilder(
          builder: (context, setState) {
            return MyMenuBar(
              items: [
                MyMenuBarItem(
                  key: _fileKey,
                  text: 'View',
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
                        MyMenuRadio(
                          value: 'One',
                          text: 'One',
                          autoClose: false,
                        ),
                        MyMenuRadio(
                          value: 'Two',
                          text: 'Two',
                          autoClose: false,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );

    await tester.tap(find.byKey(_fileKey));
    await _pumpPopover(tester);
    await tester.tap(find.text('Show toolbar'));
    await tester.pump();
    expect(checked, isTrue);
    expect(find.text('Show toolbar'), findsOneWidget);

    await tester.tap(find.text('Two'));
    await tester.pump();
    expect(selected, 'Two');
    expect(find.text('Two'), findsOneWidget);
  });

  testWidgets('disabled top-level and child items do not invoke callbacks', (
    tester,
  ) async {
    var topTapped = false;
    var childTapped = false;
    await tester.pumpWidget(
      _ThemeHarness(
        child: MyMenuBar(
          items: [
            MyMenuBarItem(
              key: _fileKey,
              text: 'Disabled',
              enabled: false,
              onPressed: () => topTapped = true,
              items: const [MyMenuButton(text: 'Hidden')],
            ),
            MyMenuBarItem(
              key: _editKey,
              text: 'Edit',
              items: [
                MyMenuButton(
                  text: 'Disabled child',
                  enabled: false,
                  onPressed: () => childTapped = true,
                ),
              ],
            ),
          ],
        ),
      ),
    );

    await tester.tap(find.byKey(_fileKey));
    await _pumpPopover(tester);
    expect(topTapped, isFalse);
    expect(find.text('Hidden'), findsNothing);

    await tester.tap(find.byKey(_editKey));
    await _pumpPopover(tester);
    await tester.tap(find.text('Disabled child'));
    await tester.pump();
    expect(childTapped, isFalse);
    expect(find.text('Disabled child'), findsOneWidget);
  });

  testWidgets('nested submenu opens through MyMenuButton.subMenu', (
    tester,
  ) async {
    const shareKey = ValueKey<String>('menu-bar-share');
    await tester.pumpWidget(
      const _ThemeHarness(
        child: MyMenuBar(
          items: [
            MyMenuBarItem(
              key: _fileKey,
              text: 'File',
              items: [
                MyMenuButton(
                  key: shareKey,
                  text: 'Share',
                  subMenu: [MyMenuButton(text: 'Email')],
                ),
              ],
            ),
          ],
        ),
      ),
    );

    await tester.tap(find.byKey(_fileKey));
    await _pumpPopover(tester);
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(tester.getCenter(_itemSurface(shareKey)));
    await _pumpPopover(tester);

    expect(find.text('Email'), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await _pumpPopover(tester);
    expect(find.text('Email'), findsNothing);
    await mouse.removePointer();
  });

  testWidgets('keyboard traversal opens and activates menu items', (
    tester,
  ) async {
    var activated = false;
    await tester.pumpWidget(
      _ThemeHarness(
        child: MyMenuBar(
          items: [
            const MyMenuBarItem(
              key: _fileKey,
              text: 'File',
              items: [MyMenuButton(text: 'New Tab')],
            ),
            MyMenuBarItem(
              key: _editKey,
              text: 'Edit',
              items: [
                MyMenuButton(text: 'Undo', onPressed: () => activated = true),
              ],
            ),
          ],
        ),
      ),
    );

    await tester.tap(find.byKey(_fileKey));
    await _pumpPopover(tester);
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await _pumpPopover(tester);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await _pumpPopover(tester);
    expect(find.text('Undo'), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await _pumpPopover(tester);
    expect(activated, isTrue);
    expect(find.text('Undo'), findsNothing);

    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await _pumpPopover(tester);
    expect(find.text('Undo'), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await _pumpPopover(tester);
    expect(find.text('Undo'), findsNothing);
  });

  testWidgets('external controller is not disposed by the widget', (
    tester,
  ) async {
    final controller = MyPopoverController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      _ThemeHarness(
        child: MyMenuBar(
          items: [
            MyMenuBarItem(
              key: _fileKey,
              text: 'File',
              controller: controller,
              items: const [MyMenuButton(text: 'New Tab')],
            ),
          ],
        ),
      ),
    );

    controller.show();
    await _pumpPopover(tester);
    expect(find.text('New Tab'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    controller.hide();
    controller.show();
    expect(tester.takeException(), isNull);
  });

  testWidgets('supplied submenu controllers reset on root close', (
    tester,
  ) async {
    final rootController = MyPopoverController();
    final submenuController = MyPopoverController();
    addTearDown(rootController.dispose);
    addTearDown(submenuController.dispose);
    await tester.pumpWidget(
      _ThemeHarness(
        child: MyMenuBar(
          items: [
            MyMenuBarItem(
              key: _fileKey,
              text: 'File',
              controller: rootController,
              items: [
                MyMenuButton(
                  text: 'Share',
                  submenuController: submenuController,
                  subMenu: const [MyMenuButton(text: 'Email')],
                ),
              ],
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

  testWidgets('bordered and borderless variants render', (tester) async {
    await tester.pumpWidget(
      const _ThemeHarness(
        child: Column(
          children: [
            _TestMenuBar(),
            MyMenuBar(
              border: false,
              items: [
                MyMenuBarItem(
                  text: 'Plain',
                  items: [MyMenuButton(text: 'Item')],
                ),
              ],
            ),
          ],
        ),
      ),
    );

    expect(find.byType(MyMenuBar), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });
}

Finder _topLevelSurface(Key key) {
  return find
      .descendant(of: find.byKey(key), matching: find.byType(DecoratedBox))
      .first;
}

Finder _itemSurface(Key key) {
  return find
      .descendant(of: find.byKey(key), matching: find.byType(DecoratedBox))
      .first;
}

Future<void> _pumpPopover(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 200));
  for (var frame = 0; frame < 12; frame++) {
    await tester.pump(const Duration(milliseconds: 16));
  }
}

class _TestMenuBar extends StatelessWidget {
  const _TestMenuBar();

  @override
  Widget build(BuildContext context) {
    return const MyMenuBar(
      items: [
        MyMenuBarItem(
          key: _fileKey,
          text: 'File',
          items: [
            MyMenuButton(key: _newTabKey, text: 'New Tab'),
            MyMenuButton(text: 'Open'),
          ],
        ),
        MyMenuBarItem(
          key: _editKey,
          text: 'Edit',
          items: [
            MyMenuButton(text: 'Undo'),
            MyMenuButton(text: 'Redo'),
          ],
        ),
      ],
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
