import 'package:example/common_tools_catalog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../base/example_widget.dart';

class MyDropDownMenuPage extends StatefulWidget {
  const MyDropDownMenuPage({super.key});

  @override
  State<MyDropDownMenuPage> createState() => _MyDropDownMenuPageState();
}

class _MyDropDownMenuPageState extends State<MyDropDownMenuPage> {
  final _controller = MyPopoverController();
  var _controlledOpen = false;
  var _showStatusBar = true;
  var _colorMode = 'System';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: myTitle(),
      desc: 'Dropdown menus display contextual actions anchored to a trigger.',
      exampleCodeGroup: 'drop-down-menu',
      children: [
        ExampleModule(
          title: 'Component Types',
          children: [
            ExampleItem(desc: 'Account Menu', builder: _buildAccountMenu),
            ExampleItem(desc: 'Icon Menu', builder: _buildIconMenu),
            ExampleItem(desc: 'Controlled Menu', builder: _buildControlledMenu),
          ],
        ),
      ],
    );
  }

  Widget _buildAccountMenu(BuildContext context) {
    return MyDropDownMenu(
      triggerBuilder: (context, controller, open) {
        return MyButton(
          type: MyButtonType.outline,
          text: open ? 'Close' : 'Open',
          onTap: controller.toggle,
        );
      },
      children: const [
        MyMenuLabel(text: 'My Account'),
        MyMenuDivider(),
        MyMenuButton(text: 'Profile'),
        MyMenuButton(text: 'Billing'),
        MyMenuButton(text: 'Settings'),
        MyMenuButton(text: 'Keyboard shortcuts'),
        MyMenuDivider(),
        MyMenuButton(text: 'Team'),
        MyMenuButton(
          text: 'Invite users',
          subMenu: [
            MyMenuButton(text: 'Email'),
            MyMenuButton(text: 'Message'),
            MyMenuDivider(),
            MyMenuButton(text: 'More...'),
          ],
        ),
        MyMenuButton(text: 'New Team'),
        MyMenuDivider(),
        MyMenuButton(text: 'GitHub'),
        MyMenuButton(text: 'Support'),
        MyMenuButton(text: 'API', enabled: false),
        MyMenuButton(text: 'Log out'),
      ],
    );
  }

  Widget _buildIconMenu(BuildContext context) {
    return MyDropDownMenu(
      triggerBuilder: (context, controller, open) {
        return MyButton(
          type: MyButtonType.secondary,
          iconWidget: Icon(
            LucideIcons.ellipsis,
            size: 18,
            color: context.colorScheme.secondaryForeground,
          ),
          text: 'Actions',
          onTap: controller.toggle,
        );
      },
      children: [
        MyMenuButton(
          leading: const Icon(LucideIcons.user),
          text: 'Profile',
          trailing: const MyMenuShortcut(
            activator: SingleActivator(LogicalKeyboardKey.keyP),
          ),
          onPressed: () {},
        ),
        MyMenuButton(
          leading: const Icon(LucideIcons.creditCard),
          text: 'Billing',
          trailing: const MyMenuShortcut(
            activator: SingleActivator(LogicalKeyboardKey.keyB),
          ),
          onPressed: () {},
        ),
        MyMenuButton(
          leading: const Icon(LucideIcons.settings),
          text: 'Settings',
          trailing: const MyMenuShortcut(
            activator: SingleActivator(LogicalKeyboardKey.keyS),
          ),
          onPressed: () {},
        ),
        const MyMenuDivider(),
        MyMenuCheckbox(
          value: _showStatusBar,
          text: 'Show status bar',
          autoClose: false,
          onChanged: (value) => setState(() => _showStatusBar = value),
        ),
        MyMenuRadioGroup<String>(
          value: _colorMode,
          onChanged: (value) => setState(() => _colorMode = value),
          children: const [
            MyMenuRadio(value: 'Light', text: 'Light mode', autoClose: false),
            MyMenuRadio(value: 'Dark', text: 'Dark mode', autoClose: false),
            MyMenuRadio(value: 'System', text: 'System mode', autoClose: false),
          ],
        ),
        const MyMenuDivider(),
        MyMenuButton(
          leading: const Icon(LucideIcons.logOut),
          text: 'Log out',
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildControlledMenu(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        MyDropDownMenu(
          controller: _controller,
          closeOnSelect: false,
          onOpenChanged: (open) {
            setState(() => _controlledOpen = open);
          },
          triggerBuilder: (context, controller, open) {
            return MyButton(
              type: MyButtonType.outline,
              text: open ? 'Controlled open' : 'Controlled closed',
              onTap: controller.toggle,
            );
          },
          children: [
            MyMenuLabel(
              child: MyText(
                _controlledOpen ? 'Menu is open' : 'Menu is closed',
              ),
            ),
            MyMenuDivider(),
            MyMenuButton(text: 'Close from item', onPressed: _controller.hide),
            MyMenuButton(
              text: 'Keep menu open',
              autoClose: false,
              onPressed: () {},
            ),
          ],
        ),
        const SizedBox(height: 8),
        MyText(
          _controlledOpen ? 'Open state: true' : 'Open state: false',
          style: context.bodySmall.copyWith(
            color: context.colorScheme.mutedForeground,
          ),
        ),
      ],
    );
  }
}
