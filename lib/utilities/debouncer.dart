part of 'utilities.dart';

/// de-bounces [run] method calls and runs it only once in given [duration].
/// It will ignore any calls to [run] until [duration] has passed since the
/// last call to [run].
/// It can be used to de-bounce any method calls like search, filter, etc.
final class Debouncer {
  /// Allows to create an instance with optional [Duration] with
  /// immediateFirstRun set to false. See [immediateFirstRun] for more details.
  Debouncer([Duration? duration])
    : duration = duration ?? const Duration(milliseconds: 300),
      immediateFirstRun = false;

  /// Allows to create an instance with optional [Duration] with
  /// immediateFirstRun set to true. See [immediateFirstRun] for more details.
  Debouncer.immediate([Duration? duration])
    : duration = duration ?? const Duration(milliseconds: 300),
      immediateFirstRun = true;

  /// de-bounce period. Default is 300 milliseconds.
  /// It will ignore any calls to [run] until [duration] has passed since the
  /// last call to [run].
  final Duration duration;

  /// Allows to run the first call immediately. Default is false.
  /// If set to true, the first call to [run] will be executed immediately
  /// calling the [action] and then it will wait for [duration] to run the next
  /// call if there's any.
  ///
  /// If set to false, any call to [run] will be ignored until [duration] has
  /// passed since the last call to [run] and then it will run the [action].
  final bool immediateFirstRun;

  Timer? _timer;

  /// Returns true if timer is running and a call is scheduled to run in future
  /// else returns false.
  bool get isRunning => _timer?.isActive ?? false;

  /// Runs [action] after debounced interval.
  /// If [immediateFirstRun] is set to true, it will run the [action]
  /// immediately for the first call and then it will wait for [duration] to
  /// run the next call if there's any.
  ///
  /// This [immediateFirstRun] will override the instance level setting. If
  /// not provided, it will use the instance level setting.
  ///
  /// Returns a [Future] that completes with the result of the [action] call
  /// when it is executed. If [action] is async, it will wait for the
  /// future to complete and then it will complete the returned future.
  ///
  /// Note that returned future will complete with the result of the [action]
  /// call only when it is executed. If the [action] is not executed due to
  /// debouncing, the returned future will not complete.
  Future<R> run<R>(FutureOrCallback<R> action, {bool? immediateFirstRun}) {
    immediateFirstRun ??= this.immediateFirstRun;

    final completer = Completer<R>();

    if (immediateFirstRun && !isRunning) {
      // Execute the action immediately and cancel the previous timer if any!
      _timer?.cancel();
      // fake timer to prevent immediate call on next run.
      _timer = Timer(duration, () {});
      return _runAction<R>(action, completer);
    }

    _timer?.cancel();
    _timer = Timer(duration, () => _runAction<R>(action, completer));

    return completer.future;
  }

  Future<R> _runAction<R>(FutureOrCallback<R> action, Completer<R> completer) {
    final FutureOr<R> result = action();

    if (result is Future<R>) {
      // action is async and returns a future. Wait for the future to complete
      // and then complete the completer.
      result
          .then((result) => completer.complete(result))
          .catchError((Object e) => completer.completeError(e));
      return completer.future;
    }

    // action is sync and returns a value.
    completer.complete(result);
    return completer.future;
  }

  /// alias for [run]. This also makes it so that you can use the instance
  /// as a function.
  ///
  /// e.g.
  /// ```dart
  /// final debouncer = DeBouncer();
  /// debouncer(() async {
  ///   // your action here
  ///   print('debounced action');
  /// });
  /// ```
  ///
  /// Returns a [Future] that completes with the result of the [action] call
  /// when it is executed. See [run] for more details.
  Future<R> call<R>(FutureOrCallback<R> action) => run<R>(action);

  /// Allows to cancel current timer.
  void cancel() {
    _timer?.cancel();
    _timer = null;
  }
}

class Throttler {
  Throttler([Duration? duration, this.immediateFirstRun = false])
    : duration = duration ?? const Duration(milliseconds: 300);

  Throttler.immediate([Duration? duration])
    : duration = duration ?? const Duration(milliseconds: 300),
      immediateFirstRun = true;

  /// The throttle duration.
  final Duration duration;

  /// If true, the first call is executed immediately.
  final bool immediateFirstRun;

  Timer? _timer;
  bool _isAvailable = true;

  /// Returns true if a throttle is in progress.
  bool get isRunning => _timer?.isActive ?? false;

  /// Runs [action] if throttle period has elapsed.
  /// Returns a [Future] that completes with the result of [action] when executed.
  Future<R> run<R>(FutureOrCallback<R> action, {bool? immediateFirstRun}) {
    immediateFirstRun ??= this.immediateFirstRun;
    final completer = Completer<R>();

    if (immediateFirstRun && _isAvailable) {
      _timer?.cancel();
      _isAvailable = false;
      _timer = Timer(duration, () {
        _isAvailable = true;
      });
      _runAction<R>(action, completer);
      return completer.future;
    }

    if (_isAvailable) {
      _isAvailable = false;
      _timer = Timer(duration, () {
        _isAvailable = true;
      });
      _runAction<R>(action, completer);
      return completer.future;
    }

    // If throttled, return a future that never completes.
    return completer.future;
  }

  Future<void> _runAction<R>(
    FutureOrCallback<R> action,
    Completer<R> completer,
  ) async {
    try {
      final result = await action();
      completer.complete(result);
    } catch (e, s) {
      completer.completeError(e, s);
    }
  }

  /// alias for [run]. This also makes it so that you can use the instance
  /// as a function.
  ///
  /// e.g.
  /// ```dart
  /// final throttler = Throttler();
  /// throttler(() async {
  ///   // your action here
  ///   print('throttled action');
  /// });
  /// ```
  ///
  /// Returns a [Future] that completes with the result of the [action] call
  /// when it is executed. See [run] for more details.
  Future<R> call<R>(FutureOrCallback<R> action) => run<R>(action);

  /// Allows to cancel current timer.
  void cancel() {
    _timer?.cancel();
    _timer = null;
    _isAvailable = true;
  }
}
