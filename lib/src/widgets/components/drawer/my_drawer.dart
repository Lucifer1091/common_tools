import 'dart:async';

import 'package:flutter/material.dart';

import '../../../extensions/misc/bool.dart';
import '../cell/my_cell_style.dart';
import '../popup/my_popup_route.dart';
import './my_drawer_widget.dart';

enum MyDrawerPlacement { left, right }

class MyDrawer {
  MyDrawer(
    this.context, {
    this.closeOnOverlayClick = true,
    this.footer,
    this.items,
    this.placement = MyDrawerPlacement.right,
    this.showOverlay = true,
    this.title,
    this.titleWidget,
    this.visible,
    this.onClose,
    this.onItemTap,
    this.width = 280,
    this.drawerTop,
    this.style,
    this.hover = true,
    this.backgroundColor,
    this.bordered = true,
    this.showLastBorder = true,
    this.content,
  }) {
    if (visible.getOr()) show();
  }

  final BuildContext context;

  final bool? closeOnOverlayClick;

  final Widget? footer;

  final List<MyDrawerItem>? items;

  /// Custom content has higher priority than [items]/[footer]/[title]
  final Widget? content;

  final MyDrawerPlacement? placement;

  final bool? showOverlay;

  final String? title;

  final Widget? titleWidget;

  final bool? visible;

  final VoidCallback? onClose;

  final OnTapMyDrawerItem? onItemTap;

  final double? width;

  /// The distance from the top
  final double? drawerTop;

  /// The custom style for the list
  final MyCellStyle? style;

  final bool hover;

  final Color? backgroundColor;

  final bool? bordered;

  final bool? showLastBorder;

  MySlidePopupRoute<void>? _drawerRoute;

  void show() {
    // If the drawer is already shown, don't show it again
    if (_drawerRoute != null) return;

    _drawerRoute = MySlidePopupRoute(
      slideTransitionFrom: placement == MyDrawerPlacement.right
          ? MySlideFrom.right
          : MySlideFrom.left,
      isDismissible: (showOverlay ?? true) && (closeOnOverlayClick ?? true),
      modalBarrierColor: (showOverlay ?? true) ? null : Colors.transparent,
      modalTop: drawerTop,
      builder: (context) {
        return MyDrawerWidget(
          footer: footer,
          items: items,
          content: content,
          title: title,
          titleWidget: titleWidget,
          onItemTap: onItemTap,
          width: width,
          style: style,
          hover: hover,
          backgroundColor: backgroundColor,
          bordered: bordered,
          showLastBorder: showLastBorder,
        );
      },
    );

    unawaited(
      Navigator.of(context).push(_drawerRoute!).then((_) {
        // When the drawer is closed, set _drawerRoute to null
        _deleteRouter();
      }),
    );
  }

  void open() => show();

  @mustCallSuper
  void close() {
    if (_drawerRoute != null) {
      Navigator.of(context).pop();
      _deleteRouter();
    }
  }

  void _deleteRouter() {
    _drawerRoute = null;
    onClose?.call();
  }
}
