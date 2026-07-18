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
}
