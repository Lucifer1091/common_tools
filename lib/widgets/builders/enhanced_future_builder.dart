import 'package:flutter/widgets.dart';

import '../../common_tools.dart';

class EnhancedFutureBuilder<T> extends StatefulWidget {
  const EnhancedFutureBuilder({
    required this.future,
    required this.onSuccess,
    required this.inProgress,
    this.rememberFutureResult = false,
    this.initialData,
    this.onLoading,
    this.onError,
    super.key,
  });

  /// Future to resolve.
  final Future<T>? future;

  /// Whether or not the future result should be stored.
  final bool rememberFutureResult;

  /// Widget to display when connected to an asynchronous computation and awaiting interaction.
  final Widget? onLoading;

  /// Widget to display when the asynchronous computation is not done yet.
  final Widget inProgress;

  /// Function to call when the asynchronous computation is done.
  final Widget Function(T snapshotData) onSuccess;

  /// Function to call when the asynchronous computation is done with error.
  /// If no function is passed, whenNotDone() will be used instead
  final Widget Function(Object? error)? onError;

  /// The data that will be used until a non-null [future] has completed.
  ///
  /// See [FutureBuilder] for more info
  final T? initialData;

  @override
  State<EnhancedFutureBuilder<T>> createState() =>
      _EnhancedFutureBuilderState<T>();
}

class _EnhancedFutureBuilderState<T> extends State<EnhancedFutureBuilder<T>> {
  Future<T>? _cachedFuture;

  @override
  void initState() {
    super.initState();
    // If rememberFutureResult is true, we cache the future so that it can be reused
    // on rebuilds. This is useful for cases where the future is expensive to compute.
    // If it is false, we use the provided future directly.
    if (widget.rememberFutureResult) {
      _cachedFuture = widget.future;
    } else {
      // If rememberFutureResult is false, we do not cache the future.
      // This means that the future will be recreated on every rebuild.
      _cachedFuture = null;
    }
  }

  @override
  void didUpdateWidget(covariant EnhancedFutureBuilder<T> oldWidget) {
    if (widget.rememberFutureResult) {
      // If rememberFutureResult is true, we need to update the cached future
      // to the new future provided in the widget.
      if (widget.future != oldWidget.future) {
        _cachedFuture = widget.future;
      }
    } else {
      // If rememberFutureResult is false, we do not cache the future.
      _cachedFuture = null;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      key: ValueKey(widget.future),
      initialData: widget.initialData,
      future: widget.rememberFutureResult ? _cachedFuture : widget.future,
      builder: (context, snapshot) {
        return snapshot.when(
          loading: () => widget.onLoading ?? widget.inProgress,
          data: (data, isComplete) {
            if (isComplete) {
              return widget.onSuccess(data);
            }
            return widget.inProgress;
          },
          error: (error, stackTrace) {
            if (widget.onError != null) {
              return widget.onError!(error);
            } else {
              return widget.inProgress;
            }
          },
        );
      },
    );
  }
}
