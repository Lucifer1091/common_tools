import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeState {
  final ThemeMode mode;
  final String color;

  const ThemeState({this.mode = ThemeMode.light, this.color = 'blue'});

  ThemeState copyWith({ThemeMode? mode, String? color}) {
    return ThemeState(mode: mode ?? this.mode, color: color ?? this.color);
  }
}

class ThemeNotifier extends StateNotifier<ThemeState> {
  ThemeNotifier() : super(const ThemeState());

  void setMode(ThemeMode mode) {
    state = state.copyWith(mode: mode);
  }

  void setColor(String color) {
    state = state.copyWith(color: color);
  }
}

// Provider
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeState>((ref) {
  return ThemeNotifier();
});
