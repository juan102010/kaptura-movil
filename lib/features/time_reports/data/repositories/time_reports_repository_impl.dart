import '../../domain/entities/time_report_record_entity.dart';
import '../../domain/repositories/time_reports_repository.dart';
import '../datasources/time_reports_local_datasource.dart';
import '../datasources/time_reports_remote_datasource.dart';
import '../models/time_report_record_model.dart';

class TimeReportsRepositoryImpl implements TimeReportsRepository {
  TimeReportsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  final TimeReportsRemoteDataSource remoteDataSource;
  final TimeReportsLocalDataSource localDataSource;

  @override
  Future<List<TimeReportRecordEntity>> getCachedTimeReports() {
    return localDataSource.getCachedTimeReports();
  }

  @override
  Future<List<TimeReportRecordEntity>> refreshTimeReports() async {
    final reports = await remoteDataSource.getTimeReports();
    await localDataSource.replaceTimeReports(reports);
    return reports;
  }

  @override
  Future<TimeReportRecordEntity> updateTimeReport({
    required TimeReportRecordEntity current,
    required String type,
    required String atIso,
    required String atLocal,
  }) async {
    final updated = await remoteDataSource.updateTimeReport(
      current: TimeReportRecordModel.fromMap(current.rawData),
      type: type,
      atIso: atIso,
      atLocal: atLocal,
    );
    await localDataSource.upsertTimeReport(updated);
    return updated;
  }
}
