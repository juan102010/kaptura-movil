import '../repositories/users_repository.dart';

class GetUsersUseCase {
  final UsersRepository repository;

  GetUsersUseCase(this.repository);

  /// Trae usuarios desde remoto y actualiza cache
  Future<List<Map<String, dynamic>>> call() async {
    final users = await repository.getRemoteUsers();

    if (users.isNotEmpty) {
      await repository.cacheUsers(users);
    }

    return users;
  }
}
