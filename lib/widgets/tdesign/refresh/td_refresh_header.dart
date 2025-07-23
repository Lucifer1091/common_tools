import 'dart:math';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';

import '../../../common_tools.dart';
import '../loading/td_loading.dart';
import '../text/td_text.dart';

/// TDesign refreshes the header
/// Combines with the EasyRefresh class to implement pull-down refresh,
/// inherited from the Header class, the field meaning is consistent with the parent class
class TDRefreshHeader extends Header {
  TDRefreshHeader({
    this.key,
    this.extent = 48.0,
    double? triggerOffset,
    this.triggerDistance = 48.0,
    bool? clamping,
    this.float = false,
    Duration? processedDuration,
    this.completeDuration,
    bool? hapticFeedback,
    this.enableHapticFeedback = true,
    double? infiniteOffset,
    this.enableInfiniteRefresh = false,
    bool? infiniteHitOver,
    this.overScroll = true,
    this.loadingIcon = TDLoadingIcon.circle,
    this.backgroundColor,
    super.spring,
    super.horizontalSpring,
    super.readySpringBuilder,
    super.horizontalReadySpringBuilder,
    super.springRebound,
    super.frictionFactor,
    super.horizontalFrictionFactor,
    super.safeArea = false,
    super.hitOver,
    super.position,
    super.secondaryTriggerOffset,
    super.secondaryVelocity,
    super.secondaryDimension,
    super.secondaryCloseTriggerOffset,
    super.notifyWhenInvisible,
    super.listenable,
    super.triggerWhenReach,
    super.triggerWhenRelease,
    super.triggerWhenReleaseNoWait,
    super.maxOverOffset,
  }) : assert(
         (triggerOffset ?? triggerDistance) > 0.0,
         'triggerOffset or triggerDistance must be greater than 0.0',
       ),
       assert(
         extent != null && extent >= 0.0,
         'extent must not be null and must be >= 0.0',
       ),
       assert(
         extent != null &&
             ((clamping ?? float) ||
                 (triggerOffset ?? triggerDistance) >= extent),
         'The refresh indicator cannot take more space in its final state '
         'than the amount initially created by overscrolling.',
       ),
       super(
         triggerOffset: triggerOffset ?? triggerDistance,
         clamping: clamping ?? float,
         processedDuration:
             processedDuration ??
             completeDuration ??
             const Duration(seconds: 1),
         hapticFeedback: hapticFeedback ?? enableHapticFeedback,
         infiniteOffset: enableInfiniteRefresh ? infiniteOffset : null,
         infiniteHitOver: infiniteHitOver ?? overScroll,
       );

  final Key? key;

  final TDLoadingIcon loadingIcon;

  final Color? backgroundColor;

  /// Header container height
  final double? extent;

  /// The offset that triggers the refresh task, same as [triggerOffset]
  final double triggerDistance;

  final bool float;

  final Duration? completeDuration;

  final bool enableHapticFeedback;

  final bool enableInfiniteRefresh;

  /// Out-of-bounds scrolling (effective when [enableInfiniteRefresh] is
  /// true or [infiniteOffset] has a value)
  final bool overScroll;

  @override
  Widget build(BuildContext context, IndicatorState state) {
    // Cannot be horizontal
    assert(
      state.axisDirection == AxisDirection.down ||
          state.axisDirection == AxisDirection.up,
      'Widget cannot be horizontal',
    );
    return TGIconHeaderWidget(
      key: key,
      loadingIcon: loadingIcon,
      backgroundColor: backgroundColor,
      state: state,
      refreshIndicatorExtent: extent ?? state.triggerOffset,
    );
  }
}

class TGIconHeaderWidget extends StatefulWidget {
  const TGIconHeaderWidget({
    required this.state,
    required this.refreshIndicatorExtent,
    required this.loadingIcon,
    super.key,
    this.backgroundColor,
  });

  final TDLoadingIcon loadingIcon;

  final Color? backgroundColor;

  final IndicatorState state;

  final double refreshIndicatorExtent;

  @override
  TGIconHeaderWidgetState createState() {
    return TGIconHeaderWidgetState();
  }
}

class TGIconHeaderWidgetState extends State<TGIconHeaderWidget>
    with TickerProviderStateMixin {
  IndicatorMode get _refreshState => widget.state.mode;
  double get _offset => widget.state.offset;
  double get _actualTriggerOffset => widget.state.actualTriggerOffset;
  bool get _reverse => widget.state.reverse;
  double get _safeOffset => widget.state.safeOffset;

  Widget _buildLoading() => TDLoading(
    icon: widget.loadingIcon,
    iconColor: ThemeColors.blue.shade600,
    axis: Axis.horizontal,
    text: 'Refreshing',
    textColor: ThemeColors.neutral.shade700,
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _offset,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top:
                _offset < _actualTriggerOffset
                    ? -(_actualTriggerOffset -
                            _offset +
                            (_reverse ? _safeOffset : -_safeOffset)) /
                        2
                    : (!_reverse ? _safeOffset : 0),
            bottom:
                _offset < _actualTriggerOffset
                    ? null
                    : (_reverse ? _safeOffset : 0),
            height:
                _offset < _actualTriggerOffset ? _actualTriggerOffset : null,
            child: Container(
              alignment: Alignment.center,
              height: widget.refreshIndicatorExtent,
              color: widget.backgroundColor,
              child: Visibility(
                visible:
                    _refreshState == IndicatorMode.processing ||
                    _refreshState == IndicatorMode.ready,
                replacement: Visibility(
                  visible: _refreshState != IndicatorMode.inactive,
                  child: TDText(
                    _refreshState == IndicatorMode.drag
                        ? 'Pull Down To Refresh'
                        : _refreshState == IndicatorMode.processed ||
                            _refreshState == IndicatorMode.done
                        ? 'Refresh completed'
                        : 'Release to refresh',
                    textColor: ThemeColors.neutral.shade700,
                    style: context.bodyMedium?.copyWith(
                      color: ThemeColors.neutral.shade700,
                    ),
                  ),
                ),
                child: Container(child: _buildLoading()),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
