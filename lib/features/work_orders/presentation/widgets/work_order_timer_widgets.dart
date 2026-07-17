import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/localization_extension.dart';
import '../../../home/presentation/providers/home_providers.dart';
import '../../domain/entities/work_order_time_entry_entity.dart';
import '../providers/work_order_action_providers.dart';
import 'work_order_details_shared_widgets.dart';

class WorkOrderTimerCard extends ConsumerStatefulWidget {
  const WorkOrderTimerCard({
    super.key,
    required this.workOrderId,
    required this.history,
    this.onHistoryUpdated,
  });

  final String workOrderId;
  final List<WorkOrderTimeEntryEntity> history;
  final void Function(List<WorkOrderTimeEntryEntity> newHistory)?
  onHistoryUpdated;

  @override
  ConsumerState<WorkOrderTimerCard> createState() => _WorkOrderTimerCardState();
}

class _WorkOrderTimerCardState extends ConsumerState<WorkOrderTimerCard> {
  static const Duration _businessOffset = Duration(hours: -5);

  Timer? _ticker;
  late List<WorkOrderTimeEntryEntity> _localHistory;

  @override
  void initState() {
    super.initState();
    _localHistory = List<WorkOrderTimeEntryEntity>.from(widget.history);
    _configureTicker();
  }

  @override
  void didUpdateWidget(covariant WorkOrderTimerCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!_sameHistory(oldWidget.history, widget.history)) {
      _localHistory = List<WorkOrderTimeEntryEntity>.from(widget.history);
    }

    _configureTicker();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  bool _sameHistory(
    List<WorkOrderTimeEntryEntity> a,
    List<WorkOrderTimeEntryEntity> b,
  ) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i].toMap().toString() != b[i].toMap().toString()) return false;
    }
    return true;
  }

  List<WorkOrderTimeEntryEntity> get _entries => _localHistory;

  WorkOrderTimeEntryEntity? get _activeEntry {
    for (final item in _entries.reversed) {
      if (item.isOpen) return item;
    }
    return null;
  }

  bool get _isRunning => _activeEntry != null;

  void _configureTicker() {
    _ticker?.cancel();
    if (_isRunning) {
      _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted) setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final actionState = ref.watch(workOrderTimeActionControllerProvider);
    final activeEntry = _activeEntry;
    final activeOption = activeEntry?.optionSelect.trim() ?? '';
    final activeStart = activeEntry?.dateInit.trim() ?? '';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
          boxShadow: [
            BoxShadow(
              blurRadius: 14,
              offset: const Offset(0, 8),
              color: Colors.black.withValues(alpha: 0.04),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: WorkOrderDetailsColors.softBlue,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.pending_actions_rounded,
                    color: WorkOrderDetailsColors.brand,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    context.l10n.timer,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      color: WorkOrderDetailsColors.brand,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_isRunning) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: WorkOrderDetailsColors.softBlue.withValues(
                    alpha: 0.45,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activeOption.isEmpty
                          ? context.l10n.activityInProgress
                          : context.localizeWorkActivity(activeOption),
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        color: WorkOrderDetailsColors.brand,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      activeStart.isEmpty
                          ? context.l10n.elapsedTime('—')
                          : context.l10n.elapsedTime(
                              _elapsedLabel(activeStart),
                            ),
                      style: TextStyle(
                        color: WorkOrderDetailsColors.brand.withValues(
                          alpha: 0.82,
                        ),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _TimerActionButton(
                      label: actionState.isLoading
                          ? context.l10n.saving
                          : context.l10n.pauseActivity,
                      icon: Icons.pause_rounded,
                      enabled: !actionState.isLoading,
                      onTap: () =>
                          _closeCurrentActivity('Pausa corta / descanso'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _TimerActionButton(
                      label: actionState.isLoading
                          ? context.l10n.saving
                          : context.l10n.finish,
                      icon: Icons.stop_rounded,
                      enabled: !actionState.isLoading,
                      onTap: () => _closeCurrentActivity('Fin de jornada'),
                    ),
                  ),
                ],
              ),
            ] else ...[
              Text(
                context.l10n.noRunningActivity,
                style: TextStyle(
                  color: WorkOrderDetailsColors.brand.withValues(alpha: 0.70),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _TimerActionButton(
                      label: actionState.isLoading
                          ? context.l10n.saving
                          : context.l10n.startTravel,
                      icon: Icons.directions_car_rounded,
                      enabled: !actionState.isLoading,
                      onTap: () => _startActivity('Inicio de desplazamiento'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _TimerActionButton(
                      label: actionState.isLoading
                          ? context.l10n.saving
                          : context.l10n.startWork,
                      icon: Icons.play_arrow_rounded,
                      enabled: !actionState.isLoading,
                      onTap: () => _startActivity('Inicio de actividad'),
                    ),
                  ),
                ],
              ),
            ],
            if (actionState.errorMessage != null &&
                actionState.errorMessage!.trim().isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                context.localizeError(actionState.errorMessage!),
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _startActivity(String optionSelect) async {
    final nowBusiness = _nowInBusinessTime();
    final oldHistory = _cloneHistory(_localHistory);

    final newEntry = WorkOrderTimeEntryEntity(
      dateInit: _formatDate(nowBusiness),
      dateEnd: null,
      minutes: null,
      optionSelect: optionSelect,
    );

    final newHistory = [..._cloneHistory(_localHistory), newEntry];

    final ok = await ref
        .read(workOrderTimeActionControllerProvider.notifier)
        .updateTimeHistoryDiff(
          workOrderId: widget.workOrderId,
          oldValue: oldHistory.map((item) => item.toMap()).toList(),
          newValue: newHistory.map((item) => item.toMap()).toList(),
        );

    if (!mounted) return;

    if (ok) {
      setState(() {
        _localHistory = newHistory;
      });
      _configureTicker();
      widget.onHistoryUpdated?.call(_cloneHistory(newHistory));
      await _refreshGlobalAndLocalWorkOrders();

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.activityStarted)));
    }
  }

  Future<void> _closeCurrentActivity(String optionSelect) async {
    final activeEntry = _activeEntry;
    if (activeEntry == null) return;

    final nowBusiness = _nowInBusinessTime();
    final initDateUtc = _parseBusinessDate(activeEntry.dateInit);

    double? minutes;
    if (initDateUtc != null) {
      final diff = DateTime.now().toUtc().difference(initDateUtc);
      final safeDiff = diff.isNegative ? Duration.zero : diff;
      minutes = double.parse((safeDiff.inSeconds / 60).toStringAsFixed(2));
    }

    final oldHistory = _cloneHistory(_localHistory);
    final currentEntries = _entries;
    final targetIndex = currentEntries.lastIndexWhere((entry) => entry.isOpen);
    if (targetIndex == -1) return;

    final updatedEntries = [...currentEntries];
    updatedEntries[targetIndex] = updatedEntries[targetIndex].copyWith(
      dateEnd: _formatDate(nowBusiness),
      minutes: minutes,
      optionSelect: optionSelect,
    );

    final ok = await ref
        .read(workOrderTimeActionControllerProvider.notifier)
        .updateTimeHistoryDiff(
          workOrderId: widget.workOrderId,
          oldValue: oldHistory.map((item) => item.toMap()).toList(),
          newValue: updatedEntries.map((item) => item.toMap()).toList(),
        );

    if (!mounted) return;

    if (ok) {
      setState(() {
        _localHistory = updatedEntries;
      });
      _configureTicker();
      widget.onHistoryUpdated?.call(_cloneHistory(updatedEntries));
      await _refreshGlobalAndLocalWorkOrders();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            optionSelect == 'Fin de jornada'
                ? context.l10n.activityFinished
                : context.l10n.activityPaused,
          ),
        ),
      );
    }
  }

  Future<void> _refreshGlobalAndLocalWorkOrders() async {
    await ref.read(homeControllerProvider.notifier).fetchMyWorkOrders();
  }

  List<WorkOrderTimeEntryEntity> _cloneHistory(
    List<WorkOrderTimeEntryEntity> source,
  ) {
    return source.map((item) => item.copyWith()).toList();
  }

  String _elapsedLabel(String rawDateInit) {
    final initDateUtc = _parseBusinessDate(rawDateInit);
    if (initDateUtc == null) return '—';

    final diff = DateTime.now().toUtc().difference(initDateUtc);
    final safeDiff = diff.isNegative ? Duration.zero : diff;
    final hours = safeDiff.inHours;
    final minutes = safeDiff.inMinutes.remainder(60);
    final seconds = safeDiff.inSeconds.remainder(60);

    if (hours > 0) {
      return '$hours h ${minutes.toString().padLeft(2, '0')} min ${seconds.toString().padLeft(2, '0')} s';
    }

    return '$minutes min ${seconds.toString().padLeft(2, '0')} s';
  }

  DateTime _nowInBusinessTime() {
    return DateTime.now().toUtc().add(_businessOffset);
  }

  DateTime? _parseBusinessDate(String value) {
    try {
      final parts = value.split(' ');
      if (parts.length != 2) return null;

      final dateParts = parts[0].split('/');
      final timeParts = parts[1].split(':');
      if (dateParts.length != 3 || timeParts.length != 3) return null;

      final day = int.parse(dateParts[0]);
      final month = int.parse(dateParts[1]);
      final year = int.parse(dateParts[2]);
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);
      final second = int.parse(timeParts[2]);

      return DateTime.utc(year, month, day, hour + 5, minute, second);
    } catch (_) {
      return null;
    }
  }

  String _formatDate(DateTime value) {
    final day = value.day.toString().padLeft(2, '0');
    final month = value.month.toString().padLeft(2, '0');
    final year = value.year.toString();
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    final second = value.second.toString().padLeft(2, '0');
    return '$day/$month/$year $hour:$minute:$second';
  }
}

class _TimerActionButton extends StatelessWidget {
  const _TimerActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
    required this.enabled,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : 0.65,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: enabled ? onTap : null,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: WorkOrderDetailsColors.softBlue,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 18, color: WorkOrderDetailsColors.brand),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: WorkOrderDetailsColors.brand,
                      fontWeight: FontWeight.w900,
                      fontSize: 12.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
