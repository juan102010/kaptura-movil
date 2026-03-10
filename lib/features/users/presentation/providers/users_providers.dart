import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/providers.dart';
import '../../../../core/local_db/app_database.dart';
import '../../../../core/local_db/app_database_provider.dart';

import '../../data/datasources/users_local_datasource.dart';
import '../../data/datasources/users_remote_datasource.dart';
import '../../data/repositories/users_repository_impl.dart';
import '../../domain/repositories/users_repository.dart';
import '../../domain/usecases/get_users_usecase.dart';
import 'users_controller.dart';

final usersRemoteDataSourceProvider = Provider<UsersRemoteDataSource>((ref) {
  final dioClients = ref.watch(dioClientsProvider);

  return UsersRemoteDataSourceImpl(apiDio: dioClients.login);
});

final usersLocalDataSourceProvider = Provider<UsersLocalDataSource>((ref) {
  final AppDatabase db = ref.watch(appDatabaseProvider);

  return UsersLocalDataSourceImpl(database: db);
});

final usersRepositoryProvider = Provider<UsersRepository>((ref) {
  final remote = ref.watch(usersRemoteDataSourceProvider);
  final local = ref.watch(usersLocalDataSourceProvider);

  return UsersRepositoryImpl(remoteDataSource: remote, localDataSource: local);
});

final getUsersUsecaseProvider = Provider<GetUsersUseCase>((ref) {
  final repo = ref.watch(usersRepositoryProvider);
  return GetUsersUseCase(repo);
});

final usersControllerProvider =
    StateNotifierProvider<UsersController, UsersState>((ref) {
      final usecase = ref.watch(getUsersUsecaseProvider);
      final repo = ref.watch(usersRepositoryProvider);

      return UsersController(getUsersUseCase: usecase, usersRepository: repo);
    });
