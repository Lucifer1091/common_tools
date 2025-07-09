import 'package:flutter/material.dart';

class BannerPlaceholder extends StatelessWidget {
  const BannerPlaceholder({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.boxShape,
  });

  final double? width;
  final double? height;
  final double? borderRadius;
  final BoxShape? boxShape;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius:
            boxShape == null
                ? BorderRadius.circular(borderRadius ?? 12.0)
                : null,
        color: Colors.white,
        shape: boxShape ?? BoxShape.rectangle,
      ),
    );
  }
}

class TitlePlaceholder extends StatelessWidget {
  const TitlePlaceholder({
    required this.width,
    super.key,
    this.linesCount = 2,
    this.height = 12.0,
    this.padding = EdgeInsets.zero,
  });

  final double width;
  final double height;
  final int linesCount;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: padding,
        itemBuilder:
            (_, index) => Container(
              height: height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
            ),
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemCount: linesCount,
      ),
    );
  }
}

enum ContentLineType { twoLines, threeLines }

class ContentPlaceholder extends StatelessWidget {
  const ContentPlaceholder({required this.lineType, super.key});
  final ContentLineType lineType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Container(
            width: 96,
            height: 72,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 10,
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 8),
                ),
                if (lineType == ContentLineType.threeLines)
                  Container(
                    width: double.infinity,
                    height: 10,
                    color: Colors.white,
                    margin: const EdgeInsets.only(bottom: 8),
                  ),
                Container(width: 100, height: 10, color: Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
