import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/providers.dart';

import '../../data/datasources/work_order_remote_datasource.dart';
import '../../data/repositories/work_order_repository_impl.dart';
import '../../domain/usecases/update_work_order_time_history_usecase.dart';
import 'work_order_time_action_state.dart';

final workOrderRemoteDataSourceProvider = Provider<WorkOrderRemoteDataSource>((
  ref,
) {
  final apiDio = ref.watch(dioClientsProvider);
  return WorkOrderRemoteDataSource(apiDio.api);
});

final workOrderRepositoryProvider = Provider<WorkOrderRepositoryImpl>((ref) {
  final remote = ref.watch(workOrderRemoteDataSourceProvider);
  return WorkOrderRepositoryImpl(remote);
});

final updateWorkOrderTimeHistoryUsecaseProvider =
    Provider<UpdateWorkOrderTimeHistoryUsecase>((ref) {
      final repository = ref.watch(workOrderRepositoryProvider);
      return UpdateWorkOrderTimeHistoryUsecase(repository);
    });

final workOrderTimeActionControllerProvider =
    StateNotifierProvider<
      WorkOrderTimeActionController,
      WorkOrderTimeActionState
    >((ref) {
      final usecase = ref.watch(updateWorkOrderTimeHistoryUsecaseProvider);
      return WorkOrderTimeActionController(usecase);
    });

class WorkOrderTimeActionController
    extends StateNotifier<WorkOrderTimeActionState> {
  WorkOrderTimeActionController(this._updateUsecase)
    : super(WorkOrderTimeActionState.initial());

  final UpdateWorkOrderTimeHistoryUsecase _updateUsecase;

  Future<bool> updateTimeHistoryDiff({
    required String workOrderId,
    required List<Map<String, dynamic>> oldValue,
    required List<Map<String, dynamic>> newValue,
  }) async {
    state = state.copyWith(
      isLoading: true,
      clearErrorMessage: true,
      clearLastSuccessMessage: true,
    );

    try {
      await _updateUsecase(
        workOrderId: workOrderId,
        oldValue: oldValue,
        newValue: newValue,
      );

      state = state.copyWith(
        isLoading: false,
        lastSuccessMessage: 'Historial actualizado correctamente.',
      );

      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  void clearMessages() {
    state = state.copyWith(
      clearErrorMessage: true,
      clearLastSuccessMessage: true,
    );
  }
}
