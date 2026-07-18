class TimeReportRecordEntity {
  const TimeReportRecordEntity({
    required this.id,
    required this.userId,
    required this.type,
    required this.atIso,
    required this.atLocal,
    required this.timeZone,
    required this.reason,
    required this.rawData,
  });

  final String id;
  final String userId;
  final String type;
  final String atIso;
  final String atLocal;
  final String timeZone;
  final String? reason;
  final Map<String, dynamic> rawData;

  DateTime? get localDateTime {
    final parsedLocal = _parseAtLocal(atLocal);
    if (parsedLocal != null) return parsedLocal;

    final parsedIso = DateTime.tryParse(atIso);
    if (parsedIso == null) return null;
    return parsedIso.toUtc().subtract(const Duration(hours: 5));
  }

  bool occursOn(DateTime date) {
    final value = localDateTime;
    return value != null &&
        value.year == date.year &&
        value.month == date.month &&
        value.day == date.day;
  }

  static DateTime? _parseAtLocal(String value) {
    final match = RegExp(
      r'(\d{1,2})/(\d{1,2})/(\d{4})\D+(\d{1,2}):(\d{2})(?::(\d{2}))?',
    ).firstMatch(value);
    if (match == null) return null;

    final day = int.tryParse(match.group(1)!);
    final month = int.tryParse(match.group(2)!);
    final year = int.tryParse(match.group(3)!);
    var hour = int.tryParse(match.group(4)!);
    final minute = int.tryParse(match.group(5)!);
    final second = int.tryParse(match.group(6) ?? '0') ?? 0;
    if (day == null ||
        month == null ||
        year == null ||
        hour == null ||
        minute == null) {
      return null;
    }

    final suffix = value.substring(match.end).toLowerCase();
    final isPm = suffix.contains('p.') || suffix.contains('pm');
    final isAm = suffix.contains('a.') || suffix.contains('am');
    if (isPm && hour < 12) hour += 12;
    if (isAm && hour == 12) hour = 0;

    try {
      return DateTime(year, month, day, hour, minute, second);
    } catch (_) {
      return null;
    }
  }
}
