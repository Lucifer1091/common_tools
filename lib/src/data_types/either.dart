import 'dart:async';

import '../extensions/generic/either.dart';

/// Deferred value factory.
typedef Lazy<T> = T Function();

/// Map [error] and [stackTrace] to a [T] value.
typedef ErrorMapper<T> = T Function(Object error, StackTrace stackTrace);

T _identity<T>(T t) => t;

T Function(Object?) _const<T>(T t) =>
    (_) => t;

/// Returns a `Right(r)`.
///
/// Shortcut for `Either.of(r)`.
Either<L, R> right<L, R>(R r) => Right<L, R>(r);

/// Returns a `Left(l)`.
///
/// Shortcut for `Either.left(l)`.
Either<L, R> left<L, R>(L l) => Left<L, R>(l);

/// Represents a value of one of two possible types.
/// Instances of [Either] are either an instance of [Left] or [Right].
///
/// By convention:
/// - [Left] is used for failures/errors.
/// - [Right] is used for successes/values.

sealed class Either<L, R> {
  const Either();

  /// Returns a `Right(r)`.
  ///
  /// Same as `Either.right(r)`.
  factory Either.of(R r) => Right(r);

  /// Create a [Left].
  const factory Either.left(L left) = Left;

  /// Create a [Right].
  const factory Either.right(R right) = Right;

  /// Evaluates [block] and wraps the result in a [Right].
  ///
  /// If [block] throws, [error] is called and its value is wrapped in a [Left].
  ///
  /// Example:
  /// ```dart
  /// final a = Either<Object, int>.catchError(
  ///   (e, s) => e,
  ///   () => throw Exception('boom'),
  /// ); // Left(Exception('boom'))
  ///
  /// final b = Either<Object, String>.catchError(
  ///   (e, s) => e,
  ///   () => 'ok',
  /// ); // Right('ok')
  /// ```
  factory Either.catchError(ErrorMapper<L> error, R Function() block) {
    try {
      return Either.right(block());
    } catch (e, s) {
      return Either.left(error(e, s));
    }
  }

  /// If calling [predicate] with [r] returns `true`, returns `Right(r)`.
  /// Otherwise returns [Left] containing the result of [onFalse].
  ///
  /// Example:
  /// ```dart
  /// final a = Either<String, int>.fromPredicate(10, (v) => v > 0, (_) => 'bad');
  /// final b = Either<String, int>.fromPredicate(-1, (v) => v > 0, (_) => 'bad');
  /// // a = Right(10), b = Left('bad')
  /// ```
  factory Either.fromPredicate(
    R r,
    bool Function(R r) predicate,
    L Function(R r) onFalse,
  ) => predicate(r) ? Either.of(r) : Either.left(onFalse(r));

  /// Returns a [Right] if [value] is not `null`,
  /// otherwise returns a [Left] created by [onNull].
  ///
  /// Example:
  /// ```dart
  /// final a = Either.fromNullable<String, int>(
  ///   null,
  ///   onNull: () => 'value is null',
  /// ); // Left('value is null')
  ///
  /// final b = Either.fromNullable<String, int>(
  ///   42,
  ///   onNull: () => 'value is null',
  /// ); // Right(42)
  /// ```
  static Either<L, R> fromNullable<L, R extends Object>(
    R? value, {
    required L Function() onNull,
  }) => value == null ? Either.left(onNull()) : Either.right(value);

  /// Constructs a new [Either] from a function that might throw [Err].
  static Either<L, R> tryCatch<L, R, Err extends Object>(
    L Function(Err err) onError,
    R Function() fnR,
  ) {
    try {
      return Right(fnR());
    } on Err catch (e) {
      return Left(onError(e));
    }
  }

  /// Constructs a new [Either] from a function that might throw [Err].
  ///
  /// Simplified version of [Either.tryCatch] where [Err] itself becomes [Left].
  ///
  /// ```dart
  /// final parsed = Either.tryExcept<FormatException, int>(() => int.parse('x'));
  /// // Left(FormatException(...))
  /// ```
  static Either<Err, R> tryExcept<Err extends Object, R>(R Function() fnR) {
    try {
      return Right(fnR());
    } on Err catch (e) {
      return Left(e);
    }
  }

  /// Returns [Right] with [rightValue] when [test] is `true`,
  /// otherwise [Left] with [leftValue].
  static Either<L, R> condition<L, R>(bool test, L leftValue, R rightValue) =>
      test ? Right(rightValue) : Left(leftValue);

  /// Lazy version of [condition].
  ///
  /// Only the selected closure is evaluated.
  static Either<L, R> conditionLazy<L, R>(
    bool test,
    Lazy<L> leftValue,
    Lazy<R> rightValue,
  ) => test ? Right(rightValue()) : Left(leftValue());

  /// Returns `true` when this value is [Left].
  bool get isLeft => this is Left<L, R>;

  /// Returns `true` when this value is [Right].
  bool get isRight => this is Right<L, R>;

  /// Returns the [Left] value.
  ///
  /// Throws [Exception] when this is a [Right].
  L get left => fold<L>(
    (value) => value,
    (right) =>
        throw Exception('Illegal use. You should check isLeft before calling'),
  );

  /// Returns the [Right] value.
  ///
  /// Throws [Exception] when this is a [Left].
  R get right => fold<R>(
    (left) =>
        throw Exception('Illegal use. You should check isRight before calling'),
    (value) => value,
  );

  /// Maps both sides into a new [Either].
  Either<TL, TR> either<TL, TR>(
    TL Function(L left) fnL,
    TR Function(R right) fnR,
  );

  /// Flat-maps [Right] into another [Either].
  Either<L, TR> then<TR>(Either<L, TR> Function(R right) fnR);

  /// Async flat-map of [Right] into another [Either].
  Future<Either<L, TR>> thenAsync<TR>(
    FutureOr<Either<L, TR>> Function(R right) fnR,
  );

  /// Flat-maps [Left] into another [Either].
  Either<TL, R> thenLeft<TL>(Either<TL, R> Function(L left) fnL);

  /// Async flat-map of [Left] into another [Either].
  Future<Either<TL, R>> thenLeftAsync<TL>(
    FutureOr<Either<TL, R>> Function(L left) fnL,
  );

  /// Maps [Right] value.
  Either<L, TR> map<TR>(TR Function(R right) fnR);

  /// Maps [Left] value.
  Either<TL, R> mapLeft<TL>(TL Function(L left) fnL);

  /// Async map of [Right] value.
  Future<Either<L, TR>> mapAsync<TR>(FutureOr<TR> Function(R right) fnR);

  /// Async map of [Left] value.
  Future<Either<TL, R>> mapLeftAsync<TL>(FutureOr<TL> Function(L left) fnL);

  /// Folds [Left] and [Right] into a value of one type.
  T fold<T>(T Function(L left) fnL, T Function(R right) fnR);

  /// Swaps [Left] and [Right].
  Either<R, L> swap() => fold(Right.new, Left.new);

  /// Returns `false` for [Left], otherwise evaluates [predicate] for [Right].
  ///
  /// Example:
  /// ```dart
  /// Right<int, int>(12).exists((v) => v > 10); // Result: true
  /// Right<int, int>(7).exists((v) => v > 10);  // Result: false
  ///
  /// Left<int, int>(12).exists((v) => v > 10);  // Result: false
  /// Left<int, int>(12).exists((v) => v < 10);  // Result: false
  /// ```
  bool exists(bool Function(R value) predicate) =>
      fold(_const(false), predicate);

  /// Returns `true` for [Left], otherwise evaluates [predicate] for [Right].
  ///
  /// Example:
  /// ```dart
  /// Right<int, int>(12).all((v) => v > 10); // Result: true
  /// Right<int, int>(7).all((v) => v > 10);  // Result: false
  ///
  /// Left<int, int>(12).all((v) => v > 10);  // Result: true
  /// Left<int, int>(12).all((v) => v < 10);  // Result: true
  /// ```
  bool all(bool Function(R value) predicate) => fold(_const(true), predicate);

  /// Returns the value from this [Right] or the given argument if this is a [Left].
  ///
  /// Example:
  /// ```dart
  /// Right<int, int>(12).getOrElse(() => 17); // Result: 12
  /// Left<int, int>(12).getOrElse(() => 17);  // Result: 17
  /// ```
  R getOrElse(R Function() defaultValue) =>
      fold((_) => defaultValue(), _identity);

  /// Returns this value if it is [Right], otherwise the result of [orElse].
  ///
  /// Used to provide an alternative [Either] in case the current one is [Left].
  Either<L, R> alt(covariant Either<L, R> Function() orElse);

  /// Change the value of [Either] from type `R` to type `Z` based on the
  /// value of `Either<L, R>` using function `f`.
  Either<L, Z> extend<Z>(Z Function(Either<L, R> t) f);

  /// If this [Either] is [Left], return the result of `onLeft`.
  ///
  /// Used to recover from errors, so that when this value is [Left] you
  /// try another function that returns an [Either].
  Either<L1, R> orElse<L1>(Either<L1, R> Function(L l) onLeft);

  /// Returns the [Right]'s value if it exists, otherwise `null`.
  ///
  /// Example:
  /// ```dart
  /// Right<int, int>(12).orNull(); // Result: 12
  /// Left<int, int>(12).orNull();  // Result: null
  /// ```
  R? orNull() => fold(_const(null), _identity);

  /// Returns the value from this [Right]
  /// or allows clients to transform the value of [Left] to the final result.
  ///
  /// Example:
  /// ```dart
  /// Right<int, int>(12).getOrHandle((v) => 17);   // Result: 12
  /// Left<int, int>(12).getOrHandle((v) => v + 5); // Result: 17
  /// ```
  R getOrHandle(R Function(L value) defaultValue) =>
      fold(defaultValue, _identity);

  /// Applies [ifLeft] if this is a [Left] or [ifRight] if this is a [Right].
  ///
  /// This is quite similar to [fold], but with [fold], arguments will
  /// be called with [Right.value] or [Left.value], while the arguments of [when]
  /// will be called with [Right] or [Left] itself.
  ///
  /// [ifLeft] is the function to apply if this is a [Left].
  /// [ifRight] is the function to apply if this is a [Right].
  /// Returns the results of applying the function.
  ///
  /// Example:
  /// ```dart
  /// final Either<String, int> result = Right(1);
  ///
  /// // Prints operation succeeded with 1
  /// result.when(
  ///   (left) => print('operation failed with ${left.value}') ,
  ///   (right) => print('operation succeeded with ${right.value}'),
  /// );
  /// ```
  C when<C>(
    C Function(Left<L, R> left) ifLeft,
    C Function(Right<L, R> right) ifRight,
  ) {
    if (isLeft) {
      return ifLeft(this as Left<L, R>);
    } else {
      assert(isRight, 'This is a left.');
      return ifRight(this as Right<L, R>);
    }
  }

  /// Handles any error by mapping it to another [Either] value.
  ///
  /// Applies the given function [f] if this is a [Left], otherwise returns this if this is a [Right].
  /// This is like `thenLeft` for the exception.
  ///
  /// Example:
  /// ```dart
  /// Right<int, int>(12).handleErrorWith((v) => (v + 1).right<String>());   // Right(12)
  /// Right<int, int>(12).handleErrorWith((v) => (v + 1).toString().left()); // Right(12)
  /// Left<int, int>(12).handleErrorWith((v) => (v + 1).right<String>());    // Right(13)
  /// Left<int, int>(12).handleErrorWith((v) => (v + 1).toString().left());  // Left('13')
  /// ```
  Either<C, R> handleErrorWith<C>(Either<C, R> Function(L value) f) =>
      fold(f, (v) => v.right<C>());

  /// Handles any error by mapping [Left] into a recovered [Right] value.
  ///
  /// Applies [f] if this is [Left] and wraps the result in [Right],
  /// otherwise returns this value unchanged when it is [Right].
  Either<L, R> handleError(R Function(L value) f) =>
      fold((v) => f(v).right(), (v) => v.right());

  /// Redeem an [Either] to an [Either] by resolving the error **or** mapping the value [R] to [C].
  ///
  /// [redeem] is derived from [map] and [handleError].
  /// This is functionally equivalent to `map(rightOperation).handleError(leftOperation)`.
  Either<L, C> redeem<C>({
    required C Function(L value) leftOperation,
    required C Function(R value) rightOperation,
  }) => fold((v) => leftOperation(v).right(), (v) => rightOperation(v).right());

  /// Redeem an [Either] to an [Either] by resolving the error
  /// **or** mapping the value [R] to [C] **with** an [Either].
  ///
  /// [redeemWith] is derived from [then] and [handleErrorWith].
  /// This is functionally equivalent to `then(rightOperation).handleErrorWith(leftOperation)`.
  Either<C, D> redeemWith<C, D>({
    required Either<C, D> Function(L value) leftOperation,
    required Either<C, D> Function(R value) rightOperation,
  }) => fold(leftOperation, rightOperation);

  @override
  bool operator ==(Object other) {
    return fold(
      (left) => other is Left && left == other.value,
      (right) => other is Right && right == other.value,
    );
  }

  @override
  int get hashCode => fold((left) => left.hashCode, (right) => right.hashCode);
}

/// The failure branch of [Either].
class Left<L, R> extends Either<L, R> {
  const Left(this.value);
  final L value;

  @override
  Either<TL, TR> either<TL, TR>(
    TL Function(L left) fnL,
    TR Function(R right) fnR,
  ) {
    return Left<TL, TR>(fnL(value));
  }

  @override
  Either<L, TR> then<TR>(Either<L, TR> Function(R right) fnR) {
    return Left<L, TR>(value);
  }

  @override
  Future<Either<L, TR>> thenAsync<TR>(
    FutureOr<Either<L, TR>> Function(R right) fnR,
  ) {
    return Future.value(Left<L, TR>(value));
  }

  @override
  Either<TL, R> thenLeft<TL>(Either<TL, R> Function(L left) fnL) {
    return fnL(value);
  }

  @override
  Future<Either<TL, R>> thenLeftAsync<TL>(
    FutureOr<Either<TL, R>> Function(L left) fnL,
  ) {
    return Future.value(fnL(value));
  }

  @override
  Either<L, TR> map<TR>(TR Function(R right) fnR) {
    return Left<L, TR>(value);
  }

  @override
  Either<TL, R> mapLeft<TL>(TL Function(L left) fnL) {
    return Left<TL, R>(fnL(value));
  }

  @override
  Future<Either<L, TR>> mapAsync<TR>(FutureOr<TR> Function(R right) fnR) {
    return Future.value(Left<L, TR>(value));
  }

  @override
  Future<Either<TL, R>> mapLeftAsync<TL>(FutureOr<TL> Function(L left) fnL) {
    return Future.value(fnL(value)).then(Left<TL, R>.new);
  }

  @override
  T fold<T>(T Function(L left) fnL, T Function(R right) fnR) {
    return fnL(value);
  }

  @override
  Either<L, R> alt(covariant Either<L, R> Function() orElse) => orElse();

  @override
  Either<L, Z> extend<Z>(Z Function(Either<L, R> t) f) => Either.left(value);

  @override
  Either<L1, R> orElse<L1>(Either<L1, R> Function(L l) onLeft) => onLeft(value);
}

/// The success branch of [Either].
class Right<L, R> extends Either<L, R> {
  const Right(this.value);
  final R value;

  @override
  Either<TL, TR> either<TL, TR>(
    TL Function(L left) fnL,
    TR Function(R right) fnR,
  ) {
    return Right<TL, TR>(fnR(value));
  }

  @override
  Either<L, TR> then<TR>(Either<L, TR> Function(R right) fnR) {
    return fnR(value);
  }

  @override
  Future<Either<L, TR>> thenAsync<TR>(
    FutureOr<Either<L, TR>> Function(R right) fnR,
  ) {
    return Future.value(fnR(value));
  }

  @override
  Either<TL, R> thenLeft<TL>(Either<TL, R> Function(L left) fnL) {
    return Right<TL, R>(value);
  }

  @override
  Future<Either<TL, R>> thenLeftAsync<TL>(
    FutureOr<Either<TL, R>> Function(L left) fnL,
  ) {
    return Future.value(Right<TL, R>(value));
  }

  @override
  Either<L, TR> map<TR>(TR Function(R right) fnR) {
    return Right<L, TR>(fnR(value));
  }

  @override
  Either<TL, R> mapLeft<TL>(TL Function(L left) fnL) {
    return Right<TL, R>(value);
  }

  @override
  Future<Either<L, TR>> mapAsync<TR>(FutureOr<TR> Function(R right) fnR) {
    return Future.value(fnR(value)).then(Right<L, TR>.new);
  }

  @override
  Future<Either<TL, R>> mapLeftAsync<TL>(FutureOr<TL> Function(L left) fnL) {
    return Future.value(Right<TL, R>(value));
  }

  @override
  T fold<T>(T Function(L left) fnL, T Function(R right) fnR) {
    return fnR(value);
  }

  @override
  Either<L, R> alt(covariant Either<L, R> Function() orElse) => this;

  @override
  Either<L, Z> extend<Z>(Z Function(Either<L, R> t) f) => Either.of(f(this));

  @override
  Either<L1, R> orElse<L1>(Either<L1, R> Function(L l) onLeft) =>
      Either.of(value);
}
