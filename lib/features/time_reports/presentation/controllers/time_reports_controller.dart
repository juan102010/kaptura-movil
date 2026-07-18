import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/time_report_record_entity.dart';
import '../../domain/repositories/time_reports_repository.dart';

class TimeReportsState {
  const TimeReportsState({
    required this.loading,
    required this.savingId,
    required this.reports,
    required this.selectedDate,
    required this.fromCache,
    required this.error,
  });

  factory TimeReportsState.initial() => TimeReportsState(
    loading: false,
    savingId: null,
    reports: const <TimeReportRecordEntity>[],
    selectedDate: _dateOnly(DateTime.now()),
    fromCache: false,
    error: null,
  );

  final bool loading;
  final String? savingId;
  final List<TimeReportRecordEntity> reports;
  final DateTime selectedDate;
  final bool fromCache;
  final String? error;

  List<TimeReportRecordEntity> get reportsForSelectedDate {
    final filtered = reports
        .where((report) => report.occursOn(selectedDate))
        .toList();
    filtered.sort((a, b) {
      final aDate = a.localDateTime ?? DateTime(0);
      final bDate = b.localDateTime ?? DateTime(0);
      return aDate.compareTo(bDate);
    });
    return filtered;
  }

  TimeReportsState copyWith({
    bool? loading,
    String? savingId,
    bool clearSavingId = false,
    List<TimeReportRecordEntity>? reports,
    DateTime? selectedDate,
    bool? fromCache,
    String? error,
    bool clearError = false,
  }) {
    return TimeReportsState(
      loading: loading ?? this.loading,
      savingId: clearSavingId ? null : (savingId ?? this.savingId),
      reports: reports ?? this.reports,
      selectedDate: selectedDate ?? this.selectedDate,
      fromCache: fromCache ?? this.fromCache,
      error: clearError ? null : (error ?? this.error),
    );
  }

  static DateTime _dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);
}

class TimeReportsController extends StateNotifier<TimeReportsState> {
  TimeReportsController({required TimeReportsRepository repository})
    : _repository = repository,
      super(TimeReportsState.initial());

  final TimeReportsRepository _repository;

  Future<void> loadCacheThenRemote() async {
    state = state.copyWith(loading: true, clearError: true);
    try {
      final cached = await _repository.getCachedTimeReports();
      if (cached.isNotEmpty) {
        state = state.copyWith(loading: true, reports: cached, fromCache: true);
      }
      await refreshRemote(silentLoading: true);
    } catch (error) {
      state = state.copyWith(
        loading: false,
        error: error.toString(),
        fromCache: state.reports.isNotEmpty,
      );
    }
  }

  Future<void> refreshRemote({bool silentLoading = false}) async {
    if (!silentLoading) {
      state = state.copyWith(loading: true, clearError: true);
    }
    try {
      final remote = await _repository.refreshTimeReports();
      state = state.copyWith(
        loading: false,
        reports: remote,
        fromCache: false,
        clearError: true,
      );
    } catch (error) {
      state = state.copyWith(
        loading: false,
        error: error.toString(),
        fromCache: state.reports.isNotEmpty,
      );
    }
  }

  void setSelectedDate(DateTime date) {
    state = state.copyWith(
      selectedDate: DateTime(date.year, date.month, date.day),
    );
  }

  void goToPreviousDay() {
    setSelectedDate(state.selectedDate.subtract(const Duration(days: 1)));
  }

  void goToNextDay() {
    setSelectedDate(state.selectedDate.add(const Duration(days: 1)));
  }

  Future<void> updateReport({
    required TimeReportRecordEntity report,
    required String type,
    required TimeOfDayValue time,
  }) async {
    state = state.copyWith(savingId: report.id, clearError: true);
    final localDate = DateTime(
      state.selectedDate.year,
      state.selectedDate.month,
      state.selectedDate.day,
      time.hour,
      time.minute,
      report.localDateTime?.second ?? 0,
    );
    final utcDate = DateTime.utc(
      localDate.year,
      localDate.month,
      localDate.day,
      localDate.hour + 5,
      localDate.minute,
      localDate.second,
    );
    final atLocal = DateFormat('d/M/y, h:mm:ss a', 'es_CO').format(localDate);

    try {
      final updated = await _repository.updateTimeReport(
        current: report,
        type: type,
        atIso: utcDate.toIso8601String(),
        atLocal: atLocal,
      );
      state = state.copyWith(
        clearSavingId: true,
        reports: state.reports
            .map((item) => item.id == updated.id ? updated : item)
            .toList(growable: false),
        clearError: true,
      );
    } catch (error) {
      state = state.copyWith(clearSavingId: true, error: error.toString());
      rethrow;
    }
  }
}

class TimeOfDayValue {
  const TimeOfDayValue({required this.hour, required this.minute});

  final int hour;
  final int minute;
}
