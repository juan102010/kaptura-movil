import 'package:flutter/material.dart';

class ProjectDetailPage extends StatelessWidget {
  const ProjectDetailPage({super.key, required this.project});

  final Map<String, dynamic> project;

  dynamic _readPath(dynamic source, List<dynamic> path) {
    dynamic current = source;

    for (final segment in path) {
      if (current == null) return null;

      if (segment is String) {
        if (current is Map<String, dynamic>) {
          current = current[segment];
        } else if (current is Map) {
          current = current[segment];
        } else {
          return null;
        }
      } else if (segment is int) {
        if (current is List && segment >= 0 && segment < current.length) {
          current = current[segment];
        } else {
          return null;
        }
      } else {
        return null;
      }
    }

    return current;
  }

  String _stringValue(dynamic value, {String fallback = 'No disponible'}) {
    if (value == null) return fallback;

    final text = value.toString().trim();
    if (text.isEmpty) return fallback;

    return text;
  }

  @override
  Widget build(BuildContext context) {
    final id = _stringValue(project['_id']);
    final customerCode = _stringValue(project['text_customerCode_id']);
    final stateProject = _stringValue(project['text_stateProject_id']);
    final dateCreate = _stringValue(project['date_dateCreateProject_id']);
    final nameProject = _stringValue(project['text_nameProject_id']);

    final firstWorkOrderId = _stringValue(
      _readPath(project, ['list_workOrder_id', 0, 'id']),
    );

    final firstWorkOrderName = _stringValue(
      _readPath(project, ['list_workOrder_id', 0, 'name']),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Project Detail')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionCard(
            title: 'Información principal',
            children: [
              _DetailRow(label: 'ID', value: id),
              _DetailRow(label: 'Nombre del proyecto', value: nameProject),
              _DetailRow(label: 'Estado', value: stateProject),
              _DetailRow(label: 'Fecha de creación', value: dateCreate),
              _DetailRow(label: 'Código de cliente', value: customerCode),
            ],
          ),
          const SizedBox(height: 12),
          _SectionCard(
            title: 'Ejemplo de campos anidados',
            children: [
              _DetailRow(label: 'First Work Order Id', value: firstWorkOrderId),
              _DetailRow(
                label: 'First Work Order Name',
                value: firstWorkOrderName,
              ),
            ],
          ),
          const SizedBox(height: 12),
          _SectionCard(
            title: 'Raw preview',
            children: [
              SelectableText(
                project.toString(),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 4),
          Text(value),
        ],
      ),
    );
  }
}
