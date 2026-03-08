import 'package:flutter/widgets.dart';

/// Convenience branching helpers for [AsyncSnapshot].
///
/// These helpers map snapshot states to callbacks and expose an `isComplete`
/// flag for data callbacks:
/// - `true` for [ConnectionState.none] and [ConnectionState.done]
/// - `false` for [ConnectionState.active]
extension AsyncSnapshotExt<T> on AsyncSnapshot<T> {
  /// Returns `true` when no asynchronous computation is connected.
  bool get isNone => connectionState == ConnectionState.none;

  /// Returns `true` while waiting for the first value.
  bool get isWaiting => connectionState == ConnectionState.waiting;

  /// Returns `true` while an active stream is emitting values.
  bool get isActive => connectionState == ConnectionState.active;

  /// Returns `true` when the asynchronous computation is complete.
  bool get isDone => connectionState == ConnectionState.done;

  /// Branches by state similarly to [when], but makes [data] optional.
  ///
  /// If [data] is omitted and snapshot contains data, [loading] is used.
  /// The second `data` argument (`isComplete`) is `true` for
  /// [ConnectionState.none]/[ConnectionState.done], and `false` for
  /// [ConnectionState.active].
  ///
  /// Example:
  /// ```dart
  /// StreamBuilder<String>(
  ///   stream: messageStream,
  ///   builder: (context, snapshot) {
  ///     return snapshot.maybeWhen(
  ///       loading: () => const CircularProgressIndicator(),
  ///       error: (error, stackTrace) => Text('Error: $error'),
  ///       data: (value, isComplete) =>
  ///           Text(isComplete ? 'Final: $value' : 'Live: $value'),
  ///     );
  ///   },
  /// );
  /// ```
  R maybeWhen<R>({
    required R Function() loading,
    required R Function(Object error, StackTrace? stackTrace) error,
    R Function(T data, bool isComplete)? data,
  }) {
    R resolveData(T value, bool isComplete) =>
        data != null ? data(value, isComplete) : loading();

    switch (connectionState) {
      case ConnectionState.none:
        if (hasError) return error(this.error!, stackTrace);
        if (this.data is T) return resolveData(this.data as T, true);
        return loading();
      case ConnectionState.waiting:
        return loading();
      case ConnectionState.active:
        if (hasError) return error(this.error!, stackTrace);
        if (this.data is T) return resolveData(this.data as T, false);
        return loading();
      case ConnectionState.done:
        if (hasError) return error(this.error!, stackTrace);
        if (this.data is T) return resolveData(this.data as T, true);
        return loading();
    }
  }

  /// Branches by snapshot state with required handlers for all outcomes.
  ///
  /// Unlike [maybeWhen], [data] is required. Use [maybeWhen] when you want to
  /// treat data and loading the same.
  ///
  /// The second `data` argument (`isComplete`) is `true` for
  /// [ConnectionState.none]/[ConnectionState.done], and `false` for
  /// [ConnectionState.active].
  ///
  /// Example:
  /// ```dart
  /// final text = snapshot.when(
  ///   loading: () => 'Loading...',
  ///   data: (value, isComplete) => isComplete ? 'Done: $value' : 'Data: $value',
  ///   error: (error, stackTrace) => 'Error: $error',
  /// );
  /// ```
  R when<R>({
    required R Function() loading,
    required R Function(T data, bool isComplete) data,
    required R Function(Object error, StackTrace? stackTrace) error,
  }) {
    switch (connectionState) {
      case ConnectionState.none:
        if (hasError) return error(this.error!, stackTrace);
        if (this.data is T) return data(this.data as T, true);
        return loading();
      case ConnectionState.waiting:
        return loading();
      case ConnectionState.active:
        if (hasError) return error(this.error!, stackTrace);
        if (this.data is T) return data(this.data as T, false);
        return loading();
      case ConnectionState.done:
        if (hasError) return error(this.error!, stackTrace);
        if (this.data is T) return data(this.data as T, true);
        return loading();
    }
  }
}
