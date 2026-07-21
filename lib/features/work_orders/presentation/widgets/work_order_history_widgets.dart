import 'package:flutter/material.dart';

import '../../../../core/localization/localization_extension.dart';
import '../../domain/entities/work_order_time_entry_entity.dart';
import 'work_order_details_shared_widgets.dart';

/// Displays `text_dateTime_id` using the same timeline language as the
/// bottom-navigation time reports screen.
class WorkOrderTimeHistoryTimeline extends StatelessWidget {
  const WorkOrderTimeHistoryTimeline({super.key, required this.history});

  final List<WorkOrderTimeEntryEntity> history;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              context.l10n.timeHistory,
              style: const TextStyle(
                color: WorkOrderDetailsColors.brand,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: WorkOrderDetailsColors.softBlue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                history.length.toString(),
                style: const TextStyle(
                  color: WorkOrderDetailsColors.brand,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        if (history.isEmpty)
          _EmptyWorkOrderHistoryCard(message: context.l10n.noTimeRecords)
        else
          ...List.generate(
            history.length,
            (index) => _WorkOrderTimelineItem(
              item: history[index],
              isLast: index == history.length - 1,
            ),
          ),
      ],
    );
  }
}

class _WorkOrderTimelineItem extends StatelessWidget {
  const _WorkOrderTimelineItem({required this.item, required this.isLast});

  final WorkOrderTimeEntryEntity item;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final isOpen = item.isOpen;
    final color = isOpen ? const Color(0xFF16835B) : const Color(0xFF3F6FA5);
    final option = item.optionSelect.trim();
    final start = item.dateInit.trim();
    final end = (item.dateEnd ?? '').trim();
    final duration = item.minutes == null
        ? context.l10n.ongoing
        : context.l10n.minutesShort(_formatMinutes(item.minutes!));

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
                    isOpen ? Icons.play_arrow_rounded : Icons.check_rounded,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          option.isEmpty
                              ? context.l10n.record
                              : context.localizeWorkActivity(option),
                          style: TextStyle(
                            color: color,
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          duration,
                          style: TextStyle(
                            color: color,
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ModalInfoRow(
                    label: context.l10n.start,
                    value: start.isEmpty ? '—' : start,
                  ),
                  ModalInfoRow(
                    label: context.l10n.end,
                    value: end.isEmpty ? context.l10n.ongoing : end,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatMinutes(double value) {
    if (value == value.roundToDouble()) return value.toInt().toString();
    return value.toStringAsFixed(2).replaceFirst(RegExp(r'0+$'), '');
  }
}

class _EmptyWorkOrderHistoryCard extends StatelessWidget {
  const _EmptyWorkOrderHistoryCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.timeline_rounded,
            size: 38,
            color: Color(0xFF91A1B5),
          ),
          const SizedBox(height: 10),
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

class WorkOrderHistorySummaryRow extends StatelessWidget {
  const WorkOrderHistorySummaryRow({super.key, required this.history});

  final List<WorkOrderTimeEntryEntity> history;

  @override
  Widget build(BuildContext context) {
    return WorkOrderFieldRow(
      icon: Icons.history_rounded,
      label: context.l10n.historyRecords,
      value: history.length.toString(),
      showChevron: true,
      onTap: () {
        showWorkOrderHistoryBottomSheet(context: context, history: history);
      },
    );
  }
}

void showWorkOrderHistoryBottomSheet({
  required BuildContext context,
  required List<WorkOrderTimeEntryEntity> history,
}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => WorkOrderHistorySheet(history: history),
  );
}

class WorkOrderHistorySheet extends StatelessWidget {
  const WorkOrderHistorySheet({super.key, required this.history});

  final List<WorkOrderTimeEntryEntity> history;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.78,
          minChildSize: 0.45,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Column(
              children: [
                const SizedBox(height: 10),
                Container(
                  width: 48,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: WorkOrderDetailsColors.softBlue,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.history_rounded,
                          color: WorkOrderDetailsColors.brand,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          context.l10n.timeHistory,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                            color: WorkOrderDetailsColors.brand,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: WorkOrderDetailsColors.softBlue,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          history.length.toString(),
                          style: const TextStyle(
                            color: WorkOrderDetailsColors.brand,
                            fontWeight: FontWeight.w900,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: history.isEmpty
                      ? Center(child: Text(context.l10n.noTimeRecords))
                      : ListView.separated(
                          controller: scrollController,
                          padding: const EdgeInsets.all(16),
                          itemCount: history.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            return _WorkOrderHistoryItemCard(
                              item: history[index],
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _WorkOrderHistoryItemCard extends StatelessWidget {
  const _WorkOrderHistoryItemCard({required this.item});

  final WorkOrderTimeEntryEntity item;

  @override
  Widget build(BuildContext context) {
    final optionSelect = item.optionSelect.trim();
    final dateInit = item.dateInit.trim();
    final dateEnd = (item.dateEnd ?? '').trim();

    final minutesText = item.minutes == null
        ? context.l10n.ongoing
        : context.l10n.minutesShort(item.minutes.toString().trim());

    return Container(
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
            children: [
              Expanded(
                child: Text(
                  optionSelect.isEmpty
                      ? context.l10n.record
                      : context.localizeWorkActivity(optionSelect),
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    color: WorkOrderDetailsColors.brand,
                    fontSize: 13.5,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: WorkOrderDetailsColors.softBlue,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  minutesText,
                  style: const TextStyle(
                    color: WorkOrderDetailsColors.brand,
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ModalInfoRow(
            label: context.l10n.start,
            value: dateInit.isEmpty ? '—' : dateInit,
          ),
          ModalInfoRow(
            label: context.l10n.end,
            value: dateEnd.isEmpty ? context.l10n.ongoing : dateEnd,
          ),
        ],
      ),
    );
  }
}
