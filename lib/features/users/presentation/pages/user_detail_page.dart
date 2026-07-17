import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../../core/localization/localization_extension.dart';
import '../../../../core/ui/widgets/app_key_value_row.dart';
import '../../../../core/ui/widgets/app_section_card.dart';
import '../../domain/entities/user_list_entity.dart';

class UserDetailPage extends StatelessWidget {
  const UserDetailPage({super.key, required this.userId, this.user});

  final String userId;
  final UserListEntity? user;

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: Text(context.l10n.userDetail)),
        body: Center(child: Text(context.l10n.userNotFound(userId))),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(user!.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppSectionCard(
            title: context.l10n.mainInformation,
            children: [
              AppKeyValueRow(label: '_id', value: user!.id),
              AppKeyValueRow(label: context.l10n.name, value: user!.name),
              AppKeyValueRow(label: context.l10n.email, value: user!.email),
              AppKeyValueRow(
                label: context.l10n.identification,
                value: user!.identification,
              ),
              AppKeyValueRow(label: context.l10n.role, value: user!.role),
              AppKeyValueRow(label: context.l10n.status, value: user!.status),
              AppKeyValueRow(label: context.l10n.scheme, value: user!.scheme),
              AppKeyValueRow(
                label: context.l10n.companyId,
                value: user!.companyId,
              ),
              AppKeyValueRow(
                label: context.l10n.activeCluster,
                value: user!.clusterKey,
              ),
              AppKeyValueRow(
                label: context.l10n.clockStatus,
                value: user!.stateClock,
              ),
            ],
          ),
          const SizedBox(height: 12),
          AppSectionCard(
            title: context.l10n.allowedClusterKeys,
            children: [
              if (user!.allowedClusterKeys.isNotEmpty)
                ...user!.allowedClusterKeys.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text(item),
                  ),
                )
              else
                Text(context.l10n.noData),
            ],
          ),
          const SizedBox(height: 12),
          AppSectionCard(
            title: context.l10n.entryExitHistory,
            children: [
              if (user!.entryAndExitHistory.isNotEmpty)
                SelectableText(
                  const JsonEncoder.withIndent(
                    '  ',
                  ).convert(user!.entryAndExitHistory),
                  style: const TextStyle(fontFamily: 'monospace'),
                )
              else
                Text(context.l10n.noData),
            ],
          ),
          const SizedBox(height: 12),
          AppSectionCard(
            title: context.l10n.fullJson,
            children: [
              SelectableText(
                const JsonEncoder.withIndent('  ').convert(user!.rawData),
                style: const TextStyle(fontFamily: 'monospace'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
