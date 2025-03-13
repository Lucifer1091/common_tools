part of 'constants.dart';

typedef StringMap = Map<String, String>;
typedef Json = Map<String, dynamic>;
typedef DynamicJson = Map<dynamic, dynamic>;

typedef Selector<T> = bool Function(T value);
typedef Comparator<T> = bool Function(T a, T b);
typedef FutureOrCallback<T> = FutureOr<T> Function();

typedef GenericCallback<T> = void Function(T value);

typedef BoolCallback = GenericCallback<bool>;
typedef NumCallback = GenericCallback<num>;
typedef IntCallback = GenericCallback<int>;
typedef DoubleCallback = GenericCallback<double>;
typedef StringCallback = GenericCallback<String>;
typedef ContextCallback = GenericCallback<BuildContext>;

typedef BottomSheetBuilder = Future<T?> Function<T>(Widget child);

/// Function that gets value [T] for that element.
typedef GetValue<E, T> = T Function(E element);

typedef MapIndexedValue<E, T> = T Function(int index, E element);

/// Function that returns value [T] for the element and index
typedef IndexedPredicate<T> = bool Function(int index, T element);
