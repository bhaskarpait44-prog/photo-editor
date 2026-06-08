import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

class ImageProcessingService {
  static Future<ui.Image> cropImage(ui.Image image, Rect cropRect) async {
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    if (bytes == null) return image;

    final decoded = img.decodeImage(bytes.buffer.asUint8List());
    if (decoded == null) return image;

    final cropped = img.copyCrop(
      decoded,
      x: cropRect.left.toInt(),
      y: cropRect.top.toInt(),
      width: cropRect.width.toInt(),
      height: cropRect.height.toInt(),
    );

    final encoded = img.encodePng(cropped);
    final codec = await ui.instantiateImageCodec(encoded);
    final frame = await codec.getNextFrame();
    return frame.image;
  }
}
