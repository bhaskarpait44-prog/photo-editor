import 'dart:isolate';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import '../models/adjustment_model.dart';

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

  if (decoded.width > task.maxSize || decoded.height > task.maxSize) {
    if (decoded.width > decoded.height) {
      decoded = img.copyResize(decoded, width: task.maxSize);
    } else {
      decoded = img.copyResize(decoded, height: task.maxSize);
    }
  }

  // Basic implementation of Brightness/Contrast
  for (var p in decoded) {
    num r = p.r;
    num g = p.g;
    num b = p.b;

    // Brightness
    r += (task.adj.brightness / 100) * 255;
    g += (task.adj.brightness / 100) * 255;
    b += (task.adj.brightness / 100) * 255;

    // Contrast
    final factor = (259 * (task.adj.contrast + 255)) / (255 * (259 - task.adj.contrast));
    r = factor * (r - 128) + 128;
    g = factor * (g - 128) + 128;
    b = factor * (b - 128) + 128;

    p.r = r.clamp(0, 255);
    p.g = g.clamp(0, 255);
    p.b = b.clamp(0, 255);
  }

  return img.encodePng(decoded);
}

class _CropTask {
  final Uint8List bytes;
  final int width;
  final int height;
  final int cropX;
  final int cropY;
  final int cropW;
  final int cropH;

  _CropTask({
    required this.bytes,
    required this.width,
    required this.height,
    required this.cropX,
    required this.cropY,
    required this.cropW,
    required this.cropH,
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

  final cropped = img.copyCrop(
    decoded,
    x: task.cropX,
    y: task.cropY,
    width: task.cropW,
    height: task.cropH,
  );

  return img.encodePng(cropped);
}

class ImageProcessingService {
  static Future<ui.Image> cropImage(ui.Image image, Rect cropRect) async {
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
