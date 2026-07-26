import 'package:flutter/material.dart';
import 'widgets/gap.dart';
import 'widgets/sliver_gap.dart';

extension GapPackageListExtension<T extends Widget> on List<T> {
  /// Inserts a [Gap] between each widget in the list.
  List<Widget> gap(
    double mainAxisExtent, {
    double? crossAxisExtent,
    Color? color,
    Axis? direction,
  }) {
    return _gap(
      mainAxisExtent,
      crossAxisExtent: crossAxisExtent,
      color: color,
      direction: direction,
    ).toList();
  }

  Iterable<Widget> _gap(
    double mainAxisExtent, {
    double? crossAxisExtent,
    Color? color,
    Axis? direction,
  }) sync* {
    final maxIndex = length - 1;
    for (var i = 0; i <= maxIndex; i++) {
      yield elementAt(i);
      if (i != maxIndex) {
        yield Gap(
          mainAxisExtent,
          crossAxisExtent: crossAxisExtent,
          color: color,
          direction: direction,
        );
      }
    }
  }
}

extension SliverGapPackageListExtension<T extends Widget> on List<T> {
  /// Inserts a [SliverGap] between each sliver in the list.
  List<Widget> sliverGap(double mainAxisExtent, {Color? color}) {
    return _sliverGap(mainAxisExtent, color: color).toList();
  }

  Iterable<Widget> _sliverGap(double mainAxisExtent, {Color? color}) sync* {
    final maxIndex = length - 1;
    for (var i = 0; i <= maxIndex; i++) {
      yield elementAt(i);
      if (i != maxIndex) {
        yield SliverGap(mainAxisExtent, color: color);
      }
    }
  }
}
