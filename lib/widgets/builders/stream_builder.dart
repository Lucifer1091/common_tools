import 'package:flutter/widgets.dart';

import '../../index.dart';

class MyStreamBuilder<T> extends StatelessWidget {
  const MyStreamBuilder({
    required this.stream,
    required this.onSuccess,
    required this.inProgress,
    this.initialData,
    this.onLoading,
    this.onError,
    super.key,
  });

  /// Stream to listen to.
  final Stream<T>? stream;

  /// Widget to display when connected to an asynchronous computation and awaiting interaction.
  final Widget? onLoading;

  /// Widget to display when the asynchronous computation is not done yet.
  final Widget inProgress;

  /// Function to call when the asynchronous computation is done.
  final Widget Function(T snapshotData) onSuccess;

  /// Function to call when the asynchronous computation is done with error.
  /// If no function is passed, whenNotDone() will be used instead
  final Widget Function(Object? error)? onError;

  /// The data that will be used until a non-null [stream] has completed.
  ///
  /// See [FutureBuilder] for more info
  final T? initialData;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      key: ValueKey(stream),
      initialData: initialData,
      stream: stream,
      builder: (context, snapshot) {
        return snapshot.when(
          loading: () => onLoading ?? inProgress,
          data: (data, isComplete) {
            if (isComplete) {
              return onSuccess(data);
            }
            return inProgress;
          },
          error: (error, stackTrace) {
            if (onError != null) {
              return onError!(error);
            } else {
              return inProgress;
            }
          },
        );
      },
    );
  }
}
