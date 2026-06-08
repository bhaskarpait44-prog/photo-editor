import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/project_model.dart';
import '../services/project_service.dart';

final projectServiceProvider = Provider<ProjectService>((ref) {
  return ProjectService(); // Note: init() needs to be called separately
});

final projectsProvider = StateNotifierProvider<ProjectsNotifier, List<ProjectModel>>((ref) {
  final service = ref.watch(projectServiceProvider);
  return ProjectsNotifier(service);
});

class ProjectsNotifier extends StateNotifier<List<ProjectModel>> {
  final ProjectService _service;

  ProjectsNotifier(this._service) : super([]) {
    loadProjects();
  }

  void loadProjects() {
    state = _service.loadProjects();
  }

  Future<ProjectModel> createProject(String name) async {
    final project = await _service.createProject(name);
    loadProjects();
    return project;
  }

  Future<void> updateProject(ProjectModel project) async {
    await _service.updateProject(project);
    loadProjects();
  }

  Future<void> deleteProject(String id) async {
    await _service.deleteProject(id);
    loadProjects();
  }

  Future<void> duplicateProject(String id) async {
    await _service.duplicateProject(id);
    loadProjects();
  }
}
