import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../../index.dart';

class MyInputFormField extends MyFormBuilderField<String> {
  MyInputFormField({
    super.id,
    super.key,
    super.onSaved,
    super.forceErrorText,
    String? Function(String)? validator,
    String? initialValue,
    super.enabled,
    super.autovalidateMode,
    super.restorationId,
    this.controller,
    super.label,
    super.error,
    super.description,
    void Function(String)? onChanged,
    super.valueTransformer,
    super.onReset,
    super.focusNode,

    /// {@macro MyInput.decoration}
    MyDecoration? decoration,

    /// {@macro MyInput.placeholder}
    Widget? placeholder,

    /// {@macro MyInput.magnifierConfiguration}
    TextMagnifierConfiguration magnifierConfiguration =
        TextMagnifierConfiguration.disabled,

    /// {@macro MyInput.keyboardType}
    TextInputType? keyboardType,

    /// {@macro MyInput.textInputAction}
    TextInputAction? textInputAction,

    /// {@macro MyInput.textCapitalization}
    TextCapitalization textCapitalization = TextCapitalization.none,

    /// {@macro MyInput.style}
    TextStyle? style,

    /// {@macro MyInput.strutStyle}
    StrutStyle? strutStyle,

    /// {@macro MyInput.textAlign}
    TextAlign textAlign = TextAlign.start,

    /// {@macro MyInput.textDirection}
    TextDirection? textDirection,

    /// {@macro MyInput.autofocus}
    bool autofocus = false,

    /// {@macro MyInput.obscuringCharacter}
    String obscuringCharacter = '*',

    /// {@macro MyInput.obscureText}
    bool obscureText = false,

    /// {@macro MyInput.autocorrect}
    bool autocorrect = true,

    /// {@macro MyInput.smartDashesType}
    SmartDashesType? smartDashesType,

    /// {@macro MyInput.smartQuotesType}
    SmartQuotesType? smartQuotesType,

    /// {@macro MyInput.enableSuggestions}
    bool enableSuggestions = true,

    /// {@macro MyInput.maxLines}
    int? maxLines = 1,

    /// {@macro MyInput.minLines}
    int? minLines,

    /// {@macro MyInput.expands}
    bool expands = false,

    /// {@macro MyFormBuilderField.readOnly}
    super.readOnly,

    /// {@macro MyInput.showCursor}
    bool? showCursor,

    /// {@macro MyInput.maxLength}
    int? maxLength,

    /// {@macro MyInput.maxLengthEnforcement}
    MaxLengthEnforcement? maxLengthEnforcement,

    /// {@macro MyInput.onEditingComplete}
    VoidCallback? onEditingComplete,

    /// {@macro MyInput.onSubmitted}
    ValueChanged<String>? onSubmitted,

    /// {@macro MyInput.onAppPrivateCommand}
    AppPrivateCommandCallback? onAppPrivateCommand,

    /// {@macro MyInput.inputFormatters}
    List<TextInputFormatter>? inputFormatters,

    /// {@macro MyInput.cursorWidth}
    double? cursorWidth,

    /// {@macro MyInput.cursorHeight}
    double? cursorHeight,

    /// {@macro MyInput.cursorRadius}
    Radius? cursorRadius,

    /// {@macro MyInput.cursorOpacityAnimates}
    bool? cursorOpacityAnimates,

    /// {@macro MyInput.cursorColor}
    Color? cursorColor,

    /// {@macro MyInput.selectionHeightStyle}
    ui.BoxHeightStyle selectionHeightStyle = ui.BoxHeightStyle.tight,

    /// {@macro MyInput.selectionWidthStyle}
    ui.BoxWidthStyle selectionWidthStyle = ui.BoxWidthStyle.tight,

    /// {@macro MyInput.keyboardAppearance}
    Brightness? keyboardAppearance,

    /// {@macro MyInput.scrollPadding}
    EdgeInsets scrollPadding = const EdgeInsets.all(20),

    /// {@macro MyInput.enableInteractiveSelection}
    bool? enableInteractiveSelection,

    /// {@macro MyInput.selectionControls}
    TextSelectionControls? selectionControls,

    /// {@macro MyInput.dragStartBehavior}
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,

    /// {@macro MyInput.onPressed}
    GestureTapCallback? onPressed,

    /// {@macro MyInput.onPressedAlwaysCalled}
    bool onPressedAlwaysCalled = false,

    /// {@macro MyInput.onPressedOutside}
    TapRegionCallback? onPressedOutside,

    /// {@macro MyInput.mouseCursor}
    MouseCursor? mouseCursor,

    /// {@macro MyInput.scrollPhysics}
    ScrollPhysics? scrollPhysics,

    /// {@macro MyInput.scrollController}
    ScrollController? scrollController,

    /// {@macro MyInput.autofillHints}
    Iterable<String>? autofillHints,

    /// {@macro MyInput.clipBehavior}
    Clip clipBehavior = Clip.hardEdge,

    /// {@macro MyInput.stylusHandwritingEnabled}
    bool stylusHandwritingEnabled = true,

    /// {@macro MyInput.enableIMEPersonalizedLearning}
    bool enableIMEPersonalizedLearning = true,

    /// {@macro MyInput.contentInsertionConfiguration}
    ContentInsertionConfiguration? contentInsertionConfiguration,

    /// {@macro MyInput.contextMenuBuilder}
    EditableTextContextMenuBuilder? contextMenuBuilder,

    /// {@macro MyInput.undoController}
    UndoHistoryController? undoController,

    /// {@macro MyInput.spellCheckConfiguration}
    SpellCheckConfiguration? spellCheckConfiguration,

    /// {@macro MyInput.selectionColor}
    Color? selectionColor,

    /// {@macro MyInput.padding}
    EdgeInsetsGeometry? padding,

    /// {@macro MyInput.leading}
    Widget? leading,

    /// {@macro MyInput.trailing}
    Widget? trailing,

    /// {@macro MyInput.mainAxisAlignment}
    MainAxisAlignment? mainAxisAlignment,

    /// {@macro MyInput.crossAxisAlignment}
    CrossAxisAlignment? crossAxisAlignment,

    /// {@macro MyInput.placeholderStyle}
    TextStyle? placeholderStyle,

    /// {@macro MyInput.alignment}
    AlignmentGeometry? alignment,

    /// {@macro MyInput.placeholderAlignment}
    AlignmentGeometry? placeholderAlignment,

    /// {@macro MyInput.inputPadding}
    EdgeInsetsGeometry? inputPadding,

    /// {@macro MyInput.gap}
    double? gap,

    /// {@macro MyInput.constraints}
    BoxConstraints? constraints,

    /// {@macro flutter.widgets.editableText.groupId}
    Object? groupId,

    /// {@macro ShadKeyboardToolbar.toolbarBuilder}
    WidgetBuilder? keyboardToolbarBuilder,
  }) : super(
         initialValue: controller != null ? controller.text : initialValue,
         validator: validator == null ? null : (v) => validator(v ?? ''),
         onChanged: onChanged == null ? null : (v) => onChanged(v ?? ''),
         decorationBuilder:
             (context) => MyDecoration(
               border: MyBorder.all(
                 width: 1,
                 radius: MyBorderRadius.medium,
                 color: context.colorScheme.border,
               ),
             ).merge(decoration),
         builder: (field) {
           final state = field as _MyFormBuilderInputState;
           return MyInput(
             key: state.inputKey,
             controller: state.controller,
             restorationId: restorationId,
             enabled: state.enabled,
             focusNode: state.focusNode,
             decoration: state.decoration,
             style: style,
             cursorColor: cursorColor,
             selectionColor: selectionColor,
             keyboardType: keyboardType,
             textInputAction: textInputAction,
             textCapitalization: textCapitalization,
             autofocus: autofocus,
             obscureText: obscureText,
             autocorrect: autocorrect,
             magnifierConfiguration: magnifierConfiguration,
             smartDashesType: smartDashesType,
             smartQuotesType: smartQuotesType,
             enableSuggestions: enableSuggestions,
             maxLines: maxLines,
             minLines: minLines,
             expands: expands,
             onEditingComplete: onEditingComplete,
             onSubmitted: onSubmitted,
             onAppPrivateCommand: onAppPrivateCommand,
             inputFormatters: inputFormatters,
             cursorWidth: cursorWidth,
             cursorHeight: cursorHeight,
             cursorRadius: cursorRadius,
             selectionHeightStyle: selectionHeightStyle,
             selectionWidthStyle: selectionWidthStyle,
             scrollPadding: scrollPadding,
             dragStartBehavior: dragStartBehavior,
             scrollController: scrollController,
             scrollPhysics: scrollPhysics,
             autofillHints: autofillHints,
             clipBehavior: clipBehavior,
             stylusHandwritingEnabled: stylusHandwritingEnabled,
             enableIMEPersonalizedLearning: enableIMEPersonalizedLearning,
             contentInsertionConfiguration: contentInsertionConfiguration,
             contextMenuBuilder: contextMenuBuilder,
             selectionControls: selectionControls,
             mouseCursor: mouseCursor,
             enableInteractiveSelection: enableInteractiveSelection,
             undoController: undoController,
             spellCheckConfiguration: spellCheckConfiguration,
             placeholder: placeholder,
             onPressed: onPressed,
             onPressedAlwaysCalled: onPressedAlwaysCalled,
             onPressedOutside: onPressedOutside,
             keyboardAppearance: keyboardAppearance,
             cursorOpacityAnimates: cursorOpacityAnimates,
             readOnly: readOnly,
             strutStyle: strutStyle,
             textAlign: textAlign,
             textDirection: textDirection,
             obscuringCharacter: obscuringCharacter,
             showCursor: showCursor,
             maxLength: maxLength,
             maxLengthEnforcement: maxLengthEnforcement,
             padding: padding,
             leading: leading,
             trailing: trailing,
             mainAxisAlignment: mainAxisAlignment,
             crossAxisAlignment: crossAxisAlignment,
             alignment: alignment,
             placeholderStyle: placeholderStyle,
             placeholderAlignment: placeholderAlignment,
             inputPadding: inputPadding,
             gap: gap,
             constraints: constraints,
             groupId: groupId,
             keyboardToolbarBuilder: keyboardToolbarBuilder,
           );
         },
       );

  final TextEditingController? controller;

  @override
  MyFormBuilderFieldState<MyInputFormField, String> createState() =>
      _MyFormBuilderInputState();
}

class _MyFormBuilderInputState
    extends MyFormBuilderFieldState<MyInputFormField, String> {
  TextEditingController? _controller;

  TextEditingController get controller => widget.controller ?? _controller!;
  final GlobalKey<MyInputState> inputKey = GlobalKey<MyInputState>();

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller = TextEditingController(text: value);
    }
    controller.addListener(onControllerChanged);
  }

  @override
  void didChange(String? value) {
    super.didChange(value);
    if (controller.text != value) {
      controller.text = value ?? '';
    }
  }

  @override
  void didUpdateWidget(covariant MyInputFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller == null && widget.controller != null) {
      _controller?.dispose();
    }
    if (oldWidget.controller != null && widget.controller == null) {
      _controller = TextEditingController(text: value);
    }
  }

  @override
  void reset() {
    super.reset();
    controller.text = initialValue ?? '';
    widget.onChanged?.call(controller.text);
  }

  @override
  void dispose() {
    controller.removeListener(onControllerChanged);
    _controller?.dispose();
    super.dispose();
  }

  void onControllerChanged() {
    if (controller.text != value) {
      didChange(controller.text);
    }
  }
}
