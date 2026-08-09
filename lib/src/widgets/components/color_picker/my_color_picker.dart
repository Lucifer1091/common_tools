import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../constants/my_radius.dart';
import '../../../extensions/context/theme.dart';
import '../../../extensions/context/typography.dart';
import '../../../extensions/misc/color.dart';
import '../../../themes/my_theme.dart';
import '../../common/portal.dart';
import '../../form/field.dart';
import '../../packages/gap/src/widgets/gap.dart';
import '../button/my_button.dart';
import '../dialog/my_dialog.dart';
import '../input/my_input.dart';
import '../popover/popover.dart';
import '../select/select.dart';

enum MyColorPickerMode { rgb, hsl, hsv, hex }

enum MyColorPickerPresentation { popover, dialog, inline }

enum _MyColorPickerPanelLayout { compact, stacked }

class MyColorPickerController extends ValueNotifier<Color> {
  MyColorPickerController(super.value);

  String toHex({bool showAlpha = true}) => value
      .toHex(leadingHashSign: true)
      .let((hex) => showAlpha ? hex : '#${hex.substring(3)}');
}

class MyColorHistoryController extends ChangeNotifier {
  MyColorHistoryController({
    List<Color> initialColors = const [],
    this.capacity = 50,
  }) : _recentColors = List<Color>.of(initialColors.take(capacity));

  final int capacity;
  final List<Color> _recentColors;

  List<Color> get recentColors => List<Color>.unmodifiable(_recentColors);

  void add(Color color) {
    _recentColors.remove(color);
    _recentColors.insert(0, color);
    if (_recentColors.length > capacity) {
      _recentColors.removeRange(capacity, _recentColors.length);
    }
    notifyListeners();
  }

  void setColors(List<Color> colors) {
    _recentColors
      ..clear()
      ..addAll(colors.take(capacity));
    notifyListeners();
  }

  void clear() {
    _recentColors.clear();
    notifyListeners();
  }
}

class MyRecentColorsScope extends StatefulWidget {
  const MyRecentColorsScope({
    required this.child,
    super.key,
    this.controller,
    this.initialColors = const [],
    this.capacity = 50,
  });

  final Widget child;
  final MyColorHistoryController? controller;
  final List<Color> initialColors;
  final int capacity;

  static MyColorHistoryController? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_MyRecentColorsInherited>()
        ?.notifier;
  }

  static MyColorHistoryController of(BuildContext context) {
    final controller = maybeOf(context);
    if (controller == null) {
      throw FlutterError(
        'No MyRecentColorsScope found in context. Wrap the app or picker '
        'with MyRecentColorsScope.',
      );
    }
    return controller;
  }

  @override
  State<MyRecentColorsScope> createState() => _MyRecentColorsScopeState();
}

class _MyRecentColorsScopeState extends State<MyRecentColorsScope> {
  MyColorHistoryController? _controller;

  MyColorHistoryController get _effectiveController =>
      widget.controller ?? _controller!;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller = MyColorHistoryController(
        initialColors: widget.initialColors,
        capacity: widget.capacity,
      );
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _MyRecentColorsInherited(
      notifier: _effectiveController,
      child: widget.child,
    );
  }
}

class _MyRecentColorsInherited
    extends InheritedNotifier<MyColorHistoryController> {
  const _MyRecentColorsInherited({
    required super.notifier,
    required super.child,
  });
}

typedef MyEyeDropperPreviewLabelBuilder =
    Widget Function(BuildContext context, Color color);

class MyEyeDropperLayer extends StatefulWidget {
  const MyEyeDropperLayer({
    required this.child,
    super.key,
    this.showPreview = true,
    this.previewAlignment,
    this.previewSize = const Size(96, 96),
    this.previewScale = 8,
    this.previewLabelBuilder,
  });

  final Widget child;
  final bool showPreview;
  final AlignmentGeometry? previewAlignment;
  final Size previewSize;
  final double previewScale;
  final MyEyeDropperPreviewLabelBuilder? previewLabelBuilder;

  static MyEyeDropperLayerState? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_MyEyeDropperInherited>()
        ?.state;
  }

  static MyEyeDropperLayerState of(BuildContext context) {
    final state = maybeOf(context);
    if (state == null) {
      throw FlutterError(
        'No MyEyeDropperLayer found in context. Wrap the app with '
        'MyEyeDropperLayer before calling pickColorFromScreen.',
      );
    }
    return state;
  }

  @override
  State<MyEyeDropperLayer> createState() => MyEyeDropperLayerState();
}

class MyEyeDropperLayerState extends State<MyEyeDropperLayer> {
  final GlobalKey _repaintKey = GlobalKey();
  final FocusNode _focusNode = FocusNode(debugLabel: 'MyEyeDropperLayer');
  Completer<Color?>? _activeSession;
  _ScreenshotResult? _screenshot;
  _EyeDropperPreview? _preview;
  Offset? _previewPosition;

  Future<Color?> pickColor([MyColorHistoryController? history]) async {
    if (!mounted) return null;
    if (_activeSession != null) return _activeSession!.future;

    final screenshot = await _capture();
    if (screenshot == null) return null;

    final completer = Completer<Color?>();
    setState(() {
      _activeSession = completer;
      _screenshot = screenshot;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNode.requestFocus();
    });

    final result = await completer.future;
    if (result != null) history?.add(result);
    return result;
  }

  Future<_ScreenshotResult?> _capture() async {
    final renderObject = _repaintKey.currentContext?.findRenderObject();
    if (renderObject is! RenderRepaintBoundary) return null;
    final image = await renderObject.toImage(pixelRatio: 1);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    if (byteData == null) return null;
    return _ScreenshotResult(
      bytes: byteData.buffer.asUint8List(),
      width: image.width,
      height: image.height,
    );
  }

  void _finish(Color? color) {
    if (_activeSession == null) return;
    final session = _activeSession!;
    setState(() {
      _activeSession = null;
      _screenshot = null;
      _preview = null;
      _previewPosition = null;
    });
    _focusNode.unfocus();
    session.complete(color);
  }

  @override
  void dispose() {
    _activeSession?.complete(null);
    _focusNode.dispose();
    super.dispose();
  }

  void _updatePreview(Offset position) {
    final screenshot = _screenshot;
    if (screenshot == null) return;
    final clamped = Offset(
      position.dx.clamp(0, (screenshot.width - 1).toDouble()),
      position.dy.clamp(0, (screenshot.height - 1).toDouble()),
    );
    setState(() {
      _previewPosition = position;
      _preview = _EyeDropperPreview(
        color: screenshot.colorAt(clamped),
        colors: screenshot.sample(
          clamped,
          Size.square(widget.previewSize.shortestSide / widget.previewScale),
        ),
      );
    });
  }

  Widget _buildPreview(BuildContext context) {
    final preview = _preview;
    final position = _previewPosition;
    if (!widget.showPreview || preview == null || position == null) {
      return const SizedBox.shrink();
    }
    final label =
        widget.previewLabelBuilder?.call(context, preview.color) ??
        Text(_formatColor(preview.color, showAlpha: false));
    final previewWidget = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: context.colorScheme.background,
            border: Border.all(color: context.colorScheme.border),
          ),
          child: Padding(
            padding: const EdgeInsets.all(1),
            child: ClipOval(
              child: SizedBox.square(
                dimension: widget.previewSize.shortestSide,
                child: CustomPaint(
                  painter: _EyeDropperPreviewPainter(
                    colors: preview.colors,
                    borderColor: context.colorScheme.border,
                    selectedColor: context.colorScheme.popoverForeground,
                  ),
                ),
              ),
            ),
          ),
        ),
        const Gap(8),
        DecoratedBox(
          decoration: BoxDecoration(
            color: context.colorScheme.popover,
            borderRadius: MyBorderRadius.small,
            border: Border.all(color: context.colorScheme.border),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: label,
          ),
        ),
      ],
    );

    if (widget.previewAlignment != null) {
      return Positioned.fill(
        child: Align(
          alignment: widget.previewAlignment!.resolve(
            Directionality.of(context),
          ),
          child: previewWidget,
        ),
      );
    }

    return Positioned.fill(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final estimatedHeight = widget.previewSize.height + 44;
          final left = (position.dx + 12).clamp(
            0.0,
            (constraints.maxWidth - widget.previewSize.width - 4).clamp(
              0.0,
              double.infinity,
            ),
          );
          final top = (position.dy + 12).clamp(
            0.0,
            (constraints.maxHeight - estimatedHeight).clamp(
              0.0,
              double.infinity,
            ),
          );
          return Stack(
            children: [Positioned(left: left, top: top, child: previewWidget)],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final picking = _activeSession != null;
    return _MyEyeDropperInherited(
      state: this,
      child: Focus(
        focusNode: _focusNode,
        onKeyEvent: (_, event) {
          if (picking &&
              event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.escape) {
            _finish(null);
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        child: MouseRegion(
          cursor: picking ? SystemMouseCursors.precise : MouseCursor.defer,
          onHover: picking
              ? (event) => _updatePreview(event.localPosition)
              : null,
          child: Listener(
            key: picking ? const Key('my-eye-dropper-active-layer') : null,
            behavior: HitTestBehavior.translucent,
            onPointerDown: picking
                ? (event) => _updatePreview(event.localPosition)
                : null,
            onPointerMove: picking
                ? (event) => _updatePreview(event.localPosition)
                : null,
            onPointerUp: picking
                ? (event) {
                    final screenshot = _screenshot;
                    _finish(screenshot?.colorAt(event.localPosition));
                  }
                : null,
            child: Stack(
              fit: StackFit.passthrough,
              children: [
                IgnorePointer(
                  ignoring: picking,
                  child: RepaintBoundary(key: _repaintKey, child: widget.child),
                ),
                _buildPreview(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MyEyeDropperInherited extends InheritedWidget {
  const _MyEyeDropperInherited({required this.state, required super.child});

  final MyEyeDropperLayerState state;

  @override
  bool updateShouldNotify(_MyEyeDropperInherited oldWidget) =>
      state != oldWidget.state;
}

class MyColorPicker extends StatefulWidget {
  const MyColorPicker({
    required this.value,
    super.key,
    this.controller,
    this.onChanged,
    this.onChanging,
    this.enabled = true,
    this.showAlpha = false,
    this.showLabel = false,
    this.showHistory = true,
    this.enableEyeDropper = true,
    this.initialMode = MyColorPickerMode.rgb,
    this.presentation = MyColorPickerPresentation.popover,
    this.placeholder,
    this.dialogTitle,
    this.popoverAnchor,
    this.popoverPadding,
    this.popoverGroupId,
    this.width,
  });

  final Color value;
  final MyColorPickerController? controller;
  final ValueChanged<Color>? onChanged;
  final ValueChanged<Color>? onChanging;
  final bool enabled;
  final bool showAlpha;
  final bool showLabel;
  final bool showHistory;
  final bool enableEyeDropper;
  final MyColorPickerMode initialMode;
  final MyColorPickerPresentation presentation;
  final Widget? placeholder;
  final Widget? dialogTitle;
  final MyAnchorBase? popoverAnchor;
  final EdgeInsetsGeometry? popoverPadding;
  final Object? popoverGroupId;
  final double? width;

  static Future<Color?> pickColorFromScreen(BuildContext context) {
    return MyEyeDropperLayer.of(
      context,
    ).pickColor(MyRecentColorsScope.maybeOf(context));
  }

  @override
  State<MyColorPicker> createState() => _MyColorPickerState();
}

class _MyColorPickerState extends State<MyColorPicker> {
  late final MyPopoverController _popoverController;
  late final Object _internalPopoverGroupId;
  Color? _previewValue;

  Color get _effectiveValue =>
      widget.controller?.value ?? _previewValue ?? widget.value;

  Object get _effectivePopoverGroupId =>
      widget.popoverGroupId ?? _internalPopoverGroupId;

  @override
  void initState() {
    super.initState();
    _popoverController = MyPopoverController();
    _internalPopoverGroupId = Object();
    widget.controller?.addListener(_onControllerChanged);
  }

  @override
  void didUpdateWidget(covariant MyColorPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _previewValue = null;
    }
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_onControllerChanged);
      widget.controller?.addListener(_onControllerChanged);
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_onControllerChanged);
    _popoverController.dispose();
    super.dispose();
  }

  void _onControllerChanged() => setState(() {});

  void _handleChanging(Color color) {
    setState(() => _previewValue = color);
    widget.onChanging?.call(color);
  }

  void _handleChanged(Color color) {
    setState(() => _previewValue = color);
    widget.controller?.value = color;
    widget.onChanged?.call(color);
    MyRecentColorsScope.maybeOf(context)?.add(color);
  }

  Future<Color?> _pickFromScreen() {
    final layer = MyEyeDropperLayer.maybeOf(context);
    if (layer == null) return Future<Color?>.value();
    return layer.pickColor(MyRecentColorsScope.maybeOf(context));
  }

  Future<void> _pickFromPopover() async {
    _popoverController.hide();
    await Future<void>.delayed(const Duration(milliseconds: 170));
    if (!mounted) return;
    final result = await _pickFromScreen();
    if (!mounted) return;
    if (result != null) {
      _handleChanged(
        _withPreviousAlpha(result, _effectiveValue, widget.showAlpha),
      );
    }
    _popoverController.show();
  }

  Future<void> _openDialog() async {
    if (!widget.enabled) return;
    final themeData = context.theme;
    final history = MyRecentColorsScope.maybeOf(context);
    await Future<void>.delayed(const Duration(milliseconds: 50));
    if (!mounted) return;
    var draft = _effectiveValue;
    var showHistoryView = false;

    while (mounted) {
      final result = await MyDialog.show<_ColorPickerDialogResult>(
        context: context,
        builder: (context) {
          return MyTheme(
            data: themeData,
            child: StatefulBuilder(
              builder: (context, setDialogState) {
                final availableWidth = MediaQuery.sizeOf(context).width - 32;
                final dialogWidth = availableWidth.clamp(280.0, 390.0);
                return SafeArea(
                  child: Center(
                    child: Material(
                      color: context.colorScheme.popover,
                      borderRadius: MyBorderRadius.extraLarge,
                      child: SizedBox(
                        width: dialogWidth,
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              DefaultTextStyle(
                                style: context.titleMedium,
                                child:
                                    widget.dialogTitle ??
                                    const Text('Select Color'),
                              ),
                              const Gap(16),
                              _MyColorPickerPanel(
                                value: draft,
                                initialMode: widget.initialMode,
                                showAlpha: widget.showAlpha,
                                showHistory: widget.showHistory,
                                showHistoryView: showHistoryView,
                                showToolButtons: false,
                                enableEyeDropper: false,
                                layout: _MyColorPickerPanelLayout.stacked,
                                overlayGroupId: _effectivePopoverGroupId,
                                historyController: history,
                                onHistorySelected: (_) => setDialogState(
                                  () => showHistoryView = false,
                                ),
                                onChanging: (color) {
                                  setDialogState(() => draft = color);
                                  widget.onChanging?.call(color);
                                },
                                onChanged: (color) {
                                  setDialogState(() => draft = color);
                                },
                              ),
                              const Gap(16),
                              Row(
                                children: [
                                  if (widget.enableEyeDropper)
                                    MyButton(
                                      key: const Key(
                                        'my-color-picker-dialog-eye-dropper',
                                      ),
                                      type: MyButtonType.outline,
                                      shape: MyButtonShape.square,
                                      icon: LucideIcons.pipette,
                                      onTap: () => Navigator.of(context).pop(
                                        _ColorPickerDialogResult.pick(draft),
                                      ),
                                    ),
                                  if (widget.enableEyeDropper) const Gap(8),
                                  if (widget.showHistory)
                                    MyButton(
                                      key: const Key(
                                        'my-color-picker-dialog-history',
                                      ),
                                      type: showHistoryView
                                          ? MyButtonType.primary
                                          : MyButtonType.outline,
                                      shape: MyButtonShape.square,
                                      icon: LucideIcons.history,
                                      onTap: () => setDialogState(
                                        () =>
                                            showHistoryView = !showHistoryView,
                                      ),
                                    ),
                                  const Spacer(),
                                  MyButton(
                                    key: const Key(
                                      'my-color-picker-dialog-cancel',
                                    ),
                                    text: 'Cancel',
                                    type: MyButtonType.outline,
                                    onTap: () => Navigator.of(context).pop(),
                                  ),
                                  const Gap(8),
                                  MyButton(
                                    key: const Key(
                                      'my-color-picker-dialog-save',
                                    ),
                                    text: 'Save',
                                    onTap: () => Navigator.of(
                                      context,
                                    ).pop(_ColorPickerDialogResult.save(draft)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      );

      if (!mounted || result == null) return;
      draft = result.color;
      if (result.pickFromScreen) {
        final picked = await _pickFromScreen();
        if (!mounted) return;
        if (picked != null) {
          draft = _withPreviousAlpha(picked, draft, widget.showAlpha);
        }
        continue;
      }
      _handleChanged(draft);
      return;
    }
  }

  Widget _buildPanel({
    _MyColorPickerPanelLayout layout = _MyColorPickerPanelLayout.stacked,
    Future<void> Function()? onEyeDropperRequested,
  }) {
    return _MyColorPickerPanel(
      value: _effectiveValue,
      initialMode: widget.initialMode,
      showAlpha: widget.showAlpha,
      showHistory: widget.showHistory,
      enableEyeDropper: widget.enableEyeDropper,
      layout: layout,
      overlayGroupId: _effectivePopoverGroupId,
      onEyeDropperRequested: onEyeDropperRequested,
      onChanging: _handleChanging,
      onChanged: _handleChanged,
    );
  }

  Widget _buildTrigger() {
    return _ColorPickerTrigger(
      color: _effectiveValue,
      enabled: widget.enabled,
      showLabel: widget.showLabel,
      showAlpha: widget.showAlpha,
      placeholder: widget.placeholder,
      width: widget.width,
      onTap: switch (widget.presentation) {
        MyColorPickerPresentation.dialog => _openDialog,
        MyColorPickerPresentation.popover => _popoverController.toggle,
        MyColorPickerPresentation.inline => null,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.presentation == MyColorPickerPresentation.inline) {
      return _buildPanel();
    }

    if (widget.presentation == MyColorPickerPresentation.dialog) {
      return _buildTrigger();
    }

    return MyPopover(
      controller: _popoverController,
      groupId: _effectivePopoverGroupId,
      anchor: widget.popoverAnchor,
      padding: widget.popoverPadding ?? const EdgeInsets.all(12),
      popover: (context) {
        final availableWidth = MediaQuery.sizeOf(context).width - 24;
        return SizedBox(
          width: availableWidth.clamp(280.0, 420.0),
          child: _buildPanel(
            layout: _MyColorPickerPanelLayout.compact,
            onEyeDropperRequested: _pickFromPopover,
          ),
        );
      },
      child: _buildTrigger(),
    );
  }
}

class _ColorPickerDialogResult {
  const _ColorPickerDialogResult._({
    required this.color,
    required this.pickFromScreen,
  });

  const _ColorPickerDialogResult.save(Color color)
    : this._(color: color, pickFromScreen: false);

  const _ColorPickerDialogResult.pick(Color color)
    : this._(color: color, pickFromScreen: true);

  final Color color;
  final bool pickFromScreen;
}

class MyColorPickerFormField extends MyFormBuilderField<Color> {
  MyColorPickerFormField({
    required super.initialValue,
    super.key,
    super.id,
    super.onSaved,
    super.validator,
    super.enabled,
    super.autovalidateMode,
    super.restorationId,
    super.label,
    super.error,
    super.description,
    super.onChanged,
    super.valueTransformer,
    super.onReset,
    super.decorationBuilder,
    bool showAlpha = false,
    bool showLabel = false,
    bool showHistory = true,
    bool enableEyeDropper = true,
    MyColorPickerMode initialMode = MyColorPickerMode.rgb,
    MyColorPickerPresentation presentation = MyColorPickerPresentation.popover,
    Widget? placeholder,
    Widget? dialogTitle,
    MyAnchorBase? popoverAnchor,
    EdgeInsetsGeometry? popoverPadding,
    Object? popoverGroupId,
  }) : super(
         builder: (field) {
           return MyColorPicker(
             value: field.value ?? initialValue!,
             enabled: field.widget.enabled,
             showAlpha: showAlpha,
             showLabel: showLabel,
             showHistory: showHistory,
             enableEyeDropper: enableEyeDropper,
             initialMode: initialMode,
             presentation: presentation,
             placeholder: placeholder,
             dialogTitle: dialogTitle,
             popoverAnchor: popoverAnchor,
             popoverPadding: popoverPadding,
             popoverGroupId: popoverGroupId,
             onChanged: field.didChange,
           );
         },
       );
}

class _ColorPickerTrigger extends StatelessWidget {
  const _ColorPickerTrigger({
    required this.color,
    required this.enabled,
    required this.showLabel,
    required this.showAlpha,
    this.placeholder,
    this.width,
    this.onTap,
  });

  final Color color;
  final bool enabled;
  final bool showLabel;
  final bool showAlpha;
  final Widget? placeholder;
  final double? width;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final swatch = _ColorSwatch(color: color, size: 24);
    final child = showLabel
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child:
                    placeholder ??
                    Text(
                      _formatColor(color, showAlpha: showAlpha),
                      overflow: TextOverflow.ellipsis,
                    ),
              ),
              const Gap(10),
              swatch,
            ],
          )
        : swatch;

    return MyButton(
      enabled: enabled,
      type: MyButtonType.outline,
      shape: MyButtonShape.rectangle,
      width: width,
      padding: showLabel
          ? const EdgeInsets.symmetric(horizontal: 10, vertical: 5)
          : const EdgeInsets.all(3),
      onTap: onTap,
      child: child,
    );
  }
}

class _MyColorPickerPanel extends StatefulWidget {
  const _MyColorPickerPanel({
    required this.value,
    required this.initialMode,
    required this.showAlpha,
    required this.showHistory,
    required this.enableEyeDropper,
    required this.layout,
    required this.overlayGroupId,
    this.showHistoryView,
    this.showToolButtons = true,
    this.historyController,
    this.onEyeDropperRequested,
    this.onHistorySelected,
    this.onChanged,
    this.onChanging,
  });

  final Color value;
  final MyColorPickerMode initialMode;
  final bool showAlpha;
  final bool showHistory;
  final bool enableEyeDropper;
  final _MyColorPickerPanelLayout layout;
  final Object overlayGroupId;
  final bool? showHistoryView;
  final bool showToolButtons;
  final MyColorHistoryController? historyController;
  final Future<void> Function()? onEyeDropperRequested;
  final ValueChanged<Color>? onHistorySelected;
  final ValueChanged<Color>? onChanged;
  final ValueChanged<Color>? onChanging;

  @override
  State<_MyColorPickerPanel> createState() => _MyColorPickerPanelState();
}

class _MyColorPickerPanelState extends State<_MyColorPickerPanel> {
  late MyColorPickerMode _mode;
  late Color _value;
  bool _showHistory = false;

  @override
  void initState() {
    super.initState();
    _mode = widget.initialMode;
    _value = widget.value;
  }

  @override
  void didUpdateWidget(covariant _MyColorPickerPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _value = widget.value;
    }
  }

  void _emitChanging(Color color) {
    setState(() => _value = color);
    widget.onChanging?.call(color);
  }

  void _emitChanged(Color color) {
    setState(() => _value = color);
    widget.onChanged?.call(color);
  }

  void _selectHistoryColor(Color color) {
    setState(() {
      _value = color;
      if (widget.layout == _MyColorPickerPanelLayout.stacked &&
          widget.showHistoryView == null) {
        _showHistory = false;
      }
    });
    widget.onChanged?.call(color);
    widget.onHistorySelected?.call(color);
  }

  Future<void> _pickFromScreen() async {
    if (widget.onEyeDropperRequested case final callback?) {
      await callback();
      return;
    }
    final scope = MyEyeDropperLayer.maybeOf(context);
    if (scope == null) return;
    final result = await scope.pickColor(MyRecentColorsScope.maybeOf(context));
    if (result != null && mounted) {
      _emitChanged(_withPreviousAlpha(result, _value, widget.showAlpha));
    }
  }

  bool get _historyVisible => widget.showHistoryView ?? _showHistory;

  Widget _buildPlane() {
    return RepaintBoundary(
      child: _ColorPlane(
        color: _value,
        mode: _mode,
        onChanging: _emitChanging,
        onChanged: _emitChanged,
      ),
    );
  }

  Widget _buildCompact(MyColorHistoryController? history) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 252,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Center(
                  child: AspectRatio(aspectRatio: 1, child: _buildPlane()),
                ),
              ),
              const Gap(12),
              SizedBox(
                width: 24,
                child: RepaintBoundary(
                  child: _HueSlider(
                    color: _value,
                    axis: Axis.vertical,
                    onChanging: _emitChanging,
                    onChanged: _emitChanged,
                  ),
                ),
              ),
              if (widget.showAlpha) ...[
                const Gap(8),
                SizedBox(
                  width: 24,
                  child: RepaintBoundary(
                    child: _AlphaSlider(
                      color: _value,
                      axis: Axis.vertical,
                      onChanging: _emitChanging,
                      onChanged: _emitChanged,
                    ),
                  ),
                ),
              ],
              if (widget.showHistory && history != null) ...[
                const Gap(12),
                SizedBox(
                  width: 68,
                  child: _ColorHistoryGrid(
                    controller: history,
                    selectedColor: _value,
                    crossAxisCount: 2,
                    slotCount: 14,
                    spacing: 4,
                    onSelected: _selectHistoryColor,
                  ),
                ),
              ],
            ],
          ),
        ),
        const Gap(12),
        _buildControlRow(history, showHistoryButton: false),
      ],
    );
  }

  Widget _buildStacked(MyColorHistoryController? history) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_historyVisible && widget.showHistory && history != null)
          _ColorHistoryGrid(
            controller: history,
            selectedColor: _value,
            slotCount: 16,
            onSelected: _selectHistoryColor,
          )
        else ...[
          AspectRatio(aspectRatio: 1, child: _buildPlane()),
          const Gap(12),
          SizedBox(
            height: 24,
            child: RepaintBoundary(
              child: _HueSlider(
                color: _value,
                axis: Axis.horizontal,
                onChanging: _emitChanging,
                onChanged: _emitChanged,
              ),
            ),
          ),
          if (widget.showAlpha) ...[
            const Gap(8),
            SizedBox(
              height: 24,
              child: RepaintBoundary(
                child: _AlphaSlider(
                  color: _value,
                  axis: Axis.horizontal,
                  onChanging: _emitChanging,
                  onChanged: _emitChanged,
                ),
              ),
            ),
          ],
        ],
        const Gap(12),
        _buildControlRow(history, showHistoryButton: true),
      ],
    );
  }

  Widget _buildControlRow(
    MyColorHistoryController? history, {
    required bool showHistoryButton,
  }) {
    final showEyeDropper = widget.showToolButtons && widget.enableEyeDropper;
    final showHistoryToggle =
        widget.showToolButtons &&
        showHistoryButton &&
        widget.showHistory &&
        history != null;
    return Row(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (showEyeDropper)
          MyButton(
            key: const Key('my-color-picker-eye-dropper'),
            height: 40,
            width: 40,
            type: MyButtonType.outline,
            shape: MyButtonShape.square,
            icon: LucideIcons.pipette,
            onTap: _pickFromScreen,
          ),
        if (showHistoryToggle)
          MyButton(
            key: const Key('my-color-picker-history-toggle'),
            type: _historyVisible ? MyButtonType.primary : MyButtonType.outline,
            shape: MyButtonShape.square,
            icon: LucideIcons.history,
            onTap: () => setState(() => _showHistory = !_showHistory),
          ),
        Expanded(
          child: _ColorInputs(
            value: _value,
            mode: _mode,
            showAlpha: widget.showAlpha,
            overlayGroupId: widget.overlayGroupId,
            onModeChanged: (mode) => setState(() => _mode = mode),
            onChanged: _emitChanged,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final history =
        widget.historyController ?? MyRecentColorsScope.maybeOf(context);
    if (widget.layout == _MyColorPickerPanelLayout.stacked) {
      return _buildStacked(history);
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 390) return _buildStacked(history);
        return _buildCompact(history);
      },
    );
  }
}

class _ColorInputs extends StatelessWidget {
  const _ColorInputs({
    required this.value,
    required this.mode,
    required this.showAlpha,
    required this.overlayGroupId,
    required this.onModeChanged,
    required this.onChanged,
  });

  final Color value;
  final MyColorPickerMode mode;
  final bool showAlpha;
  final Object overlayGroupId;
  final ValueChanged<MyColorPickerMode> onModeChanged;
  final ValueChanged<Color> onChanged;

  @override
  Widget build(BuildContext context) {
    final inputs = switch (mode) {
      MyColorPickerMode.rgb => _buildRgbInputs(),
      MyColorPickerMode.hsl => _buildHslInputs(),
      MyColorPickerMode.hsv => _buildHsvInputs(),
      MyColorPickerMode.hex => _buildHexInputs(),
    };
    final selector = SizedBox(
      height: 40,
      width: 86,
      child: MySelect<MyColorPickerMode>(
        key: const Key('my-color-picker-mode-select'),
        initialValue: mode,
        groupId: overlayGroupId,
        selectedOptionBuilder: (context, value) => Text(_modeLabel(value)),
        options: [
          for (final item in MyColorPickerMode.values)
            MyOption(value: item, child: Text(_modeLabel(item))),
        ],
        onChanged: (value) {
          if (value != null) onModeChanged(value);
        },
      ),
    );
    final requiredWidth =
        92 +
        8 +
        switch (mode) {
          MyColorPickerMode.rgb ||
          MyColorPickerMode.hsl ||
          MyColorPickerMode.hsv => inputs.length * 58,
          MyColorPickerMode.hex => showAlpha ? 118 : 96,
        };
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= requiredWidth) {
          return Row(spacing: 6, children: [selector, ...inputs]);
        }
        return Wrap(
          spacing: 6,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [selector, ...inputs],
        );
      },
    );
  }

  List<Widget> _buildRgbInputs() {
    return [
      _NumberInput(
        key: const Key('my-color-picker-r-input'),
        value: _channel(value.r).toString(),
        placeholder: 'R',
        max: 255,
        onChanged: (number) =>
            onChanged(value.withValues(red: number.clamp(0, 255) / 255)),
      ),
      _NumberInput(
        key: const Key('my-color-picker-g-input'),
        value: _channel(value.g).toString(),
        placeholder: 'G',
        max: 255,
        onChanged: (number) =>
            onChanged(value.withValues(green: number.clamp(0, 255) / 255)),
      ),
      _NumberInput(
        key: const Key('my-color-picker-b-input'),
        value: _channel(value.b).toString(),
        placeholder: 'B',
        max: 255,
        onChanged: (number) =>
            onChanged(value.withValues(blue: number.clamp(0, 255) / 255)),
      ),
      if (showAlpha)
        _NumberInput(
          key: const Key('my-color-picker-a-input'),
          value: _channel(value.a).toString(),
          placeholder: 'A',
          max: 255,
          onChanged: (number) =>
              onChanged(value.withValues(alpha: number.clamp(0, 255) / 255)),
        ),
    ];
  }

  List<Widget> _buildHslInputs() {
    final hsl = HSLColor.fromColor(value);
    return [
      _NumberInput(
        key: const Key('my-color-picker-hsl-h-input'),
        value: hsl.hue.round().toString(),
        placeholder: 'H',
        max: 360,
        onChanged: (number) =>
            onChanged(hsl.withHue(number.clamp(0, 360).toDouble()).toColor()),
      ),
      _NumberInput(
        key: const Key('my-color-picker-hsl-s-input'),
        value: (hsl.saturation * 100).round().toString(),
        placeholder: 'S',
        max: 100,
        onChanged: (number) =>
            onChanged(hsl.withSaturation(number.clamp(0, 100) / 100).toColor()),
      ),
      _NumberInput(
        key: const Key('my-color-picker-hsl-l-input'),
        value: (hsl.lightness * 100).round().toString(),
        placeholder: 'L',
        max: 100,
        onChanged: (number) =>
            onChanged(hsl.withLightness(number.clamp(0, 100) / 100).toColor()),
      ),
      if (showAlpha)
        _NumberInput(
          key: const Key('my-color-picker-hsl-a-input'),
          value: (value.a * 100).round().toString(),
          placeholder: 'A',
          max: 100,
          onChanged: (number) =>
              onChanged(value.withValues(alpha: number.clamp(0, 100) / 100)),
        ),
    ];
  }

  List<Widget> _buildHsvInputs() {
    final hsv = HSVColor.fromColor(value);
    return [
      _NumberInput(
        key: const Key('my-color-picker-hsv-h-input'),
        value: hsv.hue.round().toString(),
        placeholder: 'H',
        max: 360,
        onChanged: (number) =>
            onChanged(hsv.withHue(number.clamp(0, 360).toDouble()).toColor()),
      ),
      _NumberInput(
        key: const Key('my-color-picker-hsv-s-input'),
        value: (hsv.saturation * 100).round().toString(),
        placeholder: 'S',
        max: 100,
        onChanged: (number) =>
            onChanged(hsv.withSaturation(number.clamp(0, 100) / 100).toColor()),
      ),
      _NumberInput(
        key: const Key('my-color-picker-hsv-v-input'),
        value: (hsv.value * 100).round().toString(),
        placeholder: 'V',
        max: 100,
        onChanged: (number) =>
            onChanged(hsv.withValue(number.clamp(0, 100) / 100).toColor()),
      ),
      if (showAlpha)
        _NumberInput(
          key: const Key('my-color-picker-hsv-a-input'),
          value: (value.a * 100).round().toString(),
          placeholder: 'A',
          max: 100,
          onChanged: (number) =>
              onChanged(value.withValues(alpha: number.clamp(0, 100) / 100)),
        ),
    ];
  }

  List<Widget> _buildHexInputs() {
    return [
      SizedBox(
        width: showAlpha ? 118 : 96,
        child: _TextValueInput(
          key: const Key('my-color-picker-hex-input'),
          value: _formatColor(value, showAlpha: showAlpha),
          placeholder: showAlpha ? '#AARRGGBB' : '#RRGGBB',
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[#a-fA-F0-9]')),
            LengthLimitingTextInputFormatter(showAlpha ? 9 : 7),
          ],
          onChanged: (text) {
            final normalized = text.trim().replaceFirst('#', '');
            if (normalized.length == 6 || normalized.length == 8) {
              try {
                final parsed = normalized.fromHex();
                onChanged(
                  showAlpha ? parsed : parsed.withValues(alpha: value.a),
                );
              } on FormatException {
                return;
              }
            }
          },
        ),
      ),
    ];
  }
}

class _NumberInput extends StatelessWidget {
  const _NumberInput({
    required this.value,
    required this.placeholder,
    required this.max,
    required this.onChanged,
    super.key,
  });

  final String value;
  final String placeholder;
  final int max;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 58,
      child: _TextValueInput(
        value: value,
        placeholder: placeholder,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(max == 360 ? 3 : 3),
        ],
        onChanged: (text) {
          final number = double.tryParse(text);
          if (number != null) onChanged(number);
        },
      ),
    );
  }
}

class _TextValueInput extends StatefulWidget {
  const _TextValueInput({
    required this.value,
    required this.placeholder,
    required this.onChanged,
    this.keyboardType,
    this.inputFormatters,
    super.key,
  });

  final String value;
  final String placeholder;
  final ValueChanged<String> onChanged;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  @override
  State<_TextValueInput> createState() => _TextValueInputState();
}

class _TextValueInputState extends State<_TextValueInput> {
  late final TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
    _focusNode.addListener(_handleFocus);
  }

  @override
  void didUpdateWidget(covariant _TextValueInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_focusNode.hasFocus && widget.value != _controller.text) {
      _controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocus);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _handleFocus() {
    if (!_focusNode.hasFocus && widget.value != _controller.text) {
      _controller.text = widget.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyInput(
      controller: _controller,
      focusNode: _focusNode,
      placeholder: widget.placeholder,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters,
      onChanged: widget.onChanged,
    );
  }
}

class _ColorPlane extends StatefulWidget {
  const _ColorPlane({
    required this.color,
    required this.mode,
    this.onChanging,
    this.onChanged,
  });

  final Color color;
  final MyColorPickerMode mode;
  final ValueChanged<Color>? onChanging;
  final ValueChanged<Color>? onChanged;

  @override
  State<_ColorPlane> createState() => _ColorPlaneState();
}

class _ColorPlaneState extends State<_ColorPlane> {
  Color? _latestDragColor;

  Color _colorAt(Offset local, Size size) {
    final dx = (local.dx / size.width).clamp(0.0, 1.0);
    final dy = (local.dy / size.height).clamp(0.0, 1.0);
    final hsv = HSVColor.fromColor(widget.color);
    final hsl = HSLColor.fromColor(widget.color);
    return switch (widget.mode) {
      MyColorPickerMode.hsl => HSLColor.fromAHSL(
        widget.color.a,
        hsl.hue,
        dy,
        dx,
      ).toColor(),
      _ => HSVColor.fromAHSV(widget.color.a, hsv.hue, dy, dx).toColor(),
    };
  }

  void _updateDrag(Offset local, Size size) {
    final next = _colorAt(local, size);
    _latestDragColor = next;
    widget.onChanging?.call(next);
  }

  void _commitDrag() {
    final next = _latestDragColor;
    _latestDragColor = null;
    if (next != null) widget.onChanged?.call(next);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        return GestureDetector(
          key: const Key('my-color-picker-plane'),
          onTapDown: (details) =>
              widget.onChanged?.call(_colorAt(details.localPosition, size)),
          onPanStart: (details) => _updateDrag(details.localPosition, size),
          onPanUpdate: (details) => _updateDrag(details.localPosition, size),
          onPanEnd: (_) => _commitDrag(),
          onPanCancel: () => _latestDragColor = null,
          child: ClipRRect(
            borderRadius: MyBorderRadius.medium,
            child: CustomPaint(
              painter: _ColorPlanePainter(
                color: widget.color,
                mode: widget.mode,
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: _planeAlignment(widget.color, widget.mode),
                    child: _ColorHandle(color: widget.color),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _HueSlider extends StatefulWidget {
  const _HueSlider({
    required this.color,
    required this.axis,
    this.onChanging,
    this.onChanged,
  });

  final Color color;
  final Axis axis;
  final ValueChanged<Color>? onChanging;
  final ValueChanged<Color>? onChanged;

  @override
  State<_HueSlider> createState() => _HueSliderState();
}

class _HueSliderState extends State<_HueSlider> {
  Color? _latestDragColor;

  Color _colorAt(Offset local, Size size) {
    final ratio = widget.axis == Axis.horizontal
        ? (local.dx / size.width).clamp(0.0, 1.0)
        : (local.dy / size.height).clamp(0.0, 1.0);
    return HSVColor.fromColor(widget.color).withHue(ratio * 360).toColor();
  }

  void _updateDrag(Offset local, Size size) {
    final next = _colorAt(local, size);
    _latestDragColor = next;
    widget.onChanging?.call(next);
  }

  void _commitDrag() {
    final next = _latestDragColor;
    _latestDragColor = null;
    if (next != null) widget.onChanged?.call(next);
  }

  @override
  Widget build(BuildContext context) {
    final hue = HSVColor.fromColor(widget.color).hue / 360;
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        return GestureDetector(
          key: const Key('my-color-picker-hue-slider'),
          onTapDown: (details) =>
              widget.onChanged?.call(_colorAt(details.localPosition, size)),
          onPanStart: (details) => _updateDrag(details.localPosition, size),
          onPanUpdate: (details) => _updateDrag(details.localPosition, size),
          onPanEnd: (_) => _commitDrag(),
          onPanCancel: () => _latestDragColor = null,
          child: ClipRRect(
            borderRadius: MyBorderRadius.small,
            child: CustomPaint(
              painter: _HueSliderPainter(widget.axis),
              child: Align(
                alignment: widget.axis == Axis.horizontal
                    ? Alignment(hue * 2 - 1, 0)
                    : Alignment(0, hue * 2 - 1),
                child: _SliderHandle(color: widget.color, axis: widget.axis),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AlphaSlider extends StatefulWidget {
  const _AlphaSlider({
    required this.color,
    required this.axis,
    this.onChanging,
    this.onChanged,
  });

  final Color color;
  final Axis axis;
  final ValueChanged<Color>? onChanging;
  final ValueChanged<Color>? onChanged;

  @override
  State<_AlphaSlider> createState() => _AlphaSliderState();
}

class _AlphaSliderState extends State<_AlphaSlider> {
  Color? _latestDragColor;

  Color _colorAt(Offset local, Size size) {
    final ratio = widget.axis == Axis.horizontal
        ? (local.dx / size.width).clamp(0.0, 1.0)
        : (local.dy / size.height).clamp(0.0, 1.0);
    return widget.color.withValues(alpha: ratio);
  }

  void _updateDrag(Offset local, Size size) {
    final next = _colorAt(local, size);
    _latestDragColor = next;
    widget.onChanging?.call(next);
  }

  void _commitDrag() {
    final next = _latestDragColor;
    _latestDragColor = null;
    if (next != null) widget.onChanged?.call(next);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        return GestureDetector(
          key: const Key('my-color-picker-alpha-slider'),
          onTapDown: (details) =>
              widget.onChanged?.call(_colorAt(details.localPosition, size)),
          onPanStart: (details) => _updateDrag(details.localPosition, size),
          onPanUpdate: (details) => _updateDrag(details.localPosition, size),
          onPanEnd: (_) => _commitDrag(),
          onPanCancel: () => _latestDragColor = null,
          child: ClipRRect(
            borderRadius: MyBorderRadius.small,
            child: CustomPaint(
              painter: _AlphaSliderPainter(widget.color, widget.axis),
              child: Align(
                alignment: widget.axis == Axis.horizontal
                    ? Alignment(widget.color.a * 2 - 1, 0)
                    : Alignment(0, widget.color.a * 2 - 1),
                child: _SliderHandle(color: widget.color, axis: widget.axis),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ColorHistoryGrid extends StatelessWidget {
  const _ColorHistoryGrid({
    required this.controller,
    required this.selectedColor,
    required this.onSelected,
    this.crossAxisCount = 8,
    this.slotCount,
    this.spacing = 6,
  });

  final MyColorHistoryController controller;
  final Color selectedColor;
  final ValueChanged<Color> onSelected;
  final int crossAxisCount;
  final int? slotCount;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final colors = controller.recentColors;
        final itemCount =
            slotCount ?? (colors.isEmpty ? crossAxisCount : colors.length);
        return GridView.builder(
          key: const Key('my-color-picker-history-grid'),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
          ),
          itemCount: itemCount,
          itemBuilder: (context, index) {
            if (index >= colors.length) {
              return DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(color: context.colorScheme.border),
                  borderRadius: MyBorderRadius.small,
                ),
              );
            }
            final color = colors[index];
            return GestureDetector(
              key: Key('my-color-picker-history-color-$index'),
              onTap: () => onSelected(color),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: MyBorderRadius.small,
                  border: Border.all(
                    color: color == selectedColor
                        ? context.colorScheme.primary
                        : context.colorScheme.border,
                    width: color == selectedColor ? 2 : 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(3),
                  child: _ColorSwatch(color: color),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _ColorSwatch extends StatelessWidget {
  const _ColorSwatch({required this.color, this.size});

  final Color color;
  final double? size;

  @override
  Widget build(BuildContext context) {
    Widget child = ClipRRect(
      borderRadius: MyBorderRadius.small,
      child: CustomPaint(
        painter: const _CheckerPainter(),
        child: ColoredBox(color: color),
      ),
    );
    if (size != null) {
      child = SizedBox.square(dimension: size, child: child);
    }
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: context.colorScheme.border),
        borderRadius: MyBorderRadius.small,
      ),
      child: child,
    );
  }
}

class _ColorHandle extends StatelessWidget {
  const _ColorHandle({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
      ),
    );
  }
}

class _SliderHandle extends StatelessWidget {
  const _SliderHandle({required this.color, required this.axis});

  final Color color;
  final Axis axis;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: axis == Axis.horizontal ? 14 : double.infinity,
      height: axis == Axis.horizontal ? double.infinity : 14,
      decoration: BoxDecoration(
        color: color,
        borderRadius: MyBorderRadius.small,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
      ),
    );
  }
}

class _ColorPlanePainter extends CustomPainter {
  const _ColorPlanePainter({required this.color, required this.mode});

  final Color color;
  final MyColorPickerMode mode;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final hueColor = HSVColor.fromColor(
      color,
    ).withSaturation(1).withValue(1).withAlpha(1).toColor();
    final isHsl = mode == MyColorPickerMode.hsl;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          colors: isHsl
              ? const [Colors.black, Color(0xFF808080), Colors.white]
              : const [Colors.black, Colors.white],
          stops: isHsl ? const [0, 0.5, 1] : null,
        ).createShader(rect),
    );
    canvas.saveLayer(rect, Paint());
    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          colors: isHsl
              ? [Colors.black, hueColor, Colors.white]
              : [Colors.black, hueColor],
          stops: isHsl ? const [0, 0.5, 1] : null,
        ).createShader(rect),
    );
    canvas.drawRect(
      rect,
      Paint()
        ..blendMode = BlendMode.dstIn
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.white],
        ).createShader(rect),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ColorPlanePainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.mode != mode;
}

class _HueSliderPainter extends CustomPainter {
  const _HueSliderPainter(this.axis);

  final Axis axis;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: axis == Axis.horizontal
              ? Alignment.centerLeft
              : Alignment.topCenter,
          end: axis == Axis.horizontal
              ? Alignment.centerRight
              : Alignment.bottomCenter,
          colors: const [
            Color(0xFFFF0000),
            Color(0xFFFFFF00),
            Color(0xFF00FF00),
            Color(0xFF00FFFF),
            Color(0xFF0000FF),
            Color(0xFFFF00FF),
            Color(0xFFFF0000),
          ],
        ).createShader(rect),
    );
  }

  @override
  bool shouldRepaint(covariant _HueSliderPainter oldDelegate) =>
      oldDelegate.axis != axis;
}

class _AlphaSliderPainter extends CustomPainter {
  const _AlphaSliderPainter(this.color, this.axis);

  final Color color;
  final Axis axis;

  @override
  void paint(Canvas canvas, Size size) {
    const _CheckerPainter().paint(canvas, size);
    final rect = Offset.zero & size;
    final opaque = color.withValues(alpha: 1);
    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: axis == Axis.horizontal
              ? Alignment.centerLeft
              : Alignment.topCenter,
          end: axis == Axis.horizontal
              ? Alignment.centerRight
              : Alignment.bottomCenter,
          colors: [opaque.withValues(alpha: 0), opaque],
        ).createShader(rect),
    );
  }

  @override
  bool shouldRepaint(covariant _AlphaSliderPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.axis != axis;
}

class _CheckerPainter extends CustomPainter {
  const _CheckerPainter();

  @override
  void paint(Canvas canvas, Size size) {
    const cell = 8.0;
    final paint = Paint()..color = const Color(0xFFE5E7EB);
    canvas.drawRect(Offset.zero & size, paint);
    paint.color = const Color(0xFFBFC5CE);
    for (var y = 0.0; y < size.height; y += cell) {
      for (var x = 0.0; x < size.width; x += cell) {
        final odd = ((x / cell).floor() + (y / cell).floor()).isOdd;
        if (odd) canvas.drawRect(Rect.fromLTWH(x, y, cell, cell), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _CheckerPainter oldDelegate) => false;
}

class _EyeDropperPreviewPainter extends CustomPainter {
  const _EyeDropperPreviewPainter({
    required this.colors,
    required this.borderColor,
    required this.selectedColor,
  });

  final List<Color> colors;
  final Color borderColor;
  final Color selectedColor;

  @override
  void paint(Canvas canvas, Size size) {
    final count = colors.isEmpty ? 1 : colors.length;
    final side = count.sqrtFloor();
    final cell = size.width / side;
    final paint = Paint();
    for (var index = 0; index < colors.length; index++) {
      final x = index % side;
      final y = index ~/ side;
      paint.color = colors[index];
      paint.style = PaintingStyle.fill;
      canvas.drawRect(Rect.fromLTWH(x * cell, y * cell, cell, cell), paint);
    }
    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = borderColor;
    for (var i = 0; i <= side; i++) {
      final p = i * cell;
      canvas.drawLine(Offset(p, 0), Offset(p, size.height), paint);
      canvas.drawLine(Offset(0, p), Offset(size.width, p), paint);
    }
    paint
      ..strokeWidth = 2
      ..color = selectedColor;
    final center = side ~/ 2;
    canvas.drawRect(
      Rect.fromLTWH(center * cell, center * cell, cell, cell),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _EyeDropperPreviewPainter oldDelegate) =>
      !listEquals(colors, oldDelegate.colors) ||
      borderColor != oldDelegate.borderColor ||
      selectedColor != oldDelegate.selectedColor;
}

class _ScreenshotResult {
  const _ScreenshotResult({
    required this.bytes,
    required this.width,
    required this.height,
  });

  final Uint8List bytes;
  final int width;
  final int height;

  Color colorAt(Offset position) {
    final x = position.dx.floor().clamp(0, width - 1);
    final y = position.dy.floor().clamp(0, height - 1);
    final index = (y * width + x) * 4;
    return Color.fromARGB(
      bytes[index + 3],
      bytes[index],
      bytes[index + 1],
      bytes[index + 2],
    );
  }

  List<Color> sample(Offset center, Size size) {
    final side = size.shortestSide.floor().clamp(3, 15);
    final radius = side ~/ 2;
    final colors = <Color>[];
    for (var y = -radius; y <= radius; y++) {
      for (var x = -radius; x <= radius; x++) {
        colors.add(colorAt(center.translate(x.toDouble(), y.toDouble())));
      }
    }
    return colors;
  }
}

class _EyeDropperPreview {
  const _EyeDropperPreview({required this.color, required this.colors});

  final Color color;
  final List<Color> colors;
}

String _modeLabel(MyColorPickerMode mode) {
  return switch (mode) {
    MyColorPickerMode.rgb => 'RGB',
    MyColorPickerMode.hsl => 'HSL',
    MyColorPickerMode.hsv => 'HSV',
    MyColorPickerMode.hex => 'HEX',
  };
}

String _formatColor(Color color, {required bool showAlpha}) {
  final hex = color.toHex(leadingHashSign: true).toUpperCase();
  return showAlpha ? hex : '#${hex.substring(3)}';
}

int _channel(double value) => (value * 255).round().clamp(0, 255);

Alignment _planeAlignment(Color color, MyColorPickerMode mode) {
  if (mode == MyColorPickerMode.hsl) {
    final hsl = HSLColor.fromColor(color);
    return Alignment(hsl.lightness * 2 - 1, hsl.saturation * 2 - 1);
  }
  final hsv = HSVColor.fromColor(color);
  return Alignment(hsv.value * 2 - 1, hsv.saturation * 2 - 1);
}

Color _withPreviousAlpha(Color next, Color previous, bool showAlpha) {
  return showAlpha ? next : next.withValues(alpha: previous.a);
}

extension _Let<T> on T {
  R let<R>(R Function(T value) transform) => transform(this);
}

extension _SqrtFloor on int {
  int sqrtFloor() {
    var side = 1;
    while ((side + 1) * (side + 1) <= this) {
      side++;
    }
    return side;
  }
}
