import 'package:flutter/material.dart';

import 'td_collapse.dart';

typedef TDCollapseIconTextBuilder =
    String Function(BuildContext context, bool isExpanded);

/// Folding panel, need to be used with [TDCollapse]
class TDCollapsePanel extends ExpansionPanel {
  TDCollapsePanel({
    required super.headerBuilder,

    required super.body,

    super.isExpanded,

    this.expandIconTextBuilder,

    /// The value of the folding panel. When using [TDCollapse.accordion], this value must be passed in
    this.value,

    super.backgroundColor,
  }) : super(canTapOnHeader: true);

  final Object? value;

  final TDCollapseIconTextBuilder? expandIconTextBuilder;
}
