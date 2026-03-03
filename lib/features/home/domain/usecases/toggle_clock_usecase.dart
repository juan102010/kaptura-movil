import 'package:intl/intl.dart';

import '../entities/clock_coords.dart';
import '../repositories/home_repository.dart';

class ToggleClockUsecase {
  ToggleClockUsecase(this._repository);

  final HomeRepository _repository;

  static const _bogotaOffset = Duration(hours: 5);

  /// Retorna el nuevo stateClock (true clock_in, false clock_out)
  Future<bool> call({
    required String userId,
    required bool currentStateClock,
    required ClockCoords coords,
    String? reason,
  }) async {
    final oldBool = currentStateClock;
    final newBool = !oldBool;

    final nowUtc = DateTime.now().toUtc();
    final nowBogota = nowUtc.subtract(_bogotaOffset);

    final atISO = nowUtc.toIso8601String();

    // Similar a Vue: "17/2/2026, 5:33:14 a. m."
    // Aquí dejamos un formato legible en es_CO (Bogotá).
    final atLocal = DateFormat('d/M/y, h:mm:ss a', 'es_CO').format(nowBogota);

    final type = newBool ? 'clock_in' : 'clock_out';

    // 1) CREATE time_reports
    final payload = <String, dynamic>{
      'userId': userId,
      'type': type,
      'atISO': atISO,
      'atLocal': atLocal,
      'tz': 'America/Bogota',
      'coords': coords.toJson(),
      if (reason != null && reason.trim().isNotEmpty) 'reason': reason.trim(),
    };

    await _repository.createTimeReport(payload: payload);

    // 2) UPDATE users diff stateClock
    final diffPayload = <String, dynamic>{
      'stateClock': {'oldValue': oldBool, 'newValue': newBool},
    };

    await _repository.updateUserStateClockDiff(
      userId: userId,
      diffPayload: diffPayload,
    );

    return newBool;
  }
}
