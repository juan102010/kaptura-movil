import '../repositories/auth_repository.dart';

class ClearSessionUseCase {
  ClearSessionUseCase(this._repo);

  final AuthRepository _repo;

  Future<Result<void>> call() {
    return _repo.clearSession();
  }
}
