import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

class SliverGridWithReorderablePosDelegate extends SliverGrid {
  const SliverGridWithReorderablePosDelegate({
    required super.delegate,
    required super.gridDelegate,
    super.key,
  });

  SliverGridWithReorderablePosDelegate.count({
    required int crossAxisCount,
    Key? key,
    double mainAxisSpacing = 0.0,
    double crossAxisSpacing = 0.0,
    double childAspectRatio = 1.0,
    List<Widget> children = const <Widget>[],
  }) : this(
         key: key,
         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
           crossAxisCount: crossAxisCount,
           mainAxisSpacing: mainAxisSpacing,
           crossAxisSpacing: crossAxisSpacing,
           childAspectRatio: childAspectRatio,
         ),
         delegate: SliverChildListDelegate(children),
       );
}
