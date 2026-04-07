import 'package:flutter/material.dart';

import '../../index.dart';

enum MySymbolType { bullet, numbered, custom }

class MyBulletList extends StatelessWidget {
  const MyBulletList({
    this.children,
    this.padding = 8,
    this.spacing = 8,
    this.symbolType = MySymbolType.bullet,
    this.symbolColor,
    this.textColor,
    this.customSymbol,
    this.prefixText,
    this.rowPadding,
    this.symbolCrossAxisAlignment,
    super.key,
  }) : assert(padding >= 0, 'padding must be greater than or equal to 0.'),
       assert(spacing >= 0, 'spacing must be greater than or equal to 0.'),
       assert(
         symbolType != MySymbolType.custom || customSymbol != null,
         'customSymbol must be provided when symbolType is SymbolType.custom.',
       );

  final List<Widget>? children;
  final double padding;
  final double spacing;
  final MySymbolType symbolType;
  final Color? symbolColor;
  final Color? textColor;
  final EdgeInsets? rowPadding;
  final Widget? customSymbol;
  final CrossAxisAlignment? symbolCrossAxisAlignment;
  final String? prefixText;

  @override
  Widget build(BuildContext context) {
    final children = this.children;
    if (children == null || children.isEmpty) {
      return const SizedBox.shrink();
    }

    final symbolStyle = context.bodyMedium.copyWith(
      color: symbolColor ?? context.colorScheme.primary,
    );
    final crossAxisAlignment =
        symbolCrossAxisAlignment ?? CrossAxisAlignment.start;

    final childTextStyle =
        textColor == null
            ? null
            : context.bodyMedium.copyWith(color: textColor);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List<Widget>.generate(children.length, (index) {
        final child =
            childTextStyle == null
                ? children[index]
                : DefaultTextStyle.merge(
                  style: childTextStyle,
                  child: children[index],
                );

        final effectivePadding =
            rowPadding ??
            EdgeInsets.only(bottom: index == children.length - 1 ? 0 : spacing);

        return Padding(
          padding: effectivePadding,
          child: Row(
            crossAxisAlignment: crossAxisAlignment,
            children: [
              _buildSymbol(index, symbolStyle),
              SizedBox(width: padding),
              Expanded(child: child),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSymbol(int index, TextStyle symbolStyle) {
    switch (symbolType) {
      case MySymbolType.bullet:
        return Text('\u2022', style: symbolStyle);
      case MySymbolType.numbered:
        final prefix = prefixText;
        final label =
            prefix == null || prefix.isEmpty
                ? '${index + 1}.'
                : '$prefix ${index + 1}.';
        return Text(label, style: symbolStyle);
      case MySymbolType.custom:
        return customSymbol ?? const SizedBox.shrink();
    }
  }
}
