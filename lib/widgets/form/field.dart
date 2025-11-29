import 'dart:async';

import 'package:flutter/widgets.dart';

import '../../index.dart';

/// A function that transforms the value of a form field into a different
/// format.
///
/// Takes a value of type [T] and returns a transformed value of any type.
/// Used to convert field values before saving or processing
typedef ValueTransformer<T> = dynamic Function(T value);

/// A customizable form field widget with built-in decoration and state
/// management.
///
/// The [MyFormBuilderField] extends [FormField] to provide a styled input
/// field with a label, error display, and description, integrated with
/// `MyTheme` via [MyInputDecorator]. It supports validation, focus
/// management, and value transformation, designed for use within a [MyForm].
@immutable
class MyFormBuilderField<T> extends FormField<T> {
  /// Creates a form field widget with a custom builder and optional properties.
  MyFormBuilderField({
    required Widget Function(FormFieldState<T>) builder,
    super.key,
    super.onSaved,
    super.validator,
    super.initialValue,
    super.enabled,
    super.autovalidateMode,
    super.restorationId,
    this.readOnly = false,
    this.id,
    this.focusNode,
    this.label,
    this.error,
    this.description,
    this.onChanged,
    this.valueTransformer,
    this.onReset,
    this.decorationBuilder,
    super.forceErrorText,
  }) : super(
         builder: (field) {
           final state =
               field as MyFormBuilderFieldState<MyFormBuilderField<T>, T>;
           final hasError = field.hasError;

           final effectiveError =
               hasError
                   ? error?.call(field.errorText!) ?? Text(field.errorText!)
                   : null;

           return MyInputDecorator(
             label: label,
             error: effectiveError,
             description: description,
             decoration: state.decoration,
             child: builder(field),
           );
         },
         onReset: onReset,
       );

  /// {@template MyFormBuilderField.id}
  /// An optional identifier used to reference the field within a [MyForm].
  /// Enables form data retrieval or field manipulation post-submission.
  /// {@endtemplate}
  final Object? id;

  /// {@template MyFormBuilderField.focusNode}
  /// The focus node for keyboard navigation and focus handling.
  /// If null, an internal focus node is created by the state.
  /// {@endtemplate}
  final FocusNode? focusNode;

  /// {@template MyFormBuilderField.label}
  /// The label widget displayed above the field.
  /// Typically a [Text] widget, providing context for the field’s purpose.
  /// {@endtemplate}
  final Widget? label;

  /// {@template MyFormBuilderField.error}
  /// A function that returns a custom error widget based on the error text.
  /// Called when validation fails; defaults to a [Text] widget if null.
  /// {@endtemplate}
  final Widget Function(String error)? error;

  /// {@template MyFormBuilderField.description}
  /// The description widget displayed below the field.
  /// Typically a [Text] widget, offering additional field information.
  /// {@endtemplate}
  final Widget? description;

  /// {@template MyFormBuilderField.onChanged}
  /// Callback invoked when the field’s value changes.
  /// Provides the new value, complementing form state updates.
  /// {@endtemplate}
  final ValueChanged<T?>? onChanged;

  /// {@template MyFormBuilderField.valueTransformer}
  /// A function to transform the field’s value before saving or processing.
  /// Useful for formatting or converting data; defaults to null
  /// (no transformation).
  /// {@endtemplate}
  final ValueTransformer<T?>? valueTransformer;

  /// {@template MyFormBuilderField.onReset}
  /// Callback invoked when the field is reset to its initial value.
  /// Allows additional reset logic; defaults to null.
  /// {@endtemplate}
  @override
  // ignore: overridden_fields
  final VoidCallback? onReset;

  /// {@template MyFormBuilderField.decorationBuilder}
  /// A function that builds a custom [MyDecoration] for the field.
  /// Overrides the default decoration; merged with error state if provided.
  /// {@endtemplate}
  final MyDecoration? Function(BuildContext context)? decorationBuilder;

  /// {@template MyFormBuilderField.readOnly}
  /// Whether the field is read-only.
  /// Defaults to false; if true, prevents editing but allows focus.
  /// {@endtemplate}
  final bool readOnly;

  @override
  MyFormBuilderFieldState<MyFormBuilderField<T>, T> createState() =>
      MyFormBuilderFieldState<MyFormBuilderField<T>, T>();
}

/// The state class for [MyFormBuilderField], managing field state and form
/// integration.
///
/// Extends [FormFieldState] to handle value changes, focus, and form
/// registration.
/// Provides methods for focusing, ensuring visibility, and updating the parent
/// form.
class MyFormBuilderFieldState<F extends MyFormBuilderField<T>, T>
    extends FormFieldState<T> {
  FocusNode? _focusNode;
  MyFormState? _parentForm;

  /// The effective focus node, either provided or internally managed.
  FocusNode get focusNode => widget.focusNode ?? _focusNode!;

  bool get _isEnabled => widget.enabled;

  bool get _canRequestFocus => !widget.readOnly && _isEnabled;

  /// The decoration applied to the field, reflecting error state.
  MyDecoration get decoration =>
      (widget.decorationBuilder?.call(context) ?? const MyDecoration())
          .copyWith(hasError: hasError);

  String? _forceErrorText;

  String? get forceErrorText => widget.forceErrorText ?? _forceErrorText;

  @override
  String? get errorText => forceErrorText ?? super.errorText;

  @override
  bool get hasError => forceErrorText != null || super.hasError;

  /// Sets an internal error message that overrides validation errors.
  void setInternalError(String? error) {
    setState(() {
      _forceErrorText = error;
    });
  }

  @override
  F get widget => super.widget as F;

  /// The initial value of the field, sourced from widget or parent form.
  T? get initialValue =>
      widget.initialValue ??
      (_parentForm?.widget.initialValue[widget.id] as T?);

  /// Whether the field is enabled, factoring in parent form state.
  bool get enabled => widget.enabled && (_parentForm?.enabled ?? true);

  @override
  void initState() {
    super.initState();
    if (widget.focusNode == null) {
      _focusNode = FocusNode(canRequestFocus: _canRequestFocus);
    }
    // Register this field when there is a parent MyForm
    _parentForm = MyForm.maybeOf(context);
    if (widget.id != null) _parentForm?.registerField(widget.id!, this);
  }

  @override
  void didUpdateWidget(covariant MyFormBuilderField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.id != oldWidget.id) {
      if (oldWidget.id != null) {
        _parentForm?.unregisterField(oldWidget.id!, this);
      }
      if (widget.id != null) _parentForm?.registerField(widget.id!, this);
    }

    if (oldWidget.focusNode != null && widget.focusNode == null) {
      _focusNode ??= FocusNode(canRequestFocus: _canRequestFocus);
    }

    if (widget.readOnly != oldWidget.readOnly) {
      _focusNode?.canRequestFocus = _canRequestFocus;
    }
  }

  @override
  void didChange(T? value) {
    super.didChange(value);
    _informFormForFieldChange();
    widget.onChanged?.call(value);
  }

  @override
  void reset() {
    super.reset();
    didChange(initialValue);
    widget.onReset?.call();
  }

  @override
  void dispose() {
    if (widget.id != null) _parentForm?.unregisterField(widget.id!, this);
    _focusNode?.dispose();
    super.dispose();
  }

  /// Requests focus for the field's focus node.
  void focus() {
    FocusScope.of(context).requestFocus(focusNode);
  }

  /// Ensures the field is visible by scrolling if necessary.
  void ensureVisible() {
    unawaited(Scrollable.ensureVisible(context));
  }

  @override
  void setValue(T? value, {bool populateForm = true}) {
    super.setValue(value);
    if (populateForm) {
      _informFormForFieldChange();
    }
  }

  void _informFormForFieldChange() {
    if (_parentForm != null) {
      if (enabled) {
        if (widget.id != null) {
          _parentForm!.setInternalFieldValue<T>(widget.id!, value);
        }
        return;
      }
      if (widget.id != null) _parentForm!.removeInternalFieldValue(widget.id!);
    }
  }

  /// Registers the field’s value transformer with the provided map.
  void registerTransformer(Map<Object, Function> map) {
    if (widget.id == null) return;
    final fun = widget.valueTransformer;
    if (fun != null) {
      map[widget.id!] = fun;
    }
  }
}
