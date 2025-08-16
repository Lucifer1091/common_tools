import 'package:flutter/material.dart';

import '../../../index.dart';
import 'td_horizontal_tab_bar.dart';
import 'td_tab.dart';

enum TDTabBarOutlineType { filled, capsule, card }

class TDTabBar extends StatefulWidget {
  const TDTabBar({
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
    this.isScrollable = false,
    this.unselectedLabelStyle,
    this.labelStyle,
    this.width,
    this.height,
    this.indicatorPadding,
    this.labelPadding,
    this.indicator,
    this.physics,
    this.onTap,
    this.outlineType = TDTabBarOutlineType.filled,
    this.showIndicator = false,
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

  final List<TDTab> tabs;

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

  final TDTabBarOutlineType outlineType;

  final Color? dividerColor;

  final double dividerHeight;

  final Color? selectedBgColor;

  final Color? unSelectedBgColor;

  final TabAlignment? tabAlignment;

  @override
  State<StatefulWidget> createState() => _TDTabBarState();
}

class _TDTabBarState extends State<TDTabBar> {
  /// 默认高度
  static const double _defaultHeight = 48;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? MediaQuery.of(context).size.width,
      height: widget.height ?? _defaultHeight,
      decoration:
          widget.decoration ??
          (widget.outlineType == TDTabBarOutlineType.card
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
                                ThemeColors.neutral.shade200,
                            width: widget.dividerHeight,
                          ),
                        ),
              )),

      child: TDHorizontalTabBar(
        physics: widget.physics,
        isScrollable: widget.isScrollable,
        indicator: widget.indicator ?? _getIndicator(context),
        indicatorColor: widget.indicatorColor,
        unselectedLabelColor: widget.unselectedLabelColor,
        labelColor: widget.labelColor,
        labelStyle: widget.labelStyle ?? _getLabelStyle(context),
        labelPadding: widget.labelPadding ?? const EdgeInsets.all(8),
        unselectedLabelStyle:
            widget.unselectedLabelStyle ?? _getUnSelectLabelStyle(context),
        tabs: widget.tabs,
        indicatorPadding: widget.indicatorPadding ?? EdgeInsets.zero,
        outlineType: widget.outlineType,
        controller: widget.controller,
        backgroundColor: widget.backgroundColor,
        selectedBgColor: widget.selectedBgColor,
        unSelectedBgColor: widget.unSelectedBgColor,
        tabAlignment: widget.tabAlignment,
        onTap: (index) {
          widget.onTap?.call(index);
        },
      ),
    );
  }

  TextStyle _getUnSelectLabelStyle(BuildContext context) {
    return TextStyle(
      fontWeight: FontWeight.w400,
      color: ThemeColors.neutral.shade800,
    );
  }

  TextStyle _getLabelStyle(BuildContext context) {
    return TextStyle(
      fontWeight: FontWeight.w600,
      color: ThemeColors.neutral.shade800,
    );
  }

  Decoration _getIndicator(BuildContext context) {
    return widget.showIndicator
        ? TDTabBarIndicator(
          context: context,
          height: widget.indicatorHeight,
          width: widget.indicatorWidth,
          color: widget.indicatorColor,
        )
        : TDNoneIndicator();
  }
}

class TDTabBarIndicator extends Decoration {
  const TDTabBarIndicator({this.context, this.width, this.height, this.color});

  final BuildContext? context;
  final double? width;
  final double? height;
  final Color? color;

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) =>
      _TDTabBarIndicatorPainter(this);
}

class _TDTabBarIndicatorPainter extends BoxPainter {
  _TDTabBarIndicatorPainter(this.decoration) {
    _paint.color = decoration.color ?? ThemeColors.blue.shade600;
    _paint.strokeCap = StrokeCap.round;
  }

  static const double _defaultIndicatorWidth = 16;

  static const double _defaultIndicatorHeight = 3;

  final TDTabBarIndicator decoration;

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

class TDTabBarVerticalIndicator extends Decoration {
  const TDTabBarVerticalIndicator({
    this.context,
    this.indicatorWidth,
    this.indicatorHeight,
  });
  final BuildContext? context;
  final double? indicatorWidth;
  final double? indicatorHeight;

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) =>
      _TDTabBarVerticalIndicatorPainter(this);
}

class _TDTabBarVerticalIndicatorPainter extends BoxPainter {
  _TDTabBarVerticalIndicatorPainter(this.decoration) {
    _paint.color = ThemeColors.blue.shade600;
    _paint.strokeCap = StrokeCap.round;
  }

  static const double _defaultIndicatorWidth = 1.5;

  static const double _defaultIndicatorHeight = 54;

  final TDTabBarVerticalIndicator decoration;

  final _paint = Paint();

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    canvas.drawLine(
      Offset(
        0 + _indicatorWidth() / 2,
        offset.dx + (configuration.size!.width - _indicatorHeight()) / 2,
      ),
      Offset(
        0 + _indicatorWidth() / 2,
        offset.dx + (configuration.size!.width + _indicatorHeight()) / 2,
      ),
      _paint..strokeWidth = _indicatorWidth(),
    );
  }

  double _indicatorHeight() =>
      decoration.indicatorHeight ?? _defaultIndicatorHeight;

  double _indicatorWidth() =>
      decoration.indicatorWidth ?? _defaultIndicatorWidth;
}

class TDNoneIndicator extends Decoration {
  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) =>
      _TDNoneIndicatorPainter();
}

class _TDNoneIndicatorPainter extends BoxPainter {
  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {}
}
