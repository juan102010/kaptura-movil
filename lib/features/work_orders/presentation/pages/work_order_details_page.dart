import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../home/presentation/providers/home_providers.dart';

class WorkOrderDetailsPage extends ConsumerWidget {
  const WorkOrderDetailsPage({super.key, required this.workOrderId});

  final String workOrderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeControllerProvider);

    // Buscamos en la lista completa (asignadas) para garantizar que exista
    final wo = state.workOrders.cast<Map<String, dynamic>?>().firstWhere(
      (e) => (e?['_id'] ?? '').toString() == workOrderId,
      orElse: () => null,
    );

    if (wo == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Work Order')),
        body: const Center(
          child: Text('No se encontró la Work Order en memoria/cache.'),
        ),
      );
    }

    final title = _s(wo['text_nameWorkOrder_id']);
    final displayTitle = title.isEmpty ? '(Sin nombre)' : title;

    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            displayTitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'General'),
              Tab(text: 'Tiempo'),
              Tab(text: 'Técnico'),
              Tab(text: 'Ubicación'),
              Tab(text: 'Partes'),
              Tab(text: 'Evidencias'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _GeneralTab(wo: wo),
            _TimeTab(wo: wo),
            _TechTab(wo: wo),
            _LocationTab(wo: wo),
            _PartsTab(wo: wo),
            _EvidenceTab(wo: wo),
          ],
        ),
      ),
    );
  }

  static String _s(dynamic v) => (v ?? '').toString().trim();
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }
}

class _FieldRow extends StatelessWidget {
  const _FieldRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final v = value.trim().isEmpty ? '—' : value.trim();

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(v),
          ],
        ),
      ),
    );
  }
}

// ============================
// Tabs
// ============================

class _GeneralTab extends StatelessWidget {
  const _GeneralTab({required this.wo});
  final Map<String, dynamic> wo;

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'Información General',
      children: [
        _FieldRow(label: 'Nombre', value: _s(wo['text_nameWorkOrder_id'])),
        _FieldRow(label: 'Cliente', value: _s(wo['sel_customer_id'])),
        _FieldRow(label: 'Proyecto', value: _s(wo['sel_project_id'])),
        _FieldRow(label: 'Tipo', value: _s(wo['sel_type_id'])),
        _FieldRow(label: 'Clase', value: _s(wo['sel_class_id'])),
        _FieldRow(
          label: 'Asignado a',
          value: _assignedToText(wo['text_assigned_id']),
        ),
      ],
    );
  }

  String _s(dynamic v) => (v ?? '').toString().trim();

  String _assignedToText(dynamic v) {
    if (v == null) return '';
    if (v is String) return v.trim();
    if (v is List) {
      return v
          .map((e) => e.toString().trim())
          .where((e) => e.isNotEmpty)
          .join(', ');
    }
    return v.toString().trim();
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
      children: [
        _FieldRow(label: 'Inicio', value: start),
        _FieldRow(label: 'Fin', value: end),
        _FieldRow(label: 'Tiempo acumulado (ms)', value: elapsed),
        _FieldRow(label: 'Historial (registros)', value: historyCount),

        // Placeholder UI (timer / historial) - en este paso NO implementamos lógica
        const SizedBox(height: 8),
        _FieldRow(
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
      title: 'Detalles Técnicos del Trabajo',
      children: [
        _FieldRow(
          label: 'Notas técnicas',
          value: _s(wo['text_workTechNotes_id']),
        ),
        _FieldRow(label: 'Tareas', value: _s(wo['text_tasks_id'])),
        _FieldRow(label: 'To Do', value: _s(wo['text_toDo_id'])),
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
      title: 'Logística y Ubicación',
      children: [
        _FieldRow(
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
      title: 'Control de Partes / Repuestos',
      children: [
        _FieldRow(
          label: 'Partes a entregar',
          value: _s(wo['text_partsToDeliver_id']),
        ),
        _FieldRow(
          label: 'Solicitar partes',
          value: _s(wo['text_requestParts_id']),
        ),
        _FieldRow(
          label: 'Partes usadas (hecho)',
          value: _s(wo['text_donePartsUsed_id']),
        ),
        _FieldRow(
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
      title: 'Evidencias y Documentación',
      children: [
        _FieldRow(label: 'Imágenes adjuntas (cantidad)', value: count),
        _FieldRow(
          label: 'Adjuntar imágenes',
          value: 'Pendiente: uploader / cámara (se implementa después).',
        ),
      ],
    );
  }
}
