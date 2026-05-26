import '../entities/user_list_entity.dart';
import '../repositories/users_repository.dart';

class GetUsersUseCase {
  GetUsersUseCase(this.repository);

  final UsersRepository repository;

  Future<List<UserListEntity>> call() async {
    final users = await repository.getRemoteUsers();

    if (users.isNotEmpty) {
      await repository.cacheUsers(users);
    }

    return users;
  }
}
