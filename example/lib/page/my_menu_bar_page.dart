import 'package:example/common_tools_catalog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../base/example_widget.dart';

class MyMenuBarPage extends StatefulWidget {
  const MyMenuBarPage({super.key});

  @override
  State<MyMenuBarPage> createState() => _MyMenuBarPageState();
}

class _MyMenuBarPageState extends State<MyMenuBarPage> {
  final _controller = MyPopoverController();
  var _showBookmarksBar = false;
  var _showFullUrls = true;
  var _selectedProfile = 1;
  var _controlledOpen = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: myTitle(),
      desc: 'Menu bars organize desktop-style navigation and actions.',
      exampleCodeGroup: 'menu-bar',
      children: [
        ExampleModule(
          title: 'Component Types',
          children: [
            ExampleItem(desc: 'Browser Menu Bar', builder: _buildBrowserMenu),
            ExampleItem(desc: 'Application Menu Bar', builder: _buildAppMenu),
            ExampleItem(desc: 'Controlled Menu Bar', builder: _buildControlled),
          ],
        ),
      ],
    );
  }

  Widget _buildBrowserMenu(BuildContext context) {
    return MyMenuBar(
      items: [
        const MyMenuBarItem(
          text: 'File',
          items: [
            MyMenuButton(
              leading: Icon(LucideIcons.filePlus),
              text: 'New Tab',
              trailing: MyMenuShortcut(
                activator: SingleActivator(
                  LogicalKeyboardKey.keyT,
                  control: true,
                ),
              ),
            ),
            MyMenuButton(
              text: 'New Window',
              trailing: MyMenuShortcut(
                activator: SingleActivator(
                  LogicalKeyboardKey.keyN,
                  control: true,
                ),
              ),
            ),
            MyMenuButton(text: 'New Incognito Window', enabled: false),
            MyMenuDivider(),
            MyMenuButton(
              text: 'Share',
              subMenu: [
                MyMenuButton(text: 'Email Link'),
                MyMenuButton(text: 'Messages'),
                MyMenuButton(text: 'Notes'),
              ],
            ),
            MyMenuButton(
              text: 'Print',
              trailing: MyMenuShortcut(
                activator: SingleActivator(
                  LogicalKeyboardKey.keyP,
                  control: true,
                ),
              ),
            ),
            MyMenuButton(
              text: 'Exit',
              subMenu: [
                MyMenuButton(text: 'Save and Exit'),
                MyMenuButton(text: 'Discard and Exit'),
              ],
            ),
          ],
        ),
        const MyMenuBarItem(
          text: 'Edit',
          items: [
            MyMenuButton(
              text: 'Undo',
              trailing: MyMenuShortcut(
                activator: SingleActivator(
                  LogicalKeyboardKey.keyZ,
                  control: true,
                ),
              ),
            ),
            MyMenuButton(
              text: 'Redo',
              trailing: MyMenuShortcut(
                activator: SingleActivator(
                  LogicalKeyboardKey.keyZ,
                  control: true,
                  shift: true,
                ),
              ),
            ),
            MyMenuDivider(),
            MyMenuButton(
              text: 'Find',
              subMenu: [
                MyMenuButton(text: 'Search the Web'),
                MyMenuDivider(),
                MyMenuButton(text: 'Find...'),
                MyMenuButton(text: 'Find Next'),
                MyMenuButton(text: 'Find Previous'),
              ],
            ),
            MyMenuDivider(),
            MyMenuButton(text: 'Cut'),
            MyMenuButton(text: 'Copy'),
            MyMenuButton(text: 'Paste'),
          ],
        ),
        MyMenuBarItem(
          text: 'View',
          items: [
            MyMenuCheckbox(
              value: _showBookmarksBar,
              text: 'Always Show Bookmarks Bar',
              autoClose: false,
              onChanged: (value) => setState(() => _showBookmarksBar = value),
            ),
            MyMenuCheckbox(
              value: _showFullUrls,
              text: 'Always Show Full URLs',
              autoClose: false,
              onChanged: (value) => setState(() => _showFullUrls = value),
            ),
            const MyMenuDivider(),
            const MyMenuButton(
              text: 'Reload',
              trailing: MyMenuShortcut(
                activator: SingleActivator(
                  LogicalKeyboardKey.keyR,
                  control: true,
                ),
              ),
            ),
            const MyMenuButton(
              text: 'Force Reload',
              enabled: false,
              trailing: MyMenuShortcut(
                activator: SingleActivator(
                  LogicalKeyboardKey.keyR,
                  control: true,
                  shift: true,
                ),
              ),
            ),
            const MyMenuDivider(),
            const MyMenuButton(text: 'Toggle Full Screen'),
            const MyMenuDivider(),
            const MyMenuButton(text: 'Hide Sidebar'),
          ],
        ),
        MyMenuBarItem(
          text: 'Profiles',
          items: [
            MyMenuRadioGroup<int>(
              value: _selectedProfile,
              onChanged: (value) => setState(() => _selectedProfile = value),
              children: const [
                MyMenuRadio(value: 0, text: 'Andy', autoClose: false),
                MyMenuRadio(value: 1, text: 'Benoit', autoClose: false),
                MyMenuRadio(value: 2, text: 'Luis', autoClose: false),
              ],
            ),
            const MyMenuDivider(),
            const MyMenuButton(text: 'Edit...'),
            const MyMenuDivider(),
            const MyMenuButton(text: 'Add Profile...'),
          ],
        ),
      ],
    );
  }

  Widget _buildAppMenu(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        MyMenuBar(
          items: const [
            MyMenuBarItem(
              leading: Icon(LucideIcons.folderOpen),
              text: 'Project',
              items: [
                MyMenuButton(
                  leading: Icon(LucideIcons.plus),
                  text: 'New Project',
                ),
                MyMenuButton(leading: Icon(LucideIcons.folder), text: 'Open'),
                MyMenuDivider(),
                MyMenuButton(text: 'Recent Projects'),
              ],
            ),
            MyMenuBarItem(
              leading: Icon(LucideIcons.wrench),
              text: 'Tools',
              items: [
                MyMenuButton(text: 'Command Palette'),
                MyMenuButton(text: 'Extensions'),
                MyMenuButton(text: 'Developer Tools', enabled: false),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        const MyMenuBar(
          border: false,
          items: [
            MyMenuBarItem(
              text: 'Plain',
              items: [MyMenuButton(text: 'Item')],
            ),
            MyMenuBarItem(
              text: 'Minimal',
              items: [MyMenuButton(text: 'Item')],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildControlled(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        MyMenuBar(
          onOpenChanged: (open) => setState(() => _controlledOpen = open),
          items: [
            MyMenuBarItem(
              text: 'Controlled',
              controller: _controller,
              items: [
                MyMenuLabel(
                  child: MyText(
                    _controlledOpen ? 'Menu is open' : 'Menu is closed',
                  ),
                ),
                const MyMenuDivider(),
                MyMenuButton(
                  text: 'Close from item',
                  onPressed: _controller.hide,
                ),
                MyMenuButton(
                  text: 'Keep menu open',
                  autoClose: false,
                  onPressed: () {},
                ),
              ],
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
