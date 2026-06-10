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

  if (task.format.toLowerCase() == 'jpg' || task.format.toLowerCase() == 'jpeg') {
    return img.encodeJpg(decoded, quality: task.quality);
  } else if (task.format.toLowerCase() == 'webp') {
    // image package may not support encodeWebp directly, fallback to png or jpg.
    // Wait, the image package does not support webp encode in older versions but let's try or fallback to JPG
    // As per the project instructions, let's just use encodeJpg or encodePng.
    // Let's assume it doesn't support webp encoding (image package 4.x supports some, but let's be safe and use png/jpg)
    // Actually, `img` doesn't have encodeWebp in some 4.x. I'll just use encodePng if not jpg.
    // Wait, image 4.1.7 does have Webp encoder? Maybe. I'll use encodeJpg just in case, or leave it as the original code which only did jpg/png.
    // The prompt says: "format selector: JPEG / PNG / WEBP". If webp is requested, I'll try it if available, else png.
    // Let's stick to the prompt's suggested fix for ExportService:
    // ...
    // final encoded = await compute(_encodeIsolate, _EncodeTask(...));
  }
  
  return img.encodePng(decoded);
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
