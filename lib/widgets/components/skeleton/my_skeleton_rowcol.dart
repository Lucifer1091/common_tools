import 'package:flutter/material.dart';

import '../../../index.dart';

class MySkeletonRowColStyle {
  const MySkeletonRowColStyle({this.rowSpacing = _defaultRowSpacing});

  final double Function(BuildContext) rowSpacing;

  static double _defaultRowSpacing(BuildContext context) => 16;
}

class MySkeletonRowCol {
  MySkeletonRowCol({
    required this.objects,
    this.style = const MySkeletonRowColStyle(),
  }) : assert(objects.isNotEmpty && objects.every((row) => row.isNotEmpty), '');

  final List<List<MySkeletonRowColObj>> objects;

  final MySkeletonRowColStyle style;

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

class MySkeletonRowColObjStyle {
  const MySkeletonRowColObjStyle({
    this.background = _defaultBackground,
    this.borderRadius = _textBorderRadius,
  });

  const MySkeletonRowColObjStyle.circle({this.background = _defaultBackground})
    : borderRadius = _circleBorderRadius;

  const MySkeletonRowColObjStyle.rect({this.background = _defaultBackground})
    : borderRadius = _rectBorderRadius;

  const MySkeletonRowColObjStyle.text({this.background = _defaultBackground})
    : borderRadius = _textBorderRadius;

  const MySkeletonRowColObjStyle.spacer()
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

class MySkeletonRowColObj {
  const MySkeletonRowColObj({
    this.width,
    this.height = 16,
    this.flex = 1,
    this.margin = EdgeInsets.zero,
    this.style = const MySkeletonRowColObjStyle(),
  });

  const MySkeletonRowColObj.circle({
    this.width = 48,
    this.height = 48,
    this.flex,
    this.margin = EdgeInsets.zero,
    this.style = const MySkeletonRowColObjStyle.circle(),
  });

  const MySkeletonRowColObj.rect({
    this.width,
    this.height = 16,
    this.flex = 1,
    this.margin = EdgeInsets.zero,
    this.style = const MySkeletonRowColObjStyle.rect(),
  });

  const MySkeletonRowColObj.text({
    this.width,
    this.height = 16,
    this.flex = 1,
    this.margin = EdgeInsets.zero,
    this.style = const MySkeletonRowColObjStyle.text(),
  });

  const MySkeletonRowColObj.spacer({
    this.width,
    this.height,
    this.flex,
    this.margin = EdgeInsets.zero,
  }) : style = const MySkeletonRowColObjStyle.spacer();

  final double? width;
  final double? height;
  final int? flex;
  final EdgeInsets margin;
  final MySkeletonRowColObjStyle style;
  double get visualHeight => (height ?? 0) + margin.top + margin.bottom;
}
