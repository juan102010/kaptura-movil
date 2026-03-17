import '../../domain/entities/home_entity.dart';

enum HomeStatus { initial, loading, ready, error }

class HomeState {
  const HomeState({
    required this.status,
    required this.loadingUser,
    required this.savingClock,
    required this.user,
    required this.errorMessage,

    // Work Orders
    required this.loadingWorkOrders,
    required this.workOrders,
    required this.todayWorkOrders,
    required this.filteredWorkOrders,
    required this.selectedWorkOrdersDate,
    required this.workOrdersError,
  });

  final HomeStatus status;
  final bool loadingUser;
  final bool savingClock;
  final HomeEntity? user;
  final String? errorMessage;

  // Work Orders
  final bool loadingWorkOrders;
  final List<Map<String, dynamic>> workOrders;
  final List<Map<String, dynamic>> todayWorkOrders;

  // ✅ NUEVO
  final List<Map<String, dynamic>> filteredWorkOrders;
  final DateTime selectedWorkOrdersDate;

  final String? workOrdersError;

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
      workOrders: const <Map<String, dynamic>>[],
      todayWorkOrders: const <Map<String, dynamic>>[],
      filteredWorkOrders: const <Map<String, dynamic>>[],
      selectedWorkOrdersDate: normalizedToday,
      workOrdersError: null,
    );
  }

  HomeState copyWith({
    HomeStatus? status,
    bool? loadingUser,
    bool? savingClock,
    HomeEntity? user,
    String? errorMessage,

    bool? loadingWorkOrders,
    List<Map<String, dynamic>>? workOrders,
    List<Map<String, dynamic>>? todayWorkOrders,
    List<Map<String, dynamic>>? filteredWorkOrders,
    DateTime? selectedWorkOrdersDate,
    String? workOrdersError,
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
    );
  }
}
