abstract class ProjectsRepository {
  Future<List<Map<String, dynamic>>> getProjectsRemote();

  Future<void> saveProjectsCache(List<Map<String, dynamic>> rawProjects);

  Future<List<Map<String, dynamic>>> getProjectsCache();

  Future<void> clearProjectsCache();
}
