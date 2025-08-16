import 'dart:collection';

import 'package:flutter/material.dart';

import '../layout/no_widget.dart';

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
  late final MyIndexedStackController _controller;
  late final AnimationController _animation;
  late bool _internal;

  @override
  void initState() {
    _internal = widget.controller == null;
    _controller =
        widget.controller ??
        MyIndexedStackController(
          initialIndex: widget.index ?? 0,
          totalPages: widget.children.length,
        );
    _animation = AnimationController(vsync: this, duration: widget.duration);
    _animation.forward();
    super.initState();
  }

  @override
  void didUpdateWidget(MyIndexedStack oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If controller changed, update listener
    if (widget.controller != oldWidget.controller) {
      if (_internal) _controller.dispose();

      _internal = widget.controller == null;
      _controller =
          widget.controller ??
          MyIndexedStackController(
            initialIndex: widget.index ?? 0,
            totalPages: widget.children.length,
          );
    }

    // Animate if index changes
    if (widget.index != oldWidget.index && widget.animate) {
      _animation.forward(from: 0);
      if (widget.index != null) _controller.jumpTo(widget.index!);
    } else if (widget.index != oldWidget.index && widget.index != null) {
      _controller.jumpTo(widget.index!);
    }
  }

  List<Widget> get children {
    final currentIndex = widget.index ?? _controller.currentIndex;
    final loadedIndexes = _controller.loadedIndexes;
    final children = List<Widget>.filled(
      widget.children.length,
      const NoWidget(),
    );

    for (final i in loadedIndexes) {
      if (i >= 0 && i < widget.children.length) {
        children[i] = KeyedSubtree(
          key: ValueKey('lc$i'),
          child: TickerMode(
            enabled: i == currentIndex,
            child: widget.children[i],
          ),
        );
      }
    }

    return children;
  }

  @override
  Widget build(BuildContext context) {
    final stack = ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        // Safe Index Check
        final currentIndex = widget.index ?? _controller.currentIndex;
        final safeIndex =
            (currentIndex >= 0 && currentIndex < widget.children.length)
                ? currentIndex
                : 0;

        return IndexedStack(
          index: safeIndex,
          alignment: widget.alignment,
          clipBehavior: widget.clipBehavior,
          textDirection: widget.textDirection,
          sizing: widget.fit,
          children: children,
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

  final LinkedHashMap<int, bool> _loadedPages = LinkedHashMap<int, bool>();

  Set<int> get loadedIndexes => _loadedPages.keys.toSet();
  int get currentIndex => _currentIndex;
  bool get canGoBack => _currentIndex > 0;
  bool isLoaded(int index) => _loadedPages.containsKey(index);

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

    if (changed) notifyListeners();
  }

  void _markAsUsed(int index) {
    if (index < 0) return;

    _loadedPages.remove(index);
    _loadedPages[index] = true;

    if (_loadedPages.length > maxCachedPages) _enforceMaxSize();
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
        _enforceMaxSize();
        notifyListeners();
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
    notifyListeners();
  }

  void disposePage(int index) {
    if (index == _currentIndex || preloadIndexes.contains(index)) {
      return;
    }

    if (_loadedPages.remove(index) != null) notifyListeners();
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

    if (changed) notifyListeners();
  }

  void preloadPage(int index) {
    if (index < 0 ||
        (totalPages != null && index >= totalPages!) ||
        _loadedPages.containsKey(index)) {
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

      if (nextIndex < totalPages! && !_loadedPages.containsKey(nextIndex)) {
        _markAsUsed(nextIndex);
        changed = true;
      }

      if (prevIndex >= 0 && !_loadedPages.containsKey(prevIndex)) {
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
