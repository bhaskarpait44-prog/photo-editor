import 'dart:ui' as ui;
import 'package:flutter_riverpod/flutter_riverpod.dart';

final imageCacheProvider = StateNotifierProvider<ImageCacheNotifier, Map<String, ui.Image>>((ref) {
  return ImageCacheNotifier();
});

class ImageCacheNotifier extends StateNotifier<Map<String, ui.Image>> {
  ImageCacheNotifier() : super({});

  void cacheImage(String id, ui.Image image) {
    state = {...state, id: image};
  }

  ui.Image? getImage(String id) => state[id];
}
