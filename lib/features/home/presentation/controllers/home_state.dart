import '../../../work_orders/domain/entities/work_order_entity.dart';
import '../../domain/entities/home_entity.dart';
import '../../domain/entities/time_report_entity.dart';

enum HomeStatus { initial, loading, ready, error }

class HomeState {
  const HomeState({
    required this.status,
    required this.loadingUser,
    required this.savingClock,
    required this.user,
    required this.errorMessage,
    required this.loadingWorkOrders,
    required this.workOrders,
    required this.todayWorkOrders,
    required this.filteredWorkOrders,
    required this.selectedWorkOrdersDate,
    required this.workOrdersError,
    required this.loadingLatestTimeReport,
    required this.latestTimeReport,
  });

  final HomeStatus status;
  final bool loadingUser;
  final bool savingClock;
  final HomeEntity? user;
  final String? errorMessage;

  final bool loadingWorkOrders;
  final List<WorkOrderEntity> workOrders;
  final List<WorkOrderEntity> todayWorkOrders;
  final List<WorkOrderEntity> filteredWorkOrders;
  final DateTime selectedWorkOrdersDate;
  final String? workOrdersError;

  final bool loadingLatestTimeReport;
  final TimeReportEntity? latestTimeReport;

  factory HomeState.initial() {
    final today = DateTime.now();
    final normalizedToday = DateTime(today.year, today.month, today.day);

    return HomeState(
      status: HomeStatus.initial,
      loadingUser: false,
      savingClock: false,
      user: null,
      errorMessage: null,
      loadingWorkOrders: false,
      workOrders: const <WorkOrderEntity>[],
      todayWorkOrders: const <WorkOrderEntity>[],
      filteredWorkOrders: const <WorkOrderEntity>[],
      selectedWorkOrdersDate: normalizedToday,
      workOrdersError: null,
      loadingLatestTimeReport: false,
      latestTimeReport: null,
    );
  }

  HomeState copyWith({
    HomeStatus? status,
    bool? loadingUser,
    bool? savingClock,
    HomeEntity? user,
    String? errorMessage,
    bool? loadingWorkOrders,
    List<WorkOrderEntity>? workOrders,
    List<WorkOrderEntity>? todayWorkOrders,
    List<WorkOrderEntity>? filteredWorkOrders,
    DateTime? selectedWorkOrdersDate,
    String? workOrdersError,
    bool? loadingLatestTimeReport,
    TimeReportEntity? latestTimeReport,
  }) {
    return HomeState(
      status: status ?? this.status,
      loadingUser: loadingUser ?? this.loadingUser,
      savingClock: savingClock ?? this.savingClock,
      user: user ?? this.user,
      errorMessage: errorMessage,
      loadingWorkOrders: loadingWorkOrders ?? this.loadingWorkOrders,
      workOrders: workOrders ?? this.workOrders,
      todayWorkOrders: todayWorkOrders ?? this.todayWorkOrders,
      filteredWorkOrders: filteredWorkOrders ?? this.filteredWorkOrders,
      selectedWorkOrdersDate:
          selectedWorkOrdersDate ?? this.selectedWorkOrdersDate,
      workOrdersError: workOrdersError,
      loadingLatestTimeReport:
          loadingLatestTimeReport ?? this.loadingLatestTimeReport,
      latestTimeReport: latestTimeReport ?? this.latestTimeReport,
    );
  }
}
