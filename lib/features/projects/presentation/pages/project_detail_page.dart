import 'package:flutter/material.dart';

import '../../../../core/localization/localization_extension.dart';
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
        appBar: AppBar(title: Text(context.l10n.projectDetail)),
        body: Center(child: Text(context.l10n.projectNotFound(projectId))),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.projectDetail)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppSectionCard(
            title: context.l10n.mainInformation,
            children: [
              AppKeyValueRow(label: context.l10n.idLabel, value: project!.id),
              AppKeyValueRow(
                label: context.l10n.projectName,
                value: project!.name,
              ),
              AppKeyValueRow(
                label: context.l10n.status,
                value: project!.status,
              ),
              AppKeyValueRow(
                label: context.l10n.createdAt,
                value: project!.dateCreated,
              ),
              AppKeyValueRow(
                label: context.l10n.customerCode,
                value: project!.customerCode,
              ),
            ],
          ),
          const SizedBox(height: 12),
          AppSectionCard(
            title: context.l10n.nestedFields,
            children: [
              AppKeyValueRow(
                label: context.l10n.firstWorkOrderId,
                value: project!.firstWorkOrderId,
              ),
              AppKeyValueRow(
                label: context.l10n.firstWorkOrderName,
                value: project!.firstWorkOrderName,
              ),
            ],
          ),
          const SizedBox(height: 12),
          AppSectionCard(
            title: context.l10n.rawPreview,
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
