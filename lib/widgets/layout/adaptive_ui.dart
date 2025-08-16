import 'package:flutter/material.dart';

import '../../index.dart';

enum BreakpointType { compact, medium, expanded, large, extraLarge }

/// https://m3.material.io/foundations/layout/understanding-layout/overview
///
/// Layout Breakpoints applied according to the material 3 UI standards
///
/// This will handle devices from mobile to large desktops in portrait,
/// landscape and folded devices.
///
/// Base class for defining breakpoints.
///
/// A breakpoint represents a specific screen size that can be used to
/// implement responsive design in a Flutter application. This class
/// provides various helpers for comparing breakpoints, checking orientation,
/// and working with responsive layouts.
@immutable
class Breakpoint {
  /// Creates an instance of [Breakpoint] with a specific width and name.
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

  /// The staring width of the breakpoint.
  final double start;

  /// The ending width of the breakpoint.
  final double? end;

  /// The name of the breakpoint.
  final BreakpointType type;

  bool get isCompact => type == BreakpointType.compact;

  bool get isMedium => type == BreakpointType.medium;

  bool get isExpanded => type == BreakpointType.expanded;

  bool get isLarge => type == BreakpointType.large;

  bool get isExtraLarge => type == BreakpointType.extraLarge;

  /// Returns true if the breakpoint matches the provided [type].
  bool match(String name) => type.name == name.toLowerCase();

  // Comparison and Range Helpers

  /// Returns true if this breakpoint is larger than the [other] breakpoint.
  bool isLargerThan(Breakpoint other) {
    return start > other.start;
  }

  /// Returns true if this breakpoint is larger than or equal to the [other] breakpoint.
  bool isLargerThanOrEqual(Breakpoint other) {
    return start >= other.start;
  }

  /// Returns true if this breakpoint is smaller than the [other] breakpoint.
  bool isSmallerThan(Breakpoint other) {
    return start < other.start;
  }

  /// Returns true if this breakpoint is smaller than or equal to the [other] breakpoint.
  bool isSmallerThanOrEqual(Breakpoint other) {
    return start <= other.start;
  }

  /// Returns true if this breakpoint is equal to the [other] breakpoint.
  bool isEqualTo(Breakpoint other) {
    return start == other.start;
  }

  /// Returns true if this breakpoint is not equal to the [other] breakpoint.
  bool isNotEqualTo(Breakpoint other) {
    return !isEqualTo(other);
  }

  /// Returns true if this breakpoint is between the [lower] and [upper] breakpoints.
  bool isBetween(Breakpoint lower, Breakpoint upper) {
    return isLargerThanOrEqual(lower) && isSmallerThanOrEqual(upper);
  }

  // Logical Operators
  /// Compares this breakpoint with [other] to check if it is larger.
  bool operator >(Breakpoint other) => isLargerThan(other);

  /// Compares this breakpoint with [other] to check if it is larger or equal.
  bool operator >=(Breakpoint other) => isLargerThanOrEqual(other);

  /// Compares this breakpoint with [other] to check if it is smaller.
  bool operator <(Breakpoint other) => isSmallerThan(other);

  /// Compares this breakpoint with [other] to check if it is smaller or equal.
  bool operator <=(Breakpoint other) => isSmallerThanOrEqual(other);

  // Orientation Helpers

  /// Returns true if this breakpoint is the active one in the given [context].
  bool isActive(BuildContext context) => this == of(context);

  /// Creates a copy of this breakpoint with modified properties.
  ///
  /// You can provide a new [type], [start] or [end] to create a new instance
  /// of [Breakpoint] with the updated values.
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

  /// Retrieves the active breakpoint from the context.
  ///
  /// If [listen] is `true` (the default), the widget calling this method will
  /// rebuild whenever the breakpoint changes.
  ///
  /// If [listen] is `false`, the breakpoint is retrieved without establishing a
  /// dependency, preventing unnecessary rebuilds.
  ///
  /// Throws a [FlutterError] if the context does not contain a `PlatformTypeProvider`.
  ///
  /// Example usage:
  /// ```dart
  /// void main() {
  ///   runApp(
  ///     const PlatformTypeProvider(
  ///       breakpoints: [
  ///        Breakpoint(width: 200, name: 'Watch'),
  ///         ...Breakpoint.defaults,
  ///       ],
  ///       child: MyApp(),
  ///     ),
  ///   );
  /// }
  /// ```
  static Breakpoint of(BuildContext context, {bool listen = true}) {
    if (listen) {
      final result =
          context.dependOnInheritedWidgetOfExactType<_PlatformTypeInherited>();
      if (result == null) {
        throw FlutterError(
          'Breakpoint.of() called with a context that does not contain a PlatformTypeProvider.',
        );
      }
      return result.breakpoint;
    } else {
      final inheritedElement =
          context
              .getElementForInheritedWidgetOfExactType<
                _PlatformTypeInherited
              >();
      final result = inheritedElement?.widget as _PlatformTypeInherited?;
      if (result == null) {
        throw FlutterError(
          'Breakpoint.of() called with a context that does not contain a PlatformTypeProvider.',
        );
      }
      return result.breakpoint;
    }
  }

  // String Representation
  /// Returns a human-readable string representation of this breakpoint.
  /// e.g. "compact: 0, 600".
  String toPrettyString() => '${type.name}: $start, $end';

  static const List<Breakpoint> defaults = [
    Breakpoint.compact(),
    Breakpoint.medium(),
    Breakpoint.expanded(),
    Breakpoint.large(),
    Breakpoint.expanded(),
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
  int get hashCode => start.hashCode * end.hashCode * type.hashCode;
}

/// Provides information about the current platform size and orientation.
class PlatformSizeInfo {
  /// Creates an instance of [PlatformSizeInfo].
  PlatformSizeInfo({
    required this.platform,
    required this.breakpoint,
    required this.orientation,
  });

  final Breakpoint breakpoint;
  final Orientation orientation;
  final TargetPlatform platform;
}

/// An inherited widget that holds the current [Breakpoint] for its descendants.
class _PlatformTypeInherited extends InheritedWidget {
  /// Creates an instance of [_PlatformTypeInherited].
  const _PlatformTypeInherited({
    required this.breakpoint,
    required super.child,
  });

  /// The current breakpoint.
  final Breakpoint breakpoint;

  @override
  bool updateShouldNotify(_PlatformTypeInherited oldWidget) =>
      breakpoint != oldWidget.breakpoint;
}

/// A widget that provides the current [Breakpoint] and [Orientation] to its descendants.
/// Wrap this around the root of your application to make platform and orientation information
/// available throughout the widget tree.
///
/// Example usage:
/// ```dart
/// runApp(PlatformTypeProvider(
///     breakpoints: Breakpoint.defaults,
///     child: MyApp(),
/// ));
/// ```
/// You can also customize the breakpoints by providing a list of [Breakpoint]s.
/// This is useful for applications that need to support custom breakpoints for different devices.
/// Example usage:
/// ```dart
/// void main() {
///   runApp(
///     const PlatformTypeProvider(
///       breakpoints: [
///        Breakpoint(width: 200, name: 'Watch'),
///         ...Breakpoint.defaults,
///       ],
///       child: MyApp(),
///     ),
///   );
/// }
/// ```
class PlatformTypeProvider extends StatefulWidget {
  /// Creates an instance of [PlatformTypeProvider].
  ///
  /// [child] - The widget below this widget in the tree.
  /// [breakpoints] - Defines the breakpoints used for platform type detection.
  const PlatformTypeProvider({
    required this.child,
    this.breakpoints = Breakpoint.defaults,
    super.key,
  });

  /// The widget below this widget in the tree.
  final Widget child;

  /// Defines the breakpoints used for platform type detection.
  final List<Breakpoint> breakpoints;

  @override
  State<PlatformTypeProvider> createState() => _PlatformTypeProviderState();
}

class _PlatformTypeProviderState extends State<PlatformTypeProvider> {
  late Breakpoint _currentBreakpoint;
  final List<Breakpoint> breakpoints = [];

  @override
  void initState() {
    super.initState();

    breakpoints
      ..clear()
      ..addAll(widget.breakpoints)
      ..sort((a, b) {
        return a.start.compareTo(b.start);
      });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updatePlatformType();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updatePlatformType();
  }

  void _updatePlatformType() {
    setState(() {
      _currentBreakpoint = getBreakpoint(
        MediaQuery.sizeOf(context),
        breakpoints,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return _PlatformTypeInherited(
      breakpoint: _currentBreakpoint,
      child: widget.child,
    );
  }

  Breakpoint getBreakpoint(Size size, List<Breakpoint> breakpoints) {
    for (final breakpoint in breakpoints) {
      if (size.width <= breakpoint.start) return breakpoint;
    }
    return breakpoints.last;
  }
}

/// Extension methods on [BuildContext] for easy access to [Breakpoint] and [Orientation].
extension BuildContextPlatformExtension on BuildContext {
  /// Gets the current [Breakpoint] for the given [BuildContext] and establishes
  /// a dependency, causing the widget to rebuild whenever the breakpoint changes.
  ///
  /// Throws a [FlutterError] if no [PlatformTypeProvider] is found in the widget tree.
  Breakpoint get watchBreakpoint => Breakpoint.of(this);

  /// Gets the current [Breakpoint] for the given [BuildContext] without
  /// establishing a dependency, preventing unnecessary rebuilds.
  ///
  /// Throws a [FlutterError] if no [PlatformTypeProvider] is found in the widget tree.
  Breakpoint get readBreakpoint => Breakpoint.of(this, listen: false);

  /// Gets the current [PlatformSizeInfo] for the given [BuildContext].
  PlatformSizeInfo get platformSizeInfo => PlatformSizeInfo(
    breakpoint: watchBreakpoint,
    orientation: MediaQuery.orientationOf(this),
    platform: PlatformChecker.targetPlatform,
  );
}

class PlatformInfoLayoutBuilder extends StatelessWidget {
  /// Creates an instance of [PlatformInfoLayoutBuilder].
  ///
  /// [builder] - A function that takes the [BuildContext] and [PlatformSizeInfo] to build the widget.
  /// [Breakpoint] - Defines the breakpoints used for platform type detection.
  const PlatformInfoLayoutBuilder({required this.builder, super.key});

  final Widget Function(BuildContext, PlatformSizeInfo) builder;

  @override
  Widget build(BuildContext context) {
    return builder(context, context.platformSizeInfo);
  }
}

class BreakpointLayoutBuilder extends StatelessWidget {
  /// Creates an instance of [BreakpointLayoutBuilder].
  ///
  /// [builder] - A function that takes the [BuildContext] and [Breakpoint] to build the widget.
  const BreakpointLayoutBuilder({required this.builder, super.key});

  final Widget Function(BuildContext, Breakpoint) builder;

  @override
  Widget build(BuildContext context) {
    return builder(context, context.watchBreakpoint);
  }
}
