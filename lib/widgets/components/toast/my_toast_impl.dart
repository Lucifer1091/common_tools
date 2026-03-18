part of 'my_toast.dart';

class _MyToastImpl {
  const _MyToastImpl._();

  static final _toastControllers = Queue<ToastController>();
  static final List<_ActiveToastOverlay> _activeToasts = [];
  static BuildContext? _context;
  static OverlayState? _overlayState;
  static const double _stackGap = 14;
  static const double _expandedStackGap = 10;
  static const double _stackScaleStep = .03;
  static const double _minStackScale = .82;
  static const double _estimatedToastHeight = 72;

  /// Initialize context early so that toasts can be shown without context later.
  // ignore: avoid_setters_without_getters
  static set context(BuildContext context) => _context = context;

  /// Initialize overlay state early so that toasts can be shown without overlay state later.
  // ignore: avoid_setters_without_getters
  static set overlayState(OverlayState overlayState) =>
      _overlayState = overlayState;

  static OverlayState? _resolveOverlayState({
    BuildContext? context,
    OverlayState? overlayState,
  }) {
    if (overlayState?.mounted ?? false) return overlayState;

    if (context?.mounted != true) return null;

    final BuildContext safeContext = context!;
    final OverlayState? navigatorOverlay =
        Navigator.maybeOf(safeContext, rootNavigator: true)?.overlay;
    if (navigatorOverlay?.mounted ?? false) return navigatorOverlay;

    final OverlayState? contextOverlay = Overlay.maybeOf(
      safeContext,
      rootOverlay: true,
    );
    if (contextOverlay?.mounted ?? false) return contextOverlay;

    return null;
  }

  static _ToastStackTransform _resolveStackTransform({
    required String toastId,
    required OverlayState overlayState,
    required Alignment alignment,
  }) {
    final alignedToasts =
        _activeToasts
            .where(
              (toast) =>
                  toast.overlayState == overlayState &&
                  toast.alignment == alignment,
            )
            .toList();
    final int toastIndex = alignedToasts.indexWhere(
      (toast) => toast.id == toastId,
    );
    if (toastIndex == -1) return const _ToastStackTransform();

    final bool isExpanded = _isStackExpanded(
      overlayState: overlayState,
      alignment: alignment,
    );
    final double direction = alignment.y < 0 ? 1 : -1;
    final double offsetY =
        direction *
        (isExpanded
            ? _resolveExpandedOffset(alignedToasts, toastIndex)
            : _resolveCollapsedOffset(alignedToasts.length, toastIndex));
    final double scale =
        isExpanded
            ? 1
            : (1 - ((alignedToasts.length - toastIndex - 1) * _stackScaleStep))
                .clamp(_minStackScale, 1)
                .toDouble();

    return _ToastStackTransform(offsetY: offsetY, scale: scale);
  }

  static double _resolveCollapsedOffset(int totalToasts, int toastIndex) {
    final int indexFromLast = totalToasts - toastIndex - 1;
    return indexFromLast * _stackGap;
  }

  static double _resolveExpandedOffset(
    List<_ActiveToastOverlay> alignedToasts,
    int toastIndex,
  ) {
    double offset = 0;
    for (int index = toastIndex + 1; index < alignedToasts.length; index++) {
      final toast = alignedToasts[index];
      final double toastHeight =
          toast.height > 0 ? toast.height : _estimatedToastHeight;
      offset += toastHeight + _expandedStackGap;
    }
    return offset;
  }

  static bool _isStackExpanded({
    required OverlayState overlayState,
    required Alignment alignment,
  }) {
    return _activeToasts.any(
      (toast) =>
          toast.overlayState == overlayState &&
          toast.alignment == alignment &&
          toast.expandOnHover &&
          toast.isHovering,
    );
  }

  static void _rebuildActiveToasts({
    required OverlayState overlayState,
    required Alignment alignment,
  }) {
    for (final toast in _activeToasts) {
      if (toast.overlayState == overlayState &&
          toast.alignment == alignment &&
          toast.overlayEntry.mounted) {
        toast.overlayEntry.markNeedsBuild();
      }
    }
  }

  static _ActiveToastOverlay? _removeActiveToast(String toastId) {
    final int index = _activeToasts.indexWhere((toast) => toast.id == toastId);
    if (index == -1) return null;

    return _activeToasts.removeAt(index);
  }

  static _ActiveToastOverlay? _findActiveToast(String toastId) {
    final int index = _activeToasts.indexWhere((toast) => toast.id == toastId);
    if (index == -1) return null;

    return _activeToasts[index];
  }

  static void _updateToastHover({
    required String toastId,
    required bool isHovering,
  }) {
    final toast = _findActiveToast(toastId);
    if (toast == null || toast.isHovering == isHovering) return;

    toast.isHovering = isHovering;
    _rebuildActiveToasts(
      overlayState: toast.overlayState,
      alignment: toast.alignment,
    );
  }

  static void _updateToastHeight({
    required String toastId,
    required double height,
  }) {
    final toast = _findActiveToast(toastId);
    if (toast == null) return;

    final double nextHeight = height <= 0 ? 0 : height;
    if ((toast.height - nextHeight).abs() < .5) return;

    toast.height = nextHeight;
    if (_isStackExpanded(
      overlayState: toast.overlayState,
      alignment: toast.alignment,
    )) {
      _rebuildActiveToasts(
        overlayState: toast.overlayState,
        alignment: toast.alignment,
      );
    }
  }

  static ToastController _showToast({
    required Alignment alignment,
    required bool expandOnHover,
    required Widget Function({
      required ToastController controller,
      required _ToastStackTransform stackTransform,
    })
    builder,
    BuildContext? context,
    OverlayState? overlayState,
    void Function()? onDisposed,
  }) {
    context ??= _context;
    overlayState ??= _overlayState;

    final OverlayState? resolvedOverlayState = _resolveOverlayState(
      context: context,
      overlayState: overlayState,
    );

    if (resolvedOverlayState == null) return ToastController.empty();

    final CapturedThemes? capturedThemes =
        (context?.mounted ?? false)
            ? InheritedTheme.capture(
              from: context!,
              to: resolvedOverlayState.context,
            )
            : null;

    final String toastId = Guid.uuid();
    late final OverlayEntry overlayEntry;

    final toastController = ToastController(
      id: toastId,
      close: () {
        if (overlayEntry.mounted) {
          overlayEntry
            ..remove()
            ..dispose();
          onDisposed?.call();
        }

        _toastControllers.removeWhere((toast) => toast.id == toastId);
        final removedToast = _removeActiveToast(toastId);
        if (removedToast != null) {
          _rebuildActiveToasts(
            overlayState: removedToast.overlayState,
            alignment: removedToast.alignment,
          );
        }
      },
    );

    overlayEntry = OverlayEntry(
      builder: (overlayContext) {
        final stackTransform = _resolveStackTransform(
          toastId: toastId,
          overlayState: resolvedOverlayState,
          alignment: alignment,
        );

        Widget child = builder(
          controller: toastController,
          stackTransform: stackTransform,
        );

        if (capturedThemes != null) {
          child = capturedThemes.wrap(child);
        }

        return child;
      },
    );

    _toastControllers.add(toastController);
    _activeToasts.add(
      _ActiveToastOverlay(
        id: toastId,
        alignment: alignment,
        overlayState: resolvedOverlayState,
        overlayEntry: overlayEntry,
        expandOnHover: expandOnHover,
      ),
    );

    resolvedOverlayState.insert(overlayEntry);
    _rebuildActiveToasts(
      overlayState: resolvedOverlayState,
      alignment: alignment,
    );

    return toastController;
  }

  /// If [overlayState] is provided, then [context] will not be used.
  static ToastController slide({
    required Widget title,
    BuildContext? context,
    OverlayState? overlayState,
    Widget? leading,
    Widget? trailing,
    SlidingToastSetting toastSetting = const SlidingToastSetting(),
    ToastStyle toastStyle = const ToastStyle(),
    void Function()? onDisposed,
    void Function()? onTapped,
  }) {
    return _showToast(
      context: context,
      overlayState: overlayState,
      alignment: toastSetting.toastAlignment,
      expandOnHover: toastSetting.expandOnHover,
      onDisposed: onDisposed,
      builder: ({required controller, required stackTransform}) {
        return ToastSlider(
          toastController: controller,
          leading: leading,
          title: title,
          trailing: trailing,
          toastSetting: toastSetting,
          toastStyle: toastStyle,
          stackOffsetY: stackTransform.offsetY,
          stackScale: stackTransform.scale,
          onHeightChanged: (height) {
            _updateToastHeight(toastId: controller.id, height: height);
          },
          onHoverChanged: (isHovering) {
            _updateToastHover(toastId: controller.id, isHovering: isHovering);
          },
          onTapped: onTapped,
        );
      },
    );
  }

  /// Close all the toasts one by one
  static void closeAll() {
    while (_toastControllers.isNotEmpty) {
      _toastControllers.removeFirst().close();
    }
  }
}

class _ActiveToastOverlay {
  _ActiveToastOverlay({
    required this.id,
    required this.alignment,
    required this.overlayState,
    required this.overlayEntry,
    required this.expandOnHover,
  });

  final String id;
  final Alignment alignment;
  final OverlayState overlayState;
  final OverlayEntry overlayEntry;
  final bool expandOnHover;
  bool isHovering = false;
  double height = 0;
}

class _ToastStackTransform {
  const _ToastStackTransform({this.offsetY = 0, this.scale = 1});

  final double offsetY;
  final double scale;
}
