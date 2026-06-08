import 'package:hive/hive.dart';

part 'project_model.g.dart';

@HiveType(typeId: 0)
class ProjectModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  final DateTime createdAt;

  @HiveField(3)
  DateTime updatedAt;

  @HiveField(4)
  String thumbnailPath;

  @HiveField(5)
  String projectFilePath;

  ProjectModel({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.thumbnailPath,
    required this.projectFilePath,
  });

  ProjectModel copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? thumbnailPath,
    String? projectFilePath,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      projectFilePath: projectFilePath ?? this.projectFilePath,
    );
  }
}
