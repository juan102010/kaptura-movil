import '../repositories/auth_repository.dart';

class SendOtpUseCase {
  SendOtpUseCase(this._repo);
  final AuthRepository _repo;

  Future<Result<void>> call(String email) => _repo.sendOtpByEmail(email);
}
