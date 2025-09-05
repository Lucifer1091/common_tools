import 'package:flutter/material.dart';

import '../../../index.dart';

class MyTabBar extends StatefulWidget {
  const MyTabBar({
    required this.tabs,
    super.key,
    this.controller,
    this.decoration,
    this.backgroundColor,
    this.indicatorColor,
    this.indicatorWidth,
    this.indicatorHeight,
    this.labelColor,
    this.unselectedLabelColor,
    this.unselectedLabelStyle,
    this.labelStyle,
    this.width,
    this.height,
    this.indicatorPadding,
    this.labelPadding,
    this.indicator,
    this.physics,
    this.onTap,
    this.isScrollable = false,
    this.type = MyTabType.underline,
    this.showIndicator = true,
    this.dividerColor,
    this.dividerHeight = 0.5,
    this.selectedBgColor,
    this.unSelectedBgColor,
    this.tabAlignment,
  }) : assert(
         backgroundColor == null || decoration == null,
         'Cannot provide both a backgroundColor and a decoration\n'
         'To provide both, use "decoration: BoxDecoration(color: color)".',
       );

  final List<MyTab> tabs;

  final TabController? controller;

  final Decoration? decoration;

  final Color? backgroundColor;

  final Color? indicatorColor;

  final double? indicatorHeight;

  final double? indicatorWidth;

  final Color? labelColor;

  final Color? unselectedLabelColor;

  final bool isScrollable;

  final TextStyle? labelStyle;

  final TextStyle? unselectedLabelStyle;

  final double? width;

  final double? height;

  final EdgeInsets? indicatorPadding;

  final Decoration? indicator;

  final bool showIndicator;

  final ScrollPhysics? physics;

  final void Function(int)? onTap;

  final EdgeInsetsGeometry? labelPadding;

  final MyTabType type;

  final Color? dividerColor;

  final double dividerHeight;

  final Color? selectedBgColor;

  final Color? unSelectedBgColor;

  final TabAlignment? tabAlignment;

  @override
  State<StatefulWidget> createState() => _MyTabBarState();
}

class _MyTabBarState extends State<MyTabBar> {
  static const double _defaultHeight = 48;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? MediaQuery.of(context).size.width,
      height: widget.height ?? _defaultHeight,
      decoration:
          widget.decoration ??
          (widget.type == MyTabType.card
              ? BoxDecoration(color: widget.backgroundColor)
              : BoxDecoration(
                color: widget.backgroundColor,
                border:
                    widget.dividerHeight <= 0
                        ? null
                        : Border(
                          bottom: BorderSide(
                            color:
                                widget.dividerColor ??
                                context.colorScheme.border,
                            width: widget.dividerHeight,
                          ),
                        ),
              )),

      child: MyHorizontalTabBar(
        physics: widget.physics,
        isScrollable: widget.isScrollable,
        indicator: widget.indicator ?? _getIndicator(context),
        indicatorColor: widget.indicatorColor,
        unselectedLabelColor: widget.unselectedLabelColor,
        labelColor: widget.labelColor,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: widget.labelStyle ?? _getLabelStyle(context),
        labelPadding: widget.labelPadding ?? const EdgeInsets.all(8),
        unselectedLabelStyle:
            widget.unselectedLabelStyle ?? _getUnSelectLabelStyle(context),
        tabs: widget.tabs,
        indicatorPadding: widget.indicatorPadding ?? EdgeInsets.zero,
        outlineType: widget.type,
        controller: widget.controller,
        backgroundColor: widget.backgroundColor,
        selectedBgColor: widget.selectedBgColor,
        unSelectedBgColor: widget.unSelectedBgColor,
        tabAlignment: widget.tabAlignment,
        onTap: widget.onTap,
      ),
    );
  }

  TextStyle _getUnSelectLabelStyle(BuildContext context) {
    return TextStyle(
      fontWeight: FontWeight.w400,
      color: context.colorScheme.mutedForeground,
    );
  }

  TextStyle _getLabelStyle(BuildContext context) {
    return TextStyle(
      fontWeight: FontWeight.w600,
      color: context.colorScheme.foreground,
    );
  }

  Decoration _getIndicator(BuildContext context) {
    return widget.showIndicator
        ? MyTabUnderlineIndicator(
          context: context,
          height: widget.indicatorHeight,
          width: widget.indicatorWidth,
          color: widget.indicatorColor,
        )
        : MyNoIndicator();
  }
}

class MyTabUnderlineIndicator extends Decoration {
  const MyTabUnderlineIndicator({
    required this.context,
    this.width,
    this.height,
    this.color,
  });

  final BuildContext context;
  final double? width;
  final double? height;
  final Color? color;

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) =>
      _MyTabUnderlineIndicatorPainter(context, this);
}

class _MyTabUnderlineIndicatorPainter extends BoxPainter {
  _MyTabUnderlineIndicatorPainter(this.context, this.decoration) {
    _paint.color = decoration.color ?? context.colorScheme.primary;
    _paint.strokeCap = StrokeCap.round;
  }

  static const double _defaultIndicatorWidth = 16;

  static const double _defaultIndicatorHeight = 3;

  final MyTabUnderlineIndicator decoration;

  final BuildContext context;

  final _paint = Paint();

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    canvas.drawLine(
      Offset(
        offset.dx + (configuration.size!.width - _indicatorWidth()) / 2,
        configuration.size!.height - _indicatorHeight() / 2,
      ),
      Offset(
        offset.dx + (configuration.size!.width + _indicatorWidth()) / 2,
        configuration.size!.height - _indicatorHeight() / 2,
      ),
      _paint..strokeWidth = _indicatorHeight(),
    );
  }

  double _indicatorHeight() => decoration.height ?? _defaultIndicatorHeight;

  double _indicatorWidth() => decoration.width ?? _defaultIndicatorWidth;
}

class MyTabCapsuleIndicator extends Decoration {
  const MyTabCapsuleIndicator({
    required this.context,
    this.height,
    this.color,
    this.radius,
    this.indicatorPadding,
  });

  final BuildContext context;
  final double? height;
  final Color? color;
  final double? radius;
  final EdgeInsetsGeometry? indicatorPadding;

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) =>
      _MyTabCapsuleIndicatorPainter(context, this);
}

class _MyTabCapsuleIndicatorPainter extends BoxPainter {
  _MyTabCapsuleIndicatorPainter(this.context, this.decoration);

  final MyTabCapsuleIndicator decoration;
  final BuildContext context;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final indicatorHeight = decoration.height ?? 32;
    final indicatorRadius = decoration.radius ?? indicatorHeight / 2;
    final indicatorColor = decoration.color ?? context.colorScheme.primary;
    final EdgeInsets padding = (decoration.indicatorPadding ??
            decoration.padding)
        .resolve(Directionality.of(context));

    final rect =
        Offset(
          offset.dx + padding.left,
          offset.dy + configuration.size!.height / 2 - indicatorHeight / 2,
        ) &
        Size(configuration.size!.width - padding.horizontal, indicatorHeight);

    final paint =
        Paint()
          ..color = indicatorColor
          ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(indicatorRadius)),
      paint,
    );
  }
}

class MyNoIndicator extends Decoration {
  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) =>
      _MyNoIndicatorPainter();
}

class _MyNoIndicatorPainter extends BoxPainter {
  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {}
}
