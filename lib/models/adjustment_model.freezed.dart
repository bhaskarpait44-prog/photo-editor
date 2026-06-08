// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'adjustment_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AdjustmentModel _$AdjustmentModelFromJson(Map<String, dynamic> json) {
  return _AdjustmentModel.fromJson(json);
}

/// @nodoc
mixin _$AdjustmentModel {
  double get brightness => throw _privateConstructorUsedError; // -100 to 100
  double get contrast => throw _privateConstructorUsedError; // -100 to 100
  double get exposure => throw _privateConstructorUsedError; // -3 to 3 EV
  double get highlights => throw _privateConstructorUsedError; // -100 to 100
  double get shadows => throw _privateConstructorUsedError; // -100 to 100
  double get whites => throw _privateConstructorUsedError; // -100 to 100
  double get blacks => throw _privateConstructorUsedError; // -100 to 100
  double get saturation => throw _privateConstructorUsedError; // -100 to 100
  double get vibrance => throw _privateConstructorUsedError; // -100 to 100
  double get hue => throw _privateConstructorUsedError; // -180 to 180
  double get temperature => throw _privateConstructorUsedError; // -100 to 100
  double get tint => throw _privateConstructorUsedError; // -100 to 100
  double get sharpness => throw _privateConstructorUsedError; // 0 to 100
  double get clarity => throw _privateConstructorUsedError; // -100 to 100
  double get dehaze => throw _privateConstructorUsedError; // -100 to 100
  double get vignette => throw _privateConstructorUsedError; // -100 to 100
  double get grain => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AdjustmentModelCopyWith<AdjustmentModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AdjustmentModelCopyWith<$Res> {
  factory $AdjustmentModelCopyWith(
          AdjustmentModel value, $Res Function(AdjustmentModel) then) =
      _$AdjustmentModelCopyWithImpl<$Res, AdjustmentModel>;
  @useResult
  $Res call(
      {double brightness,
      double contrast,
      double exposure,
      double highlights,
      double shadows,
      double whites,
      double blacks,
      double saturation,
      double vibrance,
      double hue,
      double temperature,
      double tint,
      double sharpness,
      double clarity,
      double dehaze,
      double vignette,
      double grain});
}

/// @nodoc
class _$AdjustmentModelCopyWithImpl<$Res, $Val extends AdjustmentModel>
    implements $AdjustmentModelCopyWith<$Res> {
  _$AdjustmentModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? brightness = null,
    Object? contrast = null,
    Object? exposure = null,
    Object? highlights = null,
    Object? shadows = null,
    Object? whites = null,
    Object? blacks = null,
    Object? saturation = null,
    Object? vibrance = null,
    Object? hue = null,
    Object? temperature = null,
    Object? tint = null,
    Object? sharpness = null,
    Object? clarity = null,
    Object? dehaze = null,
    Object? vignette = null,
    Object? grain = null,
  }) {
    return _then(_value.copyWith(
      brightness: null == brightness
          ? _value.brightness
          : brightness // ignore: cast_nullable_to_non_nullable
              as double,
      contrast: null == contrast
          ? _value.contrast
          : contrast // ignore: cast_nullable_to_non_nullable
              as double,
      exposure: null == exposure
          ? _value.exposure
          : exposure // ignore: cast_nullable_to_non_nullable
              as double,
      highlights: null == highlights
          ? _value.highlights
          : highlights // ignore: cast_nullable_to_non_nullable
              as double,
      shadows: null == shadows
          ? _value.shadows
          : shadows // ignore: cast_nullable_to_non_nullable
              as double,
      whites: null == whites
          ? _value.whites
          : whites // ignore: cast_nullable_to_non_nullable
              as double,
      blacks: null == blacks
          ? _value.blacks
          : blacks // ignore: cast_nullable_to_non_nullable
              as double,
      saturation: null == saturation
          ? _value.saturation
          : saturation // ignore: cast_nullable_to_non_nullable
              as double,
      vibrance: null == vibrance
          ? _value.vibrance
          : vibrance // ignore: cast_nullable_to_non_nullable
              as double,
      hue: null == hue
          ? _value.hue
          : hue // ignore: cast_nullable_to_non_nullable
              as double,
      temperature: null == temperature
          ? _value.temperature
          : temperature // ignore: cast_nullable_to_non_nullable
              as double,
      tint: null == tint
          ? _value.tint
          : tint // ignore: cast_nullable_to_non_nullable
              as double,
      sharpness: null == sharpness
          ? _value.sharpness
          : sharpness // ignore: cast_nullable_to_non_nullable
              as double,
      clarity: null == clarity
          ? _value.clarity
          : clarity // ignore: cast_nullable_to_non_nullable
              as double,
      dehaze: null == dehaze
          ? _value.dehaze
          : dehaze // ignore: cast_nullable_to_non_nullable
              as double,
      vignette: null == vignette
          ? _value.vignette
          : vignette // ignore: cast_nullable_to_non_nullable
              as double,
      grain: null == grain
          ? _value.grain
          : grain // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AdjustmentModelImplCopyWith<$Res>
    implements $AdjustmentModelCopyWith<$Res> {
  factory _$$AdjustmentModelImplCopyWith(_$AdjustmentModelImpl value,
          $Res Function(_$AdjustmentModelImpl) then) =
      __$$AdjustmentModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double brightness,
      double contrast,
      double exposure,
      double highlights,
      double shadows,
      double whites,
      double blacks,
      double saturation,
      double vibrance,
      double hue,
      double temperature,
      double tint,
      double sharpness,
      double clarity,
      double dehaze,
      double vignette,
      double grain});
}

/// @nodoc
class __$$AdjustmentModelImplCopyWithImpl<$Res>
    extends _$AdjustmentModelCopyWithImpl<$Res, _$AdjustmentModelImpl>
    implements _$$AdjustmentModelImplCopyWith<$Res> {
  __$$AdjustmentModelImplCopyWithImpl(
      _$AdjustmentModelImpl _value, $Res Function(_$AdjustmentModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? brightness = null,
    Object? contrast = null,
    Object? exposure = null,
    Object? highlights = null,
    Object? shadows = null,
    Object? whites = null,
    Object? blacks = null,
    Object? saturation = null,
    Object? vibrance = null,
    Object? hue = null,
    Object? temperature = null,
    Object? tint = null,
    Object? sharpness = null,
    Object? clarity = null,
    Object? dehaze = null,
    Object? vignette = null,
    Object? grain = null,
  }) {
    return _then(_$AdjustmentModelImpl(
      brightness: null == brightness
          ? _value.brightness
          : brightness // ignore: cast_nullable_to_non_nullable
              as double,
      contrast: null == contrast
          ? _value.contrast
          : contrast // ignore: cast_nullable_to_non_nullable
              as double,
      exposure: null == exposure
          ? _value.exposure
          : exposure // ignore: cast_nullable_to_non_nullable
              as double,
      highlights: null == highlights
          ? _value.highlights
          : highlights // ignore: cast_nullable_to_non_nullable
              as double,
      shadows: null == shadows
          ? _value.shadows
          : shadows // ignore: cast_nullable_to_non_nullable
              as double,
      whites: null == whites
          ? _value.whites
          : whites // ignore: cast_nullable_to_non_nullable
              as double,
      blacks: null == blacks
          ? _value.blacks
          : blacks // ignore: cast_nullable_to_non_nullable
              as double,
      saturation: null == saturation
          ? _value.saturation
          : saturation // ignore: cast_nullable_to_non_nullable
              as double,
      vibrance: null == vibrance
          ? _value.vibrance
          : vibrance // ignore: cast_nullable_to_non_nullable
              as double,
      hue: null == hue
          ? _value.hue
          : hue // ignore: cast_nullable_to_non_nullable
              as double,
      temperature: null == temperature
          ? _value.temperature
          : temperature // ignore: cast_nullable_to_non_nullable
              as double,
      tint: null == tint
          ? _value.tint
          : tint // ignore: cast_nullable_to_non_nullable
              as double,
      sharpness: null == sharpness
          ? _value.sharpness
          : sharpness // ignore: cast_nullable_to_non_nullable
              as double,
      clarity: null == clarity
          ? _value.clarity
          : clarity // ignore: cast_nullable_to_non_nullable
              as double,
      dehaze: null == dehaze
          ? _value.dehaze
          : dehaze // ignore: cast_nullable_to_non_nullable
              as double,
      vignette: null == vignette
          ? _value.vignette
          : vignette // ignore: cast_nullable_to_non_nullable
              as double,
      grain: null == grain
          ? _value.grain
          : grain // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AdjustmentModelImpl implements _AdjustmentModel {
  const _$AdjustmentModelImpl(
      {this.brightness = 0.0,
      this.contrast = 0.0,
      this.exposure = 0.0,
      this.highlights = 0.0,
      this.shadows = 0.0,
      this.whites = 0.0,
      this.blacks = 0.0,
      this.saturation = 0.0,
      this.vibrance = 0.0,
      this.hue = 0.0,
      this.temperature = 0.0,
      this.tint = 0.0,
      this.sharpness = 0.0,
      this.clarity = 0.0,
      this.dehaze = 0.0,
      this.vignette = 0.0,
      this.grain = 0.0});

  factory _$AdjustmentModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AdjustmentModelImplFromJson(json);

  @override
  @JsonKey()
  final double brightness;
// -100 to 100
  @override
  @JsonKey()
  final double contrast;
// -100 to 100
  @override
  @JsonKey()
  final double exposure;
// -3 to 3 EV
  @override
  @JsonKey()
  final double highlights;
// -100 to 100
  @override
  @JsonKey()
  final double shadows;
// -100 to 100
  @override
  @JsonKey()
  final double whites;
// -100 to 100
  @override
  @JsonKey()
  final double blacks;
// -100 to 100
  @override
  @JsonKey()
  final double saturation;
// -100 to 100
  @override
  @JsonKey()
  final double vibrance;
// -100 to 100
  @override
  @JsonKey()
  final double hue;
// -180 to 180
  @override
  @JsonKey()
  final double temperature;
// -100 to 100
  @override
  @JsonKey()
  final double tint;
// -100 to 100
  @override
  @JsonKey()
  final double sharpness;
// 0 to 100
  @override
  @JsonKey()
  final double clarity;
// -100 to 100
  @override
  @JsonKey()
  final double dehaze;
// -100 to 100
  @override
  @JsonKey()
  final double vignette;
// -100 to 100
  @override
  @JsonKey()
  final double grain;

  @override
  String toString() {
    return 'AdjustmentModel(brightness: $brightness, contrast: $contrast, exposure: $exposure, highlights: $highlights, shadows: $shadows, whites: $whites, blacks: $blacks, saturation: $saturation, vibrance: $vibrance, hue: $hue, temperature: $temperature, tint: $tint, sharpness: $sharpness, clarity: $clarity, dehaze: $dehaze, vignette: $vignette, grain: $grain)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdjustmentModelImpl &&
            (identical(other.brightness, brightness) ||
                other.brightness == brightness) &&
            (identical(other.contrast, contrast) ||
                other.contrast == contrast) &&
            (identical(other.exposure, exposure) ||
                other.exposure == exposure) &&
            (identical(other.highlights, highlights) ||
                other.highlights == highlights) &&
            (identical(other.shadows, shadows) || other.shadows == shadows) &&
            (identical(other.whites, whites) || other.whites == whites) &&
            (identical(other.blacks, blacks) || other.blacks == blacks) &&
            (identical(other.saturation, saturation) ||
                other.saturation == saturation) &&
            (identical(other.vibrance, vibrance) ||
                other.vibrance == vibrance) &&
            (identical(other.hue, hue) || other.hue == hue) &&
            (identical(other.temperature, temperature) ||
                other.temperature == temperature) &&
            (identical(other.tint, tint) || other.tint == tint) &&
            (identical(other.sharpness, sharpness) ||
                other.sharpness == sharpness) &&
            (identical(other.clarity, clarity) || other.clarity == clarity) &&
            (identical(other.dehaze, dehaze) || other.dehaze == dehaze) &&
            (identical(other.vignette, vignette) ||
                other.vignette == vignette) &&
            (identical(other.grain, grain) || other.grain == grain));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      brightness,
      contrast,
      exposure,
      highlights,
      shadows,
      whites,
      blacks,
      saturation,
      vibrance,
      hue,
      temperature,
      tint,
      sharpness,
      clarity,
      dehaze,
      vignette,
      grain);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AdjustmentModelImplCopyWith<_$AdjustmentModelImpl> get copyWith =>
      __$$AdjustmentModelImplCopyWithImpl<_$AdjustmentModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AdjustmentModelImplToJson(
      this,
    );
  }
}

abstract class _AdjustmentModel implements AdjustmentModel {
  const factory _AdjustmentModel(
      {final double brightness,
      final double contrast,
      final double exposure,
      final double highlights,
      final double shadows,
      final double whites,
      final double blacks,
      final double saturation,
      final double vibrance,
      final double hue,
      final double temperature,
      final double tint,
      final double sharpness,
      final double clarity,
      final double dehaze,
      final double vignette,
      final double grain}) = _$AdjustmentModelImpl;

  factory _AdjustmentModel.fromJson(Map<String, dynamic> json) =
      _$AdjustmentModelImpl.fromJson;

  @override
  double get brightness;
  @override // -100 to 100
  double get contrast;
  @override // -100 to 100
  double get exposure;
  @override // -3 to 3 EV
  double get highlights;
  @override // -100 to 100
  double get shadows;
  @override // -100 to 100
  double get whites;
  @override // -100 to 100
  double get blacks;
  @override // -100 to 100
  double get saturation;
  @override // -100 to 100
  double get vibrance;
  @override // -100 to 100
  double get hue;
  @override // -180 to 180
  double get temperature;
  @override // -100 to 100
  double get tint;
  @override // -100 to 100
  double get sharpness;
  @override // 0 to 100
  double get clarity;
  @override // -100 to 100
  double get dehaze;
  @override // -100 to 100
  double get vignette;
  @override // -100 to 100
  double get grain;
  @override
  @JsonKey(ignore: true)
  _$$AdjustmentModelImplCopyWith<_$AdjustmentModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
