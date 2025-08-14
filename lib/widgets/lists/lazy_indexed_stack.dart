import 'dart:collection';

import 'package:flutter/material.dart';

import '../layout/no_widget.dart';

/// A custom IndexedStack implementation with optional fade transition
/// and page caching logic controlled by [MyIndexedStackController].
///
/// Unlike a regular [IndexedStack], this widget:
/// - Can animate between index changes using a fade effect.
/// - Allows controlling which pages are cached, preloaded, or disposed.
/// - Works in conjunction with [MyIndexedStackController] to manage
///   memory usage and preloading.
///
/// This is useful for scenarios such as tab navigation with heavy
/// child widgets that should not all be built at once.
class MyIndexedStack extends StatefulWidget {
  /// Creates a [MyIndexedStack].
  ///
  /// The [index], [controller], and [children] parameters are required.
  const MyIndexedStack({
    required this.index,
    required this.children,
    this.controller,
    super.key,
    this.animate = true,
    this.duration = const Duration(milliseconds: 250),
    this.alignment = AlignmentDirectional.topStart,
    this.textDirection,
    this.clipBehavior = Clip.hardEdge,
    this.fit = StackFit.loose,
  });

  /// An optional controller that manages the state and behavior of the [MyIndexedStack].
  ///
  /// If provided, this controller can be used to programmatically change the
  /// currently displayed child or listen for index changes within the stack.
  final MyIndexedStackController? controller;

  /// How to align the non-positioned and partially-positioned children in the
  /// stack.
  ///
  /// Defaults to [AlignmentDirectional.topStart].
  ///
  /// See [Stack.alignment] for more information.
  final AlignmentGeometry alignment;

  /// The text direction with which to resolve [alignment].
  ///
  /// Defaults to the ambient [Directionality].
  final TextDirection? textDirection;

  /// {@macro flutter.material.Material.clipBehavior}
  ///
  /// Defaults to [Clip.hardEdge].
  final Clip clipBehavior;

  /// How to size the non-positioned children in the stack.
  ///
  /// Defaults to [StackFit.loose].
  ///
  /// See [Stack.fit] for more information.
  final StackFit fit;

  /// The index of the child to show.
  ///
  /// If this is null, none of the children will be shown.
  final int? index;

  /// The child widgets of the stack.
  ///
  /// Only the child at index [index] will be shown.
  ///
  /// See [Stack.children] for more information.
  final List<Widget> children;

  /// The duration for the fade animation.
  ///
  /// Defaults to 250 milliseconds.
  final Duration duration;

  /// Whether to animate index changes with a fade transition.
  final bool animate;

  @override
  State<MyIndexedStack> createState() => _MyIndexedStackState();
}

class _MyIndexedStackState extends State<MyIndexedStack>
    with SingleTickerProviderStateMixin {
  late final MyIndexedStackController _controller;
  late final AnimationController _animation;

  @override
  void initState() {
    _controller = widget.controller ?? MyIndexedStackController();
    _animation = AnimationController(vsync: this, duration: widget.duration);
    _animation.forward();
    super.initState();
  }

  @override
  void didUpdateWidget(MyIndexedStack oldWidget) {
    if (widget.index != oldWidget.index) {
      _animation.forward(from: 0);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _controller.currentIndex;
    final loadedIndexes = _controller.loadedIndexes;
    final visibleChildren = List<Widget>.filled(
      widget.children.length,
      const NoWidget(),
    );

    for (final i in loadedIndexes) {
      if (i < widget.children.length) {
        visibleChildren[i] = KeyedSubtree(
          key: ValueKey('lc$i'),
          child: TickerMode(
            enabled: i == currentIndex,
            child: widget.children[i],
          ),
        );
      }
    }

    final stack = IndexedStack(
      index: currentIndex,
      alignment: widget.alignment,
      clipBehavior: widget.clipBehavior,
      textDirection: widget.textDirection,
      sizing: widget.fit,
      children: visibleChildren,
    );

    if (widget.animate) {
      return FadeTransition(opacity: _animation, child: stack);
    } else {
      return stack;
    }
  }

  @override
  void dispose() {
    _animation.dispose();
    _controller.dispose();
    super.dispose();
  }
}

class MyIndexedStackController extends Listenable with WidgetsBindingObserver {
  MyIndexedStackController({
    int initialIndex = 0,
    this.preloadIndexes = const [],
    this.disposeUnused = false,
    this.maxCachedPages = 3,
    this.removableIndexes = const [],
    this.isListenMemoryPressure = false,
  }) : _currentIndex = initialIndex {
    _markAsUsed(initialIndex);

    preloadIndexes.forEach(_markAsUsed);

    if (isListenMemoryPressure) {
      WidgetsBinding.instance.addObserver(this);
    }
  }

  final List<VoidCallback> _listeners = [];

  int _currentIndex;
  final int maxCachedPages;
  final List<int> preloadIndexes;
  final bool disposeUnused;
  final List<int> removableIndexes;
  final bool isListenMemoryPressure;

  final LinkedHashMap<int, bool> _loadedPages = LinkedHashMap<int, bool>();

  // Listenable implementation
  @override
  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  void _notifyListeners() {
    for (final listener in List<VoidCallback>.from(_listeners)) {
      listener();
    }
  }

  Set<int> get loadedIndexes => _loadedPages.keys.toSet();
  int get currentIndex => _currentIndex;
  bool get canGoBack => _currentIndex > 0;
  bool isLoaded(int index) => _loadedPages.containsKey(index);

  // Memory pressure handler
  @override
  void didHaveMemoryPressure() {
    _removeSpecifiedIndexes();
  }

  void _removeSpecifiedIndexes() {
    bool changed = false;
    final protectedIndexes = {_currentIndex, ...preloadIndexes};

    for (final index in removableIndexes) {
      if (!protectedIndexes.contains(index) &&
          _loadedPages.containsKey(index)) {
        _loadedPages.remove(index);
        changed = true;
      }
    }

    if (changed) {
      _notifyListeners();
    }
  }

  void _markAsUsed(int index) {
    _loadedPages.remove(index);
    _loadedPages[index] = true;

    if (_loadedPages.length > maxCachedPages) {
      _enforceMaxSize();
    }
  }

  void switchTo(
    int index,
    int totalPages,
    //{bool notify = true}
  ) {
    // if (index < 0 || index >= totalPages || index == _currentIndex) return;

    _currentIndex = index;
    _markAsUsed(index);
    _notifyListeners();

    if (disposeUnused) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _enforceMaxSize();
        _notifyListeners();
      });
    }
  }

  void _enforceMaxSize() {
    if (_loadedPages.length <= maxCachedPages) return;

    final protectedIndexes = {_currentIndex, ...preloadIndexes};
    final iterator = _loadedPages.keys.iterator;
    final toRemove = <int>[];

    while (iterator.moveNext() &&
        (_loadedPages.length - toRemove.length) > maxCachedPages) {
      final key = iterator.current;
      if (!protectedIndexes.contains(key)) {
        toRemove.add(key);
      }
    }

    toRemove.forEach(_loadedPages.remove);
  }

  void reset() {
    _loadedPages.clear();
    _markAsUsed(_currentIndex);
    preloadIndexes.forEach(_markAsUsed);
    _notifyListeners();
  }

  void disposePage(int index) {
    if (index == _currentIndex || preloadIndexes.contains(index)) {
      return;
    }

    if (_loadedPages.remove(index) != null) {
      _notifyListeners();
    }
  }

  void disposePages(List<int> indexes) {
    bool changed = false;
    final protectedIndexes = {_currentIndex, ...preloadIndexes};

    for (final index in indexes) {
      if (!protectedIndexes.contains(index) &&
          _loadedPages.remove(index) != null) {
        changed = true;
      }
    }

    if (changed) {
      _notifyListeners();
    }
  }

  void preloadPage(int index, int totalPages) {
    if (index < 0 || index >= totalPages || _loadedPages.containsKey(index)) {
      return;
    }

    _markAsUsed(index);
    _notifyListeners();
  }

  void preloadAdjacentPages(int totalPages, [int range = 1]) {
    bool changed = false;

    for (int i = 1; i <= range; i++) {
      final nextIndex = _currentIndex + i;
      final prevIndex = _currentIndex - i;

      if (nextIndex < totalPages && !_loadedPages.containsKey(nextIndex)) {
        _markAsUsed(nextIndex);
        changed = true;
      }

      if (prevIndex >= 0 && !_loadedPages.containsKey(prevIndex)) {
        _markAsUsed(prevIndex);
        changed = true;
      }
    }

    if (changed) {
      _notifyListeners();
    }
  }

  void dispose() {
    _loadedPages.clear();
    _listeners.clear();
    if (isListenMemoryPressure) {
      WidgetsBinding.instance.removeObserver(this);
    }
  }
}
