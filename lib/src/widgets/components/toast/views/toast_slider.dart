import 'dart:async' show unawaited;

import 'package:flutter/material.dart';

import '../models/sliding_toast_setting.dart';
import '../models/toast_controller.dart';
import '../models/toast_style.dart';
import '../widgets/toast_container_widget.dart';
import '../widgets/toast_position_widget.dart';
import '../widgets/toast_progress_bar_widget.dart';
import '../widgets/toast_size_listener_widget.dart';

class ToastSlider extends StatefulWidget {
  const ToastSlider({
    required this.toastController,
    required this.leading,
    required this.title,
    required this.trailing,
    required this.toastSetting,
    required this.toastStyle,
    super.key,
    this.stackOffsetY = 0,
    this.stackScale = 1,
    this.onHeightChanged,
    this.onHoverChanged,
    this.onTapped,
  });

  /// The toast controller for removing the overlay
  final ToastController toastController;

  /// The widget to display at the start of the message
  final Widget? leading;

  /// The Message to be displayed at the toast
  /// It's width is expanded whenever leading or trailing widget is present
  final Widget title;

  /// A widget displayed at the right side of the toast
  final Widget? trailing;

  /// The setting for the sliding animation
  final SlidingToastSetting toastSetting;

  /// The style of the toast
  final ToastStyle toastStyle;

  /// Vertical stack offset for concurrent toasts.
  final double stackOffsetY;

  /// Stack scale factor for concurrent toasts.
  final double stackScale;

  /// Function to be called when the toast height changes.
  final ValueChanged<double>? onHeightChanged;

  /// Function to be called when the hover state changes.
  final ValueChanged<bool>? onHoverChanged;

  /// Function to be called when the toast is clicked
  final void Function()? onTapped;

  @override
  State<ToastSlider> createState() => _ToastSliderState();
}

class _ToastSliderState extends State<ToastSlider>
    with TickerProviderStateMixin {
  late final SlidingToastSetting toastSetting;
  late final ToastStyle toastStyle;
  late final AnimationController slideController;
  late final AnimationController sizeController;
  late final Animation<Offset> slideAnimation;
  late final Animation<double> fadeAnimation;
  late final Animation<double> sizeAnimation;

  /// Is the toast clicked by the user
  bool isToastTapped = false;

  void _pauseTimer() => sizeController.stop();

  void _resumeTimer() {
    if (sizeController.status != AnimationStatus.completed &&
        !sizeController.isAnimating) {
      unawaited(sizeController.forward());
    }
  }

  @override
  void initState() {
    super.initState();
    toastSetting = widget.toastSetting;
    toastStyle = widget.toastStyle;

    /// For sliding effect
    slideController = AnimationController(
      vsync: this,
      duration: toastSetting.animationDuration,
    );

    /// For displaying the toast and also for progress bar
    sizeController = AnimationController(
      vsync: this,
      duration: toastSetting.animationDuration + toastSetting.displayDuration,
    );

    // Get tween according to the start direction
    final tween = toastSetting.toastStartPosition.tween();

    // Create a curved tween animation for the slide
    slideAnimation = tween.animate(
      CurvedAnimation(parent: slideController, curve: toastSetting.curve),
    );

    fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: slideController, curve: toastSetting.curve),
    );

    // Create a size animation for the progress bar
    sizeAnimation = Tween<double>(begin: 1, end: 0).animate(sizeController);

    // Start the animation
    unawaited(slideController.forward());

    // Start the size animation and listen animation is completed or not to remove the overlay
    unawaited(sizeController.forward());
    sizeController.addStatusListener(animationListener);
  }

  Future<void> animationListener(AnimationStatus status) async {
    if (status == AnimationStatus.completed) {
      // Wait for the reverse animation to complete
      if (toastSetting.showReverseAnimation) {
        await slideController.reverse();
      }

      // Remove the overlay entry
      widget.toastController.close();
    }
  }

  @override
  void dispose() {
    slideController.dispose();
    sizeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Create the toast container
    Widget child = ToastContainerWidget(
      leading: widget.leading,
      title: widget.title,
      trailing: widget.trailing,
      toastStyle: toastStyle,
      expandTitleWidth:
          toastStyle.expandedTitle || toastSetting.showProgressBar,
    );

    // Show the progress bar if available
    if (toastSetting.showProgressBar) {
      child = Stack(
        alignment: Alignment.bottomLeft,
        children: [
          child,
          ToastProgressBarWidget(
            animation: sizeAnimation,
            toastStyle: toastStyle,
            toastSetting: toastSetting,
          ),
        ],
      );
    }

    // Show the clipping with border radius
    child = ClipRRect(borderRadius: toastStyle.borderRadius, child: child);

    // Show the box shadow if available
    if (toastStyle.boxShadow != null) {
      child = DecoratedBox(
        decoration: BoxDecoration(boxShadow: toastStyle.boxShadow),
        child: child,
      );
    }

    if (widget.onHeightChanged != null) {
      child = ToastSizeListenerWidget(
        onSizeChanged: (size) => widget.onHeightChanged?.call(size.height),
        child: child,
      );
    }

    child = FadeTransition(opacity: fadeAnimation, child: child);

    final bool isTopAligned = toastSetting.toastAlignment.y < 0;
    final Alignment scaleAlignment = isTopAligned
        ? Alignment.topCenter
        : Alignment.bottomCenter;

    final Widget gestureChild = SlideTransition(
      position: slideAnimation,
      child: child,
    );
    final Widget stackedChild = AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      transformAlignment: scaleAlignment,
      transform: Matrix4.identity()
        ..translateByDouble(0, widget.stackOffsetY, 0, 1)
        ..scaleByDouble(widget.stackScale, widget.stackScale, 1, 1),
      child: gestureChild,
    );

    return ToastPositionWidget(
      alignment: toastSetting.toastAlignment,
      padding: toastSetting.padding,
      newMaxHeight: toastSetting.maxHeight,
      newMaxWidth: toastSetting.maxWidth,
      child: _buildInteractiveChild(stackedChild),
    );
  }

  Widget _buildInteractiveChild(Widget child) {
    Widget interactiveChild = GestureDetector(
      // Execute onTapped function on tap
      onTap: () {
        if (!isToastTapped) {
          widget.onTapped?.call();
        }
        if (widget.toastSetting.disableMultiTapping) {
          isToastTapped = true;
        }
      },
      // Pause the animation on long press
      onLongPress: _pauseTimer,
      // Forward the animation when long press ends
      onLongPressEnd: (_) => _resumeTimer(),
      child: child,
    );

    final bool useMouseRegion =
        widget.toastSetting.pauseOnHover || widget.toastSetting.expandOnHover;
    if (useMouseRegion) {
      interactiveChild = MouseRegion(
        onEnter: (_) {
          if (widget.toastSetting.pauseOnHover) {
            _pauseTimer();
          }
          if (widget.toastSetting.expandOnHover) {
            widget.onHoverChanged?.call(true);
          }
        },
        onExit: (_) {
          if (widget.toastSetting.pauseOnHover) {
            _resumeTimer();
          }
          if (widget.toastSetting.expandOnHover) {
            widget.onHoverChanged?.call(false);
          }
        },
        child: interactiveChild,
      );
    }

    if (!widget.toastSetting.dismissible) {
      return interactiveChild;
    }

    return Dismissible(
      key: ValueKey(widget.toastController.id),
      direction: toastSetting.toastStartPosition.dismissDirection(),
      // Stop animations and remove the overlay on dismissed
      onDismissed: (_) {
        _pauseTimer();
        widget.toastController.close();
      },
      child: interactiveChild,
    );
  }
}
