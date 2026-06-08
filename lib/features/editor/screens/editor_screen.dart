import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../models/project_model.dart';
import '../../../models/layer_model.dart';
import '../../../providers/editor_provider.dart';
import '../../../providers/layers_provider.dart';
import '../../../providers/image_cache_provider.dart';
import '../canvas/editor_canvas.dart';
import '../canvas/canvas_controller.dart';
import '../toolbar/top_toolbar.dart';
import '../toolbar/bottom_toolbar.dart';
import '../panels/adjustments_panel.dart';
import '../panels/layers_panel.dart';
import '../panels/filters_panel.dart';

class EditorScreen extends ConsumerStatefulWidget {
  final ProjectModel project;

  const EditorScreen({
    super.key,
    required this.project,
  });

  @override
  ConsumerState<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends ConsumerState<EditorScreen> {
  late final CanvasController _canvasController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _canvasController = CanvasController();
    _loadImage();
  }

  @override
  void dispose() {
    _canvasController.dispose();
    super.dispose();
  }

  Future<void> _loadImage() async {
    setState(() => _isLoading = true);

    try {
      final file = File(widget.project.projectFilePath);
      final bytes = await file.readAsBytes();
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      
      final image = frame.image;
      final layerId = const Uuid().v4();

      // Initialize with base layer
      final baseLayer = LayerModel(
        id: layerId,
        name: 'Base',
        type: LayerType.image,
        imagePath: widget.project.projectFilePath,
      );

      ref.read(layersProvider.notifier).addLayer(baseLayer);
      ref.read(activeLayerIdProvider.notifier).state = layerId;
      ref.read(imageCacheProvider.notifier).cacheImage(layerId, image);
      ref.read(editorProvider.notifier).setImage(image);
    } catch (e) {
      debugPrint('Error loading image: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final editorState = ref.watch(editorProvider);
    final adjustments = ref.watch(adjustmentsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: Column(
          children: [
            TopToolbar(
              onSave: () {
                // Save project logic
              },
              onExport: () {
                // Export screen navigation
              },
            ),
            Expanded(
              child: Stack(
                children: [
                  if (_isLoading)
                    const Center(child: CircularProgressIndicator(color: Color(0xFFFF6B35)))
                  else
                    EditorCanvas(
                      controller: _canvasController,
                      adjustments: adjustments,
                    ),
                  
                  _buildSidePanel(editorState.activeTool),
                ],
              ),
            ),
            const BottomToolbar(),
          ],
        ),
      ),
    );
  }

  Widget _buildSidePanel(EditorTool activeTool) {
    if (activeTool == EditorTool.none) return const SizedBox.shrink();

    return Positioned(
      right: 0,
      top: 0,
      bottom: 0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        width: 300,
        decoration: const BoxDecoration(
          color: Color(0xFF141414),
          border: Border(left: BorderSide(color: Colors.white10, width: 0.5)),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Text(
                    activeTool.name.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white, size: 20),
                    onPressed: () => ref.read(editorProvider.notifier).setActiveTool(EditorTool.none),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _getPanelContent(activeTool),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getPanelContent(EditorTool activeTool) {
    switch (activeTool) {
      case EditorTool.adjust:
        return const AdjustmentsPanel();
      case EditorTool.layers:
        return const LayersPanel();
      case EditorTool.filter:
        return const FiltersPanel();
      default:
        return Center(
          child: Text(
            '${activeTool.name} options coming soon',
            style: const TextStyle(color: Colors.white38),
          ),
        );
    }
  }
}
