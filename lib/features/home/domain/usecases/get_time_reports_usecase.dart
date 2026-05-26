import '../entities/time_report_entity.dart';
import '../repositories/home_repository.dart';

class GetTimeReportsUsecase {
  GetTimeReportsUsecase(this._repository);

  final HomeRepository _repository;

  Future<List<TimeReportEntity>> call() {
    return _repository.getTimeReports();
  }
}
