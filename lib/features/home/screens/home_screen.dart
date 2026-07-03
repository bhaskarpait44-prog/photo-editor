import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import '../../../providers/project_provider.dart';
import '../widgets/project_card.dart';
import '../../../models/project_model.dart';
import '../../editor/screens/editor_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _sortBy = 'Recent'; // 'Recent', 'Name', 'Oldest'

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final projects = ref.watch(projectsProvider);

    final filtered = projects.where((p) => p.name.toLowerCase().contains(_searchQuery)).toList();
    final sorted = [...filtered];
    switch (_sortBy) {
      case 'Name':
        sorted.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'Oldest':
        sorted.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      default:
        sorted.sort((a, b) => b.updatedAt.compareTo(a.updatedAt)); // Recent
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        title: const Text('Pixel Forge', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF141414),
        actions: [
          IconButton(
            icon: const Icon(PhosphorIcons.gear, color: Colors.white70),
            onPressed: () {
              // Settings placeholder
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search projects...',
                      hintStyle: const TextStyle(color: Colors.white38),
                      prefixIcon: const Icon(Icons.search, color: Colors.white38),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, color: Colors.white38),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: const Color(0xFF1A1A1A),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onChanged: (v) => setState(() => _searchQuery = v.toLowerCase()),
                  ),
                ),
                const SizedBox(width: 12),
                DropdownButton<String>(
                  value: _sortBy,
                  dropdownColor: const Color(0xFF1A1A1A),
                  underline: const SizedBox(),
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.white70),
                  items: ['Recent', 'Name', 'Oldest']
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (v) => setState(() => _sortBy = v!),
                ),
              ],
            ),
          ),
          Expanded(
            child: sorted.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.photo_library_outlined, color: Colors.white24, size: 64),
                        const SizedBox(height: 16),
                        Text(
                          _searchQuery.isNotEmpty ? 'No projects match "\$_searchQuery"' : 'No projects yet',
                          style: const TextStyle(color: Colors.white38, fontSize: 16),
                        ),
                        if (_searchQuery.isEmpty) ...[
                          const SizedBox(height: 8),
                          const Text('Tap + to create your first project', style: TextStyle(color: Colors.white24, fontSize: 13)),
                        ],
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
                    itemCount: sorted.length,
                    itemBuilder: (context, index) {
                      final project = sorted[index];
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
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFFFF6B35),
        onPressed: () => _createNewProject(context, ref),
        icon: const Icon(PhosphorIcons.plus, color: Colors.white),
        label: const Text('New Project', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
        title: const Text('Rename Project', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Project Name',
            hintStyle: TextStyle(color: Colors.white38),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFFF6B35))),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () async {
              if (controller.text.trim().isNotEmpty) {
                final updatedProject = project.copyWith(name: controller.text.trim());
                final projectService = ref.read(projectServiceProvider);
                await projectService.updateProject(updatedProject);
                ref.refresh(projectsProvider);
                if (context.mounted) {
                   Navigator.pop(context);
                }
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
        title: const Text('Delete Project?', style: TextStyle(color: Colors.white)),
        content: const Text('This action cannot be undone.', style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
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
