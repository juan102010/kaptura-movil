import '../entities/home_entity.dart';
import '../repositories/home_repository.dart';

class FetchUserUsecase {
  FetchUserUsecase(this._repository);

  final HomeRepository _repository;

  Future<HomeEntity> call({required String userId}) {
    return _repository.getUserById(userId: userId);
  }
}
