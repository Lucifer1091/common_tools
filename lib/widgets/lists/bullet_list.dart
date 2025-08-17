import 'package:flutter/material.dart';

import '../../index.dart';

enum SymbolType { Bullet, Numbered, Custom }

/// Add UL to its children
class BulletList extends StatelessWidget {
  // Used when SymbolType is Numbered

  const BulletList({
    this.children,
    this.padding = 8,
    this.spacing = 8,
    this.symbolType = SymbolType.Bullet,
    this.symbolColor,
    this.textColor,
    this.customSymbol,
    this.prefixText,
    this.edgeInsets,
    this.symbolCrossAxisAlignment,
    super.key,
  });

  final List<Widget>? children;
  final double padding;
  final double spacing;
  final SymbolType symbolType;
  final Color? symbolColor;
  final Color? textColor;
  final EdgeInsets? edgeInsets;
  final Widget? customSymbol;
  final CrossAxisAlignment? symbolCrossAxisAlignment;
  final String? prefixText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(children?.length ?? 0, (index) {
        return Padding(
          padding: edgeInsets ?? EdgeInsets.zero,
          child: Row(
            crossAxisAlignment:
                symbolCrossAxisAlignment ?? CrossAxisAlignment.start,
            children: [
              symbolWidget(context, index),
              SizedBox(width: padding),
              children![index].expanded(),
            ],
          ),
        );
      }),
    );
  }

  /// Returns a symbol widget
  Widget symbolWidget(BuildContext context, int index) {
    if (symbolType == SymbolType.Numbered && customSymbol != null) {
      return customSymbol!;
    } else if (symbolType == SymbolType.Bullet) {
      return Text(
        '•',
        style: context.bodyMedium?.copyWith(
          color: symbolColor ?? context.colorScheme.primary,
        ),
      );
    } else if (symbolType == SymbolType.Numbered) {
      return Text(
        '$prefixText ${index + 1}.',
        style: context.bodyMedium?.copyWith(
          color: symbolColor ?? context.colorScheme.primary,
        ),
      );
    }

    return Offstage();
  }
}
