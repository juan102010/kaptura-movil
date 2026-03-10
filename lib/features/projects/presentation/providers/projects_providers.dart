import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/local_db/app_database.dart';
import '../../../../core/local_db/app_database_provider.dart';
import '../../../../app/di/providers.dart';

import '../../data/datasources/projects_local_datasource.dart';
import '../../data/datasources/projects_remote_datasource.dart';
import '../../data/repositories/projects_repository_impl.dart';
import '../../domain/repositories/projects_repository.dart';
import '../../domain/usecases/get_projects_usecase.dart';
import 'projects_controller.dart';

final projectsRemoteDataSourceProvider = Provider<ProjectsRemoteDataSource>((
  ref,
) {
  final apiDio = ref.watch(dioClientsProvider);
  return ProjectsRemoteDataSource(apiDio: apiDio.api);
});

final projectsLocalDataSourceProvider = Provider<ProjectsLocalDataSource>((
  ref,
) {
  final AppDatabase db = ref.watch(appDatabaseProvider);
  return ProjectsLocalDataSource(database: db);
});

final projectsRepositoryProvider = Provider<ProjectsRepository>((ref) {
  final remote = ref.watch(projectsRemoteDataSourceProvider);
  final local = ref.watch(projectsLocalDataSourceProvider);

  return ProjectsRepositoryImpl(
    remoteDataSource: remote,
    localDataSource: local,
  );
});

final getProjectsUsecaseProvider = Provider<GetProjectsUsecase>((ref) {
  final repo = ref.watch(projectsRepositoryProvider);
  return GetProjectsUsecase(repo);
});

final projectsControllerProvider =
    StateNotifierProvider<ProjectsController, ProjectsState>((ref) {
      final usecase = ref.watch(getProjectsUsecaseProvider);
      return ProjectsController(getProjectsUsecase: usecase);
    });
