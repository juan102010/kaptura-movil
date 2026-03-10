abstract class UsersRepository {
  Future<List<Map<String, dynamic>>> getCachedUsers();
  Future<List<Map<String, dynamic>>> getRemoteUsers();
  Future<void> cacheUsers(List<Map<String, dynamic>> users);
  Future<void> clearUsers();
}
