import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/providers.dart';
import '../../../../core/localization/localization_extension.dart';
import '../providers/home_providers.dart';

class WorkOrdersListWidget extends ConsumerWidget {
  const WorkOrdersListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeControllerProvider);
    final logger = ref.watch(loggerProvider);
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
          context.localizeError(state.workOrdersError!),
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
        child: Text(context.l10n.noTodayWorkOrders),
      );
    }

    return SizedBox(
      height: 440,
      child: ListView.separated(
        primary: false,
        physics: const BouncingScrollPhysics(),
        itemCount: list.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = list[index];
          final title = item.name.trim();
          final displayTitle = title.isEmpty ? context.l10n.unnamed : title;
          final initials = _initialsFrom(displayTitle);

          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
              boxShadow: [
                BoxShadow(
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                  color: Colors.black.withValues(alpha: 0.05),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () {
                  final id = item.id.trim();
                  if (id.isEmpty) return;

                  logger.i('WorkOrder selected: ${item.rawData}');
                  context.go('/work-orders/$id');
                },
                onLongPress: () {
                  logger.i('WorkOrder selected (long): ${item.rawData}');
                },
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: const Color(0xFFE7EEF8),
                        ),
                        child: Center(
                          child: Text(
                            initials,
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF0B2A4A),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              displayTitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 15.5,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF0B2A4A),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              context.l10n.tapForDetails,
                              style: TextStyle(
                                fontSize: 12.5,
                                color: const Color(
                                  0xFF0B2A4A,
                                ).withValues(alpha: 0.55),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF6F7FB),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.black.withValues(alpha: 0.04),
                          ),
                        ),
                        child: Icon(
                          Icons.chevron_right_rounded,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
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
        .where((item) => item.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';

    final first = parts[0].isNotEmpty ? parts[0][0] : '';
    final second = (parts.length > 1 && parts[1].isNotEmpty) ? parts[1][0] : '';

    final out = (first + second).toUpperCase();
    return out.isEmpty ? '?' : out;
  }
}
