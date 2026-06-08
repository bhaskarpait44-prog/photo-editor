import 'package:flutter/material.dart';

class CustomSlider extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;
  final VoidCallback onReset;

  const CustomSlider({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    required this.onReset,
    this.min = -100.0,
    this.max = 100.0,
  });

  @override
  Widget build(BuildContext context) {
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
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
