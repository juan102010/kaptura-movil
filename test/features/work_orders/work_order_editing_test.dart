import 'package:flutter_kaptura/features/work_orders/domain/entities/work_order_entity.dart';
import 'package:flutter_kaptura/features/customers/domain/entities/customer_entity.dart';
import 'package:flutter_kaptura/features/work_orders/presentation/widgets/work_order_details_tabs.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('validates a latitude and longitude stored as one string', () {
    final coordinates = WorkCoordinates.tryParse('4.7110,-74.0721');
    expect(coordinates?.latitude, 4.7110);
    expect(coordinates?.longitude, -74.0721);
    expect(WorkCoordinates.tryParse('not-coordinates'), isNull);
    expect(WorkCoordinates.tryParse('95,-74'), isNull);
  });

  test('patches the raw work order used by offline cache', () {
    const workOrder = WorkOrderEntity(
      id: 'wo-1',
      name: 'WO',
      assignedIds: [],
      startAt: null,
      endAt: null,
      rawData: {
        '_id': 'wo-1',
        'text_nameWorkOrder_id': 'WO',
        'text_tasks_id': 'Before',
      },
    );

    final updated = workOrder.withPatchedRawData({'text_tasks_id': 'After'});
    expect(updated.tasks, 'After');
    expect(updated.rawData['_id'], 'wo-1');
  });

  test('patches customer categories without losing customer data', () {
    const customer = CustomerEntity(
      id: 'customer-1',
      displayName: 'Diego Torres',
      clientType: 'Persona',
      mainEmail: 'diego@example.com',
      mainPhone: '',
      mobile: '',
      city: 'Bucaramanga',
      stateName: 'Santander',
      country: 'Colombia',
      street: '',
      rawData: {'_id': 'customer-1', 'text_firstName_id': 'Diego'},
    );

    final updated = customer.withPatchedRawData({
      'obj_categoriesOfServices_id': {
        'Camaras': [
          {'message': 'Nueva nota', 'images': []},
        ],
      },
    });

    expect(updated.rawData['text_firstName_id'], 'Diego');
    expect(
      (updated.rawData['obj_categoriesOfServices_id'] as Map)['Camaras'],
      isNotEmpty,
    );
  });
}
