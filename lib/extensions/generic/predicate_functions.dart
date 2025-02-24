/// Provides utility functions for composing and modifying boolean predicates
/// that take no parameters.
///
/// This extension adds logical operations such as `negate`, `and`, `or`, and `xor`
/// for functions that return a boolean value.
///
/// ## Example:
/// ```dart
/// bool alwaysTrue() => true;
/// final alwaysFalse = alwaysTrue.negate;
///
/// final isSunny = () => true;
/// final isWeekend = () => false;
/// final isGoodDay = isSunny.and(isWeekend);
///
/// print(isGoodDay()); // false
/// ```
extension BooleanPredicateExtensions on bool Function() {
  /// Returns a function that negates the result of this function.
  ///
  /// Example:
  /// ```dart
  /// bool alwaysTrue() => true;
  /// final alwaysFalse = alwaysTrue.negate;
  ///
  /// print(alwaysFalse()); // false
  /// ```
  bool get negate => !this();

  /// Returns a function that performs a logical AND (`&&`) operation between
  /// this function and the given [predicate].
  ///
  /// Example:
  /// ```dart
  /// final isSunny = () => true;
  /// final isWeekend = () => false;
  /// final isGoodDay = isSunny.and(isWeekend);
  ///
  /// print(isGoodDay()); // false
  /// ```
  bool Function() and(bool Function() predicate) => () => this() && predicate();

  /// Returns a function that performs a logical OR (`||`) operation between
  /// this function and the given [predicate].
  ///
  /// Example:
  /// ```dart
  /// final isSunny = () => true;
  /// final isWeekend = () => false;
  /// final isGoodDay = isSunny.or(isWeekend);
  ///
  /// print(isGoodDay()); // true
  /// ```
  bool Function() or(bool Function() predicate) => () => this() || predicate();

  /// Returns a function that performs a logical XOR (`^`) operation between
  /// this function and the given [predicate].
  ///
  /// Example:
  /// ```dart
  /// final isSunny = () => true;
  /// final isWeekend = () => true;
  /// final isGoodDay = isSunny.xor(isWeekend);
  ///
  /// print(isGoodDay()); // false
  /// ```
  bool Function() xor(bool Function() predicate) => () {
        final thisPredicate = this();
        final otherPredicate = predicate();
        return thisPredicate ^ otherPredicate;
      };
}

/// Provides utility functions for composing and modifying boolean predicates
/// that take a **single parameter**.
///
/// This extension allows operations like `negate`, `and`, `or`, and `xor`
/// for functions that take a parameter and return a boolean.
///
/// ## Example:
/// ```dart
/// bool isEven(int n) => n % 2 == 0;
/// final isOdd = isEven.negate;
///
/// final isPositive = (int n) => n > 0;
/// final isPositiveEven = isEven.and(isPositive);
///
/// print(isOdd(3)); // true
/// print(isPositiveEven(4)); // true
/// print(isPositiveEven(-4)); // false
/// ```
extension UnaryBooleanPredicateExtensions<P> on bool Function(P) {
  /// Returns a function that negates the result of this function.
  ///
  /// Example:
  /// ```dart
  /// bool isEven(int n) => n % 2 == 0;
  /// final isOdd = isEven.negate;
  ///
  /// print(isOdd(3)); // true
  /// ```
  bool Function(P) get negate => (p) => !this(p);

  /// Returns a function that performs a logical AND (`&&`) operation between
  /// this function and the given [predicate].
  ///
  /// Example:
  /// ```dart
  /// final isEven = (int n) => n % 2 == 0;
  /// final isPositive = (int n) => n > 0;
  /// final isPositiveEven = isEven.and(isPositive);
  ///
  /// print(isPositiveEven(4));  // true
  /// print(isPositiveEven(-4)); // false
  /// ```
  bool Function(P) and(bool Function(P p) predicate) =>
      (p) => this(p) && predicate(p);

  /// Returns a function that performs a logical OR (`||`) operation between
  /// this function and the given [predicate].
  ///
  /// Example:
  /// ```dart
  /// final isEven = (int n) => n % 2 == 0;
  /// final isNegative = (int n) => n < 0;
  /// final isEvenOrNegative = isEven.or(isNegative);
  ///
  /// print(isEvenOrNegative(4));  // true
  /// print(isEvenOrNegative(-3)); // true
  /// print(isEvenOrNegative(3));  // false
  /// ```
  bool Function(P) or(bool Function(P) predicate) =>
      (p) => this(p) || predicate(p);

  /// Returns a function that performs a logical XOR (`^`) operation between
  /// this function and the given [predicate].
  ///
  /// Example:
  /// ```dart
  /// final isEven = (int n) => n % 2 == 0;
  /// final isNegative = (int n) => n < 0;
  /// final isOddOrNegative = isEven.xor(isNegative);
  ///
  /// print(isOddOrNegative(4));  // false
  /// print(isOddOrNegative(-3)); // true
  /// print(isOddOrNegative(3));  // true
  /// ```
  bool Function(P) xor(bool Function(P) predicate) =>
      (p) => this(p) ^ predicate(p);

  /// Applies a mapping function [map] to transform an input of type `A`
  /// into a value of type `P`, then applies this function.
  ///
  /// This is useful when you want to reuse an existing predicate on a different type.
  ///
  /// Example:
  /// ```dart
  /// bool isEven(int n) => n % 2 == 0;
  /// final isEvenLength = isEven.contramap<String>((a) => a.length);
  ///
  /// print(isEvenLength("hello"));  // false
  /// print(isEvenLength("world!")); // true
  /// ```
  bool Function(A) contramap<A>(P Function(A a) map) => (a) => this(map(a));
}
