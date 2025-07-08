import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// HorizontalList widget is great when you don't want to give fix height to a item
class HorizontalList extends StatelessWidget {
  const HorizontalList({
    required this.itemCount,
    required this.itemBuilder,
    this.spacing,
    this.runSpacing,
    this.padding,
    this.physics,
    this.controller,
    this.reverse = false,
    this.wrapAlignment,
    this.crossAxisAlignment,
    super.key,
  });

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final double? spacing;
  final double? runSpacing;
  final EdgeInsets? padding;
  final ScrollPhysics? physics;
  final bool reverse;
  final ScrollController? controller;

  final WrapAlignment? wrapAlignment;
  final WrapCrossAlignment? crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: physics,
      padding: padding ?? EdgeInsets.all(8),
      scrollDirection: Axis.horizontal,
      reverse: reverse,
      controller: controller,
      child: Wrap(
        spacing: spacing ?? 8,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        runAlignment: wrapAlignment ?? WrapAlignment.start,
        crossAxisAlignment: crossAxisAlignment ?? WrapCrossAlignment.start,
        runSpacing: runSpacing ?? 8,
        children: List.generate(
          itemCount,
          (index) => itemBuilder(context, index),
        ),
      ),
    );
  }
}

class HorizontalListView<T> extends StatefulWidget {
  const HorizontalListView({
    required this.builder,
    super.key,
    this.itemCount = 100,
    this.listHeight,
    this.itemHeight,
    this.itemWidth,
    this.reverse = false,
    this.padding = EdgeInsets.zero,
    this.primary,
    this.physics,
    this.controller,
    this.dragStartBehavior = DragStartBehavior.start,
    this.clipBehavior = Clip.hardEdge,
    this.restorationId,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
  });

  final IndexedWidgetBuilder builder;
  final int itemCount;
  final bool reverse;
  final EdgeInsetsGeometry? padding;
  final bool? primary;
  final ScrollPhysics? physics;
  final ScrollController? controller;
  final DragStartBehavior dragStartBehavior;
  final Clip clipBehavior;
  final String? restorationId;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;
  final double? listHeight;
  final double? itemHeight;
  final double? itemWidth;

  @override
  _HorizontalListViewState<T> createState() => _HorizontalListViewState();
}

class _HorizontalListViewState<T> extends State<HorizontalListView<T>> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.listHeight,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        reverse: widget.reverse,
        padding: widget.padding,
        primary: widget.primary,
        physics: widget.physics,
        controller: widget.controller,
        dragStartBehavior: widget.dragStartBehavior,
        clipBehavior: widget.clipBehavior,
        restorationId: widget.restorationId,
        keyboardDismissBehavior: widget.keyboardDismissBehavior,
        child: Row(
          children: List.generate(widget.itemCount, (index) {
            return SizedBox(
              height: widget.itemHeight,
              width: widget.itemWidth,
              child: widget.builder(context, index),
            );
          }),
        ),
      ),
    );
  }
}
