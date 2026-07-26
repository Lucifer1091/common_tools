import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart'
    show ItemExtentBuilder, ScrollCacheExtent;

typedef MyListViewBuilder<T> = Widget Function(int index, T item);

/// A type-safe ListView that allows for easy customization with headers,
/// footers, separators, and pagination.
///
/// This widget extends Flutter's `ListView.builder` and provides a convenient
/// way to build lists with optional headers, footers, separators, and a
/// pagination widget.
///
/// The `itemBuilder` is a required parameter that takes the current index and
/// item as arguments and returns a widget to be displayed at that position.
///
/// The `header`, `footer`, and `paginationWidget` parameters are optional and
/// allow you to add widgets at the beginning, end, or after the list items
/// and before the footer, respectively.
///
/// The `separatorBuilder` parameter is also optional and allows you to add
/// separators between items in the list.
///
/// If you need keyed child reordering, prefer `findItemIndexCallback`. It maps
/// your data-item index back to the correct visible child index even when
/// headers or separators are enabled.
///
/// Example usage:
/// ```dart
/// MyListView<String>(
///   items: ['Item 1', 'Item 2', 'Item 3'],
///   itemBuilder: (index, item) => ListTile(title: Text(item)),
///   header: const Text('Header'),
///   footer: const Text('Footer'),
///   separatorBuilder: (context, index) => const Divider(),
///   paginationWidget: const CircularProgressIndicator(),
/// )
/// ```
class MyListView<T> extends StatelessWidget {
  const MyListView({
    required this._items,
    required this._itemBuilder,
    super.key,
    this._header,
    this._footer,
    this._separatorBuilder,
    this._paginationWidget,
    this._padding,
    this._physics,
    this._shrinkWrap = false,
    this._addAutomaticKeepAlives = true,
    this._addRepaintBoundaries = true,
    this._addSemanticIndexes = true,
    this._scrollDirection = Axis.vertical,
    this._reverse = false,
    this._controller,
    this._primary,
    double? itemExtent,
    ItemExtentBuilder? itemExtentBuilder,
    Widget? prototypeItem,
    this._findItemIndexCallback,
    this._cacheExtent,
    this._semanticChildCount,
    this._dragStartBehavior = DragStartBehavior.start,
    this._keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this._restorationId,
    this._clipBehavior = Clip.hardEdge,
  }) : assert(
         (itemExtent == null && prototypeItem == null) ||
             (itemExtent == null && itemExtentBuilder == null) ||
             (prototypeItem == null && itemExtentBuilder == null),
         'You can only pass one of itemExtent, prototypeItem and itemExtentBuilder.',
       ),
       _itemExtent = itemExtent,
       _itemExtentBuilder = itemExtentBuilder,
       _prototypeItem = prototypeItem;

  final List<T> _items;
  final MyListViewBuilder<T> _itemBuilder;
  final Widget? _header;
  final Widget? _footer;
  final IndexedWidgetBuilder? _separatorBuilder;
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
  final double? _itemExtent;
  final ItemExtentBuilder? _itemExtentBuilder;
  final Widget? _prototypeItem;
  final ChildIndexGetter? _findItemIndexCallback;
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
    final separatorBuilder = _separatorBuilder;
    final paginationWidget = _paginationWidget;
    final hasHeader = header != null;
    final hasFooter = footer != null;
    final hasPagination = paginationWidget != null;
    final hasSeparators = separatorBuilder != null && items.length > 1;
    final headerOffset = hasHeader ? 1 : 0;
    final footerOffset = hasFooter ? 1 : 0;
    final paginationOffset = hasPagination ? 1 : 0;
    final separatorCount = hasSeparators ? items.length - 1 : 0;
    final effectiveFindChildIndexCallback = _resolveFindChildIndexCallback(
      itemCount: items.length,
      headerOffset: headerOffset,
      hasSeparators: hasSeparators,
      findItemIndexCallback: _findItemIndexCallback,
    );
    final scrollCacheExtent = _cacheExtent == null
        ? null
        : ScrollCacheExtent.pixels(_cacheExtent);
    final totalItemCount =
        headerOffset +
        items.length +
        separatorCount +
        paginationOffset +
        footerOffset;

    if (!hasHeader && !hasFooter && !hasPagination && !hasSeparators) {
      return ListView.builder(
        padding: _padding,
        physics: _physics,
        shrinkWrap: _shrinkWrap,
        itemCount: items.length,
        itemBuilder: (context, index) => _itemBuilder(index, items[index]),
        addAutomaticKeepAlives: _addAutomaticKeepAlives,
        addRepaintBoundaries: _addRepaintBoundaries,
        addSemanticIndexes: _addSemanticIndexes,
        scrollDirection: _scrollDirection,
        reverse: _reverse,
        controller: _controller,
        primary: _primary,
        itemExtent: _itemExtent,
        itemExtentBuilder: _itemExtentBuilder,
        prototypeItem: _prototypeItem,
        findChildIndexCallback: effectiveFindChildIndexCallback,
        scrollCacheExtent: scrollCacheExtent,
        semanticChildCount: _semanticChildCount,
        dragStartBehavior: _dragStartBehavior,
        keyboardDismissBehavior: _keyboardDismissBehavior,
        restorationId: _restorationId,
        clipBehavior: _clipBehavior,
      );
    }

    return ListView.builder(
      padding: _padding,
      physics: _physics,
      shrinkWrap: _shrinkWrap,
      itemCount: totalItemCount,
      itemBuilder: (context, index) => _buildItem(
        context,
        index,
        items: items,
        itemBuilder: _itemBuilder,
        header: header,
        footer: footer,
        separatorBuilder: separatorBuilder,
        paginationWidget: paginationWidget,
        headerOffset: headerOffset,
        footerOffset: footerOffset,
        totalItemCount: totalItemCount,
      ),
      addAutomaticKeepAlives: _addAutomaticKeepAlives,
      addRepaintBoundaries: _addRepaintBoundaries,
      addSemanticIndexes: _addSemanticIndexes,
      scrollDirection: _scrollDirection,
      reverse: _reverse,
      controller: _controller,
      primary: _primary,
      itemExtent: _itemExtent,
      itemExtentBuilder: _itemExtentBuilder,
      prototypeItem: _prototypeItem,
      findChildIndexCallback: effectiveFindChildIndexCallback,
      scrollCacheExtent: scrollCacheExtent,
      semanticChildCount: _semanticChildCount,
      dragStartBehavior: _dragStartBehavior,
      keyboardDismissBehavior: _keyboardDismissBehavior,
      restorationId: _restorationId,
      clipBehavior: _clipBehavior,
    );
  }

  /// Builds the appropriate widget for the given index, handling headers,
  /// footers, separators, and pagination widgets.
  static Widget _buildItem<T>(
    BuildContext context,
    int index, {
    required List<T> items,
    required MyListViewBuilder<T> itemBuilder,
    required int headerOffset,
    required int footerOffset,
    required int totalItemCount,
    Widget? header,
    Widget? footer,
    IndexedWidgetBuilder? separatorBuilder,
    Widget? paginationWidget,
  }) {
    // Handle header
    if (header != null && index == 0) return header;

    // Handle footer
    if (footer != null && index == totalItemCount - 1) {
      return footer;
    }

    // Handle paginationWidget
    if (paginationWidget != null &&
        index == totalItemCount - footerOffset - 1) {
      return paginationWidget;
    }

    // Adjust index for header
    var adjustedIndex = index - headerOffset;

    // Handle separators
    if (separatorBuilder != null && items.length > 1) {
      if (adjustedIndex.isOdd) {
        // This is a separator
        return separatorBuilder(context, adjustedIndex ~/ 2);
      }
      // This is an item
      adjustedIndex = adjustedIndex ~/ 2;
    }

    // Build item
    if (adjustedIndex >= 0 && adjustedIndex < items.length) {
      return itemBuilder(adjustedIndex, items[adjustedIndex]);
    }

    // This should be unreachable when itemCount math is correct.
    return const SizedBox.shrink();
  }

  static ChildIndexGetter? _resolveFindChildIndexCallback({
    required int itemCount,
    required int headerOffset,
    required bool hasSeparators,
    ChildIndexGetter? findItemIndexCallback,
  }) {
    if (findItemIndexCallback != null) {
      return (Key key) {
        final itemIndex = findItemIndexCallback(key);
        if (itemIndex == null || itemIndex < 0 || itemIndex >= itemCount) {
          return null;
        }
        return headerOffset + (hasSeparators ? itemIndex * 2 : itemIndex);
      };
    }
    return null;
  }
}
