import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'brush_settings_model.freezed.dart';

@freezed
class BrushSettingsModel with _$BrushSettingsModel {
  const factory BrushSettingsModel({
    @Default(20.0) double size,
    @Default(0.5) double hardness,
    @Default(1.0) double opacity,
    @Default(1.0) double flow,
    @Default(Colors.black) Color color,
    @Default(0.1) double spacing,
  }) = _BrushSettingsModel;
}
