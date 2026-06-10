import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../../../models/adjustment_model.dart';
import '../../../models/layer_model.dart';
import '../../../providers/hsl_provider.dart';
import '../../../services/shader_service.dart';
import '../../../models/curves_model.dart';
import '../../../providers/curves_provider.dart';

class CanvasPainter extends CustomPainter {
  final Map<String, ui.Image> images;
  final List<LayerModel> layers;
  final Offset offset;
  final double scale;
  final double rotation;
  final AdjustmentModel adjustments;
  final bool isInteracting;
  final bool isBeforeView;
  final HslRangeState? hslRanges;
  final CurvesState? curvesState;

  CanvasPainter({
    required this.images,
    required this.layers,
    required this.offset,
    required this.scale,
    required this.rotation,
    required this.adjustments,
    this.isInteracting = false,
    this.isBeforeView = false,
    this.hslRanges,
    this.curvesState,
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

      ui.Image? image;
      if (layer.type == LayerType.image) {
        if (isInteracting && layer.name == 'Base') {
          image = images['${layer.id}_preview'] ?? images[layer.id];
        } else {
          image = images[layer.id];
        }
        if (image == null) continue;
      }

      _drawLayer(canvas, layer, image);
    }

    canvas.restore();
  }

  void _drawLayer(Canvas canvas, LayerModel layer, ui.Image? image) {
    if (layer.type == LayerType.image && image != null) {
      canvas.save();
      canvas.translate(layer.offsetX, layer.offsetY);
      canvas.scale(layer.scale);
      canvas.rotate(layer.rotation);

      // Apply flips
      if (layer.isFlippedH || layer.isFlippedV) {
        canvas.scale(
          layer.isFlippedH ? -1.0 : 1.0,
          layer.isFlippedV ? -1.0 : 1.0,
        );
      }

      if (layer.name == 'Base') {
        _drawLayerWithAdjustments(canvas, image, layer);
      } else {
        final paint = Paint()
          ..filterQuality = FilterQuality.medium
          ..color = Colors.white.withValues(alpha: layer.opacity / 100.0)
          ..blendMode = layer.blendMode;

        final double drawX = -image.width.toDouble() / 2;
        final double drawY = -image.height.toDouble() / 2;
        canvas.drawImage(image, Offset(drawX, drawY), paint);
      }
      canvas.restore();
    } else if (layer.type == LayerType.text && layer.textSettings != null) {
      canvas.save();
      canvas.translate(layer.offsetX, layer.offsetY);
      canvas.scale(layer.scale);
      canvas.rotate(layer.rotation);

      // Apply flips
      if (layer.isFlippedH || layer.isFlippedV) {
        canvas.scale(
          layer.isFlippedH ? -1.0 : 1.0,
          layer.isFlippedV ? -1.0 : 1.0,
        );
      }

      final ts = layer.textSettings!;
      final textPainter = TextPainter(
        text: TextSpan(
          text: ts.text,
          style: TextStyle(
            fontFamily: ts.fontFamily,
            fontSize: ts.fontSize,
            color: ts.color.withValues(alpha: layer.opacity / 100.0),
            fontWeight: ts.isBold ? FontWeight.bold : FontWeight.normal,
            fontStyle: ts.isItalic ? FontStyle.italic : FontStyle.normal,
            decoration: ts.isUnderline ? TextDecoration.underline : TextDecoration.none,
            letterSpacing: ts.letterSpacing,
            height: ts.lineHeight,
            shadows: ts.shadowBlur > 0
              ? [Shadow(color: ts.shadowColor, blurRadius: ts.shadowBlur, offset: ts.shadowOffset)]
              : null,
          ),
        ),
        textDirection: TextDirection.ltr,
        textAlign: ts.textAlign,
      )..layout(maxWidth: 400);

      textPainter.paint(canvas, Offset(-textPainter.width / 2, -textPainter.height / 2));
      canvas.restore();
    }
  }

  void _drawLayerWithAdjustments(Canvas canvas, ui.Image image, LayerModel layer) {
    ui.Image current = image;

    // Apply all shader passes to get adjusted version
    current = _runShaderPasses(image, layer);

    if (isBeforeView) {
      // Left half: original
      canvas.save();
      canvas.clipRect(Rect.fromLTWH(-image.width / 2.0, -image.height / 2.0, image.width / 2.0, image.height.toDouble()));
      final origPaint = Paint()..filterQuality = FilterQuality.medium..color = Colors.white.withValues(alpha: layer.opacity / 100.0)..blendMode = layer.blendMode;
      canvas.drawImage(image, Offset(-image.width / 2.0, -image.height / 2.0), origPaint);
      canvas.restore();

      // Right half: adjusted
      canvas.save();
      canvas.clipRect(Rect.fromLTWH(0, -image.height / 2.0, image.width / 2.0, image.height.toDouble()));
      final adjPaint = Paint()..filterQuality = FilterQuality.medium..color = Colors.white.withValues(alpha: layer.opacity / 100.0)..blendMode = layer.blendMode;
      canvas.drawImage(current, Offset(-current.width / 2.0, -current.height / 2.0), adjPaint);
      canvas.restore();

      // Draw split line
      final linePaint = Paint()..color = Colors.white..strokeWidth = 1.5 / scale;
      canvas.drawLine(Offset(0, -image.height / 2.0), Offset(0, image.height / 2.0), linePaint);
      return;
    }

    // Normal: draw adjusted
    final paint = Paint()..filterQuality = FilterQuality.medium..color = Colors.white.withValues(alpha: layer.opacity / 100.0)..blendMode = layer.blendMode;
    canvas.drawImage(current, Offset(-current.width / 2.0, -current.height / 2.0), paint);
  }

  ui.Image _runShaderPasses(ui.Image image, LayerModel layer) {
    ui.Image current = image;

    current = _applyShaderPass(
      current,
      'brightness_contrast',
      uniforms: [adjustments.brightness / 100.0, adjustments.contrast / 100.0],
    ) ?? current;

    current = _applyShaderPass(
      current,
      'exposure_shadows_highlights',
      uniforms: [
        adjustments.exposure,
        adjustments.highlights / 100.0,
        adjustments.shadows / 100.0,
        adjustments.whites / 100.0,
        adjustments.blacks / 100.0,
      ],
    ) ?? current;

    current = _applyShaderPass(
      current,
      'hsl_adjust',
      uniforms: [
        adjustments.saturation / 100.0,
        adjustments.hue / 180.0,
        adjustments.vibrance / 100.0,
      ],
    ) ?? current;

    current = _applyShaderPass(
      current,
      'temperature_tint',
      uniforms: [adjustments.temperature / 100.0, adjustments.tint / 100.0],
    ) ?? current;

    current = _applyShaderPass(
      current,
      'detail_effects',
      uniforms: [
        adjustments.sharpness / 100.0,
        adjustments.clarity / 100.0,
        adjustments.dehaze / 100.0,
        adjustments.vignette / 100.0,
        adjustments.grain / 100.0,
        current.width.toDouble(),
        current.height.toDouble(),
      ],
    ) ?? current;

    // Curves pass (apply per-channel LUT)
    if (curvesState != null) {
      final rgbLUT = CurvesNotifier.generateLUT(curvesState!.rgb);
      final rLUT = CurvesNotifier.generateLUT(curvesState!.red);
      final gLUT = CurvesNotifier.generateLUT(curvesState!.green);
      final bLUT = CurvesNotifier.generateLUT(curvesState!.blue);

      // Check if all LUTs are linear (no-op)
      bool isIdentity(List<double> lut) {
        for (int i = 0; i < 256; i++) {
          if ((lut[i] - i / 255.0).abs() > 0.005) return false;
        }
        return true;
      }

      if (!isIdentity(rgbLUT) || !isIdentity(rLUT) || !isIdentity(gLUT) || !isIdentity(bLUT)) {
        // Apply curves in software (CPU) since shader LUT textures aren't trivial
        // For now, skip actual application and just note as future enhancement
        // current = _applyCurvesLUT(current, rgbLUT, rLUT, gLUT, bLUT) ?? current;
      }
    }

    if (hslRanges != null) {
      final allZero = hslRanges!.hueOffsets.every((v) => v == 0) &&
                      hslRanges!.satOffsets.every((v) => v == 0) &&
                      hslRanges!.lumOffsets.every((v) => v == 0);
      if (!allZero) {
        current = _applyShaderPass(current, 'hsl_ranges', uniforms: [
          ...hslRanges!.hueOffsets,
          ...hslRanges!.satOffsets,
          ...hslRanges!.lumOffsets,
        ]) ?? current;
      }
    }
    return current;
  }

  ui.Image? _applyShaderPass(ui.Image image, String shaderName, {required List<double> uniforms}) {
    // Optimization: skip pass if all uniforms are 0
    bool allZero = true;
    for (int i = 0; i < uniforms.length; i++) {
        // detail_effects has resolution as last 2 uniforms, don't consider them for skipping
        if (shaderName == 'detail_effects' && i >= uniforms.length - 2) break;
        if (uniforms[i] != 0.0) { allZero = false; break; }
    }
    if (allZero) return image;

    final shader = ShaderService().getShader(shaderName, uniforms: uniforms, image: image);
    if (shader == null) return null;

    final recorder = ui.PictureRecorder();
    final c = Canvas(recorder);
    final paint = Paint()..shader = shader;
    c.drawRect(Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()), paint);
    final picture = recorder.endRecording();
    return picture.toImageSync(image.width, image.height);
  }

  @override
  bool shouldRepaint(covariant CanvasPainter oldDelegate) {
    return oldDelegate.images != images ||
        oldDelegate.layers != layers ||
        oldDelegate.offset != offset ||
        oldDelegate.scale != scale ||
        oldDelegate.rotation != rotation ||
        oldDelegate.adjustments != adjustments ||
        oldDelegate.isInteracting != isInteracting ||
        oldDelegate.isBeforeView != isBeforeView ||
        oldDelegate.hslRanges != hslRanges ||
        oldDelegate.curvesState != curvesState;
  }
}