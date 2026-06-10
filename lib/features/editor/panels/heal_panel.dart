import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/custom_slider.dart';
import '../../../providers/brush_provider.dart';

class HealPanel extends ConsumerWidget {
  const HealPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brushSettings = ref.watch(brushSettingsProvider);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Spot Heal',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),
          const Text(
            'Brush over blemishes or unwanted objects to remove them. Pixel Forge will intelligently fill the area with surrounding pixels.',
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue, size: 20),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'The size and hardness of your brush affect the healing area. A softer brush often yields more natural results.',
                    style: TextStyle(color: Colors.blue, fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          CustomSlider(
            label: 'Size',
            value: brushSettings.size,
            min: 1,
            max: 100,
            onChanged: (v) {
              ref.read(brushSettingsProvider.notifier).state = brushSettings.copyWith(size: v);
            },
            onReset: () {
              ref.read(brushSettingsProvider.notifier).state = brushSettings.copyWith(size: 20);
            },
          ),
          const SizedBox(height: 24),
          CustomSlider(
            label: 'Hardness',
            value: brushSettings.hardness * 100,
            min: 0,
            max: 100,
            onChanged: (v) {
              ref.read(brushSettingsProvider.notifier).state = brushSettings.copyWith(hardness: v / 100);
            },
            onReset: () {
              ref.read(brushSettingsProvider.notifier).state = brushSettings.copyWith(hardness: 0.5);
            },
          ),
        ],
      ),
    );
  }
}
