import 'package:flutter_kaptura/features/work_orders/domain/entities/work_order_entity.dart';
import 'package:flutter_kaptura/features/customers/domain/entities/customer_entity.dart';
import 'package:flutter_kaptura/features/customers/data/models/customer_model.dart';
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

  test('normalizes a Mongo object id returned for a customer', () {
    final customer = CustomerModel.fromMap({
      '_id': {r'$oid': '688c058ffc6491b6d74ed4fc'},
    });

    expect(customer.id, '688c058ffc6491b6d74ed4fc');
    expect(customer.matchesId('688c058ffc6491b6d74ed4fc'), isTrue);
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

  test('reads customer coordinates from the new list fields', () {
    const customer = CustomerEntity(
      id: 'customer-1',
      displayName: 'Customer',
      clientType: '',
      mainEmail: '',
      mainPhone: '',
      mobile: '',
      city: '',
      stateName: '',
      country: '',
      street: '',
      rawData: {
        'text_addressLatitude_id': [25.8955809],
        'text_addressLongitude_id': [-80.3358456],
      },
    );

    final coordinates = WorkCoordinates.tryFromCustomer(customer);
    expect(coordinates?.latitude, 25.8955809);
    expect(coordinates?.longitude, -80.3358456);
    expect(coordinates?.formatted, '25.8955809,-80.3358456');
  });

  test('selects customer coordinates from the work order location', () {
    const customer = CustomerEntity(
      id: 'customer-1',
      displayName: 'Alfonso Gutierrez',
      clientType: '',
      mainEmail: '',
      mainPhone: '',
      mobile: '',
      city: '',
      stateName: '',
      country: '',
      street: '',
      rawData: {
        'text_street_id': [
          'Direccion Principal, Cra. 30c # 65-42, Manizales, Caldas, Colombia',
          'Direccion de Facturacion, Miami, Florida, EE. UU.',
        ],
        'text_addressLatitude_id': [5.053679, 25.7616798],
        'text_addressLongitude_id': [-75.49485, -80.1917902],
      },
    );
    const workLocation =
        'Direccion de Facturacion, Miami, Florida, EE. UU. | '
        'Lat: 25.7616798 | Lng: -80.1917902';

    final coordinates = WorkCoordinates.tryFromCustomer(customer, workLocation);
    expect(coordinates?.latitude, 25.7616798);
    expect(coordinates?.longitude, -80.1917902);
    expect(WorkCoordinates.addressIndexFor(customer, workLocation), 1);
  });

  test(
    'matches a customer address by text when coordinates are not embedded',
    () {
      const customer = CustomerEntity(
        id: 'customer-1',
        displayName: 'Customer',
        clientType: '',
        mainEmail: '',
        mainPhone: '',
        mobile: '',
        city: '',
        stateName: '',
        country: '',
        street: '',
        rawData: {
          'text_address_id': ['Bogotá, Colombia', 'Miami, Florida, EE. UU.'],
          'text_addressLatitude_id': [4.711, 25.7616798],
          'text_addressLongitude_id': [-74.0721, -80.1917902],
        },
      );

      final coordinates = WorkCoordinates.tryFromCustomer(
        customer,
        'Visita técnica - Miami, Florida, EE. UU.',
      );
      expect(coordinates?.latitude, 25.7616798);
      expect(coordinates?.longitude, -80.1917902);
    },
  );
}
