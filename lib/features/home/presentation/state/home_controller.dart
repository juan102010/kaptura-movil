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
          todayWorkOrders: _filterToday(cached),
          loadingWorkOrders: true, // por defecto, porque podría venir remoto
          workOrdersError: null,
        );
      } else {
        // si no hay cache, al menos dejamos la lista de hoy vacía coherente
        state = state.copyWith(todayWorkOrders: const []);
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
        todayWorkOrders: _filterToday(remoteFiltered),
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
  // ============================
  // Helpers: filtro "hoy"
  // ============================

  List<Map<String, dynamic>> _filterToday(List<Map<String, dynamic>> list) {
    final now = DateTime.now();

    // Rango del día local
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);

    return list.where((wo) {
      final start = _extractWorkOrderStart(wo);
      if (start == null) return false;

      final end = _extractWorkOrderEnd(wo) ?? start;

      // Intersección de rangos: [start,end] con [startOfDay,endOfDay]
      final overlaps = !(end.isBefore(startOfDay) || start.isAfter(endOfDay));
      return overlaps;
    }).toList();
  }

  DateTime? _extractWorkOrderStart(Map<String, dynamic> wo) {
    // Preferimos backend keys
    final a = _tryParseDate(wo['date_start_id']);
    if (a != null) return a;

    // fallback si viene de cache local
    final b = _tryParseDate(wo['__local_startAt']);
    return b;
  }

  DateTime? _extractWorkOrderEnd(Map<String, dynamic> wo) {
    final a = _tryParseDate(wo['date_end_id']);
    if (a != null) return a;

    final b = _tryParseDate(wo['__local_endAt']);
    return b;
  }

  DateTime? _tryParseDate(dynamic v) {
    if (v == null) return null;
    final s = v.toString().trim();
    if (s.isEmpty) return null;
    try {
      return DateTime.parse(s);
    } catch (_) {
      return null;
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
