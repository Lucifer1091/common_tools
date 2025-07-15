import 'package:flutter/cupertino.dart';

import 'td_cell_style.dart';

class TDCellInherited extends InheritedWidget {
  const TDCellInherited({required super.child, required this.style, super.key});

  final TDCellStyle style;

  @override
  bool updateShouldNotify(covariant TDCellInherited oldWidget) {
    return true;
  }

  static TDCellInherited? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TDCellInherited>();
  }
}
