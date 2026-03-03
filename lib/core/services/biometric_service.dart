import 'package:local_auth/local_auth.dart';

abstract class BiometricService {
  Future<bool> canCheckBiometrics();
  Future<bool> authenticate({required String reason});
}

class BiometricServiceImpl implements BiometricService {
  BiometricServiceImpl(this._localAuth);

  final LocalAuthentication _localAuth;

  @override
  Future<bool> canCheckBiometrics() async {
    final canCheck = await _localAuth.canCheckBiometrics;
    final isSupported = await _localAuth.isDeviceSupported();
    return canCheck && isSupported;
  }

  @override
  Future<bool> authenticate({required String reason}) async {
    final available = await canCheckBiometrics();
    if (!available) return false;

    return _localAuth.authenticate(
      localizedReason: reason,
      options: const AuthenticationOptions(
        biometricOnly: true,
        stickyAuth: true,
      ),
    );
  }
}
