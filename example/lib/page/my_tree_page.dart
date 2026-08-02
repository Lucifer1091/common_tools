import 'package:example/common_tools_catalog.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../base/example_widget.dart';

class MyTreePage extends StatelessWidget {
  const MyTreePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: myTitle(context),
      desc:
          'Trees display hierarchical data with expandable branches, nested items, and optional node selection.',
      exampleCodeGroup: 'tree',
      children: [
        ExampleModule(
          title: 'Component Types',
          children: [ExampleItem(desc: 'Basic Tree', builder: _basicTree)],
        ),
      ],
    );
  }

  Widget _basicTree(BuildContext context) {
    return const _FruitTreeExample();
  }
}

class _FruitTreeExample extends StatefulWidget {
  const _FruitTreeExample();

  @override
  State<_FruitTreeExample> createState() => _FruitTreeExampleState();
}

class _FruitTreeExampleState extends State<_FruitTreeExample> {
  bool expandIcon = true;
  bool usePath = true;
  bool recursiveSelection = false;

  List<MyTreeNode<String>> treeItems = [
    MyTreeItemNode(
      data: 'Apple',
      expanded: true,
      children: [
        MyTreeItemNode(
          data: 'Red Apple',
          children: [
            MyTreeItemNode(data: 'Red Apple 1'),
            MyTreeItemNode(data: 'Red Apple 2'),
          ],
        ),
        MyTreeItemNode(data: 'Green Apple'),
      ],
    ),
    MyTreeItemNode(
      data: 'Banana',
      children: [
        MyTreeItemNode(data: 'Yellow Banana'),
        MyTreeItemNode(
          data: 'Green Banana',
          children: [
            MyTreeItemNode(data: 'Green Banana 1'),
            MyTreeItemNode(data: 'Green Banana 2'),
            MyTreeItemNode(data: 'Green Banana 3'),
          ],
        ),
      ],
    ),
    MyTreeItemNode(
      data: 'Cherry',
      children: [
        MyTreeItemNode(data: 'Red Cherry'),
        MyTreeItemNode(data: 'Green Cherry'),
      ],
    ),
    MyTreeItemNode(data: 'Date'),
    MyTreeRootNode(
      children: [
        MyTreeItemNode(
          data: 'Elderberry',
          children: [
            MyTreeItemNode(data: 'Black Elderberry'),
            MyTreeItemNode(data: 'Red Elderberry'),
          ],
        ),
        MyTreeItemNode(
          data: 'Fig',
          children: [
            MyTreeItemNode(data: 'Green Fig'),
            MyTreeItemNode(data: 'Purple Fig'),
          ],
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: context.colorScheme.border),
            borderRadius: BorderRadius.circular(6),
          ),
          child: SizedBox(
            height: 400,
            width: 320,
            child: MyTree<String>(
              showExpandIcon: expandIcon,
              shrinkWrap: true,
              recursiveSelection: recursiveSelection,
              nodes: treeItems,
              branchLine: usePath
                  ? MyTreeBranchLine.path
                  : MyTreeBranchLine.line,
              onSelectionChanged: MyTree.defaultSelectionHandler(treeItems, (
                value,
              ) {
                setState(() {
                  treeItems = value;
                });
              }),
              builder: (context, node) {
                return MyTreeItem(
                  onTap: () {},
                  trailing: node.leaf
                      ? const SizedBox.square(
                          dimension: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : null,
                  leading: Icon(
                    node.leaf
                        ? LucideIcons.file
                        : node.expanded
                        ? LucideIcons.folderOpen
                        : LucideIcons.folder,
                  ),
                  onExpand: MyTree.defaultItemExpandHandler(treeItems, node, (
                    value,
                  ) {
                    setState(() {
                      treeItems = value;
                    });
                  }),
                  child: MyText(node.data),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            MyButton(
              onTap: () {
                setState(() {
                  treeItems = treeItems.expandAll();
                });
              },
              text: 'Expand All',
            ),
            const SizedBox(width: 8),
            MyButton(
              onTap: () {
                setState(() {
                  treeItems = treeItems.collapseAll();
                });
              },
              text: 'Collapse All',
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 250,
          child: Column(
            children: [
              MyCheckbox(
                checked: expandIcon,
                title: 'Expand Icon',
                showDivider: false,
                onChanged: (value) {
                  setState(() {
                    expandIcon = value ?? false;
                  });
                },
              ),
              MyCheckbox(
                checked: usePath,
                title: 'Use Path Branch Line',
                showDivider: false,
                onChanged: (value) {
                  setState(() {
                    usePath = value ?? false;
                  });
                },
              ),
              MyCheckbox(
                checked: recursiveSelection,
                title: 'Recursive Selection',
                showDivider: false,
                onChanged: (value) {
                  setState(() {
                    recursiveSelection = value ?? false;
                    if (recursiveSelection) {
                      treeItems = treeItems.updateRecursiveSelection();
                    }
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
