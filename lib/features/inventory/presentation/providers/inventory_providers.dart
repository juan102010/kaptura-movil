import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/providers.dart';
import '../../../../core/local_db/app_database.dart';
import '../../../../core/local_db/app_database_provider.dart';
import '../../data/datasources/inventory_local_datasource.dart';
import '../../data/datasources/inventory_remote_datasource.dart';
import '../../data/repositories/inventory_repository_impl.dart';
import '../../domain/repositories/inventory_repository.dart';
import '../../domain/usecases/get_inventories_usecase.dart';
import '../../domain/usecases/update_inventory_quantities_usecase.dart';
import '../controllers/inventory_controller.dart';

final inventoryRemoteDataSourceProvider = Provider<InventoryRemoteDataSource>((
  ref,
) {
  final dioClients = ref.watch(dioClientsProvider);
  return InventoryRemoteDataSourceImpl(apiDio: dioClients.api);
});

final inventoryLocalDataSourceProvider = Provider<InventoryLocalDataSource>((
  ref,
) {
  final AppDatabase database = ref.watch(appDatabaseProvider);
  return InventoryLocalDataSourceImpl(database: database);
});

final inventoryRepositoryProvider = Provider<InventoryRepository>((ref) {
  return InventoryRepositoryImpl(
    remoteDataSource: ref.watch(inventoryRemoteDataSourceProvider),
    localDataSource: ref.watch(inventoryLocalDataSourceProvider),
  );
});

final getInventoriesUsecaseProvider = Provider<GetInventoriesUsecase>((ref) {
  return GetInventoriesUsecase(ref.watch(inventoryRepositoryProvider));
});

final updateInventoryQuantitiesUsecaseProvider =
    Provider<UpdateInventoryQuantitiesUsecase>((ref) {
      return UpdateInventoryQuantitiesUsecase(
        ref.watch(inventoryRepositoryProvider),
      );
    });

final inventoryControllerProvider =
    StateNotifierProvider<InventoryController, InventoryState>((ref) {
      return InventoryController(
        getInventoriesUsecase: ref.watch(getInventoriesUsecaseProvider),
        updateInventoryQuantitiesUsecase: ref.watch(
          updateInventoryQuantitiesUsecaseProvider,
        ),
        inventoryRepository: ref.watch(inventoryRepositoryProvider),
      );
    });
