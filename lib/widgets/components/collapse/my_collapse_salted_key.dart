import 'package:flutter/cupertino.dart';

class MyCollapseSaltedKey<S, V> extends LocalKey {
  const MyCollapseSaltedKey(this.salt, this.value);

  final S salt;
  final V value;

  @override
  bool operator ==(Object other) {
    if (other is! MyCollapseSaltedKey<S, V>) return false;

    return salt == other.salt && value == other.value;
  }

  @override
  int get hashCode => Object.hash(runtimeType, salt, value);

  @override
  String toString() {
    final saltString = S == String ? "<'$salt'>" : '<$salt>';
    final valueString = V == String ? "<'$value'>" : '<$value>';
    return '[$saltString $valueString]';
  }
}
