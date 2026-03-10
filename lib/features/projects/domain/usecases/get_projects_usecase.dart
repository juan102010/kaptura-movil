import '../repositories/projects_repository.dart';

class GetProjectsUsecase {
  GetProjectsUsecase(this._repository);

  final ProjectsRepository _repository;

  Future<List<Map<String, dynamic>>> getRemote() {
    return _repository.getProjectsRemote();
  }

  Future<void> saveCache(List<Map<String, dynamic>> rawProjects) {
    return _repository.saveProjectsCache(rawProjects);
  }

  Future<List<Map<String, dynamic>>> getCache() {
    return _repository.getProjectsCache();
  }

  Future<void> clearCache() {
    return _repository.clearProjectsCache();
  }
}
