import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../../index.dart';

const kInvisibleCharCode = '\u200b';

/// A customizable one-time password (OTP) input widget with multiple fields.
///
/// The [MyOtp] widget provides a series of input fields for entering an
/// OTP, managing focus and input across multiple single-character inputs. It
/// integrates with [MyTheme] for consistent styling and supports custom
/// formatting and behavior.
class MyOtp extends StatefulWidget {
  /// Creates an OTP input widget with the specified number of fields and
  /// children.
  const MyOtp({
    required this.maxLength,
    required this.children,
    super.key,
    this.enabled = true,
    this.gap,
    this.jumpToNextWhenFilled = true,
    this.onChanged,
    this.inputFormatters,
    this.keyboardType,
    this.initialValue,
  });

  /// {@template MyOtp.maxLength}
  /// The maximum length of the OTP
  /// {@endtemplate}
  final int maxLength;

  /// {@template MyOtp.enabled}
  /// Whether the input is enabled, defaults to true
  /// {@endtemplate}
  final bool enabled;

  /// {@template MyOtp.gap}
  /// The gap between each slot, defaults to 8
  /// {@endtemplate}
  final double? gap;

  /// {@template MyOtp.children}
  /// The children of the input otp
  /// {@endtemplate}
  final List<Widget> children;

  /// {@template MyOtp.jumpToNextWhenFilled}
  /// Whether to jump to the next slot when the current slot is filled,
  /// defaults to true
  /// {@endtemplate}
  final bool jumpToNextWhenFilled;

  /// {@template MyOtp.onChanged}
  /// Called when the value of the OTP changes
  /// {@endtemplate}
  final ValueChanged<String>? onChanged;

  /// {@template MyOtp.inputFormatters}
  /// The input formatters for the input of each slot, unless overridden in the
  /// slot
  /// {@endtemplate}
  final List<TextInputFormatter>? inputFormatters;

  /// {@template MyOtp.keyboardType}
  /// The keyboard type for the input of each slot, unless overridden in the
  /// slot
  /// {@endtemplate}
  final TextInputType? keyboardType;

  /// {@template MyOtp.initialValue}
  /// The initial value of the OTP, to skip one slot pass an empty space
  /// {@endtemplate}
  final String? initialValue;

  @override
  State<MyOtp> createState() => MyOtpState();
}

class MyOtpState extends State<MyOtp> {
  final registeredOTPs =
      <({FocusNode focusNode, TextEditingController controller})>[];

  late Listenable listenable;

  late final values = List<String>.filled(widget.maxLength, '');

  late final ValueNotifier<String> result;

  int groups = 0;

  @override
  void initState() {
    super.initState();
    result = ValueNotifier(
      (widget.initialValue ?? '').padRight(widget.maxLength),
    );
    result.addListener(() {
      widget.onChanged?.call(result.value);
    });
  }

  @override
  void dispose() {
    result.dispose();
    super.dispose();
  }

  // Call this method to register a slot, returns the index of the slot
  int registerSlot({
    required FocusNode focusNode,
    required TextEditingController controller,
  }) {
    registeredOTPs.add((focusNode: focusNode, controller: controller));

    final index = registeredOTPs.length - 1;

    // Set the initial value of the slot
    if (controller.text == kInvisibleCharCode && result.value[index] != ' ') {
      controller.text = result.value[index];
    }

    listenToSlot(index);
    return index;
  }

  @override
  void didUpdateWidget(covariant MyOtp oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      final value = (widget.initialValue ?? '').padRight(widget.maxLength);
      for (var index = 0; index < registeredOTPs.length; index++) {
        final slot = registeredOTPs[index];
        // Set the initial value of the slot
        if (slot.controller.text == kInvisibleCharCode && value[index] != ' ') {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            slot.controller.text = value[index];
          });
        }
      }
    }
  }

  // Call this method to register a group, returns the index of the group
  int registerGroup() {
    groups++;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
    return groups - 1;
  }

  void listenToSlot(int index) {
    final slot = registeredOTPs[index];

    slot.controller.addListener(() {
      final text = (slot.controller.text.split('').lastOrNull ??
              kInvisibleCharCode)
          .replaceAll(kInvisibleCharCode, ' ');
      values[index] = text;

      final wholeValue = values.reduce((value, element) {
        final parsedElement = element.isEmpty ? ' ' : element;
        return value + parsedElement;
      });
      result.value = wholeValue;
    });
  }

  void jumpToSlot(int index, {bool clear = false}) {
    if (!widget.jumpToNextWhenFilled) return;
    if (index < registeredOTPs.length) {
      final nextSlot = registeredOTPs[index];
      nextSlot.focusNode.requestFocus();
      if (clear) nextSlot.controller.text = kInvisibleCharCode;
    }
  }

  void jumpToNextSlot() {
    final focusedSlotIndex = registeredOTPs.indexWhere(
      (slot) => slot.focusNode.hasFocus,
    );
    if (focusedSlotIndex == registeredOTPs.length - 1) return;
    jumpToSlot(focusedSlotIndex + 1);
  }

  void jumpToPreviousSlot({bool clear = false}) {
    final focusedSlotIndex = registeredOTPs.indexWhere(
      (slot) => slot.focusNode.hasFocus,
    );
    if (focusedSlotIndex == 0) return;
    jumpToSlot(focusedSlotIndex - 1, clear: clear);
  }

  void setValues(String values) {
    for (var i = 0; i < values.length; i++) {
      final slot = registeredOTPs[i];
      slot.controller.text = values[i];
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveGap = widget.gap ?? 8;

    return MyProvider(
      data: this,
      child: MyDisabled(
        disabled: !widget.enabled,
        child: Row(
          spacing: effectiveGap,
          textDirection: TextDirection.ltr,
          mainAxisSize: MainAxisSize.min,
          children: widget.children,
        ),
      ),
      notifyUpdate: (_) => true,
    );
  }
}

class MyOtpGroup extends StatefulWidget {
  const MyOtpGroup({required this.children, super.key});

  final List<Widget> children;

  @override
  State<MyOtpGroup> createState() => _MyOtpGroupState();
}

class _MyOtpGroupState extends State<MyOtpGroup> {
  late final otpProvider = context.read<MyOtpState>();

  @override
  void initState() {
    super.initState();
    otpProvider.registerGroup();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.ltr,
      mainAxisSize: MainAxisSize.min,
      children: widget.children,
    );
  }
}

class MyOtpSlot extends StatefulWidget {
  const MyOtpSlot({
    super.key,
    this.focusNode,
    this.controller,
    this.inputFormatters,
    this.keyboardType,
    this.style,
    this.width,
    this.height,
    this.decoration,
    this.firstRadius,
    this.lastRadius,
    this.singleRadius,
    this.middleRadius,
    this.initialValue,
    this.textInputAction,
    this.keyboardToolbarBuilder,
  });

  /// {@template MyOtpSlot.focusNode}
  /// The focus node for the input of the slot
  /// {@endtemplate}
  final FocusNode? focusNode;

  /// {@template MyOtpSlot.controller}
  /// The controller for the input of the slot
  /// {@endtemplate}
  final TextEditController? controller;

  /// {@template MyOtpSlot.inputFormatters}
  /// The input formatters for the input of the slot
  /// {@endtemplate}
  final List<TextInputFormatter>? inputFormatters;

  /// {@template MyOtpSlot.keyboardType}
  /// The keyboard type for the input of the slot
  /// {@endtemplate}
  final TextInputType? keyboardType;

  /// {@template MyOtpSlot.style}
  /// The style for the input of the slot, defaults to
  /// ```dart
  /// textTheme.muted.copyWith(
  ///    color: theme.colorScheme.foreground,
  ///    fontFamily: kDefaultFontFamilyMono,
  ///  )
  /// ```
  /// {@endtemplate}
  final TextStyle? style;

  /// {@template MyOtpSlot.width}
  /// The width of the slot, defaults to 40
  /// {@endtemplate}
  final double? width;

  /// {@template MyOtpSlot.height}
  /// The height of the slot, defaults to 40
  /// {@endtemplate}
  final double? height;

  /// {@template MyOtpSlot.decoration}
  /// The decoration of the slot
  /// {@endtemplate}
  final MyDecoration? decoration;

  /// {@template MyOtpSlot.firstRadius}
  /// The radius applied to the first slot of each group
  /// {@endtemplate}
  final BorderRadius? firstRadius;

  /// {@template MyOtpSlot.lastRadius}
  /// The radius applied to the last slot of each group
  /// {@endtemplate}
  final BorderRadius? lastRadius;

  /// {@template MyOtpSlot.singleRadius}
  /// The radius applied to the single slot of each group.
  /// Used only if the group has only one slot
  /// {@endtemplate}
  final BorderRadius? singleRadius;

  /// {@template MyOtpSlot.middleRadius}
  /// The radius applied to the middle slots of each group.
  /// If there are 4 slots in a group, the middle slots are the 2nd and 3rd
  /// {@endtemplate}
  final BorderRadius? middleRadius;

  /// {@template MyOtpSlot.initialValue}
  /// The initial value of the slot.
  /// {@endtemplate}
  final String? initialValue;

  /// {@template MyOtpSlot.textInputAction}
  /// The text input action for the slot, defaults to null
  /// {@endtemplate}
  final TextInputAction? textInputAction;

  /// {@macro MyKeyboardToolbar.toolbarBuilder}
  final WidgetBuilder? keyboardToolbarBuilder;

  @override
  State<MyOtpSlot> createState() => _MyOtpSlotState();
}

class _MyOtpSlotState extends State<MyOtpSlot> {
  late final otpProvider = context.read<MyOtpState>();

  FocusNode? _focusNode;
  FocusNode get focusNode => widget.focusNode ?? _focusNode!;
  TextEditController? _controller;
  TextEditController get controller => widget.controller ?? _controller!;
  late final int index;

  @override
  void initState() {
    super.initState();
    if (widget.focusNode == null) {
      _focusNode = FocusNode(
        onKeyEvent: (node, event) {
          // Handle the arrow keys
          if (event is KeyUpEvent) return KeyEventResult.ignored;
          if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
            otpProvider.jumpToPreviousSlot();
            return KeyEventResult.handled;
          }
          if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
            otpProvider.jumpToNextSlot();
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
      );
    }
    if (widget.controller == null) {
      _controller = TextEditController();
    }

    controller.text = widget.initialValue ?? kInvisibleCharCode;
    index = otpProvider.registerSlot(
      focusNode: focusNode,
      controller: controller,
    );
  }

  @override
  void dispose() {
    _focusNode?.dispose();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = MyTheme.of(context);

    // Watching the OTP provider for changes
    final otpProvider = context.watch<MyOtpState>();

    final defaultStyle =
        widget.style ??
        context.bodyMedium.copyWith(
          color: theme.colorScheme.foreground,
          fontFamily: MyTypography.kDefaultFontFamilyMono,
        );

    final firstRadius =
        widget.firstRadius ??
        BorderRadius.only(
          topLeft: MyBorderRadius.medium.topLeft,
          bottomLeft: MyBorderRadius.medium.bottomLeft,
        );

    final lastRadius =
        widget.lastRadius ??
        BorderRadius.only(
          topRight: MyBorderRadius.medium.topRight,
          bottomRight: MyBorderRadius.medium.bottomRight,
        );

    final singleRadius = widget.singleRadius ?? MyBorderRadius.medium;

    final middleRadius = widget.middleRadius ?? BorderRadius.zero;

    final lastIndexForGroup = otpProvider.widget.maxLength / otpProvider.groups;
    final isLastInGroup = (index + 1) % lastIndexForGroup == 0;

    final isFirstInGroup = index % lastIndexForGroup == 0;

    final BorderRadius effectiveRadius;

    if (isFirstInGroup && isLastInGroup) {
      // Radius on all the sides
      effectiveRadius = singleRadius;
    } else {
      if (isFirstInGroup) {
        // only first side radius
        effectiveRadius = firstRadius;
      } else if (isLastInGroup) {
        // only last side radius
        effectiveRadius = lastRadius;
      } else {
        // middle radius
        effectiveRadius = middleRadius;
      }
    }
    final effectiveInputFormatters =
        widget.inputFormatters ?? otpProvider.widget.inputFormatters ?? [];

    final effectiveKeyboardType =
        widget.keyboardType ?? otpProvider.widget.keyboardType;

    final effectiveWidth = widget.width ?? 40.0;
    final effectiveHeight = widget.height ?? 40.0;

    final defaultDecoration = MyDecoration(
      disableSecondaryBorder: true,
      focusedBorder: MyBorder.all(color: theme.colorScheme.ring, width: 2),
      border: MyBorder(
        top: MyBorderSide(color: theme.colorScheme.border, width: 1),
        bottom: MyBorderSide(color: theme.colorScheme.border, width: 1),
        right: MyBorderSide(color: theme.colorScheme.border, width: 1),
        padding: const EdgeInsets.all(1),
      ),
    );
    final effectiveDecoration = defaultDecoration
        .merge(widget.decoration)
        .merge(
          MyDecoration(
            border: MyBorder(
              radius: effectiveRadius,
              left:
                  isFirstInGroup
                      ? MyBorderSide(color: theme.colorScheme.border, width: 1)
                      : MyBorderSide.none,
            ),
            focusedBorder: MyBorder(radius: effectiveRadius),
          ),
        );

    return SizedBox(
      width: effectiveWidth,
      height: effectiveHeight,
      child: Align(
        child: MyInput(
          focusNode: focusNode,
          controller: controller,
          decoration: effectiveDecoration,
          textAlign: TextAlign.center,
          textInputAction: widget.textInputAction,
          onChanged: (v) {
            // sanitize the text and format it
            var sanitizedV = v.replaceAll(kInvisibleCharCode, '');
            final result = TextEditingValue(text: sanitizedV);
            final formattedValue = effectiveInputFormatters
                .fold<TextEditingValue>(
                  result,
                  (TextEditingValue newValue, TextInputFormatter formatter) =>
                      formatter.formatEditUpdate(result, newValue),
                );

            final hasBeenFormatted = formattedValue.text != sanitizedV;
            sanitizedV = formattedValue.text;

            // if the value is more than 1 and the slot is not the first
            // get the last character from the value
            if (index != 0 && sanitizedV.length > 1) {
              sanitizedV = sanitizedV[sanitizedV.length - 1];
            }
            // if the max length is entered, set the values
            // to all the slots
            // this condition happens only for the first slot
            if (sanitizedV.length > 1) {
              otpProvider
                ..setValues(sanitizedV)
                ..jumpToSlot(sanitizedV.length - 1);
            } else {
              if (sanitizedV.isEmpty) {
                final previousText = controller.previous?.text ?? '';
                controller.text = kInvisibleCharCode;
                // Jump to the previous slot only if the formatter was not
                // applied
                if (!hasBeenFormatted) {
                  otpProvider.jumpToPreviousSlot(
                    clear: previousText == kInvisibleCharCode,
                  );
                }
              } else {
                final newText = sanitizedV[sanitizedV.length - 1];
                controller.value = controller.value.copyWith(
                  text: newText,
                  selection: TextSelection.collapsed(offset: newText.length),
                  composing: TextRange.empty,
                );
                otpProvider.jumpToNextSlot();
              }
            }
          },
          maxLength: otpProvider.widget.maxLength + 1,
          maxLengthEnforcement:
              MaxLengthEnforcement.truncateAfterCompositionEnds,
          style: defaultStyle,
          keyboardType: effectiveKeyboardType,
          keyboardToolbarBuilder: widget.keyboardToolbarBuilder,
          buildCounter: MyInput.noCounter,
        ),
      ),
    );
  }
}
