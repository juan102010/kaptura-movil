import 'package:flutter/material.dart';

import '../../../../core/ui/widgets/app_key_value_row.dart';
import '../../../../core/ui/widgets/app_section_card.dart';
import '../../domain/entities/project_entity.dart';

class ProjectDetailPage extends StatelessWidget {
  const ProjectDetailPage({super.key, required this.projectId, this.project});

  final String projectId;
  final ProjectEntity? project;

  @override
  Widget build(BuildContext context) {
    if (project == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Project Detail')),
        body: Center(
          child: Text('No se encontro el proyecto para id: $projectId'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Project Detail')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppSectionCard(
            title: 'Informacion principal',
            children: [
              AppKeyValueRow(label: 'ID', value: project!.id),
              AppKeyValueRow(
                label: 'Nombre del proyecto',
                value: project!.name,
              ),
              AppKeyValueRow(label: 'Estado', value: project!.status),
              AppKeyValueRow(
                label: 'Fecha de creacion',
                value: project!.dateCreated,
              ),
              AppKeyValueRow(
                label: 'Codigo de cliente',
                value: project!.customerCode,
              ),
            ],
          ),
          const SizedBox(height: 12),
          AppSectionCard(
            title: 'Campos anidados',
            children: [
              AppKeyValueRow(
                label: 'First Work Order Id',
                value: project!.firstWorkOrderId,
              ),
              AppKeyValueRow(
                label: 'First Work Order Name',
                value: project!.firstWorkOrderName,
              ),
            ],
          ),
          const SizedBox(height: 12),
          AppSectionCard(
            title: 'Raw preview',
            children: [
              SelectableText(
                project!.rawData.toString(),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
