import 'dart:async';

import '../../data_types/either.dart';

/// Adds [left] and [right] helpers to any value.
extension ToEitherObjectExtension<T> on T {
  /// Returns a `Left` containing this value.
  ///
  /// Shorthand for [Either.left].
  ///
  /// Example:
  /// ```dart
  /// Either<int, Never> e1 = 1.left<Never>();
  /// Either<int, String> e2 = 1.left<String>();
  /// ```
  // ignore: use_to_and_as_if_applicable
  Either<T, R> left<R>() => Either<T, R>.left(this);

  /// Returns a `Right` containing this value.
  ///
  /// Shorthand for [Either.right].
  ///
  /// Example:
  /// ```dart
  /// Either<Never, int> e1 = 1.right<Never>();
  /// Either<String, int> e2 = 1.right<String>();
  /// ```
  // ignore: use_to_and_as_if_applicable
  Either<L, T> right<L>() => Either<L, T>.right(this);
}

/// Converts [Either] values into [Future]s.
extension AsFutureEitherExtension<L extends Object, R> on Either<L, R> {
  /// Convert this [Either] to a [Future].
  ///
  /// If this is `Right`, the returned future completes with that value.
  /// If this is `Left`, the returned future completes with that value as error.
  ///
  /// Example:
  /// ```dart
  /// final value = await Either<String, int>.right(10).toFuture(); // 10
  /// ```
  Future<R> toFuture() => fold(Future.error, Future.value);
}

/// Async combinators for [Future] values that resolve to [Either].
///
/// These methods let you work with `Future<Either<L, R>>` without repeatedly
/// writing nested `then(... fold(...))` chains.
extension FutureEither<L, R> on Future<Either<L, R>> {
  /// Resolves to `true` when the underlying [Either] is `Left`.
  Future<bool> get isLeft => then((either) => either.isLeft);

  /// Resolves to `true` when the underlying [Either] is `Right`.
  Future<bool> get isRight => then((either) => either.isRight);

  /// Maps both sides of the resolved [Either].
  ///
  /// Equivalent to calling `either.either(fnL, fnR)` after awaiting.
  Future<Either<TL, TR>> either<TL, TR>(
    TL Function(L left) fnL,
    TR Function(R right) fnR,
  ) => then((either) => either.either(fnL, fnR));

  /// Maps only the right value, keeping the left type unchanged.
  Future<Either<L, TR>> mapRight<TR>(FutureOr<TR> Function(R right) fnR) =>
      then((either) => either.mapAsync(fnR));

  /// Maps only the left value, keeping the right type unchanged.
  Future<Either<TL, R>> mapLeft<TL>(FutureOr<TL> Function(L left) fnL) =>
      then((either) => either.mapLeftAsync(fnL));

  /// Flat-maps the right value into another [Either] asynchronously.
  Future<Either<L, TR>> thenRight<TR>(
    FutureOr<Either<L, TR>> Function(R right) fnR,
  ) => then((either) => either.thenAsync(fnR));

  /// Flat-maps the left value into another [Either] asynchronously.
  Future<Either<TL, R>> thenLeft<TL>(
    FutureOr<Either<TL, R>> Function(L left) fnL,
  ) => then((either) => either.thenLeftAsync(fnL));

  /// Folds the resolved [Either] into a single value.
  ///
  /// Example:
  /// ```dart
  /// final message = await Future.value(Either<String, int>.right(7)).fold(
  ///   (left) => 'error: $left',
  ///   (right) => 'ok: $right',
  /// );
  /// ```
  Future<T> fold<T>(
    FutureOr<T> Function(L left) fnL,
    FutureOr<T> Function(R right) fnR,
  ) {
    return then((either) => either.fold(fnL, fnR));
  }

  /// Swaps the left and right side of the resolved [Either].
  Future<Either<R, L>> swap() => fold<Either<R, L>>(Right.new, Left.new);
}
