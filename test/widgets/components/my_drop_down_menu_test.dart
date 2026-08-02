import 'package:common_tools/components.dart';
import 'package:common_tools/theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

const _triggerKey = ValueKey<String>('menu-trigger');
const _profileKey = ValueKey<String>('profile-item');

void main() {
  testWidgets('trigger renders and opens menu on tap', (tester) async {
    await tester.pumpWidget(
      const _ThemeHarness(child: _TestMenu(children: [_profileItem])),
    );

    expect(find.text('Open menu'), findsOneWidget);
    expect(find.text('Profile'), findsNothing);

    await tester.tap(find.text('Open menu'));
    await _pumpPopover(tester);

    expect(find.text('Profile'), findsOneWidget);
  });

  testWidgets('labels dividers and items render in order', (tester) async {
    await tester.pumpWidget(
      const _ThemeHarness(
        child: _TestMenu(
          children: [
            MyMenuLabel(text: 'My Account'),
            MyMenuDivider(),
            _profileItem,
            MyMenuButton(text: 'Billing'),
          ],
        ),
      ),
    );

    await tester.tap(find.text('Open menu'));
    await _pumpPopover(tester);

    expect(find.text('My Account'), findsOneWidget);
    expect(find.byType(MyMenuDivider), findsOneWidget);
    expect(
      tester.getTopLeft(find.text('Profile')).dy,
      lessThan(tester.getTopLeft(find.text('Billing')).dy),
    );
  });

  testWidgets('leaf item tap invokes callback and closes root by default', (
    tester,
  ) async {
    var tapped = false;
    await tester.pumpWidget(
      _ThemeHarness(
        child: _TestMenu(
          children: [
            MyMenuButton(text: 'Profile', onPressed: () => tapped = true),
          ],
        ),
      ),
    );

    await tester.tap(find.text('Open menu'));
    await _pumpPopover(tester);
    await tester.tap(find.text('Profile'));
    await _pumpPopover(tester);

    expect(tapped, isTrue);
    expect(find.text('Profile'), findsNothing);
  });

  testWidgets('closeOnSelect false keeps the menu open after item tap', (
    tester,
  ) async {
    var tapped = false;
    await tester.pumpWidget(
      _ThemeHarness(
        child: _TestMenu(
          closeOnSelect: false,
          children: [
            MyMenuButton(text: 'Profile', onPressed: () => tapped = true),
          ],
        ),
      ),
    );

    await tester.tap(find.text('Open menu'));
    await _pumpPopover(tester);
    await tester.tap(find.text('Profile'));
    await tester.pump();

    expect(tapped, isTrue);
    expect(find.text('Profile'), findsOneWidget);
  });

  testWidgets('disabled item does not invoke callback', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      _ThemeHarness(
        child: _TestMenu(
          children: [
            MyMenuButton(
              text: 'API',
              enabled: false,
              onPressed: () => tapped = true,
            ),
          ],
        ),
      ),
    );

    await tester.tap(find.text('Open menu'));
    await _pumpPopover(tester);
    await tester.tap(find.text('API'));
    await tester.pump();

    expect(tapped, isFalse);
    expect(find.text('API'), findsOneWidget);
  });

  testWidgets('nested submenu opens on hover and renders submenu items', (
    tester,
  ) async {
    await tester.pumpWidget(
      const _ThemeHarness(
        child: _TestMenu(
          children: [
            MyMenuButton(
              text: 'Invite users',
              subMenu: [MyMenuButton(text: 'Email')],
            ),
          ],
        ),
      ),
    );

    await tester.tap(find.text('Open menu'));
    await _pumpPopover(tester);
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(tester.getCenter(find.text('Invite users')));
    await _pumpPopover(tester);

    expect(find.text('Email'), findsOneWidget);
    await mouse.removePointer();
  });

  testWidgets('nested submenu opens on tap and selecting leaf closes root', (
    tester,
  ) async {
    var tapped = false;
    await tester.pumpWidget(
      _ThemeHarness(
        child: _TestMenu(
          children: [
            MyMenuButton(
              text: 'Invite users',
              subMenu: [
                MyMenuButton(text: 'Email', onPressed: () => tapped = true),
              ],
            ),
          ],
        ),
      ),
    );

    await tester.tap(find.text('Open menu'));
    await _pumpPopover(tester);
    await tester.tap(find.text('Invite users'));
    await _pumpPopover(tester);
    await tester.tap(find.text('Email'));
    await _pumpPopover(tester);

    expect(tapped, isTrue);
    expect(find.text('Invite users'), findsNothing);
    expect(find.text('Email'), findsNothing);
  });

  testWidgets('provided controller can show and hide programmatically', (
    tester,
  ) async {
    final controller = MyPopoverController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      _ThemeHarness(
        child: _TestMenu(
          controller: controller,
          children: const [_profileItem],
        ),
      ),
    );

    controller.show();
    await _pumpPopover(tester);
    expect(find.text('Profile'), findsOneWidget);

    controller.hide();
    await _pumpPopover(tester);
    expect(find.text('Profile'), findsNothing);

    await tester.pumpWidget(const SizedBox.shrink());
    controller.show();
    controller.hide();
    expect(tester.takeException(), isNull);
  });

  testWidgets('escape and outside tap close the menu', (tester) async {
    await tester.pumpWidget(
      const _ThemeHarness(child: _TestMenu(children: [_profileItem])),
    );

    await tester.tap(find.text('Open menu'));
    await _pumpPopover(tester);
    expect(find.text('Profile'), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await _pumpPopover(tester);
    expect(find.text('Profile'), findsNothing);

    await tester.tap(find.text('Open menu'));
    await _pumpPopover(tester);
    await tester.tapAt(const Offset(790, 590));
    await _pumpPopover(tester);
    expect(find.text('Profile'), findsNothing);
  });

  testWidgets('root menu aligns to the trigger start with the expected gap', (
    tester,
  ) async {
    await tester.pumpWidget(
      const _ThemeHarness(
        child: Padding(
          padding: EdgeInsets.only(left: 40, top: 30),
          child: _TestMenu(children: [_profileItem]),
        ),
      ),
    );
    await tester.tap(find.byKey(_triggerKey));
    await _pumpPopover(tester);

    final trigger = tester.getRect(find.byKey(_triggerKey));
    final item = tester.getRect(_itemSurface(_profileKey));
    expect(item.left, closeTo(trigger.left + 5, 0.01));
    expect(item.top, closeTo(trigger.bottom + 9, 0.01));
  });

  testWidgets('submenu opens beside and near the top of its parent item', (
    tester,
  ) async {
    const inviteKey = ValueKey<String>('invite-item');
    const emailKey = ValueKey<String>('email-item');
    await tester.pumpWidget(
      const _ThemeHarness(
        child: Padding(
          padding: EdgeInsets.only(left: 40, top: 30),
          child: _TestMenu(
            children: [
              MyMenuButton(
                key: inviteKey,
                text: 'Invite users',
                subMenu: [MyMenuButton(key: emailKey, text: 'Email')],
              ),
            ],
          ),
        ),
      ),
    );
    await tester.tap(find.byKey(_triggerKey));
    await _pumpPopover(tester);
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(tester.getCenter(_itemSurface(inviteKey)));
    await _pumpPopover(tester);

    final parent = tester.getRect(_itemSurface(inviteKey));
    final child = tester.getRect(_itemSurface(emailKey));
    expect(child.left, closeTo(parent.right + 9, 0.01));
    expect(child.top, closeTo(parent.top + 3, 0.01));
    await mouse.removePointer();
  });

  testWidgets('submenu flips to the left near the right viewport edge', (
    tester,
  ) async {
    const inviteKey = ValueKey<String>('invite-edge-item');
    const emailKey = ValueKey<String>('email-edge-item');
    await tester.pumpWidget(
      const _ThemeHarness(
        alignment: Alignment.topRight,
        child: _TestMenu(
          children: [
            MyMenuButton(
              key: inviteKey,
              text: 'Invite users',
              subMenu: [MyMenuButton(key: emailKey, text: 'Email')],
            ),
          ],
        ),
      ),
    );
    await tester.tap(find.byKey(_triggerKey));
    await _pumpPopover(tester);
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(tester.getCenter(_itemSurface(inviteKey)));
    await _pumpPopover(tester);

    final parent = tester.getRect(_itemSurface(inviteKey));
    final child = tester.getRect(_itemSurface(emailKey));
    expect(child.right, closeTo(parent.left - 9, 0.01));
    await mouse.removePointer();
  });

  testWidgets('RTL menus align to the trigger end and open submenus left', (
    tester,
  ) async {
    const inviteKey = ValueKey<String>('rtl-invite-item');
    const emailKey = ValueKey<String>('rtl-email-item');
    await tester.pumpWidget(
      const _ThemeHarness(
        textDirection: TextDirection.rtl,
        alignment: Alignment.topCenter,
        child: _TestMenu(
          children: [
            MyMenuButton(
              key: inviteKey,
              text: 'Invite users',
              subMenu: [MyMenuButton(key: emailKey, text: 'Email')],
            ),
          ],
        ),
      ),
    );
    await tester.tap(find.byKey(_triggerKey));
    await _pumpPopover(tester);
    final trigger = tester.getRect(find.byKey(_triggerKey));
    final parent = tester.getRect(_itemSurface(inviteKey));
    expect(parent.right, closeTo(trigger.right - 5, 0.01));

    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(parent.center);
    await _pumpPopover(tester);
    final child = tester.getRect(_itemSurface(emailKey));
    expect(child.right, closeTo(parent.left - 9, 0.01));
    await mouse.removePointer();
  });

  testWidgets('leading columns stay aligned across sibling items', (
    tester,
  ) async {
    await tester.pumpWidget(
      const _ThemeHarness(
        child: _TestMenu(
          children: [
            MyMenuButton(text: 'Profile', leading: Icon(Icons.person)),
            MyMenuButton(text: 'Billing'),
          ],
        ),
      ),
    );
    await tester.tap(find.byKey(_triggerKey));
    await _pumpPopover(tester);

    expect(
      tester.getTopLeft(find.text('Profile')).dx,
      closeTo(tester.getTopLeft(find.text('Billing')).dx, 0.01),
    );
  });

  for (final brightness in Brightness.values) {
    testWidgets('hover uses accent colors in ${brightness.name} mode', (
      tester,
    ) async {
      const billingKey = ValueKey<String>('billing-item');
      final scheme = MyColorScheme.fromParts(
        base: MyBaseColor.neutral,
        accent: MyAccentColor.blue,
        brightness: brightness,
      );
      await tester.pumpWidget(
        _ThemeHarness(
          brightness: brightness,
          child: const _TestMenu(
            children: [
              _profileItem,
              MyMenuButton(key: billingKey, text: 'Billing'),
            ],
          ),
        ),
      );
      await tester.tap(find.byKey(_triggerKey));
      await _pumpPopover(tester);
      final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await mouse.addPointer(location: Offset.zero);
      await mouse.moveTo(tester.getCenter(_itemSurface(billingKey)));
      await tester.pump();

      expect(
        find.descendant(
          of: find.byKey(billingKey),
          matching: find.byType(AnimatedContainer),
        ),
        findsNothing,
      );
      expect(_itemColor(tester, billingKey), scheme.accent);
      final styles = tester.widgetList<DefaultTextStyle>(
        find.descendant(
          of: find.byKey(billingKey),
          matching: find.byType(DefaultTextStyle),
        ),
      );
      expect(
        styles.any((style) => style.style.color == scheme.accentForeground),
        isTrue,
      );
      await mouse.removePointer();
    });
  }

  testWidgets('hover color is stable without animated intermediate frames', (
    tester,
  ) async {
    const billingKey = ValueKey<String>('stable-hover-item');
    await tester.pumpWidget(
      const _ThemeHarness(
        child: _TestMenu(
          children: [
            _profileItem,
            MyMenuButton(key: billingKey, text: 'Billing'),
          ],
        ),
      ),
    );
    await tester.tap(find.byKey(_triggerKey));
    await _pumpPopover(tester);
    final scheme = MyTheme.of(
      tester.element(find.byKey(billingKey)),
    ).colorScheme;
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(tester.getCenter(_itemSurface(billingKey)));

    await tester.pump();
    expect(_itemColor(tester, billingKey), scheme.accent);
    await tester.pump(const Duration(milliseconds: 16));
    expect(_itemColor(tester, billingKey), scheme.accent);
    await tester.pump(const Duration(milliseconds: 75));
    expect(_itemColor(tester, billingKey), scheme.accent);
    await tester.pump(kThemeAnimationDuration);
    expect(_itemColor(tester, billingKey), scheme.accent);
    await mouse.removePointer();
  });

  testWidgets(
    'moving hover between sibling items leaves only current item active',
    (tester) async {
      const billingKey = ValueKey<String>('sibling-hover-item');
      await tester.pumpWidget(
        const _ThemeHarness(
          child: _TestMenu(
            children: [
              MyMenuButton(key: _profileKey, text: 'Profile'),
              MyMenuButton(key: billingKey, text: 'Billing'),
            ],
          ),
        ),
      );
      await tester.tap(find.byKey(_triggerKey));
      await _pumpPopover(tester);
      final scheme = MyTheme.of(
        tester.element(find.byKey(billingKey)),
      ).colorScheme;
      final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await mouse.addPointer(location: Offset.zero);

      await mouse.moveTo(tester.getCenter(_itemSurface(_profileKey)));
      await tester.pump();
      expect(_itemColor(tester, _profileKey), scheme.accent);

      await mouse.moveTo(tester.getCenter(_itemSurface(billingKey)));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      expect(_itemColor(tester, _profileKey), Colors.transparent);
      expect(_itemColor(tester, billingKey), scheme.accent);
      await mouse.removePointer();
    },
  );

  testWidgets('opening a submenu closes its sibling submenu', (tester) async {
    await tester.pumpWidget(
      const _ThemeHarness(
        child: _TestMenu(
          children: [
            MyMenuButton(
              text: 'Share',
              subMenu: [MyMenuButton(text: 'Email')],
            ),
            MyMenuButton(
              text: 'Export',
              subMenu: [MyMenuButton(text: 'PDF')],
            ),
          ],
        ),
      ),
    );
    await tester.tap(find.byKey(_triggerKey));
    await _pumpPopover(tester);
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(tester.getCenter(find.text('Share')));
    await _pumpPopover(tester);
    expect(find.text('Email'), findsOneWidget);

    await mouse.moveTo(tester.getCenter(find.text('Export')));
    await _pumpPopover(tester);
    expect(find.text('Email'), findsNothing);
    expect(find.text('PDF'), findsOneWidget);
    await mouse.removePointer();
  });

  testWidgets('moving into submenu content keeps it open', (tester) async {
    const shareKey = ValueKey<String>('share-hover-item');
    await tester.pumpWidget(
      const _ThemeHarness(
        child: _TestMenu(
          children: [
            MyMenuButton(
              key: shareKey,
              text: 'Share',
              subMenu: [MyMenuButton(text: 'Email')],
            ),
          ],
        ),
      ),
    );
    await tester.tap(find.byKey(_triggerKey));
    await _pumpPopover(tester);
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(tester.getCenter(find.text('Share')));
    await _pumpPopover(tester);
    await mouse.moveTo(tester.getCenter(find.text('Email')));
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('Email'), findsOneWidget);
    final scheme = MyTheme.of(tester.element(find.byKey(shareKey))).colorScheme;
    expect(_itemColor(tester, shareKey), scheme.accent);
    await mouse.removePointer();
  });

  testWidgets('checkbox radio and shortcut primitives work together', (
    tester,
  ) async {
    var checked = false;
    var selected = 'One';
    await tester.pumpWidget(
      _ThemeHarness(
        child: StatefulBuilder(
          builder: (context, setState) {
            return _TestMenu(
              children: [
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
                  text: 'Save',
                  trailing: MyMenuShortcut(
                    activator: SingleActivator(
                      LogicalKeyboardKey.keyS,
                      control: true,
                      shift: true,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
    await tester.tap(find.byKey(_triggerKey));
    await _pumpPopover(tester);
    expect(find.text('Ctrl + Shift + S'), findsOneWidget);

    await tester.tap(find.text('Show toolbar'));
    await tester.pump();
    expect(checked, isTrue);
    expect(find.text('Show toolbar'), findsOneWidget);

    await tester.tap(find.text('Two'));
    await tester.pump();
    expect(selected, 'Two');
    expect(find.text('Two'), findsOneWidget);
  });

  testWidgets('keyboard traversal activates items and opens submenus', (
    tester,
  ) async {
    var activated = '';
    await tester.pumpWidget(
      _ThemeHarness(
        child: _TestMenu(
          children: [
            const MyMenuButton(
              text: 'Share',
              subMenu: [MyMenuButton(text: 'Email')],
            ),
            MyMenuButton(
              text: 'Billing',
              onPressed: () => activated = 'Billing',
            ),
          ],
        ),
      ),
    );
    await tester.tap(find.byKey(_triggerKey));
    await _pumpPopover(tester);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await _pumpPopover(tester);
    expect(find.text('Email'), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    await _pumpPopover(tester);
    expect(find.text('Email'), findsNothing);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await _pumpPopover(tester);
    expect(activated, 'Billing');
  });

  testWidgets('external submenu controller survives removal', (tester) async {
    final submenuController = MyPopoverController();
    addTearDown(submenuController.dispose);
    await tester.pumpWidget(
      _ThemeHarness(
        child: _TestMenu(
          children: [
            MyMenuButton(
              text: 'Share',
              submenuController: submenuController,
              subMenu: const [MyMenuButton(text: 'Email')],
            ),
          ],
        ),
      ),
    );
    await tester.pumpWidget(const SizedBox.shrink());

    submenuController.show();
    submenuController.hide();
    expect(tester.takeException(), isNull);
  });

  testWidgets('programmatic root close resets supplied submenus', (
    tester,
  ) async {
    final rootController = MyPopoverController();
    final submenuController = MyPopoverController();
    addTearDown(rootController.dispose);
    addTearDown(submenuController.dispose);
    await tester.pumpWidget(
      _ThemeHarness(
        child: _TestMenu(
          controller: rootController,
          children: [
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
    rootController.show();
    await _pumpPopover(tester);
    expect(find.text('Email'), findsNothing);
  });

  testWidgets('pending submenu close is harmless after disposal', (
    tester,
  ) async {
    await tester.pumpWidget(
      const _ThemeHarness(
        child: _TestMenu(
          children: [
            MyMenuButton(
              text: 'Share',
              subMenu: [MyMenuButton(text: 'Email')],
            ),
          ],
        ),
      ),
    );
    await tester.tap(find.byKey(_triggerKey));
    await _pumpPopover(tester);
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(tester.getCenter(find.text('Share')));
    await _pumpPopover(tester);
    await mouse.moveTo(const Offset(700, 500));
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 200));

    expect(tester.takeException(), isNull);
    await mouse.removePointer();
  });
}

Finder _itemSurface(Key key) {
  return find
      .descendant(of: find.byKey(key), matching: find.byType(DecoratedBox))
      .first;
}

Color? _itemColor(WidgetTester tester, Key key) {
  final surface = tester.widget<DecoratedBox>(_itemSurface(key));
  return (surface.decoration as BoxDecoration).color;
}

const _profileItem = MyMenuButton(key: _profileKey, text: 'Profile');

Future<void> _pumpPopover(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 200));
  for (var frame = 0; frame < 12; frame++) {
    await tester.pump(const Duration(milliseconds: 16));
  }
}

class _TestMenu extends StatelessWidget {
  const _TestMenu({
    required this.children,
    this.controller,
    this.closeOnSelect = true,
  });

  final List<MyMenuItem> children;
  final MyPopoverController? controller;
  final bool closeOnSelect;

  @override
  Widget build(BuildContext context) {
    return MyDropDownMenu(
      controller: controller,
      closeOnSelect: closeOnSelect,
      triggerBuilder: (context, controller, open) {
        return MyButton(
          key: _triggerKey,
          type: MyButtonType.outline,
          text: 'Open menu',
          onTap: controller.toggle,
        );
      },
      children: children,
    );
  }
}

class _ThemeHarness extends StatelessWidget {
  const _ThemeHarness({
    required this.child,
    this.brightness = Brightness.light,
    this.alignment = Alignment.topLeft,
    this.textDirection = TextDirection.ltr,
  });

  final Widget child;
  final Brightness brightness;
  final Alignment alignment;
  final TextDirection textDirection;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyTheme(
        data: MyThemeData(
          colorScheme: MyColorScheme.fromParts(
            base: MyBaseColor.neutral,
            accent: MyAccentColor.blue,
            brightness: brightness,
          ),
          typography: const MyTypography.geist(),
        ),
        child: Scaffold(
          body: Directionality(
            textDirection: textDirection,
            child: Align(alignment: alignment, child: child),
          ),
        ),
      ),
    );
  }
}
