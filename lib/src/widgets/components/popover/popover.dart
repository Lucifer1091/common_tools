import 'dart:async';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../../constants/my_radius.dart';
import '../../../constants/shadows.dart';
import '../../../extensions/context/theme.dart';
import '../../common/mouse_area.dart';
import '../../common/my_border.dart';
import '../../common/my_decoration.dart';
import '../../common/my_decorator.dart';
import '../../common/portal.dart';

/// Controls the visibility of a [MyPopover].
class MyPopoverController extends ChangeNotifier {
  MyPopoverController({this._isOpen = false});

  bool _isOpen = false;

  /// Indicates if the popover is visible.
  bool get isOpen => _isOpen;

  /// Displays the popover.
  void show() {
    if (_isOpen) return;
    _isOpen = true;
    notifyListeners();
  }

  /// Hides the popover.
  void hide() {
    if (!_isOpen) return;
    _isOpen = false;
    notifyListeners();
  }

  void setOpen(bool open) {
    if (_isOpen == open) return;
    _isOpen = open;
    notifyListeners();
  }

  /// Toggles the visibility of the popover.
  void toggle() => _isOpen ? hide() : show();
}

class MyPopover extends StatefulWidget {
  const MyPopover({
    required this.child,
    required this.popover,
    super.key,
    this.controller,
    this.visible,
    this.closeOnTapOutside = true,
    this.focusNode,
    this.anchor,
    this.reverseDuration,
    this.shadows,
    this.padding,
    this.decoration,
    this.filter,
    this.groupId,
    this.areaGroupId,
    this.useSameGroupIdForChild = true,
  }) : assert(
         (controller != null) ^ (visible != null),
         'Either controller or visible must be provided',
       );

  /// {@template MyPopover.popover}
  /// The widget displayed as a popover.
  /// {@endtemplate}
  final WidgetBuilder popover;

  /// {@template MyPopover.child}
  /// The child widget.
  /// {@endtemplate}
  final Widget child;

  /// {@template MyPopover.controller}
  /// The controller that controls the visibility of the [popover].
  /// {@endtemplate}
  final MyPopoverController? controller;

  /// {@template MyPopover.visible}
  /// Indicates if the popover should be visible.
  /// {@endtemplate}
  final bool? visible;

  /// {@template MyPopover.closeOnTapOutside}
  /// Closes the popover when the user taps outside, defaults to true.
  /// {@endtemplate}
  final bool closeOnTapOutside;

  /// {@template MyPopover.focusNode}
  /// The focus node of the child, the [popover] will be shown when
  /// focused.
  /// {@endtemplate}
  final FocusNode? focusNode;

  ///{@template MyPopover.anchor}
  /// The position of the [popover] in the global coordinate system.
  ///
  /// Defaults to `MyAnchorAuto(offset: Offset(0, 4))`.
  /// {@endtemplate}
  final MyAnchorBase? anchor;

  /// {@template MyPopover.shadows}
  /// The shadows applied to the [popover], defaults to
  /// [MyBoxShadows.md].
  /// {@endtemplate}
  final List<BoxShadow>? shadows;

  /// {@template MyPopover.padding}
  /// The padding of the [popover], defaults to
  /// `EdgeInsets.symmetric(horizontal: 12, vertical: 6)`.
  /// {@endtemplate}
  final EdgeInsetsGeometry? padding;

  /// {@template MyPopover.decoration}
  /// The decoration of the [popover].
  /// {@endtemplate}
  final MyDecoration? decoration;

  /// {@template MyPopover.filter}
  /// The filter of the [popover]. If `null`, falls back to `MyPopoverTheme`.
  /// {@endtemplate}
  final ImageFilter? filter;

  /// {@template MyPopover.groupId}
  /// The group id of the [popover], defaults to `UniqueKey()`.
  ///
  /// Used to determine it the tap is inside the [popover] or not.
  /// {@endtemplate}
  final Object? groupId;

  /// {@macro MyMouseArea.groupId}
  final Object? areaGroupId;

  /// {@template MyPopover.useSameGroupIdForChild}
  /// Whether the [groupId] should be used for the child widget, defaults to
  /// `true`. This teams that taps on the child widget will be handled as inside
  /// the popover.
  /// {@endtemplate}
  final bool useSameGroupIdForChild;

  /// {@template MyPopover.reverseDuration}
  /// The duration of the popover's exit animation.
  ///
  /// Defaults to [Duration(milliseconds: 150)].
  ///
  /// {@endtemplate}
  final Duration? reverseDuration;

  @override
  State<MyPopover> createState() => _MyPopoverState();
}

class _MyPopoverState extends State<MyPopover>
    with SingleTickerProviderStateMixin {
  MyPopoverController? _controller;
  MyPopoverController get controller => widget.controller ?? _controller!;

  late final AnimationController animationController;

  late final _popoverKey = UniqueKey();

  // The focus node of the popover.
  // It's used to be able to focus the popover and receive key events.
  final _popoverFocusNode = FocusNode();

  Object get groupId => widget.groupId ?? _popoverKey;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller = MyPopoverController(isOpen: widget.visible ?? false);
    }
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    controller.addListener(_onPopoverToggle);

    _onPopoverToggle();
  }

  @override
  void didUpdateWidget(covariant MyPopover oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != null &&
        widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_onPopoverToggle);
      widget.controller!.addListener(_onPopoverToggle);
    }

    if (widget.visible != null) {
      if (widget.visible! && !controller.isOpen) {
        controller.show();
      } else if (!widget.visible! && controller.isOpen) {
        controller.hide();
      }
    }
  }

  @override
  void dispose() {
    // Remove the listener from the provided `MyPopoverController`
    // or our internal controller.
    controller.removeListener(_onPopoverToggle);

    animationController.dispose();
    _popoverFocusNode.dispose();
    _controller?.dispose();
    super.dispose();
  }

  void _onPopoverToggle() {
    if (controller.isOpen) {
      unawaited(animationController.forward(from: 0));
      // When the popover is opened, request focus
      // to be able to receive key events.

      _popoverFocusNode.requestFocus();
    } else {
      unawaited(animationController.reverse());
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveReverseDuration =
        widget.reverseDuration ?? const Duration(milliseconds: 150);

    animationController.duration = const Duration(milliseconds: 150);
    animationController.reverseDuration = effectiveReverseDuration;
    final popoverAnimation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
      reverseCurve: Curves.easeInOut,
    );

    final effectivePadding =
        widget.padding ??
        const EdgeInsets.symmetric(horizontal: 12, vertical: 6);

    final effectiveMyows = widget.shadows;
    var effectiveDecoration = MyDecoration(
      color: context.colorScheme.popover,
      shadows: MyBoxShadows.md,
      border: MyBorder.all(
        radius: MyBorderRadius.medium,
        color: context.colorScheme.border,
        width: 1,
      ),
    ).merge(widget.decoration).copyWith(shadows: effectiveMyows);
    // remove the top padding of the popover
    effectiveDecoration = effectiveDecoration.copyWith(
      secondaryBorder: MyBorder(
        padding: MyDecoration().secondaryBorder?.padding
            ?.resolve(Directionality.of(context))
            .copyWith(top: 0),
      ),
    );

    final effectiveAnchor =
        widget.anchor ?? const MyAnchorAuto(offset: Offset(0, 4));

    final effectiveFilter = widget.filter;

    final effectiveFilterRadius =
        effectiveDecoration.border?.radius ?? BorderRadius.zero;

    Widget popover = MyMouseArea(
      groupId: widget.areaGroupId,
      child: MyDecorator(
        decoration: effectiveDecoration,
        child: Padding(
          padding: effectivePadding,
          child: DefaultTextStyle(
            style: TextStyle(color: context.colorScheme.popoverForeground),
            textAlign: TextAlign.center,
            child: Builder(builder: widget.popover),
          ),
        ),
      ),
    );

    if (effectiveFilter != null) {
      popover = ClipRRect(
        borderRadius: effectiveFilterRadius,
        child: BackdropFilter(filter: effectiveFilter, child: popover),
      );
    }

    popover = FadeTransition(opacity: popoverAnimation, child: popover);
    popover = ScaleTransition(
      scale: Tween<double>(begin: 0.92, end: 1).animate(popoverAnimation),
      child: popover,
    );

    if (widget.closeOnTapOutside) {
      popover = TapRegion(
        groupId: groupId,
        behavior: HitTestBehavior.opaque,
        onTapOutside: (_) => controller.hide(),
        child: popover,
      );
    }

    Widget child = CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.escape): () {
          controller.hide();
        },
      },
      child: AnimatedBuilder(
        animation: animationController,
        builder: (context, _) {
          return MyPortal(
            portalBuilder: (_) {
              // used to trap the focus inside the popover.
              return FocusScope(
                child: Focus(
                  skipTraversal: true,
                  focusNode: _popoverFocusNode,
                  child: popover,
                ),
              );
            },
            visible: !animationController.isDismissed,
            anchor: effectiveAnchor,
            child: widget.child,
          );
        },
      ),
    );
    if (widget.useSameGroupIdForChild) {
      child = TapRegion(groupId: groupId, child: child);
    }
    return child;
  }
}
