import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import '../../../models/layer_model.dart';
import '../../../providers/layers_provider.dart';

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
                  // Add layer logic
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: ReorderableListView.builder(
            itemCount: layers.length,
            onReorder: (oldIndex, newIndex) {
              ref.read(layersProvider.notifier).reorderLayers(oldIndex, newIndex);
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

class _LayerItem extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isSelected ? Border.all(color: const Color(0xFFFF6B35), width: 1) : null,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Icon(
                _getLayerIcon(layer.type),
                size: 20,
                color: Colors.white38,
              ),
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
                  if (isSelected)
                    Text(
                      '${layer.blendMode.name} • ${layer.opacity.toInt()}%',
                      style: const TextStyle(color: Colors.white38, fontSize: 10),
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
