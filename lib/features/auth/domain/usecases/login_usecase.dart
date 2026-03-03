import '../entities/auth_session_entity.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  LoginUseCase(this._repo);
  final AuthRepository _repo;

  Future<Result<AuthSessionEntity>> call({
    required String email,
    required String password,
  }) {
    return _repo.login(email: email, password: password);
  }
}
