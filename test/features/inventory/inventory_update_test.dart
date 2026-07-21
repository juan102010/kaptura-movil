import 'package:dio/dio.dart';
import 'package:flutter_kaptura/core/services/update_data_by_id_service.dart';
import 'package:flutter_kaptura/features/inventory/data/datasources/inventory_remote_datasource.dart';
import 'package:flutter_kaptura/features/inventory/data/models/inventory_item_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockDio extends Mock implements Dio {}

class _MockUpdateDataByIdService extends Mock
    implements UpdateDataByIdService {}

void main() {
  test(
    'updates inventory through the shared offline-capable service',
    () async {
      final updateService = _MockUpdateDataByIdService();
      final dataSource = InventoryRemoteDataSourceImpl(
        apiDio: _MockDio(),
        updateService: updateService,
      );
      final current = InventoryItemModel.fromMap({
        '_id': 'inventory-1',
        'text_itemName_id': 'Cable',
        'num_defaultQty_id': 4,
        'num_stocMin_id': 2,
        'swt_state_id': true,
      });

      when(
        () => updateService.update(
          tableName: 'inventories',
          id: 'inventory-1',
          data: {
            'num_defaultQty_id': {'oldValue': 4, 'newValue': 8},
            'num_stocMin_id': {'oldValue': 2, 'newValue': 3},
          },
        ),
      ).thenAnswer((_) async => const UpdateDataResult.queued());

      final updated = await dataSource.updateInventoryQuantities(
        currentItem: current,
        newDefaultQty: 8,
        newStockMin: 3,
      );

      expect(updated.defaultQty, 8);
      expect(updated.stockMin, 3);
      verify(
        () => updateService.update(
          tableName: 'inventories',
          id: 'inventory-1',
          data: {
            'num_defaultQty_id': {'oldValue': 4, 'newValue': 8},
            'num_stocMin_id': {'oldValue': 2, 'newValue': 3},
          },
        ),
      ).called(1);
    },
  );
}
