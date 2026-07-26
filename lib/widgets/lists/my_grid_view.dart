import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show ScrollCacheExtent;

typedef MyGridViewBuilder<T> = Widget Function(int index, T item);

/// A type-safe grid view with optional header, footer, and pagination slots.
///
/// `MyGridView` mirrors the ergonomics of `MyListView` while keeping the grid
/// layout concerns explicit through a required `gridDelegate`.
///
/// When `header`, `footer`, or `paginationWidget` are supplied, they are
/// rendered as full-width slivers before or after the grid content rather than
/// being forced into grid cells.
class MyGridView<T> extends StatelessWidget {
  const MyGridView({
    required List<T> items,
    required MyGridViewBuilder<T> itemBuilder,
    required SliverGridDelegate gridDelegate,
    super.key,
    Widget? header,
    Widget? footer,
    Widget? paginationWidget,
    EdgeInsetsGeometry? padding,
    ScrollPhysics? physics,
    bool shrinkWrap = false,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    ScrollController? controller,
    bool? primary,
    ChildIndexGetter? findChildIndexCallback,
    double? cacheExtent,
    int? semanticChildCount,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.manual,
    String? restorationId,
    Clip clipBehavior = Clip.hardEdge,
  }) : _items = items,
       _itemBuilder = itemBuilder,
       _gridDelegate = gridDelegate,
       _header = header,
       _footer = footer,
       _paginationWidget = paginationWidget,
       _padding = padding,
       _physics = physics,
       _shrinkWrap = shrinkWrap,
       _addAutomaticKeepAlives = addAutomaticKeepAlives,
       _addRepaintBoundaries = addRepaintBoundaries,
       _addSemanticIndexes = addSemanticIndexes,
       _scrollDirection = scrollDirection,
       _reverse = reverse,
       _controller = controller,
       _primary = primary,
       _findChildIndexCallback = findChildIndexCallback,
       _cacheExtent = cacheExtent,
       _semanticChildCount = semanticChildCount,
       _dragStartBehavior = dragStartBehavior,
       _keyboardDismissBehavior = keyboardDismissBehavior,
       _restorationId = restorationId,
       _clipBehavior = clipBehavior;

  final List<T> _items;
  final MyGridViewBuilder<T> _itemBuilder;
  final SliverGridDelegate _gridDelegate;
  final Widget? _header;
  final Widget? _footer;
  final Widget? _paginationWidget;

  final EdgeInsetsGeometry? _padding;
  final ScrollPhysics? _physics;
  final bool _shrinkWrap;
  final bool _addAutomaticKeepAlives;
  final bool _addRepaintBoundaries;
  final bool _addSemanticIndexes;
  final Axis _scrollDirection;
  final bool _reverse;
  final ScrollController? _controller;
  final bool? _primary;
  final ChildIndexGetter? _findChildIndexCallback;
  final double? _cacheExtent;
  final int? _semanticChildCount;
  final DragStartBehavior _dragStartBehavior;
  final ScrollViewKeyboardDismissBehavior _keyboardDismissBehavior;
  final String? _restorationId;
  final Clip _clipBehavior;

  @override
  Widget build(BuildContext context) {
    final items = _items;
    final header = _header;
    final footer = _footer;
    final paginationWidget = _paginationWidget;
    final scrollCacheExtent =
        _cacheExtent == null ? null : ScrollCacheExtent.pixels(_cacheExtent);

    final childrenDelegate = SliverChildBuilderDelegate(
      (context, index) => _itemBuilder(index, items[index]),
      childCount: items.length,
      addAutomaticKeepAlives: _addAutomaticKeepAlives,
      addRepaintBoundaries: _addRepaintBoundaries,
      addSemanticIndexes: _addSemanticIndexes,
      findChildIndexCallback: _findChildIndexCallback,
    );

    if (header == null && footer == null && paginationWidget == null) {
      return GridView.custom(
        padding: _padding,
        physics: _physics,
        shrinkWrap: _shrinkWrap,
        scrollDirection: _scrollDirection,
        reverse: _reverse,
        controller: _controller,
        primary: _primary,
        gridDelegate: _gridDelegate,
        childrenDelegate: childrenDelegate,
        scrollCacheExtent: scrollCacheExtent,
        semanticChildCount: _semanticChildCount,
        dragStartBehavior: _dragStartBehavior,
        keyboardDismissBehavior: _keyboardDismissBehavior,
        restorationId: _restorationId,
        clipBehavior: _clipBehavior,
      );
    }

    final slivers = <Widget>[
      if (header != null) SliverToBoxAdapter(child: header),
      SliverGrid(delegate: childrenDelegate, gridDelegate: _gridDelegate),
      if (paginationWidget != null) SliverToBoxAdapter(child: paginationWidget),
      if (footer != null) SliverToBoxAdapter(child: footer),
    ];

    final Widget scrollBody =
        _padding == null
            ? SliverMainAxisGroup(slivers: slivers)
            : SliverPadding(
              padding: _padding,
              sliver: SliverMainAxisGroup(slivers: slivers),
            );

    return CustomScrollView(
      physics: _physics,
      shrinkWrap: _shrinkWrap,
      scrollDirection: _scrollDirection,
      reverse: _reverse,
      controller: _controller,
      primary: _primary,
      scrollCacheExtent: scrollCacheExtent,
      semanticChildCount: _semanticChildCount,
      dragStartBehavior: _dragStartBehavior,
      keyboardDismissBehavior: _keyboardDismissBehavior,
      restorationId: _restorationId,
      clipBehavior: _clipBehavior,
      slivers: [scrollBody],
    );
  }
}
