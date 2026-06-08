import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../../../models/adjustment_model.dart';
import '../../../models/layer_model.dart';
import '../../../services/shader_service.dart';

class CanvasPainter extends CustomPainter {
  final Map<String, ui.Image> images;
  final List<LayerModel> layers;
  final Offset offset;
  final double scale;
  final double rotation;
  final AdjustmentModel adjustments;

  CanvasPainter({
    required this.images,
    required this.layers,
    required this.offset,
    required this.scale,
    required this.rotation,
    required this.adjustments,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    
    // Global viewport transform
    canvas.translate(size.width / 2 + offset.dx, size.height / 2 + offset.dy);
    canvas.scale(scale);
    canvas.rotate(rotation);

    for (final layer in layers) {
      if (!layer.isVisible) continue;

      final image = images[layer.id];
      if (image == null && layer.type == LayerType.image) continue;

      _drawLayer(canvas, layer, image);
    }

    canvas.restore();
  }

  void _drawLayer(Canvas canvas, LayerModel layer, ui.Image? image) {
    final paint = Paint()
      ..filterQuality = FilterQuality.medium
      ..color = Colors.white.withValues(alpha: layer.opacity / 100.0)
      ..blendMode = layer.blendMode;

    canvas.save();
    
    // Individual layer transform
    canvas.translate(layer.offsetX, layer.offsetY);
    canvas.scale(layer.scale);
    canvas.rotate(layer.rotation);

    if (layer.type == LayerType.image && image != null) {
      // Apply adjustments to the base image layer (or active layer)
      // For now, only applying to the "Base" layer (first image layer)
      if (layer.name == 'Base') {
        _applyShaders(paint, image);
      }

      final double drawX = -image.width.toDouble() / 2;
      final double drawY = -image.height.toDouble() / 2;
      canvas.drawImage(image, Offset(drawX, drawY), paint);
    }
    
    // Future: Handle other layer types (text, shapes)

    canvas.restore();
  }

  void _applyShaders(Paint paint, ui.Image image) {
    if (adjustments.brightness != 0 || adjustments.contrast != 0) {
      final shader = ShaderService().getShader(
        'brightness_contrast',
        uniforms: [
          adjustments.brightness / 100.0,
          adjustments.contrast / 100.0,
        ],
        image: image,
      );
      if (shader != null) {
        paint.shader = shader;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CanvasPainter oldDelegate) {
    return oldDelegate.images != images ||
        oldDelegate.layers != layers ||
        oldDelegate.offset != offset ||
        oldDelegate.scale != scale ||
        oldDelegate.rotation != rotation ||
        oldDelegate.adjustments != adjustments;
  }
}
