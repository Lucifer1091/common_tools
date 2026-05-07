import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../utilities/my_platform.dart';

enum BreakpointType { compact, medium, expanded, large, extraLarge }

/// Material 3 adaptive layout breakpoint.
///
/// Breakpoints are selected by the highest [start] value that is less than or
/// equal to the current logical screen width.
@immutable
class Breakpoint {
  /// Creates an instance of [Breakpoint] with a specific width and type.
  const Breakpoint({required this.start, required this.type, this.end});

  const Breakpoint.compact({
    this.start = 0,
    this.end = 600,
    this.type = BreakpointType.compact,
  });

  const Breakpoint.medium({
    this.start = 600,
    this.end = 840,
    this.type = BreakpointType.medium,
  });

  const Breakpoint.expanded({
    this.start = 840,
    this.end = 1200,
    this.type = BreakpointType.expanded,
  });

  const Breakpoint.large({
    this.start = 1200,
    this.end = 1600,
    this.type = BreakpointType.large,
  });

  const Breakpoint.extraLarge({
    this.start = 1600,
    this.end = double.maxFinite,
    this.type = BreakpointType.extraLarge,
  });

  /// The starting width for this breakpoint.
  final double start;

  /// The ending width for this breakpoint.
  final double? end;

  /// The breakpoint category.
  final BreakpointType type;

  bool get isCompact => type == BreakpointType.compact;

  bool get isMedium => type == BreakpointType.medium;

  bool get isExpanded => type == BreakpointType.expanded;

  bool get isLarge => type == BreakpointType.large;

  bool get isExtraLarge => type == BreakpointType.extraLarge;

  /// Returns true if the breakpoint matches the provided [name].
  bool match(String name) => type.name == name.toLowerCase();

  /// Returns true if this breakpoint is larger than the [other] breakpoint.
  bool isLargerThan(Breakpoint other) => start > other.start;

  /// Returns true if this breakpoint is larger than or equal to [other].
  bool isLargerThanOrEqual(Breakpoint other) => start >= other.start;

  /// Returns true if this breakpoint is smaller than the [other] breakpoint.
  bool isSmallerThan(Breakpoint other) => start < other.start;

  /// Returns true if this breakpoint is smaller than or equal to [other].
  bool isSmallerThanOrEqual(Breakpoint other) => start <= other.start;

  /// Returns true if this breakpoint starts at the same width as [other].
  bool isEqualTo(Breakpoint other) => start == other.start;

  /// Returns true if this breakpoint does not start at the same width as [other].
  bool isNotEqualTo(Breakpoint other) => !isEqualTo(other);

  /// Returns true if this breakpoint is between [lower] and [upper].
  bool isBetween(Breakpoint lower, Breakpoint upper) {
    return isLargerThanOrEqual(lower) && isSmallerThanOrEqual(upper);
  }

  /// Compares this breakpoint with [other] to check if it is larger.
  bool operator >(Breakpoint other) => isLargerThan(other);

  /// Compares this breakpoint with [other] to check if it is larger or equal.
  bool operator >=(Breakpoint other) => isLargerThanOrEqual(other);

  /// Compares this breakpoint with [other] to check if it is smaller.
  bool operator <(Breakpoint other) => isSmallerThan(other);

  /// Compares this breakpoint with [other] to check if it is smaller or equal.
  bool operator <=(Breakpoint other) => isSmallerThanOrEqual(other);

  /// Returns true if this breakpoint is the active one in [context].
  bool isActive(BuildContext context) => this == of(context);

  /// Creates a copy of this breakpoint with modified properties.
  Breakpoint copyWith({
    required BreakpointType type,
    double? start,
    double? end,
  }) {
    return Breakpoint(
      start: start ?? this.start,
      end: end ?? this.end,
      type: type,
    );
  }

  /// Resolves a value using this breakpoint's fallback chain.
  T resolve<T>({
    required T compact,
    T? medium,
    T? expanded,
    T? large,
    T? extraLarge,
  }) {
    return switch (type) {
      BreakpointType.compact => compact,
      BreakpointType.medium => medium ?? compact,
      BreakpointType.expanded => expanded ?? medium ?? compact,
      BreakpointType.large => large ?? expanded ?? medium ?? compact,
      BreakpointType.extraLarge =>
        extraLarge ?? large ?? expanded ?? medium ?? compact,
    };
  }

  /// Retrieves the active breakpoint from the nearest [BreakpointProvider].
  static Breakpoint of(BuildContext context, {bool listen = true}) {
    final result = maybeOf(context, listen: listen);
    if (result != null) return result;

    throw FlutterError(
      'Breakpoint.of() called with a context that does not contain a '
      'BreakpointProvider.',
    );
  }

  /// Retrieves the active breakpoint from the nearest [BreakpointProvider].
  ///
  /// Returns `null` when no [BreakpointProvider] is found.
  static Breakpoint? maybeOf(BuildContext context, {bool listen = true}) {
    if (listen) {
      return context
          .dependOnInheritedWidgetOfExactType<_BreakpointInherited>()
          ?.breakpoint;
    }

    final inheritedElement =
        context.getElementForInheritedWidgetOfExactType<_BreakpointInherited>();
    final result = inheritedElement?.widget as _BreakpointInherited?;
    return result?.breakpoint;
  }

  /// Resolves a breakpoint from a sorted non-empty [breakpoints] list.
  ///
  /// The highest breakpoint with `start <= width` is selected.
  static Breakpoint forWidth(
    double width, {
    List<Breakpoint> breakpoints = defaults,
  }) {
    assert(breakpoints.isNotEmpty, 'breakpoints must not be empty');
    assert(
      _debugIsSortedByStart(breakpoints),
      'breakpoints must be sorted by start in ascending order',
    );
    if (breakpoints.isEmpty) {
      throw ArgumentError.value(
        breakpoints,
        'breakpoints',
        'must not be empty',
      );
    }

    var result = breakpoints.first;
    for (final breakpoint in breakpoints) {
      if (width >= breakpoint.start) {
        result = breakpoint;
      } else {
        break;
      }
    }
    return result;
  }

  /// Returns a human-readable representation, e.g. `compact: 0, 600`.
  String toPrettyString() => '${type.name}: $start, $end';

  static bool _debugIsSortedByStart(List<Breakpoint> breakpoints) {
    for (var index = 1; index < breakpoints.length; index++) {
      if (breakpoints[index].start < breakpoints[index - 1].start) {
        return false;
      }
    }
    return true;
  }

  /// The default Material 3 width breakpoints.
  static const List<Breakpoint> defaults = [
    Breakpoint.compact(),
    Breakpoint.medium(),
    Breakpoint.expanded(),
    Breakpoint.large(),
    Breakpoint.extraLarge(),
  ];

  @override
  String toString() => type.name;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Breakpoint) return false;
    return start == other.start && end == other.end && type == other.type;
  }

  @override
  int get hashCode => Object.hash(start, end, type);
}

/// Provides information about the current platform size and orientation.
class PlatformSizeInfo {
  /// Creates an instance of [PlatformSizeInfo].
  const PlatformSizeInfo({
    required this.platform,
    required this.breakpoint,
    required this.orientation,
  });

  final Breakpoint breakpoint;
  final Orientation orientation;
  final TargetPlatform platform;
}

/// An inherited widget that holds the current [Breakpoint] for descendants.
class _BreakpointInherited extends InheritedWidget {
  /// Creates an instance of [_BreakpointInherited].
  const _BreakpointInherited({required this.breakpoint, required super.child});

  /// The current breakpoint.
  final Breakpoint breakpoint;

  @override
  bool updateShouldNotify(_BreakpointInherited oldWidget) {
    return breakpoint != oldWidget.breakpoint;
  }
}

/// Provides the active [Breakpoint] to descendants.
///
/// Place this below a [MediaQuery], for example in [MaterialApp.builder]:
///
/// ```dart
/// MaterialApp(
///   builder: (context, child) {
///     return BreakpointProvider(
///       child: child ?? const SizedBox.shrink(),
///     );
///   },
/// );
/// ```
class BreakpointProvider extends StatefulWidget {
  /// Creates an instance of [BreakpointProvider].
  const BreakpointProvider({
    required this.child,
    this.breakpoints = Breakpoint.defaults,
    super.key,
  });

  /// The widget below this widget in the tree.
  final Widget child;

  /// Defines the breakpoints used for width detection.
  final List<Breakpoint> breakpoints;

  @override
  State<BreakpointProvider> createState() => _BreakpointProviderState();
}

class _BreakpointProviderState extends State<BreakpointProvider> {
  late List<Breakpoint> _breakpoints;

  @override
  void initState() {
    super.initState();
    _breakpoints = _sortBreakpoints(widget.breakpoints);
  }

  @override
  void didUpdateWidget(covariant BreakpointProvider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(oldWidget.breakpoints, widget.breakpoints)) {
      _breakpoints = _sortBreakpoints(widget.breakpoints);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.maybeSizeOf(context);
    if (size == null) {
      throw FlutterError(
        'BreakpointProvider requires a MediaQuery ancestor. Place it inside '
        'MaterialApp.builder or below another widget that provides MediaQuery.',
      );
    }

    final breakpoint = Breakpoint.forWidth(
      size.width,
      breakpoints: _breakpoints,
    );

    return _BreakpointInherited(breakpoint: breakpoint, child: widget.child);
  }

  List<Breakpoint> _sortBreakpoints(List<Breakpoint> breakpoints) {
    assert(breakpoints.isNotEmpty, 'breakpoints must not be empty');
    if (breakpoints.isEmpty) {
      throw ArgumentError.value(
        breakpoints,
        'breakpoints',
        'must not be empty',
      );
    }

    final sorted = List<Breakpoint>.of(breakpoints)
      ..sort((a, b) => a.start.compareTo(b.start));
    return List<Breakpoint>.unmodifiable(sorted);
  }
}

/// Extension methods on [BuildContext] for breakpoint and platform info.
extension BuildContextPlatformExtension on BuildContext {
  /// Gets the current [Breakpoint] if available and establishes a dependency.
  Breakpoint? get maybeWatchBreakpoint => Breakpoint.maybeOf(this);

  /// Gets the current [Breakpoint] if available without establishing a dependency.
  Breakpoint? get maybeReadBreakpoint =>
      Breakpoint.maybeOf(this, listen: false);

  /// Gets the current [Breakpoint] and establishes a dependency.
  ///
  /// Throws a [FlutterError] if no [BreakpointProvider] is found.
  Breakpoint get watchBreakpoint => Breakpoint.of(this);

  /// Gets the current [Breakpoint] without establishing a dependency.
  ///
  /// Throws a [FlutterError] if no [BreakpointProvider] is found.
  Breakpoint get readBreakpoint => Breakpoint.of(this, listen: false);

  /// Gets the current [PlatformSizeInfo].
  PlatformSizeInfo get platformSizeInfo => PlatformSizeInfo(
    breakpoint: watchBreakpoint,
    orientation: MediaQuery.orientationOf(this),
    platform: MyPlatform.targetPlatform,
  );
}

class PlatformInfoLayoutBuilder extends StatelessWidget {
  /// Creates an instance of [PlatformInfoLayoutBuilder].
  const PlatformInfoLayoutBuilder({required this.builder, super.key});

  final Widget Function(BuildContext, PlatformSizeInfo) builder;

  @override
  Widget build(BuildContext context) {
    return builder(context, context.platformSizeInfo);
  }
}

class BreakpointLayoutBuilder extends StatelessWidget {
  /// Creates an instance of [BreakpointLayoutBuilder].
  const BreakpointLayoutBuilder({required this.builder, super.key});

  final Widget Function(BuildContext, Breakpoint) builder;

  @override
  Widget build(BuildContext context) {
    return builder(context, context.watchBreakpoint);
  }
}
