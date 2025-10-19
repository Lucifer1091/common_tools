import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../index.dart';

enum MyStepperSize { small, medium, large }

enum MyStepperTheme { normal, filled, outline }

enum MyStepperIconType { remove, add }

enum MyStepperOverlimitType { minus, plus }

enum MyStepperEventType { cleanValue }

typedef MyStepperOverlimitFunction = void Function(MyStepperOverlimitType type);

class MyStepperController {
  _MyStepperState? _state;

  int _value = 0;
  int get value => _value;

  set value(int value) {
    _value = value;
    _state?.updateUI();
  }

  // ignore: use_setters_to_change_properties
  void bindState(_MyStepperState tdStepperState) {
    _state = tdStepperState;
  }
}

class MyStepper extends StatefulWidget {
  const MyStepper({
    super.key,
    this.disableInput = false,
    this.disabled = false,
    this.inputWidth,
    this.eventController,
    this.max = 100,
    this.min = 0,
    this.size = MyStepperSize.medium,
    this.step = 1,
    this.theme = MyStepperTheme.normal,
    this.value = 0,
    this.defaultValue = 0,
    this.onBlur,
    this.onChange,
    this.onOverlimit,
    this.controller,
  });

  final bool disableInput;
  final bool disabled;
  final double? inputWidth;
  final int max;
  final int min;
  final MyStepperSize size;
  final int step;
  final MyStepperTheme theme;
  final int? value;
  final int? defaultValue;
  final VoidCallback? onBlur;
  final ValueChanged<int>? onChange;
  final MyStepperOverlimitFunction? onOverlimit;
  final StreamController<MyStepperEventType>? eventController;
  final MyStepperController? controller;

  @override
  State<MyStepper> createState() => _MyStepperState();
}

class _MyStepperState extends State<MyStepper> {
  late int value;
  late MyStepperController _controller;
  late TextEditingController _textController;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller =
          MyStepperController()
            ..value = widget.value ?? widget.defaultValue ?? 0;
    }
    _controller.bindState(this);

    if (widget.eventController != null) {
      widget.eventController?.stream.listen((MyStepperEventType event) {
        if (event == MyStepperEventType.cleanValue) {
          cleanValue();
        }
      });
    }
    _textController = TextEditingController(
      text: _controller._value.toString(),
    );

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) widget.onBlur?.call();
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  double _getWidth() {
    if (widget.inputWidth != null && widget.inputWidth! > 0) {
      return widget.inputWidth!;
    }

    return switch (widget.size) {
      MyStepperSize.small => 34,
      MyStepperSize.medium => 38,
      MyStepperSize.large => 45,
    };
  }

  double _getTextWidth() {
    final textLength = _controller._value.toString().length;
    return textLength < 4 ? 0 : (textLength - 4) * _getFontSize();
  }

  double _getHeight() {
    return switch (widget.size) {
      MyStepperSize.small => 20,
      MyStepperSize.medium => 24,
      MyStepperSize.large => 28,
    };
  }

  Color? _getBackgroundColor(BuildContext context) {
    switch (widget.theme) {
      case MyStepperTheme.filled:
        return widget.disabled
            ? context.colorScheme.muted
            : context.colorScheme.secondary;
      case MyStepperTheme.outline:
        return Colors.transparent;
      case MyStepperTheme.normal:
    }

    return null;
  }

  double _getFontSize() {
    return switch (widget.size) {
      MyStepperSize.small => 10,
      MyStepperSize.medium => 12,
      MyStepperSize.large => 16,
    };
  }

  void onAdd() {
    if (_controller._value >= widget.max) return;

    if (_controller._value + widget.step > widget.max) {
      setState(() => _controller._value = widget.max);

      widget.onOverlimit?.call(MyStepperOverlimitType.plus);

      renderNumber();

      return;
    }

    setState(() => _controller._value += widget.step);

    renderNumber();
  }

  void onReduce() {
    if (_controller._value <= widget.min) return;

    if (_controller._value - widget.step < widget.min) {
      setState(() => _controller._value = widget.min);

      widget.onOverlimit?.call(MyStepperOverlimitType.minus);

      renderNumber();

      return;
    }

    setState(() => _controller._value -= widget.step);

    renderNumber();
  }

  void cleanValue() {
    _controller._value = 0;
    _textController.value = TextEditingValue(
      text: _controller._value.toString(),
      selection: TextSelection.fromPosition(
        TextPosition(offset: _controller._value.toString().length),
      ),
    );
    _focusNode.unfocus();
  }

  void renderNumber() {
    _textController.value = TextEditingValue(
      text: _controller._value.toString(),
      selection: TextSelection.fromPosition(
        TextPosition(offset: _controller._value.toString().length),
      ),
    );
    _focusNode.unfocus();

    widget.onChange?.call(_controller._value);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MyStepperIconButton(
          type: MyStepperIconType.remove,
          disabled: widget.disabled || _controller._value <= widget.min,
          theme: widget.theme,
          size: widget.size,
          onTap: onReduce,
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            border:
                widget.theme == MyStepperTheme.outline
                    ? Border(
                      top: BorderSide(color: context.colorScheme.border),
                      bottom: BorderSide(color: context.colorScheme.border),
                    )
                    : null,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: widget.theme == MyStepperTheme.normal ? 0 : 4,
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
                  height: MyPlatform.isWeb ? _getFontSize() : null,
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: TextField(
                    controller: _textController,
                    enabled: !widget.disabled && !widget.disableInput,
                    focusNode: _focusNode,
                    style: context.bodyMedium.copyWith(
                      fontSize: _getFontSize(),
                      color:
                          widget.disabled
                              ? context.colorScheme.mutedForeground
                              : context.colorScheme.secondaryForeground,
                    ),
                    textAlign: TextAlign.center,
                    textAlignVertical: TextAlignVertical.top,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      TextInputFormatter.withFunction((oldValue, newValue) {
                        try {
                          if (newValue.text == '') {
                            setState(() => _controller._value = widget.min);

                            widget.onOverlimit?.call(
                              MyStepperOverlimitType.minus,
                            );

                            return newValue.copyWith(
                              text: _controller._value.toString(),
                              selection: TextSelection.collapsed(
                                offset: _controller._value.toString().length,
                              ),
                            );
                          }

                          final newNum = int.parse(newValue.text);

                          if (newNum < widget.min) {
                            setState(() => _controller._value = widget.min);

                            widget.onOverlimit?.call(
                              MyStepperOverlimitType.minus,
                            );
                          } else if (newNum > widget.max) {
                            setState(() => _controller._value = widget.max);
                            widget.onOverlimit?.call(
                              MyStepperOverlimitType.plus,
                            );
                          } else {
                            setState(() => _controller._value = newNum);
                          }

                          return newValue.copyWith(
                            text: _controller._value.toString(),
                            selection: TextSelection.collapsed(
                              offset: _controller._value.toString().length,
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
        MyStepperIconButton(
          type: MyStepperIconType.add,
          disabled: widget.disabled || _controller._value >= widget.max,
          theme: widget.theme,
          size: widget.size,
          onTap: onAdd,
        ),
      ],
    );
  }

  void updateUI() {
    if (mounted) {
      _textController.value = TextEditingValue(
        text: _controller._value.toString(),
        selection: TextSelection.fromPosition(
          TextPosition(offset: _controller._value.toString().length),
        ),
      );
    }
  }
}

class MyStepperIconButton extends StatelessWidget {
  const MyStepperIconButton({
    required this.type,
    super.key,
    this.onTap,
    this.size = MyStepperSize.medium,
    this.disabled = false,
    this.theme = MyStepperTheme.normal,
  });

  final VoidCallback? onTap;
  final MyStepperSize size;
  final MyStepperIconType type;
  final bool disabled;
  final MyStepperTheme theme;

  double _getIconSize() {
    return switch (size) {
      MyStepperSize.small => 12,
      MyStepperSize.medium => 16,
      MyStepperSize.large => 20,
    };
  }

  Icon _getIcon(BuildContext context) {
    final iconType = type == MyStepperIconType.add ? Icons.add : Icons.remove;

    return Icon(
      iconType,
      size: _getIconSize(),
      color:
          disabled
              ? context.colorScheme.mutedForeground
              : context.colorScheme.secondaryForeground,
    );
  }

  Color? _getBackgroundColor(BuildContext context) {
    switch (theme) {
      case MyStepperTheme.filled:
        return disabled
            ? context.colorScheme.muted
            : context.colorScheme.secondary;
      case MyStepperTheme.outline:
        return disabled ? context.colorScheme.muted : null;
      case MyStepperTheme.normal:
    }
    return null;
  }

  BorderRadiusGeometry? _getBorderRadius(BuildContext context) {
    if (theme == MyStepperTheme.normal) return null;

    return type == MyStepperIconType.remove
        ? const BorderRadius.only(
          topLeft: MyRadi.small,
          bottomLeft: MyRadi.small,
        )
        : const BorderRadius.only(
          topRight: MyRadi.small,
          bottomRight: MyRadi.small,
        );
  }

  BoxBorder? _getBoxBorder(BuildContext context) {
    if (theme == MyStepperTheme.outline) {
      return Border.all(color: context.colorScheme.border);
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MyGestureDetector(
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
