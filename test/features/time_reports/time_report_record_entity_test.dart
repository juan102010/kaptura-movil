import 'package:flutter_kaptura/features/time_reports/domain/entities/time_report_record_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TimeReportRecordEntity report(String atLocal) {
    return TimeReportRecordEntity(
      id: 'report-1',
      userId: 'user-1',
      type: 'clock_in',
      atIso: '2026-02-16T05:33:14.092Z',
      atLocal: atLocal,
      timeZone: 'America/Bogota',
      reason: null,
      rawData: const {},
    );
  }

  test('uses atLocal as the primary date for filtering', () {
    final item = report('17/2/2026, 5:33:14 a. m.');

    expect(item.occursOn(DateTime(2026, 2, 17)), isTrue);
    expect(item.occursOn(DateTime(2026, 2, 16)), isFalse);
  });

  test('parses afternoon time from atLocal', () {
    final item = report('17/2/2026, 5:19:36 p. m.');

    expect(item.localDateTime, DateTime(2026, 2, 17, 17, 19, 36));
  });

  test('falls back to atISO in Bogota when atLocal is empty', () {
    final item = report('');
    final value = item.localDateTime!;

    expect(
      [
        value.year,
        value.month,
        value.day,
        value.hour,
        value.minute,
        value.second,
        value.millisecond,
      ],
      [2026, 2, 16, 0, 33, 14, 92],
    );
  });
}
