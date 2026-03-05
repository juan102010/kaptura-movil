import '../repositories/customers_repository.dart';

class GetCustomersUsecase {
  GetCustomersUsecase(this._repo);

  final CustomersRepository _repo;

  /// Sin filtro:
  /// - Trae remoto
  /// - Guarda en cache
  /// - Retorna remoto
  Future<List<Map<String, dynamic>>> call() async {
    final remote = await _repo.getCustomersRemote();
    await _repo.saveCustomersCache(remote);
    return remote;
  }

  /// Para mostrar rápido mientras llega remoto (o cuando estás offline)
  Future<List<Map<String, dynamic>>> getCached() async {
    return _repo.getCustomersCache();
  }

  Future<void> clearCache() async {
    return _repo.clearCustomersCache();
  }
}
