import 'package:example/common_tools_catalog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../base/example_widget.dart';

class MyContextMenuPage extends StatefulWidget {
  const MyContextMenuPage({super.key});

  @override
  State<MyContextMenuPage> createState() => _MyContextMenuPageState();
}

class _MyContextMenuPageState extends State<MyContextMenuPage> {
  final _controller = MyPopoverController();
  var _controlledOpen = false;
  var _people = 0;
  var _showBookmarksBar = false;
  var _showFullUrls = true;
  var _showExtensions = true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: myTitle(),
      desc: 'Context menus show actions at the pointer location.',
      exampleCodeGroup: 'context-menu',
      children: [
        ExampleModule(
          title: 'Component Types',
          children: [
            ExampleItem(desc: 'Browser Menu', builder: _buildBrowserMenu),
            ExampleItem(desc: 'File Menu', builder: _buildFileMenu),
            ExampleItem(desc: 'Controlled Menu', builder: _buildControlledMenu),
          ],
        ),
      ],
    );
  }

  Widget _buildBrowserMenu(BuildContext context) {
    return MyContextMenu(
      items: [
        const MyMenuButton(
          text: 'Back',
          trailing: MyMenuShortcut(
            activator: SingleActivator(
              LogicalKeyboardKey.bracketLeft,
              control: true,
            ),
          ),
        ),
        const MyMenuButton(
          text: 'Forward',
          enabled: false,
          trailing: MyMenuShortcut(
            activator: SingleActivator(
              LogicalKeyboardKey.bracketRight,
              control: true,
            ),
          ),
        ),
        const MyMenuButton(
          text: 'Reload',
          trailing: MyMenuShortcut(
            activator: SingleActivator(LogicalKeyboardKey.keyR, control: true),
          ),
        ),
        const MyMenuButton(
          text: 'More Tools',
          subMenu: [
            MyMenuButton(
              text: 'Save Page As...',
              trailing: MyMenuShortcut(
                activator: SingleActivator(
                  LogicalKeyboardKey.keyS,
                  control: true,
                ),
              ),
            ),
            MyMenuButton(text: 'Create Shortcut...'),
            MyMenuButton(text: 'Name Window...'),
            MyMenuDivider(),
            MyMenuButton(text: 'Developer Tools'),
          ],
        ),
        const MyMenuDivider(),
        MyMenuCheckbox(
          value: _showBookmarksBar,
          text: 'Show Bookmarks Bar',
          autoClose: false,
          trailing: const MyMenuShortcut(
            activator: SingleActivator(
              LogicalKeyboardKey.keyB,
              control: true,
              shift: true,
            ),
          ),
          onChanged: (value) => setState(() => _showBookmarksBar = value),
        ),
        MyMenuCheckbox(
          value: _showFullUrls,
          text: 'Show Full URLs',
          autoClose: false,
          onChanged: (value) => setState(() => _showFullUrls = value),
        ),
        const MyMenuDivider(),
        const MyMenuLabel(text: 'People'),
        const MyMenuDivider(),
        MyMenuRadioGroup<int>(
          value: _people,
          onChanged: (value) => setState(() => _people = value),
          children: const [
            MyMenuRadio(value: 0, text: 'Pedro Duarte', autoClose: false),
            MyMenuRadio(value: 1, text: 'Colm Tuite', autoClose: false),
          ],
        ),
      ],
      child: _ContextTarget(
        icon: LucideIcons.mousePointerClick,
        text: 'Right click here',
      ),
    );
  }

  Widget _buildFileMenu(BuildContext context) {
    return MyContextMenu(
      items: [
        const MyMenuLabel(text: 'report-final.pdf'),
        const MyMenuDivider(),
        const MyMenuButton(
          leading: Icon(LucideIcons.fileText),
          text: 'Open',
          trailing: MyMenuShortcut(
            activator: SingleActivator(LogicalKeyboardKey.enter),
          ),
        ),
        const MyMenuButton(
          leading: Icon(LucideIcons.copy),
          text: 'Duplicate',
          trailing: MyMenuShortcut(
            activator: SingleActivator(LogicalKeyboardKey.keyD, control: true),
          ),
        ),
        const MyMenuButton(
          leading: Icon(LucideIcons.share2),
          text: 'Share',
          subMenu: [
            MyMenuButton(text: 'Copy Link'),
            MyMenuButton(text: 'Send by Email'),
            MyMenuDivider(),
            MyMenuButton(text: 'Manage Access'),
          ],
        ),
        const MyMenuButton(
          leading: Icon(LucideIcons.archive),
          text: 'Archive',
          enabled: false,
        ),
        const MyMenuDivider(),
        MyMenuCheckbox(
          value: _showExtensions,
          text: 'Show file extensions',
          autoClose: false,
          onChanged: (value) => setState(() => _showExtensions = value),
        ),
        const MyMenuDivider(),
        MyMenuButton(
          leading: Icon(
            LucideIcons.trash2,
            color: context.colorScheme.destructive,
          ),
          child: MyText(
            'Delete',
            style: context.bodyMedium.copyWith(
              color: context.colorScheme.destructive,
            ),
          ),
        ),
      ],
      child: _ContextTarget(icon: LucideIcons.file, text: 'report-final.pdf'),
    );
  }

  Widget _buildControlledMenu(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        MyContextMenu(
          controller: _controller,
          closeOnSelect: false,
          onOpenChanged: (open) => setState(() => _controlledOpen = open),
          items: [
            MyMenuLabel(
              child: MyText(
                _controlledOpen ? 'Menu is open' : 'Menu is closed',
              ),
            ),
            const MyMenuDivider(),
            MyMenuButton(text: 'Close from item', onPressed: _controller.hide),
            MyMenuButton(
              text: 'Keep menu open',
              autoClose: false,
              onPressed: () {},
            ),
          ],
          child: const _ContextTarget(
            icon: LucideIcons.panelTopOpen,
            text: 'Controlled target',
          ),
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

class _ContextTarget extends StatelessWidget {
  const _ContextTarget({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints.tightFor(width: 300, height: 200),
      child: MyDottedBorder(
        radius: 8,
        strokeWidth: 2,
        dotsWidth: 8,
        gap: 4,
        color: context.colorScheme.border,
        padding: const EdgeInsets.all(12),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 24, color: context.colorScheme.mutedForeground),
              const SizedBox(height: 8),
              MyText(text),
              const SizedBox(height: 4),
              MyText(
                'Right-click or long-press',
                style: context.bodySmall.copyWith(
                  color: context.colorScheme.mutedForeground,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
