import 'dart:async';
import 'dart:math';
import 'dart:ui' show PointerDeviceKind;

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../common_tools.dart';
import '../../../../extensions/context.dart';
import '../../../../utilities.dart';

/// Builder function for custom refresh indicators.
///
/// Parameters:
/// - [context]: The build context
/// - [stage]: Current refresh trigger stage with progress information
///
/// Returns a widget that visualizes the refresh state.
typedef RefreshIndicatorBuilder =
    Widget Function(BuildContext context, RefreshTriggerStage stage);

/// Callback for async refresh operations.
///
/// Returns a Future that completes when the refresh operation finishes.
typedef FutureVoidCallback = Future<void> Function();

/// A widget that provides pull-to-refresh functionality.
///
/// The [MyRefreshTrigger] wraps a scrollable widget and provides pull-to-refresh
/// functionality. When the user pulls the content beyond the [minExtent],
/// the [onRefresh] callback is triggered.
///
/// Pull-to-refresh gesture handler with customizable visual indicators.
///
/// Wraps scrollable content to provide pull-to-refresh functionality similar to
/// native mobile applications. Supports both vertical and horizontal refresh
/// gestures with fully customizable visual indicators and animation behavior.
///
/// Key Features:
/// - **Pull Gesture Detection**: Recognizes pull gestures beyond scroll boundaries
/// - **Visual Feedback**: Customizable refresh indicators with progress animation
/// - **Flexible Direction**: Supports vertical and horizontal refresh directions
/// - **Reverse Mode**: Can trigger from opposite direction (e.g., bottom-up)
/// - **Theme Integration**: Full theme support with customizable appearance
/// - **Async Support**: Handles async refresh operations with loading states
/// - **Physics Integration**: Works with any ScrollPhysics implementation
///
/// Operation Flow:
/// 1. User pulls scrollable content beyond normal bounds
/// 2. Visual indicator appears and updates based on pull distance
/// 3. When minimum threshold reached, indicator shows "ready to refresh" state
/// 4. On release, onRefresh callback is triggered
/// 5. Loading indicator shows during async refresh operation
/// 6. Completion animation plays when refresh finishes
/// 7. Content returns to normal scroll position
///
/// The component integrates seamlessly with ListView, GridView, CustomScrollView,
/// and other scrollable widgets without requiring changes to existing scroll behavior.
///
/// Example:
/// ```dart
/// RefreshTrigger(
///   minExtent: 80.0,
///   maxExtent: 150.0,
///   onRefresh: () async {
///     await Future.delayed(Duration(seconds: 2));
///     // Refresh data here
///   },
///   child: ListView.builder(
///     itemCount: items.length,
///     itemBuilder: (context, index) => ListTile(
///       title: Text(items[index]),
///     ),
///   ),
/// )
/// ```
class MyRefreshTrigger extends StatefulWidget {
  /// Default indicator builder that creates a spinning progress indicator.
  ///
  /// Displays a platform-appropriate circular progress indicator that rotates
  /// based on pull extent and animates during refresh.
  static Widget defaultIndicatorBuilder(
    BuildContext context,
    RefreshTriggerStage stage,
  ) {
    return DefaultRefreshIndicator(stage: stage);
  }

  /// Minimum pull extent required to trigger refresh.
  ///
  /// Pull distance must exceed this value to activate the refresh callback.
  /// If null, uses theme or default value.
  final double? minExtent;

  /// Maximum pull extent allowed.
  ///
  /// Limits how far the user can pull to prevent excessive stretching.
  /// If null, uses theme or default value.
  final double? maxExtent;

  /// Callback invoked when refresh is triggered.
  ///
  /// Should return a Future that completes when the refresh operation finishes.
  /// While the Future is pending, the refresh indicator shows loading state.
  final FutureVoidCallback? onRefresh;

  /// The scrollable child widget being refreshed.
  final Widget child;

  /// Direction of the pull gesture.
  ///
  /// Defaults to [Axis.vertical] for standard top-down pull-to-refresh.
  final Axis direction;

  /// Whether to reverse the pull direction.
  ///
  /// If true, pull gesture is inverted (e.g., pull down instead of up).
  final bool reverse;

  /// Custom builder for the refresh indicator.
  ///
  /// If null, uses [defaultIndicatorBuilder].
  final RefreshIndicatorBuilder? indicatorBuilder;

  /// Animation curve for extent changes.
  ///
  /// Controls how the pull extent animates during interactions.
  final Curve? curve;

  /// Duration for the completion animation.
  ///
  /// Time to display the completion state before hiding the indicator.
  final Duration? completeDuration;

  /// Scroll physics applied through [ScrollConfiguration] when the child
  /// scrollable does not provide explicit physics.
  final ScrollPhysics? physics;

  /// Pointer devices that can drag the wrapped scrollable.
  final Set<PointerDeviceKind>? dragDevices;

  /// Creates a [MyRefreshTrigger] with pull-to-refresh functionality.
  ///
  /// Wraps the provided child widget with refresh gesture detection and
  /// visual indicator management.
  ///
  /// Parameters:
  /// - [child] (Widget, required): Scrollable content to wrap with refresh capability
  /// - [onRefresh] (FutureVoidCallback?, optional): Async callback triggered on refresh
  /// - [direction] (Axis, default: Axis.vertical): Pull gesture direction
  /// - [reverse] (bool, default: false): Whether to trigger from opposite direction
  /// - [minExtent] (double?, optional): Minimum pull distance to trigger refresh
  /// - [maxExtent] (double?, optional): Maximum allowed pull distance
  /// - [indicatorBuilder] (RefreshIndicatorBuilder?, optional): Custom indicator widget builder
  /// - [curve] (Curve?, optional): Animation curve for refresh transitions
  /// - [completeDuration] (Duration?, optional): Duration of completion animation
  /// - [physics] (ScrollPhysics?, optional): Default physics for child scrollables
  /// - [dragDevices] (`Set<PointerDeviceKind>?`, optional): Devices that can drag
  ///
  /// The [onRefresh] callback should return a Future that completes when the
  /// refresh operation is finished. During this time, a loading indicator will be shown.
  ///
  /// Example:
  /// ```dart
  /// RefreshTrigger(
  ///   onRefresh: () async {
  ///     final newData = await fetchDataFromAPI();
  ///     setState(() => items = newData);
  ///   },
  ///   minExtent: 60,
  ///   direction: Axis.vertical,
  ///   child: ListView(children: widgets),
  /// )
  /// ```
  const MyRefreshTrigger({
    super.key,
    this.minExtent,
    this.maxExtent,
    this.onRefresh,
    this.direction = Axis.vertical,
    this.reverse = false,
    this.indicatorBuilder,
    this.curve,
    this.completeDuration,
    this.physics,
    this.dragDevices,
    required this.child,
  });

  @override
  State<MyRefreshTrigger> createState() => MyRefreshTriggerState();
}

/// Default refresh indicator widget with platform-appropriate styling.
///
/// Displays a circular progress indicator that responds to pull gestures
/// and animates during the refresh lifecycle stages.
class DefaultRefreshIndicator extends StatefulWidget {
  /// Current refresh trigger stage.
  final RefreshTriggerStage stage;

  /// Creates a default refresh indicator.
  const DefaultRefreshIndicator({super.key, required this.stage});

  @override
  State<DefaultRefreshIndicator> createState() =>
      _DefaultRefreshIndicatorState();
}

class _DefaultRefreshIndicatorState extends State<DefaultRefreshIndicator> {
  Widget buildRefreshingContent(BuildContext context) {
    final densityGap = 8.0;
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: densityGap,
      children: [
        Flexible(child: MyText('Refreshing...')),
        const MyLoader(
          options: MyLoaderOptions(strokeWidth: 2, size: MyLoaderSize.small),
          icon: MyLoaderIcon.activity,
        ),
      ],
    );
  }

  Widget buildCompletedContent(BuildContext context) {
    final densityGap = 8.0;
    return Row(
      spacing: densityGap,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(child: MyText('Refresh complete')),
        Icon(LucideIcons.check, color: context.colorScheme.success),
      ],
    );
  }

  Widget buildPullingContent(BuildContext context) {
    final densityGap = 8.0;
    return AnimatedBuilder(
      animation: widget.stage.extent,
      builder: (context, child) {
        double angle;
        if (widget.stage.direction == Axis.vertical) {
          // 0 -> 1 (0 -> 180)
          angle = -pi * widget.stage.extentValue.clamp(0, 1);
        } else {
          // 0 -> 1 (90 -> 270)
          angle = -pi / 2 + -pi * widget.stage.extentValue.clamp(0, 1);
        }
        return Row(
          spacing: densityGap,
          mainAxisSize: MainAxisSize.min,
          children: [
            Transform.rotate(
              angle: angle,
              child: const Icon(LucideIcons.arrowDown),
            ),
            Flexible(
              child: MyText(
                widget.stage.extentValue < 1
                    ? 'Pull to refresh'
                    : 'Release to refresh',
              ),
            ),
            Transform.rotate(
              angle: angle,
              child: const Icon(LucideIcons.arrowDown),
            ),
          ],
        );
      },
    );
  }

  Widget buildIdleContent(BuildContext context) {
    final densityGap = 8.0;
    return Row(
      spacing: densityGap,
      mainAxisSize: MainAxisSize.min,
      children: [Flexible(child: MyText('Pull to refresh'))],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    switch (widget.stage.stage) {
      case TriggerStage.refreshing:
        child = buildRefreshingContent(context);
        break;
      case TriggerStage.completed:
        child = buildCompletedContent(context);
        break;
      case TriggerStage.pulling:
        child = buildPullingContent(context);
        break;
      case TriggerStage.idle:
        child = buildIdleContent(context);
        break;
    }
    final densityGap = 8.0;
    return Center(
      child: Container(
        padding: widget.stage.stage == TriggerStage.pulling
            ? EdgeInsets.all(densityGap * 0.5)
            : EdgeInsets.symmetric(
                horizontal: densityGap * 1.5,
                vertical: densityGap * 0.5,
              ),
        decoration: BoxDecoration(
          color: context.colorScheme.card,
          borderRadius: MyBorderRadius.round,
        ),
        child: CrossFadedTransition(
          child: KeyedSubtree(key: ValueKey(widget.stage.stage), child: child),
        ),
      ),
    );
  }
}

class _RefreshTriggerTween extends Animatable<double> {
  final double minExtent;

  const _RefreshTriggerTween(this.minExtent);

  @override
  double transform(double t) {
    return t / minExtent;
  }
}

/// State for the refresh trigger widget.
///
/// Manages the refresh lifecycle, gesture detection, and animation coordination
/// for pull-to-refresh functionality.
class MyRefreshTriggerState extends State<MyRefreshTrigger>
    with SingleTickerProviderStateMixin {
  double _currentExtent = 0;
  bool _scrolling = false;
  TriggerStage _stage = TriggerStage.idle;
  Future<void>? _currentFuture;
  int _currentFutureCount = 0;
  Timer? _completeTimer;

  // Computed theme values
  late double _minExtent;
  late double _maxExtent;
  late RefreshIndicatorBuilder _indicatorBuilder;
  late Curve _curve;
  late Duration _completeDuration;
  late ScrollPhysics _physics;
  late Set<PointerDeviceKind> _dragDevices;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateThemeValues();
  }

  @override
  void didUpdateWidget(MyRefreshTrigger oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateThemeValues();
  }

  void _updateThemeValues() {
    final densityContainerPadding = 8.0;

    _minExtent = widget.minExtent ?? densityContainerPadding * 4.6875;
    _maxExtent = widget.maxExtent ?? densityContainerPadding * 9.375;
    _indicatorBuilder =
        widget.indicatorBuilder ?? MyRefreshTrigger.defaultIndicatorBuilder;
    _curve = widget.curve ?? Curves.easeOutSine;
    _completeDuration =
        widget.completeDuration ?? const Duration(milliseconds: 500);
    _physics = widget.physics ?? const RefreshTriggerPhysics();
    _dragDevices =
        widget.dragDevices ??
        const <PointerDeviceKind>{
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
          PointerDeviceKind.stylus,
          PointerDeviceKind.invertedStylus,
          PointerDeviceKind.trackpad,
          PointerDeviceKind.unknown,
        };
  }

  double _calculateSafeExtent(double extent) {
    if (extent > _minExtent) {
      final double relativeExtent = extent - _minExtent;
      final double maxExtent = _maxExtent;
      final double diff = (maxExtent - _minExtent) - relativeExtent;
      final double diffNormalized = diff / (maxExtent - _minExtent);
      extent = maxExtent - _decelerateCurve(diffNormalized.clamp(0, 1)) * diff;
    }
    return widget.reverse ? -extent : extent;
  }

  double _decelerateCurve(double value) {
    return Curves.decelerate.transform(value);
  }

  Widget _wrapPositioned(Widget child) {
    if (widget.direction == Axis.vertical) {
      return Positioned(
        top: !widget.reverse ? 0 : null,
        bottom: !widget.reverse ? null : 0,
        left: 0,
        right: 0,
        child: child,
      );
    } else {
      return Positioned(
        top: 0,
        bottom: 0,
        left: widget.reverse ? null : 0,
        right: widget.reverse ? 0 : null,
        child: child,
      );
    }
  }

  Offset get _offset {
    if (widget.direction == Axis.vertical) {
      return Offset(0, widget.reverse ? 1 : -1);
    } else {
      return Offset(widget.reverse ? 1 : -1, 0);
    }
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification.depth != 0 ||
        notification.metrics.axis != widget.direction) {
      return false;
    }

    if (notification is ScrollEndNotification && _scrolling) {
      final bool shouldRefresh = _currentExtent >= _minExtent;
      setState(() {
        _scrolling = false;
        if (!shouldRefresh) {
          _stage = TriggerStage.idle;
          _currentExtent = 0;
        }
      });
      if (shouldRefresh) {
        unawaited(refresh());
      }
    } else if (notification is ScrollUpdateNotification) {
      final delta = notification.scrollDelta;
      if (delta != null) {
        final pullDelta = _pullDeltaForNotification(
          notification.metrics,
          delta,
          notification.dragDetails,
        );
        if (_stage == TriggerStage.pulling) {
          if (pullDelta < 0 && _currentExtent >= _minExtent) {
            setState(() {
              _scrolling = false;
            });
            unawaited(refresh());
          } else {
            _applyPullDelta(pullDelta);
          }
        } else if (_stage == TriggerStage.idle &&
            _isAtRefreshEdge(notification.metrics) &&
            pullDelta > 0) {
          _applyPullDelta(pullDelta);
        }
      }
    } else if (notification is OverscrollNotification) {
      final pullDelta = _pullDeltaForNotification(
        notification.metrics,
        notification.overscroll,
        notification.dragDetails,
      );
      if (_stage == TriggerStage.pulling) {
        if (pullDelta < 0 && _currentExtent >= _minExtent) {
          setState(() {
            _scrolling = false;
          });
          unawaited(refresh());
        } else {
          _applyPullDelta(pullDelta);
        }
      } else if (_stage == TriggerStage.idle && pullDelta > 0) {
        _applyPullDelta(pullDelta);
      }
    }
    return false;
  }

  bool _isAtRefreshEdge(ScrollMetrics metrics) {
    return widget.reverse
        ? metrics.extentAfter <= 0.0
        : metrics.extentBefore <= 0.0;
  }

  double _pullDeltaForNotification(
    ScrollMetrics metrics,
    double delta,
    DragUpdateDetails? dragDetails,
  ) {
    if (dragDetails != null) {
      final dragDelta = widget.direction == Axis.vertical
          ? dragDetails.delta.dy
          : dragDetails.delta.dx;
      return widget.reverse ? -dragDelta : dragDelta;
    }

    final axisDirection = metrics.axisDirection;
    final normalizedDelta =
        (axisDirection == AxisDirection.down ||
            axisDirection == AxisDirection.right)
        ? -delta
        : delta;
    return widget.reverse ? -normalizedDelta : normalizedDelta;
  }

  void _applyPullDelta(double pullDelta) {
    if (_stage == TriggerStage.refreshing ||
        _stage == TriggerStage.completed ||
        pullDelta == 0) {
      return;
    }

    setState(() {
      _currentExtent = max(0.0, _currentExtent + pullDelta);
      if (_currentExtent == 0) {
        _scrolling = false;
        _stage = TriggerStage.idle;
      } else {
        _scrolling = true;
        _stage = TriggerStage.pulling;
      }
    });
  }

  /// Triggers a refresh programmatically.
  ///
  /// Initiates the refresh animation and invokes the provided callback or
  /// widget's [onRefresh] callback. Can be called from parent widgets to
  /// trigger refresh without user gesture.
  ///
  /// Parameters:
  /// - [refreshCallback]: Optional callback to use instead of widget's onRefresh
  ///
  /// Returns a Future that completes when refresh finishes.
  Future<void> refresh([FutureVoidCallback? refreshCallback]) async {
    _scrolling = false;
    final int count = ++_currentFutureCount;
    _completeTimer?.cancel();
    if (_currentFuture != null) {
      await _currentFuture;
    }
    if (!mounted) {
      return;
    }
    _setRefreshing();
    final future = _refresh(refreshCallback);
    setState(() {
      _currentFuture = future;
    });
    return _currentFuture!.whenComplete(() {
      if (!mounted || count != _currentFutureCount) {
        return;
      }
      setState(() {
        _currentFuture = null;
        _stage = TriggerStage.completed;
        _completeTimer = Timer(_completeDuration, () {
          if (!mounted) {
            return;
          }
          setState(() {
            _stage = TriggerStage.idle;
            _currentExtent = 0;
          });
        });
      });
    });
  }

  void _setRefreshing() {
    if (_stage == TriggerStage.refreshing) {
      return;
    }
    setState(() {
      _stage = TriggerStage.refreshing;
    });
  }

  Future<void> _refresh([FutureVoidCallback? refresh]) {
    refresh ??= widget.onRefresh;
    return refresh?.call() ?? Future.value();
  }

  @override
  void dispose() {
    _completeTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tween = _RefreshTriggerTween(_minExtent);
    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: AnimatedValueBuilder.animation(
        value:
            _stage == TriggerStage.refreshing ||
                _stage == TriggerStage.completed
            ? _minExtent
            : _currentExtent,
        duration: _scrolling ? Duration.zero : kDefaultDuration,
        curve: _curve,
        builder: (context, animation) {
          return Stack(
            fit: StackFit.passthrough,
            children: [
              ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(physics: _physics, dragDevices: _dragDevices),
                child: widget.child,
              ),
              AnimatedBuilder(
                animation: animation,
                child: _indicatorBuilder(
                  context,
                  RefreshTriggerStage(
                    _stage,
                    tween.animate(animation),
                    widget.direction,
                    widget.reverse,
                  ),
                ),
                builder: (context, child) {
                  return Positioned.fill(
                    child: ClipRect(
                      child: Stack(
                        children: [
                          _wrapPositioned(
                            FractionalTranslation(
                              translation: _offset,
                              child: Transform.translate(
                                offset: widget.direction == Axis.vertical
                                    ? Offset(
                                        0,
                                        _calculateSafeExtent(animation.value),
                                      )
                                    : Offset(
                                        _calculateSafeExtent(animation.value),
                                        0,
                                      ),
                                child: child,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Lifecycle stages of a refresh trigger.
///
/// Represents the different states a refresh indicator can be in:
/// - [idle]: No refresh in progress, waiting for user interaction
/// - [pulling]: User is pulling but hasn't reached min extent
/// - [refreshing]: Refresh callback is executing
/// - [completed]: Refresh completed, showing completion state
enum TriggerStage {
  /// Idle state, no refresh in progress.
  idle,

  /// Pulling state, user is dragging the indicator.
  pulling,

  /// Refreshing state, async refresh operation is executing.
  refreshing,

  /// Completed state, refresh finished successfully.
  completed,
}

/// Immutable snapshot of refresh trigger state.
///
/// Provides information about the current refresh stage and pull extent
/// to indicator builders for rendering appropriate UI.
class RefreshTriggerStage {
  /// Current stage of the refresh lifecycle.
  final TriggerStage stage;

  /// Animated pull extent value.
  ///
  /// Range depends on min/max extent configuration. Use [extentValue] for
  /// current numeric value.
  final Animation<double> extent;

  /// Direction of the pull gesture.
  final Axis direction;

  /// Whether the pull direction is reversed.
  final bool reverse;

  /// Creates a refresh trigger stage snapshot.
  const RefreshTriggerStage(
    this.stage,
    this.extent,
    this.direction,
    this.reverse,
  );

  /// Current numeric value of the pull extent.
  ///
  /// Convenience getter for [extent.value].
  double get extentValue => extent.value;
}

/// Custom scroll physics for refresh trigger behavior.
///
/// Enables over-scroll to allow pulling beyond content bounds for refresh.
/// Applied automatically by [MyRefreshTrigger] to its child scrollable.
class RefreshTriggerPhysics extends BouncingScrollPhysics {
  /// Creates scroll physics that bounce and always accept user offset.
  const RefreshTriggerPhysics({super.parent});

  @override
  RefreshTriggerPhysics applyTo(ScrollPhysics? ancestor) {
    return RefreshTriggerPhysics(parent: buildParent(ancestor));
  }

  @override
  bool shouldAcceptUserOffset(ScrollMetrics position) => true;
}

/// A widget that provides a cross-fade transition between two child widgets.
///
/// This widget is a [StatefulWidget] that manages the animation state and
/// allows for smooth transitions between two widgets. It is useful for
/// scenarios where you want to visually transition between two different
/// UI elements with a fade effect.
class CrossFadedTransition extends StatefulWidget {
  /// Linearly interpolates the opacity of a widget between two values.
  ///
  /// This method is typically used in animations to create a smooth transition
  /// effect by blending the opacity of a widget over time.
  ///
  /// Returns a [Widget] with the interpolated opacity.
  static Widget lerpOpacity(
    Widget a,
    Widget b,
    double t, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    if (t == 0) {
      return a;
    } else if (t == 1) {
      return b;
    }
    final double startOpacity = 1 - (t.clamp(0, 0.5) * 2);
    final double endOpacity = t.clamp(0.5, 1) * 2 - 1;
    return Stack(
      fit: StackFit.passthrough,
      children: [
        Positioned.fill(
          child: Opacity(
            opacity: startOpacity,
            child: Align(alignment: alignment, child: a),
          ),
        ),
        Opacity(opacity: endOpacity, child: b),
      ],
    );
  }

  /// Creates a widget that interpolates between two widgets in a stepwise manner.
  ///
  /// This method is typically used to create a crossfade effect where the transition
  /// between two widgets occurs in discrete steps rather than a smooth animation.
  ///
  /// The interpolation logic and the specific behavior of the step transition
  /// should be defined within the implementation of this method.
  static Widget lerpStep(
    Widget a,
    Widget b,
    double t, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    if (t == 0) {
      return a;
    } else if (t == 1) {
      return b;
    }
    return Stack(fit: StackFit.passthrough, children: [a, b]);
  }

  /// The widget to be displayed as the child of this widget.
  ///
  /// This is the primary content that will be rendered and can be
  /// dynamically updated to achieve crossfade or other animation effects.
  final Widget child;

  /// The duration of the crossfade animation.
  ///
  /// This defines how long the animation should take to transition
  /// between states.
  final Duration duration;

  /// The alignment of the child within the parent widget.
  ///
  /// This property determines how the child widget is aligned within its
  /// parent. For example, you can use [Alignment.center] to center the child,
  /// or [Alignment.topLeft] to align it to the top-left corner.
  ///
  /// Defaults to [Alignment.center] if not specified.
  final AlignmentGeometry alignment;

  /// A builder function that returns a [Widget].
  ///
  /// This function is typically used to create a widget dynamically
  /// based on certain conditions or input parameters.
  final Widget Function(
    Widget a,
    Widget b,
    double t, {
    AlignmentGeometry alignment,
  })
  lerp;

  /// Creates a cross-faded transition widget.
  ///
  /// This widget allows for a smooth transition between two child widgets
  /// by cross-fading them over a specified duration. It is commonly used
  /// to animate changes in the UI where one widget replaces another.
  ///
  /// The transition can be customized by providing parameters such as
  /// animation duration, curve, and alignment.
  const CrossFadedTransition({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.alignment = Alignment.center,
    this.lerp = lerpOpacity,
  });

  @override
  State<CrossFadedTransition> createState() => _CrossFadedTransitionState();
}

class _CrossFadedTransitionState extends State<CrossFadedTransition> {
  late Widget newChild;

  @override
  void initState() {
    super.initState();
    newChild = widget.child;
  }

  @override
  void didUpdateWidget(covariant CrossFadedTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.child != widget.child &&
        oldWidget.child.key != widget.child.key) {
      newChild = widget.child;
    }
  }

  Widget _lerpWidget(Widget a, Widget b, double t) {
    return widget.lerp(a, b, t, alignment: widget.alignment);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      alignment: widget.alignment,
      duration: widget.duration,
      child: AnimatedValueBuilder(
        value: newChild,
        lerp: _lerpWidget,
        duration: widget.duration,
        builder: _builder,
      ),
    );
  }

  Widget _builder(BuildContext context, Widget value, Widget? child) {
    return value;
  }
}
