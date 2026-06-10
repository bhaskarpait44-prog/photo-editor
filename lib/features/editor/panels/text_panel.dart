import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../../../models/layer_model.dart';
import '../../../providers/layers_provider.dart';
import '../widgets/custom_slider.dart';

class TextPanel extends ConsumerWidget {
  const TextPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeLayerId = ref.watch(activeLayerIdProvider);
    final layers = ref.watch(layersProvider);
    final activeLayerIndex = layers.indexWhere((l) => l.id == activeLayerId);
    
    if (activeLayerIndex == -1 || layers[activeLayerIndex].type != LayerType.text) {
      return const Center(
        child: Text('Tap on canvas to add text', style: TextStyle(color: Colors.white38)),
      );
    }

    final layer = layers[activeLayerIndex];
    final ts = layer.textSettings!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Font'),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButton<String>(
              value: ts.fontFamily,
              isExpanded: true,
              dropdownColor: const Color(0xFF1A1A1A),
              underline: const SizedBox(),
              style: const TextStyle(color: Colors.white),
              items: [
                'Roboto', 'Montserrat', 'Lato', 'Open Sans', 'Oswald', 
                'Raleway', 'Playfair Display', 'Merriweather', 'Nunito', 'Poppins'
              ].map((f) => DropdownMenuItem(value: f, child: Text(f))).toList(),
              onChanged: (v) {
                if (v != null) {
                  ref.read(layersProvider.notifier).updateLayer(
                    layer.copyWith(textSettings: ts.copyWith(fontFamily: v)),
                  );
                }
              },
            ),
          ),
          const SizedBox(height: 20),
          CustomSlider(
            label: 'Size',
            value: ts.fontSize,
            min: 8,
            max: 200,
            onChanged: (v) {
              ref.read(layersProvider.notifier).updateLayer(
                layer.copyWith(textSettings: ts.copyWith(fontSize: v)),
              );
            },
            onReset: () {
              ref.read(layersProvider.notifier).updateLayer(
                layer.copyWith(textSettings: ts.copyWith(fontSize: 24)),
              );
            },
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StyleButton(
                icon: Icons.format_bold,
                isSelected: ts.isBold,
                onTap: () => ref.read(layersProvider.notifier).updateLayer(
                  layer.copyWith(textSettings: ts.copyWith(isBold: !ts.isBold)),
                ),
              ),
              _StyleButton(
                icon: Icons.format_italic,
                isSelected: ts.isItalic,
                onTap: () => ref.read(layersProvider.notifier).updateLayer(
                  layer.copyWith(textSettings: ts.copyWith(isItalic: !ts.isItalic)),
                ),
              ),
              _StyleButton(
                icon: Icons.format_underlined,
                isSelected: ts.isUnderline,
                onTap: () => ref.read(layersProvider.notifier).updateLayer(
                  layer.copyWith(textSettings: ts.copyWith(isUnderline: !ts.isUnderline)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StyleButton(
                icon: Icons.format_align_left,
                isSelected: ts.textAlign == TextAlign.left,
                onTap: () => ref.read(layersProvider.notifier).updateLayer(
                  layer.copyWith(textSettings: ts.copyWith(textAlign: TextAlign.left)),
                ),
              ),
              _StyleButton(
                icon: Icons.format_align_center,
                isSelected: ts.textAlign == TextAlign.center,
                onTap: () => ref.read(layersProvider.notifier).updateLayer(
                  layer.copyWith(textSettings: ts.copyWith(textAlign: TextAlign.center)),
                ),
              ),
              _StyleButton(
                icon: Icons.format_align_right,
                isSelected: ts.textAlign == TextAlign.right,
                onTap: () => ref.read(layersProvider.notifier).updateLayer(
                  layer.copyWith(textSettings: ts.copyWith(textAlign: TextAlign.right)),
                ),
              ),
              _StyleButton(
                icon: Icons.format_align_justify,
                isSelected: ts.textAlign == TextAlign.justify,
                onTap: () => ref.read(layersProvider.notifier).updateLayer(
                  layer.copyWith(textSettings: ts.copyWith(textAlign: TextAlign.justify)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildColorPicker(context, ref, 'Text Color', ts.color, (c) {
            ref.read(layersProvider.notifier).updateLayer(
              layer.copyWith(textSettings: ts.copyWith(color: c)),
            );
          }),
          const SizedBox(height: 20),
          CustomSlider(
            label: 'Letter Spacing',
            value: ts.letterSpacing,
            min: -5,
            max: 20,
            onChanged: (v) {
              ref.read(layersProvider.notifier).updateLayer(
                layer.copyWith(textSettings: ts.copyWith(letterSpacing: v)),
              );
            },
            onReset: () {
              ref.read(layersProvider.notifier).updateLayer(
                layer.copyWith(textSettings: ts.copyWith(letterSpacing: 0.0)),
              );
            },
          ),
          const SizedBox(height: 20),
          CustomSlider(
            label: 'Line Height',
            value: ts.lineHeight,
            min: 0.8,
            max: 3.0,
            onChanged: (v) {
              ref.read(layersProvider.notifier).updateLayer(
                layer.copyWith(textSettings: ts.copyWith(lineHeight: v)),
              );
            },
            onReset: () {
              ref.read(layersProvider.notifier).updateLayer(
                layer.copyWith(textSettings: ts.copyWith(lineHeight: 1.2)),
              );
            },
          ),
          const SizedBox(height: 20),
          CustomSlider(
            label: 'Shadow Blur',
            value: ts.shadowBlur,
            min: 0,
            max: 30,
            onChanged: (v) {
              ref.read(layersProvider.notifier).updateLayer(
                layer.copyWith(textSettings: ts.copyWith(shadowBlur: v)),
              );
            },
            onReset: () {
              ref.read(layersProvider.notifier).updateLayer(
                layer.copyWith(textSettings: ts.copyWith(shadowBlur: 0.0)),
              );
            },
          ),
          const SizedBox(height: 20),
          _buildColorPicker(context, ref, 'Shadow Color', ts.shadowColor, (c) {
            ref.read(layersProvider.notifier).updateLayer(
              layer.copyWith(textSettings: ts.copyWith(shadowColor: c)),
            );
          }),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2),
      ),
    );
  }

  Widget _buildColorPicker(BuildContext context, WidgetRef ref, String label, Color currentColor, ValueChanged<Color> onColorChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(label),
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: const Color(0xFF1A1A1A),
                title: Text('Pick $label', style: const TextStyle(color: Colors.white)),
                content: SingleChildScrollView(
                  child: ColorPicker(
                    pickerColor: currentColor,
                    onColorChanged: onColorChanged,
                    pickerAreaHeightPercent: 0.8,
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Done', style: TextStyle(color: Color(0xFFFF6B35))),
                  ),
                ],
              ),
            );
          },
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: currentColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white10, width: 1),
            ),
          ),
        ),
      ],
    );
  }
}

class _StyleButton extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _StyleButton({
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, color: isSelected ? const Color(0xFFFF6B35) : Colors.white),
      onPressed: onTap,
    );
  }
}
