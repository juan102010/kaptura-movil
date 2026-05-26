import '../../domain/entities/work_order_time_entry_entity.dart';

class WorkOrderTimeEntryModel extends WorkOrderTimeEntryEntity {
  const WorkOrderTimeEntryModel({
    required super.dateInit,
    required super.dateEnd,
    required super.minutes,
    required super.optionSelect,
  });

  factory WorkOrderTimeEntryModel.fromMap(Map<String, dynamic> map) {
    final entity = WorkOrderTimeEntryEntity.fromMap(map);
    return WorkOrderTimeEntryModel(
      dateInit: entity.dateInit,
      dateEnd: entity.dateEnd,
      minutes: entity.minutes,
      optionSelect: entity.optionSelect,
    );
  }
}
