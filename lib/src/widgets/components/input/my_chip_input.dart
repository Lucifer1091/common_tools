import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../constants/my_radius.dart';
import '../../../extensions/context/theme.dart';
import '../../../extensions/context/typography.dart';
import '../../common/my_decoration.dart';
import '../../common/my_provider.dart';
import '../../form/focusable.dart';
import '../button/my_button.dart';
import 'my_auto_complete.dart';
import 'my_input.dart';

typedef MyChipWidgetBuilder<T> = Widget Function(BuildContext context, T chip);

typedef MyChipInputWrapperBuilder<T> =
    Widget Function(
      BuildContext context,
      T chip,
      Widget child,
      VoidCallback onDeleted,
    );

typedef MyChipSubmissionCallback<T> = T? Function(String chipText);

class MyChipSpan<T> extends WidgetSpan {
  const MyChipSpan({
    required this.value,
    required super.child,
    super.alignment = PlaceholderAlignment.middle,
    super.baseline,
    super.style,
  });

  final T value;
}

abstract class MyChipClipboardHandler<T> {
  const MyChipClipboardHandler();

  List<InlineSpan> deserializeClipboard(String content);

  String serializeClipboard(List<InlineSpan> content);
}

class MyDefaultChipClipboardHandler<T> extends MyChipClipboardHandler<T> {
  const MyDefaultChipClipboardHandler({
    this.chipSerializer,
    this.chipSeparator = '',
  });

  final String Function(T value)? chipSerializer;
  final String chipSeparator;

  @override
  List<InlineSpan> deserializeClipboard(String content) {
    return [TextSpan(text: content)];
  }

  @override
  String serializeClipboard(List<InlineSpan> content) {
    final buffer = StringBuffer();
    var previousWasChip = false;

    void writeSpan(InlineSpan span) {
      if (span is MyChipSpan<T>) {
        if (previousWasChip && chipSeparator.isNotEmpty) {
          buffer.write(chipSeparator);
        }
        buffer.write(chipSerializer?.call(span.value) ?? span.value.toString());
        previousWasChip = true;
        return;
      }
      if (span is TextSpan) {
        buffer.write(span.text ?? '');
        previousWasChip = false;
        for (final child in span.children ?? const <InlineSpan>[]) {
          writeSpan(child);
        }
      }
    }

    for (final span in content) {
      writeSpan(span);
    }
    return buffer.toString();
  }
}

class MyDecoratedChipClipboardHandler<T> extends MyChipClipboardHandler<T> {
  const MyDecoratedChipClipboardHandler({
    this.prefix,
    this.suffix,
    this.chipSerializer,
    this.chipDeserializer,
    this.escapeDecoration = true,
    this.escapeCharacter = r'\',
    this.delimiter,
    this.escapeNonChip = false,
  });

  final String? prefix;
  final String? suffix;
  final String Function(T value)? chipSerializer;
  final T Function(String inner)? chipDeserializer;
  final bool escapeDecoration;
  final String escapeCharacter;
  final String? delimiter;
  final bool escapeNonChip;

  bool get _usesEscaping =>
      escapeDecoration &&
      escapeCharacter.isNotEmpty &&
      ((prefix?.isNotEmpty ?? false) ||
          (suffix?.isNotEmpty ?? false) ||
          (delimiter?.isNotEmpty ?? false));

  String _escape(String value) {
    if (!_usesEscaping) return value;
    final tokens = <String>[
      escapeCharacter,
      if (prefix?.isNotEmpty ?? false) prefix!,
      if (suffix?.isNotEmpty ?? false) suffix!,
      if (delimiter?.isNotEmpty ?? false) delimiter!,
    ]..sort((a, b) => b.length.compareTo(a.length));
    final buffer = StringBuffer();
    var index = 0;
    while (index < value.length) {
      String? matched;
      for (final token in tokens) {
        if (value.startsWith(token, index)) {
          matched = token;
          break;
        }
      }
      if (matched == null) {
        buffer.write(value[index]);
        index++;
      } else {
        buffer
          ..write(escapeCharacter)
          ..write(matched);
        index += matched.length;
      }
    }
    return buffer.toString();
  }

  (String, int) _readEscaped(String content, int index) {
    final escapedStart = index + escapeCharacter.length;
    if (escapedStart >= content.length) return ('', escapedStart);
    final tokens = <String>[
      if (prefix?.isNotEmpty ?? false) prefix!,
      if (suffix?.isNotEmpty ?? false) suffix!,
      if (delimiter?.isNotEmpty ?? false) delimiter!,
      escapeCharacter,
    ]..sort((a, b) => b.length.compareTo(a.length));
    for (final token in tokens) {
      if (content.startsWith(token, escapedStart)) {
        return (token, escapedStart + token.length);
      }
    }
    return (content[escapedStart], escapedStart + 1);
  }

  @override
  String serializeClipboard(List<InlineSpan> content) {
    final buffer = StringBuffer();
    final opening = prefix ?? '';
    final closing = suffix ?? '';
    final separator = delimiter ?? '';
    var previousWasChip = false;

    void writeSpan(InlineSpan span) {
      if (span is MyChipSpan<T>) {
        if (previousWasChip && separator.isNotEmpty) buffer.write(separator);
        final inner = chipSerializer?.call(span.value) ?? span.value.toString();
        buffer
          ..write(opening)
          ..write(_escape(inner))
          ..write(closing);
        previousWasChip = true;
        return;
      }
      if (span is TextSpan) {
        final text = span.text ?? '';
        buffer.write(escapeNonChip ? _escape(text) : text);
        previousWasChip = false;
        for (final child in span.children ?? const <InlineSpan>[]) {
          writeSpan(child);
        }
      }
    }

    for (final span in content) {
      writeSpan(span);
    }
    return buffer.toString();
  }

  @override
  List<InlineSpan> deserializeClipboard(String content) {
    final parser = chipDeserializer;
    final opening = prefix ?? '';
    final closing = suffix ?? '';
    final separator = delimiter ?? '';
    if (parser == null || opening.isEmpty) return [TextSpan(text: content)];

    final spans = <InlineSpan>[];
    final text = StringBuffer();

    void flushText() {
      if (text.isEmpty) return;
      spans.add(TextSpan(text: text.toString()));
      text.clear();
    }

    var index = 0;
    while (index < content.length) {
      if (_usesEscaping &&
          escapeNonChip &&
          content.startsWith(escapeCharacter, index)) {
        final (literal, next) = _readEscaped(content, index);
        text.write(literal);
        index = next;
        continue;
      }
      if (!content.startsWith(opening, index)) {
        text.write(content[index]);
        index++;
        continue;
      }

      final inner = StringBuffer();
      final innerStart = index + opening.length;
      var cursor = innerStart;
      var closed = closing.isEmpty;
      while (cursor < content.length) {
        if (_usesEscaping && content.startsWith(escapeCharacter, cursor)) {
          final (literal, next) = _readEscaped(content, cursor);
          inner.write(literal);
          cursor = next;
          continue;
        }
        if (closing.isNotEmpty && content.startsWith(closing, cursor)) {
          cursor += closing.length;
          closed = true;
          break;
        }
        if (closing.isEmpty &&
            ((separator.isNotEmpty && content.startsWith(separator, cursor)) ||
                content.startsWith(opening, cursor))) {
          break;
        }
        inner.write(content[cursor]);
        cursor++;
      }

      if (!closed || inner.isEmpty) {
        text.write(opening);
        index = innerStart;
        continue;
      }
      flushText();
      spans.add(
        MyChipSpan<T>(value: parser(inner.toString()), child: const SizedBox()),
      );
      index = cursor;
      if (separator.isNotEmpty && content.startsWith(separator, index)) {
        index += separator.length;
      }
    }
    flushText();
    return spans;
  }
}

class _MyChipRenderData<T> {
  const _MyChipRenderData({required this.spacing, required this.builder});

  final double spacing;
  final Widget Function(BuildContext context, int id, T chip) builder;
}

class MyChipEditingController<T> extends TextEditingController {
  MyChipEditingController({String? text, List<T> initialChips = const []}) {
    _replaceAllChips(initialChips, plainText: text ?? '');
  }

  static const int _chipStart = 0xE000;
  static const int _chipEnd = 0xF8FF;
  static const int _maxChips = _chipEnd - _chipStart + 1;

  final Map<int, T> _chipMap = {};
  var _nextChipId = 0;

  static bool isChipUnicode(int codeUnit) {
    return codeUnit >= _chipStart && codeUnit <= _chipEnd;
  }

  int _allocateChip(T chip) {
    if (_chipMap.length >= _maxChips) {
      throw StateError('Maximum number of chips reached.');
    }
    while (_chipMap.containsKey(_nextChipId)) {
      _nextChipId = (_nextChipId + 1) % _maxChips;
    }
    final id = _nextChipId;
    _chipMap[id] = chip;
    _nextChipId = (_nextChipId + 1) % _maxChips;
    return id;
  }

  String _characterFor(int id) => String.fromCharCode(_chipStart + id);

  int? _idForCodeUnit(int codeUnit) {
    if (!isChipUnicode(codeUnit)) return null;
    final id = codeUnit - _chipStart;
    return _chipMap.containsKey(id) ? id : null;
  }

  void _reconcileChipMap(String text) {
    final presentIds = <int>{};
    for (final codeUnit in text.codeUnits) {
      if (isChipUnicode(codeUnit)) presentIds.add(codeUnit - _chipStart);
    }
    _chipMap.removeWhere((id, _) => !presentIds.contains(id));
  }

  @override
  set value(TextEditingValue newValue) {
    _reconcileChipMap(newValue.text);
    super.value = newValue;
  }

  List<T> get chips {
    final result = <T>[];
    for (final codeUnit in value.text.codeUnits) {
      final id = _idForCodeUnit(codeUnit);
      if (id != null) result.add(_chipMap[id] as T);
    }
    return List.unmodifiable(result);
  }

  set chips(List<T> newChips) {
    _replaceAllChips(newChips, plainText: plainText);
  }

  String get plainText {
    final buffer = StringBuffer();
    for (final codeUnit in value.text.codeUnits) {
      if (!isChipUnicode(codeUnit)) buffer.writeCharCode(codeUnit);
    }
    return buffer.toString();
  }

  TextRange _activeTextRange() {
    final text = value.text;
    final selection = value.selection;
    if (selection.isValid && !selection.isCollapsed) {
      return TextRange(start: selection.start, end: selection.end);
    }
    final caret = selection.isValid
        ? selection.extentOffset.clamp(0, text.length)
        : text.length;
    var start = caret;
    var end = caret;
    while (start > 0 && !isChipUnicode(text.codeUnitAt(start - 1))) {
      start--;
    }
    while (end < text.length && !isChipUnicode(text.codeUnitAt(end))) {
      end++;
    }
    return TextRange(start: start, end: end);
  }

  String _plainTextInRange(TextRange range) {
    final buffer = StringBuffer();
    for (final codeUnit
        in value.text.substring(range.start, range.end).codeUnits) {
      if (!isChipUnicode(codeUnit)) buffer.writeCharCode(codeUnit);
    }
    return buffer.toString();
  }

  String get textAtCursor => _plainTextInRange(_activeTextRange());

  bool insertChipAtCursor(MyChipSubmissionCallback<T> chipConverter) {
    final range = _activeTextRange();
    final chipText = _plainTextInRange(range);
    if (chipText.isEmpty) return false;
    final chip = chipConverter(chipText);
    if (chip == null) return false;
    _replaceRangeWithChip(range, chip);
    return true;
  }

  void clearTextAtCursor() {
    final range = _activeTextRange();
    _replaceRange(range, '');
  }

  void appendChip(T chip) {
    _insertChipAt(value.text.length, chip);
  }

  void appendChipAtCursor(T chip) {
    final selection = value.selection;
    final offset = selection.isValid
        ? selection.end.clamp(0, value.text.length)
        : value.text.length;
    _insertChipAt(offset, chip);
  }

  void insertChip(T chip) {
    _insertChipAt(0, chip);
  }

  bool removeChip(T chip) {
    var chipIndex = 0;
    for (var textIndex = 0; textIndex < value.text.length; textIndex++) {
      final id = _idForCodeUnit(value.text.codeUnitAt(textIndex));
      if (id == null) continue;
      if (_chipMap[id] == chip) return removeChipAt(chipIndex);
      chipIndex++;
    }
    return false;
  }

  bool removeChipAt(int chipIndex) {
    var current = 0;
    for (var textIndex = 0; textIndex < value.text.length; textIndex++) {
      final id = _idForCodeUnit(value.text.codeUnitAt(textIndex));
      if (id == null) continue;
      if (current == chipIndex) {
        _removeChipId(id);
        return true;
      }
      current++;
    }
    return false;
  }

  void removeAllChips() {
    _chipMap.clear();
    final text = plainText;
    super.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  void _removeChipId(int id) {
    final character = _characterFor(id);
    final index = value.text.indexOf(character);
    if (index < 0) return;
    _chipMap.remove(id);
    final oldSelection = value.selection;
    final newText = value.text.replaceRange(index, index + 1, '');
    final oldOffset = oldSelection.isValid ? oldSelection.extentOffset : index;
    final newOffset = oldOffset > index ? oldOffset - 1 : oldOffset;
    super.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(
        offset: newOffset.clamp(0, newText.length),
      ),
    );
  }

  void _insertChipAt(int offset, T chip) {
    final id = _allocateChip(chip);
    final text = value.text.replaceRange(offset, offset, _characterFor(id));
    super.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: offset + 1),
    );
  }

  void _replaceRangeWithChip(TextRange range, T chip) {
    final id = _allocateChip(chip);
    final text = value.text.replaceRange(
      range.start,
      range.end,
      _characterFor(id),
    );
    _reconcileChipMap(text);
    super.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: range.start + 1),
    );
  }

  void _replaceRange(TextRange range, String replacement) {
    final text = value.text.replaceRange(range.start, range.end, replacement);
    _reconcileChipMap(text);
    super.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(
        offset: range.start + replacement.length,
      ),
    );
  }

  void _replaceAllChips(List<T> newChips, {required String plainText}) {
    if (newChips.length > _maxChips) {
      throw StateError('Maximum number of chips reached.');
    }
    _chipMap.clear();
    _nextChipId = 0;
    final buffer = StringBuffer();
    for (final chip in newChips) {
      buffer.write(_characterFor(_allocateChip(chip)));
    }
    buffer.write(plainText);
    final text = buffer.toString();
    super.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  List<InlineSpan> getSelectionSpans(TextSelection selection) {
    if (!selection.isValid) return const [];
    final start = selection.start.clamp(0, value.text.length);
    final end = selection.end.clamp(0, value.text.length);
    final spans = <InlineSpan>[];
    final buffer = StringBuffer();

    void flushText() {
      if (buffer.isEmpty) return;
      spans.add(TextSpan(text: buffer.toString()));
      buffer.clear();
    }

    for (var index = start; index < end; index++) {
      final id = _idForCodeUnit(value.text.codeUnitAt(index));
      if (id == null) {
        buffer.write(value.text[index]);
      } else {
        flushText();
        spans.add(
          MyChipSpan<T>(value: _chipMap[id] as T, child: const SizedBox()),
        );
      }
    }
    flushText();
    return spans;
  }

  void replaceSelectionWithSpans(List<InlineSpan> spans) {
    final selection = value.selection;
    final start = selection.isValid ? selection.start : value.text.length;
    final end = selection.isValid ? selection.end : value.text.length;
    final buffer = StringBuffer(value.text.substring(0, start));
    for (final span in spans) {
      _writeSpan(buffer, span);
    }
    final caret = buffer.length;
    buffer.write(value.text.substring(end));
    final text = buffer.toString();
    _reconcileChipMap(text);
    super.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: caret),
    );
  }

  void _writeSpan(StringBuffer buffer, InlineSpan span) {
    if (span is MyChipSpan<T>) {
      buffer.write(_characterFor(_allocateChip(span.value)));
      return;
    }
    if (span is TextSpan) {
      buffer.write(span.text ?? '');
      for (final child in span.children ?? const <InlineSpan>[]) {
        _writeSpan(buffer, child);
      }
    }
  }

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final renderData = context.maybeWatch<_MyChipRenderData<T>>();
    if (renderData == null) {
      return super.buildTextSpan(
        context: context,
        style: style,
        withComposing: withComposing,
      );
    }

    final children = <InlineSpan>[];
    final buffer = StringBuffer();
    var bufferIsComposing = false;
    final composingValid = withComposing && value.isComposingRangeValid;
    final composingStyle = style?.merge(
      const TextStyle(decoration: TextDecoration.underline),
    );

    void flushText() {
      if (buffer.isEmpty) return;
      children.add(
        TextSpan(
          text: buffer.toString(),
          style: bufferIsComposing ? composingStyle : style,
        ),
      );
      buffer.clear();
    }

    for (var index = 0; index < value.text.length; index++) {
      final codeUnit = value.text.codeUnitAt(index);
      final id = _idForCodeUnit(codeUnit);
      if (id != null) {
        flushText();
        final previousIsChip =
            index > 0 &&
            _idForCodeUnit(value.text.codeUnitAt(index - 1)) != null;
        final nextIsChip =
            index < value.text.length - 1 &&
            _idForCodeUnit(value.text.codeUnitAt(index + 1)) != null;
        children.add(
          MyChipSpan<T>(
            value: _chipMap[id] as T,
            child: Padding(
              padding: EdgeInsets.only(
                left: previousIsChip
                    ? renderData.spacing / 2
                    : index == 0
                    ? 0
                    : renderData.spacing,
                right: nextIsChip ? renderData.spacing / 2 : renderData.spacing,
              ),
              child: renderData.builder(context, id, _chipMap[id] as T),
            ),
          ),
        );
        continue;
      }

      final isComposing =
          composingValid &&
          index >= value.composing.start &&
          index < value.composing.end;
      if (buffer.isNotEmpty && isComposing != bufferIsComposing) flushText();
      bufferIsComposing = isComposing;
      buffer.writeCharCode(codeUnit);
    }
    flushText();
    return TextSpan(style: style, children: children);
  }
}

class MyChipSubmitIntent extends Intent {
  const MyChipSubmitIntent();
}

class MyChipInput<T> extends StatefulWidget {
  MyChipInput({
    required this.chipBuilder,
    required this.onChipSubmitted,
    super.key,
    this.controller,
    this.initialValue = '',
    this.initialChips = const [],
    this.chipWrapperBuilder,
    this.onChipsChanged,
    this.useChips = true,
    this.removable = true,
    this.spacing = 4,
    this.autoInsertSuggestion = true,
    this.clipboardHandler,
    this.groupId = EditableText,
    this.focusNode,
    this.decoration,
    this.placeholder,
    this.placeholderStyle,
    this.leading,
    this.trailing,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.style,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.textDirection,
    this.readOnly = false,
    this.autofocus = false,
    this.autocorrect,
    this.enableSuggestions = true,
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
    this.maxLength,
    this.maxLengthEnforcement,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.inputFormatters,
    this.enabled,
    this.ignorePointers,
    this.scrollPadding = const EdgeInsets.all(20),
    this.dragStartBehavior = DragStartBehavior.start,
    this.enableInteractiveSelection,
    this.onTap,
    this.onTapOutside,
    this.onTapUpOutside,
    this.scrollController,
    this.scrollPhysics,
    this.autofillHints = const [],
    this.clipBehavior = Clip.hardEdge,
    this.canRequestFocus = true,
    this.keyboardToolbarBuilder,
  }) : assert(
         controller == null || (initialValue.isEmpty && initialChips.isEmpty),
         'initialValue and initialChips cannot be used with a controller.',
       );

  final MyChipEditingController<T>? controller;
  final String initialValue;
  final List<T> initialChips;
  final MyChipWidgetBuilder<T> chipBuilder;
  final MyChipInputWrapperBuilder<T>? chipWrapperBuilder;
  final MyChipSubmissionCallback<T> onChipSubmitted;
  final ValueChanged<List<T>>? onChipsChanged;
  final bool useChips;
  final bool removable;
  final double spacing;
  final bool autoInsertSuggestion;
  final MyChipClipboardHandler<T>? clipboardHandler;

  final Object groupId;
  final FocusNode? focusNode;
  final MyDecoration? decoration;
  final String? placeholder;
  final TextStyle? placeholderStyle;
  final Widget? leading;
  final Widget? trailing;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final TextStyle? style;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final TextDirection? textDirection;
  final bool readOnly;
  final bool autofocus;
  final bool? autocorrect;
  final bool enableSuggestions;
  final int? maxLines;
  final int? minLines;
  final bool expands;
  final int? maxLength;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final bool? enabled;
  final bool? ignorePointers;
  final EdgeInsets scrollPadding;
  final DragStartBehavior dragStartBehavior;
  final bool? enableInteractiveSelection;
  final GestureTapCallback? onTap;
  final TapRegionCallback? onTapOutside;
  final TapRegionUpCallback? onTapUpOutside;
  final ScrollController? scrollController;
  final ScrollPhysics? scrollPhysics;
  final Iterable<String> autofillHints;
  final Clip clipBehavior;
  final bool canRequestFocus;
  final WidgetBuilder? keyboardToolbarBuilder;

  static bool isChipUnicode(int codeUnit) {
    return MyChipEditingController.isChipUnicode(codeUnit);
  }

  static bool isChipCharacter(String character) {
    return character.isNotEmpty && isChipUnicode(character.codeUnitAt(0));
  }

  @override
  State<MyChipInput<T>> createState() => _MyChipInputState<T>();
}

class _MyChipInputState<T> extends State<MyChipInput<T>> {
  late MyChipEditingController<T> _controller;
  var _ownsController = false;
  late List<T> _lastChips;
  late String _lastPlainText;

  MyChipClipboardHandler<T> get _clipboardHandler =>
      widget.clipboardHandler ?? MyDefaultChipClipboardHandler<T>();

  @override
  void initState() {
    super.initState();
    _attachController(widget.controller);
  }

  void _attachController(MyChipEditingController<T>? controller) {
    _ownsController = controller == null;
    _controller =
        controller ??
        MyChipEditingController<T>(
          text: widget.initialValue,
          initialChips: widget.initialChips,
        );
    _lastChips = _controller.chips;
    _lastPlainText = _controller.plainText;
    _controller.addListener(_handleControllerChanged);
  }

  void _detachController() {
    _controller.removeListener(_handleControllerChanged);
    if (_ownsController) _controller.dispose();
  }

  void _handleControllerChanged() {
    final chips = _controller.chips;
    final plainText = _controller.plainText;
    if (!listEquals(chips, _lastChips)) {
      _lastChips = chips;
      widget.onChipsChanged?.call(chips);
    }
    if (plainText != _lastPlainText) {
      _lastPlainText = plainText;
      widget.onChanged?.call(plainText);
    }
  }

  @override
  void didUpdateWidget(covariant MyChipInput<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      _detachController();
      _attachController(widget.controller);
    }
  }

  @override
  void dispose() {
    _detachController();
    super.dispose();
  }

  void _submitCurrentToken() {
    _controller.insertChipAtCursor(widget.onChipSubmitted);
  }

  void _handleSubmitted(String _) {
    _submitCurrentToken();
    widget.onSubmitted?.call(_controller.plainText);
  }

  void _handleCopy(CopySelectionTextIntent intent) {
    final selection = _controller.selection;
    if (!selection.isValid || selection.isCollapsed) return;
    final serialized = _clipboardHandler.serializeClipboard(
      _controller.getSelectionSpans(selection),
    );
    if (serialized.isNotEmpty) {
      unawaited(Clipboard.setData(ClipboardData(text: serialized)));
    }
    if (intent.collapseSelection) {
      _controller.replaceSelectionWithSpans(const []);
    }
  }

  Future<void> _handlePaste() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (!mounted || data?.text == null || data!.text!.isEmpty) return;
    _controller.replaceSelectionWithSpans(
      _clipboardHandler.deserializeClipboard(data.text!),
    );
  }

  Widget _defaultChipWrapper(
    BuildContext context,
    T chip,
    Widget child,
    VoidCallback onDeleted,
  ) {
    return Container(
      padding: const EdgeInsets.only(left: 8, top: 2, bottom: 2, right: 2),
      decoration: BoxDecoration(
        color: context.colorScheme.accent,
        borderRadius: MyBorderRadius.small,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          DefaultTextStyle.merge(style: context.bodySmall, child: child),
          if (widget.removable) ...[
            const SizedBox(width: 4),
            MyButton(
              width: 20,
              height: 20,
              padding: EdgeInsets.zero,
              type: MyButtonType.text,
              shape: MyButtonShape.square,
              icon: LucideIcons.x,
              focus: const MyFocusableParams(canRequestFocus: false),
              onTap: onDeleted,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildChip(BuildContext context, int id, T chip) {
    final child = widget.chipBuilder(context, chip);
    if (!widget.useChips) return child;
    void delete() => _controller._removeChipId(id);
    return widget.chipWrapperBuilder?.call(context, chip, child, delete) ??
        _defaultChipWrapper(context, chip, child, delete);
  }

  @override
  Widget build(BuildContext context) {
    final renderData = _MyChipRenderData<T>(
      spacing: widget.spacing,
      builder: _buildChip,
    );
    Widget input = MyInput(
      groupId: widget.groupId,
      controller: _controller,
      focusNode: widget.focusNode,
      decoration: widget.decoration,
      placeholder: widget.placeholder,
      placeholderStyle: widget.placeholderStyle,
      leading: widget.leading,
      trailing: widget.trailing,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction ?? TextInputAction.done,
      textCapitalization: widget.textCapitalization,
      style: widget.style,
      textAlign: widget.textAlign,
      textAlignVertical: widget.textAlignVertical,
      textDirection: widget.textDirection,
      readOnly: widget.readOnly,
      autofocus: widget.autofocus,
      autocorrect: widget.autocorrect,
      enableSuggestions: widget.enableSuggestions,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      expands: widget.expands,
      maxLength: widget.maxLength,
      maxLengthEnforcement: widget.maxLengthEnforcement,
      onEditingComplete:
          widget.onEditingComplete ?? () => _controller.clearComposing(),
      onSubmitted: _handleSubmitted,
      inputFormatters: widget.inputFormatters,
      enabled: widget.enabled,
      ignorePointers: widget.ignorePointers,
      scrollPadding: widget.scrollPadding,
      dragStartBehavior: widget.dragStartBehavior,
      enableInteractiveSelection: widget.enableInteractiveSelection,
      onTap: widget.onTap,
      onTapOutside: widget.onTapOutside,
      onTapUpOutside: widget.onTapUpOutside,
      scrollController: widget.scrollController,
      scrollPhysics: widget.scrollPhysics,
      autofillHints: widget.autofillHints,
      clipBehavior: widget.clipBehavior,
      canRequestFocus: widget.canRequestFocus,
      keyboardToolbarBuilder: widget.keyboardToolbarBuilder,
    );

    input = Actions(
      actions: {
        CopySelectionTextIntent: CallbackAction<CopySelectionTextIntent>(
          onInvoke: (intent) {
            _handleCopy(intent);
            return null;
          },
        ),
        PasteTextIntent: CallbackAction<PasteTextIntent>(
          onInvoke: (intent) {
            unawaited(_handlePaste());
            return null;
          },
        ),
        MyChipSubmitIntent: CallbackAction<MyChipSubmitIntent>(
          onInvoke: (intent) {
            _submitCurrentToken();
            return null;
          },
        ),
        if (widget.autoInsertSuggestion)
          MyAutoCompleteIntent: CallbackAction<MyAutoCompleteIntent>(
            onInvoke: (intent) {
              _controller.insertChipAtCursor(
                (_) => widget.onChipSubmitted(intent.suggestion),
              );
              return null;
            },
          ),
      },
      child: Shortcuts(
        shortcuts: const {
          SingleActivator(LogicalKeyboardKey.enter): MyChipSubmitIntent(),
        },
        child: input,
      ),
    );

    return MyProvider<_MyChipRenderData<T>>(
      data: renderData,
      notifyUpdate: (oldWidget) => oldWidget.data != renderData,
      child: input,
    );
  }
}
