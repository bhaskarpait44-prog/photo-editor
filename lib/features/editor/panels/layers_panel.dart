import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../../models/layer_model.dart';
import '../../../providers/layers_provider.dart';
import '../../../providers/image_cache_provider.dart';

class LayersPanel extends ConsumerWidget {
  const LayersPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final layers = ref.watch(layersProvider);
    final activeLayerId = ref.watch(activeLayerIdProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Layers', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              IconButton(
                icon: const Icon(PhosphorIcons.plus, color: Colors.white, size: 20),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: const Color(0xFF1A1A1A),
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
                    builder: (_) => Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: const Icon(Icons.image, color: Colors.white),
                            title: const Text('Add Image Layer', style: TextStyle(color: Colors.white)),
                            onTap: () async {
                              Navigator.pop(context);
                              final picker = ImagePicker();
                              final file = await picker.pickImage(source: ImageSource.gallery);
                              if (file == null) return;
                              final bytes = await File(file.path).readAsBytes();
                              final codec = await ui.instantiateImageCodec(bytes);
                              final frame = await codec.getNextFrame();
                              final newId = const Uuid().v4();
                              final newLayer = LayerModel(
                                id: newId,
                                name: 'Image ${ref.read(layersProvider).length + 1}',
                                type: LayerType.image,
                                imagePath: file.path,
                              );
                              ref.read(layersProvider.notifier).addLayer(newLayer);
                              ref.read(imageCacheProvider.notifier).cacheImage(newId, frame.image);
                              ref.read(activeLayerIdProvider.notifier).state = newId;
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.tune, color: Colors.white),
                            title: const Text('Add Adjustment Layer', style: TextStyle(color: Colors.white)),
                            onTap: () {
                              Navigator.pop(context);
                              final newLayer = LayerModel(
                                id: const Uuid().v4(),
                                name: 'Adjustment ${ref.read(layersProvider).length + 1}',
                                type: LayerType.adjustment,
                              );
                              ref.read(layersProvider.notifier).addLayer(newLayer);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: ReorderableListView.builder(
            itemCount: layers.length,
            onReorder: (oldIndex, newIndex) {
              // Convert from display index (top=0) to actual index
              final actualOldIndex = layers.length - 1 - oldIndex;
              int actualNewIndex = layers.length - 1 - newIndex;
              if (newIndex > oldIndex) actualNewIndex++;
              ref.read(layersProvider.notifier).reorderLayers(actualOldIndex, actualNewIndex);
            },
            itemBuilder: (context, index) {
              final layer = layers[layers.length - 1 - index]; // Display top layers at the top
              final isSelected = layer.id == activeLayerId;

              return _LayerItem(
                key: ValueKey(layer.id),
                layer: layer,
                isSelected: isSelected,
                onTap: () => ref.read(activeLayerIdProvider.notifier).state = layer.id,
                onToggleVisibility: () {
                  ref.read(layersProvider.notifier).updateLayer(
                    layer.copyWith(isVisible: !layer.isVisible),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _LayerItem extends ConsumerWidget {
  final LayerModel layer;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onToggleVisibility;

  const _LayerItem({
    super.key,
    required this.layer,
    required this.isSelected,
    required this.onTap,
    required this.onToggleVisibility,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageCache = ref.watch(imageCacheProvider);
    final thumbnail = imageCache[layer.id];

    return GestureDetector(
      onTap: onTap,
      onLongPress: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: const Color(0xFF1A1A1A),
          builder: (_) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.copy, color: Colors.white),
                title: const Text('Duplicate Layer', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  final newLayer = layer.copyWith(
                    id: const Uuid().v4(),
                    name: '${layer.name} copy',
                  );
                  ref.read(layersProvider.notifier).addLayer(newLayer);
                  if (thumbnail != null) {
                    ref.read(imageCacheProvider.notifier).cacheImage(newLayer.id, thumbnail);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Delete Layer', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  ref.read(layersProvider.notifier).removeLayer(layer.id);
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isSelected ? Border.all(color: const Color(0xFFFF6B35), width: 1) : null,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: thumbnail != null 
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: RawImage(image: thumbnail, fit: BoxFit.cover),
                        )
                      : Icon(_getLayerIcon(layer.type), size: 20, color: Colors.white38),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        layer.name,
                        style: TextStyle(
                          color: layer.isVisible ? Colors.white : Colors.white38,
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    layer.isVisible ? PhosphorIcons.eye : PhosphorIcons.eyeSlash,
                    size: 18,
                    color: Colors.white38,
                  ),
                  onPressed: onToggleVisibility,
                ),
              ],
            ),
            if (isSelected) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text('Opacity', style: TextStyle(color: Colors.white38, fontSize: 11)),
                  Expanded(
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 2,
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                        overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                      ),
                      child: Slider(
                        value: layer.opacity,
                        min: 0,
                        max: 100,
                        activeColor: const Color(0xFFFF6B35),
                        inactiveColor: Colors.white10,
                        onChanged: (v) {
                          ref.read(layersProvider.notifier).updateLayer(layer.copyWith(opacity: v));
                        },
                      ),
                    ),
                  ),
                  Text('${layer.opacity.toInt()}%', style: const TextStyle(color: Colors.white, fontSize: 11)),
                ],
              ),
              Row(
                children: [
                  const Text('Blend Mode', style: TextStyle(color: Colors.white38, fontSize: 11)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButton<BlendMode>(
                      value: layer.blendMode,
                      isExpanded: true,
                      dropdownColor: const Color(0xFF1A1A1A),
                      underline: const SizedBox(),
                      style: const TextStyle(color: Colors.white, fontSize: 11),
                      items: [
                        BlendMode.srcOver, BlendMode.multiply, BlendMode.screen, 
                        BlendMode.overlay, BlendMode.softLight, BlendMode.hardLight,
                        BlendMode.colorDodge, BlendMode.colorBurn, BlendMode.difference, 
                        BlendMode.exclusion, BlendMode.hue, BlendMode.saturation, 
                        BlendMode.color, BlendMode.luminosity,
                      ].map((mode) => DropdownMenuItem(
                        value: mode,
                        child: Text(mode.name.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 11)),
                      )).toList(),
                      onChanged: (v) {
                        if (v != null) {
                          ref.read(layersProvider.notifier).updateLayer(layer.copyWith(blendMode: v));
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getLayerIcon(LayerType type) {
    switch (type) {
      case LayerType.image:
        return PhosphorIcons.image;
      case LayerType.adjustment:
        return PhosphorIcons.slidersHorizontal;
      case LayerType.text:
        return PhosphorIcons.textT;
      case LayerType.shape:
        return PhosphorIcons.shapes;
    }
  }
}
