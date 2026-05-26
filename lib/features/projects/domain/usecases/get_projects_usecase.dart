import '../entities/project_entity.dart';
import '../repositories/projects_repository.dart';

class GetProjectsUsecase {
  GetProjectsUsecase(this._repository);

  final ProjectsRepository _repository;

  Future<List<ProjectEntity>> getRemote() {
    return _repository.getProjectsRemote();
  }

  Future<void> saveCache(List<ProjectEntity> projects) {
    return _repository.saveProjectsCache(projects);
  }

  Future<List<ProjectEntity>> getCache() {
    return _repository.getProjectsCache();
  }

  Future<void> clearCache() {
    return _repository.clearProjectsCache();
  }
}
