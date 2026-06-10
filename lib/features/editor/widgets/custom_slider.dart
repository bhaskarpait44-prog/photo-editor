import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/interaction_provider.dart';

class CustomSlider extends ConsumerWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;
  final ValueChanged<double>? onChangeEnd;
  final VoidCallback onReset;

  const CustomSlider({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.onChangeEnd,
    required this.onReset,
    this.min = -100.0,
    this.max = 100.0,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
            GestureDetector(
              onDoubleTap: onReset,
              child: Text(
                value.toStringAsFixed(1),
                style: const TextStyle(color: Color(0xFFFF6B35), fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
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
            value: value,
            min: min,
            max: max,
            onChangeStart: (_) => ref.read(isSliderInteractingProvider.notifier).state = true,
            onChanged: onChanged,
            onChangeEnd: (val) {
              ref.read(isSliderInteractingProvider.notifier).state = false;
              if (onChangeEnd != null) onChangeEnd!(val);
            },
          ),
        ),
      ],
    );
  }
}
