import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/get_customers_usecase.dart';
import '../providers/customers_providers.dart';

class CustomersState {
  final bool loading;
  final List<Map<String, dynamic>> customers;
  final String? error;
  final bool fromCache;

  const CustomersState({
    required this.loading,
    required this.customers,
    required this.error,
    required this.fromCache,
  });

  factory CustomersState.initial() => const CustomersState(
    loading: false,
    customers: <Map<String, dynamic>>[],
    error: null,
    fromCache: false,
  );

  CustomersState copyWith({
    bool? loading,
    List<Map<String, dynamic>>? customers,
    String? error,
    bool? fromCache,
  }) {
    return CustomersState(
      loading: loading ?? this.loading,
      customers: customers ?? this.customers,
      error: error,
      fromCache: fromCache ?? this.fromCache,
    );
  }
}

class CustomersController extends StateNotifier<CustomersState> {
  CustomersController(this._usecase) : super(CustomersState.initial());

  final GetCustomersUsecase _usecase;

  /// Cache-first UI:
  /// 1) emite cache (si hay)
  /// 2) luego intenta remoto y reemplaza
  Future<void> loadCacheThenRemote() async {
    state = state.copyWith(loading: true, error: null);

    // 1) cache primero
    try {
      final cached = await _usecase.getCached();
      if (cached.isNotEmpty) {
        state = state.copyWith(
          loading: true,
          customers: cached,
          fromCache: true,
          error: null,
        );
      }
    } catch (_) {
      // Si cache falla, no tumbamos el flujo
    }

    // 2) remoto
    try {
      final remote = await _usecase();
      state = state.copyWith(
        loading: false,
        customers: remote,
        fromCache: false,
        error: null,
      );
    } catch (e) {
      // Si falla remoto, dejamos lo que haya (cache o vacío)
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  /// Solo remoto (ej: pull-to-refresh)
  Future<void> refreshRemoteOnly() async {
    state = state.copyWith(loading: true, error: null);
    try {
      final remote = await _usecase();
      state = state.copyWith(
        loading: false,
        customers: remote,
        fromCache: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<void> clearCache() async {
    await _usecase.clearCache();
    state = state.copyWith(
      customers: <Map<String, dynamic>>[],
      fromCache: false,
    );
  }
}

final customersControllerProvider =
    StateNotifierProvider<CustomersController, CustomersState>((ref) {
      final usecase = ref.watch(getCustomersUsecaseProvider);
      return CustomersController(usecase);
    });
