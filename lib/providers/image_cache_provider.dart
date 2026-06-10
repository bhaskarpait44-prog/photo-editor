import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final imageCacheProvider = StateNotifierProvider<ImageCacheNotifier, Map<String, ui.Image>>((ref) {
  return ImageCacheNotifier();
});

class ImageCacheNotifier extends StateNotifier<Map<String, ui.Image>> {
  ImageCacheNotifier() : super({});

  void cacheImage(String id, ui.Image image) {
    // Generate a 400px preview for fast sliding
    ui.Image? preview;
    if (image.width > 400) {
      final double ratio = 400 / image.width;
      const int newWidth = 400;
      final int newHeight = (image.height * ratio).toInt();
      
      final recorder = ui.PictureRecorder();
      final canvas = ui.Canvas(recorder);
      final paint = Paint()..filterQuality = FilterQuality.medium;
      
      canvas.drawImageRect(
        image, 
        Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
        Rect.fromLTWH(0, 0, newWidth.toDouble(), newHeight.toDouble()),
        paint,
      );
      preview = recorder.endRecording().toImageSync(newWidth, newHeight);
    }

    state = {
      ...state, 
      id: image,
      if (preview != null) '${id}_preview': preview,
    };
  }

  ui.Image? getImage(String id) => state[id];
}
