import '../../domain/repositories/customers_repository.dart';
import '../datasources/customers_local_datasource.dart';
import '../datasources/customers_remote_datasource.dart';

class CustomersRepositoryImpl implements CustomersRepository {
  CustomersRepositoryImpl(this._remote, this._local);

  final CustomersRemoteDataSource _remote;
  final CustomersLocalDataSource _local;

  @override
  Future<List<Map<String, dynamic>>> getCustomersRemote() {
    return _remote.getCustomers();
  }

  @override
  Future<void> saveCustomersCache(List<Map<String, dynamic>> rawCustomers) {
    return _local.upsertCustomersCache(rawCustomers);
  }

  @override
  Future<List<Map<String, dynamic>>> getCustomersCache() {
    return _local.getCustomersCacheRaw();
  }

  @override
  Future<void> clearCustomersCache() {
    return _local.clearCustomersCache();
  }
}
