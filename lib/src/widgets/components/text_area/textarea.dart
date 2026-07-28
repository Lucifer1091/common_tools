import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import '../../../extensions/context/theme.dart';
import '../../../extensions/context/typography.dart';
import '../../../themes/my_scroll_wrapper.dart';
import '../../../themes/my_theme.dart';
import '../../common/my_decoration.dart';
import '../input/my_input.dart';

/// A customizable multiline textarea widget with
/// adjustable height and optional resizing grip.
///
/// The [MyTextarea] widget builds on [MyInput] to provide a rich, multiline
/// text input experience with support for theming, placeholder content, and
/// resize interaction.
///
/// It integrates with [MyTheme] for consistent appearance, and includes
/// properties for min/max height, editable behavior, styling, and decoration.
///
/// The field grows or shrinks based on content height (number of lines),
/// and supports user-driven resizing using a drag handle,
/// if [resizable] is enabled.
///
/// See also:
/// - [resizeHandleBuilder], for customizing the drag handle
class MyTextarea extends StatefulWidget {
  const MyTextarea({
    super.key,
    this.initialValue,
    this.controller,
    this.focusNode,
    this.placeholder,
    this.decoration,
    this.undoController,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.onAppPrivateCommand,
    this.style,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.autofocus = false,
    this.enabled = true,
    this.scrollPadding = const EdgeInsets.all(20),
    this.dragStartBehavior = DragStartBehavior.start,
    bool? enableInteractiveSelection,
    this.selectionControls,
    this.onTap,
    this.onTapAlwaysCalled = false,
    this.onTapOutside,
    this.mouseCursor,
    this.scrollController,
    this.scrollPhysics,
    this.contentInsertionConfiguration,
    this.clipBehavior = Clip.hardEdge,
    this.restorationId,
    this.enableIMEPersonalizedLearning = true,
    this.contextMenuBuilder,
    this.spellCheckConfiguration,
    this.placeholderStyle,
    this.placeholderAlignment,
    this.constraints,
    this.stylusHandwritingEnabled =
        EditableText.defaultStylusHandwritingEnabled,
    this.groupId,
    this.readOnly = false,
    this.minHeight = 80,
    this.maxHeight = 500,
    this.resizable = true,
    this.onHeightChanged,
    this.resizeHandleBuilder,
    this.keyboardToolbarBuilder,
    this.leading,
    this.trailing,
  }) : enableInteractiveSelection = enableInteractiveSelection ?? !readOnly,
       assert(
         initialValue == null || controller == null,
         'Either initialValue or controller must be specified',
       );

  /// {@template MyTextarea.initialValue}
  /// The initial text value of the textarea.
  /// Used if [controller] is null; cannot be used with [controller].
  /// {@endtemplate}
  final String? initialValue;

  /// {@template MyTextarea.controller}
  /// Controls the text being edited. If null, an internal controller is created
  /// and initialized with [initialValue].
  /// {@endtemplate}
  final TextEditingController? controller;

  /// {@template MyTextarea.focusNode}
  /// Defines the keyboard focus for this widget.
  /// If null, one will be created automatically.
  /// {@endtemplate}
  final FocusNode? focusNode;

  /// {@template MyTextarea.placeholder}
  /// The widget shown when the textarea is empty. Typically a [Text] widget.
  /// {@endtemplate}
  final String? placeholder;

  /// {@template MyTextarea.placeholderStyle}
  /// The text style to use for the placeholder.
  /// If not specified, uses the theme's muted style.
  /// {@endtemplate}
  final TextStyle? placeholderStyle;

  /// {@template MyTextarea.placeholderAlignment}
  /// Alignment for the placeholder inside the field.
  ///
  /// Defaults to direction-aware top start:
  /// [Alignment.topLeft] in LTR, [Alignment.topRight] in RTL.
  /// {@endtemplate}
  final AlignmentGeometry? placeholderAlignment;

  /// {@template MyTextarea.decoration}
  /// Optional visual decoration for the textarea.
  /// Merged with the theme’s default decoration if provided.
  /// {@endtemplate}
  final MyDecoration? decoration;

  /// {@template MyTextarea.undoController}
  /// Optional controller for undo/redo functionality inside the text field.
  /// {@endtemplate}
  final UndoHistoryController? undoController;

  /// {@template MyTextarea.onChanged}
  /// Called when the text being edited changes.
  /// {@endtemplate}
  final ValueChanged<String>? onChanged;

  /// {@template MyTextarea.onEditingComplete}
  /// Called when the user indicates they are done editing the text.
  /// {@endtemplate}
  final VoidCallback? onEditingComplete;

  /// {@template MyTextarea.onSubmitted}
  /// Called when the user submits the text (e.g. presses "done").
  /// {@endtemplate}
  final ValueChanged<String>? onSubmitted;

  /// {@template MyTextarea.onAppPrivateCommand}
  /// Called for platform-specific app commands sent to the input field.
  /// {@endtemplate}
  final AppPrivateCommandCallback? onAppPrivateCommand;

  /// {@template MyTextarea.style}
  /// The text style used for the input text inside the textarea.
  /// {@endtemplate}
  final TextStyle? style;

  /// {@template MyTextarea.textAlign}
  /// How the text inside the textarea is aligned horizontally.
  /// {@endtemplate}
  final TextAlign textAlign;

  /// {@template MyTextarea.textDirection}
  /// The direction of the text. Defaults to the inherited direction.
  /// {@endtemplate}
  final TextDirection? textDirection;

  /// {@template MyTextarea.readOnly}
  /// Whether the text field is read-only.
  /// {@endtemplate}
  final bool readOnly;

  /// {@template MyTextarea.enabled}
  /// Whether the textarea is enabled and can be interacted with.
  /// {@endtemplate}
  final bool enabled;

  /// {@template MyTextarea.autofocus}
  /// Whether the field should focus itself
  /// automatically when the widget is built.
  /// {@endtemplate}
  final bool autofocus;

  /// {@template MyTextarea.scrollPadding}
  /// Insets to apply to the input when it's scrolled into view.
  /// {@endtemplate}
  final EdgeInsets scrollPadding;

  /// {@template MyTextarea.scrollController}
  /// Optional controller for managing scroll position.
  /// {@endtemplate}
  final ScrollController? scrollController;

  /// {@template MyTextarea.scrollPhysics}
  /// The physics applied to the textarea's scroll behavior.
  /// {@endtemplate}
  final ScrollPhysics? scrollPhysics;

  /// {@template MyTextarea.clipBehavior}
  /// Clip behavior of the textarea's content. Default is [Clip.hardEdge].
  /// {@endtemplate}
  final Clip clipBehavior;

  /// {@template MyTextarea.dragStartBehavior}
  /// The kind of drag behavior this widget uses for text selection.
  /// {@endtemplate}
  final DragStartBehavior dragStartBehavior;

  /// {@template MyTextarea.enableInteractiveSelection}
  /// Whether to allow interactive text selection.
  /// {@endtemplate}
  final bool enableInteractiveSelection;

  /// {@template MyTextarea.selectionControls}
  /// Controls for displaying custom selection handles.
  /// {@endtemplate}
  final TextSelectionControls? selectionControls;

  /// {@template MyTextarea.onTap}
  /// Called when the user taps the textarea.
  /// {@endtemplate}
  final GestureTapCallback? onTap;

  /// {@template MyTextarea.onTapOutside}
  /// Called when a pointer tap happens outside this widget.
  /// {@endtemplate}
  final TapRegionCallback? onTapOutside;

  /// {@template MyTextarea.onTapAlwaysCalled}
  /// Whether [onTap] is called even when text is selected.
  /// {@endtemplate}
  final bool onTapAlwaysCalled;

  /// {@template MyTextarea.mouseCursor}
  /// The mouse cursor to use when hovering over this widget.
  /// {@endtemplate}
  final MouseCursor? mouseCursor;

  /// {@template MyTextarea.contextMenuBuilder}
  /// Builds the context menu that appears
  /// when text is long-Tap or selected.
  /// {@endtemplate}
  final EditableTextContextMenuBuilder? contextMenuBuilder;

  /// {@template MyTextarea.spellCheckConfiguration}
  /// Configuration for enabling spell check support.
  /// {@endtemplate}
  final SpellCheckConfiguration? spellCheckConfiguration;

  /// {@template MyTextarea.contentInsertionConfiguration}
  /// Platform-specific configuration for handling content insertion.
  /// {@endtemplate}
  final ContentInsertionConfiguration? contentInsertionConfiguration;

  /// {@template MyTextarea.restorationId}
  /// Restoration ID used to save the textarea’s state.
  /// {@endtemplate}
  final String? restorationId;

  /// {@template MyTextarea.stylusHandwritingEnabled}
  /// Enables handwriting input using a stylus on supported platforms.
  /// {@endtemplate}
  final bool stylusHandwritingEnabled;

  /// {@template MyTextarea.enableIMEPersonalizedLearning}
  /// Enables IME (Input Method Editor) to personalize learning.
  /// {@endtemplate}
  final bool enableIMEPersonalizedLearning;

  /// {@template MyTextarea.constraints}
  /// Constraints to control layout of the field (e.g. minHeight).
  /// {@endtemplate}
  final BoxConstraints? constraints;

  /// {@template MyTextarea.groupId}
  /// ID used to group text fields for focus/interaction.
  /// {@endtemplate}
  final Object? groupId;

  /// {@template MyTextarea.minHeight}
  /// The minimum height of the textarea (default is 80).
  /// {@endtemplate}
  final double minHeight;

  /// {@template MyTextarea.maxHeight}
  /// The maximum height of the textarea (default is 500).
  /// {@endtemplate}
  final double maxHeight;

  /// {@template MyTextarea.resizable}
  /// Whether the textarea can be resized by the user (default is true).
  /// {@endtemplate}
  final bool resizable;

  /// {@template MyTextarea.onHeightChanged}
  /// Callback triggered whenever the textarea is resized.
  /// {@endtemplate}
  final ValueChanged<double>? onHeightChanged;

  /// {@template MyTextarea.resizeHandleBuilder}
  /// Allows customizing the resize handle (shown at bottom-right).
  /// {@endtemplate}
  final WidgetBuilder? resizeHandleBuilder;

  /// {@macro MyKeyboardToolbar.toolbarBuilder}
  final WidgetBuilder? keyboardToolbarBuilder;

  /// {@macro MyInput.leading}
  final Widget? leading;

  /// {@macro MyInput.trailing}
  final Widget? trailing;

  @override
  State<MyTextarea> createState() => _MyTextareaState();
}

class _MyTextareaState extends State<MyTextarea> {
  late double _textareaHeight;
  FocusNode? _focusNode;

  FocusNode get focusNode => widget.focusNode ?? _focusNode!;

  @override
  void initState() {
    super.initState();
    _textareaHeight = widget.minHeight;
    if (widget.focusNode == null) {
      _focusNode = FocusNode();
    }
  }

  @override
  void didUpdateWidget(covariant MyTextarea oldWidget) {
    super.didUpdateWidget(oldWidget);
    final clamped = _textareaHeight.clamp(widget.minHeight, widget.maxHeight);
    if (clamped != _textareaHeight) {
      setState(() => _textareaHeight = clamped);
      widget.onHeightChanged?.call(clamped);
    }
  }

  @override
  void dispose() {
    _focusNode?.dispose();
    super.dispose();
  }

  /// Handles the drag gesture to resize the textarea.
  ///
  /// Updates [_textareaHeight] based on the vertical drag delta
  /// and clamps the result
  void _handleResize(DragUpdateDetails details) {
    focusNode.requestFocus();
    final newHeight = (_textareaHeight + details.delta.dy).clamp(
      widget.minHeight,
      widget.maxHeight,
    );
    if (newHeight != _textareaHeight) {
      setState(() => _textareaHeight = newHeight);
      widget.onHeightChanged?.call(newHeight);
    }
  }

  /// Calculates the number of visible text lines that can fit in
  /// the current [_textareaHeight], based on the given [TextStyle].
  ///
  /// Falls back to the theme's [Theme.of(context).textTheme.bodyMedium] style
  /// or a default
  /// size of 14px and line height of 20/4 if not provided.
  ///
  /// Returns a clamped value between 1 and 100.
  int _calculateLineCount(TextStyle style) {
    final fontSize = style.fontSize ?? 14;
    final heightFactor = style.height ?? 20 / 4;
    final lineHeight = fontSize * heightFactor;
    return (_textareaHeight / lineHeight).floor().clamp(1, 100);
  }

  @override
  Widget build(BuildContext context) {
    final effectiveTextStyle = context.bodyMedium
        .copyWith(color: context.colorScheme.foreground)
        .merge(widget.style);

    final lineCount = _calculateLineCount(effectiveTextStyle);

    final effectiveDecoration = (const MyDecoration()).merge(widget.decoration);

    final effectivePlaceholderStyle = context.bodyMedium.merge(
      widget.placeholderStyle,
    );

    final effectiveMouseCursor =
        widget.mouseCursor ?? WidgetStateMouseCursor.textable;

    return Stack(
      children: [
        DisableScrollbar(
          child: MyInput(
            initialValue: widget.initialValue,
            controller: widget.controller,
            focusNode: focusNode,
            placeholder: widget.placeholder,
            maxLines: lineCount,
            minLines: lineCount,
            keyboardType: TextInputType.multiline,
            readOnly: widget.readOnly,
            enabled: widget.enabled,
            autofocus: widget.autofocus,
            onChanged: widget.onChanged,
            onEditingComplete: widget.onEditingComplete,
            onSubmitted: widget.onSubmitted,
            onAppPrivateCommand: widget.onAppPrivateCommand,
            style: effectiveTextStyle,
            textAlign: widget.textAlign,
            textDirection: widget.textDirection,
            scrollPadding: widget.scrollPadding,
            dragStartBehavior: widget.dragStartBehavior,
            enableInteractiveSelection: widget.enableInteractiveSelection,
            selectionControls: widget.selectionControls,
            onTap: widget.onTap,
            onTapAlwaysCalled: widget.onTapAlwaysCalled,
            onTapOutside: widget.onTapOutside,
            mouseCursor: effectiveMouseCursor,
            scrollController: widget.scrollController,
            scrollPhysics: widget.scrollPhysics,
            contentInsertionConfiguration: widget.contentInsertionConfiguration,
            clipBehavior: widget.clipBehavior,
            restorationId: widget.restorationId,
            stylusHandwritingEnabled: widget.stylusHandwritingEnabled,
            enableIMEPersonalizedLearning: widget.enableIMEPersonalizedLearning,
            contextMenuBuilder: widget.contextMenuBuilder,
            spellCheckConfiguration: widget.spellCheckConfiguration,
            decoration: effectiveDecoration,
            placeholderStyle: effectivePlaceholderStyle,
            groupId: widget.groupId ?? EditableText,
            undoController: widget.undoController,
            keyboardToolbarBuilder: widget.keyboardToolbarBuilder,
            leading: widget.leading,
            trailing: widget.trailing,
          ),
        ),
        if (widget.resizable)
          Positioned(
            bottom: 2,
            right: 2,
            child: MouseRegion(
              cursor: SystemMouseCursors.resizeUpDown,
              child: GestureDetector(
                onPanUpdate: _handleResize,
                behavior: HitTestBehavior.translucent,
                child: widget.resizeHandleBuilder != null
                    ? Builder(builder: widget.resizeHandleBuilder!)
                    : const MyDefaultResizeGrip(),
              ),
            ),
          ),
      ],
    );
  }
}

/// A small visual grip used to indicate that the [MyTextarea]
/// is resizable by the user.
///
/// This widget appears in the bottom-right corner and allows
/// the user to drag and resize the textarea vertically.
class MyDefaultResizeGrip extends StatelessWidget {
  const MyDefaultResizeGrip({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = MyTheme.of(context);

    return SizedBox(
      width: 8,
      height: 8,
      child: CustomPaint(
        painter: MyResizeGripPainter(color: theme.colorScheme.primary),
      ),
    );
  }
}

/// A customizable painter for drawing diagonal resize grip lines,
/// typically used in the bottom-right corner of a resizable widget.
class MyResizeGripPainter extends CustomPainter {
  /// Creates a painter that draws multiple diagonal lines to represent a resize
  /// grip.
  ///
  /// - [color]: The color of the lines.
  /// - [strokeWidth]: Thickness of each grip line. Default is 0.8.
  /// - [lineCount]: Number of diagonal lines to draw. Default is 3.
  /// - [spacing]: Spacing between each line. Default is 4.0.
  const MyResizeGripPainter({
    required this.color,
    this.strokeWidth = 0.8,
    this.lineCount = 3,
    this.spacing = 4.0,
  });

  /// The color of the grip lines.
  final Color color;

  /// The thickness of the lines.
  final double strokeWidth;

  /// The number of diagonal lines in the grip.
  final int lineCount;

  /// The spacing between each grip line.
  final double spacing;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth;

    for (var i = 0; i < lineCount; i++) {
      final offset = spacing * i;
      canvas.drawLine(
        Offset(size.width - offset, size.height),
        Offset(size.width, size.height - offset),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant MyResizeGripPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.lineCount != lineCount ||
        oldDelegate.spacing != spacing;
  }
}
