import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/filter_presets.dart';
import '../../../providers/adjustments_provider.dart';
import '../../../providers/editor_provider.dart';
import '../../../services/image_processing_service.dart';

final filterThumbnailsProvider = FutureProvider.family<ui.Image?, String>((ref, filterName) async {
  final baseImage = ref.watch(editorProvider).image;
  if (baseImage == null) return null;
  final preset = FilterPresets.all[filterName];
  if (preset == null) return null;
  return ImageProcessingService.applyAdjustmentsToImage(baseImage, preset, maxSize: 120);
});

final filterIntensityProvider = StateProvider<double>((ref) => 100.0);
final selectedFilterNameProvider = StateProvider<String?>((ref) => null);

class FiltersPanel extends ConsumerWidget {
  const FiltersPanel({super.key});

  void _applyFilterWithIntensity(WidgetRef ref, String name, double intensity) {
    final preset = FilterPresets.all[name]!;
    final t = intensity / 100.0;
    ref.read(adjustmentsProvider.notifier).state = preset.copyWith(
      brightness: preset.brightness * t,
      contrast: preset.contrast * t,
      saturation: preset.saturation * t,
      exposure: preset.exposure * t,
      highlights: preset.highlights * t,
      shadows: preset.shadows * t,
      whites: preset.whites * t,
      blacks: preset.blacks * t,
      vibrance: preset.vibrance * t,
      hue: preset.hue * t,
      temperature: preset.temperature * t,
      tint: preset.tint * t,
      sharpness: preset.sharpness * t,
      clarity: preset.clarity * t,
      dehaze: preset.dehaze * t,
      vignette: preset.vignette * t,
      grain: preset.grain * t,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFilterName = ref.watch(selectedFilterNameProvider);
    final intensity = ref.watch(filterIntensityProvider);

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('Filters', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: FilterPresets.all.length,
            itemBuilder: (context, index) {
              final name = FilterPresets.all.keys.elementAt(index);
              final isSelected = selectedFilterName == name;

              return GestureDetector(
                onTap: () {
                  ref.read(selectedFilterNameProvider.notifier).state = name;
                  _applyFilterWithIntensity(ref, name, ref.read(filterIntensityProvider));
                },
                child: Container(
                  width: 80,
                  margin: const EdgeInsets.only(right: 12),
                  child: Column(
                    children: [
                      Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(8),
                          border: isSelected ? Border.all(color: const Color(0xFFFF6B35), width: 2) : null,
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: ref.watch(filterThumbnailsProvider(name)).when(
                          data: (img) => img != null 
                              ? RawImage(image: img, fit: BoxFit.cover) 
                              : const Center(child: Icon(Icons.image, color: Colors.white24, size: 32)),
                          loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 1.5, color: Color(0xFFFF6B35))),
                          error: (_, __) => const Center(child: Icon(Icons.error, color: Colors.white24, size: 32)),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        name,
                        style: TextStyle(
                          color: isSelected ? const Color(0xFFFF6B35) : Colors.white70,
                          fontSize: 11,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Intensity', style: TextStyle(color: Colors.white38, fontSize: 12)),
                  Text('${intensity.toInt()}%', style: const TextStyle(color: Colors.white38, fontSize: 12)),
                ],
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: const Color(0xFFFF6B35),
                  inactiveTrackColor: Colors.white10,
                  thumbColor: Colors.white,
                  overlayColor: const Color(0xFFFF6B35).withValues(alpha: 0.2),
                  trackHeight: 2.0,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
                ),
                child: Slider(
                  value: intensity,
                  min: 0,
                  max: 100,
                  onChanged: (val) {
                    ref.read(filterIntensityProvider.notifier).state = val;
                    if (selectedFilterName != null) {
                      _applyFilterWithIntensity(ref, selectedFilterName, val);
                    }
                  },
                  onChangeEnd: (val) {
                    ref.read(editorProvider.notifier).pushHistory(ref.read(adjustmentsProvider), description: 'Filter: $selectedFilterName');
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
