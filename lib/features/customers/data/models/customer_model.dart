import '../../domain/entities/customer_entity.dart';

class CustomerModel extends CustomerEntity {
  const CustomerModel({
    required super.id,
    required super.displayName,
    required super.clientType,
    required super.mainEmail,
    required super.mainPhone,
    required super.mobile,
    required super.city,
    required super.stateName,
    required super.country,
    required super.street,
    required super.rawData,
  });

  factory CustomerModel.fromMap(Map<String, dynamic> map) {
    String recordId(dynamic value) {
      if (value is Map) {
        return (value[r'$oid'] ?? value['oid'] ?? '').toString().trim();
      }
      return (value ?? '').toString().trim();
    }

    String firstStringFromList(dynamic value) {
      if (value is List && value.isNotEmpty) {
        return (value.first ?? '').toString().trim();
      }
      return '';
    }

    final custName = (map['text_custName_id'] ?? '').toString().trim();
    final firstName = (map['text_firstName_id'] ?? '').toString().trim();
    final lastName = (map['text_lastName_id'] ?? '').toString().trim();
    final displayName = custName.isNotEmpty
        ? custName
        : [firstName, lastName].where((item) => item.isNotEmpty).join(' ');

    return CustomerModel(
      id: recordId(map['_id']),
      displayName: displayName,
      clientType: (map['rad_clientType_id'] ?? '').toString().trim(),
      mainEmail: (map['text_mainEmail_id'] ?? '').toString().trim(),
      mainPhone: (map['text_mainPhone_id'] ?? '').toString().trim(),
      mobile: (map['text_mobile_id'] ?? '').toString().trim(),
      city: firstStringFromList(map['text_city_id']),
      stateName: firstStringFromList(map['text_state_id']),
      country: firstStringFromList(map['text_country_id']),
      street: firstStringFromList(map['text_street_id']),
      rawData: Map<String, dynamic>.from(map),
    );
  }

  Map<String, dynamic> toMap() => Map<String, dynamic>.from(rawData);
}
