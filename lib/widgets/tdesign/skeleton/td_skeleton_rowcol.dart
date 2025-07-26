import 'package:flutter/material.dart';

import '../../../common_tools.dart';

class TDSkeletonRowColStyle {
  const TDSkeletonRowColStyle({this.rowSpacing = _defaultRowSpacing});

  final double Function(BuildContext) rowSpacing;

  static double _defaultRowSpacing(BuildContext context) => 16;
}

class TDSkeletonRowCol {
  TDSkeletonRowCol({
    required this.objects,
    this.style = const TDSkeletonRowColStyle(),
  }) : assert(objects.isNotEmpty && objects.every((row) => row.isNotEmpty), '');

  final List<List<TDSkeletonRowColObj>> objects;

  final TDSkeletonRowColStyle style;

  double visualHeight(BuildContext context) {
    var rowSpacing = style.rowSpacing(context);
    assert(rowSpacing >= 0, '');

    if (rowSpacing < 0) rowSpacing = 0;

    return objects
            .map(
              (row) => row.fold<num>(
                0,
                (a, b) => a > b.visualHeight ? a : b.visualHeight,
              ),
            )
            .fold<num>(0, (a, b) => a + b) +
        rowSpacing * (objects.length - 1);
  }
}

class TDSkeletonRowColObjStyle {
  const TDSkeletonRowColObjStyle({
    this.background = _defaultBackground,
    this.borderRadius = _textBorderRadius,
  });

  const TDSkeletonRowColObjStyle.circle({this.background = _defaultBackground})
    : borderRadius = _circleBorderRadius;

  const TDSkeletonRowColObjStyle.rect({this.background = _defaultBackground})
    : borderRadius = _rectBorderRadius;

  const TDSkeletonRowColObjStyle.text({this.background = _defaultBackground})
    : borderRadius = _textBorderRadius;

  const TDSkeletonRowColObjStyle.spacer()
    : background = _transparentBackground,
      borderRadius = _textBorderRadius;

  final Color Function(BuildContext) background;

  final double Function(BuildContext) borderRadius;

  static Color _defaultBackground(BuildContext context) =>
      ThemeColors.neutral.shade50;

  static Color _transparentBackground(BuildContext context) =>
      Colors.transparent;

  static double _circleBorderRadius(BuildContext context) => 9999;

  static double _rectBorderRadius(BuildContext context) => 6;

  static double _textBorderRadius(BuildContext context) => 3;
}

class TDSkeletonRowColObj {
  const TDSkeletonRowColObj({
    this.width,
    this.height = 16,
    this.flex = 1,
    this.margin = EdgeInsets.zero,
    this.style = const TDSkeletonRowColObjStyle(),
  });

  const TDSkeletonRowColObj.circle({
    this.width = 48,
    this.height = 48,
    this.flex,
    this.margin = EdgeInsets.zero,
    this.style = const TDSkeletonRowColObjStyle.circle(),
  });

  const TDSkeletonRowColObj.rect({
    this.width,
    this.height = 16,
    this.flex = 1,
    this.margin = EdgeInsets.zero,
    this.style = const TDSkeletonRowColObjStyle.rect(),
  });

  const TDSkeletonRowColObj.text({
    this.width,
    this.height = 16,
    this.flex = 1,
    this.margin = EdgeInsets.zero,
    this.style = const TDSkeletonRowColObjStyle.text(),
  });

  const TDSkeletonRowColObj.spacer({
    this.width,
    this.height,
    this.flex,
    this.margin = EdgeInsets.zero,
  }) : style = const TDSkeletonRowColObjStyle.spacer();

  final double? width;

  final double? height;

  final int? flex;

  final EdgeInsets margin;

  final TDSkeletonRowColObjStyle style;

  double get visualHeight => (height ?? 0) + margin.top + margin.bottom;
}
