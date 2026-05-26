import '../../domain/entities/project_entity.dart';
import '../../domain/repositories/projects_repository.dart';
import '../datasources/projects_local_datasource.dart';
import '../datasources/projects_remote_datasource.dart';
import '../models/project_model.dart';

class ProjectsRepositoryImpl implements ProjectsRepository {
  ProjectsRepositoryImpl({
    required ProjectsRemoteDataSource remoteDataSource,
    required ProjectsLocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  final ProjectsRemoteDataSource _remoteDataSource;
  final ProjectsLocalDataSource _localDataSource;

  @override
  Future<List<ProjectEntity>> getProjectsRemote() {
    return _remoteDataSource.getProjects();
  }

  @override
  Future<void> saveProjectsCache(List<ProjectEntity> projects) {
    return _localDataSource.upsertProjectsCache(
      projects.map((item) => ProjectModel.fromMap(item.rawData)).toList(),
    );
  }

  @override
  Future<List<ProjectEntity>> getProjectsCache() {
    return _localDataSource.getProjectsCacheRaw();
  }

  @override
  Future<void> clearProjectsCache() {
    return _localDataSource.clearProjectsCache();
  }
}
