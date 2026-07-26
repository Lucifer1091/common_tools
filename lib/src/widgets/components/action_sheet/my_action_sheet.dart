import 'dart:async';

import 'package:flutter/material.dart';

import '../popup/my_popup_route.dart';
import 'my_action_sheet.dart';
import 'my_action_sheet_grid.dart';
import 'my_action_sheet_group.dart';
import 'my_action_sheet_list.dart';

export 'my_action_sheet_item.dart';

typedef MyActionSheetItemCallback =
    void Function(ActionSheetItem item, int index);

enum MyActionSheetTheme { list, grid, group }

enum MyActionSheetAlign { center, left, right }

class MyActionSheet {
  MyActionSheet(
    this.context, {
    required this.items,
    this.align = MyActionSheetAlign.center,
    this.cancelText = 'Cancel',
    this.count = 8,
    this.rows = 2,
    this.itemHeight = 96.0,
    this.itemMinWidth = 80.0,
    this.description,
    this.showCancel = true,
    this.showPagination = false,
    this.scrollable = false,
    this.theme = MyActionSheetTheme.list,
    this.visible = false,
    this.onCancel,
    this.onClose,
    this.onSelected,
    this.showOverlay = true,
    this.closeOnOverlayClick = true,
    this.useSafeArea = true,
  }) {
    if (visible) show();
  }

  final BuildContext context;

  final MyActionSheetAlign align;

  final String cancelText;

  /// Number of items displayed per page
  /// Valid when [theme] equals [MyActionSheetTheme.grid] and [showPagination] is true
  final int count;

  /// Number of rows displayed
  /// Valid when [theme] equals [MyActionSheetTheme.grid]
  final int rows;

  /// Row height of items
  /// Valid when [theme] equals [MyActionSheetTheme.grid] or [theme] equals [MyActionSheetTheme.group]
  final double itemHeight;

  /// Minimum width of items
  /// Valid when [theme] equals [MyActionSheetTheme.grid] and [scrollable] is true
  /// Or valid when [theme] equals [MyActionSheetTheme.group]
  final double itemMinWidth;

  /// Description text
  /// This is valid when [theme] equals [MyActionSheetTheme.grid] or [theme] equals [MyActionSheetTheme.list].
  final String? description;

  final List<ActionSheetItem> items;

  final bool showCancel;

  final bool showOverlay;

  final bool closeOnOverlayClick;

  final MyActionSheetTheme theme;

  final bool visible;

  /// Whether to display pagination
  /// Effective when [theme] equals [MyActionSheetTheme.grid]
  final bool showPagination;

  /// Whether to allow horizontal scrolling
  /// Effective when [theme] equals [MyActionSheetTheme.grid] and [showPagination] is false
  final bool scrollable;

  final VoidCallback? onCancel;

  final VoidCallback? onClose;

  final MyActionSheetItemCallback? onSelected;

  final bool useSafeArea;

  static MySlidePopupRoute<void>? _actionSheetRoute;

  static void showListActionSheet(
    BuildContext context, {
    required List<ActionSheetItem> items,
    MyActionSheetAlign align = MyActionSheetAlign.center,
    String cancelText = 'Cancel',
    bool showCancel = true,
    VoidCallback? onCancel,
    MyActionSheetItemCallback? onSelected,
    bool showOverlay = true,
    bool closeOnOverlayClick = true,
    VoidCallback? onClose,
    bool useSafeArea = true,
  }) {
    _createRoute(
      context,
      theme: MyActionSheetTheme.list,
      items: items,
      align: align,
      cancelText: cancelText,
      showCancel: showCancel,
      onSelected: onSelected,
      onCancel: onCancel,
      showOverlay: showOverlay,
      closeOnOverlayClick: closeOnOverlayClick,
      onClose: onClose,
      useSafeArea: useSafeArea,
    );
  }

  static void showGridActionSheet(
    BuildContext context, {
    required List<ActionSheetItem> items,
    MyActionSheetAlign align = MyActionSheetAlign.center,
    String cancelText = 'Cancel',
    bool showCancel = true,
    MyActionSheetItemCallback? onSelected,
    bool showOverlay = true,
    bool closeOnOverlayClick = true,
    int count = 8,
    int rows = 2,
    double itemHeight = 96.0,
    double itemMinWidth = 80.0,
    bool scrollable = false,
    bool showPagination = false,
    VoidCallback? onCancel,
    String? description,
    VoidCallback? onClose,
    bool useSafeArea = true,
  }) {
    _createRoute(
      context,
      theme: MyActionSheetTheme.grid,
      items: items,
      align: align,
      cancelText: cancelText,
      showCancel: showCancel,
      onSelected: onSelected,
      onCancel: onCancel,
      showOverlay: showOverlay,
      closeOnOverlayClick: closeOnOverlayClick,
      count: count,
      rows: rows,
      itemHeight: itemHeight,
      itemMinWidth: itemMinWidth,
      scrollable: scrollable,
      showPagination: showPagination,
      description: description,
      onClose: onClose,
      useSafeArea: useSafeArea,
    );
  }

  static void showGroupActionSheet(
    BuildContext context, {
    required List<ActionSheetItem> items,
    MyActionSheetAlign align = MyActionSheetAlign.left,
    String cancelText = 'Cancel',
    bool showCancel = true,
    MyActionSheetItemCallback? onSelected,
    bool showOverlay = true,
    bool closeOnOverlayClick = true,
    double itemHeight = 96.0,
    double itemMinWidth = 80.0,
    VoidCallback? onCancel,
    VoidCallback? onClose,
    bool useSafeArea = true,
  }) {
    _createRoute(
      context,
      theme: MyActionSheetTheme.group,
      items: items,
      align: align,
      cancelText: cancelText,
      showCancel: showCancel,
      onSelected: onSelected,
      onCancel: onCancel,
      showOverlay: showOverlay,
      closeOnOverlayClick: closeOnOverlayClick,
      itemHeight: itemHeight,
      itemMinWidth: itemMinWidth,
      onClose: onClose,
      useSafeArea: useSafeArea,
    );
  }

  void show() {
    MyActionSheet._createRoute(
      context,
      theme: theme,
      items: items,
      align: align,
      cancelText: cancelText,
      showCancel: showCancel,
      onSelected: onSelected,
      onCancel: onCancel,
      showOverlay: showOverlay,
      closeOnOverlayClick: closeOnOverlayClick,
      count: count,
      rows: rows,
      itemHeight: itemHeight,
      itemMinWidth: itemMinWidth,
      scrollable: scrollable,
      showPagination: showPagination,
      description: description,
      onClose: onClose,
      useSafeArea: useSafeArea,
    );
  }

  void open() => show();

  @mustCallSuper
  void close() {
    if (_actionSheetRoute != null) {
      Navigator.of(context).pop();
    }
  }

  static void _createRoute(
    BuildContext context, {
    required MyActionSheetTheme theme,
    required List<ActionSheetItem> items,
    MyActionSheetAlign align = MyActionSheetAlign.center,
    String cancelText = 'Cancel',
    bool showCancel = true,
    MyActionSheetItemCallback? onSelected,
    bool showOverlay = true,
    bool closeOnOverlayClick = true,
    int count = 8,
    int rows = 2,
    double itemHeight = 96.0,
    double itemMinWidth = 80.0,
    bool scrollable = false,
    bool showPagination = false,
    VoidCallback? onCancel,
    String? description,
    VoidCallback? onClose,
    bool useSafeArea = true,
  }) {
    if (_actionSheetRoute != null) return;

    _actionSheetRoute = MySlidePopupRoute(
      isDismissible: showOverlay && closeOnOverlayClick,
      modalBarrierColor: showOverlay ? null : Colors.transparent,
      builder: (context) {
        switch (theme) {
          case MyActionSheetTheme.list:
            return MyActionSheetList(
              items: items,
              align: align,
              cancelText: cancelText,
              description: description,
              showCancel: showCancel,
              onCancel: onCancel,
              onSelected: onSelected,
              useSafeArea: useSafeArea,
            );
          case MyActionSheetTheme.grid:
            return MyActionSheetGrid(
              items: items,
              align: align,
              onSelected: onSelected,
              showCancel: showCancel,
              showPagination: showPagination,
              scrollable: scrollable,
              cancelText: cancelText,
              description: description,
              count: count,
              rows: rows,
              onCancel: onCancel,
              itemHeight: itemHeight,
              itemMinWidth: itemMinWidth,
              useSafeArea: useSafeArea,
            );
          case MyActionSheetTheme.group:
            return MyActionSheetGroup(
              items: items,
              align: align,
              cancelText: cancelText,
              showCancel: showCancel,
              onCancel: onCancel,
              onSelected: onSelected,
              itemHeight: itemHeight,
              itemMinWidth: itemMinWidth,
              useSafeArea: useSafeArea,
            );
        }
      },
    );
    unawaited(
      Navigator.of(context).push(_actionSheetRoute!).then((_) {
        _actionSheetRoute = null;
        onClose?.call();
      }),
    );
  }
}
