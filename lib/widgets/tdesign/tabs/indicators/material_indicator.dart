import 'package:flutter/material.dart';

enum TabPosition { top, bottom }

class MaterialIndicator extends Decoration {
  const MaterialIndicator({
    this.height = 4,
    this.tabPosition = TabPosition.bottom,
    this.topRightRadius = 5,
    this.topLeftRadius = 5,
    this.bottomRightRadius = 0,
    this.bottomLeftRadius = 0,
    this.color = Colors.black,
    this.horizontalPadding = 0,
    this.paintingStyle = PaintingStyle.fill,
    this.strokeWidth = 2,
  });

  /// Height of the indicator. Defaults to 4
  final double height;

  /// Determines to location of the tab, [TabPosition.bottom] set to default.
  final TabPosition tabPosition;

  /// topRight radius of the indicator, default to 5.
  final double topRightRadius;

  /// topLeft radius of the indicator, default to 5.
  final double topLeftRadius;

  /// bottomRight radius of the indicator, default to 0.
  final double bottomRightRadius;

  /// bottomLeft radius of the indicator, default to 0
  final double bottomLeftRadius;

  /// Color of the indicator, default set to [Colors.black]
  final Color color;

  /// Horizontal padding of the indicator, default set 0
  final double horizontalPadding;

  /// [PaintingStyle] determines if the indicator should be fill or stroke, default to fill
  final PaintingStyle paintingStyle;

  /// StrokeWidth, used for [PaintingStyle.stroke], default set to 2
  final double strokeWidth;
  @override
  _CustomPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CustomPainter(
      this,
      onChanged,
      bottomLeftRadius: bottomLeftRadius,
      bottomRightRadius: bottomRightRadius,
      color: color,
      height: height,
      horizontalPadding: horizontalPadding,
      tabPosition: tabPosition,
      topLeftRadius: topLeftRadius,
      topRightRadius: topRightRadius,
      paintingStyle: paintingStyle,
      strokeWidth: strokeWidth,
    );
  }
}

class _CustomPainter extends BoxPainter {
  _CustomPainter(
    this.decoration,
    VoidCallback? onChanged, {
    required this.height,
    required this.tabPosition,
    required this.topRightRadius,
    required this.topLeftRadius,
    required this.bottomRightRadius,
    required this.bottomLeftRadius,
    required this.color,
    required this.horizontalPadding,
    required this.paintingStyle,
    required this.strokeWidth,
  }) : super(onChanged);

  final MaterialIndicator decoration;
  final double height;
  final TabPosition tabPosition;
  final double topRightRadius;
  final double topLeftRadius;
  final double bottomRightRadius;
  final double bottomLeftRadius;
  final Color color;
  final double horizontalPadding;
  final double strokeWidth;
  final PaintingStyle paintingStyle;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(horizontalPadding >= 0, '');
    assert(
      horizontalPadding < configuration.size!.width / 2,
      'Padding must be less than half of the size of the tab',
    );
    assert(height > 0, '');
    assert(
      strokeWidth >= 0 &&
          strokeWidth < configuration.size!.width / 2 &&
          strokeWidth < configuration.size!.height / 2,
      '',
    );

    // offset is the position from where the decoration should be drawn.
    // configuration.size tells us about the height and width of the tab.
    final Size mysize = Size(
      configuration.size!.width - (horizontalPadding * 2),
      height,
    );

    final Offset myoffset = Offset(
      offset.dx + horizontalPadding,
      offset.dy +
          (tabPosition == TabPosition.bottom
              ? configuration.size!.height - height
              : 0),
    );

    final Rect rect = myoffset & mysize;
    final Paint paint =
        Paint()
          ..color = color
          ..style = paintingStyle
          ..strokeWidth = strokeWidth;

    canvas.drawRRect(
      RRect.fromRectAndCorners(
        rect,
        bottomRight: Radius.circular(bottomRightRadius),
        bottomLeft: Radius.circular(bottomLeftRadius),
        topLeft: Radius.circular(topLeftRadius),
        topRight: Radius.circular(topRightRadius),
      ),
      paint,
    );
  }
}

enum MyTabIndicatorSize { tiny, normal, full }

class MD2Indicator extends Decoration {
  const MD2Indicator({
    required this.indicatorHeight,
    required this.indicatorColor,
    required this.indicatorSize,
  });
  final double indicatorHeight;
  final Color indicatorColor;
  final MyTabIndicatorSize indicatorSize;

  @override
  _MD2Painter createBoxPainter([VoidCallback? onChanged]) {
    return _MD2Painter(this, onChanged);
  }
}

class _MD2Painter extends BoxPainter {
  _MD2Painter(this.decoration, VoidCallback? onChanged) : super(onChanged);

  final MD2Indicator decoration;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration.size != null, '');

    Rect rect;
    if (decoration.indicatorSize == MyTabIndicatorSize.full) {
      rect =
          Offset(
            offset.dx,
            configuration.size!.height - decoration.indicatorHeight,
          ) &
          Size(configuration.size!.width, decoration.indicatorHeight);
    } else if (decoration.indicatorSize == MyTabIndicatorSize.tiny) {
      rect =
          Offset(
            offset.dx + configuration.size!.width / 2 - 8,
            configuration.size!.height - decoration.indicatorHeight,
          ) &
          Size(16, decoration.indicatorHeight);
    } else {
      rect =
          Offset(
            offset.dx + 6,
            configuration.size!.height - decoration.indicatorHeight,
          ) &
          Size(configuration.size!.width - 12, decoration.indicatorHeight);
    }

    final Paint paint =
        Paint()
          ..color = decoration.indicatorColor
          ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndCorners(
        rect,
        topRight: Radius.circular(8),
        topLeft: Radius.circular(8),
      ),
      paint,
    );
  }
}
