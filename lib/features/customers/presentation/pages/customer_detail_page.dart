import 'package:flutter/material.dart';

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
        appBar: AppBar(title: const Text('Customer Detail')),
        body: Center(
          child: Text('No se encontro el cliente para id: $customerId'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Customer Detail')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppKeyValueRow(label: 'ID', value: customer!.id, labelWidth: 160),
          AppKeyValueRow(
            label: 'Tipo',
            value: customer!.clientType,
            labelWidth: 160,
          ),
          const Divider(),
          AppKeyValueRow(
            label: 'Email',
            value: customer!.mainEmail,
            labelWidth: 160,
          ),
          AppKeyValueRow(
            label: 'Phone',
            value: customer!.mainPhone,
            labelWidth: 160,
          ),
          AppKeyValueRow(
            label: 'Mobile',
            value: customer!.mobile,
            labelWidth: 160,
          ),
          const Divider(),
          AppKeyValueRow(label: 'City', value: customer!.city, labelWidth: 160),
          AppKeyValueRow(
            label: 'State',
            value: customer!.stateName,
            labelWidth: 160,
          ),
          AppKeyValueRow(
            label: 'Country',
            value: customer!.country,
            labelWidth: 160,
          ),
          AppKeyValueRow(
            label: 'Street',
            value: customer!.street,
            labelWidth: 160,
          ),
          const Divider(),
          AppKeyValueRow(
            label: 'Camera Message',
            value: customer!.cameraMessage,
            labelWidth: 160,
          ),
          AppKeyValueRow(
            label: 'First camera image URL',
            value: customer!.firstCameraImageUrl,
            labelWidth: 160,
          ),
          const SizedBox(height: 12),
          Text(
            'Este detalle sigue funcionando offline porque sale del cache local.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
