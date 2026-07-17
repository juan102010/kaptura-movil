import '../../domain/entities/project_entity.dart';

class ProjectModel extends ProjectEntity {
  const ProjectModel({
    required super.id,
    required super.name,
    required super.status,
    required super.dateCreated,
    required super.customerCode,
    required super.rawData,
  });

  factory ProjectModel.fromMap(Map<String, dynamic> map) {
    return ProjectModel(
      id: (map['_id'] ?? '').toString().trim(),
      name: (map['text_nameProject_id'] ?? '').toString().trim(),
      status: (map['text_stateProject_id'] ?? '').toString().trim(),
      dateCreated: (map['date_dateCreateProject_id'] ?? '').toString().trim(),
      customerCode: (map['text_customerCode_id'] ?? '').toString().trim(),
      rawData: Map<String, dynamic>.from(map),
    );
  }

  Map<String, dynamic> toMap() => Map<String, dynamic>.from(rawData);
}
