import '../../../exports/index.dart';

class CustomTabView extends StatelessWidget {
  final int tabCount;
  final int initialIndex;
  final TabController? controller;
  final double radius;
  final double? labelHorizontalPadding;
  final BorderRadiusGeometry? borderRadius;

  final Color? borderColor;
  final Color labelColor;
  final Color indicatorColor;
  final Color dividerColor;
  final Color? backgroundColor, bgColor;
  final Color? tabBarColor;

  final double indicatorHeight;
  final List<Widget> tabs;
  final List<Widget> children;
  final TextStyle? labelTextStyle;
  final void Function(int)? onTabChange;
  final bool isScrollable;
  final Clip? clipBehavior;

  const CustomTabView({
    super.key,
    required this.tabCount,
    this.initialIndex = 0,
    required this.tabs,
    required this.children,
    this.radius = Sizes.RADIUS_10,
    this.borderRadius,
    this.backgroundColor,
    this.labelHorizontalPadding,
    this.bgColor,
    this.tabBarColor,
    this.borderColor,
    this.labelTextStyle,
    this.indicatorHeight = 8,
    this.indicatorColor = AppColors.blueShade1,
    this.dividerColor = Colors.transparent,
    this.labelColor = AppColors.blueShade1,
    this.onTabChange,
    this.controller,
    this.isScrollable = true,
    this.clipBehavior,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.zero,
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(radius),
        border: Border.all(color: borderColor ?? const Color(0xFFE3E3E3)),
      ),
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(radius),
        child: DefaultTabController(
          length: tabCount,
          initialIndex: initialIndex,
          child: Scaffold(
            extendBody: false,
            extendBodyBehindAppBar: false,
            resizeToAvoidBottomInset: false,
            backgroundColor: bgColor ?? AppColors.white,
            appBar: AppBar(
              backgroundColor: backgroundColor ?? Colors.transparent,
              automaticallyImplyLeading: false,
              flexibleSpace: Container(
                color: tabBarColor ?? Colors.transparent,
                child: Stack(
                  children: [
                    _buildIndicatorDivider(),
                    TabBar(
                      controller: controller,
                      tabAlignment: isScrollable ? TabAlignment.start : null,
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelColor: AppColors.kPrimaryLight,
                      dividerColor: dividerColor,
                      dividerHeight: 4,
                      isScrollable: isScrollable,
                      labelPadding: EdgeInsets.symmetric(
                        horizontal: labelHorizontalPadding ?? Sizes.PADDING_32,
                      ),
                      onTap: onTabChange,
                      indicator: ContainerTabIndicator(
                        height: indicatorHeight,
                        color: indicatorColor,
                        padding: const EdgeInsetsDirectional.only(
                          top: Sizes.PADDING_20,
                        ),
                      ),
                      unselectedLabelColor: AppColors.blackShade1,
                      labelStyle: labelTextStyle ??
                          context.textTheme.titleSmall?.copyWith(
                            color: labelColor,
                            fontWeight: FontWeight.w500,
                          ),
                      indicatorWeight: 5.0,
                      tabs: tabs,
                    ),
                  ],
                ),
              ),
            ),
            body: TabBarView(
              controller: controller,
              physics: const NeverScrollableScrollPhysics(),
              clipBehavior: clipBehavior ?? Clip.none,
              children: children,
            ),
          ),
        ),
      ),
    );
  }

  Positioned _buildIndicatorDivider() {
    return Positioned(
      top: Sizes.HEIGHT_44 + 1,
      left: 0,
      right: 0,
      child: Stack(
        children: [
          Container(
            height: Sizes.HEIGHT_8,
            color: backgroundColor ?? Colors.transparent,
          ),
          Container(
            width: double.maxFinite,
            decoration: const BoxDecoration(
              color: AppColors.blueShade3,
              border: Border(bottom: BorderSide(color: Color(0xFFE3E3E3))),
            ),
          ),
        ],
      ),
    );
  }
}
