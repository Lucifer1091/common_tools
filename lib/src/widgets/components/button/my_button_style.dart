import 'package:flutter/material.dart';

import '../../../extensions/context/theme.dart';
import '../../../extensions/misc/color.dart';

class MyButtonStyle {
  MyButtonStyle({
    this.backgroundColor,
    this.borderColor,
    this.borderWidth,
    this.radius,
    this.textColor,
    this.decoration,
  });

  MyButtonStyle.primary(BuildContext context, Set<WidgetState> states) {
    final pressed = states.contains(WidgetState.pressed);
    final hovered = states.contains(WidgetState.hovered);
    final disabled = states.contains(WidgetState.disabled);

    if (disabled) {
      backgroundColor = context.colorScheme.mutedForeground;
    } else if (hovered || pressed) {
      backgroundColor = context.colorScheme.primary.scaleAlpha(0.8);
    }

    backgroundColor ??= context.colorScheme.primary;
    borderColor ??= backgroundColor;
    textColor ??= context.colorScheme.primaryForeground;
  }

  MyButtonStyle.secondary(BuildContext context, Set<WidgetState> states) {
    final pressed = states.contains(WidgetState.pressed);
    final hovered = states.contains(WidgetState.hovered);
    final disabled = states.contains(WidgetState.disabled);

    if (disabled) {
      backgroundColor = context.colorScheme.primaryForeground;
      textColor = context.colorScheme.mutedForeground;
    } else if (hovered || pressed) {
      backgroundColor = context.colorScheme.secondary.scaleAlpha(0.8);
    }

    backgroundColor ??= context.colorScheme.secondary;
    borderColor ??= backgroundColor;
    textColor ??= context.colorScheme.secondaryForeground;
  }

  MyButtonStyle.destructive(BuildContext context, Set<WidgetState> states) {
    final pressed = states.contains(WidgetState.pressed);
    final hovered = states.contains(WidgetState.hovered);
    final disabled = states.contains(WidgetState.disabled);

    if (disabled) {
      backgroundColor = context.colorScheme.primaryForeground;
      textColor = context.colorScheme.mutedForeground;
    } else if (hovered || pressed) {
      backgroundColor = context.colorScheme.destructive.scaleAlpha(0.8);
    }

    backgroundColor ??= context.colorScheme.destructive;
    textColor ??= context.colorScheme.destructiveForeground;
    borderColor ??= backgroundColor;
  }

  MyButtonStyle.outline(BuildContext context, Set<WidgetState> states) {
    final pressed = states.contains(WidgetState.pressed);
    final hovered = states.contains(WidgetState.hovered);
    final disabled = states.contains(WidgetState.disabled);

    if (disabled) {
      backgroundColor = context.colorScheme.border.withValues(alpha: 0);
      borderColor = context.colorScheme.border;
      textColor = context.colorScheme.mutedForeground;
    } else if (hovered || pressed) {
      backgroundColor = context.colorScheme.muted.scaleAlpha(0.8);
      borderColor = context.colorScheme.muted.scaleAlpha(0.8);
    }

    backgroundColor ??= context.colorScheme.muted.withValues(alpha: 0);
    borderColor ??= context.colorScheme.input;
    borderWidth = 1;
    textColor ??= context.colorScheme.foreground;
  }

  MyButtonStyle.ghost(BuildContext context, Set<WidgetState> states) {
    final pressed = states.contains(WidgetState.pressed);
    final hovered = states.contains(WidgetState.hovered);
    final disabled = states.contains(WidgetState.disabled);

    if (disabled) {
      backgroundColor = context.colorScheme.muted.withValues(alpha: 0);
      textColor = context.colorScheme.mutedForeground;
    } else if (hovered || pressed) {
      backgroundColor = context.colorScheme.muted.scaleAlpha(0.8);
      borderColor = context.colorScheme.muted.scaleAlpha(0.8);
    }

    backgroundColor ??= context.colorScheme.muted.withValues(alpha: 0);
    borderColor ??= backgroundColor;
    textColor ??= context.colorScheme.foreground;
  }

  MyButtonStyle.text(BuildContext context, Set<WidgetState> states) {
    final pressed = states.contains(WidgetState.pressed);
    final hovered = states.contains(WidgetState.hovered);

    if (hovered || pressed) {
      textColor = context.colorScheme.primary;
    }

    textColor ??= context.colorScheme.mutedForeground;
  }

  MyButtonStyle.link(BuildContext context, Set<WidgetState> states) {
    final pressed = states.contains(WidgetState.pressed);
    final hovered = states.contains(WidgetState.hovered);
    final disabled = states.contains(WidgetState.disabled);

    if (disabled) {
      textColor = context.colorScheme.mutedForeground;
    } else if (hovered || pressed) {
      decoration = TextDecoration.underline;
    }

    textColor ??= context.colorScheme.foreground;
    decoration ??= TextDecoration.none;
  }

  Color? backgroundColor;
  Color? borderColor;
  Color? textColor;
  TextDecoration? decoration;
  double? borderWidth;
  BorderRadius? radius;

  MyButtonStyle copyWith({
    Color? backgroundColor,
    Color? borderColor,
    Color? textColor,
    TextDecoration? decoration,
    double? borderWidth,
    BorderRadius? radius,
  }) {
    return MyButtonStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderColor: borderColor ?? this.borderColor,
      textColor: textColor ?? this.textColor,
      decoration: decoration ?? this.decoration,
      borderWidth: borderWidth ?? this.borderWidth,
      radius: radius ?? this.radius,
    );
  }
}
