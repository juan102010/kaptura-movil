class WorkOrderTimeEntryEntity {
  const WorkOrderTimeEntryEntity({
    required this.dateInit,
    required this.dateEnd,
    required this.minutes,
    required this.optionSelect,
  });

  final String dateInit;
  final String? dateEnd;
  final double? minutes;
  final String optionSelect;

  bool get isOpen => dateEnd == null || dateEnd!.trim().isEmpty;

  factory WorkOrderTimeEntryEntity.fromMap(Map<String, dynamic> map) {
    return WorkOrderTimeEntryEntity(
      dateInit: (map['dateInit'] ?? '').toString().trim(),
      dateEnd: map['dateEnd'] == null
          ? null
          : map['dateEnd'].toString().trim().isEmpty
          ? null
          : map['dateEnd'].toString().trim(),
      minutes: _toDoubleOrNull(map['minutes']),
      optionSelect: (map['optionSelect'] ?? '').toString().trim(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'dateInit': dateInit,
      'dateEnd': dateEnd,
      'minutes': minutes,
      'optionSelect': optionSelect,
    };
  }

  WorkOrderTimeEntryEntity copyWith({
    String? dateInit,
    String? dateEnd,
    bool clearDateEnd = false,
    double? minutes,
    bool clearMinutes = false,
    String? optionSelect,
  }) {
    return WorkOrderTimeEntryEntity(
      dateInit: dateInit ?? this.dateInit,
      dateEnd: clearDateEnd ? null : (dateEnd ?? this.dateEnd),
      minutes: clearMinutes ? null : (minutes ?? this.minutes),
      optionSelect: optionSelect ?? this.optionSelect,
    );
  }

  static double? _toDoubleOrNull(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString());
  }
}
