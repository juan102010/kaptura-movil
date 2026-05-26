class TimeReportEntity {
  const TimeReportEntity({
    required this.id,
    required this.userId,
    required this.type,
    required this.atIso,
    required this.coords,
    required this.reason,
    required this.rawData,
  });

  final String id;
  final String userId;
  final String type;
  final String atIso;
  final Map<String, dynamic> coords;
  final String? reason;
  final Map<String, dynamic> rawData;

  DateTime? get atDateTime {
    final value = atIso.trim();
    if (value.isEmpty) return null;
    try {
      return DateTime.parse(value);
    } catch (_) {
      return null;
    }
  }

  String get atLocalLabel {
    final raw = (rawData['atLocal'] ?? '').toString().trim();
    if (raw.isNotEmpty) return raw;

    final date = atDateTime?.toLocal();
    if (date == null) return '';

    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$day/$month/$year $hour:$minute';
  }
}
