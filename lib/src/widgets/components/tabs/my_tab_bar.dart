library;

import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../../extensions/context/theme.dart';
import '../../../extensions/context/typography.dart';
import './my_tab.dart';
import './my_tab_indicator.dart';

part 'my_horizontal_tab_bar.dart';

class MyTabBar extends StatefulWidget {
  const MyTabBar({
    required this.tabs,
    super.key,
    this.controller,
    this.onTap,
    this.width,
    this.height,
    this.decoration,
    this.backgroundColor,
    this.labelColor,
    this.labelStyle,
    this.unselectedLabelColor,
    this.unselectedLabelStyle,
    this.indicator,
    this.indicatorPadding,
    this.labelPadding,
    this.physics,
    this.isScrollable = false,
    this.dividerColor,
    this.dividerHeight = 0.5,
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

  final Color? labelColor;

  final Color? unselectedLabelColor;

  final bool isScrollable;

  final TextStyle? labelStyle;

  final TextStyle? unselectedLabelStyle;

  final double? width;

  final double? height;

  final EdgeInsets? indicatorPadding;

  final MyTabIndicator? indicator;

  final ScrollPhysics? physics;

  final void Function(int)? onTap;

  final EdgeInsetsGeometry? labelPadding;

  final Color? dividerColor;

  final double dividerHeight;

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
          BoxDecoration(
            color: widget.backgroundColor,
            border: widget.dividerHeight <= 0
                ? null
                : Border(
                    bottom: BorderSide(
                      color: widget.dividerColor ?? context.colorScheme.border,
                      width: widget.dividerHeight,
                    ),
                  ),
          ),
      child: _MyHorizontalTabBar(
        physics: widget.physics,
        isScrollable: widget.isScrollable,
        indicator: widget.indicator ?? MyTabIndicator(context),
        unselectedLabelColor: widget.unselectedLabelColor,
        labelColor: widget.labelColor,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: widget.labelStyle ?? _getLabelStyle(context),
        labelPadding: widget.labelPadding ?? const EdgeInsets.all(8),
        unselectedLabelStyle:
            widget.unselectedLabelStyle ?? _getUnSelectLabelStyle(context),
        tabs: widget.tabs,
        indicatorPadding: widget.indicatorPadding ?? EdgeInsets.zero,
        controller: widget.controller,
        backgroundColor: widget.backgroundColor,
        tabAlignment: widget.tabAlignment,
        onTap: widget.onTap,
        padding: EdgeInsets.zero,
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
}
