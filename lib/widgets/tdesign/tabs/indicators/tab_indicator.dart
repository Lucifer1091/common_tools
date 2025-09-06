import 'package:flutter/material.dart';

enum TabIndicatorAlignVertical { center, up, down }

//  TabIndicator getIndicator(int index) {
//  if (index == 0) {
//    return const TabIndicator();
//  } else if (index == 1) {
//    return const TabIndicator(width: 20);
//  } else if (index == 2) {
//    return const TabIndicator(width: 4,height: 4,radius: 2);
//  } else if (index == 3) {
//    return const TabIndicator(width: 4,height: 4,radius: 2,align: TabIndicatorAlignVertical.up);
//  }else if (index == 4) {
//  return const TabIndicator(
//    align: TabIndicatorAlignVertical.center,
//    height:26,
//    radius: 13,
//    padding: EdgeInsets.symmetric(horizontal: -12,vertical: 0),
//    color: Color.fromARGB(100, 26, 26, 255),
//  );
//  } else {
//    return const TabIndicator();
//  }
// }
class TabIndicator extends Decoration {
  const TabIndicator({
    this.height = 2,
    this.color = Colors.redAccent,
    this.width = 0,
    this.radius = 1,
    this.padding = EdgeInsets.zero,
    this.align = TabIndicatorAlignVertical.down,
  });

  final double height;
  final double width;
  final double radius;
  final Color color;
  final TabIndicatorAlignVertical align;

  @override
  final EdgeInsetsGeometry padding;

  @override
  Decoration? lerpFrom(Decoration? a, double t) {
    if (a is TabIndicator) {
      return TabIndicator(
        padding: EdgeInsetsGeometry.lerp(a.padding, padding, t)!,
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  Decoration? lerpTo(Decoration? b, double t) {
    if (b is TabIndicator) {
      return TabIndicator(
        padding: EdgeInsetsGeometry.lerp(padding, b.padding, t)!,
      );
    }
    return super.lerpTo(b, t);
  }

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _TabIndicatorPainter(this, onChanged);
  }
}

class _TabIndicatorPainter extends BoxPainter {
  _TabIndicatorPainter(this.decoration, VoidCallback? onChanged)
    : super(onChanged);

  final TabIndicator decoration;
  double get indicatorHeight => decoration.height;
  double get indicatorWidth => decoration.width;
  Color get indicatorColor => decoration.color;
  double get indicatorRadius => decoration.radius;
  EdgeInsetsGeometry get padding => decoration.padding;
  TabIndicatorAlignVertical get align => decoration.align;

  Rect _indicatorRectFor(Rect rect, TextDirection textDirection) {
    final Rect indicator = padding.resolve(textDirection).deflateRect(rect);

    final double width = indicatorWidth > 0 ? indicatorWidth : indicator.width;
    final double height =
        indicatorHeight > 0 ? indicatorHeight : indicator.height;
    final double left = (indicator.left + indicator.right - width) * 0.5;
    double top;

    switch (align) {
      case TabIndicatorAlignVertical.up:
        top = indicator.top;
      case TabIndicatorAlignVertical.down:
        top = indicator.bottom - height;
      case TabIndicatorAlignVertical.center:
        top = (indicator.height - height) * 0.5;
    }
    return Rect.fromLTWH(left, top, width, height);
  }

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration.size != null, '');

    final Rect rect = offset & configuration.size!;
    final TextDirection textDirection = configuration.textDirection!;
    final Rect indicator = _indicatorRectFor(rect, textDirection);

    final Paint paint =
        Paint()
          ..color = indicatorColor
          ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(indicator, Radius.circular(indicatorRadius)),
      paint,
    );
  }
}
