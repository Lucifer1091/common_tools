import 'package:flutter/cupertino.dart';

class TDCollapseSaltedKey<S, V> extends LocalKey {
  const TDCollapseSaltedKey(this.salt, this.value);

  final S salt;
  final V value;

  @override
  bool operator ==(Object other) {
    if (other is! TDCollapseSaltedKey<S, V>) return false;

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
