import 'package:common_tools/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeState {
  final ThemeMode mode;
  final MyBaseColor baseColor;
  final MyAccentColor? accentColor;

  const ThemeState({
    this.mode = ThemeMode.light,
    this.baseColor = MyBaseColor.neutral,
    this.accentColor = MyAccentColor.blue,
  });

  MyThemePickerValue get pickerValue {
    return MyThemePickerValue(
      mode: mode,
      baseColor: baseColor,
      accentColor: accentColor,
    );
  }

  String get label {
    return _labelFor(accentColor?.name ?? baseColor.name);
  }

  MyColorScheme colorScheme({Brightness brightness = Brightness.light}) {
    return MyColorScheme.fromParts(
      base: baseColor,
      accent: accentColor,
      brightness: brightness,
    );
  }

  ThemeState copyWith({
    ThemeMode? mode,
    MyBaseColor? baseColor,
    MyAccentColor? accentColor,
    bool clearAccentColor = false,
  }) {
    return ThemeState(
      mode: mode ?? this.mode,
      baseColor: baseColor ?? this.baseColor,
      accentColor: clearAccentColor ? null : accentColor ?? this.accentColor,
    );
  }
}

class ThemeNotifier extends StateNotifier<ThemeState> {
  ThemeNotifier() : super(const ThemeState());

  void setMode(ThemeMode mode) {
    state = state.copyWith(mode: mode);
  }

  void setBaseColor(MyBaseColor baseColor) {
    state = state.copyWith(baseColor: baseColor);
  }

  void setAccentColor(MyAccentColor? accentColor) {
    state = state.copyWith(
      accentColor: accentColor,
      clearAccentColor: accentColor == null,
    );
  }

  void setValue(MyThemePickerValue value) {
    state = ThemeState(
      mode: value.mode,
      baseColor: value.baseColor,
      accentColor: value.accentColor,
    );
  }
}

// Provider
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeState>((ref) {
  return ThemeNotifier();
});

String _labelFor(String value) {
  return value.isEmpty
      ? 'Theme'
      : '${value[0].toUpperCase()}${value.substring(1)}';
}
