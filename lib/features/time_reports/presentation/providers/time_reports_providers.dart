import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/providers.dart';
import '../../../../core/local_db/app_database_provider.dart';
import '../../data/datasources/time_reports_local_datasource.dart';
import '../../data/datasources/time_reports_remote_datasource.dart';
import '../../data/repositories/time_reports_repository_impl.dart';
import '../../domain/repositories/time_reports_repository.dart';
import '../controllers/time_reports_controller.dart';

final timeReportsRemoteDataSourceProvider =
    Provider<TimeReportsRemoteDataSource>((ref) {
      return TimeReportsRemoteDataSourceImpl(
        apiDio: ref.watch(dioClientsProvider).api,
      );
    });

final timeReportsLocalDataSourceProvider = Provider<TimeReportsLocalDataSource>(
  (ref) {
    return TimeReportsLocalDataSourceImpl(
      database: ref.watch(appDatabaseProvider),
    );
  },
);

final timeReportsRepositoryProvider = Provider<TimeReportsRepository>((ref) {
  return TimeReportsRepositoryImpl(
    remoteDataSource: ref.watch(timeReportsRemoteDataSourceProvider),
    localDataSource: ref.watch(timeReportsLocalDataSourceProvider),
  );
});

final timeReportsControllerProvider =
    StateNotifierProvider<TimeReportsController, TimeReportsState>((ref) {
      return TimeReportsController(
        repository: ref.watch(timeReportsRepositoryProvider),
      );
    });
