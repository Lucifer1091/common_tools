import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../extensions/context/theme.dart';
import '../../../themes/my_theme.dart';
import './my_skeleton.dart';

@immutable
class MySkeletonStyle {
  const MySkeletonStyle({
    this.duration = const Duration(milliseconds: 1500),
    this.curve = Curves.linear,
    this.direction = MySkeletonDirection.ltr,
    this.enabled = true,
    this.lightColors = _defaultLightColors,
    this.darkColors = _defaultDarkColors,
    this.stops = _defaultStops,
  });

  static const List<Color> _defaultLightColors = <Color>[
    Color.fromRGBO(0, 0, 0, 0.1),
    Color.fromRGBO(0, 0, 0, 0.1),
    Color(0x44CCCCCC),
    Color.fromRGBO(0, 0, 0, 0.1),
    Color.fromRGBO(0, 0, 0, 0.1),
  ];

  static const List<Color> _defaultDarkColors = <Color>[
    Color(0xff2A2C2E),
    Color(0xff2A2C2E),
    Color(0xff3A3E3F),
    Color(0xff2A2C2E),
    Color(0xff2A2C2E),
  ];

  static const List<double> _defaultStops = <double>[0, 0.35, 0.5, 0.65, 1];

  final Duration duration;
  final Curve curve;
  final MySkeletonDirection direction;
  final bool enabled;
  final List<Color> lightColors;
  final List<Color> darkColors;
  final List<double> stops;

  List<Color> resolveColors(BuildContext context) {
    final brightness = MyTheme.of(context).brightness;
    return brightness == Brightness.dark ? darkColors : lightColors;
  }

  MySkeletonStyle copyWith({
    Duration? duration,
    Curve? curve,
    MySkeletonDirection? direction,
    bool? enabled,
    List<Color>? lightColors,
    List<Color>? darkColors,
    List<double>? stops,
  }) {
    return MySkeletonStyle(
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
      direction: direction ?? this.direction,
      enabled: enabled ?? this.enabled,
      lightColors: lightColors ?? this.lightColors,
      darkColors: darkColors ?? this.darkColors,
      stops: stops ?? this.stops,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MySkeletonStyle &&
          duration == other.duration &&
          curve == other.curve &&
          direction == other.direction &&
          enabled == other.enabled &&
          listEquals(lightColors, other.lightColors) &&
          listEquals(darkColors, other.darkColors) &&
          listEquals(stops, other.stops);

  @override
  int get hashCode =>
      duration.hashCode ^
      curve.hashCode ^
      direction.hashCode ^
      enabled.hashCode ^
      Object.hashAll(lightColors) ^
      Object.hashAll(darkColors) ^
      Object.hashAll(stops);
}

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

  final List<List<MySkeletonItem>> objects;

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

class MySkeletonItemStyle {
  const MySkeletonItemStyle({
    this.background = _defaultBackground,
    this.borderRadius = _textBorderRadius,
  });

  const MySkeletonItemStyle.circle({this.background = _defaultBackground})
    : borderRadius = _circleBorderRadius;

  const MySkeletonItemStyle.rect({this.background = _defaultBackground})
    : borderRadius = _rectBorderRadius;

  const MySkeletonItemStyle.text({this.background = _defaultBackground})
    : borderRadius = _textBorderRadius;

  const MySkeletonItemStyle.spacer()
    : background = _transparentBackground,
      borderRadius = _textBorderRadius;

  final Color Function(BuildContext) background;

  final double Function(BuildContext) borderRadius;

  static Color _defaultBackground(BuildContext context) =>
      context.colorScheme.secondary;

  static Color _transparentBackground(BuildContext context) =>
      Colors.transparent;

  static double _circleBorderRadius(BuildContext context) => 9999;

  static double _rectBorderRadius(BuildContext context) => 6;

  static double _textBorderRadius(BuildContext context) => 3;
}

class MySkeletonItem {
  const MySkeletonItem({
    this.width,
    this.height = 16,
    this.flex = 1,
    this.margin = EdgeInsets.zero,
    this.style = const MySkeletonItemStyle(),
  });

  const MySkeletonItem.circle({
    this.width = 48,
    this.height = 48,
    this.flex,
    this.margin = EdgeInsets.zero,
    this.style = const MySkeletonItemStyle.circle(),
  });

  const MySkeletonItem.rect({
    this.width,
    this.height = 16,
    this.flex = 1,
    this.margin = EdgeInsets.zero,
    this.style = const MySkeletonItemStyle.rect(),
  });

  const MySkeletonItem.text({
    this.width,
    this.height = 16,
    this.flex = 1,
    this.margin = EdgeInsets.zero,
    this.style = const MySkeletonItemStyle.text(),
  });

  const MySkeletonItem.spacer({
    this.width,
    this.height,
    this.flex,
    this.margin = EdgeInsets.zero,
  }) : style = const MySkeletonItemStyle.spacer();

  final double? width;
  final double? height;
  final int? flex;
  final EdgeInsets margin;
  final MySkeletonItemStyle style;
  double get visualHeight => (height ?? 0) + margin.top + margin.bottom;
}
