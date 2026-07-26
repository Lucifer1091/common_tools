import 'dart:collection';

/// A lightweight LIFO stack backed by a growable [List].
///
/// This is the default stack type in the package and does not enforce a
/// capacity limit.
///
/// Both [pop] and [peek] are nullable and return `null` when the stack is
/// empty.
///
/// Example:
/// ```dart
/// final stack = UnboundedStack<int>([1, 2]);
/// stack.push(3);
///
/// print(stack.peek); // 3
/// print(stack.pop()); // 3
/// print(stack.toList()); // [1, 2]
/// ```
class UnboundedStack<T> {
  /// Creates a stack optionally seeded with [values], from bottom to top.
  UnboundedStack([Iterable<T> values = const []]) : _items = List<T>.of(values);

  final List<T> _items;

  /// Pushes [value] onto the top of the stack.
  void push(T value) => _items.add(value);

  /// Pushes every element from [values] preserving iteration order.
  ///
  /// The last element in [values] becomes the new top of the stack.
  void pushAll(Iterable<T> values) => _items.addAll(values);

  /// Clears the stack and then pushes [value].
  void clearAndPush(T value) {
    _items
      ..clear()
      ..add(value);
  }

  /// Removes and returns the top element, or `null` when the stack is empty.
  T? pop() => _items.isEmpty ? null : _items.removeLast();

  /// Returns the top element without removing it, or `null` when empty.
  T? get peek => _items.isEmpty ? null : _items.last;

  /// Returns a snapshot copy from bottom to top.
  ///
  /// The returned list is growable when [growable] is `true`.
  List<T> toList({bool growable = true}) =>
      List<T>.of(_items, growable: growable);

  /// Returns whether [value] exists in the stack.
  bool contains(T value) => _items.contains(value);

  /// Removes all elements.
  void clear() => _items.clear();

  /// Read-only iteration from bottom to top.
  Iterable<T> get iterate => UnmodifiableListView<T>(_items);

  /// Read-only iteration from top to bottom.
  Iterable<T> get reversed => _items.reversed;

  /// Current number of elements in the stack.
  int get length => _items.length;

  /// Whether the stack has no elements.
  bool get isEmpty => _items.isEmpty;

  /// Whether the stack has at least one element.
  bool get isNotEmpty => _items.isNotEmpty;

  @override
  String toString() => _items.toString();
}

/// A LIFO stack with a hard maximum capacity.
///
/// [push] and [pushAll] throw [StackOperationException] when an operation
/// would exceed [maxSize]. [tryPush] returns `false` instead of throwing.
///
/// Example:
/// ```dart
/// final stack = BoundedStack<String>(maxSize: 2);
/// stack.push('a');
/// stack.push('b');
///
/// final ok = stack.tryPush('c'); // false, already full
/// print(ok);
/// print(stack.length); // 2
/// ```
class BoundedStack<T> {
  /// Creates a bounded stack with required [maxSize].
  ///
  /// The [maxSize] must be greater than `1`.
  ///
  /// Throws [ArgumentError] if [maxSize] is too small.
  /// Throws [StackOperationException] if initial [values] exceed [maxSize].
  BoundedStack({required this.maxSize, Iterable<T> values = const []})
    : _stack = UnboundedStack<T>(values) {
    if (maxSize < 2) {
      throw ArgumentError.value(
        maxSize,
        'maxSize',
        'maxSize must be greater than 1.',
      );
    }

    if (_stack.length > maxSize) {
      throw StackOperationException(
        'Initial values exceed maxSize ($maxSize).',
      );
    }
  }

  /// Maximum number of elements this stack can hold.
  final int maxSize;

  final UnboundedStack<T> _stack;

  /// Current number of elements in the stack.
  int get length => _stack.length;

  /// Whether the stack has no elements.
  bool get isEmpty => _stack.isEmpty;

  /// Whether the stack has at least one element.
  bool get isNotEmpty => _stack.isNotEmpty;

  /// Whether the stack reached [maxSize].
  bool get isFull => length >= maxSize;

  /// Remaining number of elements that can still be pushed.
  int get remaining => maxSize - length;

  /// Pushes [value] onto the top of the stack.
  ///
  /// Throws [StackOperationException] if the stack is full.
  void push(T value) {
    if (isFull) {
      throw StackOperationException(
        'Cannot push: stack reached maxSize ($maxSize).',
      );
    }

    _stack.push(value);
  }

  /// Attempts to push [value].
  ///
  /// Returns `false` if the stack is full.
  bool tryPush(T value) {
    if (isFull) return false;

    _stack.push(value);
    return true;
  }

  /// Pushes all [values] as one atomic operation.
  ///
  /// Throws [StackOperationException] when there is not enough capacity.
  void pushAll(Iterable<T> values) {
    final items = values.toList(growable: false);
    if (items.length > remaining) {
      throw StackOperationException(
        'Cannot push ${items.length} item(s): '
        'remaining capacity is $remaining.',
      );
    }

    _stack.pushAll(items);
  }

  /// Clears the stack and pushes [value].
  ///
  /// This operation always succeeds because the stack is empty before push.
  void clearAndPush(T value) {
    _stack
      ..clear()
      ..push(value);
  }

  /// Removes and returns the top element, or `null` when the stack is empty.
  T? pop() => _stack.pop();

  /// Returns the top element without removing it, or `null` when empty.
  T? get peek => _stack.peek;

  /// Returns whether [value] exists in the stack.
  bool contains(T value) => _stack.contains(value);

  /// Removes all elements.
  void clear() => _stack.clear();

  /// Read-only iteration from bottom to top.
  Iterable<T> get iterate => _stack.iterate;

  /// Read-only iteration from top to bottom.
  Iterable<T> get reversed => _stack.reversed;

  /// Returns a snapshot copy from bottom to top.
  ///
  /// The returned list is growable when [growable] is `true`.
  List<T> toList({bool growable = true}) => _stack.toList(growable: growable);

  @override
  String toString() => _stack.toString();
}

/// A domain exception used by stack operations.
class StackOperationException implements Exception {
  /// Creates a stack operation exception with a human-readable [message].
  StackOperationException(this.message);

  /// The error message describing the failed stack operation.
  final String message;

  @override
  String toString() => 'StackOperationException: $message';
}
