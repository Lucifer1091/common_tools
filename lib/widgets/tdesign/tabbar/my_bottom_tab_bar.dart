import 'dart:async';

import 'package:flutter/material.dart';

import '../../../index.dart';

/// Expand Item Down Arrow Width
const double _kArrowWidth = 13.5;

/// Expand Item Down Arrow Height
const double _kArrowHeight = 8;

/// Expand item options pop-up window Minimum height of a single item
const double _kMenuItemMinHeight = 23;

/// Expand item popup window Default height of a single item
const double _kDefaultMenuItemHeight = 48;

/// Expand item popup The default width of a single item is the button width minus 20
const double _kDefaultMenuItemWidthShrink = 20;

/// Navigation bar default height
const double _kDefaultTabBarHeight = 56;

/// Expand item pop-up window pop-up animation time
const Duration _kPopupMenuDuration = Duration(milliseconds: 10);

enum MyBottomTabBarBasicType {
  /// Single-level plain text tab bar
  text,

  /// Text plus icon label bar
  iconText,

  /// Pure icon tab bar
  icon,

  /// Two-level plain text tab bar
  expansionPanel,
}

enum MyBottomTabBarComponentType {
  /// Normal Stlye
  normal,

  /// Item selection style with capsule background
  label,
}

enum MyBottomTabBarOutlineType { filled, capsule }

class MyBadgeConfig {
  MyBadgeConfig({
    required this.showBadge,
    MyBadge? badge,
    this.badgeTopOffset,
    this.badgeRightOffset,
  }) : badge = badge ?? const MyBadge(MyBadgeType.redPoint);

  final bool showBadge;

  final MyBadge? badge;

  final double? badgeTopOffset;

  final double? badgeRightOffset;
}

/// Single tab configuration
class MyBottomTabBarTabConfig {
  MyBottomTabBarTabConfig({
    required this.onTap,
    this.selectedIcon,
    this.unselectedIcon,
    this.label,
    this.selectedStyle,
    this.unselectedStyle,
    this.badgeConfig,
    this.popUpButtonConfig,
    this.onLongPress,
    this.allowMultipleTaps = false,
  }) : assert(() {
         if (badgeConfig?.showBadge ?? false) {
           if (badgeConfig?.badge == null) {
             throw FlutterError(
               '[NavigationTab] if set showBadge = true, '
               'you must set a tdBadge instance',
             );
           }
         }
         return true;
       }(), '');

  final Widget? selectedIcon;

  final Widget? unselectedIcon;

  final String? label;

  final TextStyle? selectedStyle;

  final TextStyle? unselectedStyle;

  final GestureTapCallback? onTap;

  final MyBadgeConfig? badgeConfig;

  final TDBottomTabBarPopUpBtnConfig? popUpButtonConfig;

  final bool allowMultipleTaps;

  final GestureLongPressCallback? onLongPress;
}

class MyBottomTabBar extends StatefulWidget {
  MyBottomTabBar(
    this.basicType, {
    required this.navigationTabs,
    super.key,
    this.componentType = MyBottomTabBarComponentType.label,
    this.outlineType = MyBottomTabBarOutlineType.filled,
    this.barHeight = _kDefaultTabBarHeight,
    this.useVerticalDivider,
    this.dividerHeight,
    this.dividerThickness,
    this.dividerColor,
    this.showTopBorder = true,
    this.topBorder,
    this.useSafeArea = true,
    this.selectedBgColor,
    this.unselectedBgColor,
    this.backgroundColor,
    this.centerDistance,
    this.currentIndex,
    this.needInkWell = false,
  }) : assert(() {
         if (navigationTabs.isEmpty) {
           throw FlutterError('[TDBottomTabBar] please set at least one tab!');
         }
         if (basicType == MyBottomTabBarBasicType.text) {
           for (final item in navigationTabs) {
             if (item.label == null) {
               throw FlutterError(
                 '[TDBottomTabBar] type is TDBottomBarType.text, but not set tabText.',
               );
             }
           }
         }
         if (basicType == MyBottomTabBarBasicType.icon) {
           for (final item in navigationTabs) {
             if (item.selectedIcon == null || item.unselectedIcon == null) {
               throw FlutterError(
                 '[TDBottomTabBar] type is TDBottomBarType.icon, but has no set icon.',
               );
             }
           }
         }
         if (basicType == MyBottomTabBarBasicType.iconText) {
           for (final item in navigationTabs) {
             if (item.label == null ||
                 item.selectedIcon == null ||
                 item.unselectedIcon == null) {
               throw FlutterError(
                 '[TDBottomTabBar] type is TDBottomBarType.iconText, but not set tabText or icon.',
               );
             }
           }
         }
         if (currentIndex != null &&
             (currentIndex < 0 || currentIndex >= navigationTabs.length)) {
           throw FlutterError(
             '[TDBottomTabBar] currentIndex must in [0,navigationTabs.length)',
           );
         }
         return true;
       }(), '');

  final MyBottomTabBarBasicType basicType;

  final MyBottomTabBarComponentType? componentType;

  final MyBottomTabBarOutlineType? outlineType;

  final List<MyBottomTabBarTabConfig> navigationTabs;

  final double? barHeight;

  final bool? useVerticalDivider;

  final double? dividerHeight;

  final double? dividerThickness;

  final Color? dividerColor;

  final bool? showTopBorder;

  final BorderSide? topBorder;

  final bool useSafeArea;

  final Color? selectedBgColor;

  final Color? unselectedBgColor;

  final Color? backgroundColor;

  final double? centerDistance;

  final int? currentIndex;

  final bool needInkWell;

  @override
  State<MyBottomTabBar> createState() => _MyBottomTabBarState();
}

class _MyBottomTabBarState extends State<MyBottomTabBar> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.currentIndex ?? 0;
  }

  @override
  void didUpdateWidget(covariant MyBottomTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    _selectedIndex = widget.currentIndex ?? _selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    final isCapsuleOutlineType =
        widget.outlineType == MyBottomTabBarOutlineType.capsule;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        /// -2 is to increase the border
        var maxWidth =
            double.parse(constraints.biggest.width.toStringAsFixed(1)) - 2;

        /// Capsule style is 32 widths smaller than normal style
        if (isCapsuleOutlineType) maxWidth -= 32;

        final itemWidth = maxWidth / widget.navigationTabs.length;

        Widget result = Container(
          height: widget.barHeight ?? _kDefaultTabBarHeight,
          alignment: Alignment.center,
          margin:
              isCapsuleOutlineType
                  ? const EdgeInsets.symmetric(horizontal: 16)
                  : null,
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? context.colorScheme.secondary,
            borderRadius:
                isCapsuleOutlineType ? BorderRadius.circular(56) : null,
            border:
                widget.showTopBorder! && !isCapsuleOutlineType
                    ? Border(
                      top:
                          widget.topBorder ??
                          BorderSide(
                            color: context.colorScheme.border,
                            width: 0.5,
                          ),
                    )
                    : null,
            boxShadow: isCapsuleOutlineType ? MyBoxShadows.top : null,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(widget.navigationTabs.length, (index) {
                  return _item(index, itemWidth);
                }),
              ),
              _verticalDivider(),
            ],
          ),
        );
        if (widget.useSafeArea) {
          result = SafeArea(child: result);
        }
        return result;
      },
    );
  }

  void _onTap(int index) {
    setState(() {
      if (_selectedIndex != index ||
          widget.navigationTabs[index].allowMultipleTaps) {
        widget.navigationTabs[index].onTap?.call();
      }
      if (_selectedIndex != index) {
        _selectedIndex = index;
      }
    });
  }

  Widget _item(int index, double itemWidth) {
    final tabItemConfig = widget.navigationTabs[index];
    return Container(
      height: widget.barHeight ?? _kDefaultTabBarHeight,
      width: itemWidth,
      alignment: Alignment.center,
      padding: EdgeInsets.only(
        top: 7,
        bottom: widget.basicType == MyBottomTabBarBasicType.iconText ? 5 : 7,
      ),
      child: MyBottomTabBarItemWithBadge(
        basiceType: widget.basicType,
        componentType:
            widget.componentType ?? MyBottomTabBarComponentType.label,
        outlineType: widget.outlineType ?? MyBottomTabBarOutlineType.filled,
        itemConfig: tabItemConfig,
        isSelected: index == _selectedIndex,
        itemHeight: widget.barHeight ?? _kDefaultTabBarHeight,
        itemWidth: itemWidth,
        tabsLength: widget.navigationTabs.length,
        selectedBgColor: widget.selectedBgColor,
        unselectedBgColor: widget.unselectedBgColor,
        centerDistance: widget.centerDistance ?? 0,
        needInkWell: widget.needInkWell,
        onTap: () => _onTap(index),
        onLongPress: () => tabItemConfig.onLongPress?.call(),
      ),
    );
  }

  Widget _verticalDivider() {
    if (widget.componentType == MyBottomTabBarComponentType.label) {}
    return Visibility(
      visible:
          widget.componentType != MyBottomTabBarComponentType.label &&
          (widget.useVerticalDivider ?? false),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(widget.navigationTabs.length - 1, (index) {
          return SizedBox(
            width: widget.dividerThickness ?? 0.5,
            height: widget.dividerHeight ?? 32,
            child: VerticalDivider(
              color: widget.dividerColor ?? ThemeColors.neutral.shade200,
              thickness: widget.dividerThickness ?? 0.5,
            ),
          );
        }),
      ),
    );
  }
}

class MyBottomTabBarItemWithBadge extends StatelessWidget {
  const MyBottomTabBarItemWithBadge({
    required this.basiceType,
    required this.componentType,
    required this.outlineType,
    required this.itemConfig,
    required this.isSelected,
    required this.itemHeight,
    required this.itemWidth,
    required this.onTap,
    required this.tabsLength,
    required this.selectedBgColor,
    required this.unselectedBgColor,
    required this.centerDistance,
    super.key,
    this.onLongPress,
    this.needInkWell = false,
  });

  /// tab基本类型
  final MyBottomTabBarBasicType basiceType;

  /// tab选中背景类型
  final MyBottomTabBarComponentType componentType;

  //
  final MyBottomTabBarOutlineType outlineType;

  /// 单个tab的属性配置
  final MyBottomTabBarTabConfig itemConfig;

  /// 选中状态
  final bool isSelected;

  /// tab高度
  final double itemHeight;

  /// tab宽度
  final double itemWidth;

  /// 点击事件
  final GestureTapCallback onTap;

  /// tab总个数
  final int tabsLength;

  /// 选中时背景颜色
  final Color? selectedBgColor;

  /// 未选中时背景颜色
  final Color? unselectedBgColor;

  /// icon与文本中间距离
  final double centerDistance;

  /// 长按事件
  final GestureLongPressCallback? onLongPress;

  /// 是否需要水波纹效果
  final bool needInkWell;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => handleTap(context),
      onLongPress: onLongPress,
      child: Container(
        height: itemHeight,
        alignment: Alignment.center,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            if (isSelected || unselectedBgColor != null)
              Visibility(
                visible: componentType == MyBottomTabBarComponentType.label,
                child: Container(
                  /// 设计稿上 tab个数大于3时，左右边距为8，小于等于3时，左右边距为12
                  width: itemWidth - (tabsLength > 3 ? 16 : 24),
                  height:
                      basiceType == MyBottomTabBarBasicType.text ||
                              basiceType ==
                                  MyBottomTabBarBasicType.expansionPanel
                          ? 32
                          : null,
                  decoration: BoxDecoration(
                    color:
                        isSelected
                            ? selectedBgColor ?? context.colorScheme.background
                            : unselectedBgColor,
                    borderRadius: const BorderRadius.all(Radius.circular(24)),
                  ),
                ),
              ),
            _buildItem(context),
          ],
        ),
      ),
    );
  }

  Widget _badge(MyBadgeConfig? badgeConfig) {
    if (badgeConfig?.showBadge ?? false) {
      if (badgeConfig?.badge != null) {
        return badgeConfig!.badge!;
      }
    }
    return Container();
  }

  Widget _constructItem(
    BuildContext context,
    MyBadgeConfig? badgeConfig,
    bool isInOrOutCapsule,
  ) {
    Widget child = const NoWidget();
    if (basiceType == MyBottomTabBarBasicType.text) {
      child = _textItem(context, itemConfig, isSelected);
    }
    if (basiceType == MyBottomTabBarBasicType.expansionPanel) {
      if (itemConfig.popUpButtonConfig != null) {
        child = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.view_list_rounded,
              size: 16,
              color:
                  isSelected
                      ? context.colorScheme.primary
                      : context.colorScheme.foreground,
            ),
            const SizedBox(width: 5),
            _textItem(context, itemConfig, isSelected),
          ],
        );
      } else {
        child = _textItem(context, itemConfig, isSelected);
      }
    }
    if (basiceType == MyBottomTabBarBasicType.icon) {
      final selectedIcon = itemConfig.selectedIcon;
      final unSelectedIcon = itemConfig.unselectedIcon;
      child = isSelected ? selectedIcon! : unSelectedIcon!;
    }

    if (basiceType == MyBottomTabBarBasicType.iconText) {
      final selectedIcon = itemConfig.selectedIcon;
      final unSelectedIcon = itemConfig.unselectedIcon;
      child = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isSelected) selectedIcon! else unSelectedIcon!,
          if (centerDistance > 0) SizedBox(height: centerDistance),
          if (itemConfig.label?.isNotEmpty ?? false)
            _textItem(context, itemConfig, isSelected),
        ],
      );
    }

    final top = badgeConfig?.badgeTopOffset ?? -2;
    final right = badgeConfig?.badgeRightOffset ?? -10;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Visibility(
          visible: badgeConfig?.showBadge ?? false,
          child: Positioned(top: top, right: right, child: _badge(badgeConfig)),
        ),
      ],
    );
  }

  Widget _textItem(
    BuildContext context,
    MyBottomTabBarTabConfig config,
    bool isSelected,
  ) {
    return MyText(
      config.label,
      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      style: isSelected ? config.selectedStyle : config.unselectedStyle,
      textColor:
          isSelected
              ? context.colorScheme.primary
              : context.colorScheme.foreground,
    );
  }

  Widget _buildItem(BuildContext context) {
    final badgeConfig = itemConfig.badgeConfig;
    final isInOrOutCapsule =
        componentType == MyBottomTabBarComponentType.label ||
        outlineType == MyBottomTabBarOutlineType.capsule;

    final child = Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(
        top: isInOrOutCapsule ? 3.0 : 2.0,
        bottom:
            isInOrOutCapsule
                ? (basiceType == MyBottomTabBarBasicType.iconText ? 0.0 : 1.0)
                : 0.0,
      ),
      color: Colors.transparent,
      child: _constructItem(context, badgeConfig, isInOrOutCapsule),
    );

    if (!needInkWell) return child;

    return Material(
      color: Colors.transparent,
      borderRadius: isInOrOutCapsule ? BorderRadius.circular(24) : null,
      child: InkWell(
        borderRadius: isInOrOutCapsule ? BorderRadius.circular(24) : null,
        splashFactory: InkRipple.splashFactory,
        splashColor: selectedBgColor ?? context.colorScheme.primary,
        highlightColor: selectedBgColor ?? context.colorScheme.primary,
        onTap: () => handleTap(context),
        child: child,
      ),
    );
  }

  void handleTap(BuildContext context) {
    onTap.call();

    final popUpButtonConfig = itemConfig.popUpButtonConfig;
    if (popUpButtonConfig != null) {
      unawaited(
        Navigator.push(
          context,
          PopRoute(
            child: PopupDialog(
              itemWidth - _kDefaultMenuItemWidthShrink,
              btnContext: context,
              config: popUpButtonConfig.popUpDialogConfig,
              items: popUpButtonConfig.items,
              onClickMenu: popUpButtonConfig.onChanged,
            ),
          ),
        ),
      );
    }
  }
}

class TDBottomTabBarPopUpBtnConfig {
  TDBottomTabBarPopUpBtnConfig({
    required this.items,
    required this.onChanged,
    this.popUpDialogConfig,
  }) : assert(() {
         if (popUpDialogConfig != null) {
           if ((popUpDialogConfig.arrowHeight != null &&
                   popUpDialogConfig.arrowHeight! <= 0.0) ||
               (popUpDialogConfig.arrowWidth != null &&
                   popUpDialogConfig.arrowWidth! <= 0.0)) {
             throw FlutterError(
               '[TDBottomTabBarPopUpBtnConfig] arrowHeight or arrowHeight can '
               'not set less than or equal to zero',
             );
           }
         }
         return true;
       }(), '');

  /// Optionslist
  final List<PopUpMenuItem> items;

  /// 统一在 onChanged 中处理各item点击事件
  final ValueChanged<String> onChanged;

  /// 弹窗UI配置
  final TDBottomTabBarPopUpShapeConfig? popUpDialogConfig;
}

/// 弹窗UI配置
class TDBottomTabBarPopUpShapeConfig {
  TDBottomTabBarPopUpShapeConfig({
    this.popUpWidth,
    this.popUpitemHeight = _kDefaultMenuItemHeight,
    this.backgroundColor,
    this.radius,
    this.arrowWidth,
    this.arrowHeight,
  });

  /// 弹窗宽度（不设置，默认为按钮宽度 - 20）
  final double? popUpWidth;

  /// 单个Options高度 所有Options等高 不设置则使用默认值 48
  final double? popUpitemHeight;

  /// 弹窗背景颜色
  final Color? backgroundColor;

  /// panel圆角 默认0
  final double? radius;

  /// 箭头宽度 默认13.5
  final double? arrowWidth;

  /// 箭头高度 默认8
  final double? arrowHeight;
}

/// 弹窗菜单item
class PopUpMenuItem extends StatelessWidget {
  const PopUpMenuItem({
    required this.value,
    super.key,
    this.itemWidget,
    this.alignment = AlignmentDirectional.center,
  });

  /// Optionswidget
  final Widget? itemWidget;

  /// Options值
  final String value;

  /// 对齐方式
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: _kMenuItemMinHeight),
      alignment: alignment,
      child:
          itemWidget ??
          MyText(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
    );
  }
}

class PopRoute extends PopupRoute<dynamic> {
  PopRoute({required this.child});

  Widget child;

  @override
  Color? get barrierColor => Colors.transparent;

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => 'popUpMenuBarrierLabel';

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return child;
  }

  @override
  Duration get transitionDuration => _kPopupMenuDuration;
}

class PopupDialog extends StatefulWidget {
  const PopupDialog(
    this.defaultPopUpWidth, {
    required this.btnContext,
    required this.onClickMenu,
    required this.items,
    required this.config,
    super.key,
  });

  final BuildContext btnContext;

  final ValueChanged<String> onClickMenu;

  final List<PopUpMenuItem> items;

  final TDBottomTabBarPopUpShapeConfig? config;

  final double defaultPopUpWidth;

  @override
  PopupDialogState createState() => PopupDialogState();
}

class PopupDialogState extends State<PopupDialog> {
  RenderBox? button;
  RenderBox? overlay;
  RelativeRect? position;
  Size? size;

  @override
  void initState() {
    super.initState();
    button = widget.btnContext.findRenderObject()! as RenderBox;
    size = button!.size;
    overlay =
        Overlay.of(widget.btnContext).context.findRenderObject()! as RenderBox;

    position = RelativeRect.fromRect(
      Rect.fromPoints(
        button!.localToGlobal(Offset.zero, ancestor: overlay),
        button!.localToGlobal(Offset.zero, ancestor: overlay),
      ),
      Offset.zero & overlay!.size,
    );
  }

  @override
  Widget build(BuildContext context) {
    final popUpitemHeight =
        widget.config?.popUpitemHeight ?? _kDefaultMenuItemHeight;
    final popUpItemWidth =
        widget.config?.popUpWidth ?? widget.defaultPopUpWidth;
    final menuItems =
        widget.items
            .map(
              (e) => GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  widget.onClickMenu(e.value);
                  Navigator.of(context).pop();
                },
                child: SizedBox(height: popUpitemHeight, child: e),
              ),
            )
            .toList();

    return Material(
      type: MaterialType.transparency,
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Stack(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.transparent,
            ),
            Positioned(
              /// Here -8 is because widget.btnContext is TDBottomTabBarItemWithBadge,
              ///  which has 8dp padding in the parent widget -4 is because the
              /// arrow and tab have a 4dp distance in the design
              top:
                  position!.top -
                  (popUpitemHeight * widget.items.length +
                      (widget.config?.arrowHeight ?? _kArrowHeight)) -
                  8 -
                  4,
              right: position!.right - (popUpItemWidth + size!.width) / 2,
              child: Container(
                width: popUpItemWidth,
                height:
                    popUpitemHeight * widget.items.length +
                    (widget.config?.arrowHeight ?? _kArrowHeight),
                decoration: BoxDecoration(boxShadow: MyBoxShadows.top),
                child: CustomPaint(
                  painter: PanelWithDownArrow(config: widget.config),
                  child: Container(
                    alignment: Alignment.topCenter,
                    height: popUpitemHeight * widget.items.length,
                    child: Container(
                      constraints: BoxConstraints(
                        maxHeight: popUpitemHeight * widget.items.length,
                      ),
                      child: Stack(
                        children: [
                          Column(children: menuItems),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(
                              widget.items.length - 1,
                              (index) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: Divider(
                                  thickness: 0.5,
                                  height: 0.5,
                                  color: ThemeColors.neutral.shade200,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PanelWithDownArrow extends CustomPainter {
  PanelWithDownArrow({this.config});

  TDBottomTabBarPopUpShapeConfig? config;

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..isAntiAlias = true
          ..color = config?.backgroundColor ?? Colors.white
          ..style = PaintingStyle.fill;
    final path = Path();
    final panelWidth = size.width;
    final panelHeight = size.height - (config?.arrowHeight ?? _kArrowHeight);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, panelWidth, panelHeight),
        Radius.circular(config?.radius ?? 0.0),
      ),
      paint,
    );

    if (config?.arrowWidth != 0.0 && config?.arrowHeight != 0.0) {
      var left = (panelWidth - _kArrowWidth) / 2;
      var right = (panelWidth + _kArrowWidth) / 2;
      var bottom = panelHeight + _kArrowHeight;
      if (config?.arrowWidth != null) {
        left = (panelWidth - config!.arrowWidth!) / 2;
        right = (panelWidth + config!.arrowWidth!) / 2;
      }
      if (config?.arrowHeight != null) {
        bottom = panelHeight + config!.arrowHeight!;
      }

      path
        ..moveTo(left, panelHeight)
        ..lineTo(panelWidth / 2, bottom)
        ..lineTo(right, panelHeight);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
