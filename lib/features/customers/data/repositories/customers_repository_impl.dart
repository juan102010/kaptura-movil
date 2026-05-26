import '../../domain/entities/customer_entity.dart';
import '../../domain/repositories/customers_repository.dart';
import '../datasources/customers_local_datasource.dart';
import '../datasources/customers_remote_datasource.dart';
import '../models/customer_model.dart';

class CustomersRepositoryImpl implements CustomersRepository {
  CustomersRepositoryImpl(this._remote, this._local);

  final CustomersRemoteDataSource _remote;
  final CustomersLocalDataSource _local;

  @override
  Future<List<CustomerEntity>> getCustomersRemote() {
    return _remote.getCustomers();
  }

  @override
  Future<void> saveCustomersCache(List<CustomerEntity> customers) {
    return _local.upsertCustomersCache(
      customers.map((item) => CustomerModel.fromMap(item.rawData)).toList(),
    );
  }

  @override
  Future<List<CustomerEntity>> getCustomersCache() {
    return _local.getCustomersCacheRaw();
  }

  @override
  Future<void> clearCustomersCache() {
    return _local.clearCustomersCache();
  }
}
