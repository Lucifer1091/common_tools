import 'package:local_auth/local_auth.dart';

class Biometric {
  Biometric._();

  static final _auth = LocalAuthentication();

  static Future<bool> get isSupported async {
    try {
      return await _auth.canCheckBiometrics || await _auth.isDeviceSupported();
    } catch (e) {
      return false;
    }
  }

  static Future<bool> authenticate({
    String? message = 'Please Authenticate to login automatically',
    bool biometricOnly = false,
  }) async {
    try {
      if (!await isSupported) return false;

      return _auth.authenticate(
        localizedReason: message ?? 'Please Authenticate to continue.',
        persistAcrossBackgrounding: true,
        biometricOnly: biometricOnly,
      );
    } on LocalAuthException catch (e) {
      if (e.code == LocalAuthExceptionCode.noBiometricHardware) {
        // Add handling of no hardware here.
      } else if (e.code == LocalAuthExceptionCode.noBiometricsEnrolled) {
        // ...
      } else {
        // ...
      }
      if (e.code == LocalAuthExceptionCode.noBiometricsEnrolled) {
        // Add handling of no hardware here.
      } else if (e.code == LocalAuthExceptionCode.temporaryLockout ||
          e.code == LocalAuthExceptionCode.biometricLockout) {
        // ...
      } else {
        // ...
      }
    }
    return false;
  }
}
