import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/localization_extension.dart';
import '../../../../core/ui/widgets/app_date_filter_bar.dart';
import '../../../permissions/presentation/controllers/permission_settings_controller.dart';
import '../../../permissions/presentation/providers/permission_settings_providers.dart';
import '../../domain/entities/time_report_record_entity.dart';
import '../controllers/time_reports_controller.dart';
import '../providers/time_reports_providers.dart';

class TimeReportsPage extends ConsumerStatefulWidget {
  const TimeReportsPage({super.key});

  @override
  ConsumerState<TimeReportsPage> createState() => _TimeReportsPageState();
}

class _TimeReportsPageState extends ConsumerState<TimeReportsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref
          .read(timeReportsControllerProvider.notifier)
          .loadCacheThenRemote(),
    );
  }

  Future<void> _pickDate(DateTime initialDate) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      helpText: context.l10n.selectDate,
      cancelText: context.l10n.cancel,
      confirmText: context.l10n.accept,
    );
    if (picked == null) return;
    ref.read(timeReportsControllerProvider.notifier).setSelectedDate(picked);
  }

  Future<void> _edit(TimeReportRecordEntity report) async {
    final initial = report.localDateTime ?? DateTime.now();
    final result = await showDialog<_TimeReportEditValue>(
      context: context,
      builder: (_) => _EditTimeReportDialog(
        initialType: report.type,
        initialTime: TimeOfDay.fromDateTime(initial),
      ),
    );
    if (result == null || !mounted) return;

    try {
      await ref
          .read(timeReportsControllerProvider.notifier)
          .updateReport(
            report: report,
            type: result.type,
            time: TimeOfDayValue(
              hour: result.time.hour,
              minute: result.time.minute,
            ),
          );
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.timeReportUpdated)));
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(timeReportsControllerProvider);
    final controller = ref.read(timeReportsControllerProvider.notifier);
    final permissions = ref.watch(permissionSettingsControllerProvider);
    final canUpdate = permissions.hasPermission(
      ProtectedModule.timeReports,
      'Update',
    );
    final reports = state.reportsForSelectedDate;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: Text(context.l10n.timeReports),
        actions: [
          IconButton(
            onPressed: state.loading ? null : controller.refreshRemote,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: controller.refreshRemote,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          children: [
            AppDateFilterBar(
              selectedDate: state.selectedDate,
              onPrevious: controller.goToPreviousDay,
              onNext: controller.goToNextDay,
              onTapDate: () => _pickDate(state.selectedDate),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Text(
                  context.l10n.dailyTimeline,
                  style: const TextStyle(
                    color: Color(0xFF0B2A4A),
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE7EEF8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${reports.length}',
                    style: const TextStyle(
                      color: Color(0xFF0B2A4A),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            if (state.loading && state.reports.isEmpty)
              const SizedBox(
                height: 240,
                child: Center(child: CircularProgressIndicator()),
              )
            else if (reports.isEmpty)
              _EmptyReportsCard(message: context.l10n.noTimeReportsForDate)
            else
              ...List.generate(
                reports.length,
                (index) => _TimelineItem(
                  report: reports[index],
                  isLast: index == reports.length - 1,
                  canUpdate: canUpdate,
                  saving: state.savingId == reports[index].id,
                  onEdit: () => _edit(reports[index]),
                ),
              ),
            if (state.error != null && state.error!.trim().isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                context.localizeError(state.error!),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  const _TimelineItem({
    required this.report,
    required this.isLast,
    required this.canUpdate,
    required this.saving,
    required this.onEdit,
  });

  final TimeReportRecordEntity report;
  final bool isLast;
  final bool canUpdate;
  final bool saving;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final isClockIn = report.type.toLowerCase() == 'clock_in';
    final color = isClockIn ? const Color(0xFF16835B) : const Color(0xFFD26A32);
    final label = isClockIn ? context.l10n.entryType : context.l10n.exitType;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 40,
            child: Column(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                    border: Border.all(color: color.withValues(alpha: 0.35)),
                  ),
                  child: Icon(
                    isClockIn ? Icons.login_rounded : Icons.logout_rounded,
                    color: color,
                    size: 19,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: const Color(0xFFDCE4EE),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(bottom: isLast ? 0 : 14),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          style: TextStyle(
                            color: color,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          report.atLocal,
                          style: const TextStyle(
                            color: Color(0xFF243B53),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (report.userId.isNotEmpty) ...[
                          const SizedBox(height: 5),
                          Text(
                            report.userId,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFF8291A5),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (saving)
                    const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  else if (canUpdate)
                    IconButton(
                      tooltip: context.l10n.editTimeReport,
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit_rounded),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyReportsCard extends StatelessWidget {
  const _EmptyReportsCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 42),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.timeline_rounded,
            size: 42,
            color: Color(0xFF91A1B5),
          ),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }
}

class _TimeReportEditValue {
  const _TimeReportEditValue({required this.type, required this.time});

  final String type;
  final TimeOfDay time;
}

class _EditTimeReportDialog extends StatefulWidget {
  const _EditTimeReportDialog({
    required this.initialType,
    required this.initialTime,
  });

  final String initialType;
  final TimeOfDay initialTime;

  @override
  State<_EditTimeReportDialog> createState() => _EditTimeReportDialogState();
}

class _EditTimeReportDialogState extends State<_EditTimeReportDialog> {
  late String _type;
  late TimeOfDay _time;

  @override
  void initState() {
    super.initState();
    _type = widget.initialType == 'clock_out' ? 'clock_out' : 'clock_in';
    _time = widget.initialTime;
  }

  Future<void> _selectTime() async {
    final selected = await showTimePicker(context: context, initialTime: _time);
    if (selected == null || !mounted) return;
    setState(() => _time = selected);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.l10n.editTimeReport),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            initialValue: _type,
            decoration: InputDecoration(
              labelText: context.l10n.type,
              border: const OutlineInputBorder(),
            ),
            items: [
              DropdownMenuItem(
                value: 'clock_in',
                child: Text(context.l10n.entryType),
              ),
              DropdownMenuItem(
                value: 'clock_out',
                child: Text(context.l10n.exitType),
              ),
            ],
            onChanged: (value) {
              if (value != null) setState(() => _type = value);
            },
          ),
          const SizedBox(height: 14),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Color(0xFFB8C2CE)),
              borderRadius: BorderRadius.circular(8),
            ),
            leading: const Icon(Icons.schedule_rounded),
            title: Text(context.l10n.reportedTime),
            subtitle: Text(_time.format(context)),
            onTap: _selectTime,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.l10n.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(
            context,
          ).pop(_TimeReportEditValue(type: _type, time: _time)),
          child: Text(context.l10n.saveChanges),
        ),
      ],
    );
  }
}
