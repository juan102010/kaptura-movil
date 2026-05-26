import '../../domain/entities/user_list_entity.dart';
import '../../domain/repositories/users_repository.dart';
import '../datasources/users_local_datasource.dart';
import '../datasources/users_remote_datasource.dart';
import '../models/user_list_model.dart';

class UsersRepositoryImpl implements UsersRepository {
  UsersRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  final UsersRemoteDataSource remoteDataSource;
  final UsersLocalDataSource localDataSource;

  @override
  Future<List<UserListEntity>> getCachedUsers() {
    return localDataSource.getCachedUsers();
  }

  @override
  Future<List<UserListEntity>> getRemoteUsers() {
    return remoteDataSource.getUsers();
  }

  @override
  Future<void> cacheUsers(List<UserListEntity> users) {
    return localDataSource.cacheUsers(
      users.map((item) => UserListModel.fromMap(item.rawData)).toList(),
    );
  }

  @override
  Future<void> clearUsers() {
    return localDataSource.clearUsers();
  }
}
