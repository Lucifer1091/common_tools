import 'package:flutter/material.dart';

import '../../index.dart';
import '../layout/spaces.dart';

class NoteWidget extends StatelessWidget {
  const NoteWidget({required this.text, super.key, this.color, this.style});

  final String text;
  final TextStyle? style;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color ?? Colors.blue,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_rounded),
          const Space.w16(),
          Text(
            text,
            style:
                style ??
                context.labelLarge?.copyWith(fontWeight: FontWeight.w400),
            maxLines: 5,
          ).expanded(),
        ],
      ),
    );
  }
}
