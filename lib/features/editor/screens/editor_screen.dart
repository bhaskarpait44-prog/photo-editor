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
import '../../../providers/adjustments_provider.dart';
import '../panels/layers_panel.dart';
import '../panels/filters_panel.dart';
import '../tools/crop_tool.dart';
import '../tools/brush_tool_overlay.dart';
import '../panels/brush_panel.dart';
import '../tools/text_tool_overlay.dart';
import '../panels/text_panel.dart';
import '../tools/transform_tool_overlay.dart';
import '../panels/transform_panel.dart';
import '../panels/histogram_panel.dart';
import '../panels/hsl_panel.dart';
import '../panels/heal_panel.dart';
import '../panels/curves_panel.dart';
import '../tools/selection_tool_overlay.dart';
import '../panels/selection_panel.dart';
import '../../../services/image_processing_service.dart';
import 'package:path_provider/path_provider.dart';
import '../../../services/export_service.dart';
import '../../../providers/project_provider.dart';
import '../../export/screens/export_screen.dart';

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
  String? _errorMessage;

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
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final file = File(widget.project.projectFilePath);
      final bytes = await file.readAsBytes();
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      
      final image = frame.image;
      
      final projectService = ref.read(projectServiceProvider);
      final savedLayers = projectService.loadLayers(widget.project.id);
      
      if (savedLayers.isNotEmpty) {
        // Load existing layers
        for (final layer in savedLayers) {
          ref.read(layersProvider.notifier).addLayer(layer);
          if (layer.type == LayerType.image && layer.imagePath != null) {
             if (layer.name == 'Base') {
               ref.read(imageCacheProvider.notifier).cacheImage(layer.id, image);
               ref.read(activeLayerIdProvider.notifier).state = layer.id;
             } else {
               // Load other image layers from their paths
               final otherFile = File(layer.imagePath!);
               if (await otherFile.exists()) {
                 final otherBytes = await otherFile.readAsBytes();
                 final otherCodec = await ui.instantiateImageCodec(otherBytes);
                 final otherFrame = await otherCodec.getNextFrame();
                 ref.read(imageCacheProvider.notifier).cacheImage(layer.id, otherFrame.image);
               }
             }
          }
        }
      } else {
        // Initialize with base layer
        final layerId = const Uuid().v4();
        final baseLayer = LayerModel(
          id: layerId,
          name: 'Base',
          type: LayerType.image,
          imagePath: widget.project.projectFilePath,
        );

        ref.read(layersProvider.notifier).addLayer(baseLayer);
        ref.read(activeLayerIdProvider.notifier).state = layerId;
        ref.read(imageCacheProvider.notifier).cacheImage(layerId, image);
      }
      
      ref.read(editorProvider.notifier).setImage(image);
    } catch (e) {
      debugPrint('Error loading image: \$e');
      if (mounted) setState(() {
        _errorMessage = 'Failed to load image: \${e.toString()}';
        _isLoading = false;
      });
    } finally {
      if (mounted && _errorMessage == null) setState(() => _isLoading = false);
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
              onSave: () async {
                // Show saving indicator
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Row(children: [
                      SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)),
                      SizedBox(width: 12),
                      Text('Saving...'),
                    ]),
                    duration: Duration(seconds: 30), // will be dismissed manually
                    backgroundColor: Color(0xFF1A1A1A),
                  ),
                );

                try {
                  final image = ref.read(editorProvider).image;
                  if (image == null) return;
                  
                  final tempDir = await getTemporaryDirectory();
                  final thumbPath = '${tempDir.path}/thumb_${widget.project.id}.jpg';
                  await ExportService.exportImage(image: image, path: thumbPath, format: 'jpg', quality: 0.7);
                  
                  final updated = widget.project.copyWith(
                    thumbnailPath: thumbPath,
                    updatedAt: DateTime.now(),
                  );
                  
                  final projectService = ref.read(projectServiceProvider);
                  await projectService.updateProject(updated);
                  
                  final layers = ref.read(layersProvider);
                  await projectService.saveLayers(widget.project.id, layers);
                  
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Row(children: [
                          Icon(Icons.check_circle, color: Colors.green, size: 18),
                          SizedBox(width: 12),
                          Text('Project saved'),
                        ]),
                        duration: Duration(seconds: 2),
                        backgroundColor: Color(0xFF1A1A1A),
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Save failed: $e'), backgroundColor: Colors.red),
                    );
                  }
                }
              },
              onExport: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ExportScreen(image: ref.read(editorProvider).image!)),
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  if (_isLoading)
                    const Center(child: CircularProgressIndicator(color: Color(0xFFFF6B35)))
                  else ...[
                    EditorCanvas(
                      controller: _canvasController,
                      adjustments: adjustments,
                    ),
                    if (editorState.activeTool == EditorTool.crop && editorState.image != null)
                      CropTool(
                        imageSize: Size(editorState.image!.width.toDouble(), editorState.image!.height.toDouble()),
                        onCropApplied: (rect, rotation) async {
                          setState(() => _isLoading = true);
                          ref.read(editorProvider.notifier).setActiveTool(EditorTool.none);
                          try {
                            final cropped = await ImageProcessingService.cropImage(editorState.image!, rect, rotationDegrees: rotation);
                            final layerId = ref.read(activeLayerIdProvider);
                            if (layerId != null) {
                              ref.read(imageCacheProvider.notifier).cacheImage(layerId, cropped);
                            }
                            ref.read(editorProvider.notifier).setImage(cropped);
                          } catch (e) {
                            debugPrint('Error cropping: \$e');
                          } finally {
                            if (mounted) setState(() => _isLoading = false);
                          }
                        },
                        onCancel: () {
                          ref.read(editorProvider.notifier).setActiveTool(EditorTool.none);
                        },
                      ),
                    if (editorState.activeTool == EditorTool.brush && editorState.image != null)
                      BrushToolOverlay(
                        imageSize: Size(editorState.image!.width.toDouble(), editorState.image!.height.toDouble()),
                        onStrokeEnd: (strokeImage) async {
                          final baseLayerId = ref.read(activeLayerIdProvider);
                          if (baseLayerId == null) return;
                          
                          final baseImage = ref.read(imageCacheProvider)[baseLayerId];
                          if (baseImage == null) return;

                          // The stroke was drawn at screen size — composite it onto the base image
                          // at proper scale using PictureRecorder
                          final recorder = ui.PictureRecorder();
                          final c = Canvas(recorder);
                          
                          // Draw base image
                          c.drawImage(baseImage, Offset.zero, Paint());
                          
                          // Scale stroke to match image dimensions
                          final scaleX = baseImage.width / strokeImage.width;
                          final scaleY = baseImage.height / strokeImage.height;
                          c.save();
                          c.scale(scaleX, scaleY);
                          c.drawImage(strokeImage, Offset.zero, Paint()..blendMode = BlendMode.srcOver);
                          c.restore();
                          
                          final picture = recorder.endRecording();
                          final composited = await picture.toImage(baseImage.width, baseImage.height);
                          
                          ref.read(imageCacheProvider.notifier).cacheImage(baseLayerId, composited);
                          ref.read(editorProvider.notifier).setImage(composited);
                          ref.read(editorProvider.notifier).pushHistory(
                            ref.read(adjustmentsProvider), description: 'Brush Stroke'
                          );
                        },
                      ),
                    if (editorState.isBeforeView)
                      Positioned(
                        top: 12, left: 0, right: 0,
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(12)),
                            child: const Text('◀ BEFORE  |  AFTER ▶', style: TextStyle(color: Colors.white, fontSize: 10, letterSpacing: 1.2, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                    if (editorState.activeTool == EditorTool.text)
                      const TextToolOverlay(),
                    if (editorState.activeTool == EditorTool.transform)
                      const TransformToolOverlay(),
                    if (editorState.activeTool == EditorTool.select)
                      const SelectionToolOverlay(),
                  ],
                  Consumer(
                    builder: (context, ref, _) {
                      final show = ref.watch(isHistogramVisibleProvider);
                      if (!show) return const SizedBox.shrink();
                      return Positioned(
                        bottom: 0, left: 0, right: 0,
                        child: Container(
                          color: const Color(0xE6141414),
                          child: const HistogramPanel(),
                        ),
                      );
                    },
                  ),
                  if (editorState.activeTool != EditorTool.crop && editorState.activeTool != EditorTool.brush)
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
      case EditorTool.brush:
        return const BrushPanel();
      case EditorTool.text:
        return const TextPanel();
      case EditorTool.transform:
        return const TransformPanel();
      case EditorTool.hsl:
        return const HslPanel();
      case EditorTool.heal:
        return const HealPanel();
      case EditorTool.curves:
        return const CurvesPanel();
      case EditorTool.select:
        return const SelectionPanel();
      default:
        return const Center(
          child: Text(
            'Options coming soon',
            style: TextStyle(color: Colors.white38),
          ),
        );
    }
  }
}
