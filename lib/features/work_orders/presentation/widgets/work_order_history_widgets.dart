import 'package:flutter/material.dart';

import '../../../../core/localization/localization_extension.dart';
import '../../domain/entities/work_order_time_entry_entity.dart';
import 'work_order_details_shared_widgets.dart';

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
