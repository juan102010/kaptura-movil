import '../entities/time_report_record_entity.dart';

abstract class TimeReportsRepository {
  Future<List<TimeReportRecordEntity>> getCachedTimeReports();
  Future<List<TimeReportRecordEntity>> refreshTimeReports();
  Future<TimeReportRecordEntity> updateTimeReport({
    required TimeReportRecordEntity current,
    required String type,
    required String atIso,
    required String atLocal,
  });
}
