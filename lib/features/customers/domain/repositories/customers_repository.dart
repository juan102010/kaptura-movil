abstract class CustomersRepository {
  Future<List<Map<String, dynamic>>> getCustomersRemote();
  Future<void> saveCustomersCache(List<Map<String, dynamic>> rawCustomers);
  Future<List<Map<String, dynamic>>> getCustomersCache();
  Future<void> clearCustomersCache();
}
