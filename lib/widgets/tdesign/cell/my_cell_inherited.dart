import 'package:flutter/cupertino.dart';

import 'my_cell_style.dart';

class MyCellInherited extends InheritedWidget {
  const MyCellInherited({required super.child, required this.style, super.key});

  final MyCellStyle style;

  @override
  bool updateShouldNotify(covariant MyCellInherited oldWidget) {
    return true;
  }

  static MyCellInherited? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MyCellInherited>();
  }
}
