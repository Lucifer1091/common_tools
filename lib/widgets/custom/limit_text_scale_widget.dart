import 'dart:math';

import 'package:flutter/cupertino.dart';

import '../../common_tools.dart';

class LimitTextScaleWidget extends StatelessWidget {
  const LimitTextScaleWidget({
    required this.child,
    super.key,
    this.maxTextScaleFactor,
  });

  /// If the value is not set or set to 0,
  /// the application defaults to using the system textscale
  final double? maxTextScaleFactor;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final maxTextScale = maxTextScaleFactor ?? 0;

    if (maxTextScale > 0) {
      final limitTextScale = min(maxTextScale, context.textScaleFactor);

      return MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(textScaler: TextScaler.linear(limitTextScale)),
        child: child,
      );
    }

    return child;
  }
}
