// ignore_for_file: use_to_and_as_if_applicable, comment_references

import 'dart:async';

import '../data_types/either.dart';

/// Provide [left] and [right] extensions on any types.
extension ToEitherObjectExtension<T> on T {
  /// Return a [Left] that contains [this] value.
  /// This is a shorthand for [Either.left].
  ///
  /// ### Example
  /// ```dart
  /// Either<int, Never> e1 = 1.left<Never>();
  /// Either<int, String> e2 = 1.left<String>();
  /// ```
  Either<T, R> left<R>() => Either<T, R>.left(this);

  /// Return a [Right] that contains [this] value.
  /// This is a shorthand for [Either.right].
  ///
  /// ### Example
  /// ```dart
  /// Either<Never, int> e1 = 1.right<Never>();
  /// Either<String, int> e2 = 1.right<String>();
  /// ```
  Either<L, T> right<L>() => Either<L, T>.right(this);
}

/// Provide [toFuture] extension on [Either].
extension AsFutureEitherExtension<L extends Object, R> on Either<L, R> {
  /// Convert this [Either] to a [Future].
  /// If [this] is [Right], the Future will complete with [Right.value] as its value.
  /// Otherwise, the result Future will complete with [Left.value] as its error.
  Future<R> toFuture() => fold(Future.error, Future.value);
}

extension FutureEither<L, R> on Future<Either<L, R>> {
  /// Represents the left side of [Either] class which by convention is a "Failure".
  Future<bool> get isLeft => then((either) => either.isLeft);

  /// Represents the right side of [Either] class which by convention is a "Success"
  Future<bool> get isRight => then((either) => either.isRight);

  /// Transform values of [Left] and [Right]
  Future<Either<TL, TR>> either<TL, TR>(
    TL Function(L left) fnL,
    TR Function(R right) fnR,
  ) =>
      then((either) => either.either(fnL, fnR));

  /// Transform value of [Right]
  Future<Either<L, TR>> mapRight<TR>(FutureOr<TR> Function(R right) fnR) =>
      then((either) => either.mapAsync(fnR));

  /// Transform value of [Left]
  Future<Either<TL, R>> mapLeft<TL>(FutureOr<TL> Function(L left) fnL) =>
      then((either) => either.mapLeftAsync(fnL));

  /// Async transform value of [Right] when transformation may be finished with an error
  Future<Either<L, TR>> thenRight<TR>(
    FutureOr<Either<L, TR>> Function(R right) fnR,
  ) =>
      then((either) => either.thenAsync(fnR));

  /// Async transform value of [Left] when transformation may be finished with an [Right]
  Future<Either<TL, R>> thenLeft<TL>(
    FutureOr<Either<TL, R>> Function(L left) fnL,
  ) =>
      then((either) => either.thenLeftAsync(fnL));

  /// Fold [Left] and [Right] into the value of one type
  Future<T> fold<T>(
    FutureOr<T> Function(L left) fnL,
    FutureOr<T> Function(R right) fnR,
  ) {
    return then((either) => either.fold(fnL, fnR));
  }

  /// Swap [Left] and [Right]
  Future<Either<R, L>> swap() => this.fold<Either<R, L>>(Right.new, Left.new);
}
