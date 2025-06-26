import 'package:flutter/material.dart';

import '../../common_tools.dart';
import '../widgets.dart';

/// Conditional rendering class
class Conditional {
  Conditional._();

  /// A function which returns a single `Widget`
  ///
  /// - [condition] is a function which returns a boolean.
  /// - [widget] is a function which returns a `Widget`,
  ///  when [condition] returns `true`.
  /// - [fallback] is a function which returns a `Widget`,
  ///  when [condition] returns `false`. If [fallback] is
  /// not provided, a `Container()` will be returned.
  static Widget single({
    required BuildContext context,
    required Selector<BuildContext> condition,
    required Transformer<BuildContext, Widget> widget,
    Transformer<BuildContext, Widget>? fallback,
  }) {
    if (condition(context)) {
      return widget(context);
    } else {
      return fallback?.call(context) ?? const EmptyPlaceholder();
    }
  }

  /// A function which returns a `List<Widget>`
  ///
  /// - [condition] is the function which returns a boolean.
  /// - [widgets] is a function which returns a `List<Widget>`,
  ///  when [condition] returns `true`.
  /// - [fallback] is a function which returns a `List<Widget>`,
  ///  when [condition] returns `false`. If [fallback] is
  /// not provided, an empty list will be returned.
  static List<Widget> list({
    required BuildContext context,
    required Selector<BuildContext> condition,
    required Transformer<BuildContext, List<Widget>> widgets,
    Transformer<BuildContext, List<Widget>>? fallback,
  }) {
    if (condition(context)) {
      return widgets(context);
    } else {
      return fallback?.call(context) ?? [];
    }
  }
}
