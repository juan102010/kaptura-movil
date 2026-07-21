import 'package:dio/dio.dart';

import '../../../../core/services/update_data_by_id_service.dart';
import '../models/inventory_item_model.dart';

abstract class InventoryRemoteDataSource {
  Future<List<InventoryItemModel>> getInventories();
  Future<InventoryItemModel> updateInventoryQuantities({
    required InventoryItemModel currentItem,
    required int newDefaultQty,
    required int newStockMin,
  });
}

class InventoryRemoteDataSourceImpl implements InventoryRemoteDataSource {
  InventoryRemoteDataSourceImpl({
    required this.apiDio,
    required this.updateService,
  });

  final Dio apiDio;
  final UpdateDataByIdService updateService;

  @override
  Future<List<InventoryItemModel>> getInventories() async {
    final response = await apiDio.get(
      '/api/dynamicRow/get-data-table',
      queryParameters: {'nombre_de_tabla': 'inventories'},
    );

    final body = _asMap(response.data);
    _ensureOk(body);

    final rawList = body['data'];
    if (rawList is! List) return <InventoryItemModel>[];

    return rawList
        .whereType<Map>()
        .map(
          (item) => InventoryItemModel.fromMap(Map<String, dynamic>.from(item)),
        )
        .where((item) => item.id.isNotEmpty)
        .toList();
  }

  @override
  Future<InventoryItemModel> updateInventoryQuantities({
    required InventoryItemModel currentItem,
    required int newDefaultQty,
    required int newStockMin,
  }) async {
    final result = await updateService.update(
      tableName: 'inventories',
      id: currentItem.id,
      data: {
        'num_defaultQty_id': {
          'oldValue': currentItem.defaultQty,
          'newValue': newDefaultQty,
        },
        'num_stocMin_id': {
          'oldValue': currentItem.stockMin,
          'newValue': newStockMin,
        },
      },
    );

    if (!result.wasQueued) {
      _ensureOk(_asMap(result.response));
    }

    final nextMap = currentItem.toMap()
      ..['num_defaultQty_id'] = newDefaultQty
      ..['num_stocMin_id'] = newStockMin
      ..['updatedAt'] = DateTime.now().toUtc().toIso8601String();

    return InventoryItemModel.fromMap(nextMap);
  }

  Map<String, dynamic> _asMap(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    throw Exception('Respuesta invalida de inventories.');
  }

  void _ensureOk(Map<String, dynamic> body) {
    final success =
        body['success'] == true ||
        body['ok'] == true ||
        body['status'] == true ||
        body['code'] == 200;

    if (success) return;

    final message =
        (body['message'] ??
                body['msg'] ??
                body['error'] ??
                'No fue posible procesar inventories.')
            .toString();
    throw Exception(message);
  }
}
