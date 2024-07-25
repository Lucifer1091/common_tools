part of 'extensions.dart';

extension FormStateX on GlobalKey<FormState>? {
  bool isValid() {
    if (this == null) return false;

    return this!.currentState?.validate() ?? false;
  }

  bool isNotValid() {
    return !isValid();
  }

  void reset() {
    if (this == null) return;

    return this!.currentState?.reset();
  }

  void save() {
    if (this == null) return;

    return this!.currentState?.save();
  }

  Set<FormFieldState<Object?>>? validateGranularly() {
    if (this == null) return null;

    return this!.currentState?.validateGranularly();
  }
}
