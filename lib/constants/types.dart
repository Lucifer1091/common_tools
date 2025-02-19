part of 'constants.dart';

typedef StringMap = Map<String, String>;
typedef Json = Map<String, dynamic>;
typedef DynamicJson = Map<dynamic, dynamic>;

typedef Selector<T> = bool Function(T);
typedef FutureOrCallback<T> = FutureOr<T> Function();

typedef BoolCallback = void Function(bool);
typedef NumCallback = void Function(num);
typedef IntCallback = void Function(int);
typedef DoubleCallback = void Function(double);

typedef StringCallback = void Function(String value);

typedef ContextCallback = void Function(BuildContext context);

typedef BottomSheetBuilder = Future<T?> Function<T>(Widget child);
