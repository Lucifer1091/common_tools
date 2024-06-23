part of 'utilities.dart';

/// Utility class for encrypting and decrypting data using AES encryption.
///
/// This class provides static methods to encrypt and decrypt strings using AES encryption.
class Encryptor {
  Encryptor._();

  /// Encrypts the given `plainText` using AES encryption with the provided `rawKey` and optional `rawIv`.
  ///
  /// Returns the encrypted data as an `encrypt.Encrypted` object.
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

  /// Decrypts the given `encoded` data using AES encryption with the provided `rawKey` and optional `rawIv`.
  ///
  /// Returns the decrypted data as a plain text `String`.
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

/// Extension on `String?` to provide encryption and decryption methods.
///
/// This extension allows any nullable string (`String?`) to be encrypted and decrypted
/// using AES encryption with a specified `key` and optional `iv`.
extension EncryptX on String? {
  /// Encrypts the current string using AES encryption with the provided `key` and optional `iv`.
  ///
  /// Returns the encrypted data as a base64-encoded `String`.
  String encrypt({required String key, String? iv}) {
    if (this == null) return '';

    return Encryptor.encryptAES(toString(), rawKey: key, rawIv: iv).base64;
  }

  /// Decrypts the current base64-encoded string using AES encryption with the provided `key` and optional `iv`.
  ///
  /// Returns the decrypted data as a plain text `String`.
  String decrypt({required String key, String? iv}) {
    if (this == null) return '';

    return Encryptor.decryptAES(toString(), rawKey: key, rawIv: iv);
  }
}

/// Example usage of Encryptor and EncryptX extension.
///
/// Encrypts and decrypts a sample string using AES encryption.
///
/// ```dart
/// void main() {
///   final originalText = 'Hello, world!';
///   final key = 'my_secret_key_123';
///   final iv = 'my_initialization_vector'; // Optional
///
///   // Encrypt using static method
///   final encrypted = Encryptor.encryptAES(originalText, rawKey: key, rawIv: iv);
///   print('Encrypted: ${encrypted.base64}');
///
///   // Decrypt using static method
///   final decrypted = Encryptor.decryptAES(encrypted.base64, rawKey: key, rawIv: iv);
///   print('Decrypted: $decrypted');
///
///   // Using extension methods
///   final encryptedExtension = originalText.encrypt(key: key, iv: iv);
///   print('Encrypted (extension): $encryptedExtension');
///
///   final decryptedExtension = encryptedExtension.decrypt(key: key, iv: iv);
///   print('Decrypted (extension): $decryptedExtension');
/// }
/// ```
