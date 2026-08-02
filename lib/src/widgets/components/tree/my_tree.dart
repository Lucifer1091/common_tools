import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../constants/my_radius.dart';
import '../../../extensions/context/theme.dart';
import '../../../extensions/context/typography.dart';
import '../../../extensions/misc/color.dart';
import '../../../themes/my_ui_layer.dart';
import '../../common/my_decorator.dart';
import '../../common/my_gesture_detector.dart';
import '../../common/my_provider.dart';
import '../../form/focusable.dart';

abstract class MyTreeNode<T> {
  List<MyTreeNode<T>> get children;

  bool get expanded;

  bool get selected;

  bool get leaf => children.isEmpty;

  MyTreeNode<T> updateState({bool? expanded, bool? selected});

  MyTreeNode<T> updateChildren(List<MyTreeNode<T>> children);
}

class MyTreeItemNode<T> extends MyTreeNode<T> {
  MyTreeItemNode({
    required this.data,
    this.children = const [],
    this.expanded = false,
    this.selected = false,
  });

  final T data;

  @override
  final List<MyTreeNode<T>> children;

  @override
  final bool expanded;

  @override
  final bool selected;

  @override
  MyTreeItemNode<T> updateState({bool? expanded, bool? selected}) {
    return MyTreeItemNode(
      data: data,
      children: children,
      expanded: expanded ?? this.expanded,
      selected: selected ?? this.selected,
    );
  }

  @override
  MyTreeItemNode<T> updateChildren(List<MyTreeNode<T>> children) {
    return MyTreeItemNode(
      data: data,
      children: children,
      expanded: expanded,
      selected: selected,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is MyTreeItemNode<T> &&
        other.data == data &&
        listEquals(other.children, children) &&
        other.expanded == expanded &&
        other.selected == selected;
  }

  @override
  int get hashCode {
    return Object.hash(data, Object.hashAll(children), expanded, selected);
  }
}

class MyTreeRootNode<T> extends MyTreeNode<T> {
  MyTreeRootNode({required this.children});

  @override
  final List<MyTreeNode<T>> children;

  @override
  bool get expanded => true;

  @override
  bool get selected => false;

  @override
  MyTreeRootNode<T> updateState({bool? expanded, bool? selected}) => this;

  @override
  MyTreeRootNode<T> updateChildren(List<MyTreeNode<T>> children) {
    return MyTreeRootNode(children: children);
  }

  @override
  bool operator ==(Object other) {
    return other is MyTreeRootNode<T> && listEquals(other.children, children);
  }

  @override
  int get hashCode => Object.hashAll(children);
}

enum MyTreeSelectionPosition { start, middle, end, single }

enum _MyTreeFocusChangeReason { focusScope, userInteraction }

BorderRadius _borderRadiusFromPosition(
  MyTreeSelectionPosition? position,
  double value,
) {
  return switch (position) {
    MyTreeSelectionPosition.start => BorderRadius.vertical(
      top: Radius.circular(value),
    ),
    MyTreeSelectionPosition.middle => BorderRadius.zero,
    MyTreeSelectionPosition.end => BorderRadius.vertical(
      bottom: Radius.circular(value),
    ),
    MyTreeSelectionPosition.single => BorderRadius.all(Radius.circular(value)),
    null => BorderRadius.zero,
  };
}

class MyTreeNodeDepth {
  const MyTreeNodeDepth(this.childIndex, this.childCount);

  final int childIndex;
  final int childCount;

  @override
  bool operator ==(Object other) {
    return other is MyTreeNodeDepth &&
        other.childIndex == childIndex &&
        other.childCount == childCount;
  }

  @override
  int get hashCode => Object.hash(childIndex, childCount);
}

class _MyTreeNodeData {
  const _MyTreeNodeData({
    required this.depth,
    required this.node,
    required this.branchLine,
    required this.parentExpanded,
    required this.showExpandIcon,
    required this.onFocusChanged,
    this.selectionPosition,
  });

  final List<MyTreeNodeDepth> depth;
  final MyTreeItemNode<dynamic> node;
  final MyTreeBranchLine branchLine;
  final bool parentExpanded;
  final bool showExpandIcon;
  final void Function(_MyTreeFocusChangeReason reason) onFocusChanged;
  final MyTreeSelectionPosition? selectionPosition;

  @override
  bool operator ==(Object other) {
    return other is _MyTreeNodeData &&
        listEquals(other.depth, depth) &&
        other.node == node &&
        other.branchLine == branchLine &&
        other.parentExpanded == parentExpanded &&
        other.showExpandIcon == showExpandIcon &&
        other.selectionPosition == selectionPosition;
  }

  @override
  int get hashCode {
    return Object.hash(
      Object.hashAll(depth),
      node,
      branchLine,
      parentExpanded,
      showExpandIcon,
      selectionPosition,
    );
  }
}

typedef MyTreeNodeUnaryOperator<T> =
    MyTreeNode<T>? Function(MyTreeNode<T> node);
typedef MyTreeNodeUnaryOperatorWithParent<T> =
    MyTreeNode<T>? Function(MyTreeNode<T>? parent, MyTreeNode<T> node);

extension MyTreeNodeListExtension<T> on List<MyTreeNode<T>> {
  List<MyTreeNode<T>> replaceNodes(MyTreeNodeUnaryOperator<T> operator) {
    return MyTree.replaceNodes(this, operator);
  }

  List<MyTreeNode<T>> replaceNodesWithParent(
    MyTreeNodeUnaryOperatorWithParent<T> operator,
  ) {
    return MyTree.replaceNodesWithParent(this, operator);
  }

  List<MyTreeNode<T>> replaceNode(
    MyTreeNode<T> oldNode,
    MyTreeNode<T> newNode,
  ) {
    return MyTree.replaceNode(this, oldNode, newNode);
  }

  List<MyTreeNode<T>> replaceItem(T oldItem, MyTreeNode<T> newItem) {
    return MyTree.replaceItem(this, oldItem, newItem);
  }

  List<MyTreeNode<T>> expandAll() => MyTree.expandAll(this);

  List<MyTreeNode<T>> collapseAll() => MyTree.collapseAll(this);

  List<MyTreeNode<T>> expandNode(MyTreeNode<T> target) {
    return MyTree.expandNode(this, target);
  }

  List<MyTreeNode<T>> expandItem(T target) => MyTree.expandItem(this, target);

  List<MyTreeNode<T>> collapseNode(MyTreeNode<T> target) {
    return MyTree.collapseNode(this, target);
  }

  List<MyTreeNode<T>> collapseItem(T target) {
    return MyTree.collapseItem(this, target);
  }

  List<MyTreeNode<T>> get selectedNodes => MyTree.getSelectedNodes(this);

  List<T> get selectedItems => MyTree.getSelectedItems(this);

  List<MyTreeNode<T>> selectNode(MyTreeNode<T> target) {
    return MyTree.selectNode(this, target);
  }

  List<MyTreeNode<T>> selectItem(T target) => MyTree.selectItem(this, target);

  List<MyTreeNode<T>> deselectNode(MyTreeNode<T> target) {
    return MyTree.deselectNode(this, target);
  }

  List<MyTreeNode<T>> deselectItem(T target) {
    return MyTree.deselectItem(this, target);
  }

  List<MyTreeNode<T>> toggleSelectNode(MyTreeNode<T> target) {
    return MyTree.toggleSelectNode(this, target);
  }

  List<MyTreeNode<T>> toggleSelectNodes(Iterable<MyTreeNode<T>> targets) {
    return MyTree.toggleSelectNodes(this, targets);
  }

  List<MyTreeNode<T>> toggleSelectItem(T target) {
    return MyTree.toggleSelectItem(this, target);
  }

  List<MyTreeNode<T>> toggleSelectItems(Iterable<T> targets) {
    return MyTree.toggleSelectItems(this, targets);
  }

  List<MyTreeNode<T>> selectAll() => MyTree.selectAll(this);

  List<MyTreeNode<T>> deselectAll() => MyTree.deselectAll(this);

  List<MyTreeNode<T>> toggleSelectAll() => MyTree.toggleSelectAll(this);

  List<MyTreeNode<T>> selectNodes(Iterable<MyTreeNode<T>> selectedNodes) {
    return MyTree.selectNodes(this, selectedNodes);
  }

  List<MyTreeNode<T>> selectItems(Iterable<T> selectedItems) {
    return MyTree.selectItems(this, selectedItems);
  }

  List<MyTreeNode<T>> deselectNodes(Iterable<MyTreeNode<T>> deselectedNodes) {
    return MyTree.deselectNodes(this, deselectedNodes);
  }

  List<MyTreeNode<T>> deselectItems(Iterable<T> deselectedItems) {
    return MyTree.deselectItems(this, deselectedItems);
  }

  List<MyTreeNode<T>> setSelectedNodes(Iterable<MyTreeNode<T>> selectedNodes) {
    return MyTree.setSelectedNodes(this, selectedNodes);
  }

  List<MyTreeNode<T>> setSelectedItems(Iterable<T> selectedItems) {
    return MyTree.setSelectedItems(this, selectedItems);
  }

  List<MyTreeNode<T>> updateRecursiveSelection() {
    return MyTree.updateRecursiveSelection(this);
  }
}

typedef MyTreeNodeSelectionChanged<T> =
    void Function(
      List<MyTreeNode<T>> selectedNodes,
      bool multiSelect,
      bool selected,
    );

class MyTreeSelectionDefaultHandler<T> {
  const MyTreeSelectionDefaultHandler(this.nodes, this.onChanged);

  final List<MyTreeNode<T>> nodes;
  final ValueChanged<List<MyTreeNode<T>>> onChanged;

  void call(
    List<MyTreeNode<T>> selectedNodes,
    bool multiSelect,
    bool selected,
  ) {
    if (multiSelect) {
      onChanged(
        selected
            ? nodes.selectNodes(selectedNodes)
            : nodes.deselectNodes(selectedNodes),
      );
    } else {
      onChanged(nodes.setSelectedNodes(selectedNodes));
    }
  }
}

class MyTreeItemExpandDefaultHandler<T> {
  const MyTreeItemExpandDefaultHandler(this.nodes, this.target, this.onChanged);

  final List<MyTreeNode<T>> nodes;
  final MyTreeNode<T> target;
  final ValueChanged<List<MyTreeNode<T>>> onChanged;

  void call(bool expanded) {
    onChanged(expanded ? nodes.expandNode(target) : nodes.collapseNode(target));
  }
}

class MyTree<T> extends StatefulWidget {
  const MyTree({
    required this.nodes,
    required this.builder,
    super.key,
    this.shrinkWrap = false,
    this.controller,
    this.branchLine,
    this.padding,
    this.showExpandIcon,
    this.allowMultiSelect,
    this.focusNode,
    this.onSelectionChanged,
    this.recursiveSelection,
  });

  static MyTreeNodeSelectionChanged<K> defaultSelectionHandler<K>(
    List<MyTreeNode<K>> nodes,
    ValueChanged<List<MyTreeNode<K>>> onChanged,
  ) {
    return MyTreeSelectionDefaultHandler(nodes, onChanged).call;
  }

  static ValueChanged<bool> defaultItemExpandHandler<K>(
    List<MyTreeNode<K>> nodes,
    MyTreeNode<K> target,
    ValueChanged<List<MyTreeNode<K>>> onChanged,
  ) {
    return MyTreeItemExpandDefaultHandler(nodes, target, onChanged).call;
  }

  static List<MyTreeNode<K>>? _replaceNodes<K>(
    List<MyTreeNode<K>> nodes,
    MyTreeNodeUnaryOperator<K> operator,
  ) {
    var changed = false;
    final newNodes = List<MyTreeNode<K>>.of(nodes);

    for (var i = 0; i < newNodes.length; i++) {
      final node = newNodes[i];
      var newNode = operator(node);
      final effectiveNode = newNode ?? node;
      final newChildren = _replaceNodes(effectiveNode.children, operator);

      if (newChildren != null) {
        newNode = effectiveNode.updateChildren(newChildren);
      }

      if (newNode != null) {
        newNodes[i] = newNode;
        changed = true;
      }
    }

    return changed ? newNodes : null;
  }

  static List<MyTreeNode<K>>? _replaceNodesWithParent<K>(
    MyTreeNode<K>? parent,
    List<MyTreeNode<K>> nodes,
    MyTreeNodeUnaryOperatorWithParent<K> operator,
  ) {
    var changed = false;
    final newNodes = List<MyTreeNode<K>>.of(nodes);

    for (var i = 0; i < newNodes.length; i++) {
      final node = newNodes[i];
      var newNode = operator(parent, node);
      final effectiveNode = newNode ?? node;
      final newChildren = _replaceNodesWithParent(
        effectiveNode,
        effectiveNode.children,
        operator,
      );

      if (newChildren != null) {
        newNode = effectiveNode.updateChildren(newChildren);
      }

      if (newNode != null) {
        newNodes[i] = newNode;
        changed = true;
      }
    }

    return changed ? newNodes : null;
  }

  static List<MyTreeNode<K>> replaceNodes<K>(
    List<MyTreeNode<K>> nodes,
    MyTreeNodeUnaryOperator<K> operator,
  ) {
    return _replaceNodes(nodes, operator) ?? nodes;
  }

  static List<MyTreeNode<K>> replaceNodesWithParent<K>(
    List<MyTreeNode<K>> nodes,
    MyTreeNodeUnaryOperatorWithParent<K> operator,
  ) {
    return _replaceNodesWithParent(null, nodes, operator) ?? nodes;
  }

  static List<MyTreeNode<K>> replaceNode<K>(
    List<MyTreeNode<K>> nodes,
    MyTreeNode<K> oldNode,
    MyTreeNode<K> newNode,
  ) {
    return replaceNodes(nodes, (node) => node == oldNode ? newNode : null);
  }

  static List<MyTreeNode<K>> replaceItem<K>(
    List<MyTreeNode<K>> nodes,
    K oldItem,
    MyTreeNode<K> newItem,
  ) {
    return replaceNodes(nodes, (node) {
      return node is MyTreeItemNode<K> && node.data == oldItem ? newItem : null;
    });
  }

  static List<MyTreeNode<K>> updateRecursiveSelection<K>(
    List<MyTreeNode<K>> nodes,
  ) {
    return replaceNodesWithParent(nodes, (parent, node) {
      if (node is MyTreeItemNode<K> &&
          !node.selected &&
          parent != null &&
          parent.selected) {
        return node.updateState(selected: true);
      }
      return null;
    });
  }

  static List<MyTreeNode<K>> getSelectedNodes<K>(List<MyTreeNode<K>> nodes) {
    final selected = <MyTreeNode<K>>[];

    void walk(MyTreeNode<K> node) {
      if (node.selected && node is MyTreeItemNode<K>) selected.add(node);
      for (final child in node.children) {
        walk(child);
      }
    }

    for (final node in nodes) {
      walk(node);
    }
    return selected;
  }

  static List<K> getSelectedItems<K>(List<MyTreeNode<K>> nodes) {
    return getSelectedNodes(
      nodes,
    ).whereType<MyTreeItemNode<K>>().map((node) => node.data).toList();
  }

  static List<MyTreeNode<K>> expandAll<K>(List<MyTreeNode<K>> nodes) {
    return replaceNodes(
      nodes,
      (node) => node.expanded ? null : node.updateState(expanded: true),
    );
  }

  static List<MyTreeNode<K>> collapseAll<K>(List<MyTreeNode<K>> nodes) {
    return replaceNodes(
      nodes,
      (node) => node.expanded ? node.updateState(expanded: false) : null,
    );
  }

  static List<MyTreeNode<K>> expandNode<K>(
    List<MyTreeNode<K>> nodes,
    MyTreeNode<K> target,
  ) {
    return replaceNodes(
      nodes,
      (node) => node == target ? node.updateState(expanded: true) : null,
    );
  }

  static List<MyTreeNode<K>> expandItem<K>(
    List<MyTreeNode<K>> nodes,
    K target,
  ) {
    return replaceNodes(nodes, (node) {
      if (node is MyTreeItemNode<K> && node.data == target && !node.expanded) {
        return node.updateState(expanded: true);
      }
      return null;
    });
  }

  static List<MyTreeNode<K>> collapseNode<K>(
    List<MyTreeNode<K>> nodes,
    MyTreeNode<K> target,
  ) {
    return replaceNodes(
      nodes,
      (node) => node == target ? node.updateState(expanded: false) : null,
    );
  }

  static List<MyTreeNode<K>> collapseItem<K>(
    List<MyTreeNode<K>> nodes,
    K target,
  ) {
    return replaceNodes(nodes, (node) {
      if (node is MyTreeItemNode<K> && node.data == target) {
        return node.updateState(expanded: false);
      }
      return null;
    });
  }

  static List<MyTreeNode<K>> selectNode<K>(
    List<MyTreeNode<K>> nodes,
    MyTreeNode<K> target,
  ) {
    return replaceNodes(
      nodes,
      (node) => node == target ? node.updateState(selected: true) : null,
    );
  }

  static List<MyTreeNode<K>> selectItem<K>(
    List<MyTreeNode<K>> nodes,
    K target,
  ) {
    return replaceNodes(nodes, (node) {
      if (node is MyTreeItemNode<K> && node.data == target) {
        return node.updateState(selected: true);
      }
      return null;
    });
  }

  static List<MyTreeNode<K>> deselectNode<K>(
    List<MyTreeNode<K>> nodes,
    MyTreeNode<K> target,
  ) {
    return replaceNodes(
      nodes,
      (node) => node == target ? node.updateState(selected: false) : null,
    );
  }

  static List<MyTreeNode<K>> deselectItem<K>(
    List<MyTreeNode<K>> nodes,
    K target,
  ) {
    return replaceNodes(nodes, (node) {
      if (node is MyTreeItemNode<K> && node.data == target) {
        return node.updateState(selected: false);
      }
      return null;
    });
  }

  static List<MyTreeNode<K>> toggleSelectNode<K>(
    List<MyTreeNode<K>> nodes,
    MyTreeNode<K> target,
  ) {
    return replaceNodes(
      nodes,
      (node) =>
          node == target ? node.updateState(selected: !node.selected) : null,
    );
  }

  static List<MyTreeNode<K>> toggleSelectNodes<K>(
    List<MyTreeNode<K>> nodes,
    Iterable<MyTreeNode<K>> targets,
  ) {
    return replaceNodes(
      nodes,
      (node) => targets.contains(node)
          ? node.updateState(selected: !node.selected)
          : null,
    );
  }

  static List<MyTreeNode<K>> toggleSelectItem<K>(
    List<MyTreeNode<K>> nodes,
    K target,
  ) {
    return replaceNodes(nodes, (node) {
      if (node is MyTreeItemNode<K> && node.data == target) {
        return node.updateState(selected: !node.selected);
      }
      return null;
    });
  }

  static List<MyTreeNode<K>> toggleSelectItems<K>(
    List<MyTreeNode<K>> nodes,
    Iterable<K> targets,
  ) {
    return replaceNodes(nodes, (node) {
      if (node is MyTreeItemNode<K> && targets.contains(node.data)) {
        return node.updateState(selected: !node.selected);
      }
      return null;
    });
  }

  static List<MyTreeNode<K>> selectAll<K>(List<MyTreeNode<K>> nodes) {
    return replaceNodes(nodes, (node) {
      return node is MyTreeItemNode<K> && !node.selected
          ? node.updateState(selected: true)
          : null;
    });
  }

  static List<MyTreeNode<K>> deselectAll<K>(List<MyTreeNode<K>> nodes) {
    return replaceNodes(nodes, (node) {
      return node is MyTreeItemNode<K> && node.selected
          ? node.updateState(selected: false)
          : null;
    });
  }

  static List<MyTreeNode<K>> toggleSelectAll<K>(List<MyTreeNode<K>> nodes) {
    return replaceNodes(nodes, (node) {
      return node is MyTreeItemNode<K>
          ? node.updateState(selected: !node.selected)
          : null;
    });
  }

  static List<MyTreeNode<K>> selectNodes<K>(
    List<MyTreeNode<K>> nodes,
    Iterable<MyTreeNode<K>> selectedNodes,
  ) {
    return replaceNodes(nodes, (node) {
      return selectedNodes.contains(node) && !node.selected
          ? node.updateState(selected: true)
          : null;
    });
  }

  static List<MyTreeNode<K>> selectItems<K>(
    List<MyTreeNode<K>> nodes,
    Iterable<K> selectedItems,
  ) {
    return replaceNodes(nodes, (node) {
      if (node is MyTreeItemNode<K> &&
          selectedItems.contains(node.data) &&
          !node.selected) {
        return node.updateState(selected: true);
      }
      return null;
    });
  }

  static List<MyTreeNode<K>> deselectNodes<K>(
    List<MyTreeNode<K>> nodes,
    Iterable<MyTreeNode<K>> deselectedNodes,
  ) {
    return replaceNodes(nodes, (node) {
      return deselectedNodes.contains(node) && node.selected
          ? node.updateState(selected: false)
          : null;
    });
  }

  static List<MyTreeNode<K>> deselectItems<K>(
    List<MyTreeNode<K>> nodes,
    Iterable<K> deselectedItems,
  ) {
    return replaceNodes(nodes, (node) {
      if (node is MyTreeItemNode<K> &&
          deselectedItems.contains(node.data) &&
          node.selected) {
        return node.updateState(selected: false);
      }
      return null;
    });
  }

  static List<MyTreeNode<K>> setSelectedNodes<K>(
    List<MyTreeNode<K>> nodes,
    Iterable<MyTreeNode<K>> selectedNodes,
  ) {
    return replaceNodes(nodes, (node) {
      if (node is! MyTreeItemNode<K>) return null;
      final selected = selectedNodes.contains(node);
      return node.selected == selected
          ? null
          : node.updateState(selected: selected);
    });
  }

  static List<MyTreeNode<K>> setSelectedItems<K>(
    List<MyTreeNode<K>> nodes,
    Iterable<K> selectedItems,
  ) {
    return replaceNodes(nodes, (node) {
      if (node is! MyTreeItemNode<K>) return null;
      final selected = selectedItems.contains(node.data);
      return node.selected == selected
          ? null
          : node.updateState(selected: selected);
    });
  }

  final List<MyTreeNode<T>> nodes;
  final Widget Function(BuildContext context, MyTreeItemNode<T> node) builder;
  final bool shrinkWrap;
  final ScrollController? controller;
  final MyTreeBranchLine? branchLine;
  final EdgeInsetsGeometry? padding;
  final bool? showExpandIcon;
  final bool? allowMultiSelect;
  final FocusScopeNode? focusNode;
  final MyTreeNodeSelectionChanged<T>? onSelectionChanged;
  final bool? recursiveSelection;

  @override
  State<MyTree<T>> createState() => _MyTreeState<T>();
}

typedef _MyTreeWalker<T> =
    void Function(
      bool parentExpanded,
      MyTreeItemNode<T> node,
      List<MyTreeNodeDepth> depth,
    );

typedef _MyNodeWalker<T> = void Function(MyTreeItemNode<T> node);

class _MyTreeState<T> extends State<MyTree<T>> {
  bool _multiSelect = false;
  bool _rangeMultiSelect = false;
  int? _currentFocusedIndex;
  int? _startFocusedIndex;

  void _walkFlattened(
    _MyTreeWalker<T> walker,
    List<MyTreeNode<T>> nodes,
    bool parentExpanded,
    List<MyTreeNodeDepth> depth,
  ) {
    for (var i = 0; i < nodes.length; i++) {
      final node = nodes[i];
      if (node is MyTreeItemNode<T>) {
        final newDepth = List<MyTreeNodeDepth>.of(depth)
          ..add(MyTreeNodeDepth(i, nodes.length));
        walker(parentExpanded, node, newDepth);
        _walkFlattened(
          walker,
          node.children,
          parentExpanded && node.expanded,
          newDepth,
        );
      } else if (node is MyTreeRootNode<T>) {
        _walkFlattened(walker, node.children, parentExpanded, depth);
      }
    }
  }

  void _walkItemNodes(_MyNodeWalker<T> walker, List<MyTreeNode<T>> nodes) {
    for (final node in nodes) {
      if (node is MyTreeItemNode<T>) {
        walker(node);
        _walkItemNodes(walker, node.children);
      } else if (node is MyTreeRootNode<T>) {
        _walkItemNodes(walker, node.children);
      }
    }
  }

  List<MyTreeNode<T>> _collectSelection(
    MyTreeItemNode<T> node,
    bool recursive,
  ) {
    if (!recursive) return [node];

    final selectedItems = <MyTreeNode<T>>[];
    _walkItemNodes(selectedItems.add, [node]);
    return selectedItems;
  }

  void _onChangeSelectionRange(
    List<_MyTreeNodeData> children,
    int start,
    int end,
    bool recursive,
  ) {
    if (children.isEmpty) return;
    if (start > end) {
      final temp = start;
      start = end;
      end = temp;
    }

    final selectedItems = <MyTreeNode<T>>[];
    for (var i = start; i <= end && i < children.length; i++) {
      if (!children[i].parentExpanded) continue;
      selectedItems.addAll(
        _collectSelection(children[i].node as MyTreeItemNode<T>, recursive),
      );
    }
    widget.onSelectionChanged?.call(selectedItems, false, true);
  }

  @override
  Widget build(BuildContext context) {
    final branchLine = widget.branchLine ?? MyTreeBranchLine.path;
    final showExpandIcon = widget.showExpandIcon ?? true;
    final allowMultiSelect = widget.allowMultiSelect ?? true;
    final recursiveSelection = widget.recursiveSelection ?? true;
    final children = <_MyTreeNodeData>[];

    var index = 0;
    _walkFlattened(
      (expanded, node, depth) {
        final currentIndex = index++;
        children.add(
          _MyTreeNodeData(
            depth: depth,
            node: node,
            branchLine: branchLine,
            parentExpanded: expanded,
            showExpandIcon: showExpandIcon,
            onFocusChanged: (reason) {
              if (reason == _MyTreeFocusChangeReason.focusScope) {
                _startFocusedIndex = currentIndex;
                _currentFocusedIndex = currentIndex;
                return;
              }

              _currentFocusedIndex = currentIndex;
              if (_rangeMultiSelect && _startFocusedIndex != null) {
                _onChangeSelectionRange(
                  children,
                  _startFocusedIndex!,
                  _currentFocusedIndex!,
                  recursiveSelection,
                );
                return;
              }

              _startFocusedIndex = currentIndex;
              widget.onSelectionChanged?.call(
                _collectSelection(node, recursiveSelection),
                _multiSelect,
                !node.selected,
              );
            },
          ),
        );
      },
      widget.nodes,
      true,
      [],
    );

    _markSelectionPositions(children);

    return Shortcuts(
      shortcuts: {
        if (allowMultiSelect) ...{
          LogicalKeySet(LogicalKeyboardKey.shift, LogicalKeyboardKey.arrowUp):
              const MyDirectionalSelectTreeNodeIntent(false),
          LogicalKeySet(LogicalKeyboardKey.shift, LogicalKeyboardKey.arrowDown):
              const MyDirectionalSelectTreeNodeIntent(true),
          LogicalKeySet(
            LogicalKeyboardKey.shiftLeft,
            LogicalKeyboardKey.arrowUp,
          ): const MyDirectionalSelectTreeNodeIntent(
            false,
          ),
          LogicalKeySet(
            LogicalKeyboardKey.shiftLeft,
            LogicalKeyboardKey.arrowDown,
          ): const MyDirectionalSelectTreeNodeIntent(
            true,
          ),
          LogicalKeySet(
            LogicalKeyboardKey.shiftRight,
            LogicalKeyboardKey.arrowUp,
          ): const MyDirectionalSelectTreeNodeIntent(
            false,
          ),
          LogicalKeySet(
            LogicalKeyboardKey.shiftRight,
            LogicalKeyboardKey.arrowDown,
          ): const MyDirectionalSelectTreeNodeIntent(
            true,
          ),
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.space):
              const MySelectTreeNodeIntent(),
          LogicalKeySet(
            LogicalKeyboardKey.controlLeft,
            LogicalKeyboardKey.space,
          ): const MySelectTreeNodeIntent(),
          LogicalKeySet(
            LogicalKeyboardKey.controlRight,
            LogicalKeyboardKey.space,
          ): const MySelectTreeNodeIntent(),
        },
      },
      child: Actions(
        actions: {
          MySelectTreeNodeIntent: CallbackAction<MySelectTreeNodeIntent>(
            onInvoke: (intent) {
              final index = _currentFocusedIndex;
              if (index == null || index >= children.length) return null;

              final selectedNode = children[index].node as MyTreeItemNode<T>;
              widget.onSelectionChanged?.call(
                _collectSelection(selectedNode, recursiveSelection),
                _multiSelect,
                !selectedNode.selected,
              );
              return null;
            },
          ),
          MyDirectionalSelectTreeNodeIntent:
              CallbackAction<MyDirectionalSelectTreeNodeIntent>(
                onInvoke: (intent) {
                  if (children.isEmpty) return null;

                  _currentFocusedIndex ??= 0;
                  _startFocusedIndex ??= _currentFocusedIndex;

                  final currentIndex = _currentFocusedIndex!;
                  final startIndex = _startFocusedIndex!;
                  final reverseSelection = currentIndex < startIndex;
                  final equalSelection = currentIndex == startIndex;
                  final nextIndex = _nextSelectableIndex(
                    children,
                    currentIndex,
                    startIndex,
                    reverseSelection,
                    equalSelection,
                    intent.forward,
                  );

                  if (nextIndex != null) _currentFocusedIndex = nextIndex;
                  _onChangeSelectionRange(
                    children,
                    _startFocusedIndex!,
                    _currentFocusedIndex!,
                    recursiveSelection,
                  );
                  return null;
                },
              ),
        },
        child: FocusScope(
          node: widget.focusNode,
          onKeyEvent: (node, event) {
            if (!allowMultiSelect) return KeyEventResult.ignored;

            if (event is KeyDownEvent) {
              if (_isShift(event.logicalKey)) _rangeMultiSelect = true;
              if (_isControl(event.logicalKey)) _multiSelect = true;
            } else if (event is KeyUpEvent) {
              if (_isShift(event.logicalKey)) _rangeMultiSelect = false;
              if (_isControl(event.logicalKey)) _multiSelect = false;
            }
            return KeyEventResult.ignored;
          },
          child: ListView.builder(
            padding: widget.padding ?? const EdgeInsets.all(8),
            shrinkWrap: widget.shrinkWrap,
            controller: widget.controller,
            itemCount: children.length,
            itemBuilder: (context, index) {
              final data = children[index];
              return MyProvider<_MyTreeNodeData>(
                data: data,
                notifyUpdate: (oldWidget) => oldWidget.data != data,
                child: Builder(
                  builder: (context) {
                    return widget.builder(
                      context,
                      data.node as MyTreeItemNode<T>,
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _markSelectionPositions(List<_MyTreeNodeData> children) {
    for (var i = 0; i < children.length; i++) {
      final child = children[i];
      if (!child.parentExpanded || !child.node.selected) continue;

      var nextSelected = false;
      for (var j = i + 1; j < children.length; j++) {
        if (!children[j].parentExpanded) continue;
        nextSelected = children[j].node.selected;
        break;
      }

      var previousSelected = false;
      for (var j = i - 1; j >= 0; j--) {
        if (!children[j].parentExpanded) continue;
        previousSelected = children[j].node.selected;
        break;
      }

      children[i] = _MyTreeNodeData(
        depth: child.depth,
        node: child.node,
        branchLine: child.branchLine,
        parentExpanded: child.parentExpanded,
        showExpandIcon: child.showExpandIcon,
        onFocusChanged: child.onFocusChanged,
        selectionPosition: switch ((previousSelected, nextSelected)) {
          (false, false) => MyTreeSelectionPosition.single,
          (false, true) => MyTreeSelectionPosition.start,
          (true, true) => MyTreeSelectionPosition.middle,
          (true, false) => MyTreeSelectionPosition.end,
        },
      );
    }
  }

  int? _nextSelectableIndex(
    List<_MyTreeNodeData> children,
    int currentIndex,
    int startIndex,
    bool reverseSelection,
    bool equalSelection,
    bool forward,
  ) {
    final step = forward ? 1 : -1;
    var index = currentIndex + step;

    while (index >= 0 && index < children.length) {
      final child = children[index];
      final selected = child.node.selected;
      final shouldUse =
          child.parentExpanded &&
          (equalSelection
              ? !selected
              : (reverseSelection ? selected == forward : selected != forward));

      if (shouldUse) return index;
      index += step;
    }
    return null;
  }

  bool _isShift(LogicalKeyboardKey key) {
    return key == LogicalKeyboardKey.shift ||
        key == LogicalKeyboardKey.shiftLeft ||
        key == LogicalKeyboardKey.shiftRight;
  }

  bool _isControl(LogicalKeyboardKey key) {
    return key == LogicalKeyboardKey.control ||
        key == LogicalKeyboardKey.controlLeft ||
        key == LogicalKeyboardKey.controlRight;
  }
}

abstract class MyTreeBranchLine {
  static const none = MyTreeBranchLineNone();
  static const line = MyTreeBranchLineLine();
  static const path = MyTreeBranchLinePath();

  const MyTreeBranchLine();

  Widget build(BuildContext context, List<MyTreeNodeDepth> depth, int index);
}

class MyTreeBranchLineNone extends MyTreeBranchLine {
  const MyTreeBranchLineNone();

  @override
  Widget build(BuildContext context, List<MyTreeNodeDepth> depth, int index) {
    return const SizedBox.shrink();
  }
}

class MyTreeBranchLineLine extends MyTreeBranchLine {
  const MyTreeBranchLineLine({this.color});

  final Color? color;

  @override
  Widget build(BuildContext context, List<MyTreeNodeDepth> depth, int index) {
    if (index <= 0) return const SizedBox.shrink();

    return CustomPaint(
      painter: _MyTreePathPainter(
        color: color ?? context.colorScheme.border,
        top: true,
        bottom: true,
      ),
    );
  }
}

class MyTreeBranchLinePath extends MyTreeBranchLine {
  const MyTreeBranchLinePath({this.color});

  final Color? color;

  @override
  Widget build(BuildContext context, List<MyTreeNodeDepth> depth, int index) {
    var top = true;
    var right = true;
    var bottom = true;
    var left = false;

    if (index >= 0) {
      final current = depth[index];
      if (index != depth.length - 1) {
        right = false;
        if (current.childIndex >= current.childCount - 1) top = false;
      }

      if (current.childIndex >= current.childCount - 1) bottom = false;
    } else {
      left = true;
      top = false;
      bottom = false;
    }

    return CustomPaint(
      painter: _MyTreePathPainter(
        color: color ?? context.colorScheme.border,
        top: top,
        right: right,
        bottom: bottom,
        left: left,
      ),
    );
  }
}

class _MyTreePathPainter extends CustomPainter {
  _MyTreePathPainter({
    required this.color,
    this.top = false,
    this.right = false,
    this.bottom = false,
    this.left = false,
  });

  final Color color;
  final bool top;
  final bool right;
  final bool bottom;
  final bool left;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;
    final path = Path();
    final halfWidth = size.width / 2;
    final halfHeight = size.height / 2;

    if (top) {
      path
        ..moveTo(halfWidth, 0)
        ..lineTo(halfWidth, halfHeight);
    }
    if (right) {
      path
        ..moveTo(halfWidth, halfHeight)
        ..lineTo(size.width, halfHeight);
    }
    if (bottom) {
      path
        ..moveTo(halfWidth, halfHeight)
        ..lineTo(halfWidth, size.height);
    }
    if (left) {
      path
        ..moveTo(halfWidth, halfHeight)
        ..lineTo(0, halfHeight);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _MyTreePathPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.top != top ||
        oldDelegate.right != right ||
        oldDelegate.bottom != bottom ||
        oldDelegate.left != left;
  }
}

class MyTreeItem extends StatefulWidget {
  const MyTreeItem({
    required this.child,
    super.key,
    this.leading,
    this.trailing,
    this.onTap,
    this.onDoubleTap,
    this.onExpand,
    this.expandable,
    this.focusNode,
  });

  final Widget child;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;
  final ValueChanged<bool>? onExpand;
  final bool? expandable;
  final FocusNode? focusNode;

  @override
  State<MyTreeItem> createState() => _MyTreeItemState();
}

class _MyTreeItemState extends State<MyTreeItem> {
  final WidgetStatesController _statesController = WidgetStatesController();
  FocusNode? _focusNode;
  bool _ownsFocusNode = false;
  _MyTreeNodeData? _data;

  FocusNode get _effectiveFocusNode => _focusNode!;

  @override
  void initState() {
    super.initState();
    _setFocusNode(widget.focusNode);
  }

  @override
  void didUpdateWidget(covariant MyTreeItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      _disposeOwnedFocusNode();
      _setFocusNode(widget.focusNode);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newData = context.maybeWatch<_MyTreeNodeData>();
    if (_data != newData) {
      _data = newData;
      _statesController.update(
        WidgetState.selected,
        _data?.node.selected ?? false,
      );
    }
  }

  @override
  void dispose() {
    _disposeOwnedFocusNode();
    _statesController.dispose();
    super.dispose();
  }

  void _setFocusNode(FocusNode? focusNode) {
    _ownsFocusNode = focusNode == null;
    _focusNode = focusNode ?? FocusNode();
  }

  void _disposeOwnedFocusNode() {
    if (_ownsFocusNode) _focusNode?.dispose();
    _focusNode = null;
    _ownsFocusNode = false;
  }

  void _handleFocusChanged(bool focused) {
    _statesController.update(WidgetState.focused, focused);
    if (focused) {
      _data?.onFocusChanged(_MyTreeFocusChangeReason.focusScope);
    }
  }

  void _handleTap() {
    widget.onTap?.call();
    _effectiveFocusNode.requestFocus();
    _data?.onFocusChanged(_MyTreeFocusChangeReason.userInteraction);
  }

  void _handleDoubleTap() {
    widget.onDoubleTap?.call();
    _toggleExpansion();
    _effectiveFocusNode.requestFocus();
  }

  void _toggleExpansion() {
    final data = _data;
    if (data == null || !_isExpandable(data)) return;
    widget.onExpand?.call(!data.node.expanded);
  }

  bool _isExpandable(_MyTreeNodeData data) {
    return widget.expandable ?? data.node.children.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final data = _data;
    assert(data != null, 'MyTreeItem must be a descendant of MyTree.');

    final content = _buildFocusableItem(context, data!);

    return ExcludeFocus(
      excluding: !data.parentExpanded,
      child: DefaultTextStyle.merge(
        style: context.bodyMedium,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        child: AnimatedSwitcher(
          duration: kDefaultDuration,
          switchInCurve: Curves.easeInOut,
          switchOutCurve: Curves.easeInOut,
          child: data.parentExpanded
              ? content
              : const SizedBox.shrink(key: ValueKey('hidden-tree-item')),
        ),
      ),
    );
  }

  Widget _buildFocusableItem(BuildContext context, _MyTreeNodeData data) {
    final enabled =
        widget.onTap != null ||
        widget.onDoubleTap != null ||
        (widget.onExpand != null && _isExpandable(data));

    return IntrinsicHeight(
      key: ValueKey(data.node),
      child: Shortcuts(
        shortcuts: {
          if (widget.onExpand != null && _isExpandable(data))
            LogicalKeySet(LogicalKeyboardKey.arrowRight):
                const MyExpandTreeNodeIntent(),
          if (widget.onExpand != null && _isExpandable(data))
            LogicalKeySet(LogicalKeyboardKey.arrowLeft):
                const MyCollapseTreeNodeIntent(),
        },
        child: Actions(
          actions: {
            ActivateIntent: CallbackAction<ActivateIntent>(
              onInvoke: (intent) {
                _toggleExpansion();
                widget.onTap?.call();
                return null;
              },
            ),
            MyCollapseTreeNodeIntent: CallbackAction<MyCollapseTreeNodeIntent>(
              onInvoke: (intent) {
                if (_isExpandable(data)) widget.onExpand?.call(false);
                return null;
              },
            ),
            MyExpandTreeNodeIntent: CallbackAction<MyExpandTreeNodeIntent>(
              onInvoke: (intent) {
                if (_isExpandable(data)) widget.onExpand?.call(true);
                return null;
              },
            ),
          },
          child: Semantics(
            button: enabled,
            selected: data.node.selected,
            focusable: enabled,
            enabled: enabled,
            child: MyFocusable(
              params: MyFocusableParams(
                focusNode: _effectiveFocusNode,
                onFocusChange: _handleFocusChanged,
              ),
              builder: (context, focused, child) {
                return MyDecorator(
                  focused: focused && !data.node.selected,
                  radius: _borderRadiusFromPosition(
                    data.selectionPosition,
                    MyRadius.medium,
                  ),
                  child: child,
                );
              },
              child: ValueListenableBuilder<Set<WidgetState>>(
                valueListenable: _statesController,
                builder: (context, states, _) {
                  return MyGestureDetector(
                    behavior: HitTestBehavior.translucent,
                    cursor: enabled
                        ? SystemMouseCursors.click
                        : SystemMouseCursors.basic,
                    onHover: (hovered) {
                      _statesController.update(WidgetState.hovered, hovered);
                    },
                    onTapDown: (_) {
                      _statesController.update(WidgetState.pressed, true);
                    },
                    onTapUp: (_) {
                      _statesController.update(WidgetState.pressed, false);
                    },
                    onTapCancel: () {
                      _statesController.update(WidgetState.pressed, false);
                    },
                    onTap: enabled ? _handleTap : null,
                    onDoubleTap:
                        widget.onDoubleTap != null ||
                            (widget.onExpand != null && _isExpandable(data))
                        ? _handleDoubleTap
                        : null,
                    child: DecoratedBox(
                      decoration: _decorationFor(context, data, states),
                      child: _buildRow(context, data),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _decorationFor(
    BuildContext context,
    _MyTreeNodeData data,
    Set<WidgetState> states,
  ) {
    if (states.contains(WidgetState.selected)) {
      return BoxDecoration(
        color: context.colorScheme.primary.scaleAlpha(
          states.contains(WidgetState.focused) ? 0.10 : 0.05,
        ),
        borderRadius: _borderRadiusFromPosition(
          data.selectionPosition,
          MyRadius.medium,
        ),
      );
    }

    if (states.contains(WidgetState.hovered)) {
      return BoxDecoration(
        color: context.colorScheme.muted.scaleAlpha(0.5),
        borderRadius: MyBorderRadius.medium,
      );
    }

    return const BoxDecoration();
  }

  Widget _buildRow(BuildContext context, _MyTreeNodeData data) {
    const gap = 8.0;
    const indentWidth = 16.0;
    final rowChildren = <Widget>[];

    if (data.showExpandIcon) rowChildren.add(const SizedBox(width: gap));

    for (var i = 0; i < data.depth.length; i++) {
      if (i == 0) continue;
      if (!data.showExpandIcon) rowChildren.add(const SizedBox(width: gap));
      rowChildren.add(
        SizedBox(
          width: indentWidth,
          child: data.branchLine.build(context, data.depth, i),
        ),
      );
    }

    if (data.showExpandIcon) {
      rowChildren.add(_buildExpandIcon(context, data));
    }

    rowChildren.add(
      Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: gap, vertical: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (widget.leading != null) ...[
                IconTheme.merge(
                  data: const IconThemeData(size: 16),
                  child: widget.leading!,
                ),
                const SizedBox(width: gap),
              ],
              Expanded(child: widget.child),
              if (widget.trailing != null) ...[
                const SizedBox(width: gap),
                widget.trailing!,
              ],
            ],
          ),
        ),
      ),
    );

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 28),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: rowChildren,
      ),
    );
  }

  Widget _buildExpandIcon(BuildContext context, _MyTreeNodeData data) {
    if (!_isExpandable(data)) {
      if (data.depth.length > 1) {
        return SizedBox(
          width: 20,
          child: data.branchLine.build(context, data.depth, -1),
        );
      }
      return const SizedBox(width: 20);
    }

    return MyGestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _toggleExpansion,
      child: SizedBox(
        width: 20,
        child: Center(
          child: AnimatedRotation(
            duration: kDefaultDuration,
            turns: data.node.expanded ? 0.25 : 0,
            child: Icon(
              LucideIcons.chevronRight,
              size: 16,
              color: context.colorScheme.mutedForeground,
            ),
          ),
        ),
      ),
    );
  }
}

class MyExpandTreeNodeIntent extends Intent {
  const MyExpandTreeNodeIntent();
}

class MyCollapseTreeNodeIntent extends Intent {
  const MyCollapseTreeNodeIntent();
}

class MySelectTreeNodeIntent extends Intent {
  const MySelectTreeNodeIntent();
}

class MyDirectionalSelectTreeNodeIntent extends Intent {
  const MyDirectionalSelectTreeNodeIntent(this.forward);

  final bool forward;
}
