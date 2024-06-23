part of 'constants.dart';

/// Map of keys and values of type String
typedef StringMap = Map<String, String>;

/// Map of String keys and dynamic values.
typedef Json = Map<String, dynamic>;

/// Map of dynamic keys and dynamic values.
typedef DynamicJson = Map<dynamic, dynamic>;

/// Callback that accepts an [int] through parameters
typedef IntCallback = void Function(int);

typedef BoolCallback<T> = bool Function(T value);

/// Callback that accepts an [String] through parameters
typedef StringCallback = void Function(String value);

/// Callback that accepts an [BuildContext] through parameters
typedef ContextCallback = void Function(BuildContext context);

/// Callback for bottom sheet builders
typedef BottomSheetBuilder = Future<T?> Function<T>(Widget child);

/// Callback that accepts an index parameter.
typedef IndexCallback = void Function(int index);
