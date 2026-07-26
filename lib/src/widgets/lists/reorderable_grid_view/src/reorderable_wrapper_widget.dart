import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../reorderable_grid_view.dart';
import 'reorderable_grid_mixin.dart';
import 'reorderable_item.dart';

class GridChildPosDelegate extends ReorderableChildPosDelegate {
  const GridChildPosDelegate({
    required this.crossAxisCount,
    this.mainAxisSpacing = 0.0,
    this.crossAxisSpacing = 0.0,
    this.childAspectRatio = 1.0,
  });
  final int crossAxisCount;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final double childAspectRatio;

  @override
  Offset getPos(
    int index,
    Map<int, ReorderableItemViewState> items,
    BuildContext context,
  ) {
    // can I get pos by child?
    final child = items[index];
    // I think the better is use the sliverGrid?
    final childObject = child?.context.findRenderObject();

    // so from the childObject, I still can't get pos?
    if (childObject == null) {
      debugPrint('index: $index is null');
    } else {
      if (childObject is RenderSliver) {
        debugPrint('index: $index, pos: ${childObject.constraints}');
      } else if (childObject is RenderBox) {
        // childObject.localToGlobal(point)
        debugPrint('index: $index, pos: ${childObject.semanticBounds}');
      } else {
        debugPrint('index: $index, $childObject');
      }
    }

    // will it be not ready?
    // index and the next is not ready?
    // ok, but let's do it

    double width;
    final RenderObject? renderObject = context.findRenderObject();

    if (renderObject == null) {
      return Offset.zero;
    }

    if (renderObject is RenderSliver) {
      width = renderObject.constraints.crossAxisExtent;
    } else {
      width = (renderObject as RenderBox).size.width;
    }

    final double itemWidth =
        (width - (crossAxisCount - 1) * crossAxisSpacing) / crossAxisCount;

    final int row = index ~/ crossAxisCount;
    final int col = index % crossAxisCount;

    final double x = (col - 1) * (itemWidth + crossAxisSpacing);
    final double y =
        (row - 1) * (itemWidth / childAspectRatio + mainAxisSpacing);

    return Offset(x, y);
  }
}

class ReorderableWrapperWidget extends StatefulWidget
    with ReorderableGridWidgetMixin {
  const ReorderableWrapperWidget({
    required this.child,
    required this.onReorder,
    super.key,
    this.dragEnableConfig,
    this.restrictDragScope = false,
    this.dragWidgetBuilder,
    this.scrollSpeedController,
    this.placeholderBuilder,
    this.posDelegate,
    this.onDragStart,
    this.onDragUpdate,
    this.dragEnabled,
    this.dragStartDelay,
    this.isSliver,
    this.onDropIndexChange,
  });
  @override
  final DragEnableConfig? dragEnableConfig;

  @override
  final ReorderCallback onReorder;

  @override
  final DragWidgetBuilder? dragWidgetBuilder;

  @override
  final ScrollSpeedController? scrollSpeedController;

  @override
  final PlaceholderBuilder? placeholderBuilder;

  final ReorderableChildPosDelegate? posDelegate;

  @override
  final OnDragStart? onDragStart;

  @override
  final OnDragUpdate? onDragUpdate;

  @override
  final Widget child;

  @override
  final bool? dragEnabled;

  @override
  final Duration? dragStartDelay;

  @override
  final bool? isSliver;

  @override
  final bool restrictDragScope;

  @override
  // every time an animation occurs begin
  final OnDropIndexChange? onDropIndexChange;

  @override
  ReorderableWrapperWidgetState createState() {
    return ReorderableWrapperWidgetState();
  }
}

/// Yes we can't get grid delegate here, because we don't know child.
class ReorderableWrapperWidgetState extends State<ReorderableWrapperWidget>
    with
        TickerProviderStateMixin<ReorderableWrapperWidget>,
        ReorderableGridStateMixin {
  ReorderableWrapperWidgetState();
}
