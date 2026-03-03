import '../repositories/auth_repository.dart';

class VerifyOtpUseCase {
  VerifyOtpUseCase(this._repo);
  final AuthRepository _repo;

  Future<Result<void>> call({required String email, required String code}) {
    return _repo.verifyOtpCode(email: email, code: code);
  }
}
