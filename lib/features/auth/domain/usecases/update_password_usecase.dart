import '../repositories/auth_repository.dart';

class UpdatePasswordUseCase {
  UpdatePasswordUseCase(this._repo);
  final AuthRepository _repo;

  Future<Result<void>> call({required String email, required String password}) {
    return _repo.updatePassword(email: email, password: password);
  }
}
