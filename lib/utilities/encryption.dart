part of 'utilities.dart';

class Encryptor {
  Encryptor._();

  static encrypt.Encrypted encryptAES(
    String plainText, {
    required String rawKey,
    String? rawIv,
  }) {
    final key = encrypt.Key.fromUtf8(rawKey);
    final iv = rawIv != null
        ? encrypt.IV.fromBase64(rawIv)
        : encrypt.IV.fromLength(16);
    final encrypted =
        encrypt.Encrypter(encrypt.AES(key)).encrypt(plainText, iv: iv);
    return encrypted;
  }

  static String decryptAES(
    String encoded, {
    required String rawKey,
    String? rawIv,
  }) {
    final key = encrypt.Key.fromUtf8(rawKey);
    final iv = rawIv != null
        ? encrypt.IV.fromBase64(rawIv)
        : encrypt.IV.fromLength(16);
    final decrypted =
        encrypt.Encrypter(encrypt.AES(key)).decrypt64(encoded, iv: iv);
    return decrypted;
  }
}

extension EncryptX on String? {
  String encrypt({required String key, String? iv}) {
    if (this == null) return '';

    return Encryptor.encryptAES(toString(), rawKey: key, rawIv: iv).base64;
  }

  String decrypt({required String key, String? iv}) {
    if (this == null) return '';

    return Encryptor.decryptAES(toString(), rawKey: key, rawIv: iv);
  }
}
