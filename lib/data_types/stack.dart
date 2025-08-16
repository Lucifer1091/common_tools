import 'dart:collection';
import 'dart:core' as core;
import 'dart:core';

class StackCollection<T> {
  final _list = <T>[];

  void push(T value) => _list.add(value);

  void clearAndPush(T value) =>
      _list
        ..clear()
        ..add(value);

  void clear() => _list.clear();

  T? pop() => isEmpty ? null : _list.removeLast();

  T? get peek => isEmpty ? null : _list.last;

  Iterable<T> get iterate => _list;

  Iterable<T> get reversed => _list.reversed;

  bool get isEmpty => _list.isEmpty;
  int get length => _list.length;
  bool get isNotEmpty => _list.isNotEmpty;

  @override
  String toString() => _list.toString();
}

class IllegalOperationException implements Exception {
  IllegalOperationException(this.cause);
  final String cause;

  String errMsg() => cause;
}

// class Stack<T> {
//   /// Default constructor sets the maximum stack size to 'no limit.'
//   Stack() {
//     _sizeMax = noLimit;
//   }

//   /// Constructor in which you can specify maximum number of entries.
//   /// This maximum is a limit that is enforced as entries are pushed on to the stack
//   /// to prevent stack growth beyond a maximum size. There is no pre-allocation of
//   /// slots for entries at any time in this library.
//   Stack.sized(int sizeMax) {
//     if (sizeMax < 2) {
//       throw IllegalOperationException(
//         'Error: stack size must be 2 entries or more ',
//       );
//     } else {
//       _sizeMax = sizeMax;
//     }
//   }
//   final ListQueue<T> _list = ListQueue();

//   final int noLimit = -1;

//   /// the maximum number of entries allowed on the stack. -1 = no limit.
//   int _sizeMax = 0;

//   /// Returns a list of T elements contained in the Stack
//   List<T> toList() => _list.toList();

//   /// check if the stack is empty.
//   bool get isEmpty => _list.isEmpty;

//   /// check if the stack is not empty.
//   bool get isNotEmpty => _list.isNotEmpty;

//   /// push element in top of the stack.
//   void push(T e) {
//     if (_sizeMax == noLimit || _list.length < _sizeMax) {
//       _list.addLast(e);
//     } else {
//       throw IllegalOperationException(
//         'Error: cannot add element. Stack already at maximum size of: $_sizeMax elements',
//       );
//     }
//   }

//   /// get the top of the stack and delete it.
//   T pop() {
//     if (isEmpty) {
//       throw IllegalOperationException(
//         "Can't use pop with empty stack\n consider "
//         'checking for size or isEmpty before calling pop',
//       );
//     }
//     T res = _list.last;
//     _list.removeLast();
//     return res;
//   }

//   /// get the top of the stack without deleting it.
//   T top() {
//     if (isEmpty) {
//       throw IllegalOperationException(
//         "Can't use top with empty stack\n consider "
//         'checking for size or isEmpty before calling top',
//       );
//     }
//     return _list.last;
//   }

//   /// get the size of the stack.
//   int size() => _list.length;

//   /// get the length of the stack.
//   int get length => size();

//   /// returns true if element is found in the stack
//   bool contains(T x) => _list.contains(x);

//   /// removes all elements from the stack
//   void clear() {
//     while (isNotEmpty) {
//       _list.removeLast();
//     }
//   }

//   /// print stack
//   void print() {
//     for (final item in List<T>.from(_list).reversed) {
//       core.print(item);
//     }
//   }
// }

class StackX<T> {
  final _list = ListQueue<T>();

  bool get isEmpty => _list.isEmpty;

  bool get isNotEmpty => _list.isNotEmpty;

  void push(T element) => _list.addLast(element);

  T pop() {
    final T element = _list.last;
    _list.removeLast();
    return element;
  }

  T top() => _list.last;

  List<T> addAll(Iterable<T> elements) {
    _list.addAll(elements);
    return _list.toList();
  }
}
