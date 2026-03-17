import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/clock_coords.dart';
import '../../domain/entities/home_entity.dart';
import '../../domain/usecases/fetch_user_usecase.dart';
import '../../domain/usecases/get_my_work_orders_usecase.dart';
import '../../domain/usecases/get_time_reports_usecase.dart';
import '../../domain/usecases/has_clock_in_today_usecase.dart';
import '../../domain/usecases/toggle_clock_usecase.dart';
import 'home_state.dart';

class HomeController extends StateNotifier<HomeState> {
  HomeController({
    required FetchUserUsecase fetchUserUsecase,
    required HasClockInTodayUsecase hasClockInTodayUsecase,
    required ToggleClockUsecase toggleClockUsecase,
    required GetMyWorkOrdersUsecase getMyWorkOrdersUsecase,
    required GetTimeReportsUsecase getTimeReportsUsecase,
    required Future<String?> Function() getUserIdFromStorage,
  }) : _fetchUserUsecase = fetchUserUsecase,
       _hasClockInTodayUsecase = hasClockInTodayUsecase,
       _toggleClockUsecase = toggleClockUsecase,
       _getMyWorkOrdersUsecase = getMyWorkOrdersUsecase,
       _getTimeReportsUsecase = getTimeReportsUsecase,
       _getUserIdFromStorage = getUserIdFromStorage,
       super(HomeState.initial());

  final FetchUserUsecase _fetchUserUsecase;
  final HasClockInTodayUsecase _hasClockInTodayUsecase;
  final ToggleClockUsecase _toggleClockUsecase;
  final GetMyWorkOrdersUsecase _getMyWorkOrdersUsecase;
  final GetTimeReportsUsecase _getTimeReportsUsecase;
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

      await fetchLatestTimeReport();
    } catch (e) {
      state = state.copyWith(
        status: HomeStatus.error,
        savingClock: false,
        errorMessage: e.toString(),
      );
      rethrow;
    }
  }

  /// Cache siempre. Si [skipRemote] es true, NO intentamos remoto.
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
          filteredWorkOrders: _filterBySelectedDate(
            cached,
            state.selectedWorkOrdersDate,
          ),
          loadingWorkOrders: true,
          workOrdersError: null,
        );
      } else {
        state = state.copyWith(
          todayWorkOrders: const [],
          filteredWorkOrders: const [],
        );
      }

      if (skipRemote) {
        state = state.copyWith(loadingWorkOrders: false, workOrdersError: null);
        return;
      }

      // 2) Remoto filtrado (usecase ya guarda cache)
      final remoteFiltered = await _getMyWorkOrdersUsecase(userId: userId);

      state = state.copyWith(
        workOrders: remoteFiltered,
        todayWorkOrders: _filterToday(remoteFiltered),
        filteredWorkOrders: _filterBySelectedDate(
          remoteFiltered,
          state.selectedWorkOrdersDate,
        ),
        loadingWorkOrders: false,
        workOrdersError: null,
      );
    } catch (e) {
      state = state.copyWith(
        loadingWorkOrders: false,
        workOrdersError: e.toString(),
      );
    }
  }

  Future<void> fetchLatestTimeReport() async {
    state = state.copyWith(loadingLatestTimeReport: true);

    try {
      final userId = await _requireUserId();
      if (userId == null) {
        state = state.copyWith(
          loadingLatestTimeReport: false,
          latestTimeReport: null,
        );
        return;
      }

      final allReports = await _getTimeReportsUsecase();

      final myReports = allReports.where((report) {
        return (report['userId'] ?? '').toString() == userId;
      }).toList();

      myReports.sort((a, b) {
        final aDate =
            _tryParseDate(a['atISO']) ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bDate =
            _tryParseDate(b['atISO']) ?? DateTime.fromMillisecondsSinceEpoch(0);

        return bDate.compareTo(aDate);
      });

      state = state.copyWith(
        loadingLatestTimeReport: false,
        latestTimeReport: myReports.isNotEmpty ? myReports.first : null,
      );
    } catch (_) {
      state = state.copyWith(loadingLatestTimeReport: false);
    }
  }

  // ============================
  // Fecha seleccionada Work Orders
  // ============================

  void setSelectedWorkOrdersDate(DateTime date) {
    final normalized = _normalizeDate(date);

    state = state.copyWith(
      selectedWorkOrdersDate: normalized,
      filteredWorkOrders: _filterBySelectedDate(state.workOrders, normalized),
    );
  }

  void goToPreviousWorkOrdersDay() {
    final previous = state.selectedWorkOrdersDate.subtract(
      const Duration(days: 1),
    );
    setSelectedWorkOrdersDate(previous);
  }

  void goToNextWorkOrdersDay() {
    final next = state.selectedWorkOrdersDate.add(const Duration(days: 1));
    setSelectedWorkOrdersDate(next);
  }

  void goToTodayWorkOrdersDate() {
    setSelectedWorkOrdersDate(DateTime.now());
  }

  // ============================
  // Helpers: filtro "hoy"
  // ============================

  List<Map<String, dynamic>> _filterToday(List<Map<String, dynamic>> list) {
    final now = DateTime.now();

    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);

    return list.where((wo) {
      final start = _extractWorkOrderStart(wo);
      if (start == null) return false;

      final end = _extractWorkOrderEnd(wo) ?? start;

      final overlaps = !(end.isBefore(startOfDay) || start.isAfter(endOfDay));
      return overlaps;
    }).toList();
  }

  List<Map<String, dynamic>> _filterBySelectedDate(
    List<Map<String, dynamic>> list,
    DateTime selectedDate,
  ) {
    final normalized = _normalizeDate(selectedDate);

    final startOfDay = DateTime(
      normalized.year,
      normalized.month,
      normalized.day,
    );
    final endOfDay = DateTime(
      normalized.year,
      normalized.month,
      normalized.day,
      23,
      59,
      59,
      999,
    );

    return list.where((wo) {
      final start = _extractWorkOrderStart(wo);
      if (start == null) return false;

      final end = _extractWorkOrderEnd(wo) ?? start;

      final overlaps = !(end.isBefore(startOfDay) || start.isAfter(endOfDay));
      return overlaps;
    }).toList();
  }

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  DateTime? _extractWorkOrderStart(Map<String, dynamic> wo) {
    final a = _tryParseDate(wo['date_start_id']);
    if (a != null) return a.toLocal();

    final b = _tryParseDate(wo['__local_startAt']);
    return b?.toLocal();
  }

  DateTime? _extractWorkOrderEnd(Map<String, dynamic> wo) {
    final a = _tryParseDate(wo['date_end_id']);
    if (a != null) return a.toLocal();

    final b = _tryParseDate(wo['__local_endAt']);
    return b?.toLocal();
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
