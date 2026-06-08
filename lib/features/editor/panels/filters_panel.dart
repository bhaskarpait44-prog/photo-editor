import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/filter_presets.dart';
import '../panels/adjustments_panel.dart';

class FiltersPanel extends ConsumerWidget {
  const FiltersPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentAdjustments = ref.watch(adjustmentsProvider);

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
              final preset = FilterPresets.all.values.elementAt(index);
              final isSelected = currentAdjustments == preset;

              return GestureDetector(
                onTap: () => ref.read(adjustmentsProvider.notifier).state = preset,
                child: Container(
                  width: 80,
                  margin: const EdgeInsets.only(right: 12),
                  child: Column(
                    children: [
                      Container(
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(8),
                          border: isSelected ? Border.all(color: const Color(0xFFFF6B35), width: 2) : null,
                        ),
                        child: const Center(
                          child: Icon(Icons.image, color: Colors.white24, size: 32),
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
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Intensity', style: TextStyle(color: Colors.white38, fontSize: 12)),
                  Text('100%', style: TextStyle(color: Colors.white38, fontSize: 12)),
                ],
              ),
              Slider(
                value: 100,
                min: 0,
                max: 100,
                onChanged: (val) {},
                activeColor: const Color(0xFFFF6B35),
                inactiveColor: Colors.white10,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
