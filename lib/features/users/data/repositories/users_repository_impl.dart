import '../../domain/repositories/users_repository.dart';
import '../datasources/users_local_datasource.dart';
import '../datasources/users_remote_datasource.dart';

class UsersRepositoryImpl implements UsersRepository {
  final UsersRemoteDataSource remoteDataSource;
  final UsersLocalDataSource localDataSource;

  UsersRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<Map<String, dynamic>>> getCachedUsers() {
    return localDataSource.getCachedUsers();
  }

  @override
  Future<List<Map<String, dynamic>>> getRemoteUsers() {
    return remoteDataSource.getUsers();
  }

  @override
  Future<void> cacheUsers(List<Map<String, dynamic>> users) {
    return localDataSource.cacheUsers(users);
  }

  @override
  Future<void> clearUsers() {
    return localDataSource.clearUsers();
  }
}
