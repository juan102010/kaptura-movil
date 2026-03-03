import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/clock_coords.dart';
import '../../domain/entities/home_entity.dart';
import '../../domain/usecases/fetch_user_usecase.dart';
import '../../domain/usecases/has_clock_in_today_usecase.dart';
import '../../domain/usecases/toggle_clock_usecase.dart';
import '../../domain/usecases/get_my_work_orders_usecase.dart';
import 'home_state.dart';

class HomeController extends StateNotifier<HomeState> {
  HomeController({
    required FetchUserUsecase fetchUserUsecase,
    required HasClockInTodayUsecase hasClockInTodayUsecase,
    required ToggleClockUsecase toggleClockUsecase,
    required GetMyWorkOrdersUsecase getMyWorkOrdersUsecase,
    required Future<String?> Function() getUserIdFromStorage,
  }) : _fetchUserUsecase = fetchUserUsecase,
       _hasClockInTodayUsecase = hasClockInTodayUsecase,
       _toggleClockUsecase = toggleClockUsecase,
       _getMyWorkOrdersUsecase = getMyWorkOrdersUsecase,
       _getUserIdFromStorage = getUserIdFromStorage,
       super(HomeState.initial());

  final FetchUserUsecase _fetchUserUsecase;
  final HasClockInTodayUsecase _hasClockInTodayUsecase;
  final ToggleClockUsecase _toggleClockUsecase;
  final GetMyWorkOrdersUsecase _getMyWorkOrdersUsecase;
  final Future<String?> Function() _getUserIdFromStorage;

  bool get stateClock => state.user?.stateClock ?? false;

  Future<String?> _requireUserId() async {
    final id = await _getUserIdFromStorage();
    if (id == null || id.isEmpty) {
      state = state.copyWith(
        status: HomeStatus.error,
        errorMessage: 'No se encontró userId en sesión.',
      );
      return null;
    }
    return id;
  }

  Future<void> fetchUser() async {
    state = state.copyWith(
      status: HomeStatus.loading,
      loadingUser: true,
      errorMessage: null,
    );

    try {
      final userId = await _requireUserId();
      if (userId == null) return;

      final user = await _fetchUserUsecase(userId: userId);

      state = state.copyWith(
        status: HomeStatus.ready,
        loadingUser: false,
        user: user,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        status: HomeStatus.error,
        loadingUser: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<bool> hasClockInToday() async {
    try {
      final userId = await _requireUserId();
      if (userId == null) return false;

      return await _hasClockInTodayUsecase(userId: userId);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  Future<void> toggleClock({
    required ClockCoords coords,
    String? reason,
  }) async {
    final currentUser = state.user;
    if (currentUser == null) {
      state = state.copyWith(
        status: HomeStatus.error,
        errorMessage: 'Usuario no cargado. Ejecuta fetchUser() primero.',
      );
      return;
    }

    state = state.copyWith(savingClock: true, errorMessage: null);

    try {
      final userId = currentUser.id;

      final newBool = await _toggleClockUsecase(
        userId: userId,
        currentStateClock: currentUser.stateClock,
        coords: coords,
        reason: reason,
      );

      final updatedUser = currentUser.copyWith(stateClock: newBool);

      state = state.copyWith(
        status: HomeStatus.ready,
        savingClock: false,
        user: updatedUser,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        status: HomeStatus.error,
        savingClock: false,
        errorMessage: e.toString(),
      );
      rethrow;
    }
  }

  /// ✅ Cache siempre. Si [skipRemote] es true, NO intentamos remoto.
  Future<void> fetchMyWorkOrders({bool skipRemote = false}) async {
    state = state.copyWith(loadingWorkOrders: true, workOrdersError: null);

    try {
      final userId = await _requireUserId();
      if (userId == null) return;

      // 1) Cache rápido
      final cached = await _getMyWorkOrdersUsecase.getCached();
      if (cached.isNotEmpty) {
        state = state.copyWith(
          workOrders: cached,
          loadingWorkOrders: true, // por defecto, porque podría venir remoto
          workOrdersError: null,
        );
      }

      // ✅ Si estamos offline (o decidimos saltar remoto), terminamos aquí.
      if (skipRemote) {
        state = state.copyWith(loadingWorkOrders: false, workOrdersError: null);
        return;
      }

      // 2) Remoto filtrado (usecase ya guarda cache)
      final remoteFiltered = await _getMyWorkOrdersUsecase(userId: userId);

      state = state.copyWith(
        workOrders: remoteFiltered,
        loadingWorkOrders: false,
        workOrdersError: null,
      );
    } catch (e) {
      // Si falla remoto, igual dejamos lo que haya en cache
      state = state.copyWith(
        loadingWorkOrders: false,
        workOrdersError: e.toString(),
      );
    }
  }

  // útil para pruebas
  void setUserLocal(HomeEntity user) {
    state = state.copyWith(
      status: HomeStatus.ready,
      user: user,
      loadingUser: false,
      savingClock: false,
      errorMessage: null,
    );
  }
}
