import 'package:common_tools/components.dart';
import 'package:common_tools/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows expanded descendants and hides collapsed descendants', (
    tester,
  ) async {
    await tester.pumpWidget(
      _ThemeHarness(
        child: _TreeHarness(
          nodes: [
            MyTreeItemNode(
              data: 'Expanded',
              expanded: true,
              children: [MyTreeItemNode(data: 'Visible child')],
            ),
            MyTreeItemNode(
              data: 'Collapsed',
              children: [MyTreeItemNode(data: 'Hidden child')],
            ),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Expanded'), findsOneWidget);
    expect(find.text('Visible child'), findsOneWidget);
    expect(find.text('Collapsed'), findsOneWidget);
    expect(find.text('Hidden child'), findsNothing);
  });

  testWidgets('default expand handler updates rendered children', (
    tester,
  ) async {
    await tester.pumpWidget(
      _ThemeHarness(
        child: _TreeHarness(
          nodes: [
            MyTreeItemNode(
              data: 'Parent',
              children: [MyTreeItemNode(data: 'Child')],
            ),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Child'), findsNothing);

    await tester.tap(find.text('Parent'));
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tap(find.text('Parent'));
    await tester.pumpAndSettle();

    expect(find.text('Child'), findsOneWidget);
  });

  test('expandAll and collapseAll update nested nodes recursively', () {
    final nodes = [
      MyTreeItemNode(
        data: 'Parent',
        children: [
          MyTreeItemNode(
            data: 'Child',
            children: [MyTreeItemNode(data: 'Grandchild')],
          ),
        ],
      ),
    ];

    final expanded = nodes.expandAll();
    expect(_findItem(expanded, 'Parent').expanded, isTrue);
    expect(_findItem(expanded, 'Child').expanded, isTrue);

    final collapsed = expanded.collapseAll();
    expect(_findItem(collapsed, 'Parent').expanded, isFalse);
    expect(_findItem(collapsed, 'Child').expanded, isFalse);
  });

  testWidgets('single selection replaces previous selection', (tester) async {
    final key = GlobalKey<_TreeHarnessState>();

    await tester.pumpWidget(
      _ThemeHarness(
        child: _TreeHarness(
          key: key,
          allowMultiSelect: false,
          nodes: [
            MyTreeItemNode(data: 'One'),
            MyTreeItemNode(data: 'Two'),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('One'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Two'));
    await tester.pumpAndSettle();

    expect(key.currentState!.nodes.selectedItems, ['Two']);
  });

  testWidgets('multi selection preserves existing selections', (tester) async {
    final key = GlobalKey<_TreeHarnessState>();

    await tester.pumpWidget(
      _ThemeHarness(
        child: _TreeHarness(
          key: key,
          allowMultiSelect: true,
          forceMultiSelect: true,
          nodes: [
            MyTreeItemNode(data: 'One'),
            MyTreeItemNode(data: 'Two'),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('One'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Two'));
    await tester.pumpAndSettle();

    expect(key.currentState!.nodes.selectedItems, ['One', 'Two']);
  });

  testWidgets('recursive selection selects descendants', (tester) async {
    final key = GlobalKey<_TreeHarnessState>();

    await tester.pumpWidget(
      _ThemeHarness(
        child: _TreeHarness(
          key: key,
          recursiveSelection: true,
          nodes: [
            MyTreeItemNode(
              data: 'Parent',
              expanded: true,
              children: [
                MyTreeItemNode(data: 'Child'),
                MyTreeItemNode(data: 'Sibling child'),
              ],
            ),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Parent'));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();

    expect(key.currentState!.nodes.selectedItems, [
      'Parent',
      'Child',
      'Sibling child',
    ]);
  });

  test('selectedNodes and selectedItems include nested selected items', () {
    final nodes = [
      MyTreeItemNode(
        data: 'Parent',
        children: [
          MyTreeItemNode(data: 'Child', selected: true),
          MyTreeItemNode(
            data: 'Nested',
            children: [MyTreeItemNode(data: 'Grandchild', selected: true)],
          ),
        ],
      ),
    ];

    expect(nodes.selectedItems, ['Child', 'Grandchild']);
    expect(nodes.selectedNodes, hasLength(2));
  });

  testWidgets('branch line modes render without exceptions', (tester) async {
    for (final branchLine in [
      MyTreeBranchLine.none,
      MyTreeBranchLine.line,
      MyTreeBranchLine.path,
    ]) {
      await tester.pumpWidget(
        _ThemeHarness(
          child: _TreeHarness(
            branchLine: branchLine,
            nodes: [
              MyTreeItemNode(
                data: 'Parent',
                expanded: true,
                children: [MyTreeItemNode(data: 'Child')],
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('focus and state controllers survive update and dispose', (
    tester,
  ) async {
    final firstFocusNode = FocusNode();
    final secondFocusNode = FocusNode();

    await tester.pumpWidget(
      _ThemeHarness(
        child: _TreeHarness(
          itemFocusNode: firstFocusNode,
          nodes: [MyTreeItemNode(data: 'Node')],
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.pumpWidget(
      _ThemeHarness(
        child: _TreeHarness(
          itemFocusNode: secondFocusNode,
          nodes: [MyTreeItemNode(data: 'Node')],
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.pumpWidget(const SizedBox.shrink());
    expect(tester.takeException(), isNull);

    firstFocusNode.dispose();
    secondFocusNode.dispose();
  });
}

MyTreeItemNode<String> _findItem(List<MyTreeNode<String>> nodes, String data) {
  final item = _tryFindItem(nodes, data);
  if (item == null) throw StateError('No tree item found for $data');
  return item;
}

MyTreeItemNode<String>? _tryFindItem(
  List<MyTreeNode<String>> nodes,
  String data,
) {
  for (final node in nodes) {
    if (node is MyTreeItemNode<String>) {
      if (node.data == data) return node;
      final child = _tryFindItem(node.children, data);
      if (child != null) return child;
    } else if (node is MyTreeRootNode<String>) {
      final child = _tryFindItem(node.children, data);
      if (child != null) return child;
    }
  }
  return null;
}

class _TreeHarness extends StatefulWidget {
  const _TreeHarness({
    required this.nodes,
    super.key,
    this.allowMultiSelect,
    this.recursiveSelection = false,
    this.forceMultiSelect = false,
    this.branchLine,
    this.itemFocusNode,
  });

  final List<MyTreeNode<String>> nodes;
  final bool? allowMultiSelect;
  final bool recursiveSelection;
  final bool forceMultiSelect;
  final MyTreeBranchLine? branchLine;
  final FocusNode? itemFocusNode;

  @override
  State<_TreeHarness> createState() => _TreeHarnessState();
}

class _TreeHarnessState extends State<_TreeHarness> {
  late List<MyTreeNode<String>> nodes;

  @override
  void initState() {
    super.initState();
    nodes = widget.nodes;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 320,
      child: MyTree<String>(
        nodes: nodes,
        branchLine: widget.branchLine,
        allowMultiSelect: widget.allowMultiSelect,
        recursiveSelection: widget.recursiveSelection,
        showExpandIcon: false,
        onSelectionChanged: (selectedNodes, multiSelect, selected) {
          MyTree.defaultSelectionHandler<String>(nodes, (value) {
            setState(() {
              nodes = value;
            });
          })(selectedNodes, widget.forceMultiSelect || multiSelect, selected);
        },
        builder: (context, node) {
          return MyTreeItem(
            focusNode: widget.itemFocusNode,
            onTap: () {},
            onExpand: MyTree.defaultItemExpandHandler(nodes, node, (value) {
              setState(() {
                nodes = value;
              });
            }),
            child: Text(node.data),
          );
        },
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
