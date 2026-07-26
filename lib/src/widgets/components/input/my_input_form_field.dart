import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../../constants/my_radius.dart';
import '../../../extensions/context/theme.dart';
import '../../common/my_border.dart';
import '../../common/my_decoration.dart';
import '../../form/field.dart';
import './my_input.dart';

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
    String? placeholder,

    /// {@macro MyInput.keyboardType}
    TextInputType? keyboardType,

    /// {@macro MyInput.textInputAction}
    TextInputAction? textInputAction,

    /// {@macro MyInput.textCapitalization}
    TextCapitalization textCapitalization = TextCapitalization.none,

    /// {@macro MyInput.style}
    TextStyle? style,

    /// {@macro MyInput.textAlign}
    TextAlign textAlign = TextAlign.start,

    /// {@macro MyInput.textDirection}
    TextDirection? textDirection,

    /// {@macro MyInput.autofocus}
    bool autofocus = false,

    /// {@macro MyInput.obscuringCharacter}
    String obscuringCharacter = '•',

    /// {@macro MyInput.obscureText}
    bool obscureText = false,

    /// {@macro MyInput.autocorrect}
    bool autocorrect = true,

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

    /// {@macro MyInput.scrollPadding}
    EdgeInsets scrollPadding = const EdgeInsets.all(20),

    /// {@macro MyInput.enableInteractiveSelection}
    bool? enableInteractiveSelection,

    /// {@macro flutter.widgets.editableText.selectAllOnFocus}
    bool? selectAllOnFocus,

    /// {@macro MyInput.selectionControls}
    TextSelectionControls? selectionControls,

    /// {@macro MyInput.dragStartBehavior}
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,

    /// {@macro MyInput.onTap}
    GestureTapCallback? onTap,

    /// {@macro MyInput.onTapAlwaysCalled}
    bool onTapAlwaysCalled = false,

    /// {@macro MyInput.onTapOutside}
    TapRegionCallback? onTapOutside,

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

    /// {@macro MyInput.leading}
    Widget? leading,

    /// {@macro MyInput.trailing}
    Widget? trailing,

    /// {@macro MyInput.placeholderStyle}
    TextStyle? placeholderStyle,

    /// {@macro flutter.widgets.editableText.groupId}
    Object? groupId,

    /// {@macro ShadKeyboardToolbar.toolbarBuilder}
    WidgetBuilder? keyboardToolbarBuilder,
  }) : super(
         initialValue: controller != null ? controller.text : initialValue,
         validator: validator == null ? null : (v) => validator(v ?? ''),
         onChanged: onChanged == null ? null : (v) => onChanged(v ?? ''),
         decorationBuilder: (context) => MyDecoration(
           border: MyBorder.all(
             width: 1.5,
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
             keyboardType: keyboardType,
             textInputAction: textInputAction,
             textCapitalization: textCapitalization,
             autofocus: autofocus,
             obscureText: obscureText,
             autocorrect: autocorrect,
             enableSuggestions: enableSuggestions,
             maxLines: maxLines,
             minLines: minLines,
             expands: expands,
             onEditingComplete: onEditingComplete,
             onSubmitted: onSubmitted,
             onAppPrivateCommand: onAppPrivateCommand,
             inputFormatters: inputFormatters,
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
             selectAllOnFocus: selectAllOnFocus,
             selectionControls: selectionControls,
             mouseCursor: mouseCursor,
             enableInteractiveSelection: enableInteractiveSelection,
             undoController: undoController,
             spellCheckConfiguration: spellCheckConfiguration,
             placeholder: placeholder,
             onTap: onTap,
             onTapAlwaysCalled: onTapAlwaysCalled,
             onTapOutside: onTapOutside,
             readOnly: readOnly,
             textAlign: textAlign,
             textDirection: textDirection,
             obscuringCharacter: obscuringCharacter,
             maxLength: maxLength,
             maxLengthEnforcement: maxLengthEnforcement,
             leading: leading,
             trailing: trailing,
             placeholderStyle: placeholderStyle,
             groupId: groupId ?? EditableText,
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
