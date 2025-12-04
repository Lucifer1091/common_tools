import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import '../../../index.dart';

class MyTextareaFormField extends MyFormBuilderField<String> {
  MyTextareaFormField({
    super.key,
    super.id,
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
    super.valueTransformer,
    super.onReset,
    super.focusNode,
    void Function(String)? onChanged,

    /// {@macro MyTextarea.decoration}
    MyDecoration? decoration,

    /// {@macro MyTextarea.placeholder}
    String? placeholder,

    /// {@macro MyTextarea.placeholderStyle}
    TextStyle? placeholderStyle,

    /// {@macro MyTextarea.placeholderAlignment}
    AlignmentGeometry? placeholderAlignment,

    /// {@macro MyTextarea.constraints}
    BoxConstraints? constraints,

    /// {@macro MyTextarea.readOnly}
    bool readOnly = false,

    /// {@macro MyTextarea.autofocus}
    bool autofocus = false,

    /// {@macro MyTextarea.onTapAlwaysCalled}
    bool onTapAlwaysCalled = false,

    /// {@macro MyTextarea.onTapOutside}
    TapRegionCallback? onTapOutside,

    /// {@macro MyTextarea.onTap}
    GestureTapCallback? onTap,

    /// {@macro MyTextarea.scrollController}
    ScrollController? scrollController,

    /// {@macro MyTextarea.scrollPhysics}
    ScrollPhysics? scrollPhysics,

    /// {@macro MyTextarea.mouseCursor}
    MouseCursor? mouseCursor,

    /// {@macro MyTextarea.textDirection}
    TextDirection? textDirection,

    /// {@macro MyTextarea.textAlign}
    TextAlign textAlign = TextAlign.start,

    /// {@macro MyTextarea.onEditingComplete}
    VoidCallback? onEditingComplete,

    /// {@macro MyTextarea.onSubmitted}
    ValueChanged<String>? onSubmitted,

    /// {@macro MyTextarea.onAppPrivateCommand}
    AppPrivateCommandCallback? onAppPrivateCommand,

    /// {@macro MyTextarea.style}
    TextStyle? style,

    /// {@macro MyTextarea.stylusHandwritingEnabled}
    bool stylusHandwritingEnabled = true,

    /// {@macro MyTextarea.enableIMEPersonalizedLearning}
    bool enableIMEPersonalizedLearning = true,

    /// {@macro MyTextarea.contextMenuBuilder}
    EditableTextContextMenuBuilder? contextMenuBuilder,

    /// {@macro MyTextarea.spellCheckConfiguration}
    SpellCheckConfiguration? spellCheckConfiguration,

    /// {@macro MyTextarea.contentInsertionConfiguration}
    ContentInsertionConfiguration? contentInsertionConfiguration,

    /// {@macro MyTextarea.selectionControls}
    TextSelectionControls? selectionControls,

    /// {@macro MyTextarea.enableInteractiveSelection}
    bool? enableInteractiveSelection,

    /// {@macro MyTextarea.clipBehavior}
    Clip clipBehavior = Clip.hardEdge,

    /// {@macro MyTextarea.dragStartBehavior}
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,

    /// {@macro MyTextarea.minHeight}
    double minHeight = 80,

    /// {@macro MyTextarea.maxHeight}
    double maxHeight = 500,

    /// {@macro MyTextarea.resizable}
    bool resizable = true,

    /// {@macro MyTextarea.onHeightChanged}
    ValueChanged<double>? onHeightChanged,

    /// {@macro MyTextarea.resizeHandleBuilder}
    WidgetBuilder? resizeHandleBuilder,

    /// {@macro MyTextarea.groupId}
    Object? groupId,

    /// {@macro MyKeyboardToolbar.toolbarBuilder}
    WidgetBuilder? keyboardToolbarBuilder,

    /// {@macro MyInput.leading}
    Widget? leading,

    /// {@macro MyInput.trailing}
    Widget? trailing,
  }) : super(
         initialValue: controller != null ? controller.text : initialValue,
         validator: validator == null ? null : (v) => validator(v ?? ''),
         onChanged: onChanged == null ? null : (v) => onChanged(v ?? ''),
         decorationBuilder:
             (context) => (const MyDecoration()).merge(decoration),
         builder: (field) {
           final state = field as _MyFormBuilderTextareaState;
           return MyTextarea(
             key: state.textareaKey,
             controller: state.controller,
             restorationId: restorationId,
             enabled: state.enabled,
             focusNode: state.focusNode,
             readOnly: readOnly,
             decoration: state.decoration,
             style: style,
             textAlign: textAlign,
             textDirection: textDirection,
             autofocus: autofocus,
             placeholder: placeholder,
             placeholderStyle: placeholderStyle,
             placeholderAlignment: placeholderAlignment,
             constraints: constraints,
             onEditingComplete: onEditingComplete,
             onSubmitted: onSubmitted,
             onAppPrivateCommand: onAppPrivateCommand,
             scrollController: scrollController,
             scrollPhysics: scrollPhysics,
             mouseCursor: mouseCursor,
             stylusHandwritingEnabled: stylusHandwritingEnabled,
             enableIMEPersonalizedLearning: enableIMEPersonalizedLearning,
             contextMenuBuilder: contextMenuBuilder,
             spellCheckConfiguration: spellCheckConfiguration,
             contentInsertionConfiguration: contentInsertionConfiguration,
             selectionControls: selectionControls,
             enableInteractiveSelection: enableInteractiveSelection,
             clipBehavior: clipBehavior,
             dragStartBehavior: dragStartBehavior,
             onTap: onTap,
             onTapAlwaysCalled: onTapAlwaysCalled,
             onTapOutside: onTapOutside,
             minHeight: minHeight,
             maxHeight: maxHeight,
             resizable: resizable,
             onHeightChanged: onHeightChanged,
             resizeHandleBuilder: resizeHandleBuilder,
             groupId: groupId,
             keyboardToolbarBuilder: keyboardToolbarBuilder,
             leading: leading,
             trailing: trailing,
           );
         },
       );

  final TextEditingController? controller;

  @override
  MyFormBuilderFieldState<MyTextareaFormField, String> createState() =>
      _MyFormBuilderTextareaState();
}

class _MyFormBuilderTextareaState
    extends MyFormBuilderFieldState<MyTextareaFormField, String> {
  final GlobalKey<State<StatefulWidget>> textareaKey = GlobalKey();
  TextEditingController? _controller;

  TextEditingController get controller => widget.controller ?? _controller!;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller = TextEditingController(text: value);
    }
    controller.addListener(onControllerChanged);
  }

  @override
  void dispose() {
    controller.removeListener(onControllerChanged);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant MyTextareaFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller == null && widget.controller != null) {
      _controller?.dispose();
    }
    if (oldWidget.controller != null && widget.controller == null) {
      _controller = TextEditingController(text: value);
    }
  }

  @override
  void didChange(String? value) {
    super.didChange(value);
    if (controller.text != value) {
      controller.text = value ?? '';
    }
  }

  @override
  void reset() {
    super.reset();
    controller.text = initialValue ?? '';
    widget.onChanged?.call(controller.text);
  }

  void onControllerChanged() {
    if (controller.text != value) {
      didChange(controller.text);
    }
  }
}
