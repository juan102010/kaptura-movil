import 'package:flutter/material.dart';

import 'work_order_details_shared_widgets.dart';

class WorkOrderHistorySummaryRow extends StatelessWidget {
  const WorkOrderHistorySummaryRow({super.key, required this.history});

  final List<Map<String, dynamic>> history;

  @override
  Widget build(BuildContext context) {
    final count = history.length.toString();

    return WorkOrderFieldRow(
      icon: Icons.history_rounded,
      label: 'Historial (registros)',
      value: count,
      showChevron: true,
      onTap: () {
        showWorkOrderHistoryBottomSheet(context: context, history: history);
      },
    );
  }
}

void showWorkOrderHistoryBottomSheet({
  required BuildContext context,
  required List<Map<String, dynamic>> history,
}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return WorkOrderHistorySheet(history: history);
    },
  );
}

class WorkOrderHistorySheet extends StatelessWidget {
  const WorkOrderHistorySheet({super.key, required this.history});

  final List<Map<String, dynamic>> history;

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
                      const Expanded(
                        child: Text(
                          'Historial de tiempo',
                          style: TextStyle(
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
                      ? const Center(child: Text('No hay registros de tiempo.'))
                      : ListView.separated(
                          controller: scrollController,
                          padding: const EdgeInsets.all(16),
                          itemCount: history.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final item = history[index];
                            return _WorkOrderHistoryItemCard(item: item);
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

  final Map<String, dynamic> item;

  @override
  Widget build(BuildContext context) {
    final optionSelect = _stringValue(item['optionSelect']);
    final dateInit = _stringValue(item['dateInit']);
    final dateEnd = _stringValue(item['dateEnd']);
    final minutes = item['minutes'];

    final minutesText = minutes == null || minutes.toString().trim().isEmpty
        ? 'En curso'
        : '${minutes.toString().trim()} min';

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
                  optionSelect.isEmpty ? 'Registro' : optionSelect,
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
            label: 'Inicio',
            value: dateInit.isEmpty ? '—' : dateInit,
          ),
          ModalInfoRow(
            label: 'Fin',
            value: dateEnd.isEmpty ? 'En curso' : dateEnd,
          ),
        ],
      ),
    );
  }
}

String _stringValue(dynamic value) => (value ?? '').toString().trim();
