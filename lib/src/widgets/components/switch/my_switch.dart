import 'package:flutter/material.dart';

import '../../../extensions/context/theme.dart';
import '../loading/indicators/my_loader_options.dart';
import '../loading/my_loader.dart';
import '../text/my_text.dart';
import './my_cupertino_switch.dart';

typedef OnSwitchChanged = bool Function(bool value);

enum MySwitchSize { large, medium, small }

enum MySwitchType { fill, text, loading, icon }

class MySwitch extends StatefulWidget {
  const MySwitch({
    super.key,
    this.enable = true,
    this.isOn = false,
    this.size = MySwitchSize.medium,
    this.type = MySwitchType.fill,
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
  final MySwitchSize? size;
  final MySwitchType? type;
  final OnSwitchChanged? onChanged;
  final String? openText;
  final String? closeText;

  @override
  State<StatefulWidget> createState() {
    return MySwitchState();
  }
}

class MySwitchState extends State<MySwitch> {
  bool isOn = false;

  @override
  void initState() {
    super.initState();
    isOn = widget.isOn;
  }

  @override
  void didUpdateWidget(covariant MySwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    isOn = widget.isOn;
  }

  @override
  Widget build(BuildContext context) {
    final switchEnable = widget.enable && widget.type != MySwitchType.loading;
    final trackOnColor = widget.trackOnColor ?? context.colorScheme.primary;
    final trackOffColor = widget.trackOffColor ?? context.colorScheme.secondary;
    final thumbContentOnColor =
        widget.thumbContentOnColor ?? context.colorScheme.primary;
    final thumbContentOffColor =
        widget.thumbContentOffColor ?? context.colorScheme.destructive;
    final thumbContentOnFont =
        widget.thumbContentOnFont ?? const TextStyle(fontSize: 14);
    final thumbContentOffFont =
        widget.thumbContentOffFont ?? const TextStyle(fontSize: 14);
    Widget current = MyCupertinoSwitch(
      value: isOn,
      activeColor: trackOnColor,
      trackColor: trackOffColor,
      thumbColor: context.colorScheme.background,
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
      case MySwitchSize.large:
        return 52;
      case MySwitchSize.medium:
      case null:
        return 45;
      case MySwitchSize.small:
        return 39;
    }
  }

  double _getHeight() {
    switch (widget.size) {
      case MySwitchSize.large:
        return 32;
      case MySwitchSize.medium:
      case null:
        return 28;
      case MySwitchSize.small:
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
      case MySwitchType.text:
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
      case MySwitchType.loading:
        return Align(
          alignment: Alignment.centerLeft,
          child: MyLoader(
            options: MyLoaderOptions(
              color: thumbContentOnColor,
              strokeWidth: 2,
              size: MyLoaderSize.extraSmall,
            ),
          ),
        );
      case MySwitchType.icon:
        return Container(
          alignment: Alignment.centerLeft,
          child: Icon(
            isOn ? Icons.check_rounded : Icons.close_rounded,
            size: 16,
            color: isOn ? thumbContentOnColor : thumbContentOffColor,
          ),
        );
      case MySwitchType.fill:
      case null:
        return null;
    }
  }
}
