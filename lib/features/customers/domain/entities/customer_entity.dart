class CustomerEntity {
  const CustomerEntity({
    required this.id,
    required this.displayName,
    required this.clientType,
    required this.mainEmail,
    required this.mainPhone,
    required this.mobile,
    required this.city,
    required this.stateName,
    required this.country,
    required this.street,
    required this.rawData,
  });

  final String id;
  final String displayName;
  final String clientType;
  final String mainEmail;
  final String mainPhone;
  final String mobile;
  final String city;
  final String stateName;
  final String country;
  final String street;
  final Map<String, dynamic> rawData;

  List<double?> get addressLatitudes =>
      _readCoordinates(rawData['text_addressLatitude_id'], min: -90, max: 90);

  List<double?> get addressLongitudes => _readCoordinates(
    rawData['text_addressLongitude_id'],
    min: -180,
    max: 180,
  );

  List<String> get streets => _readStrings(rawData['text_street_id']);

  List<String> get addresses => _readStrings(rawData['text_address_id']);

  int get addressCount => [
    streets.length,
    addresses.length,
    addressLatitudes.length,
    addressLongitudes.length,
  ].reduce((current, next) => current > next ? current : next);

  String get cameraMessage => _readNestedString([
    'obj_categoriesOfServices_id',
    'Camaras',
    0,
    'message',
  ]);

  String get firstCameraImageUrl => _readNestedString([
    'obj_categoriesOfServices_id',
    'Camaras',
    0,
    'images',
    0,
    'url',
  ]);

  bool matchesId(String otherId) => id == otherId.trim();

  CustomerEntity withPatchedRawData(Map<String, dynamic> patch) {
    return CustomerEntity(
      id: id,
      displayName: displayName,
      clientType: clientType,
      mainEmail: mainEmail,
      mainPhone: mainPhone,
      mobile: mobile,
      city: city,
      stateName: stateName,
      country: country,
      street: street,
      rawData: Map<String, dynamic>.from(rawData)..addAll(patch),
    );
  }

  String _readNestedString(List<dynamic> path) {
    dynamic current = rawData;

    for (final step in path) {
      if (step is String) {
        if (current is Map) {
          current = current[step];
        } else {
          return '';
        }
      } else if (step is int) {
        if (current is List && step >= 0 && step < current.length) {
          current = current[step];
        } else {
          return '';
        }
      }
    }

    return (current ?? '').toString().trim();
  }

  static List<double?> _readCoordinates(
    dynamic values, {
    required double min,
    required double max,
  }) {
    final rawValues = values is List ? values : <dynamic>[values];
    return rawValues
        .map((value) => _parseCoordinate(value, min: min, max: max))
        .toList(growable: false);
  }

  static double? _parseCoordinate(
    dynamic rawValue, {
    required double min,
    required double max,
  }) {
    final coordinate = rawValue is num
        ? rawValue.toDouble()
        : double.tryParse((rawValue ?? '').toString().trim());
    if (coordinate == null || coordinate < min || coordinate > max) {
      return null;
    }
    return coordinate;
  }

  static List<String> _readStrings(dynamic values) {
    final rawValues = values is List ? values : <dynamic>[values];
    return rawValues
        .map((value) => (value ?? '').toString().trim())
        .toList(growable: false);
  }
}
