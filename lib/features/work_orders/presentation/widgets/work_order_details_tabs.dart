import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/providers.dart';
import 'work_order_customer_sheets.dart';
import 'work_order_details_shared_widgets.dart';

class GeneralTab extends ConsumerWidget {
  const GeneralTab({
    super.key,
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

    final customerResolved = _resolveCustomer(
      ref: ref,
      customerId: wo['sel_customer_id'],
      customers: customers,
    );

    final projectText = _projectToText(
      ref: ref,
      projectId: wo['sel_project_id'],
      projects: projects,
    );

    return WorkOrderSection(
      title: 'Información General',
      subtitle: 'Datos principales de la Work Order.',
      children: [
        WorkOrderFieldRow(
          icon: Icons.title_rounded,
          label: 'Nombre',
          value: WorkOrderDetailsUiUtils.s(wo['text_nameWorkOrder_id']),
        ),
        WorkOrderFieldRow(
          icon: Icons.business_rounded,
          label: 'Cliente',
          value: customerResolved.displayText,
          showChevron: customerResolved.customer != null,
          onTap: customerResolved.customer == null
              ? null
              : () {
                  final customer = customerResolved.customer!;
                  final title = _resolveCustomerDisplayName(customer);
                  final rows = _buildCustomerSummaryRows(customer);
                  final notes = _extractServiceNotes(customer);

                  CustomerBottomSheetHelpers.showCustomerBottomSheet(
                    context: context,
                    ref: ref,
                    customer: customer,
                    title: title,
                    rows: rows,
                    notes: notes,
                  );
                },
        ),
        WorkOrderFieldRow(
          icon: Icons.account_tree_rounded,
          label: 'Proyecto',
          value: projectText,
        ),
        WorkOrderFieldRow(
          icon: Icons.category_rounded,
          label: 'Tipo',
          value: WorkOrderDetailsUiUtils.s(wo['sel_type_id']),
        ),
        WorkOrderFieldRow(
          icon: Icons.layers_rounded,
          label: 'Clase',
          value: WorkOrderDetailsUiUtils.s(wo['sel_class_id']),
        ),
        WorkOrderFieldRow(
          icon: Icons.groups_rounded,
          label: 'Asignado a',
          value: assignedText,
        ),
      ],
    );
  }

  List<DisplayRowData> _buildCustomerSummaryRows(
    Map<String, dynamic> customer,
  ) {
    final rows = <DisplayRowData>[];

    void addRow(String label, dynamic value) {
      final text = _stringifyValue(value);
      if (text.isEmpty) return;
      rows.add(DisplayRowData(label: label, value: text));
    }

    addRow('Nombre cliente', customer['text_custName_id']);
    addRow('Tipo cliente', customer['rad_clientType_id']);
    addRow('Primer nombre', customer['text_firstName_id']);
    addRow('Apellido', customer['text_lastName_id']);
    addRow('Correo principal', customer['text_mainEmail_id']);
    addRow('Celular', customer['text_mobile_id']);
    addRow('Teléfono principal', customer['text_mainPhone_id']);
    addRow('Dirección', customer['text_street_id']);

    return rows;
  }

  List<ServiceCategoryNote> _extractServiceNotes(
    Map<String, dynamic> customer,
  ) {
    final result = <ServiceCategoryNote>[];
    final raw = customer['obj_categoriesOfServices_id'];

    if (raw is! Map) return result;

    for (final entry in raw.entries) {
      final categoryName = entry.key.toString().trim();
      final value = entry.value;

      if (value is! List || value.isEmpty) continue;

      final first = value.first;
      if (first is! Map) continue;

      final message = _stringifyValue(first['message']);
      final images = _normalizeImages(first['images']);

      result.add(
        ServiceCategoryNote(
          categoryName: categoryName,
          message: message,
          images: images,
        ),
      );
    }

    return result;
  }

  List<Map<String, dynamic>> _normalizeImages(dynamic value) {
    if (value is! List) return <Map<String, dynamic>>[];

    return value
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  String _stringifyValue(dynamic value) {
    if (value == null) return '';

    if (value is List) {
      final items = value
          .map((e) => e == null ? '' : e.toString().trim())
          .where((e) => e.isNotEmpty)
          .toList();
      return items.join(', ');
    }

    if (value is Map) {
      return value.toString();
    }

    return value.toString().trim();
  }

  String _assignedToText({
    required WidgetRef ref,
    required dynamic assignedValue,
    required List<Map<String, dynamic>> users,
  }) {
    final logger = ref.watch(loggerProvider);
    final ids = _normalizeAssignedIds(assignedValue);

    logger.i(
      '[GeneralTab][users] assignedValue=$assignedValue '
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

    logger.i('[GeneralTab][users] Resultado final assignedText=$result');
    return result;
  }

  ResolvedCustomer _resolveCustomer({
    required WidgetRef ref,
    required dynamic customerId,
    required List<Map<String, dynamic>> customers,
  }) {
    final logger = ref.watch(loggerProvider);
    final id = WorkOrderDetailsUiUtils.s(customerId);

    if (id.isEmpty) {
      return const ResolvedCustomer(displayText: '', customer: null);
    }

    Map<String, dynamic>? foundCustomer;
    for (final customer in customers) {
      final currentId = (customer['_id'] ?? '').toString().trim();
      if (currentId == id) {
        foundCustomer = customer;
        break;
      }
    }

    final displayText = foundCustomer == null
        ? id
        : (_resolveCustomerDisplayName(foundCustomer).isEmpty
              ? id
              : _resolveCustomerDisplayName(foundCustomer));

    logger.i(
      '[GeneralTab][customers] customerId=$id -> displayText=$displayText '
      '| found=${foundCustomer != null}',
    );

    return ResolvedCustomer(displayText: displayText, customer: foundCustomer);
  }

  String _projectToText({
    required WidgetRef ref,
    required dynamic projectId,
    required List<Map<String, dynamic>> projects,
  }) {
    final logger = ref.watch(loggerProvider);
    final id = WorkOrderDetailsUiUtils.s(projectId);
    if (id.isEmpty) return '';

    final projectMap = <String, String>{};

    for (final project in projects) {
      final pid = (project['_id'] ?? '').toString().trim();
      if (pid.isEmpty) continue;

      final name = _resolveProjectDisplayName(project);
      projectMap[pid] = name.isEmpty ? pid : name;
    }

    final result = projectMap[id] ?? id;
    logger.i('[GeneralTab][projects] projectId=$id -> $result');
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
      customer['text_mainEmail_id'],
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

class TimeTab extends StatelessWidget {
  const TimeTab({super.key, required this.wo});

  final Map<String, dynamic> wo;

  @override
  Widget build(BuildContext context) {
    final start = WorkOrderDetailsUiUtils.s(wo['date_start_id']);
    final end = WorkOrderDetailsUiUtils.s(wo['date_end_id']);
    final elapsed = wo['num_elapsedMs_id']?.toString() ?? '';

    final history = wo['text_dateTime_id'];
    final historyCount = (history is List) ? history.length.toString() : '0';

    return WorkOrderSection(
      title: 'Tiempo y Programación',
      subtitle: 'Programación y tiempo acumulado.',
      children: [
        WorkOrderFieldRow(
          icon: Icons.play_circle_outline_rounded,
          label: 'Inicio',
          value: start,
        ),
        WorkOrderFieldRow(
          icon: Icons.stop_circle_outlined,
          label: 'Fin',
          value: end,
        ),
        WorkOrderFieldRow(
          icon: Icons.timer_outlined,
          label: 'Tiempo acumulado (ms)',
          value: elapsed,
        ),
        WorkOrderFieldRow(
          icon: Icons.history_rounded,
          label: 'Historial (registros)',
          value: historyCount,
        ),
        const SizedBox(height: 4),
        const WorkOrderFieldRow(
          icon: Icons.pending_actions_rounded,
          label: 'Timer',
          value: 'Pendiente: play / pause (se implementa después).',
        ),
      ],
    );
  }
}

class TechTab extends StatelessWidget {
  const TechTab({super.key, required this.wo});

  final Map<String, dynamic> wo;

  @override
  Widget build(BuildContext context) {
    return WorkOrderSection(
      title: 'Detalles Técnicos',
      subtitle: 'Notas, tareas y pendientes.',
      children: [
        WorkOrderFieldRow(
          icon: Icons.description_outlined,
          label: 'Notas técnicas',
          value: WorkOrderDetailsUiUtils.s(wo['text_workTechNotes_id']),
        ),
        WorkOrderFieldRow(
          icon: Icons.checklist_rounded,
          label: 'Tareas',
          value: WorkOrderDetailsUiUtils.s(wo['text_tasks_id']),
        ),
        WorkOrderFieldRow(
          icon: Icons.rule_folder_rounded,
          label: 'To Do',
          value: WorkOrderDetailsUiUtils.s(wo['text_toDo_id']),
        ),
      ],
    );
  }
}

class LocationTab extends StatelessWidget {
  const LocationTab({super.key, required this.wo});

  final Map<String, dynamic> wo;

  @override
  Widget build(BuildContext context) {
    return WorkOrderSection(
      title: 'Ubicación',
      subtitle: 'Lugar y logística del trabajo.',
      children: [
        WorkOrderFieldRow(
          icon: Icons.location_on_outlined,
          label: 'Lugar de trabajo',
          value: WorkOrderDetailsUiUtils.s(wo['text_workLocation_id']),
        ),
      ],
    );
  }
}

class PartsTab extends StatelessWidget {
  const PartsTab({super.key, required this.wo});

  final Map<String, dynamic> wo;

  @override
  Widget build(BuildContext context) {
    return WorkOrderSection(
      title: 'Partes / Repuestos',
      subtitle: 'Control de solicitudes y entregas.',
      children: [
        WorkOrderFieldRow(
          icon: Icons.inventory_2_outlined,
          label: 'Partes a entregar',
          value: WorkOrderDetailsUiUtils.s(wo['text_partsToDeliver_id']),
        ),
        WorkOrderFieldRow(
          icon: Icons.send_rounded,
          label: 'Solicitar partes',
          value: WorkOrderDetailsUiUtils.s(wo['text_requestParts_id']),
        ),
        WorkOrderFieldRow(
          icon: Icons.done_all_rounded,
          label: 'Partes usadas (hecho)',
          value: WorkOrderDetailsUiUtils.s(wo['text_donePartsUsed_id']),
        ),
        WorkOrderFieldRow(
          icon: Icons.pending_rounded,
          label: 'Pendiente / Partes necesarias',
          value: WorkOrderDetailsUiUtils.s(wo['text_leftToDoPartsNeeded_id']),
        ),
      ],
    );
  }
}

class EvidenceTab extends StatelessWidget {
  const EvidenceTab({super.key, required this.wo});

  final Map<String, dynamic> wo;

  @override
  Widget build(BuildContext context) {
    final files = wo['files_infoImagesUpload_id'];
    final count = (files is List) ? files.length.toString() : '0';

    return WorkOrderSection(
      title: 'Evidencias',
      subtitle: 'Documentación e imágenes asociadas.',
      children: [
        WorkOrderFieldRow(
          icon: Icons.image_outlined,
          label: 'Imágenes adjuntas (cantidad)',
          value: count,
        ),
        const WorkOrderFieldRow(
          icon: Icons.add_a_photo_outlined,
          label: 'Adjuntar imágenes',
          value: 'Pendiente: uploader / cámara (se implementa después).',
        ),
      ],
    );
  }
}
