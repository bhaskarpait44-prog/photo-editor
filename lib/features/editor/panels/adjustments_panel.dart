import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/adjustment_model.dart';
import '../widgets/custom_slider.dart';

final adjustmentsProvider = StateProvider<AdjustmentModel>((ref) => const AdjustmentModel());

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
            onReset: () => _update(ref, adjustments.copyWith(brightness: 0)),
          ),
          CustomSlider(
            label: 'Contrast',
            value: adjustments.contrast,
            onChanged: (val) => _update(ref, adjustments.copyWith(contrast: val)),
            onReset: () => _update(ref, adjustments.copyWith(contrast: 0)),
          ),
          CustomSlider(
            label: 'Exposure',
            value: adjustments.exposure,
            min: -3,
            max: 3,
            onChanged: (val) => _update(ref, adjustments.copyWith(exposure: val)),
            onReset: () => _update(ref, adjustments.copyWith(exposure: 0)),
          ),
        ]),
        _buildSection('Color', [
          CustomSlider(
            label: 'Saturation',
            value: adjustments.saturation,
            onChanged: (val) => _update(ref, adjustments.copyWith(saturation: val)),
            onReset: () => _update(ref, adjustments.copyWith(saturation: 0)),
          ),
          CustomSlider(
            label: 'Vibrance',
            value: adjustments.vibrance,
            onChanged: (val) => _update(ref, adjustments.copyWith(vibrance: val)),
            onReset: () => _update(ref, adjustments.copyWith(vibrance: 0)),
          ),
          CustomSlider(
            label: 'Hue',
            value: adjustments.hue,
            min: -180,
            max: 180,
            onChanged: (val) => _update(ref, adjustments.copyWith(hue: val)),
            onReset: () => _update(ref, adjustments.copyWith(hue: 0)),
          ),
        ]),
        // Detail and Effects sections would follow the same pattern
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
