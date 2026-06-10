import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/brush_provider.dart';
import '../widgets/custom_slider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class BrushPanel extends ConsumerWidget {
  const BrushPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(brushSettingsProvider);
    final isEraser = ref.watch(isEraserModeProvider);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Mode', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: false, label: Text('Paint')),
                ButtonSegment(value: true, label: Text('Eraser')),
              ],
              selected: {isEraser},
              onSelectionChanged: (set) => ref.read(isEraserModeProvider.notifier).state = set.first,
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.resolveWith((states) => states.contains(WidgetState.selected) ? Colors.white : Colors.white70),
                backgroundColor: WidgetStateProperty.resolveWith((states) => states.contains(WidgetState.selected) ? const Color(0xFFFF6B35) : Colors.white10),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        CustomSlider(
          label: 'Size',
          value: settings.size,
          min: 1,
          max: 200,
          onChanged: (val) => ref.read(brushSettingsProvider.notifier).state = settings.copyWith(size: val),
          onReset: () => ref.read(brushSettingsProvider.notifier).state = settings.copyWith(size: 20.0),
        ),
        CustomSlider(
          label: 'Hardness',
          value: settings.hardness * 100,
          min: 0,
          max: 100,
          onChanged: (val) => ref.read(brushSettingsProvider.notifier).state = settings.copyWith(hardness: val / 100),
          onReset: () => ref.read(brushSettingsProvider.notifier).state = settings.copyWith(hardness: 0.5),
        ),
        CustomSlider(
          label: 'Opacity',
          value: settings.opacity * 100,
          min: 0,
          max: 100,
          onChanged: (val) => ref.read(brushSettingsProvider.notifier).state = settings.copyWith(opacity: val / 100),
          onReset: () => ref.read(brushSettingsProvider.notifier).state = settings.copyWith(opacity: 1.0),
        ),
        CustomSlider(
          label: 'Flow',
          value: settings.flow * 100,
          min: 0,
          max: 100,
          onChanged: (val) => ref.read(brushSettingsProvider.notifier).state = settings.copyWith(flow: val / 100),
          onReset: () => ref.read(brushSettingsProvider.notifier).state = settings.copyWith(flow: 1.0),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Text('Color', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            const Spacer(),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    Color pickerColor = settings.color;
                    return AlertDialog(
                      title: const Text('Pick a color'),
                      content: SingleChildScrollView(
                        child: ColorPicker(
                          pickerColor: pickerColor,
                          onColorChanged: (c) => pickerColor = c,
                        ),
                      ),
                      actions: [
                        TextButton(
                          child: const Text('Done'),
                          onPressed: () {
                            ref.read(brushSettingsProvider.notifier).state = settings.copyWith(color: pickerColor);
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: settings.color,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white24, width: 2),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
