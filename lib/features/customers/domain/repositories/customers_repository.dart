import '../entities/customer_entity.dart';

abstract class CustomersRepository {
  Future<List<CustomerEntity>> getCustomersRemote();
  Future<void> saveCustomersCache(List<CustomerEntity> customers);
  Future<List<CustomerEntity>> getCustomersCache();
  Future<void> clearCustomersCache();
}
