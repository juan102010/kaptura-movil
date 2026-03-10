import '../../domain/repositories/projects_repository.dart';
import '../datasources/projects_local_datasource.dart';
import '../datasources/projects_remote_datasource.dart';

class ProjectsRepositoryImpl implements ProjectsRepository {
  ProjectsRepositoryImpl({
    required ProjectsRemoteDataSource remoteDataSource,
    required ProjectsLocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  final ProjectsRemoteDataSource _remoteDataSource;
  final ProjectsLocalDataSource _localDataSource;

  @override
  Future<List<Map<String, dynamic>>> getProjectsRemote() {
    return _remoteDataSource.getProjects();
  }

  @override
  Future<void> saveProjectsCache(List<Map<String, dynamic>> rawProjects) {
    return _localDataSource.upsertProjectsCache(rawProjects);
  }

  @override
  Future<List<Map<String, dynamic>>> getProjectsCache() {
    return _localDataSource.getProjectsCacheRaw();
  }

  @override
  Future<void> clearProjectsCache() {
    return _localDataSource.clearProjectsCache();
  }
}
