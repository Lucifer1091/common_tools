import 'package:flutter/material.dart';

import '../../../extensions/context/theme.dart';
import '../image/my_image.dart';
import '../link/my_link.dart';

enum MyFooterType { text, link, brand }

class MyFooter extends StatelessWidget {
  const MyFooter(
    this.type, {
    super.key,
    this.logo,
    this.text = '',
    this.links = const [],
    this.width,
    this.height,
  });

  final String? logo;
  final MyFooterType type;
  final String text;
  final double? width;
  final double? height;
  final List<MyLink> links;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case MyFooterType.text:
        return Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [_renderText(context)],
          ),
        );
      case MyFooterType.link:
        return Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (links.isNotEmpty)
                _renderLinks(context)
              else
                _renderText(context),
            ],
          ),
        );
      case MyFooterType.brand:
        return Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (logo != null) _renderLogo() else _renderText(context),
            ],
          ),
        );
    }
  }

  Widget _renderLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 4),
          child: MyImage(
            source: logo,
            type: MyImageType.fitWidth,
            width: width,
            height: height,
          ),
        ),
      ],
    );
  }

  Widget _renderLinks(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 4),
          child: Wrap(
            alignment: WrapAlignment.center,
            children: List.generate(links.length, (index) {
              final link = links[index];
              return Container(
                decoration: index < (links.length - 1)
                    ? BoxDecoration(
                        border: Border(
                          right: BorderSide(color: context.colorScheme.border),
                        ),
                      )
                    : null,
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: link,
              );
            }).toList(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Flexible(child: _renderText(context))],
          ),
        ),
      ],
    );
  }

  Widget _renderText(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 12,
        color: context.colorScheme.mutedForeground,
      ),
    );
  }
}
