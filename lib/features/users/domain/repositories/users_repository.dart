import '../entities/user_list_entity.dart';

abstract class UsersRepository {
  Future<List<UserListEntity>> getCachedUsers();
  Future<List<UserListEntity>> getRemoteUsers();
  Future<void> cacheUsers(List<UserListEntity> users);
  Future<void> clearUsers();
}
