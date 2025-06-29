part of 'utilities.dart';

/// A utility class for handling clipboard operations.
///
/// The `Clipboard` class provides static methods to copy text to the clipboard
/// and paste text from the clipboard. It includes an optional callback for the
/// copy operation.
///
/// Example usage:
/// ```dart
/// // Copying text to the clipboard
/// Clipboard.copy('Hello, World!', onCopy: () {
///   print('Text copied to clipboard');
/// });
///
/// // Pasting text from the clipboard
/// Future<void> pasteText() async {
///   String text = await Clipboard.paste();
///   print('Pasted text: $text');
/// }
/// ```
sealed class Clipboard {
  // Private constructor to prevent instantiation
  Clipboard._();

  /// Copies the provided [text] to the clipboard.
  ///
  /// This method copies the given [text] to the clipboard and optionally calls
  /// the [onCopy] callback after the text has been copied.
  ///
  /// - [text]: The text to copy to the clipboard.
  /// - [onCopy]: An optional callback function that is called after the text is copied.
  ///
  /// Example usage:
  /// ```dart
  /// Clipboard.copy('Hello, World!', onCopy: () {
  ///   print('Text copied to clipboard');
  /// });
  /// ```
  static Future<void> copy(String text, {VoidCallback? onCopy}) async {
    final data = service.ClipboardData(text: text);
    await service.Clipboard.setData(data);
    onCopy?.call();
  }

  /// Pastes text from the clipboard.
  ///
  /// This method retrieves the text from the clipboard and returns it as a string.
  /// If no text is found on the clipboard, an empty string is returned.
  ///
  /// Example usage:
  /// ```dart
  /// Future<void> pasteText() async {
  ///   String text = await Clipboard.paste();
  ///   print('Pasted text: $text');
  /// }
  /// ```
  static Future<String> paste() async {
    final data = await service.Clipboard.getData('text/plain');
    return data?.text ?? '';
  }
}
