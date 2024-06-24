import 'package:common_tools/common_tools.dart';
import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  final double? size;
  final Color? color;

  const Loader({super.key, this.size, this.color});

  @override
  Widget build(BuildContext context) {
    //return Image.asset(
    //   'assets/gifs/cronysoft_loader.gif',
    //   fit: BoxFit.contain,
    //   color: color,
    //   width: size ?? 150,
    //   height: size ?? 150,
    // )

    return CircularProgressIndicator(
      color: color ?? context.primaryColor,
    );
  }
}
