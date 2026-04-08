import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'src/reorderable_item.dart';
import 'src/reorderable_wrapper_widget.dart';

export 'src/reorderable_sliver_grid_view.dart' show ReorderableSliverGridView;
export 'src/reorderable_wrapper_widget.dart' show ReorderableWrapperWidget;
export 'src/reorderable_item.dart' show ReorderableItemView;

/// Build the drag widget under finger when dragging.
/// The index here represents the index of current dragging widget
/// The child here represents the current index widget
/// [takeScreenshot] If you pass true, then it will take a screenshot of the
/// drag widget.
class DragWidgetBuilder {
  DragWidgetBuilder({required this.builder, this.takeScreenshot = false});

  /// if true, will create a screenshot for the drag widget
  final bool takeScreenshot;

  /// [screenshot] will not be null if you [takeScreenshot] is true.
  final Widget Function(int index, Widget child, ImageProvider? screenshot)
  builder;
}

/// Control the scroll speed if drag over the boundary.
/// We can pass time here??
/// [timeInMilliSecond] is the time passed.
/// [overPercentage] is the scroll over the boundary percentage
/// [overSize] is the pixel drag over the boundary
/// [itemSize] is the drag item size
/// Maybe you need decide the scroll speed by the given param.
/// return how many pixels when scroll in 14ms(maybe a frame). 5 is the default
typedef ScrollSpeedController =
    double Function(int timeInMilliSecond, double overSize, double itemSize);

/// every an drop index changed
/// old == null, means drag start
typedef OnDropIndexChange = void Function(int index, int? old);

/// build the target placeholder
typedef PlaceholderBuilder =
    Widget Function(int dropIndex, int dropInddex, Widget dragWidget);

/// The drag and drop life cycle.
typedef OnDragStart = void Function(int dragIndex);

typedef DragEnableConfig = bool Function(int index);

/// Called when the position of the dragged widget changes.
///
/// [dragIndex] is the index of the item that is dragged.
/// [position] is the current position of the pointer in the
/// global coordinate system. [delta] is the offset of the current
/// position relative to the position of the last drag update call.
typedef OnDragUpdate =
    void Function(int dragIndex, Offset position, Offset delta);

/// Usage:
/// ```
/// ReorderableGridView(
///   crossAxisCount: 3,
///   children: this.data.map((e) => buildItem("$e")).toList(),
///   onReorder: (oldIndex, newIndex) {
///     setState(() {
///       final element = data.removeAt(oldIndex);
///       data.insert(newIndex, element);
///     });
///   },
/// )
///```
/// I think it's borrowing to pass those params.
/// Will it to hard to calculate the position by delegator? not by crossAxis
/// and spacing?
/// And the SliverGridDelete need an constraint to get a layout but, I don't have the
/// constraint, and that method look called by the framework.
/// So I need the crossAxisCount, spacing to determine the pos.
class ReorderableGridView extends StatelessWidget {

  const ReorderableGridView({
    required this.onReorder,
    required this.gridDelegate,
    required this.childrenDelegate,
    super.key,
    this.dragWidgetBuilder,
    this.dragEnableConfig,
    this.scrollSpeedController,
    this.placeholderBuilder,
    this.onDragStart,
    this.onDragUpdate,
    this.restrictDragScope = false,
    this.reverse = false,
    this.primary,
    this.physics,
    this.shrinkWrap = false,
    this.padding,
    this.cacheExtent,
    this.semanticChildCount,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
    this.controller,
    this.dragStartBehavior = DragStartBehavior.start,
    this.dragStartDelay,
    this.dragEnabled,
    this.onDropIndexChange,
  });
  ReorderableGridView.builder({
    required ReorderCallback onReorder,
    required SliverGridDelegate gridDelegate,
    required IndexedWidgetBuilder itemBuilder,
    Key? key,
    ScrollSpeedController? scrollSpeedController,
    DragWidgetBuilder? dragWidgetBuilder,
    PlaceholderBuilder? placeholderBuilder,
    OnDragStart? onDragStart,
    OnDragUpdate? onDragUpdate,
    bool reverse = false,
    ScrollController? controller,
    bool? primary,
    ScrollPhysics? physics,
    bool shrinkWrap = false,
    EdgeInsetsGeometry? padding,
    int? itemCount,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    double? cacheExtent,
    int? semanticChildCount,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.manual,
    String? restorationId,
    Clip clipBehavior = Clip.hardEdge,
    Duration? dragStartDelay,
    bool? dragEnabled,
    bool restrictDragScope = false,
    DragEnableConfig? dragEnableConfig,
    OnDropIndexChange? onDropIndexChange,
  }) : this(
         key: key,
         onReorder: onReorder,
         dragWidgetBuilder: dragWidgetBuilder,
         scrollSpeedController: scrollSpeedController,
         dragEnableConfig: dragEnableConfig,
         placeholderBuilder: placeholderBuilder,
         onDragStart: onDragStart,
         onDragUpdate: onDragUpdate,
         // how to determine the
         childrenDelegate: SliverChildBuilderDelegate(
           (BuildContext context, int index) {
             Widget child = itemBuilder(context, index);
             assert(() {
               if (child.key == null) {
                 throw FlutterError(
                   'Every item of ReorderableGridView must have a key.',
                 );
               }
               return true;
             }());
             return ReorderableItemView(
               key: child.key!,
               index: index,
               child: child,
             );
           },
           childCount: itemCount,
           addAutomaticKeepAlives: addAutomaticKeepAlives,
           addRepaintBoundaries: addRepaintBoundaries,
           addSemanticIndexes: addSemanticIndexes,
         ),

         gridDelegate: gridDelegate,
         reverse: reverse,
         controller: controller,
         primary: primary,
         physics: physics,
         shrinkWrap: shrinkWrap,
         padding: padding,
         cacheExtent: cacheExtent,
         semanticChildCount: semanticChildCount ?? itemCount,
         dragStartBehavior: dragStartBehavior,
         keyboardDismissBehavior: keyboardDismissBehavior,
         restorationId: restorationId,
         clipBehavior: clipBehavior,
         dragStartDelay: dragStartDelay,
         dragEnabled: dragEnabled,
         restrictDragScope: restrictDragScope,
         onDropIndexChange: onDropIndexChange,
       );

  factory ReorderableGridView.count({
    required ReorderCallback onReorder,
    required int crossAxisCount,
    Key? key,
    DragEnableConfig? dragEnableConfig,
    DragWidgetBuilder? dragWidgetBuilder,
    ScrollSpeedController? scrollSpeedController,
    PlaceholderBuilder? placeholderBuilder,
    OnDragStart? onDragStart,
    OnDragUpdate? onDragUpdate,
    List<Widget>? footer,
    List<Widget>? header,
    double mainAxisSpacing = 0.0,
    double crossAxisSpacing = 0.0,
    double childAspectRatio = 1.0,
    double? mainAxisExtent,
    bool reverse = false,
    ScrollController? controller,
    bool? primary,
    ScrollPhysics? physics,
    bool shrinkWrap = false,
    EdgeInsetsGeometry? padding,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    double? cacheExtent,
    List<Widget> children = const <Widget>[],
    int? semanticChildCount,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.manual,
    String? restorationId,
    Clip clipBehavior = Clip.hardEdge,
    Duration? dragStartDelay,
    bool? dragEnabled,
    bool restrictDragScope = false,
    OnDropIndexChange? onDropIndexChange,
  }) {
    assert(
      children.every((Widget w) => w.key != null),
      'All children of this widget must have a key.',
    );
    return ReorderableGridView(
      key: key,
      onReorder: onReorder,
      dragEnableConfig: dragEnableConfig,
      dragWidgetBuilder: dragWidgetBuilder,
      scrollSpeedController: scrollSpeedController,
      placeholderBuilder: placeholderBuilder,
      onDragStart: onDragStart,
      onDragUpdate: onDragUpdate,
      childrenDelegate: SliverChildListDelegate(
        ReorderableItemView.wrapMeList(header, children, footer),
        addAutomaticKeepAlives: addAutomaticKeepAlives,
        addRepaintBoundaries: addRepaintBoundaries,
        addSemanticIndexes: addSemanticIndexes,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
        childAspectRatio: childAspectRatio,
        mainAxisExtent: mainAxisExtent,
      ),
      reverse: reverse,
      controller: controller,
      primary: primary,
      physics: physics,
      shrinkWrap: shrinkWrap,
      padding: padding,
      cacheExtent: cacheExtent,
      semanticChildCount:
          semanticChildCount ??
          (header?.length ?? 0) + children.length + (footer?.length ?? 0),
      dragStartBehavior: dragStartBehavior,
      keyboardDismissBehavior: keyboardDismissBehavior,
      restorationId: restorationId,
      clipBehavior: clipBehavior,
      dragEnabled: dragEnabled,
      dragStartDelay: dragStartDelay,
      restrictDragScope: restrictDragScope,
      onDropIndexChange: onDropIndexChange,
    );
  }
  final ReorderCallback onReorder;
  final DragWidgetBuilder? dragWidgetBuilder;
  final ScrollSpeedController? scrollSpeedController;
  final PlaceholderBuilder? placeholderBuilder;
  final OnDragStart? onDragStart;
  final OnDragUpdate? onDragUpdate;
  // every time an animation occurs begin
  final OnDropIndexChange? onDropIndexChange;

  final DragEnableConfig? dragEnableConfig;
  final bool? primary;
  final bool shrinkWrap;
  final bool restrictDragScope;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final bool reverse;
  final double? cacheExtent;
  final int? semanticChildCount;

  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;
  final Clip clipBehavior;
  final String? restorationId;

  final SliverChildDelegate childrenDelegate;

  final SliverGridDelegate gridDelegate;
  final ScrollController? controller;
  final DragStartBehavior dragStartBehavior;

  final Duration? dragStartDelay;
  final bool? dragEnabled;

  @override
  Widget build(BuildContext context) {
    return ReorderableWrapperWidget(
      onReorder: onReorder,
      dragEnableConfig: dragEnableConfig,
      dragWidgetBuilder: dragWidgetBuilder,
      scrollSpeedController: scrollSpeedController,
      placeholderBuilder: placeholderBuilder,
      onDragStart: onDragStart,
      onDragUpdate: onDragUpdate,
      dragEnabled: dragEnabled,
      dragStartDelay: dragStartDelay,
      restrictDragScope: restrictDragScope,
      onDropIndexChange: onDropIndexChange,
      child: GridView.custom(
        key: key,
        gridDelegate: gridDelegate,
        childrenDelegate: childrenDelegate,
        controller: controller,
        reverse: reverse,
        primary: primary,
        physics: physics,
        shrinkWrap: shrinkWrap,
        padding: padding,
        cacheExtent: cacheExtent,
        semanticChildCount: semanticChildCount,
        keyboardDismissBehavior: keyboardDismissBehavior,
        restorationId: restorationId,
        clipBehavior: clipBehavior,
        dragStartBehavior: dragStartBehavior,
      ),
    );
  }
}
