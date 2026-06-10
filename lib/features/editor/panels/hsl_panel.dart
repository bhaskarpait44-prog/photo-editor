import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/hsl_provider.dart';
import '../widgets/custom_slider.dart';

class HslPanel extends ConsumerWidget {
  const HslPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hslState = ref.watch(hslProvider);
    final selectedIndex = ref.watch(selectedHslRangeProvider);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Color Range', style: TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
          const SizedBox(height: 12),
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 8,
              itemBuilder: (context, i) {
                final isSelected = selectedIndex == i;
                return GestureDetector(
                  onTap: () => ref.read(selectedHslRangeProvider.notifier).state = i,
                  child: Container(
                    width: 32,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: Color(HslRangeState.rangeColors[i]),
                      shape: BoxShape.circle,
                      border: isSelected ? Border.all(color: Colors.white, width: 2) : null,
                      boxShadow: isSelected ? [BoxShadow(color: Color(HslRangeState.rangeColors[i]).withValues(alpha: 0.5), blurRadius: 8)] : null,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          Text(
            HslRangeState.rangeNames[selectedIndex].toUpperCase(),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 1.5),
          ),
          const SizedBox(height: 20),
          CustomSlider(
            label: 'Hue',
            value: hslState.hueOffsets[selectedIndex] * 100,
            min: -100,
            max: 100,
            onChanged: (v) => ref.read(hslProvider.notifier).state = hslState.copyWithHue(selectedIndex, v / 100),
            onReset: () => ref.read(hslProvider.notifier).state = hslState.copyWithHue(selectedIndex, 0.0),
          ),
          const SizedBox(height: 20),
          CustomSlider(
            label: 'Saturation',
            value: hslState.satOffsets[selectedIndex] * 100,
            min: -100,
            max: 100,
            onChanged: (v) => ref.read(hslProvider.notifier).state = hslState.copyWithSat(selectedIndex, v / 100),
            onReset: () => ref.read(hslProvider.notifier).state = hslState.copyWithSat(selectedIndex, 0.0),
          ),
          const SizedBox(height: 20),
          CustomSlider(
            label: 'Luminance',
            value: hslState.lumOffsets[selectedIndex] * 100,
            min: -100,
            max: 100,
            onChanged: (v) => ref.read(hslProvider.notifier).state = hslState.copyWithLum(selectedIndex, v / 100),
            onReset: () => ref.read(hslProvider.notifier).state = hslState.copyWithLum(selectedIndex, 0.0),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => ref.read(hslProvider.notifier).state = hslState.reset(),
              child: const Text('Reset All', style: TextStyle(color: Color(0xFFFF6B35))),
            ),
          ),
        ],
      ),
    );
  }
}
