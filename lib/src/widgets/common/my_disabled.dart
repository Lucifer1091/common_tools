import 'package:flutter/material.dart';

/// A widget that disables its child by preventing interaction and applying
/// visual cues.
///
/// The [MyDisabled] widget wraps a child widget to make it non-interactive
/// when [disabled] is true, optionally adjusting its opacity and cursor to
/// indicate the disabled state.
class MyDisabled extends StatelessWidget {
  /// Creates a widget that conditionally disables its child.
  const MyDisabled({
    required this.disabled,
    required this.child,
    super.key,
    this.showForbiddenCursor = false,
    ColorFilter? colorFilter,
    bool? showColorFilter,
  }) : _showColorFilter = showColorFilter ?? disabled,
       _colorFilter = colorFilter ?? _greyscale;

  /// Whether the child widget is disabled.
  /// When true, the child becomes non-interactive and may be visually altered.
  final bool disabled;

  /// The widget to be conditionally disabled.
  /// Receives the disabled behavior and styling applied by this widget.
  final Widget child;

  /// Whether to display a forbidden cursor when the widget is disabled and
  /// hovered. Defaults to false; when true, uses
  /// [SystemMouseCursors.forbidden].
  final bool showForbiddenCursor;

  /// Custom color filter instead of the default grey filter
  final ColorFilter _colorFilter;

  /// `false` if just want to ingore pointer event, but not filter color
  final bool _showColorFilter;

  @override
  Widget build(BuildContext context) {
    Widget view = AbsorbPointer(absorbing: disabled, child: child);

    if (showForbiddenCursor && disabled) {
      view = MouseRegion(cursor: SystemMouseCursors.forbidden, child: view);
    }

    if (_showColorFilter) {
      return ColorFiltered(colorFilter: _colorFilter, child: view);
    }

    return view;
  }
}

const ColorFilter _greyscale = ColorFilter.matrix(<double>[
  0.2126, 0.7152, 0.0722, 0, 0, //
  0.2126, 0.7152, 0.0722, 0, 0, //
  0.2126, 0.7152, 0.0722, 0, 0, //
  0, 0, 0, 1, 0, //
]);
