import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../index.dart';

class NoWaveBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    if (PlatformChecker.isAndroid || PlatformChecker.isFuchsia) {
      return child;
    } else {
      return super.buildOverscrollIndicator(context, child, details);
    }
  }

  // Add mouse drag
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.stylus,
    PointerDeviceKind.invertedStylus,
    PointerDeviceKind.trackpad,
    // The VoiceAccess sends pointer events with unknown type when scrolling
    // scrollables.
    PointerDeviceKind.unknown,
    PointerDeviceKind.mouse,
  };
}
