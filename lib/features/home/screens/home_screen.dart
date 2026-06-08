import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../providers/project_provider.dart';
import '../widgets/project_card.dart';
import '../../../models/project_model.dart';
import '../../editor/screens/editor_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projects = ref.watch(projectsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pixel Forge'),
        actions: [
          IconButton(
            icon: Icon(PhosphorIcons.gear(PhosphorIconsStyle.regular)),
            onPressed: () {
              // Settings placeholder
            },
          ),
        ],
      ),
      body: projects.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    PhosphorIcons.image(PhosphorIconsStyle.regular),
                    size: 64,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No projects yet',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap "New Project" to start editing',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              itemCount: projects.length,
              itemBuilder: (context, index) {
                final project = projects[index];
                return ProjectCard(
                  project: project,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditorScreen(project: project),
                      ),
                    );
                  },
                  onRename: () => _renameProject(context, ref, project),
                  onDuplicate: () => ref.read(projectsProvider.notifier).duplicateProject(project.id),
                  onDelete: () => _confirmDelete(context, ref, project.id),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _createNewProject(context, ref),
        icon: Icon(PhosphorIcons.plus(PhosphorIconsStyle.regular)),
        label: const Text('New Project'),
      ),
    );
  }

  Future<void> _createNewProject(BuildContext context, WidgetRef ref) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final notifier = ref.read(projectsProvider.notifier);
      final project = await notifier.createProject(image.name.split('.').first);
      
      // Update with thumbnail/file path if needed
      final updatedProject = project.copyWith(
        projectFilePath: image.path, 
        thumbnailPath: image.path,
      );
      await notifier.updateProject(updatedProject);
      
      if (!context.mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditorScreen(project: updatedProject),
        ),
      );
    }
  }

  void _renameProject(BuildContext context, WidgetRef ref, ProjectModel project) {
    final controller = TextEditingController(text: project.name);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF141414),
        title: const Text('Rename Project'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Project Name',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF888888))),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                final updatedProject = project.copyWith(name: controller.text.trim());
                ref.read(projectsProvider.notifier).updateProject(updatedProject);
                Navigator.pop(context);
              }
            },
            child: const Text('Rename', style: TextStyle(color: Color(0xFFFF6B35))),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, String projectId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF141414),
        title: const Text('Delete Project?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF888888))),
          ),
          TextButton(
            onPressed: () {
              ref.read(projectsProvider.notifier).deleteProject(projectId);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }
}
