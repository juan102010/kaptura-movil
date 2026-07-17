import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/inventory_item_entity.dart';
import '../../domain/repositories/inventory_repository.dart';
import '../../domain/usecases/get_inventories_usecase.dart';
import '../../domain/usecases/update_inventory_quantities_usecase.dart';

class InventoryState {
  const InventoryState({
    required this.loading,
    required this.saving,
    required this.items,
    required this.error,
    required this.fromCache,
    required this.selectedItemId,
  });

  final bool loading;
  final bool saving;
  final List<InventoryItemEntity> items;
  final String? error;
  final bool fromCache;
  final String? selectedItemId;

  factory InventoryState.initial() {
    return const InventoryState(
      loading: false,
      saving: false,
      items: <InventoryItemEntity>[],
      error: null,
      fromCache: false,
      selectedItemId: null,
    );
  }

  InventoryItemEntity? get selectedItem {
    final id = selectedItemId;
    if (id == null || id.isEmpty) return null;

    for (final item in items) {
      if (item.matchesId(id)) return item;
    }
    return null;
  }

  InventoryState copyWith({
    bool? loading,
    bool? saving,
    List<InventoryItemEntity>? items,
    String? error,
    bool clearError = false,
    bool? fromCache,
    String? selectedItemId,
    bool clearSelectedItem = false,
  }) {
    return InventoryState(
      loading: loading ?? this.loading,
      saving: saving ?? this.saving,
      items: items ?? this.items,
      error: clearError ? null : (error ?? this.error),
      fromCache: fromCache ?? this.fromCache,
      selectedItemId: clearSelectedItem
          ? null
          : (selectedItemId ?? this.selectedItemId),
    );
  }
}

class InventoryController extends StateNotifier<InventoryState> {
  InventoryController({
    required this.getInventoriesUsecase,
    required this.updateInventoryQuantitiesUsecase,
    required this.inventoryRepository,
  }) : super(InventoryState.initial());

  final GetInventoriesUsecase getInventoriesUsecase;
  final UpdateInventoryQuantitiesUsecase updateInventoryQuantitiesUsecase;
  final InventoryRepository inventoryRepository;

  Future<void> loadCacheThenRemote() async {
    state = state.copyWith(loading: true, clearError: true);

    try {
      final cachedItems = await inventoryRepository.getCachedInventories();
      if (cachedItems.isNotEmpty) {
        state = state.copyWith(
          loading: true,
          items: _sortItems(cachedItems),
          fromCache: true,
          clearError: true,
        );
      }

      final remoteItems = await getInventoriesUsecase();
      state = state.copyWith(
        loading: false,
        items: _sortItems(remoteItems),
        fromCache: false,
        clearError: true,
      );
    } catch (e) {
      final cachedItems = await inventoryRepository.getCachedInventories();
      if (cachedItems.isNotEmpty) {
        state = state.copyWith(
          loading: false,
          items: _sortItems(cachedItems),
          fromCache: true,
          error: 'No se pudo actualizar inventories. Mostrando cache local.',
        );
        return;
      }

      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<void> refreshRemoteOnly() async {
    state = state.copyWith(loading: true, clearError: true);

    try {
      final remoteItems = await getInventoriesUsecase();
      state = state.copyWith(
        loading: false,
        items: _sortItems(remoteItems),
        fromCache: false,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  void selectItemById(String? id) {
    final nextId = (id ?? '').trim();
    if (nextId.isEmpty) {
      state = state.copyWith(clearSelectedItem: true);
      return;
    }

    state = state.copyWith(selectedItemId: nextId);
  }

  InventoryItemEntity? findById(String id) {
    final cleanId = id.trim();
    if (cleanId.isEmpty) return null;

    for (final item in state.items) {
      if (item.matchesId(cleanId)) return item;
    }
    return null;
  }

  Future<InventoryItemEntity> updateSelectedItemQuantities({
    required InventoryItemEntity item,
    required int newDefaultQty,
    required int newStockMin,
  }) async {
    state = state.copyWith(saving: true, clearError: true);

    try {
      final updated = await updateInventoryQuantitiesUsecase(
        currentItem: item,
        newDefaultQty: newDefaultQty,
        newStockMin: newStockMin,
      );

      final nextItems = state.items
          .map((current) => current.matchesId(updated.id) ? updated : current)
          .toList();

      state = state.copyWith(
        saving: false,
        items: _sortItems(nextItems),
        selectedItemId: updated.id,
        clearError: true,
      );

      return updated;
    } catch (e) {
      state = state.copyWith(saving: false, error: e.toString());
      rethrow;
    }
  }

  List<InventoryItemEntity> _sortItems(List<InventoryItemEntity> items) {
    final next = List<InventoryItemEntity>.from(items);
    next.sort(
      (a, b) => a.itemName.toLowerCase().compareTo(b.itemName.toLowerCase()),
    );
    return next;
  }
}
