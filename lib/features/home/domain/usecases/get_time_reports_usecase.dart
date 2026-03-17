import '../repositories/home_repository.dart';

class GetTimeReportsUsecase {
  GetTimeReportsUsecase(this._repository);

  final HomeRepository _repository;

  Future<List<Map<String, dynamic>>> call() {
    return _repository.getTimeReports();
  }
}
