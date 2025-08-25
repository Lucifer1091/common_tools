import 'package:flutter/material.dart';

import '../../../index.dart';
import '../loading/my_circle_indicator.dart';
import '../text/my_text.dart';
import 'td_cupertino_switch.dart';

typedef OnSwitchChanged = bool Function(bool value);

enum TDSwitchSize { large, medium, small }

enum TDSwitchType { fill, text, loading, icon }

class TDSwitch extends StatefulWidget {
  const TDSwitch({
    super.key,
    this.enable = true,
    this.isOn = false,
    this.size = TDSwitchSize.medium,
    this.type = TDSwitchType.fill,
    this.trackOnColor,
    this.trackOffColor,
    this.thumbContentOnColor,
    this.thumbContentOffColor,
    this.thumbContentOnFont,
    this.thumbContentOffFont,
    this.onChanged,
    this.openText,
    this.closeText,
  });

  final bool enable;

  final bool isOn;

  final Color? trackOnColor;

  final Color? trackOffColor;

  final Color? thumbContentOnColor;

  final Color? thumbContentOffColor;

  final TextStyle? thumbContentOnFont;

  final TextStyle? thumbContentOffFont;

  final TDSwitchSize? size;

  final TDSwitchType? type;

  final OnSwitchChanged? onChanged;

  final String? openText;

  final String? closeText;

  @override
  State<StatefulWidget> createState() {
    return TDSwitchState();
  }
}

class TDSwitchState extends State<TDSwitch> {
  bool isOn = false;

  @override
  void initState() {
    super.initState();
    isOn = widget.isOn;
  }

  @override
  void didUpdateWidget(covariant TDSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    isOn = widget.isOn;
  }

  @override
  Widget build(BuildContext context) {
    final switchEnable = widget.enable && widget.type != TDSwitchType.loading;
    final trackOnColor = widget.trackOnColor ?? ThemeColors.blue.shade600;
    final trackOffColor = widget.trackOffColor ?? ThemeColors.neutral.shade300;
    final thumbContentOnColor =
        widget.thumbContentOnColor ?? ThemeColors.blue.shade600;
    final thumbContentOffColor =
        widget.thumbContentOffColor ?? ThemeColors.neutral.shade600;
    final thumbContentOnFont =
        widget.thumbContentOnFont ?? const TextStyle(fontSize: 14);
    final thumbContentOffFont =
        widget.thumbContentOffFont ?? const TextStyle(fontSize: 14);
    Widget current = TDCupertinoSwitch(
      value: isOn,
      activeColor: trackOnColor,
      trackColor: trackOffColor,
      onChanged: (value) {
        final process = widget.onChanged?.call(value) ?? false;
        // If the external has not been processed, you need to customize the
        // refresh switch. If it has been processed, no refresh is needed
        if (!process) {
          isOn = value;
          setState(() {});
        }
      },
      thumbView: _getThumbView(
        thumbContentOnColor,
        thumbContentOffColor,
        thumbContentOnFont,
        thumbContentOffFont,
      ),
    );
    if (!switchEnable) {
      current = Opacity(
        opacity: 0.4,
        child: IgnorePointer(ignoring: !switchEnable, child: current),
      );
    }
    return SizedBox(
      width: _getWidth(),
      height: _getHeight(),
      child: FittedBox(child: current),
    );
    // return ConstrainedBox( _getWidth(), height: _getHeight(), child: current);
  }

  double _getWidth() {
    switch (widget.size) {
      case TDSwitchSize.large:
        return 52;
      case TDSwitchSize.medium:
      case null:
        return 45;
      case TDSwitchSize.small:
        return 39;
    }
  }

  double _getHeight() {
    switch (widget.size) {
      case TDSwitchSize.large:
        return 32;
      case TDSwitchSize.medium:
      case null:
        return 28;
      case TDSwitchSize.small:
        return 24;
    }
  }

  Widget? _getThumbView(
    Color thumbContentOnColor,
    Color thumbContentOffColor,
    TextStyle thumbContentOnFont,
    TextStyle thumbContentOffFont,
  ) {
    switch (widget.type) {
      case TDSwitchType.text:
        return Stack(
          children: [
            Container(
              alignment: Alignment.center,
              width: 16,
              child: MyText(
                isOn
                    ? (widget.openText ?? 'Open')
                    : (widget.closeText ?? 'Close'),
                textColor: isOn ? thumbContentOnColor : thumbContentOffColor,
                maxLines: 1,
                style: isOn ? thumbContentOnFont : thumbContentOffFont,
              ),
            ),
          ],
        );
      case TDSwitchType.loading:
        return Container(
          alignment: Alignment.centerLeft,
          child: MyCircleIndicator(color: thumbContentOnColor, size: 16),
        );
      case TDSwitchType.icon:
        return Container(
          alignment: Alignment.centerLeft,
          child: Icon(
            isOn ? Icons.check_rounded : Icons.close_rounded,
            size: 16,
            color: isOn ? thumbContentOnColor : thumbContentOffColor,
          ),
        );
      case TDSwitchType.fill:
      case null:
        return null;
    }
  }
}
