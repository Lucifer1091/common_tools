import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../reorderable_grid_view.dart';
import 'sliver_grid_with_reorderable_pos_delegate.dart';

class ReorderableSliverGridView extends StatelessWidget {
  final List<Widget> children;
  final List<Widget>? header;
  final List<Widget>? footer;
  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double childAspectRatio;

  final DragEnableConfig? dragEnableConfig;
  final ReorderCallback onReorder;
  final DragWidgetBuilder? dragWidgetBuilder;
  final ScrollSpeedController? scrollSpeedController;
  final PlaceholderBuilder? placeholderBuilder;
  final OnDragStart? onDragStart;
  final OnDragUpdate? onDragUpdate;
  final Duration dragStartDelay;
  final bool dragEnabled;

  const ReorderableSliverGridView({
    super.key,
    this.children = const <Widget>[],
    required this.crossAxisCount,
    required this.mainAxisSpacing,
    required this.crossAxisSpacing,
    required this.childAspectRatio,
    required this.onReorder,
    this.dragWidgetBuilder,
    this.header,
    this.footer,
    this.dragStartDelay = kLongPressTimeout,
    this.scrollSpeedController,
    this.placeholderBuilder,
    this.onDragStart,
    this.onDragUpdate,
    this.dragEnabled = true,
    this.dragEnableConfig,
  });

  const ReorderableSliverGridView.count({
    Key? key,
    required int crossAxisCount,
    required ReorderCallback onReorder,
    DragWidgetBuilder? dragWidgetBuilder,
    List<Widget>? footer,
    List<Widget>? header,
    OnDragStart? onDragStart,
    OnDragUpdate? onDragUpdate,
    double mainAxisSpacing = 0.0,
    double crossAxisSpacing = 0.0,
    double childAspectRatio = 1.0,
    Duration dragStartDelay = kLongPressTimeout,
   List<Widget> children = const <Widget>[],
    bool dragEnabled = true,
    DragEnableConfig? dragEnableConfig,
  }) : this(
          key: key,
          onReorder: onReorder,
          children: children,
          footer: footer,
          header: header,
          crossAxisCount: crossAxisCount,
          dragWidgetBuilder: dragWidgetBuilder,
          mainAxisSpacing: mainAxisSpacing,
          crossAxisSpacing: crossAxisSpacing,
          childAspectRatio: childAspectRatio,
          onDragStart: onDragStart,
          onDragUpdate: onDragUpdate,
          dragStartDelay: dragStartDelay,
          dragEnabled: dragEnabled,
          dragEnableConfig: dragEnableConfig,
        );

  @override
  Widget build(BuildContext context) {
    debugPrint("header: $header");

    var child = SliverGridWithReorderablePosDelegate.count(
      key: key,
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: mainAxisSpacing,
      crossAxisSpacing: crossAxisSpacing,
      childAspectRatio: childAspectRatio,
      children: ReorderableItemView.wrapMeList(header, children, footer),
    );

    return ReorderableWrapperWidget(
      onReorder: onReorder,
      dragWidgetBuilder: dragWidgetBuilder,
      dragStartDelay: dragStartDelay,
      dragEnabled: dragEnabled,
      scrollSpeedController: scrollSpeedController,
      placeholderBuilder: placeholderBuilder,
      onDragStart: onDragStart,
      onDragUpdate: onDragUpdate,
      isSliver: true,
      dragEnableConfig: dragEnableConfig,
      child: child,
    );
  }
}
