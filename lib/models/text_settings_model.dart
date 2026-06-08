import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'text_settings_model.freezed.dart';

@freezed
class TextSettingsModel with _$TextSettingsModel {
  const factory TextSettingsModel({
    required String text,
    @Default('Roboto') String fontFamily,
    @Default(24.0) double fontSize,
    @Default(Colors.white) Color color,
    @Default(TextAlign.center) TextAlign textAlign,
    @Default(0.0) double letterSpacing,
    @Default(1.2) double lineHeight,
    @Default(false) bool isBold,
    @Default(false) bool isItalic,
    @Default(false) bool isUnderline,
    @Default(0.0) double strokeWidth,
    @Default(Colors.transparent) Color strokeColor,
    @Default(Offset.zero) Offset shadowOffset,
    @Default(0.0) double shadowBlur,
    @Default(Colors.transparent) Color shadowColor,
  }) = _TextSettingsModel;
}
