part of 'utilities.dart';

class Clipboard {
  Clipboard._();
  static Future<void> copy(String text, {VoidCallback? onSuccess}) async {
    final data = service.ClipboardData(text: text);
    await service.Clipboard.setData(data);
    onSuccess?.call();
  }

  static Future<String> paste(String text) async {
    final data = await service.Clipboard.getData('text/plain');
    return data?.text ?? '';
  }
}
