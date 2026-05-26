import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/providers.dart';
import '../../../customers/domain/entities/customer_entity.dart';
import '../../../projects/domain/entities/project_entity.dart';
import '../../../users/domain/entities/user_list_entity.dart';
import '../../domain/entities/work_order_entity.dart';
import 'work_order_customer_sheets.dart';
import 'work_order_details_shared_widgets.dart';
import 'work_order_history_widgets.dart';
import 'work_order_timer_widgets.dart';

class GeneralTab extends ConsumerWidget {
  const GeneralTab({
    super.key,
    required this.wo,
    required this.users,
    required this.customers,
    required this.projects,
  });

  final WorkOrderEntity wo;
  final List<UserListEntity> users;
  final List<CustomerEntity> customers;
  final List<ProjectEntity> projects;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assignedText = _assignedToText(
      ref: ref,
      assignedIds: wo.assignedIds,
      users: users,
    );

    final customerResolved = _resolveCustomer(
      ref: ref,
      customerId: wo.customerId,
      customers: customers,
    );

    final projectText = _projectToText(
      ref: ref,
      projectId: wo.projectId,
      projects: projects,
    );

    final customer = customerResolved.customer;
    final customerTitle = customer?.displayName ?? '';
    final customerRows = customer == null
        ? <DisplayRowData>[]
        : _buildCustomerSummaryRows(customer);
    final customerNotes = customer == null
        ? <ServiceCategoryNote>[]
        : _extractServiceNotes(customer);

    return WorkOrderSection(
      title: 'Informacion General',
      children: [
        WorkOrderFieldRow(
          icon: Icons.business_rounded,
          label: 'Cliente',
          value: customerResolved.displayText,
          showChevron: customer != null,
          onTap: customer == null
              ? null
              : () {
                  CustomerBottomSheetHelpers.showCustomerBottomSheet(
                    context: context,
                    ref: ref,
                    customer: customer,
                    title: customerTitle,
                    rows: customerRows,
                    notes: customerNotes,
                  );
                },
        ),
        if (customer != null && customerNotes.isNotEmpty)
          WorkOrderActionButtonRow(
            icon: Icons.key_rounded,
            label: 'Mostrar credenciales o notas',
            onTap: () {
              CustomerBottomSheetHelpers.showCredentialsBottomSheet(
                context: context,
                title: customerTitle,
                notes: customerNotes,
              );
            },
          ),
        WorkOrderFieldRow(
          icon: Icons.account_tree_rounded,
          label: 'Proyecto',
          value: projectText,
        ),
        WorkOrderFieldRow(
          icon: Icons.groups_rounded,
          label: 'Asignado a',
          value: assignedText,
        ),
        WorkOrderFieldRow(
          icon: Icons.layers_rounded,
          label: 'Clase',
          value: wo.className,
        ),
        WorkOrderFieldRow(
          icon: Icons.category_rounded,
          label: 'Tipo',
          value: wo.typeName,
        ),
      ],
    );
  }

  List<DisplayRowData> _buildCustomerSummaryRows(CustomerEntity customer) {
    final rows = <DisplayRowData>[];
    final raw = customer.rawData;

    void addRow(String label, dynamic value) {
      final text = _stringifyValue(value);
      if (text.isEmpty) return;
      rows.add(DisplayRowData(label: label, value: text));
    }

    addRow('Nombre cliente', raw['text_custName_id']);
    addRow('Tipo cliente', raw['rad_clientType_id']);
    addRow('Primer nombre', raw['text_firstName_id']);
    addRow('Apellido', raw['text_lastName_id']);
    addRow('Correo principal', raw['text_mainEmail_id']);
    addRow('Celular', raw['text_mobile_id']);
    addRow('Telefono principal', raw['text_mainPhone_id']);
    addRow('Direccion', raw['text_street_id']);

    return rows;
  }

  List<ServiceCategoryNote> _extractServiceNotes(CustomerEntity customer) {
    final result = <ServiceCategoryNote>[];
    final raw = customer.rawData['obj_categoriesOfServices_id'];

    if (raw is! Map) return result;

    for (final entry in raw.entries) {
      final categoryName = entry.key.toString().trim();
      final value = entry.value;

      if (value is! List || value.isEmpty) continue;
      final first = value.first;
      if (first is! Map) continue;

      result.add(
        ServiceCategoryNote(
          categoryName: categoryName,
          message: _stringifyValue(first['message']),
          images: _normalizeImages(first['images']),
        ),
      );
    }

    return result;
  }

  List<Map<String, dynamic>> _normalizeImages(dynamic value) {
    if (value is! List) return <Map<String, dynamic>>[];
    return value
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  String _stringifyValue(dynamic value) {
    if (value == null) return '';
    if (value is List) {
      return value
          .map((item) => item == null ? '' : item.toString().trim())
          .where((item) => item.isNotEmpty)
          .join(', ');
    }
    if (value is Map) return value.toString();
    return value.toString().trim();
  }

  String _assignedToText({
    required WidgetRef ref,
    required List<String> assignedIds,
    required List<UserListEntity> users,
  }) {
    final logger = ref.watch(loggerProvider);
    logger.i('[GeneralTab][users] idsNormalizados=$assignedIds');
    if (assignedIds.isEmpty) return '';

    final userMap = <String, String>{};
    for (final user in users) {
      final id = user.id.trim();
      if (id.isEmpty) continue;
      final name = user.name.isEmpty ? user.email : user.name;
      userMap[id] = name.isEmpty ? id : name;
    }

    final result = assignedIds.map((id) => userMap[id] ?? id).join(', ');
    logger.i('[GeneralTab][users] Resultado final assignedText=$result');
    return result;
  }

  ResolvedCustomer _resolveCustomer({
    required WidgetRef ref,
    required String customerId,
    required List<CustomerEntity> customers,
  }) {
    final logger = ref.watch(loggerProvider);
    final id = customerId.trim();
    if (id.isEmpty) {
      return const ResolvedCustomer(displayText: '', customer: null);
    }

    CustomerEntity? foundCustomer;
    for (final customer in customers) {
      if (customer.matchesId(id)) {
        foundCustomer = customer;
        break;
      }
    }

    final displayText = foundCustomer == null
        ? id
        : (foundCustomer.displayName.isEmpty ? id : foundCustomer.displayName);

    logger.i(
      '[GeneralTab][customers] customerId=$id -> displayText=$displayText | found=${foundCustomer != null}',
    );

    return ResolvedCustomer(displayText: displayText, customer: foundCustomer);
  }

  String _projectToText({
    required WidgetRef ref,
    required String projectId,
    required List<ProjectEntity> projects,
  }) {
    final logger = ref.watch(loggerProvider);
    final id = projectId.trim();
    if (id.isEmpty) return '';

    final projectMap = <String, String>{};
    for (final project in projects) {
      final pid = project.id.trim();
      if (pid.isEmpty) continue;
      projectMap[pid] = project.name.isEmpty ? pid : project.name;
    }

    final result = projectMap[id] ?? id;
    logger.i('[GeneralTab][projects] projectId=$id -> $result');
    return result;
  }
}

class TimeTab extends StatefulWidget {
  const TimeTab({super.key, required this.wo});

  final WorkOrderEntity wo;

  @override
  State<TimeTab> createState() => _TimeTabState();
}

class _TimeTabState extends State<TimeTab> {
  late WorkOrderEntity _woLocal;

  @override
  void initState() {
    super.initState();
    _woLocal = widget.wo;
  }

  @override
  void didUpdateWidget(covariant TimeTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.wo.rawData.toString() != widget.wo.rawData.toString()) {
      _woLocal = widget.wo;
    }
  }

  @override
  Widget build(BuildContext context) {
    final workOrderId = _woLocal.id;
    final start = WorkOrderDetailsUiUtils.s(_woLocal.rawData['date_start_id']);
    final end = WorkOrderDetailsUiUtils.s(_woLocal.rawData['date_end_id']);
    final historyItems = _woLocal.timeHistory;

    return WorkOrderSection(
      title: 'Tiempo y Programacion',
      children: [
        WorkOrderTimerCard(
          workOrderId: workOrderId,
          history: historyItems,
          onHistoryUpdated: (newHistory) {
            setState(() {
              _woLocal = _woLocal.withUpdatedTimeHistory(newHistory);
            });
          },
        ),
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
        WorkOrderHistorySummaryRow(history: historyItems),
      ],
    );
  }
}

class TechTab extends StatelessWidget {
  const TechTab({super.key, required this.wo});

  final WorkOrderEntity wo;

  @override
  Widget build(BuildContext context) {
    return WorkOrderSection(
      title: 'Detalles Tecnicos',
      children: [
        WorkOrderFieldRow(
          icon: Icons.description_outlined,
          label: 'Notas tecnicas',
          value: wo.techNotes,
        ),
        WorkOrderFieldRow(
          icon: Icons.checklist_rounded,
          label: 'Tareas',
          value: wo.tasks,
        ),
        WorkOrderFieldRow(
          icon: Icons.rule_folder_rounded,
          label: 'To Do',
          value: wo.todo,
        ),
      ],
    );
  }
}

class LocationTab extends StatelessWidget {
  const LocationTab({super.key, required this.wo});

  final WorkOrderEntity wo;

  @override
  Widget build(BuildContext context) {
    return WorkOrderSection(
      title: 'Ubicacion',
      children: [
        WorkOrderFieldRow(
          icon: Icons.location_on_outlined,
          label: 'Lugar de trabajo',
          value: wo.workLocation,
        ),
      ],
    );
  }
}

class PartsTab extends StatelessWidget {
  const PartsTab({super.key, required this.wo});

  final WorkOrderEntity wo;

  @override
  Widget build(BuildContext context) {
    return WorkOrderSection(
      title: 'Partes / Repuestos',
      children: [
        WorkOrderFieldRow(
          icon: Icons.inventory_2_outlined,
          label: 'Partes a entregar',
          value: wo.partsToDeliver,
        ),
        WorkOrderFieldRow(
          icon: Icons.send_rounded,
          label: 'Solicitar partes',
          value: wo.requestParts,
        ),
        WorkOrderFieldRow(
          icon: Icons.done_all_rounded,
          label: 'Partes usadas (hecho)',
          value: wo.donePartsUsed,
        ),
        WorkOrderFieldRow(
          icon: Icons.pending_rounded,
          label: 'Pendiente / Partes necesarias',
          value: wo.leftToDoPartsNeeded,
        ),
      ],
    );
  }
}

class EvidenceTab extends StatelessWidget {
  const EvidenceTab({super.key, required this.wo});

  final WorkOrderEntity wo;

  @override
  Widget build(BuildContext context) {
    return WorkOrderSection(
      title: 'Evidencias',
      children: [
        WorkOrderFieldRow(
          icon: Icons.image_outlined,
          label: 'Imagenes adjuntas (cantidad)',
          value: wo.evidenceImages.length.toString(),
        ),
        const WorkOrderFieldRow(
          icon: Icons.add_a_photo_outlined,
          label: 'Adjuntar imagenes',
          value: 'Pendiente: uploader / camara (se implementa despues).',
        ),
      ],
    );
  }
}
