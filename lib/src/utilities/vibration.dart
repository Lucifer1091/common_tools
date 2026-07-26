import 'package:flutter/services.dart';

/// A utility class for triggering haptic feedback.
///
/// The `Vibration` class provides static methods to trigger different types of
/// haptic feedback. This can be used to provide tactile feedback to users for
/// various actions, such as selecting an item or indicating a sound.
///
/// Example usage:
/// ```dart
/// // Trigger a heavy impact vibration
/// await Vibration.select();
///
/// // Trigger a standard vibration
/// await Vibration.sound();
///
/// // Trigger a light impact vibration
/// await Vibration.lightImpact();
///
/// // Trigger a medium impact vibration
/// await Vibration.mediumImpact();
///
/// // Trigger a selection click vibration
/// await Vibration.selectionClick();
/// ```
class Vibration {
  Vibration._();

  /// Triggers a heavy impact haptic feedback.
  ///
  /// Use case: Provide feedback for a significant user action,
  /// such as confirming a selection or completing an important task.
  static Future<void> heavyImpact() => HapticFeedback.heavyImpact();

  /// Triggers a standard vibration haptic feedback.
  ///
  /// Use case: Provide feedback for events like notifications or alerts.
  static Future<void> vibrate() => HapticFeedback.vibrate();

  /// Triggers a light impact haptic feedback.
  ///
  /// Use case: Provide subtle feedback for minor actions,
  /// such as tapping a button or making a small adjustment.
  static Future<void> lightImpact() => HapticFeedback.lightImpact();

  /// Triggers a medium impact haptic feedback.
  ///
  /// Use case: Provide feedback for intermediate actions,
  /// such as toggling a switch or sliding a control.
  static Future<void> mediumImpact() => HapticFeedback.mediumImpact();

  /// Triggers a selection click haptic feedback.
  ///
  /// Use case: Provide feedback for selection actions,
  /// such as selecting an item in a list or menu.
  static Future<void> selectionClick() => HapticFeedback.selectionClick();
}
