part of 'extensions.dart';

extension FormStateX on GlobalKey<FormState>? {
  bool isValid() {
    if (this == null) return false;

    return this!.currentState?.validate() ?? false;
  }

  bool isNotValid() {
    return !isValid();
  }
}
