import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/providers.dart'; // ✅ loggerProvider
import '../providers/home_providers.dart';
import 'package:go_router/go_router.dart';

class WorkOrdersListWidget extends ConsumerWidget {
  const WorkOrdersListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeControllerProvider);
    final logger = ref.watch(loggerProvider);

    // ✅ Nueva fuente: solo las de hoy
    final list = state.todayWorkOrders;

    if (state.loadingWorkOrders) {
      return const SizedBox(
        height: 220,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (state.workOrdersError != null && state.workOrdersError!.isNotEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red.withValues(alpha: 0.18)),
        ),
        child: Text(
          state.workOrdersError!,
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    if (list.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.15)),
        ),
        child: const Text('No tienes Work Orders programadas para hoy.'),
      );
    }

    // ✅ Scroll propio: altura fija + ListView interno
    return SizedBox(
      height: 420,
      child: ListView.separated(
        primary: false,
        physics: const BouncingScrollPhysics(),
        itemCount: list.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final item = list[index];

          final title = (item['text_nameWorkOrder_id'] ?? '').toString().trim();
          final displayTitle = title.isEmpty ? '(Sin nombre)' : title;

          final initials = _initialsFrom(displayTitle);

          return Material(
            elevation: 0.6,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                final id = (item['_id'] ?? '').toString().trim();
                if (id.isEmpty) return;

                // opcional: mantener log
                logger.i('WorkOrder selected: $item');

                context.go('/work-orders/$id');
              },
              onLongPress: () {
                logger.i('WorkOrder selected (long): $item');
              },
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.primaryContainer,
                      foregroundColor: Theme.of(
                        context,
                      ).colorScheme.onPrimaryContainer,
                      child: Text(
                        initials,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        displayTitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.chevron_right,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _initialsFrom(String text) {
    final clean = text.trim();
    if (clean.isEmpty) return '?';

    final parts = clean
        .split(RegExp(r'\s+'))
        .where((e) => e.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';

    final first = parts[0].isNotEmpty ? parts[0][0] : '';
    final second = (parts.length > 1 && parts[1].isNotEmpty) ? parts[1][0] : '';

    final out = (first + second).toUpperCase();
    return out.isEmpty ? '?' : out;
  }
}
