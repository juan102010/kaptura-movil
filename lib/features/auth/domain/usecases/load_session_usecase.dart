import '../repositories/auth_repository.dart';

class LoadSessionUseCase {
  LoadSessionUseCase(this._repo);

  final AuthRepository _repo;

  Future<Result<String?>> call() {
    return _repo.getValidToken();
  }
}
