import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/providers.dart';

import '../../../home/presentation/providers/home_providers.dart';
import '../../../users/presentation/providers/users_providers.dart';
import '../../../customers/presentation/state/customers_controller.dart';
import '../../../projects/presentation/providers/projects_providers.dart';

class WorkOrderDetailsPage extends ConsumerWidget {
  const WorkOrderDetailsPage({super.key, required this.workOrderId});

  final String workOrderId;

  static const _bg = Color(0xFFF6F7FB);
  static const _brand = Color(0xFF0B2A4A);
  static const _softBlue = Color(0xFFE7EEF8);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logger = ref.watch(loggerProvider);
    final homeState = ref.watch(homeControllerProvider);
    final usersState = ref.watch(usersControllerProvider);
    final customersState = ref.watch(customersControllerProvider);
    final projectsState = ref.watch(projectsControllerProvider);

    final wo = homeState.workOrders.cast<Map<String, dynamic>?>().firstWhere(
      (e) => (e?['_id'] ?? '').toString() == workOrderId,
      orElse: () => null,
    );

    logger.i(
      '[WorkOrderDetailsPage] workOrderId=$workOrderId | '
      'workOrders=${homeState.workOrders.length} | '
      'users=${usersState.users.length} | '
      'customers=${customersState.customers.length} | '
      'projects=${projectsState.projects.length}',
    );

    if (wo != null) {
      logger.i('[WorkOrderDetailsPage] WO encontrada: $wo');
    } else {
      logger.w('[WorkOrderDetailsPage] No se encontró WO para id=$workOrderId');
    }

    if (wo == null) {
      return Scaffold(
        backgroundColor: _bg,
        appBar: AppBar(
          backgroundColor: _brand,
          foregroundColor: Colors.white,
          elevation: 0,
          title: const Text('Work Order'),
        ),
        body: const Center(
          child: Text('No se encontró la Work Order en memoria/cache.'),
        ),
      );
    }

    final title = _s(wo['text_nameWorkOrder_id']);
    final displayTitle = title.isEmpty ? '(Sin nombre)' : title;
    final initials = _initialsFrom(displayTitle);

    return DefaultTabController(
      length: 6,
      child: Scaffold(
        backgroundColor: _bg,
        appBar: AppBar(
          backgroundColor: _brand,
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
            Stack(
              children: [
                Container(
                  height: 120,
                  decoration: const BoxDecoration(color: _brand),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    height: 46,
                    decoration: const BoxDecoration(
                      color: _bg,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.elliptical(700, 120),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                  child: Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.18),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            initials,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
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
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 16.5,
                              ),
                            ),
                            const SizedBox(height: 6),
                            _Pill(
                              text: 'ID: $workOrderId',
                              bg: Colors.white.withValues(alpha: 0.14),
                              fg: Colors.white.withValues(alpha: 0.92),
                              border: Colors.white.withValues(alpha: 0.18),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.work_outline_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
              child: Container(
                padding: const EdgeInsets.all(8),
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
                child: TabBar(
                  isScrollable: true,
                  indicator: BoxDecoration(
                    color: _softBlue,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: _brand,
                  unselectedLabelColor: _brand.withValues(alpha: 0.55),
                  labelStyle: const TextStyle(fontWeight: FontWeight.w900),
                  tabs: const [
                    Tab(text: 'General'),
                    Tab(text: 'Tiempo'),
                    Tab(text: 'Técnico'),
                    Tab(text: 'Ubicación'),
                    Tab(text: 'Partes'),
                    Tab(text: 'Evidencias'),
                  ],
                ),
              ),
            ),

            Expanded(
              child: TabBarView(
                children: [
                  _GeneralTab(
                    wo: wo,
                    users: usersState.users,
                    customers: customersState.customers,
                    projects: projectsState.projects,
                  ),
                  _TimeTab(wo: wo),
                  _TechTab(wo: wo),
                  _LocationTab(wo: wo),
                  _PartsTab(wo: wo),
                  _EvidenceTab(wo: wo),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _s(dynamic v) => (v ?? '').toString().trim();

  static String _initialsFrom(String text) {
    final clean = text.trim();
    if (clean.isEmpty) return '?';

    final parts = clean
        .split(RegExp(r'\s+'))
        .where((e) => e.isNotEmpty)
        .toList();

    final first = parts.isNotEmpty ? parts[0][0] : '';
    final second = parts.length > 1 ? parts[1][0] : '';
    final out = (first + second).toUpperCase();

    return out.isEmpty ? '?' : out;
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.text,
    required this.bg,
    required this.fg,
    required this.border,
  });

  final String text;
  final Color bg;
  final Color fg;
  final Color border;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: border),
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: fg, fontWeight: FontWeight.w800, fontSize: 12),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.subtitle,
    required this.children,
  });

  final String title;
  final String subtitle;
  final List<Widget> children;

  static const _brand = Color(0xFF0B2A4A);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 18),
      children: [
        Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFFE7EEF8),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.info_outline_rounded, color: _brand),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  color: _brand,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: TextStyle(
            color: _brand.withValues(alpha: 0.60),
            fontSize: 12.5,
          ),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }
}

class _FieldRow extends StatelessWidget {
  const _FieldRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  static const _brand = Color(0xFF0B2A4A);

  @override
  Widget build(BuildContext context) {
    final v = value.trim().isEmpty ? '—' : value.trim();

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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFE7EEF8),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: _brand, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      color: _brand,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    v,
                    style: TextStyle(
                      color: _brand.withValues(alpha: 0.85),
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GeneralTab extends ConsumerWidget {
  const _GeneralTab({
    required this.wo,
    required this.users,
    required this.customers,
    required this.projects,
  });

  final Map<String, dynamic> wo;
  final List<Map<String, dynamic>> users;
  final List<Map<String, dynamic>> customers;
  final List<Map<String, dynamic>> projects;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assignedText = _assignedToText(
      ref: ref,
      assignedValue: wo['text_assigned_id'],
      users: users,
    );

    final customerText = _customerToText(
      ref: ref,
      customerId: wo['sel_customer_id'],
      customers: customers,
    );

    final projectText = _projectToText(
      ref: ref,
      projectId: wo['sel_project_id'],
      projects: projects,
    );

    return _Section(
      title: 'Información General',
      subtitle: 'Datos principales de la Work Order.',
      children: [
        _FieldRow(
          icon: Icons.title_rounded,
          label: 'Nombre',
          value: _s(wo['text_nameWorkOrder_id']),
        ),
        _FieldRow(
          icon: Icons.business_rounded,
          label: 'Cliente',
          value: customerText,
        ),
        _FieldRow(
          icon: Icons.account_tree_rounded,
          label: 'Proyecto',
          value: projectText,
        ),
        _FieldRow(
          icon: Icons.category_rounded,
          label: 'Tipo',
          value: _s(wo['sel_type_id']),
        ),
        _FieldRow(
          icon: Icons.layers_rounded,
          label: 'Clase',
          value: _s(wo['sel_class_id']),
        ),
        _FieldRow(
          icon: Icons.groups_rounded,
          label: 'Asignado a',
          value: assignedText,
        ),
      ],
    );
  }

  String _s(dynamic v) => (v ?? '').toString().trim();

  String _assignedToText({
    required WidgetRef ref,
    required dynamic assignedValue,
    required List<Map<String, dynamic>> users,
  }) {
    final logger = ref.watch(loggerProvider);
    final ids = _normalizeAssignedIds(assignedValue);

    logger.i(
      '[_GeneralTab][users] assignedValue=$assignedValue '
      '(${assignedValue?.runtimeType}) | idsNormalizados=$ids',
    );

    if (ids.isEmpty) return '';

    final userMap = <String, String>{};

    for (final user in users) {
      final id = (user['_id'] ?? '').toString().trim();
      if (id.isEmpty) continue;

      final name = _resolveUserDisplayName(user);
      userMap[id] = name.isEmpty ? id : name;
    }

    final resolved = ids.map((id) => userMap[id] ?? id).toList();
    final result = resolved.join(', ');

    logger.i('[_GeneralTab][users] Resultado final assignedText=$result');
    return result;
  }

  String _customerToText({
    required WidgetRef ref,
    required dynamic customerId,
    required List<Map<String, dynamic>> customers,
  }) {
    final logger = ref.watch(loggerProvider);
    final id = _s(customerId);
    if (id.isEmpty) return '';

    final customerMap = <String, String>{};

    for (final customer in customers) {
      final customerId = (customer['_id'] ?? '').toString().trim();
      if (customerId.isEmpty) continue;

      final name = _resolveCustomerDisplayName(customer);
      customerMap[customerId] = name.isEmpty ? customerId : name;
    }

    final result = customerMap[id] ?? id;
    logger.i('[_GeneralTab][customers] customerId=$id -> $result');
    return result;
  }

  String _projectToText({
    required WidgetRef ref,
    required dynamic projectId,
    required List<Map<String, dynamic>> projects,
  }) {
    final logger = ref.watch(loggerProvider);
    final id = _s(projectId);
    if (id.isEmpty) return '';

    final projectMap = <String, String>{};

    for (final project in projects) {
      final pid = (project['_id'] ?? '').toString().trim();
      if (pid.isEmpty) continue;

      final name = _resolveProjectDisplayName(project);
      projectMap[pid] = name.isEmpty ? pid : name;
    }

    final result = projectMap[id] ?? id;
    logger.i('[_GeneralTab][projects] projectId=$id -> $result');
    return result;
  }

  List<String> _normalizeAssignedIds(dynamic value) {
    if (value == null) return <String>[];

    if (value is String) {
      final v = value.trim();
      return v.isEmpty ? <String>[] : <String>[v];
    }

    if (value is List) {
      return value
          .map((e) => e.toString().trim())
          .where((e) => e.isNotEmpty)
          .toList();
    }

    final fallback = value.toString().trim();
    return fallback.isEmpty ? <String>[] : <String>[fallback];
  }

  String _resolveUserDisplayName(Map<String, dynamic> user) {
    final candidates = [
      user['name'],
      user['nombre'],
      user['fullName'],
      user['displayName'],
      user['text_name_id'],
      user['text_fullName_id'],
      user['email'],
    ];

    for (final candidate in candidates) {
      final value = (candidate ?? '').toString().trim();
      if (value.isNotEmpty) return value;
    }

    return '';
  }

  String _resolveCustomerDisplayName(Map<String, dynamic> customer) {
    final candidates = [
      customer['text_custName_id'],
      customer['name'],
      customer['nombre'],
      customer['displayName'],
      customer['fullName'],
      customer['text_firstName_id'],
      customer['text_companyName_id'],
      customer['email'],
    ];

    for (final candidate in candidates) {
      final value = (candidate ?? '').toString().trim();
      if (value.isNotEmpty) return value;
    }

    final firstName = (customer['text_firstName_id'] ?? '').toString().trim();
    final lastName = (customer['text_lastName_id'] ?? '').toString().trim();
    final joined = '$firstName $lastName'.trim();
    if (joined.isNotEmpty) return joined;

    return '';
  }

  String _resolveProjectDisplayName(Map<String, dynamic> project) {
    final candidates = [
      project['text_nameProject_id'],
      project['name'],
      project['nombre'],
      project['displayName'],
      project['text_projectName_id'],
    ];

    for (final candidate in candidates) {
      final value = (candidate ?? '').toString().trim();
      if (value.isNotEmpty) return value;
    }

    return '';
  }
}

class _TimeTab extends StatelessWidget {
  const _TimeTab({required this.wo});
  final Map<String, dynamic> wo;

  @override
  Widget build(BuildContext context) {
    final start = _s(wo['date_start_id']);
    final end = _s(wo['date_end_id']);
    final elapsed = wo['num_elapsedMs_id']?.toString() ?? '';

    final history = wo['text_dateTime_id'];
    final historyCount = (history is List) ? history.length.toString() : '0';

    return _Section(
      title: 'Tiempo y Programación',
      subtitle: 'Programación y tiempo acumulado.',
      children: [
        _FieldRow(
          icon: Icons.play_circle_outline_rounded,
          label: 'Inicio',
          value: start,
        ),
        _FieldRow(icon: Icons.stop_circle_outlined, label: 'Fin', value: end),
        _FieldRow(
          icon: Icons.timer_outlined,
          label: 'Tiempo acumulado (ms)',
          value: elapsed,
        ),
        _FieldRow(
          icon: Icons.history_rounded,
          label: 'Historial (registros)',
          value: historyCount,
        ),
        const SizedBox(height: 4),
        const _FieldRow(
          icon: Icons.pending_actions_rounded,
          label: 'Timer',
          value: 'Pendiente: play / pause (se implementa después).',
        ),
      ],
    );
  }

  String _s(dynamic v) => (v ?? '').toString().trim();
}

class _TechTab extends StatelessWidget {
  const _TechTab({required this.wo});
  final Map<String, dynamic> wo;

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'Detalles Técnicos',
      subtitle: 'Notas, tareas y pendientes.',
      children: [
        _FieldRow(
          icon: Icons.description_outlined,
          label: 'Notas técnicas',
          value: _s(wo['text_workTechNotes_id']),
        ),
        _FieldRow(
          icon: Icons.checklist_rounded,
          label: 'Tareas',
          value: _s(wo['text_tasks_id']),
        ),
        _FieldRow(
          icon: Icons.rule_folder_rounded,
          label: 'To Do',
          value: _s(wo['text_toDo_id']),
        ),
      ],
    );
  }

  String _s(dynamic v) => (v ?? '').toString().trim();
}

class _LocationTab extends StatelessWidget {
  const _LocationTab({required this.wo});
  final Map<String, dynamic> wo;

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'Ubicación',
      subtitle: 'Lugar y logística del trabajo.',
      children: [
        _FieldRow(
          icon: Icons.location_on_outlined,
          label: 'Lugar de trabajo',
          value: _s(wo['text_workLocation_id']),
        ),
      ],
    );
  }

  String _s(dynamic v) => (v ?? '').toString().trim();
}

class _PartsTab extends StatelessWidget {
  const _PartsTab({required this.wo});
  final Map<String, dynamic> wo;

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'Partes / Repuestos',
      subtitle: 'Control de solicitudes y entregas.',
      children: [
        _FieldRow(
          icon: Icons.inventory_2_outlined,
          label: 'Partes a entregar',
          value: _s(wo['text_partsToDeliver_id']),
        ),
        _FieldRow(
          icon: Icons.send_rounded,
          label: 'Solicitar partes',
          value: _s(wo['text_requestParts_id']),
        ),
        _FieldRow(
          icon: Icons.done_all_rounded,
          label: 'Partes usadas (hecho)',
          value: _s(wo['text_donePartsUsed_id']),
        ),
        _FieldRow(
          icon: Icons.pending_rounded,
          label: 'Pendiente / Partes necesarias',
          value: _s(wo['text_leftToDoPartsNeeded_id']),
        ),
      ],
    );
  }

  String _s(dynamic v) => (v ?? '').toString().trim();
}

class _EvidenceTab extends StatelessWidget {
  const _EvidenceTab({required this.wo});
  final Map<String, dynamic> wo;

  @override
  Widget build(BuildContext context) {
    final files = wo['files_infoImagesUpload_id'];
    final count = (files is List) ? files.length.toString() : '0';

    return _Section(
      title: 'Evidencias',
      subtitle: 'Documentación e imágenes asociadas.',
      children: [
        _FieldRow(
          icon: Icons.image_outlined,
          label: 'Imágenes adjuntas (cantidad)',
          value: count,
        ),
        const _FieldRow(
          icon: Icons.add_a_photo_outlined,
          label: 'Adjuntar imágenes',
          value: 'Pendiente: uploader / cámara (se implementa después).',
        ),
      ],
    );
  }
}
