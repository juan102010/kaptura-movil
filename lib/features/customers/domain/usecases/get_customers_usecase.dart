import '../entities/customer_entity.dart';
import '../repositories/customers_repository.dart';

class GetCustomersUsecase {
  GetCustomersUsecase(this._repo);

  final CustomersRepository _repo;

  Future<List<CustomerEntity>> call() async {
    final remote = await _repo.getCustomersRemote();
    await _repo.saveCustomersCache(remote);
    return remote;
  }

  Future<List<CustomerEntity>> getCached() async {
    return _repo.getCustomersCache();
  }

  Future<void> clearCache() async {
    return _repo.clearCustomersCache();
  }
}
