import 'package:flutter/material.dart';

import '../../../../core/localization/localization_extension.dart';
import '../../../../core/ui/widgets/app_key_value_row.dart';
import '../../domain/entities/customer_entity.dart';

class CustomerDetailPage extends StatelessWidget {
  const CustomerDetailPage({
    super.key,
    required this.customerId,
    this.customer,
  });

  final String customerId;
  final CustomerEntity? customer;

  @override
  Widget build(BuildContext context) {
    if (customer == null) {
      return Scaffold(
        appBar: AppBar(title: Text(context.l10n.customerDetail)),
        body: Center(child: Text(context.l10n.customerNotFound(customerId))),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.customerDetail)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppKeyValueRow(
            label: context.l10n.idLabel,
            value: customer!.id,
            labelWidth: 160,
          ),
          AppKeyValueRow(
            label: context.l10n.type,
            value: customer!.clientType,
            labelWidth: 160,
          ),
          const Divider(),
          AppKeyValueRow(
            label: context.l10n.email,
            value: customer!.mainEmail,
            labelWidth: 160,
          ),
          AppKeyValueRow(
            label: context.l10n.phone,
            value: customer!.mainPhone,
            labelWidth: 160,
          ),
          AppKeyValueRow(
            label: context.l10n.mobile,
            value: customer!.mobile,
            labelWidth: 160,
          ),
          const Divider(),
          AppKeyValueRow(
            label: context.l10n.city,
            value: customer!.city,
            labelWidth: 160,
          ),
          AppKeyValueRow(
            label: context.l10n.state,
            value: customer!.stateName,
            labelWidth: 160,
          ),
          AppKeyValueRow(
            label: context.l10n.country,
            value: customer!.country,
            labelWidth: 160,
          ),
          AppKeyValueRow(
            label: context.l10n.street,
            value: customer!.street,
            labelWidth: 160,
          ),
          const Divider(),
          AppKeyValueRow(
            label: context.l10n.cameraMessage,
            value: customer!.cameraMessage,
            labelWidth: 160,
          ),
          AppKeyValueRow(
            label: context.l10n.firstCameraImageUrl,
            value: customer!.firstCameraImageUrl,
            labelWidth: 160,
          ),
          const SizedBox(height: 12),
          Text(
            context.l10n.offlineDetailNotice,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
