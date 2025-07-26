import 'dart:nativewrappers/_internal/vm/lib/ffi_allocation_patch.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../common_tools.dart';

enum TDStepperSize { small, medium, large }

enum TDStepperTheme { normal, filled, outline }

enum TDStepperIconType { remove, add }

enum TDStepperOverlimitType { minus, plus }

typedef TDStepperOverlimitFunction = void Function(TDStepperOverlimitType type);

class TDStepper extends StatefulWidget {
  const TDStepper({
    super.key,
    this.disableInput = false,
    this.disabled = false,
    this.inputWidth,
    this.max = 100,
    this.min = 0,
    this.size = TDStepperSize.medium,
    this.step = 1,
    this.theme = TDStepperTheme.normal,
    this.value = 0,
    this.defaultValue = 0,
    this.onBlur,
    this.onChange,
    this.onOverlimit,
  });

  final bool disableInput;

  final bool disabled;

  final double? inputWidth;

  final int max;

  final int min;

  final TDStepperSize size;

  final int step;

  final TDStepperTheme theme;

  final int? value;

  final int? defaultValue;

  final VoidCallback? onBlur;

  final ValueChanged<int>? onChange;

  final TDStepperOverlimitFunction? onOverlimit;

  @override
  State<TDStepper> createState() => _TDStepperState();
}

class _TDStepperState extends State<TDStepper> {
  late int value;
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    value = widget.value ?? widget.defaultValue ?? 0;
    _controller = TextEditingController(text: value.toString());

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) widget.onBlur?.call();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  double _getWidth() {
    if (widget.inputWidth != null && widget.inputWidth! > 0) {
      return widget.inputWidth!;
    }

    return switch (widget.size) {
      TDStepperSize.small => 34,
      TDStepperSize.medium => 38,
      TDStepperSize.large => 45,
    };
  }

  double _getTextWidth() {
    final textLength = value.toString().length;
    return textLength < 4 ? 0 : (textLength - 4) * _getFontSize();
  }

  double _getHeight() {
    return switch (widget.size) {
      TDStepperSize.small => 20,
      TDStepperSize.medium => 24,
      TDStepperSize.large => 28,
    };
  }

  Color? _getBackgroundColor(BuildContext context) {
    switch (widget.theme) {
      case TDStepperTheme.filled:
        return widget.disabled
            ? ThemeColors.neutral.shade100
            : ThemeColors.neutral.shade50;
      case TDStepperTheme.outline:
        return Colors.white;
      case TDStepperTheme.normal:
    }

    return null;
  }

  double _getFontSize() {
    return switch (widget.size) {
      TDStepperSize.small => 10,
      TDStepperSize.medium => 12,
      TDStepperSize.large => 16,
    };
  }

  void onAdd() {
    if (value >= widget.max) return;

    if (value + widget.step > widget.max) {
      setState(() => value = widget.max);

      widget.onOverlimit?.call(TDStepperOverlimitType.plus);

      renderNumber();

      return;
    }

    setState(() => value += widget.step);

    renderNumber();
  }

  void onReduce() {
    if (value <= widget.min) return;

    if (value - widget.step < widget.min) {
      setState(() => value = widget.min);

      widget.onOverlimit?.call(TDStepperOverlimitType.minus);

      renderNumber();

      return;
    }

    setState(() => value -= widget.step);

    renderNumber();
  }

  void renderNumber() {
    _controller.value = TextEditingValue(
      text: value.toString(),
      selection: TextSelection.fromPosition(
        TextPosition(offset: value.toString().length),
      ),
    );
    _focusNode.unfocus();

    widget.onChange?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TDStepperIconButton(
          type: TDStepperIconType.remove,
          disabled: widget.disabled || value <= widget.min,
          theme: widget.theme,
          size: widget.size,
          onTap: onReduce,
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            border:
                widget.theme == TDStepperTheme.outline
                    ? Border(
                      top: BorderSide(color: ThemeColors.neutral.shade300),
                      bottom: BorderSide(color: ThemeColors.neutral.shade300),
                    )
                    : null,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: widget.theme == TDStepperTheme.normal ? 0 : 4,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: _getWidth(),
                maxWidth: _getWidth() + _getTextWidth(),
              ),
              child: Container(
                height: _getHeight(),
                alignment: Alignment.center,
                decoration: BoxDecoration(color: _getBackgroundColor(context)),
                child: Container(
                  height: PlatformChecker.isWeb ? _getFontSize() : null,
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: TextField(
                    controller: _controller,
                    enabled: !widget.disabled && !widget.disableInput,
                    focusNode: _focusNode,
                    style: TextStyle(
                      fontSize: _getFontSize(),
                      color:
                          widget.disabled
                              ? ThemeColors.neutral.shade600
                              : ThemeColors.neutral.shade900,
                    ),
                    textAlign: TextAlign.center,
                    textAlignVertical: TextAlignVertical.center,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      TextInputFormatter.withFunction((oldValue, newValue) {
                        try {
                          if (newValue.text == '') {
                            setState(() => value = widget.min);

                            widget.onOverlimit?.call(
                              TDStepperOverlimitType.minus,
                            );

                            return newValue.copyWith(
                              text: value.toString(),
                              selection: TextSelection.collapsed(
                                offset: value.toString().length,
                              ),
                            );
                          }

                          final newNum = int.parse(newValue.text);

                          if (newNum < widget.min) {
                            setState(() => value = widget.min);

                            widget.onOverlimit?.call(
                              TDStepperOverlimitType.minus,
                            );
                          } else if (newNum > widget.max) {
                            setState(() => value = widget.max);
                            widget.onOverlimit?.call(
                              TDStepperOverlimitType.plus,
                            );
                          } else {
                            setState(() => value = newNum);
                          }

                          return newValue.copyWith(
                            text: value.toString(),
                            selection: TextSelection.collapsed(
                              offset: value.toString().length,
                            ),
                          );
                        } catch (e) {
                          return oldValue;
                        }
                      }),
                    ],
                    onChanged: (newValue) {
                      final result = int.parse(newValue);
                      widget.onChange?.call(result);
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
        TDStepperIconButton(
          type: TDStepperIconType.add,
          disabled: widget.disabled || value >= widget.max,
          theme: widget.theme,
          size: widget.size,
          onTap: onAdd,
        ),
      ],
    );
  }
}

typedef TDTapFunction = void Function();

class TDStepperIconButton extends StatelessWidget {
  const TDStepperIconButton({
    required this.type,
    super.key,
    this.onTap,
    this.size = TDStepperSize.medium,
    this.disabled = false,
    this.theme = TDStepperTheme.normal,
  });

  final TDTapFunction? onTap;
  final TDStepperSize size;
  final TDStepperIconType type;
  final bool disabled;
  final TDStepperTheme theme;

  double _getIconSize() {
    return switch (size) {
      TDStepperSize.small => 12,
      TDStepperSize.medium => 16,
      TDStepperSize.large => 20,
    };
  }

  Icon _getIcon(context) {
    final iconType = type == TDStepperIconType.add ? Icons.add : Icons.remove;

    return Icon(
      iconType,
      size: _getIconSize(),
      color:
          disabled
              ? ThemeColors.neutral.shade600
              : ThemeColors.neutral.shade900,
    );
  }

  Color? _getBackgroundColor(BuildContext context) {
    switch (theme) {
      case TDStepperTheme.filled:
        return disabled
            ? ThemeColors.neutral.shade100
            : ThemeColors.neutral.shade50;
      case TDStepperTheme.outline:
        return disabled ? ThemeColors.neutral.shade100 : null;
      case TDStepperTheme.normal:
    }
    return null;
  }

  BorderRadiusGeometry? _getBorderRadius(BuildContext context) {
    if (theme == TDStepperTheme.normal) return null;

    return type == TDStepperIconType.remove
        ? const BorderRadius.only(
          topLeft: Radius.circular(3),
          bottomLeft: Radius.circular(3),
        )
        : const BorderRadius.only(
          topRight: Radius.circular(3),
          bottomRight: Radius.circular(3),
        );
  }

  BoxBorder? _getBoxBorder(BuildContext context) {
    if (theme == TDStepperTheme.outline) {
      return Border.all(color: ThemeColors.neutral.shade300);
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: disabled ? null : onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: _getBackgroundColor(context),
          borderRadius: _getBorderRadius(context),
          border: _getBoxBorder(context),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: _getIcon(context),
        ),
      ),
    );
  }
}
