// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'adjustment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AdjustmentModelImpl _$$AdjustmentModelImplFromJson(
        Map<String, dynamic> json) =>
    _$AdjustmentModelImpl(
      brightness: (json['brightness'] as num?)?.toDouble() ?? 0.0,
      contrast: (json['contrast'] as num?)?.toDouble() ?? 0.0,
      exposure: (json['exposure'] as num?)?.toDouble() ?? 0.0,
      highlights: (json['highlights'] as num?)?.toDouble() ?? 0.0,
      shadows: (json['shadows'] as num?)?.toDouble() ?? 0.0,
      whites: (json['whites'] as num?)?.toDouble() ?? 0.0,
      blacks: (json['blacks'] as num?)?.toDouble() ?? 0.0,
      saturation: (json['saturation'] as num?)?.toDouble() ?? 0.0,
      vibrance: (json['vibrance'] as num?)?.toDouble() ?? 0.0,
      hue: (json['hue'] as num?)?.toDouble() ?? 0.0,
      temperature: (json['temperature'] as num?)?.toDouble() ?? 0.0,
      tint: (json['tint'] as num?)?.toDouble() ?? 0.0,
      sharpness: (json['sharpness'] as num?)?.toDouble() ?? 0.0,
      clarity: (json['clarity'] as num?)?.toDouble() ?? 0.0,
      dehaze: (json['dehaze'] as num?)?.toDouble() ?? 0.0,
      vignette: (json['vignette'] as num?)?.toDouble() ?? 0.0,
      grain: (json['grain'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$AdjustmentModelImplToJson(
        _$AdjustmentModelImpl instance) =>
    <String, dynamic>{
      'brightness': instance.brightness,
      'contrast': instance.contrast,
      'exposure': instance.exposure,
      'highlights': instance.highlights,
      'shadows': instance.shadows,
      'whites': instance.whites,
      'blacks': instance.blacks,
      'saturation': instance.saturation,
      'vibrance': instance.vibrance,
      'hue': instance.hue,
      'temperature': instance.temperature,
      'tint': instance.tint,
      'sharpness': instance.sharpness,
      'clarity': instance.clarity,
      'dehaze': instance.dehaze,
      'vignette': instance.vignette,
      'grain': instance.grain,
    };
