import '../repositories/auth_repository.dart';

class SaveSessionUseCase {
  SaveSessionUseCase(this._repo);

  final AuthRepository _repo;

  Future<Result<void>> call({
    required String token,
    required Duration ttl,
    required Map<String, dynamic> user,
    required String scheme,
    required String schemeId,
    required String idPlans,
  }) {
    return _repo.saveFullSession(
      token: token,
      ttl: ttl,
      user: user,
      scheme: scheme,
      schemeId: schemeId,
      idPlans: idPlans,
    );
  }
}
