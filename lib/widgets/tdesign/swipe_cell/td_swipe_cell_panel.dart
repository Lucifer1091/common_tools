import 'package:flutter/material.dart';

import 'td_swipe_cell.dart';
import 'td_swipe_cell_action.dart';

enum SwipeMotion { scroll, behind, drawer, stretch }

class TDSwipeCellPanel {
  TDSwipeCellPanel({
    required this.children,
    this.extentRatio = 0.3,
    this.openThreshold,
    this.closeThreshold,
    this.motionType,
    this.dragDismissible = false,
    this.dismissThreshold = 0.75,
    this.dismissalDuration = const Duration(milliseconds: 300),
    this.resizeDuration = const Duration(milliseconds: 300),
    this.closeOnCancel = false,
    this.confirmDismiss,
    this.onDismissed,
    this.confirms,
  }) : assert(
         confirms == null ||
             confirms.every(
               (item) =>
                   item.confirmIndex != null &&
                   item.confirmIndex!.every(
                     (index) => index >= 0 && index < children.length,
                   ),
             ),
         'Confirms must have a confirmIndex, '
         'and each confirmIndex in confirms must be within the range of children indices.',
       );

  final double? extentRatio;

  /// How much dragging ratio triggers the opening action, the default is half of [extentRatio]
  final double? openThreshold;

  /// How much dragging ratio triggers the close action, the default is half of [extentRatio]
  final double? closeThreshold;

  final SwipeMotion? motionType;

  final List<TDSwipeCellAction> children;

  final List<TDSwipeCellAction>? confirms;

  /// Whether the [TDSwipeCell] component can be removed by dragging
  final bool? dragDismissible;

  final double? dismissThreshold;

  final Duration? dismissalDuration;

  final Duration? resizeDuration;

  final bool? closeOnCancel;

  final Future<bool> Function(BuildContext context)? confirmDismiss;

  final void Function(BuildContext context)? onDismissed;

  Duration get _dismissalDuration =>
      dismissalDuration ?? const Duration(milliseconds: 300);

  Duration get _resizeDuration =>
      resizeDuration ?? const Duration(milliseconds: 300);

  bool get _dragDismissible => dragDismissible ?? false;

  double get _extentRatio => extentRatio ?? 0.3;

  double get _openThreshold => openThreshold ?? (_extentRatio / 2);

  double get _closeThreshold => closeThreshold ?? (_extentRatio / 2);

  ActionPane build(BuildContext context) {
    return ActionPane(
      extentRatio: _extentRatio,
      motion: getMotionWidget(),
      openThreshold: _openThreshold,
      closeThreshold: _closeThreshold,
      dragDismissible: _dragDismissible,
      dismissible:
          _dragDismissible
              ? DismissiblePane(
                closeOnCancel: closeOnCancel ?? false,
                dismissThreshold: dismissThreshold ?? 0.75,
                dismissalDuration: _dismissalDuration,
                resizeDuration: _resizeDuration,
                confirmDismiss: () async {
                  return confirmDismiss?.call(context) ?? false;
                },
                onDismissed: () async {
                  await TDSwipeCell.of(context)?.close();
                  onDismissed?.call(context);
                },
              )
              : null,
      children: children,
    );
  }

  Widget getMotionWidget() {
    switch (motionType) {
      case SwipeMotion.scroll:
        return const ScrollMotion();
      case SwipeMotion.behind:
        return const BehindMotion();
      case SwipeMotion.drawer:
        return const DrawerMotion();
      case SwipeMotion.stretch:
        return const StretchMotion();
      case null:
        return const ScrollMotion();
    }
  }
}
