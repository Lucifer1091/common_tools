import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';

/// A custom [IndexedStack] implementation with optional fade transition
/// and page caching logic controlled by optional [MyIndexedStackController].
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
  const MyIndexedStack({
    required this.children,
    this.index,
    this.controller,
    super.key,
    this.animate = true,
    this.duration = const Duration(milliseconds: 250),
    this.alignment = AlignmentDirectional.topStart,
    this.textDirection,
    this.clipBehavior = Clip.hardEdge,
    this.fit = StackFit.loose,
  }) : assert(
         index != null || controller != null,
         'Either index or controller must be provided to switch between pages.',
       );

  final int? index;
  final MyIndexedStackController? controller;
  final List<Widget> children;
  final AlignmentGeometry alignment;
  final TextDirection? textDirection;
  final Clip clipBehavior;
  final StackFit fit;
  final Duration duration;
  final bool animate;

  @override
  State<MyIndexedStack> createState() => _MyIndexedStackState();
}

class _MyIndexedStackState extends State<MyIndexedStack>
    with SingleTickerProviderStateMixin {
  late MyIndexedStackController _controller;
  late final AnimationController _animation;
  late bool _internal;
  late int _lastAnimatedIndex;

  @override
  void initState() {
    super.initState();
    _internal = widget.controller == null;
    _controller =
        widget.controller ??
        MyIndexedStackController(
          initialIndex: widget.index ?? 0,
          totalPages: widget.children.length,
        );
    _controller.addListener(_handleControllerChanged);
    _animation = AnimationController(vsync: this, duration: widget.duration);
    _lastAnimatedIndex = _resolvedIndex;

    if (widget.animate) {
      unawaited(_animation.forward());
    } else {
      _animation.value = 1;
    }
  }

  @override
  void didUpdateWidget(MyIndexedStack oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.duration != oldWidget.duration) {
      _animation.duration = widget.duration;
    }

    if (_shouldRecreateController(oldWidget)) {
      final previousController = _controller;
      final wasInternal = _internal;

      previousController.removeListener(_handleControllerChanged);
      _internal = widget.controller == null;
      _controller =
          widget.controller ??
          MyIndexedStackController(
            initialIndex: _clampIndex(
              widget.index ?? previousController.currentIndex,
            ),
            totalPages: widget.children.length,
          );
      _controller.addListener(_handleControllerChanged);

      if (wasInternal) {
        previousController.dispose();
      }
    }

    final nextIndex = widget.index;
    if (nextIndex != null && nextIndex != oldWidget.index) {
      _controller.jumpTo(_clampIndex(nextIndex));
    }

    if (!widget.animate) {
      _animation.value = 1;
    }

    _syncAnimation(forceAnimate: widget.controller != oldWidget.controller);
  }

  bool _shouldRecreateController(MyIndexedStack oldWidget) {
    return widget.controller != oldWidget.controller ||
        (widget.controller == null &&
            oldWidget.children.length != widget.children.length);
  }

  int get _resolvedIndex {
    if (widget.children.isEmpty) return 0;
    return _clampIndex(widget.index ?? _controller.currentIndex);
  }

  int _clampIndex(int index) {
    if (widget.children.isEmpty) return 0;
    if (index < 0) return 0;
    if (index >= widget.children.length) return widget.children.length - 1;
    return index;
  }

  void _handleControllerChanged() {
    if (widget.index != null) return;
    _syncAnimation();
  }

  void _syncAnimation({bool forceAnimate = false}) {
    final currentIndex = _resolvedIndex;
    final didChange = currentIndex != _lastAnimatedIndex;

    if (widget.animate && (forceAnimate || didChange)) {
      unawaited(_animation.forward(from: 0));
    }

    _lastAnimatedIndex = currentIndex;
  }

  List<Widget> _buildChildren(int currentIndex) {
    final builtChildren = List<Widget>.filled(
      widget.children.length,
      const SizedBox.shrink(),
    );

    for (final index in _controller.loadedIndexes) {
      if (index >= 0 && index < widget.children.length) {
        builtChildren[index] = KeyedSubtree(
          key: ValueKey<int>(index),
          child: TickerMode(
            enabled: index == currentIndex,
            child: widget.children[index],
          ),
        );
      }
    }

    return builtChildren;
  }

  @override
  Widget build(BuildContext context) {
    final stack = ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        final safeIndex = _resolvedIndex;

        return IndexedStack(
          index: safeIndex,
          alignment: widget.alignment,
          clipBehavior: widget.clipBehavior,
          textDirection: widget.textDirection,
          sizing: widget.fit,
          children: _buildChildren(safeIndex),
        );
      },
    );

    if (widget.animate) {
      return FadeTransition(opacity: _animation, child: stack);
    } else {
      return stack;
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_handleControllerChanged);
    _animation.dispose();
    if (_internal) _controller.dispose();
    super.dispose();
  }
}

class MyIndexedStackController extends ChangeNotifier
    with WidgetsBindingObserver {
  MyIndexedStackController({
    int initialIndex = 0,
    this.preloadIndexes = const [],
    this.disposeUnused = false,
    this.totalPages,
    this.maxCachedPages = 3,
    this.removableIndexes = const [],
    this.isListenMemoryPressure = false,
  }) : _currentIndex = initialIndex {
    //
    // Check for conflicting indexes
    final conflictingIndexes = preloadIndexes.toSet().intersection(
      removableIndexes.toSet(),
    );
    if (conflictingIndexes.isNotEmpty) {
      debugPrint(
        '[MyIndexedStack] Warning: The same index is in both preloadIndexes and removableIndexes. '
        'It will be preloaded initially but disposed when not visible. Conflicting indexes: $conflictingIndexes',
      );
    }

    _markAsUsed(initialIndex);

    preloadIndexes.forEach(_markAsUsed);

    if (isListenMemoryPressure) {
      WidgetsBinding.instance.addObserver(this);
    }
  }

  int _currentIndex;
  final int? totalPages;
  final int maxCachedPages;
  final List<int> preloadIndexes;
  final bool disposeUnused;
  final List<int> removableIndexes;
  final bool isListenMemoryPressure;

  final LinkedHashSet<int> _loadedPages = LinkedHashSet<int>();
  late final Set<int> _loadedIndexesView = UnmodifiableSetView<int>(
    _loadedPages,
  );

  Set<int> get loadedIndexes => _loadedIndexesView;
  int get currentIndex => _currentIndex;
  bool get canGoBack => _currentIndex > 0;
  bool isLoaded(int index) => _loadedPages.contains(index);

  @override
  void didHaveMemoryPressure() {
    _removeSpecifiedIndexes();
  }

  void _removeSpecifiedIndexes() {
    bool changed = false;
    final protectedIndexes = {_currentIndex, ...preloadIndexes};

    for (final index in removableIndexes) {
      if (!protectedIndexes.contains(index) && _loadedPages.remove(index)) {
        changed = true;
      }
    }

    if (changed) notifyListeners();
  }

  void _markAsUsed(int index) {
    if (index < 0) return;

    _loadedPages
      ..remove(index)
      ..add(index);

    if (_loadedPages.length > maxCachedPages) {
      _enforceMaxSize();
    }
  }

  /// Switch to a given index, only if it's valid.
  void jumpTo(int index) {
    if (index < 0 ||
        (totalPages != null && index >= totalPages!) ||
        index == _currentIndex) {
      return;
    }

    _currentIndex = index;
    _markAsUsed(index);
    notifyListeners();

    if (disposeUnused) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!hasListeners) return;
        if (_enforceMaxSize()) {
          notifyListeners();
        }
      });
    }
  }

  bool _enforceMaxSize() {
    if (_loadedPages.length <= maxCachedPages) return false;

    final protectedIndexes = {_currentIndex, ...preloadIndexes};
    final iterator = _loadedPages.iterator;
    final toRemove = <int>[];

    while (iterator.moveNext() &&
        (_loadedPages.length - toRemove.length) > maxCachedPages) {
      final key = iterator.current;
      if (!protectedIndexes.contains(key)) {
        toRemove.add(key);
      }
    }

    toRemove.forEach(_loadedPages.remove);

    return toRemove.isNotEmpty;
  }

  void reset() {
    _loadedPages.clear();
    _markAsUsed(_currentIndex);
    preloadIndexes.forEach(_markAsUsed);
    notifyListeners();
  }

  void disposePage(int index) {
    if (index == _currentIndex || preloadIndexes.contains(index)) {
      return;
    }

    if (_loadedPages.remove(index)) notifyListeners();
  }

  void disposePages(List<int> indexes) {
    bool changed = false;
    final protectedIndexes = {_currentIndex, ...preloadIndexes};

    for (final index in indexes) {
      if (!protectedIndexes.contains(index) && _loadedPages.remove(index)) {
        changed = true;
      }
    }

    if (changed) notifyListeners();
  }

  void preloadPage(int index) {
    if (index < 0 ||
        (totalPages != null && index >= totalPages!) ||
        _loadedPages.contains(index)) {
      return;
    }

    _markAsUsed(index);
    notifyListeners();
  }

  void preloadAdjacentPages([int range = 1]) {
    if (totalPages == null) {
      debugPrint('Total pages are required to preload adjacent pages.');
      return;
    }

    bool changed = false;

    for (int i = 1; i <= range; i++) {
      final nextIndex = _currentIndex + i;
      final prevIndex = _currentIndex - i;

      if (nextIndex < totalPages! && !_loadedPages.contains(nextIndex)) {
        _markAsUsed(nextIndex);
        changed = true;
      }

      if (prevIndex >= 0 && !_loadedPages.contains(prevIndex)) {
        _markAsUsed(prevIndex);
        changed = true;
      }
    }

    if (changed) notifyListeners();
  }

  @override
  void dispose() {
    _loadedPages.clear();
    if (isListenMemoryPressure) {
      WidgetsBinding.instance.removeObserver(this);
    }
    super.dispose();
  }
}
