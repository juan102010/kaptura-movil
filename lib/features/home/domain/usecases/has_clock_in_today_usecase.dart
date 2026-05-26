import 'package:intl/intl.dart';

import '../repositories/home_repository.dart';

class HasClockInTodayUsecase {
  HasClockInTodayUsecase(this._repository);

  final HomeRepository _repository;

  static const _bogotaOffset = Duration(hours: 5);

  String _bogotaDayKeyFromIso(String iso) {
    final dt = DateTime.parse(iso);
    final bogota = dt.toUtc().subtract(_bogotaOffset);
    return DateFormat('yyyy-MM-dd').format(bogota);
  }

  Future<bool> call({required String userId}) async {
    final todayBogota = DateTime.now().toUtc().subtract(_bogotaOffset);
    final todayKey = DateFormat('yyyy-MM-dd').format(todayBogota);

    final list = await _repository.getTimeReports();

    for (final r in list) {
      if (r.userId != userId) continue;
      if (r.type != 'clock_in') continue;

      final atIso = r.atIso;
      if (atIso.isEmpty) continue;

      if (_bogotaDayKeyFromIso(atIso) == todayKey) return true;
    }

    return false;
  }
}
