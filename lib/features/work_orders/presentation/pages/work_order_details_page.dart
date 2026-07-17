import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/localization_extension.dart';
import '../../../../app/di/providers.dart';
import '../../../customers/presentation/providers/customers_providers.dart';
import '../../../home/presentation/providers/home_providers.dart';
import '../../../projects/presentation/providers/projects_providers.dart';
import '../../../users/presentation/providers/users_providers.dart';
import '../widgets/work_order_details_shared_widgets.dart';
import '../widgets/work_order_details_tabs.dart';

class WorkOrderDetailsPage extends ConsumerWidget {
  const WorkOrderDetailsPage({super.key, required this.workOrderId});

  final String workOrderId;

  static const bg = Color(0xFFF6F7FB);
  static const brand = Color(0xFF0B2A4A);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logger = ref.watch(loggerProvider);
    final homeState = ref.watch(homeControllerProvider);
    final usersState = ref.watch(usersControllerProvider);
    final customersState = ref.watch(customersControllerProvider);
    final projectsState = ref.watch(projectsControllerProvider);

    final wo = homeState.workOrders.cast().firstWhere(
      (item) => item.matchesId(workOrderId),
      orElse: () => null,
    );

    logger.i(
      '[WorkOrderDetailsPage] workOrderId=$workOrderId | '
      'workOrders=${homeState.workOrders.length} | '
      'users=${usersState.users.length} | '
      'customers=${customersState.customers.length} | '
      'projects=${projectsState.projects.length}',
    );

    if (wo == null) {
      logger.w('[WorkOrderDetailsPage] No se encontró WO para id=$workOrderId');
      return const _WorkOrderNotFoundView();
    }

    logger.i('[WorkOrderDetailsPage] WO encontrada: ${wo.rawData}');

    final title = wo.name.trim();
    final displayTitle = title.isEmpty ? context.l10n.unnamed : title;
    final initials = WorkOrderDetailsUiUtils.initialsFrom(displayTitle);

    return DefaultTabController(
      length: 6,
      child: Scaffold(
        backgroundColor: bg,
        appBar: AppBar(
          backgroundColor: brand,
          foregroundColor: Colors.white,
          elevation: 0,
          title: Text(
            displayTitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
        body: Column(
          children: [
            WorkOrderHeader(
              displayTitle: displayTitle,
              workOrderId: workOrderId,
              initials: initials,
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 10, 16, 12),
              child: WorkOrderTabBar(),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  GeneralTab(
                    wo: wo,
                    users: usersState.users,
                    customers: customersState.customers,
                    projects: projectsState.projects,
                  ),
                  TimeTab(wo: wo),
                  TechTab(wo: wo),
                  LocationTab(wo: wo),
                  PartsTab(wo: wo),
                  EvidenceTab(wo: wo),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WorkOrderNotFoundView extends StatelessWidget {
  const _WorkOrderNotFoundView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WorkOrderDetailsPage.bg,
      appBar: AppBar(
        backgroundColor: WorkOrderDetailsPage.brand,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(context.l10n.workOrders),
      ),
      body: Center(child: Text(context.l10n.workOrderNotFound)),
    );
  }
}
