import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/layer_model.dart';
import '../../../providers/layers_provider.dart';

class TransformToolOverlay extends ConsumerWidget {
  const TransformToolOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeLayerId = ref.watch(activeLayerIdProvider);
    final layers = ref.watch(layersProvider);
    final activeLayerIndex = layers.indexWhere((l) => l.id == activeLayerId);

    if (activeLayerIndex == -1) {
      return const Center(
        child: Text('Select a layer to transform', style: TextStyle(color: Colors.white38)),
      );
    }

    final layer = layers[activeLayerIndex];

    return Stack(
      children: [
        Positioned(
          left: layer.offsetX - 80 * layer.scale,
          top: layer.offsetY - 80 * layer.scale,
          child: Transform.rotate(
            angle: layer.rotation,
            child: GestureDetector(
              onPanUpdate: (details) {
                ref.read(layersProvider.notifier).updateLayer(
                  layer.copyWith(
                    offsetX: layer.offsetX + details.delta.dx,
                    offsetY: layer.offsetY + details.delta.dy,
                  ),
                );
              },
              child: Container(
                width: 160 * layer.scale,
                height: 160 * layer.scale,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFFF6B35), width: 1, style: BorderStyle.none),
                ),
                child: CustomPaint(
                  painter: _DashedBorderPainter(color: const Color(0xFFFF6B35)),
                ),
              ),
            ),
          ),
        ),
        // Rotation Handle
        Positioned(
          left: layer.offsetX + (0) * cos(layer.rotation) - (-90 * layer.scale) * sin(layer.rotation) - 12,
          top: layer.offsetY + (0) * sin(layer.rotation) + (-90 * layer.scale) * cos(layer.rotation) - 12,
          child: GestureDetector(
            onPanUpdate: (details) {
              ref.read(layersProvider.notifier).updateLayer(
                layer.copyWith(rotation: layer.rotation + details.delta.dx * 0.02),
              );
            },
            child: Container(
              width: 24, height: 24,
              decoration: const BoxDecoration(color: Color(0xFFFF6B35), shape: BoxShape.circle),
              child: const Icon(Icons.rotate_right, color: Colors.white, size: 16),
            ),
          ),
        ),
        // Scale Handle
        Positioned(
          left: layer.offsetX + (80 * layer.scale) * cos(layer.rotation) - (80 * layer.scale) * sin(layer.rotation) - 10,
          top: layer.offsetY + (80 * layer.scale) * sin(layer.rotation) + (80 * layer.scale) * cos(layer.rotation) - 10,
          child: GestureDetector(
            onPanUpdate: (details) {
              final newScale = (layer.scale + (details.delta.dx + details.delta.dy) / 100).clamp(0.1, 10.0);
              ref.read(layersProvider.notifier).updateLayer(
                layer.copyWith(scale: newScale),
              );
            },
            child: Container(
              width: 20, height: 20,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(2),
                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  _DashedBorderPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const dashWidth = 5.0;
    const dashSpace = 3.0;
    
    // Draw top
    _drawDashedLine(canvas, Offset.zero, Offset(size.width, 0), paint, dashWidth, dashSpace);
    // Draw right
    _drawDashedLine(canvas, Offset(size.width, 0), Offset(size.width, size.height), paint, dashWidth, dashSpace);
    // Draw bottom
    _drawDashedLine(canvas, Offset(size.width, size.height), Offset(0, size.height), paint, dashWidth, dashSpace);
    // Draw left
    _drawDashedLine(canvas, Offset(0, size.height), Offset.zero, paint, dashWidth, dashSpace);
  }

  void _drawDashedLine(Canvas canvas, Offset p1, Offset p2, Paint paint, double dashWidth, double dashSpace) {
    double distance = (p2 - p1).distance;
    int count = (distance / (dashWidth + dashSpace)).floor();
    for (int i = 0; i < count; i++) {
      double start = i * (dashWidth + dashSpace);
      canvas.drawLine(
        Offset.lerp(p1, p2, start / distance)!,
        Offset.lerp(p1, p2, (start + dashWidth) / distance)!,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
