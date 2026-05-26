import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/update_work_order_time_history_usecase.dart';
import 'work_order_time_action_state.dart';

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
