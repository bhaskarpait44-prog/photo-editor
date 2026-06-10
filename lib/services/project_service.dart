import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../models/project_model.dart';
import '../models/layer_model.dart';
import '../models/layer_hive_model.dart';

class ProjectService {
  static const String _boxName = 'projects_box';
  static const String _layersBoxName = 'layers_box';
  Box<ProjectModel>? _projectsBox;
  Box<LayerHiveModel>? _layersBox;

  Future<void> init() async {
    _projectsBox = await Hive.openBox<ProjectModel>(_boxName);
    _layersBox = await Hive.openBox<LayerHiveModel>(_layersBoxName);
  }

  List<ProjectModel> loadProjects() {
    if (_projectsBox == null) return [];
    return _projectsBox!.values.toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  Future<void> saveLayers(String projectId, List<LayerModel> layers) async {
    if (_layersBox == null) return;
    
    // Remove existing layers for this project
    final existingKeys = _layersBox!.keys.where((k) {
      return _layersBox!.get(k)?.projectId == projectId;
    }).toList();
    await _layersBox!.deleteAll(existingKeys);

    // Save new layers
    for (int i = 0; i < layers.length; i++) {
      final hiveModel = LayerHiveModel.fromLayerModel(layers[i], projectId);
      await _layersBox!.put('${projectId}_$i', hiveModel);
    }
  }

  List<LayerModel> loadLayers(String projectId) {
    if (_layersBox == null) return [];
    
    final projectLayers = _layersBox!.values
        .where((l) => l.projectId == projectId)
        .map((l) => l.toLayerModel())
        .toList();
        
    return projectLayers;
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
