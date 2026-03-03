import '../repositories/home_repository.dart';

class GetMyWorkOrdersUsecase {
  GetMyWorkOrdersUsecase(this._repo);

  final HomeRepository _repo;

  /// Cache-first:
  /// - Devuelve primero cache (si existe)
  /// - Luego trae remoto, filtra, guarda cache y devuelve remoto filtrado
  ///
  /// En el controller lo puedes llamar con "await" y actualizar estado 2 veces
  /// (primero cache, luego remoto). En este usecase devolvemos solo el resultado final,
  /// pero también exponemos un método para leer cache aparte si lo prefieres.
  Future<List<Map<String, dynamic>>> call({required String userId}) async {
    final remote = await _repo.getWorkOrdersRemote();
    final filtered = _filterByAssigned(remote, userId);

    // Guardamos cache ya filtrada para que la UI siempre muestre "lo mío"
    await _repo.saveWorkOrdersCache(filtered);

    return filtered;
  }

  /// Para mostrar rápido mientras llega remoto
  Future<List<Map<String, dynamic>>> getCached() async {
    return _repo.getWorkOrdersCache();
  }

  List<Map<String, dynamic>> _filterByAssigned(
    List<Map<String, dynamic>> list,
    String userId,
  ) {
    return list.where((row) {
      final assigned = row['text_assigned_id'];

      if (assigned == null) return false;

      // Puede venir String
      if (assigned is String) {
        return assigned.trim() == userId;
      }

      // Puede venir List
      if (assigned is List) {
        return assigned
            .map((e) => e.toString().trim())
            .where((e) => e.isNotEmpty)
            .contains(userId);
      }

      return false;
    }).toList();
  }
}
