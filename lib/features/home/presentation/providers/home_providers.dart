import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/providers.dart'; // 👈 providers globales (dioClients, secureStorage, etc.)
import '../../../../core/local_db/app_database_provider.dart';

import '../../data/datasources/home_local_datasource.dart';
import '../../data/datasources/home_remote_datasource.dart';
import '../../data/repositories/home_repository_impl.dart';
import '../../domain/repositories/home_repository.dart';
import '../../domain/usecases/fetch_user_usecase.dart';
import '../../domain/usecases/get_my_work_orders_usecase.dart';
import '../../domain/usecases/has_clock_in_today_usecase.dart';
import '../../domain/usecases/toggle_clock_usecase.dart';
import '../state/home_controller.dart';
import '../state/home_state.dart';
import '../../../../core/network/internet_status.dart';

/// ✅ HomeRemoteDataSource
final homeRemoteDataSourceProvider = Provider<HomeRemoteDataSource>((ref) {
  final dioClients = ref.watch(dioClientsProvider);

  return HomeRemoteDataSourceImpl(
    loginDio: dioClients.login,
    apiDio: dioClients.api,
  );
});

/// ✅ HomeLocalDataSource (SQLite/Drift)
final homeLocalDataSourceProvider = Provider<HomeLocalDataSource>((ref) {
  final db = ref.read(appDatabaseProvider);
  return HomeLocalDataSourceImpl(db);
});

/// ✅ Repository
final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  final remote = ref.read(homeRemoteDataSourceProvider);
  final local = ref.read(homeLocalDataSourceProvider);
  return HomeRepositoryImpl(remote, local);
});

/// ✅ Usecases
final fetchUserUsecaseProvider = Provider<FetchUserUsecase>((ref) {
  return FetchUserUsecase(ref.watch(homeRepositoryProvider));
});

final hasClockInTodayUsecaseProvider = Provider<HasClockInTodayUsecase>((ref) {
  return HasClockInTodayUsecase(ref.watch(homeRepositoryProvider));
});

final toggleClockUsecaseProvider = Provider<ToggleClockUsecase>((ref) {
  return ToggleClockUsecase(ref.watch(homeRepositoryProvider));
});

final getMyWorkOrdersUsecaseProvider = Provider<GetMyWorkOrdersUsecase>((ref) {
  final repo = ref.read(homeRepositoryProvider);
  return GetMyWorkOrdersUsecase(repo);
});

/// ✅ Obtener userId desde SecureStorage (session.user['id'])
final getUserIdFromStorageProvider = Provider<Future<String?> Function()>((
  ref,
) {
  final secureStorage = ref.watch(secureStorageServiceProvider);

  return () async {
    final session = await secureStorage.readSession();
    if (session == null) return null;

    // Confirmado por ti: la key principal es 'id'
    final dynamic raw = session.user['id'] ?? session.user['_id'];
    final id = raw?.toString();
    if (id == null || id.isEmpty) return null;

    return id;
  };
});

/// ✅ Controller Provider
final homeControllerProvider = StateNotifierProvider<HomeController, HomeState>(
  (ref) {
    return HomeController(
      fetchUserUsecase: ref.watch(fetchUserUsecaseProvider),
      hasClockInTodayUsecase: ref.watch(hasClockInTodayUsecaseProvider),
      toggleClockUsecase: ref.watch(toggleClockUsecaseProvider),
      getMyWorkOrdersUsecase: ref.watch(getMyWorkOrdersUsecaseProvider),
      getUserIdFromStorage: ref.watch(getUserIdFromStorageProvider),
    );
  },
);
final homeInternetStatusProvider = StreamProvider<InternetStatus>((ref) {
  return ref.watch(internetStatusProvider.stream);
});
