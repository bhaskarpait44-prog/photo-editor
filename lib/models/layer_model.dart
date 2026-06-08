import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'layer_model.freezed.dart';

enum LayerType { image, adjustment, text, shape }

@freezed
class LayerModel with _$LayerModel {
  const factory LayerModel({
    required String id,
    required String name,
    required LayerType type,
    String? imagePath,
    String? maskPath,
    @Default(100.0) double opacity,
    @Default(true) bool isVisible,
    @Default(false) bool isLocked,
    @Default(BlendMode.srcOver) BlendMode blendMode,
    @Default(0.0) double offsetX,
    @Default(0.0) double offsetY,
    @Default(1.0) double scale,
    @Default(0.0) double rotation,
  }) = _LayerModel;
}
