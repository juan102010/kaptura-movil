import '../entities/project_entity.dart';

abstract class ProjectsRepository {
  Future<List<ProjectEntity>> getProjectsRemote();
  Future<void> saveProjectsCache(List<ProjectEntity> projects);
  Future<List<ProjectEntity>> getProjectsCache();
  Future<void> clearProjectsCache();
}
