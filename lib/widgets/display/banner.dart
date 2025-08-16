import 'package:flutter/material.dart';

import '../../index.dart';

enum BannerPosition { topRight, topLeft }

class CustomBanner extends StatelessWidget {
  const CustomBanner({
    required this.child,
    super.key,
    this.bannerColor = Colors.blue,
    this.labelColor,
    this.label,
    this.bannerWidth = 100.0,
    this.position = BannerPosition.topLeft,
  }) : assert(bannerWidth >= 100.0, 'bannerWidth cannot be less than 100');
  final String? label;
  final Widget child;
  final Color bannerColor;
  final Color? labelColor;
  final double bannerWidth;
  final BannerPosition position;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: position == BannerPosition.topRight ? 4 : 20,
        top: 10,
        bottom: 10,
        right: position == BannerPosition.topRight ? 20 : 4,
      ),
      child: Column(
        children: [
          Center(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                child,
                if (label?.isNotEmpty ?? false) buildBanner(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Positioned buildBanner(BuildContext context) {
    switch (position) {
      case BannerPosition.topRight:
        return Positioned(
          top: -25,
          right: -20,
          child: ClipPath(
            clipper: _CustomRightBannerClipper(),
            child: _buildBannerContent(context),
          ),
        );

      case BannerPosition.topLeft:
        return Positioned(
          top: -25,
          left: -20,
          child: ClipPath(
            clipper: _CustomLeftBannerClipper(),
            child: _buildBannerContent(context),
          ),
        );
    }
  }

  Stack _buildBannerContent(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: bannerColor,
          height: 100,
          width: 100,
          child: Transform.rotate(
            angle: position == BannerPosition.topRight ? 0.72 : -0.72,
            child: Align(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  label!,
                  style: context.bodySmall?.copyWith(
                    color: labelColor ?? Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -10.5,
          left: position == BannerPosition.topRight ? null : 10.0,
          right: position == BannerPosition.topRight ? 10.0 : null,
          child: Transform.rotate(
            angle: position == BannerPosition.topRight ? -2.4 : -2.25,
            child: Container(
              height: 20,
              width: 20,
              color: darken(bannerColor, 0.2),
            ),
          ),
        ),
        Positioned(
          top: 22,
          right: position == BannerPosition.topRight ? null : -9.5,
          left: position == BannerPosition.topRight ? -9.5 : null,
          child: Transform.rotate(
            angle: 2.35,
            child: Container(
              height: 20,
              width: 20,
              color: darken(bannerColor, 0.2),
            ),
          ),
        ),
      ],
    );
  }

  Color darken(Color color, [double amount = .1]) {
    assert(
      amount >= 0 && amount <= 1,
      'Amount must be between 0 and 1, inclusive.',
    );

    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }
}

class _CustomLeftBannerClipper extends CustomClipper<Path> {
  _CustomLeftBannerClipper();

  @override
  Path getClip(Size size) {
    final path =
        Path()
          ..moveTo(0, 0)
          ..moveTo(size.width - 13, 0)
          ..lineTo(0, size.height - 25)
          ..lineTo(6, size.height - 3)
          ..lineTo(20, size.height)
          ..lineTo(20, size.height - 12)
          ..lineTo(size.width - 7, 25)
          ..lineTo(size.width, 25)
          ..lineTo(size.width, 19)
          ..lineTo(size.width - 22.3, 8)
          ..lineTo(size.width - 13, 0)
          ..lineTo(0, 0)
          ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => oldClipper != this;
}

class _CustomRightBannerClipper extends CustomClipper<Path> {
  _CustomRightBannerClipper();

  @override
  Path getClip(Size size) {
    final path =
        Path()
          ..moveTo(0, 0)
          ..moveTo(13, 0)
          ..lineTo(size.width, size.height - 25)
          ..lineTo(size.width - 6, size.height - 3)
          ..lineTo(size.width - 20, size.height)
          ..lineTo(size.width - 20, size.height - 12)
          ..lineTo(7, 25)
          ..lineTo(0, 25)
          ..lineTo(0, 19)
          ..lineTo(22.3, 8)
          ..lineTo(13, 0)
          ..lineTo(0, 0)
          ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => oldClipper != this;
}
