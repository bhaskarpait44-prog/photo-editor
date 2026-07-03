import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import '../models/adjustment_model.dart';
import 'dart:math' show pow;

class _AdjustmentTask {
  final ByteData imageBytes;
  final int width;
  final int height;
  final AdjustmentModel adj;
  final int maxSize;

  _AdjustmentTask({
    required this.imageBytes,
    required this.width,
    required this.height,
    required this.adj,
    required this.maxSize,
  });
}

Uint8List _applyAdjustmentsIsolate(_AdjustmentTask task) {
  img.Image decoded = img.Image.fromBytes(
    width: task.width,
    height: task.height,
    bytes: task.imageBytes.buffer,
    numChannels: 4,
    order: img.ChannelOrder.rgba,
  );

  // Downsample first
  if (decoded.width > task.maxSize || decoded.height > task.maxSize) {
    decoded = decoded.width > decoded.height
      ? img.copyResize(decoded, width: task.maxSize)
      : img.copyResize(decoded, height: task.maxSize);
  }

  final adj = task.adj;

  for (var p in decoded) {
    double r = p.r.toDouble();
    double g = p.g.toDouble();
    double b = p.b.toDouble();

    // Brightness
    r += (adj.brightness / 100) * 255;
    g += (adj.brightness / 100) * 255;
    b += (adj.brightness / 100) * 255;

    // Contrast
    if (adj.contrast != 0) {
      final factor = (259 * (adj.contrast + 255)) / (255 * (259 - adj.contrast));
      r = factor * (r - 128) + 128;
      g = factor * (g - 128) + 128;
      b = factor * (b - 128) + 128;
    }

    // Exposure (multiply by 2^EV)
    if (adj.exposure != 0) {
      final ev = pow(2.0, adj.exposure);
      r *= ev;
      g *= ev;
      b *= ev;
    }

    // Temperature (warm = shift red/blue)
    if (adj.temperature != 0) {
      r += (adj.temperature / 100) * 30;
      b -= (adj.temperature / 100) * 30;
    }

    // Tint (green-magenta)
    if (adj.tint != 0) {
      g += (adj.tint / 100) * 20;
      r -= (adj.tint / 100) * 10;
      b -= (adj.tint / 100) * 10;
    }

    r = r.clamp(0, 255);
    g = g.clamp(0, 255);
    b = b.clamp(0, 255);

    // Convert to HSL for saturation/hue adjustments
    if (adj.saturation != 0 || adj.vibrance != 0 || adj.hue != 0) {
      final hsl = _rgbToHsl(r / 255, g / 255, b / 255);
      double h = hsl[0], s = hsl[1], l = hsl[2];

      // Saturation
      s = (s + (adj.saturation / 100)).clamp(0.0, 1.0);

      // Vibrance (applies more to less-saturated colors)
      if (adj.vibrance != 0) {
        final satBoost = (adj.vibrance / 100) * (1 - s);
        s = (s + satBoost).clamp(0.0, 1.0);
      }

      // Hue shift
      h = (h + adj.hue / 360) % 1.0;
      if (h < 0) h += 1.0;

      final rgb = _hslToRgb(h, s, l);
      r = rgb[0] * 255;
      g = rgb[1] * 255;
      b = rgb[2] * 255;
    }

    p.r = r.clamp(0, 255);
    p.g = g.clamp(0, 255);
    p.b = b.clamp(0, 255);
  }

  return img.encodePng(decoded);
}

List<double> _rgbToHsl(double r, double g, double b) {
  final max = [r, g, b].reduce((a, c) => a > c ? a : c);
  final min = [r, g, b].reduce((a, c) => a < c ? a : c);
  final l = (max + min) / 2;
  if (max == min) return [0, 0, l];
  final d = max - min;
  final s = l > 0.5 ? d / (2 - max - min) : d / (max + min);
  double h;
  if (max == r) h = (g - b) / d + (g < b ? 6 : 0);
  else if (max == g) h = (b - r) / d + 2;
  else h = (r - g) / d + 4;
  return [h / 6, s, l];
}

double _hue2rgb(double p, double q, double t) {
  if (t < 0) t += 1;
  if (t > 1) t -= 1;
  if (t < 1/6) return p + (q - p) * 6 * t;
  if (t < 1/2) return q;
  if (t < 2/3) return p + (q - p) * (2/3 - t) * 6;
  return p;
}

List<double> _hslToRgb(double h, double s, double l) {
  if (s == 0) return [l, l, l];
  final q = l < 0.5 ? l * (1 + s) : l + s - l * s;
  final p = 2 * l - q;
  return [_hue2rgb(p, q, h + 1/3), _hue2rgb(p, q, h), _hue2rgb(p, q, h - 1/3)];
}

class _CropTask {
  final Uint8List bytes;
  final int width;
  final int height;
  final int cropX;
  final int cropY;
  final int cropW;
  final int cropH;
  final double rotationDegrees;

  _CropTask({
    required this.bytes,
    required this.width,
    required this.height,
    required this.cropX,
    required this.cropY,
    required this.cropW,
    required this.cropH,
    this.rotationDegrees = 0.0,
  });
}

Uint8List _cropIsolate(_CropTask task) {
  final decoded = img.Image.fromBytes(
    width: task.width,
    height: task.height,
    bytes: task.bytes.buffer,
    numChannels: 4,
    order: img.ChannelOrder.rgba,
  );

  var cropped = img.copyCrop(
    decoded,
    x: task.cropX,
    y: task.cropY,
    width: task.cropW,
    height: task.cropH,
  );

  if (task.rotationDegrees != 0.0) {
    cropped = img.copyRotate(cropped, angle: task.rotationDegrees);
  }

  return img.encodePng(cropped);
}

class ImageProcessingService {
  static Future<ui.Image> cropImage(ui.Image image, Rect cropRect, {double rotationDegrees = 0.0}) async {
    final bytes = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    if (bytes == null) return image;
    
    final result = await compute(_cropIsolate, _CropTask(
      bytes: bytes.buffer.asUint8List(),
      width: image.width,
      height: image.height,
      cropX: cropRect.left.toInt(),
      cropY: cropRect.top.toInt(),
      cropW: cropRect.width.toInt(),
      cropH: cropRect.height.toInt(),
      rotationDegrees: rotationDegrees,
    ));

    final codec = await ui.instantiateImageCodec(result);
    final frame = await codec.getNextFrame();
    return frame.image;
  }

  static Future<ui.Image> applyAdjustmentsToImage(
    ui.Image source,
    AdjustmentModel adj, {
    int maxSize = 400,
  }) async {
    final bytes = await source.toByteData(format: ui.ImageByteFormat.rawRgba);
    if (bytes == null) return source;

    final result = await compute(_applyAdjustmentsIsolate, _AdjustmentTask(
      imageBytes: bytes,
      width: source.width,
      height: source.height,
      adj: adj,
      maxSize: maxSize,
    ));

    final codec = await ui.instantiateImageCodec(result);
    final frame = await codec.getNextFrame();
    return frame.image;
  }
}
