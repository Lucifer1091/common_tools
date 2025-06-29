import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../common_tools.dart';

enum CenterLoadingType { material, cupertino, adaptive }

///Widget that displays a simple circle loading indicator like in ios.
class CenterLoading extends StatelessWidget {
  const CenterLoading({
    super.key,
    this.color,
    this.isAnimating = true,
    this.radius = 10,
  }) : _type = CenterLoadingType.cupertino,
       backgroundColor = null,
       strokeWidth = null;

  const CenterLoading.adaptive({
    super.key,
    this.color,
    this.isAnimating = true,
    this.radius,
    this.strokeWidth,
    this.backgroundColor,
  }) : _type = CenterLoadingType.adaptive;

  const CenterLoading.material({
    super.key,
    this.color,
    this.isAnimating = true,
    this.strokeWidth = 4,
    this.backgroundColor,
  }) : _type = CenterLoadingType.material,
       radius = null;

  final Color? color;
  final bool isAnimating;
  final double? radius;
  final double? strokeWidth;
  final Color? backgroundColor;
  final CenterLoadingType _type;

  @override
  Widget build(BuildContext context) {
    Widget child;

    switch (_type) {
      case CenterLoadingType.material:
        child = _buildMaterialWidget();
      case CenterLoadingType.cupertino:
        child = _buildCupertinoWidget();
      case CenterLoadingType.adaptive:
        child = isCupertino ? _buildCupertinoWidget() : _buildMaterialWidget();
    }

    return Center(child: child);
  }

  Widget _buildCupertinoWidget() {
    return CupertinoActivityIndicator(
      color: color,
      animating: isAnimating,
      radius: radius ?? 10,
    );
  }

  Widget _buildMaterialWidget() {
    return CircularProgressIndicator(
      color: color,
      value: isAnimating ? null : 1,
      strokeWidth: strokeWidth ?? 4,
      backgroundColor: backgroundColor,
    );
  }

  static bool get isCupertino {
    if (PlatformChecker.isWeb) return false;

    return PlatformChecker.isIOS || PlatformChecker.isMacOS;
  }
}
