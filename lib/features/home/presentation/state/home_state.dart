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
  final String? workOrdersError;

  factory HomeState.initial() {
    return const HomeState(
      status: HomeStatus.initial,
      loadingUser: false,
      savingClock: false,
      user: null,
      errorMessage: null,

      loadingWorkOrders: false,
      workOrders: <Map<String, dynamic>>[],
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
      workOrdersError: workOrdersError,
    );
  }
}
