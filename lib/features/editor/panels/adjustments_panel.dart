import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/adjustment_model.dart';
import '../../../providers/adjustments_provider.dart';
import '../../../providers/editor_provider.dart';
import '../widgets/custom_slider.dart';

class AdjustmentsPanel extends ConsumerWidget {
  const AdjustmentsPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adjustments = ref.watch(adjustmentsProvider);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSection('Light', [
          CustomSlider(
            label: 'Brightness',
            value: adjustments.brightness,
            onChanged: (val) => _update(ref, adjustments.copyWith(brightness: val)),
            onChangeEnd: (_) => ref.read(editorProvider.notifier).pushHistory(ref.read(adjustmentsProvider), description: 'Brightness'),
            onReset: () => _update(ref, adjustments.copyWith(brightness: 0)),
          ),
          CustomSlider(
            label: 'Contrast',
            value: adjustments.contrast,
            onChanged: (val) => _update(ref, adjustments.copyWith(contrast: val)),
            onChangeEnd: (_) => ref.read(editorProvider.notifier).pushHistory(ref.read(adjustmentsProvider), description: 'Contrast'),
            onReset: () => _update(ref, adjustments.copyWith(contrast: 0)),
          ),
          CustomSlider(
            label: 'Exposure',
            value: adjustments.exposure,
            min: -3,
            max: 3,
            onChanged: (val) => _update(ref, adjustments.copyWith(exposure: val)),
            onChangeEnd: (_) => ref.read(editorProvider.notifier).pushHistory(ref.read(adjustmentsProvider), description: 'Exposure'),
            onReset: () => _update(ref, adjustments.copyWith(exposure: 0)),
          ),
          CustomSlider(
            label: 'Highlights',
            value: adjustments.highlights,
            onChanged: (val) => _update(ref, adjustments.copyWith(highlights: val)),
            onChangeEnd: (_) => ref.read(editorProvider.notifier).pushHistory(ref.read(adjustmentsProvider), description: 'Highlights'),
            onReset: () => _update(ref, adjustments.copyWith(highlights: 0)),
          ),
          CustomSlider(
            label: 'Shadows',
            value: adjustments.shadows,
            onChanged: (val) => _update(ref, adjustments.copyWith(shadows: val)),
            onChangeEnd: (_) => ref.read(editorProvider.notifier).pushHistory(ref.read(adjustmentsProvider), description: 'Shadows'),
            onReset: () => _update(ref, adjustments.copyWith(shadows: 0)),
          ),
          CustomSlider(
            label: 'Whites',
            value: adjustments.whites,
            onChanged: (val) => _update(ref, adjustments.copyWith(whites: val)),
            onChangeEnd: (_) => ref.read(editorProvider.notifier).pushHistory(ref.read(adjustmentsProvider), description: 'Whites'),
            onReset: () => _update(ref, adjustments.copyWith(whites: 0)),
          ),
          CustomSlider(
            label: 'Blacks',
            value: adjustments.blacks,
            onChanged: (val) => _update(ref, adjustments.copyWith(blacks: val)),
            onChangeEnd: (_) => ref.read(editorProvider.notifier).pushHistory(ref.read(adjustmentsProvider), description: 'Blacks'),
            onReset: () => _update(ref, adjustments.copyWith(blacks: 0)),
          ),
        ]),
        _buildSection('Color', [
          CustomSlider(
            label: 'Saturation',
            value: adjustments.saturation,
            onChanged: (val) => _update(ref, adjustments.copyWith(saturation: val)),
            onChangeEnd: (_) => ref.read(editorProvider.notifier).pushHistory(ref.read(adjustmentsProvider), description: 'Saturation'),
            onReset: () => _update(ref, adjustments.copyWith(saturation: 0)),
          ),
          CustomSlider(
            label: 'Vibrance',
            value: adjustments.vibrance,
            onChanged: (val) => _update(ref, adjustments.copyWith(vibrance: val)),
            onChangeEnd: (_) => ref.read(editorProvider.notifier).pushHistory(ref.read(adjustmentsProvider), description: 'Vibrance'),
            onReset: () => _update(ref, adjustments.copyWith(vibrance: 0)),
          ),
          CustomSlider(
            label: 'Hue',
            value: adjustments.hue,
            min: -180,
            max: 180,
            onChanged: (val) => _update(ref, adjustments.copyWith(hue: val)),
            onChangeEnd: (_) => ref.read(editorProvider.notifier).pushHistory(ref.read(adjustmentsProvider), description: 'Hue'),
            onReset: () => _update(ref, adjustments.copyWith(hue: 0)),
          ),
          CustomSlider(
            label: 'Temperature',
            value: adjustments.temperature,
            onChanged: (val) => _update(ref, adjustments.copyWith(temperature: val)),
            onChangeEnd: (_) => ref.read(editorProvider.notifier).pushHistory(ref.read(adjustmentsProvider), description: 'Temperature'),
            onReset: () => _update(ref, adjustments.copyWith(temperature: 0)),
          ),
          CustomSlider(
            label: 'Tint',
            value: adjustments.tint,
            onChanged: (val) => _update(ref, adjustments.copyWith(tint: val)),
            onChangeEnd: (_) => ref.read(editorProvider.notifier).pushHistory(ref.read(adjustmentsProvider), description: 'Tint'),
            onReset: () => _update(ref, adjustments.copyWith(tint: 0)),
          ),
        ]),
        _buildSection('Detail', [
          CustomSlider(
            label: 'Sharpness',
            value: adjustments.sharpness,
            min: 0,
            max: 100,
            onChanged: (val) => _update(ref, adjustments.copyWith(sharpness: val)),
            onChangeEnd: (_) => ref.read(editorProvider.notifier).pushHistory(ref.read(adjustmentsProvider), description: 'Sharpness'),
            onReset: () => _update(ref, adjustments.copyWith(sharpness: 0)),
          ),
          CustomSlider(
            label: 'Clarity',
            value: adjustments.clarity,
            onChanged: (val) => _update(ref, adjustments.copyWith(clarity: val)),
            onChangeEnd: (_) => ref.read(editorProvider.notifier).pushHistory(ref.read(adjustmentsProvider), description: 'Clarity'),
            onReset: () => _update(ref, adjustments.copyWith(clarity: 0)),
          ),
          CustomSlider(
            label: 'Dehaze',
            value: adjustments.dehaze,
            onChanged: (val) => _update(ref, adjustments.copyWith(dehaze: val)),
            onChangeEnd: (_) => ref.read(editorProvider.notifier).pushHistory(ref.read(adjustmentsProvider), description: 'Dehaze'),
            onReset: () => _update(ref, adjustments.copyWith(dehaze: 0)),
          ),
        ]),
        _buildSection('Effects', [
          CustomSlider(
            label: 'Vignette',
            value: adjustments.vignette,
            onChanged: (val) => _update(ref, adjustments.copyWith(vignette: val)),
            onChangeEnd: (_) => ref.read(editorProvider.notifier).pushHistory(ref.read(adjustmentsProvider), description: 'Vignette'),
            onReset: () => _update(ref, adjustments.copyWith(vignette: 0)),
          ),
          CustomSlider(
            label: 'Grain',
            value: adjustments.grain,
            min: 0,
            max: 100,
            onChanged: (val) => _update(ref, adjustments.copyWith(grain: val)),
            onChangeEnd: (_) => ref.read(editorProvider.notifier).pushHistory(ref.read(adjustmentsProvider), description: 'Grain'),
            onReset: () => _update(ref, adjustments.copyWith(grain: 0)),
          ),
        ]),
      ],
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            title,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
        ...children,
        const SizedBox(height: 16),
      ],
    );
  }

  void _update(WidgetRef ref, AdjustmentModel model) {
    ref.read(adjustmentsProvider.notifier).state = model;
    // Real-time preview logic would be triggered here
  }
}
