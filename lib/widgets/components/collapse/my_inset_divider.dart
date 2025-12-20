import 'package:flutter/material.dart';

import '../../../extensions/context/index.dart';

class MyInsetDivider extends StatelessWidget {
  const MyInsetDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 1,
      child: Divider(
        color: context.colorScheme.border,
        indent: 16,
        endIndent: 0,
        height: 1,
        thickness: 0.5,
      ),
    );
  }
}
