import 'package:flutter/material.dart';

import 'my_collapse.dart';

typedef MyCollapseIconTextBuilder =
    String Function(BuildContext context, bool isExpanded);

/// Folding panel, need to be used with [MyCollapse]
class MyCollapsePanel extends ExpansionPanel {
  MyCollapsePanel({
    required super.headerBuilder,
    required super.body,
    super.isExpanded,
    this.expandIconTextBuilder,

    /// The value of the folding panel. When using [MyCollapse.accordion], this value must be passed in
    this.value,
    super.backgroundColor,
  }) : super(canTapOnHeader: true);

  final Object? value;
  final MyCollapseIconTextBuilder? expandIconTextBuilder;
}
