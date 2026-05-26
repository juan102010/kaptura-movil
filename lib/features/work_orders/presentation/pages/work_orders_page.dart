import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/providers.dart';
import '../../../../core/network/internet_status.dart';

import '../../../home/presentation/providers/home_providers.dart';
import '../../../home/presentation/widgets/offline_banner_in_appbar.dart';
import '../widgets/work_orders_date_filter_bar.dart';
import '../widgets/work_orders_page_sections.dart';

import '../../../users/presentation/providers/users_providers.dart';
import '../../../customers/presentation/providers/customers_providers.dart';
import '../../../projects/presentation/providers/projects_providers.dart';

class WorkOrdersPage extends ConsumerStatefulWidget {
  const WorkOrdersPage({super.key});

  @override
  ConsumerState<WorkOrdersPage> createState() => _WorkOrdersPageState();
}

class _WorkOrdersPageState extends ConsumerState<WorkOrdersPage> {
  static const _bg = Color(0xFFF6F7FB);
  static const _brand = Color(0xFF0B2A4A);
  static const _softBlue = Color(0xFFE7EEF8);

  bool _didBootstrapCatalogs = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_didBootstrapCatalogs) return;
    _didBootstrapCatalogs = true;

    Future.microtask(() async {
      final logger = ref.read(loggerProvider);

      try {
        logger.i('[WorkOrdersPage] Iniciando carga de catálogos...');

        await Future.wait([
          ref.read(usersControllerProvider.notifier).loadCacheThenRemote(),
          ref.read(customersControllerProvider.notifier).loadCacheThenRemote(),
          ref.read(projectsControllerProvider.notifier).loadCacheThenRemote(),
        ]);

        final usersState = ref.read(usersControllerProvider);
        final customersState = ref.read(customersControllerProvider);
        final projectsState = ref.read(projectsControllerProvider);

        logger.i(
          '[WorkOrdersPage] Catálogos cargados | '
          'users=${usersState.users.length} (cache=${usersState.fromCache}) | '
          'customers=${customersState.customers.length} (cache=${customersState.fromCache}) | '
          'projects=${projectsState.projects.length} (cache=${projectsState.fromCache})',
        );
      } catch (e) {
        logger.e('[WorkOrdersPage] Error cargando catálogos: $e');
      }
    });
  }

  Future<void> _pickDate(BuildContext context, DateTime initialDate) async {
    final notifier = ref.read(homeControllerProvider.notifier);
    final localInitialDate = initialDate.toLocal();

    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(
        localInitialDate.year,
        localInitialDate.month,
        localInitialDate.day,
      ),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      helpText: 'Selecciona una fecha',
      cancelText: 'Cancelar',
      confirmText: 'Aceptar',
    );

    if (picked != null) {
      notifier.setSelectedWorkOrdersDate(picked.toLocal());
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeControllerProvider);
    final notifier = ref.read(homeControllerProvider.notifier);
    final logger = ref.watch(loggerProvider);

    final list = state.filteredWorkOrders;
    final selectedDate = state.selectedWorkOrdersDate.toLocal();

    final internetAsync = ref.watch(homeInternetStatusProvider);

    final isOffline = internetAsync.when(
      data: (status) => status == InternetStatus.offline,
      loading: () => false,
      error: (error, stackTrace) => false,
    );

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _brand,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Work Orders',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        bottom: isOffline
            ? const PreferredSize(
                preferredSize: Size.fromHeight(48),
                child: OfflineBannerInAppBar(),
              )
            : null,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          final offlineNow = ref
              .read(homeInternetStatusProvider)
              .when(
                data: (status) => status == InternetStatus.offline,
                loading: () => false,
                error: (error, stackTrace) => false,
              );

          logger.i('[WorkOrdersPage] Refresh manual. offlineNow=$offlineNow');

          await notifier.fetchMyWorkOrders(skipRemote: offlineNow);

          try {
            logger.i('[WorkOrdersPage] Refrescando catálogos...');

            await Future.wait([
              ref.read(usersControllerProvider.notifier).loadCacheThenRemote(),
              ref
                  .read(customersControllerProvider.notifier)
                  .loadCacheThenRemote(),
              ref
                  .read(projectsControllerProvider.notifier)
                  .loadCacheThenRemote(),
            ]);

            final usersState = ref.read(usersControllerProvider);
            final customersState = ref.read(customersControllerProvider);
            final projectsState = ref.read(projectsControllerProvider);

            logger.i(
              '[WorkOrdersPage] Catálogos tras refresh | '
              'users=${usersState.users.length} | '
              'customers=${customersState.customers.length} | '
              'projects=${projectsState.projects.length}',
            );
          } catch (e) {
            logger.e('[WorkOrdersPage] Error refrescando catálogos: $e');
          }
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          children: [
            Stack(
              children: [
                Container(
                  height: 130,
                  decoration: const BoxDecoration(color: _brand),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    height: 50,
                    decoration: const BoxDecoration(
                      color: _bg,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.elliptical(700, 120),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.list_alt_rounded,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Asignadas a ti',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 16.5,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Revisa y abre los detalles de cada WO.',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.80),
                                fontSize: 12.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      WorkOrdersCountPill(count: list.length),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  WorkOrdersDateFilterBar(
                    selectedDate: selectedDate,
                    onPrevious: notifier.goToPreviousWorkOrdersDay,
                    onNext: notifier.goToNextWorkOrdersDay,
                    onTapDate: () => _pickDate(context, selectedDate),
                  ),
                  const SizedBox(height: 12),
                  if (state.loadingWorkOrders)
                    const SizedBox(
                      height: 220,
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (state.workOrdersError != null &&
                      state.workOrdersError!.isNotEmpty)
                    WorkOrdersErrorCard(message: state.workOrdersError!)
                  else if (list.isEmpty)
                    const WorkOrdersEmptyCard(
                      title: 'Sin Work Orders',
                      subtitle:
                          'No hay Work Orders para la fecha seleccionada.',
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      primary: false,
                      physics: const BouncingScrollPhysics(),
                      itemCount: list.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final item = list[index];

                        final title = item.name.trim();
                        final displayTitle = title.isEmpty
                            ? '(Sin nombre)'
                            : title;

                        final initials = _initialsFrom(displayTitle);

                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: Colors.black.withValues(alpha: 0.05),
                            ),
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

                                logger.i(
                                  'WorkOrder selected (all): ${item.rawData}',
                                );
                                context.go('/work-orders/$id');
                              },
                              onLongPress: () {
                                logger.i(
                                  'WorkOrder selected (all - long): ${item.rawData}',
                                );
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
                                        color: _softBlue,
                                      ),
                                      child: Center(
                                        child: Text(
                                          initials,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w900,
                                            color: _brand,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            displayTitle,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 15.5,
                                              fontWeight: FontWeight.w900,
                                              color: _brand,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Toca para ver detalles',
                                            style: TextStyle(
                                              fontSize: 12.5,
                                              color: _brand.withValues(
                                                alpha: 0.55,
                                              ),
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
                                        color: _bg,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Colors.black.withValues(
                                            alpha: 0.04,
                                          ),
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.chevron_right_rounded,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.outline,
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
                  const SizedBox(height: 18),
                ],
              ),
            ),
          ],
        ),
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
    return out.isNotEmpty ? out : '?';
  }
}
