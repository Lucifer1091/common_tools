import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'td_swipe_cell_action.dart';

class TDSwipeCellInherited extends InheritedWidget {
  const TDSwipeCellInherited({
    required super.child,
    required this.cellClick,
    required this.actionClick,
    required this.duration,
    required this.controller,
    super.key,
  });

  final Duration duration;
  final void Function() cellClick;
  final bool Function(TDSwipeCellAction action) actionClick;
  final SlidableController controller;

  @override
  bool updateShouldNotify(covariant TDSwipeCellInherited oldWidget) {
    return true;
  }

  static TDSwipeCellInherited? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TDSwipeCellInherited>();
  }
}
