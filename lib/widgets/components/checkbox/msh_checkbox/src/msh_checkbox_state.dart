import 'package:flutter/widgets.dart';

import 'msh_checkbox_style.dart';

class MSHCheckboxState {
  final BuildContext context;
  final bool isDisabled;
  final MSHCheckboxStyle style;

  const MSHCheckboxState({
    required this.context,
    required this.isDisabled,
    required this.style,
  });
}
