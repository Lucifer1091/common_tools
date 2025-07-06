import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

abstract class PlatformWidget<A extends Widget, I extends Widget>
    extends StatelessWidget {
  const PlatformWidget({super.key});

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return buildMaterialWidget(context);
    }

    final platform = Theme.of(context).platform;

    return switch (platform) {
      TargetPlatform.macOS ||
      TargetPlatform.iOS => buildCupertinoWidget(context),
      _ => buildMaterialWidget(context),
    };
  }

  /// Widget builder for Material
  A buildMaterialWidget(BuildContext context);

  /// Widget builder for iOS and MacOS
  I buildCupertinoWidget(BuildContext context);
}
