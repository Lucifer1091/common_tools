import 'package:flutter/material.dart';

import '../../index.dart';

/// Marks [child] as disabled by reducing its opacity to half and ignoring
/// pointers.
class Disabled extends StatelessWidget {
  /// Marks [child] as disabled by reducing its opacity to half and ignoring
  /// pointers.
  const Disabled({
    required this.child,
    super.key,
    this.onDisabledTapped,
    this.reason,
    this.isDisabled = true,
  });

  /// Dictates whether the [child] is currently in disabled state.
  final bool isDisabled;

  /// Widget [child]
  final Widget child;

  /// Callback fired when the child is tapped while disabled.
  final ContextCallback? onDisabledTapped;

  /// Reason to inform the user on why is this widget disabled. If not null,
  /// when tapping into a disabled widget it will show an alert
  /// through the closest ancestor of type [AlertManager]
  final String? reason;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: isDisabled ? SystemMouseCursors.forbidden : MouseCursor.defer,
      child: GestureDetector(
        onTap:
            isDisabled
                ? () {
                  onDisabledTapped?.call(context);

                  if (reason == null) return;
                  final alertManager = AlertManager.maybeOf(context);
                  alertManager?.alert(msg: reason!);
                }
                : null,
        child: AnimatedOpacity(
          opacity: isDisabled ? 0.5 : 1,
          duration: const Duration(milliseconds: 300),
          curve: Curves.elasticInOut,
          child: AbsorbPointer(absorbing: isDisabled, child: child),
        ),
      ),
    );
  }
}

const ColorFilter _greyscale = ColorFilter.matrix(<double>[
  0.2126, 0.7152, 0.0722, 0, 0, //
  0.2126, 0.7152, 0.0722, 0, 0, //
  0.2126, 0.7152, 0.0722, 0, 0, //
  0, 0, 0, 1, 0, //
]);

/// This widget can be used to disable the widget and/or show a color filter
class DisableWidget extends StatelessWidget {
  final Widget child;
  final bool disable;

  /// Custom color filter instead of the default grey filter
  final ColorFilter _colorFilter;

  /// `false` if just want to ingore pointer event, but not filter color
  final bool _showColorFilter;

  const DisableWidget({
    super.key,
    required this.child,
    required this.disable,
    ColorFilter? colorFilter,
    bool? showColorFilter,
  }) : _showColorFilter = showColorFilter ?? disable,
       _colorFilter = colorFilter ?? _greyscale;

  @override
  Widget build(BuildContext context) {
    var widget = child;

    if (_showColorFilter) {
      widget = ColorFiltered(colorFilter: _colorFilter, child: child);
    }

    if (disable) {
      return IgnorePointer(ignoring: disable, child: widget);
    }

    return widget;
  }
}
