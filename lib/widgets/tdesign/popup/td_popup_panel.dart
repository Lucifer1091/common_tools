import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../../index.dart';
import '../text/td_text.dart';

typedef PopupClick = VoidCallback;

abstract class TDPopupBasePanel extends StatefulWidget {
  const TDPopupBasePanel({
    required this.child,
    super.key,
    this.title,
    this.titleColor,
    this.backgroundColor,
    this.radius,
    this.draggable = false,
    this.maxHeightRatio = 0.9,
    this.minHeightRatio = 0.3,
  });

  final Widget child;

  final String? title;

  final Color? titleColor;

  final Color? backgroundColor;

  final double? radius;

  final bool draggable;

  final double maxHeightRatio;

  final double minHeightRatio;

  @override
  State<TDPopupBasePanel> createState();
}

abstract class _TDPopupBaseState<T extends TDPopupBasePanel> extends State<T>
    with SingleTickerProviderStateMixin {
  final GlobalKey _childKey = GlobalKey();
  static const _dragHandleHeight = 24.0;
  static const _headerHeight = 58.0;

  late AnimationController _controller;
  double _maxHeight = 0;
  double _minHeight = 0;
  double _currentHeight = 0;
  bool _isFullscreen = false;
  bool _isAnimating = false;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    )..addListener(_updateHeight);
    WidgetsBinding.instance.addPostFrameCallback((_) => _measureChildHeight());
  }

  /// Measure the subcomponent height and update the popup layout parameters
  /// 1. Get the subcomponent's rendered size
  /// 2. Calculate the actual required base height
  /// 3. Dynamically calculate the maximum and minimum height ratios
  /// 4. Update the animation controller state
  void _measureChildHeight() {
    // Get the subcomponent rendering object
    final context = _childKey.currentContext;
    if (context == null) return;
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return;

    final screenHeight = MediaQuery.of(context).size.height;
    final childHeight = renderBox.size.height;
    final headerHeight = widget.draggable ? _headerHeight : _headerHeight;
    final baseHeight = _dragHandleHeight + headerHeight + childHeight;

    // Dynamically calculate the maximum and minimum heights
    final maxHeightByRatio = screenHeight * widget.maxHeightRatio;
    final minHeightByRatio = screenHeight * widget.minHeightRatio;

    // Content height and proportion constraints
    _maxHeight = min(baseHeight, maxHeightByRatio);
    _minHeight = max(baseHeight * 0.5, minHeightByRatio);
    if (_minHeight > _maxHeight) {
      _minHeight = _maxHeight;
    }

    // Initialize current height
    _currentHeight = baseHeight.clamp(_minHeight, _maxHeight);
    // Synchronized animation controllers
    _controller.value =
        (_currentHeight - _minHeight) /
        (_maxHeight - _minHeight).clamp(0.1, 1.0);
  }

  void _updateHeight() => setState(() {
    _currentHeight = _minHeight + (_maxHeight - _minHeight) * _controller.value;
  });

  void _toggleFullscreen(bool fullscreen) {
    if (_isAnimating || _isFullscreen == fullscreen) return;

    setState(() {
      _isFullscreen = fullscreen;
      _maxHeight =
          fullscreen
              ? MediaQuery.of(context).size.height
              : MediaQuery.of(context).size.height * widget.maxHeightRatio;
    });

    _controller.animateTo(
      fullscreen ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 350),
      curve: Curves.fastOutSlowIn,
    );
  }

  void _animateTo(double height) {
    if (_isAnimating) return;
    _isAnimating = true;

    final value = (height - _minHeight) / (_maxHeight - _minHeight);
    unawaited(
      _controller
          .animateTo(
            value.clamp(0.0, 1.0),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutBack,
          )
          .whenComplete(() => _isAnimating = false),
    );
  }

  Widget _buildDragHandle() {
    if (!widget.draggable) return const SizedBox.shrink();

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onVerticalDragUpdate: _handleDragUpdate,
      onVerticalDragEnd: _handleDragEnd,
      onDoubleTap: () => _toggleFullscreen(!_isFullscreen),
      child: Container(
        height: _dragHandleHeight,
        alignment: Alignment.center,
        child: Container(
          width: 48,
          height: 4,
          decoration: BoxDecoration(
            color: ThemeColors.neutral.shade200,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Measure the height of the child content at each build to ensure that
      // the height is adaptive when the content changes (not measured when dragging)
      if (!_isDragging) {
        _measureChildHeight();
      }
    });

    return AnimatedBuilder(
      animation: _controller,
      builder:
          (context, _) => RepaintBoundary(
            child: Container(
              height: _currentHeight,
              decoration: BoxDecoration(
                color: widget.backgroundColor ?? Colors.white,
                borderRadius:
                    _isFullscreen
                        ? null
                        : BorderRadius.vertical(
                          top: Radius.circular(widget.radius ?? 12),
                        ),
              ),
              child: Column(
                children: [
                  _buildDragHandle(),
                  buildHeader(context),
                  SizedBox(child: _buildContent()),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildContent() => NotificationListener<ScrollNotification>(
    onNotification: (notification) {
      if (notification is ScrollUpdateNotification) {
        final metrics = notification.metrics;
        if ((metrics.pixels <= 0 ||
                metrics.pixels >= metrics.maxScrollExtent) &&
            notification.dragDetails != null) {
          _handleDragUpdate(notification.dragDetails!);
        }
      }
      return false;
    },
    child: Container(key: _childKey, child: widget.child),
  );

  @protected
  void _handleDragUpdate(DragUpdateDetails details);

  @protected
  void _handleDragEnd(DragEndDetails details);

  @protected
  Widget buildHeader(BuildContext context);

  void _baseHandleDragUpdate(DragUpdateDetails details) {
    _isDragging = true;
    if (_isAnimating || !widget.draggable) return;

    final newHeight = _currentHeight - details.primaryDelta! * 1.2;
    _currentHeight = newHeight.clamp(_minHeight, _maxHeight);
    _controller.value =
        (_currentHeight - _minHeight) / (_maxHeight - _minHeight);
  }

  void _baseHandleDragEnd(DragEndDetails details) {
    final velocity = details.velocity.pixelsPerSecond.dy;
    final predictedHeight = _currentHeight + velocity * 0.15;

    if (predictedHeight > _maxHeight * 0.7 || velocity < -800) {
      _animateTo(_maxHeight);
    } else if (predictedHeight < _minHeight * 1.3 || velocity > 800) {
      _animateTo(_minHeight);
    }
    _isDragging = false;
  }
}

/// Bottom floating panel with closed in the upper right corner
class TDPopupBottomDisplayPanel extends TDPopupBasePanel {
  const TDPopupBottomDisplayPanel({
    required super.child,
    super.key,
    super.title,
    super.titleColor,
    this.titleFontSize,
    this.titleLeft = false,
    this.hideClose = false,
    this.closeColor,
    this.closeSize,
    this.closeClick,
    super.backgroundColor,
    super.radius,
    super.draggable,
    super.maxHeightRatio,
    super.minHeightRatio,
  });

  final double? titleFontSize;

  final bool titleLeft;

  final bool hideClose;

  final Color? closeColor;

  final double? closeSize;

  final PopupClick? closeClick;

  @override
  State<TDPopupBasePanel> createState() => _TDPopupBottomDisplayPanelState();
}

class _TDPopupBottomDisplayPanelState
    extends _TDPopupBaseState<TDPopupBottomDisplayPanel> {
  @override
  Widget buildHeader(BuildContext context) {
    Widget header = Container(
      alignment: widget.titleLeft ? Alignment.centerLeft : Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TDText(
        widget.title ?? '',
        textColor: widget.titleColor ?? ThemeColors.neutral.shade900,
        style: context.titleLarge?.copyWith(fontSize: widget.titleFontSize),
        fontWeight: FontWeight.w700,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );

    if (!widget.hideClose) {
      header = Stack(
        alignment: Alignment.centerLeft,
        children: [
          Padding(
            padding: EdgeInsets.only(
              right: 40,
              left: widget.titleLeft ? 0 : 40,
            ),
            child: header,
          ),
          Positioned(
            right: 0,
            child: IconButton(
              icon: Icon(
                Icons.close_rounded,
                color: widget.closeColor,
                size: widget.closeSize,
              ),
              onPressed: widget.closeClick,
            ),
          ),
        ],
      );
    }

    return SizedBox(
      height:
          widget.draggable
              ? _TDPopupBaseState._headerHeight -
                  _TDPopupBaseState._dragHandleHeight
              : _TDPopupBaseState._headerHeight,
      child: header,
    );
  }

  @override
  void _handleDragUpdate(DragUpdateDetails details) {
    super._baseHandleDragUpdate(details);

    final progress = (_currentHeight - _minHeight) / (_maxHeight - _minHeight);
    if (progress > 0.85 && !_isFullscreen) {
      _toggleFullscreen(true);
    } else if (progress < 0.75 && _isFullscreen) {
      _toggleFullscreen(false);
    }
  }

  @override
  void _handleDragEnd(DragEndDetails details) =>
      super._baseHandleDragEnd(details);
}

class TDPopupBottomConfirmPanel extends TDPopupBasePanel {
  const TDPopupBottomConfirmPanel({
    required super.child,
    super.key,
    super.title,
    super.titleColor,
    this.leftText,
    this.leftTextColor,
    this.leftClick,
    this.rightText,
    this.rightTextColor,
    this.rightClick,
    this.titleFontSize,
    this.leftTextFontSize,
    this.rightTextFontSize,
    super.backgroundColor,
    super.radius,
    super.draggable,
    super.maxHeightRatio,
    super.minHeightRatio,
  });

  final double? titleFontSize;

  final String? leftText;

  final double? leftTextFontSize;

  final Color? leftTextColor;

  final PopupClick? leftClick;

  final String? rightText;

  final double? rightTextFontSize;

  final Color? rightTextColor;

  final PopupClick? rightClick;

  @override
  State<TDPopupBasePanel> createState() => _TDPopupBottomConfirmPanelState();
}

class _TDPopupBottomConfirmPanelState
    extends _TDPopupBaseState<TDPopupBottomConfirmPanel> {
  @override
  Widget buildHeader(BuildContext context) {
    return SizedBox(
      height:
          widget.draggable
              ? _TDPopupBaseState._headerHeight -
                  _TDPopupBaseState._dragHandleHeight
              : _TDPopupBaseState._headerHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildActionButton(
            text: widget.leftText ?? 'Cancel',
            color: widget.leftTextColor ?? ThemeColors.neutral.shade800,
            onTap: widget.leftClick,
            left: true,
          ),
          Expanded(
            child: Center(
              child: TDText(
                widget.title ?? '',
                textColor: widget.titleColor ?? ThemeColors.neutral.shade900,
                style: context.titleLarge?.copyWith(
                  fontSize: widget.titleFontSize,
                ),
                fontWeight: FontWeight.w700,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          _buildActionButton(
            text: widget.rightText ?? 'Confirm',
            color: widget.rightTextColor ?? ThemeColors.blue.shade600,
            onTap: widget.rightClick,
            left: false,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String text,
    required Color color,
    required VoidCallback? onTap,
    required bool left,
  }) => GestureDetector(
    onTap: onTap,
    child: Padding(
      padding: EdgeInsets.only(left: left ? 16 : 0, right: left ? 0 : 16),
      child: TDText(
        text,
        textColor: color,
        style: (left ? context.bodyLarge : context.titleMedium)?.copyWith(
          color: color,
          fontSize:
              left
                  ? widget.leftTextFontSize ?? context.bodyLarge?.fontSize
                  : widget.rightTextFontSize ?? context.titleMedium?.fontSize,
        ),
        fontWeight: left ? FontWeight.w400 : FontWeight.w600,
      ),
    ),
  );

  @override
  void _handleDragUpdate(DragUpdateDetails details) {
    super._baseHandleDragUpdate(details);

    const threshold = 0.15;
    final progress = (_currentHeight - _minHeight) / (_maxHeight - _minHeight);
    if (progress > (1 - threshold) && !_isFullscreen) {
      _toggleFullscreen(true);
    } else if (progress < threshold && _isFullscreen) {
      _toggleFullscreen(false);
    }
  }

  @override
  void _handleDragEnd(DragEndDetails details) =>
      super._baseHandleDragEnd(details);
}

class TDPopupCenterPanel extends StatelessWidget {
  const TDPopupCenterPanel({
    required this.child,
    super.key,
    this.closeUnderBottom = false,
    this.closeColor,
    this.closeClick,
    this.backgroundColor,
    this.radius,
    this.closeSize,
  });

  final Widget child;

  final bool closeUnderBottom;

  final Color? closeColor;

  final double? closeSize;

  final PopupClick? closeClick;

  final Color? backgroundColor;

  final double? radius;

  @override
  Widget build(BuildContext context) {
    if (closeUnderBottom) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 40),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
              color: backgroundColor ?? Colors.white,
              borderRadius: BorderRadius.circular(radius ?? 12),
            ),
            child: child,
          ),
          IconButton(
            icon: Icon(
              Icons.cancel_outlined,
              color: closeColor ?? Colors.white,
              size: closeSize,
            ),
            onPressed: closeClick,
          ),
        ],
      );
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(radius ?? 12),
      ),
      child: Stack(
        children: [
          child,
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: Icon(
                Icons.close_rounded,
                color: closeColor,
                size: closeSize,
              ),
              onPressed: closeClick,
            ),
          ),
        ],
      ),
    );
  }
}
