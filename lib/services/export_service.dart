import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

class _EncodeTask {
  final Uint8List bytes;
  final int width;
  final int height;
  final String format;
  final int quality;

  _EncodeTask({
    required this.bytes,
    required this.width,
    required this.height,
    required this.format,
    required this.quality,
  });
}

Uint8List _encodeIsolate(_EncodeTask task) {
  final decoded = img.Image.fromBytes(
    width: task.width,
    height: task.height,
    bytes: task.bytes.buffer,
    numChannels: 4,
    order: img.ChannelOrder.rgba,
  );

  final format = task.format.toLowerCase();
  if (format == 'jpg' || format == 'jpeg') {
    return img.encodeJpg(decoded, quality: task.quality);
  } else if (format == 'webp') {
    return img.encodeJpg(decoded, quality: task.quality); // image pkg doesn't support webp encode; use high-quality jpg as fallback
  } else {
    return img.encodePng(decoded);
  }
}

class ExportService {
  static Future<void> exportImage({
    required ui.Image image,
    required String path,
    required String format,
    double quality = 0.9,
    void Function(double)? onProgress,
  }) async {
    onProgress?.call(0.1);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    onProgress?.call(0.3);
    if (bytes == null) return;

    final encoded = await compute(_encodeIsolate, _EncodeTask(
      bytes: bytes.buffer.asUint8List(),
      width: image.width,
      height: image.height,
      format: format,
      quality: (quality * 100).toInt(),
    ));
    
    onProgress?.call(0.8);
    await File(path).writeAsBytes(encoded);
    onProgress?.call(1.0);
  }
}
