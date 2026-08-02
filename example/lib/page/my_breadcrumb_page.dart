import 'package:example/common_tools_catalog.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../base/example_widget.dart';

class MyBreadcrumbPage extends StatelessWidget {
  const MyBreadcrumbPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: myTitle(context),
      desc: 'Displays the current page location within a navigation hierarchy.',
      exampleCodeGroup: 'breadcrumb',
      children: [
        ExampleModule(
          title: 'Basic',
          children: [
            ExampleItem(
              desc:
                  'Links button for parent pages and text for the current page.',
              center: false,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              builder: _buildBasicLink,
            ),
            ExampleItem(
              desc:
                  'Text button for parent pages and text for the current page.',
              center: false,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              builder: _buildBasicText,
            ),
          ],
        ),
        ExampleModule(
          title: 'Separators',
          children: [
            ExampleItem(
              desc: 'Built-in arrow, slash, and custom separators.',
              center: false,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              builder: _buildSeparators,
            ),
          ],
        ),
        ExampleModule(
          title: 'Collapsed Path',
          children: [
            ExampleItem(
              desc: 'Use a dropdown item when intermediate levels are hidden.',
              center: false,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              builder: _buildCollapsed,
            ),
          ],
        ),
        ExampleModule(
          title: 'Wrapping',
          children: [
            ExampleItem(
              desc: 'Long breadcrumb trails wrap instead of scrolling away.',
              center: false,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              builder: _buildWrapping,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBasicLink(BuildContext context) {
    return MyBreadcrumb(
      children: [
        MyBreadcrumbLink(text: 'Home', onTap: () {}),
        MyBreadcrumbLink(text: 'Components', onTap: () {}),
        const Text('Breadcrumb'),
      ],
    );
  }

  Widget _buildBasicText(BuildContext context) {
    final type = MyButtonType.text;
    return MyBreadcrumb(
      children: [
        MyBreadcrumbLink(text: 'Home', type: type, onTap: () {}),
        MyBreadcrumbLink(text: 'Components', type: type, onTap: () {}),
        const Text('Breadcrumb'),
      ],
    );
  }

  Widget _buildSeparators(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16,
      children: [
        MyBreadcrumb(
          separator: MyBreadcrumb.arrowSeparator,
          children: [
            MyBreadcrumbLink(text: 'Home', onTap: () {}),
            MyBreadcrumbLink(text: 'Navigation', onTap: () {}),
            const Text('Arrow'),
          ],
        ),
        MyBreadcrumb(
          separator: MyBreadcrumb.slashSeparator,
          children: [
            MyBreadcrumbLink(text: 'Home', onTap: () {}),
            MyBreadcrumbLink(text: 'Navigation', onTap: () {}),
            const Text('Slash'),
          ],
        ),
        MyBreadcrumb(
          separator: const MyBreadcrumbSeparator(
            icon: LucideIcons.dot,
            size: 18,
          ),
          separatorColor: context.colorScheme.primary,
          children: [
            MyBreadcrumbLink(text: 'Home', onTap: () {}),
            MyBreadcrumbLink(text: 'Navigation', onTap: () {}),
            const Text('Custom'),
          ],
        ),
      ],
    );
  }

  Widget _buildCollapsed(BuildContext context) {
    return MyBreadcrumb(
      children: [
        MyBreadcrumbLink(text: 'Home', onTap: () {}),
        MyBreadcrumbDropdown(
          items: [
            MyBreadcrumbMenuItem(text: 'Dashboard', onTap: () {}),
            MyBreadcrumbMenuItem(text: 'Projects', onTap: () {}),
            MyBreadcrumbMenuItem(text: 'Design System', onTap: () {}),
          ],
          child: const MyBreadcrumbEllipsis(),
        ),
        MyBreadcrumbLink(text: 'Components', onTap: () {}),
        const Text('Breadcrumb'),
      ],
    );
  }

  Widget _buildWrapping(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 320),
      child: MyBreadcrumb(
        children: [
          MyBreadcrumbLink(text: 'Workspace', onTap: () {}),
          MyBreadcrumbLink(text: 'Product', onTap: () {}),
          MyBreadcrumbLink(text: 'Design System', onTap: () {}),
          MyBreadcrumbLink(text: 'Navigation Components', onTap: () {}),
          MyBreadcrumbLink(text: 'Breadcrumb Patterns', onTap: () {}),
          const Text('Responsive Trail'),
        ],
      ),
    );
  }
}
