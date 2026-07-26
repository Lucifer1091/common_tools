import 'package:flutter/material.dart';

import '../../../../extensions/context/theme.dart';
import '../models/sliding_toast_setting.dart';
import '../models/toast_style.dart';

class ToastProgressBarWidget extends StatelessWidget {
  /// A progress bar to show the remaining time left to dismiss the toast
  const ToastProgressBarWidget({
    required this.animation,
    required this.toastStyle,
    required this.toastSetting,
    super.key,
  });

  final Animation<double> animation;
  final ToastStyle toastStyle;
  final SlidingToastSetting toastSetting;

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = context.colorScheme.primary;
    final Color color = toastStyle.progressBarColor ?? primaryColor;
    double height = toastSetting.progressBarHeight;
    height = height.clamp(2, 8);

    // Defining the height of the size transition
    // Otherwise it will take available height (maxHeight)
    return SizedBox(
      height: height,
      child: SizeTransition(
        sizeFactor: animation,
        axis: Axis.horizontal,
        alignment: AlignmentDirectional.topStart,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color, color.withAlpha(179), color.withAlpha(102)],
            ),
          ),
        ),
      ),
    );
  }
}
