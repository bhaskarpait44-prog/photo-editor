import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../models/project_model.dart';

class ProjectService {
  static const String _boxName = 'projects_box';
  Box<ProjectModel>? _projectsBox;

  Future<void> init() async {
    _projectsBox = await Hive.openBox<ProjectModel>(_boxName);
  }

  List<ProjectModel> loadProjects() {
    if (_projectsBox == null) return [];
    return _projectsBox!.values.toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  Future<ProjectModel> createProject(String name) async {
    final now = DateTime.now();
    final project = ProjectModel(
      id: const Uuid().v4(),
      name: name,
      createdAt: now,
      updatedAt: now,
      thumbnailPath: '', // Empty initially
      projectFilePath: '', // Empty initially
    );
    await _projectsBox?.put(project.id, project);
    return project;
  }

  Future<void> updateProject(ProjectModel project) async {
    project.updatedAt = DateTime.now();
    await project.save();
  }

  Future<void> deleteProject(String id) async {
    await _projectsBox?.delete(id);
  }

  Future<ProjectModel?> duplicateProject(String id) async {
    final project = _projectsBox?.get(id);
    if (project != null) {
      final newProject = ProjectModel(
        id: const Uuid().v4(),
        name: '${project.name} Copy',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        thumbnailPath: project.thumbnailPath,
        projectFilePath: project.projectFilePath,
      );
      await _projectsBox?.put(newProject.id, newProject);
      return newProject;
    }
    return null;
  }
}
