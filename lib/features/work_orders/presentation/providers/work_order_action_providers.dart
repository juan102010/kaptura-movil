import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/providers.dart';
import '../../data/datasources/work_order_remote_datasource.dart';
import '../../data/repositories/work_order_repository_impl.dart';
import '../../domain/usecases/update_work_order_time_history_usecase.dart';
import '../controllers/work_order_time_action_controller.dart';
import '../controllers/work_order_time_action_state.dart';

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
