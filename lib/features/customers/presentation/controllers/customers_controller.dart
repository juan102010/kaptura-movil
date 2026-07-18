import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/customer_entity.dart';
import '../../domain/usecases/get_customers_usecase.dart';

class CustomersState {
  const CustomersState({
    required this.loading,
    required this.customers,
    required this.error,
    required this.fromCache,
  });

  final bool loading;
  final List<CustomerEntity> customers;
  final String? error;
  final bool fromCache;

  factory CustomersState.initial() => const CustomersState(
    loading: false,
    customers: <CustomerEntity>[],
    error: null,
    fromCache: false,
  );

  CustomersState copyWith({
    bool? loading,
    List<CustomerEntity>? customers,
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

  Future<void> loadCacheThenRemote() async {
    state = state.copyWith(loading: true, error: null);

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
    } catch (_) {}

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
      customers: const <CustomerEntity>[],
      fromCache: false,
    );
  }

  Future<void> applyCustomerPatch(
    String customerId,
    Map<String, dynamic> patch,
  ) async {
    final updated = state.customers
        .map(
          (customer) => customer.matchesId(customerId)
              ? customer.withPatchedRawData(patch)
              : customer,
        )
        .toList(growable: false);
    state = state.copyWith(customers: updated);
    await _usecase.saveCached(updated);
  }
}
