import 'package:flutter/material.dart';

class CanvasController extends ChangeNotifier {
  Offset _offset = Offset.zero;
  double _scale = 1.0;
  double _rotation = 0.0;

  Offset get offset => _offset;
  double get scale => _scale;
  double get rotation => _rotation;

  void updateTransform({Offset? offset, double? scale, double? rotation}) {
    if (offset != null) _offset = offset;
    if (scale != null) _scale = scale.clamp(0.1, 10.0);
    if (rotation != null) _rotation = rotation;
    notifyListeners();
  }

  void reset() {
    _offset = Offset.zero;
    _scale = 1.0;
    _rotation = 0.0;
    notifyListeners();
  }

  Offset screenToCanvas(Offset screenPoint, Size screenSize, Size canvasSize) {
    // Basic implementation for now, will be refined with Matrix4 if needed
    final center = Offset(screenSize.width / 2, screenSize.height / 2);
    final relativePoint = screenPoint - center - _offset;
    return relativePoint / _scale;
  }
}
