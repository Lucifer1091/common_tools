import 'dart:async';

import '../extensions/generic/either.dart';

typedef Lazy<T> = T Function();

/// Map [error] and [stackTrace] to a [T] value.
typedef ErrorMapper<T> = T Function(Object error, StackTrace stackTrace);

T _identity<T>(T t) => t;

T Function(Object?) _const<T>(T t) => (_) => t;

/// Return a `Right(r)`.
///
/// Shortcut for `Either.of(r)`.
Either<L, R> right<L, R>(R r) => Right<L, R>(r);

/// Return a `Left(l)`.
///
/// Shortcut for `Either.left(l)`.
Either<L, R> left<L, R>(L l) => Left<L, R>(l);

/// Represents a value of one of two possible types.
/// Instances of [Either] are either an instance of [Left] or [Right].
///
/// [Left] is used for "failure".
/// [Right] is used for "success".

sealed class Either<L, R> {
  const Either();

  /// Return a `Right(r)`.
  ///
  /// Same as `Either.right(r)`.
  factory Either.of(R r) => Right(r);

  /// Create a [Left].
  const factory Either.left(L left) = Left;

  /// Create a [Right].
  const factory Either.right(R right) = Right;

  /// Evaluates the specified [block] and wrap the result in a [Right].
  ///
  /// If an error is thrown, calling [error] with that error and wrap the result in a [Left].
  ///
  /// ### Example
  /// ```dart
  /// Either<Object, int>.catchError((e, s) => e, () => throw Exception()); // Result: Left(Exception())
  /// Either<Object, String>.catchError((e, s) => e, () => 'hoc081098');    // Result: Right('hoc081098')
  /// ```
  factory Either.catchError(ErrorMapper<L> error, R Function() block) {
    try {
      return Either.right(block());
    } catch (e, s) {
      return Either.left(error(e, s));
    }
  }

  /// If calling `predicate` with `r` returns `true`, then return `Right(r)`.
  /// Otherwise return [Left] containing the result of `onFalse`.
  factory Either.fromPredicate(
    R r,
    bool Function(R r) predicate,
    L Function(R r) onFalse,
  ) => predicate(r) ? Either.of(r) : Either.left(onFalse(r));

  /// Returns a [Right] if [value] is not `null`,
  /// otherwise returns a [Left] created by [onNull].
  /// ### Example
  /// ```dart
  /// Either.fromNullable<String>(null);        // Result: Left(null)
  /// Either.fromNullable<String>('hoc081098'); // Result: Right('hoc081098')
  /// Either.fromNullable<String, int>(
  ///   null,
  ///   onNull: () => 'value is null',
  /// ); // Result: Left('value is null')
  /// ```
  static Either<L, R> fromNullable<L, R extends Object>(
    R? value, {
    required L Function() onNull,
  }) => value == null ? Either.left(onNull()) : Either.right(value);

  /// Constructs a new [Either] from a function that might throw
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

  /// Constructs a new [Either] from a function that might throw
  ///
  /// simplified version of [Either.tryCatch]
  ///
  /// ```dart
  /// final fileOrError = Either.tryExcept<FileError>(() => /* maybe throw */);
  /// ```
  static Either<Err, R> tryExcept<Err extends Object, R>(R Function() fnR) {
    try {
      return Right(fnR());
    } on Err catch (e) {
      return Left(e);
    }
  }

  /// If the condition is true then return [rightValue] in [Right] else [leftValue] in [Left]
  static Either<L, R> condition<L, R>(bool test, L leftValue, R rightValue) =>
      test ? Right(rightValue) : Left(leftValue);

  /// If the condition is true then return [rightValue] in [Right] else [leftValue] in [Left]
  static Either<L, R> conditionLazy<L, R>(
    bool test,
    Lazy<L> leftValue,
    Lazy<R> rightValue,
  ) => test ? Right(rightValue()) : Left(leftValue());

  /// Represents the left side of [Either] class which by convention is a "Failure".
  bool get isLeft => this is Left<L, R>;

  /// Represents the right side of [Either] class which by convention is a "Success"
  bool get isRight => this is Right<L, R>;

  /// Get [Left] value, may throw an exception when the value is [Right]
  L get left => fold<L>(
    (value) => value,
    (right) =>
        throw Exception('Illegal use. You should check isLeft before calling'),
  );

  /// Get [Right] value, may throw an exception when the value is [Left]
  R get right => fold<R>(
    (left) =>
        throw Exception('Illegal use. You should check isRight before calling'),
    (value) => value,
  );

  /// Transform values of [Left] and [Right]
  Either<TL, TR> either<TL, TR>(
    TL Function(L left) fnL,
    TR Function(R right) fnR,
  );

  /// Transform value of [Right] when transformation may be finished with an error
  Either<L, TR> then<TR>(Either<L, TR> Function(R right) fnR);

  /// Transform value of [Right] when transformation may be finished with an error
  Future<Either<L, TR>> thenAsync<TR>(
    FutureOr<Either<L, TR>> Function(R right) fnR,
  );

  /// Transform value of [Left] when transformation may be finished with an [Right]
  Either<TL, R> thenLeft<TL>(Either<TL, R> Function(L left) fnL);

  /// Transform value of [Left] when transformation may be finished with an [Right]
  Future<Either<TL, R>> thenLeftAsync<TL>(
    FutureOr<Either<TL, R>> Function(L left) fnL,
  );

  /// Transform value of [Right]
  Either<L, TR> map<TR>(TR Function(R right) fnR);

  /// Transform value of [Left]
  Either<TL, R> mapLeft<TL>(TL Function(L left) fnL);

  /// Transform value of [Right]
  Future<Either<L, TR>> mapAsync<TR>(FutureOr<TR> Function(R right) fnR);

  /// Transform value of [Left]
  Future<Either<TL, R>> mapLeftAsync<TL>(FutureOr<TL> Function(L left) fnL);

  /// Fold [Left] and [Right] into the value of one type
  T fold<T>(T Function(L left) fnL, T Function(R right) fnR);

  /// Swap [Left] and [Right]
  Either<R, L> swap() => fold(Right.new, Left.new);

  /// Returns `false` if [Left] or returns the result of the application of
  /// the given [predicate] to the [Right] value.
  ///
  /// ### Example
  /// ```dart
  /// Right<int, int>(12).exists((v) => v > 10); // Result: true
  /// Right<int, int>(7).exists((v) => v > 10);  // Result: false
  ///
  /// Left<int, int>(12).exists((v) => v > 10);  // Result: false
  /// Left<int, int>(12).exists((v) => v < 10);  // Result: false
  /// ```
  bool exists(bool Function(R value) predicate) =>
      fold(_const(false), predicate);

  /// Returns `true` if [Left] or returns the result of the application of
  /// the given predicate to the [Right] value.
  ///
  /// ### Example
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
  /// ### Example
  /// ```dart
  /// Right<int, int>(12).getOrElse(() => 17); // Result: 12
  /// Left<int, int>(12).getOrElse(() => 17);  // Result: 17
  /// ```
  R getOrElse(R Function() defaultValue) =>
      fold((_) => defaultValue(), _identity);

  /// Return the current [Either] if it is a [Right], otherwise return the result of `orElse`.
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
  /// ### Example
  /// ```dart
  /// Right<int, int>(12).orNull(); // Result: 12
  /// Left<int, int>(12).orNull();  // Result: null
  /// ```
  R? orNull() => fold(_const(null), _identity);

  /// Returns the value from this [Right]
  /// or allows clients to transform the value of [Left] to the final result.
  ///
  /// ### Example
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
  /// ### Example
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

  /// Handle any error, potentially recovering from it, by mapping it to an [Either] value.
  ///
  /// Applies the given function [f] if this is a [Left], otherwise returns this if this is a [Right].
  /// This is like `thenLeft` for the exception.
  ///
  /// ### Example
  /// ```dart
  /// Right<int, int>(12).handleErrorWith((v) => (v + 1).right<String>());   // Right(12)
  /// Right<int, int>(12).handleErrorWith((v) => (v + 1).toString().left()); // Right(12)
  /// Left<int, int>(12).handleErrorWith((v) => (v + 1).right<String>());    // Right(13)
  /// Left<int, int>(12).handleErrorWith((v) => (v + 1).toString().left());  // Left('13')
  /// ```
  Either<C, R> handleErrorWith<C>(Either<C, R> Function(L value) f) =>
      fold(f, (v) => v.right<C>());

  /// Handle any error, potentially recovering from it, by mapping it to an [Either] value.
  ///
  /// Applies the given function [f] if this is a [Left] and return the result wrapped in a [Right],
  /// otherwise returns this if this is a [Right].
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

/// Used for "failure"
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

/// Used for "success"
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
