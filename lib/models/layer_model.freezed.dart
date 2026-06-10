// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'layer_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$LayerModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  LayerType get type => throw _privateConstructorUsedError;
  String? get imagePath => throw _privateConstructorUsedError;
  String? get maskPath => throw _privateConstructorUsedError;
  double get opacity => throw _privateConstructorUsedError;
  bool get isVisible => throw _privateConstructorUsedError;
  bool get isLocked => throw _privateConstructorUsedError;
  BlendMode get blendMode => throw _privateConstructorUsedError;
  double get offsetX => throw _privateConstructorUsedError;
  double get offsetY => throw _privateConstructorUsedError;
  double get scale => throw _privateConstructorUsedError;
  double get rotation => throw _privateConstructorUsedError;
  bool get isFlippedH => throw _privateConstructorUsedError;
  bool get isFlippedV => throw _privateConstructorUsedError;
  TextSettingsModel? get textSettings => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $LayerModelCopyWith<LayerModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LayerModelCopyWith<$Res> {
  factory $LayerModelCopyWith(
          LayerModel value, $Res Function(LayerModel) then) =
      _$LayerModelCopyWithImpl<$Res, LayerModel>;
  @useResult
  $Res call(
      {String id,
      String name,
      LayerType type,
      String? imagePath,
      String? maskPath,
      double opacity,
      bool isVisible,
      bool isLocked,
      BlendMode blendMode,
      double offsetX,
      double offsetY,
      double scale,
      double rotation,
      bool isFlippedH,
      bool isFlippedV,
      TextSettingsModel? textSettings});

  $TextSettingsModelCopyWith<$Res>? get textSettings;
}

/// @nodoc
class _$LayerModelCopyWithImpl<$Res, $Val extends LayerModel>
    implements $LayerModelCopyWith<$Res> {
  _$LayerModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? imagePath = freezed,
    Object? maskPath = freezed,
    Object? opacity = null,
    Object? isVisible = null,
    Object? isLocked = null,
    Object? blendMode = null,
    Object? offsetX = null,
    Object? offsetY = null,
    Object? scale = null,
    Object? rotation = null,
    Object? isFlippedH = null,
    Object? isFlippedV = null,
    Object? textSettings = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as LayerType,
      imagePath: freezed == imagePath
          ? _value.imagePath
          : imagePath // ignore: cast_nullable_to_non_nullable
              as String?,
      maskPath: freezed == maskPath
          ? _value.maskPath
          : maskPath // ignore: cast_nullable_to_non_nullable
              as String?,
      opacity: null == opacity
          ? _value.opacity
          : opacity // ignore: cast_nullable_to_non_nullable
              as double,
      isVisible: null == isVisible
          ? _value.isVisible
          : isVisible // ignore: cast_nullable_to_non_nullable
              as bool,
      isLocked: null == isLocked
          ? _value.isLocked
          : isLocked // ignore: cast_nullable_to_non_nullable
              as bool,
      blendMode: null == blendMode
          ? _value.blendMode
          : blendMode // ignore: cast_nullable_to_non_nullable
              as BlendMode,
      offsetX: null == offsetX
          ? _value.offsetX
          : offsetX // ignore: cast_nullable_to_non_nullable
              as double,
      offsetY: null == offsetY
          ? _value.offsetY
          : offsetY // ignore: cast_nullable_to_non_nullable
              as double,
      scale: null == scale
          ? _value.scale
          : scale // ignore: cast_nullable_to_non_nullable
              as double,
      rotation: null == rotation
          ? _value.rotation
          : rotation // ignore: cast_nullable_to_non_nullable
              as double,
      isFlippedH: null == isFlippedH
          ? _value.isFlippedH
          : isFlippedH // ignore: cast_nullable_to_non_nullable
              as bool,
      isFlippedV: null == isFlippedV
          ? _value.isFlippedV
          : isFlippedV // ignore: cast_nullable_to_non_nullable
              as bool,
      textSettings: freezed == textSettings
          ? _value.textSettings
          : textSettings // ignore: cast_nullable_to_non_nullable
              as TextSettingsModel?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $TextSettingsModelCopyWith<$Res>? get textSettings {
    if (_value.textSettings == null) {
      return null;
    }

    return $TextSettingsModelCopyWith<$Res>(_value.textSettings!, (value) {
      return _then(_value.copyWith(textSettings: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$LayerModelImplCopyWith<$Res>
    implements $LayerModelCopyWith<$Res> {
  factory _$$LayerModelImplCopyWith(
          _$LayerModelImpl value, $Res Function(_$LayerModelImpl) then) =
      __$$LayerModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      LayerType type,
      String? imagePath,
      String? maskPath,
      double opacity,
      bool isVisible,
      bool isLocked,
      BlendMode blendMode,
      double offsetX,
      double offsetY,
      double scale,
      double rotation,
      bool isFlippedH,
      bool isFlippedV,
      TextSettingsModel? textSettings});

  @override
  $TextSettingsModelCopyWith<$Res>? get textSettings;
}

/// @nodoc
class __$$LayerModelImplCopyWithImpl<$Res>
    extends _$LayerModelCopyWithImpl<$Res, _$LayerModelImpl>
    implements _$$LayerModelImplCopyWith<$Res> {
  __$$LayerModelImplCopyWithImpl(
      _$LayerModelImpl _value, $Res Function(_$LayerModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? imagePath = freezed,
    Object? maskPath = freezed,
    Object? opacity = null,
    Object? isVisible = null,
    Object? isLocked = null,
    Object? blendMode = null,
    Object? offsetX = null,
    Object? offsetY = null,
    Object? scale = null,
    Object? rotation = null,
    Object? isFlippedH = null,
    Object? isFlippedV = null,
    Object? textSettings = freezed,
  }) {
    return _then(_$LayerModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as LayerType,
      imagePath: freezed == imagePath
          ? _value.imagePath
          : imagePath // ignore: cast_nullable_to_non_nullable
              as String?,
      maskPath: freezed == maskPath
          ? _value.maskPath
          : maskPath // ignore: cast_nullable_to_non_nullable
              as String?,
      opacity: null == opacity
          ? _value.opacity
          : opacity // ignore: cast_nullable_to_non_nullable
              as double,
      isVisible: null == isVisible
          ? _value.isVisible
          : isVisible // ignore: cast_nullable_to_non_nullable
              as bool,
      isLocked: null == isLocked
          ? _value.isLocked
          : isLocked // ignore: cast_nullable_to_non_nullable
              as bool,
      blendMode: null == blendMode
          ? _value.blendMode
          : blendMode // ignore: cast_nullable_to_non_nullable
              as BlendMode,
      offsetX: null == offsetX
          ? _value.offsetX
          : offsetX // ignore: cast_nullable_to_non_nullable
              as double,
      offsetY: null == offsetY
          ? _value.offsetY
          : offsetY // ignore: cast_nullable_to_non_nullable
              as double,
      scale: null == scale
          ? _value.scale
          : scale // ignore: cast_nullable_to_non_nullable
              as double,
      rotation: null == rotation
          ? _value.rotation
          : rotation // ignore: cast_nullable_to_non_nullable
              as double,
      isFlippedH: null == isFlippedH
          ? _value.isFlippedH
          : isFlippedH // ignore: cast_nullable_to_non_nullable
              as bool,
      isFlippedV: null == isFlippedV
          ? _value.isFlippedV
          : isFlippedV // ignore: cast_nullable_to_non_nullable
              as bool,
      textSettings: freezed == textSettings
          ? _value.textSettings
          : textSettings // ignore: cast_nullable_to_non_nullable
              as TextSettingsModel?,
    ));
  }
}

/// @nodoc

class _$LayerModelImpl implements _LayerModel {
  const _$LayerModelImpl(
      {required this.id,
      required this.name,
      required this.type,
      this.imagePath,
      this.maskPath,
      this.opacity = 100.0,
      this.isVisible = true,
      this.isLocked = false,
      this.blendMode = BlendMode.srcOver,
      this.offsetX = 0.0,
      this.offsetY = 0.0,
      this.scale = 1.0,
      this.rotation = 0.0,
      this.isFlippedH = false,
      this.isFlippedV = false,
      this.textSettings});

  @override
  final String id;
  @override
  final String name;
  @override
  final LayerType type;
  @override
  final String? imagePath;
  @override
  final String? maskPath;
  @override
  @JsonKey()
  final double opacity;
  @override
  @JsonKey()
  final bool isVisible;
  @override
  @JsonKey()
  final bool isLocked;
  @override
  @JsonKey()
  final BlendMode blendMode;
  @override
  @JsonKey()
  final double offsetX;
  @override
  @JsonKey()
  final double offsetY;
  @override
  @JsonKey()
  final double scale;
  @override
  @JsonKey()
  final double rotation;
  @override
  @JsonKey()
  final bool isFlippedH;
  @override
  @JsonKey()
  final bool isFlippedV;
  @override
  final TextSettingsModel? textSettings;

  @override
  String toString() {
    return 'LayerModel(id: $id, name: $name, type: $type, imagePath: $imagePath, maskPath: $maskPath, opacity: $opacity, isVisible: $isVisible, isLocked: $isLocked, blendMode: $blendMode, offsetX: $offsetX, offsetY: $offsetY, scale: $scale, rotation: $rotation, isFlippedH: $isFlippedH, isFlippedV: $isFlippedV, textSettings: $textSettings)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LayerModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.imagePath, imagePath) ||
                other.imagePath == imagePath) &&
            (identical(other.maskPath, maskPath) ||
                other.maskPath == maskPath) &&
            (identical(other.opacity, opacity) || other.opacity == opacity) &&
            (identical(other.isVisible, isVisible) ||
                other.isVisible == isVisible) &&
            (identical(other.isLocked, isLocked) ||
                other.isLocked == isLocked) &&
            (identical(other.blendMode, blendMode) ||
                other.blendMode == blendMode) &&
            (identical(other.offsetX, offsetX) || other.offsetX == offsetX) &&
            (identical(other.offsetY, offsetY) || other.offsetY == offsetY) &&
            (identical(other.scale, scale) || other.scale == scale) &&
            (identical(other.rotation, rotation) ||
                other.rotation == rotation) &&
            (identical(other.isFlippedH, isFlippedH) ||
                other.isFlippedH == isFlippedH) &&
            (identical(other.isFlippedV, isFlippedV) ||
                other.isFlippedV == isFlippedV) &&
            (identical(other.textSettings, textSettings) ||
                other.textSettings == textSettings));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      type,
      imagePath,
      maskPath,
      opacity,
      isVisible,
      isLocked,
      blendMode,
      offsetX,
      offsetY,
      scale,
      rotation,
      isFlippedH,
      isFlippedV,
      textSettings);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LayerModelImplCopyWith<_$LayerModelImpl> get copyWith =>
      __$$LayerModelImplCopyWithImpl<_$LayerModelImpl>(this, _$identity);
}

abstract class _LayerModel implements LayerModel {
  const factory _LayerModel(
      {required final String id,
      required final String name,
      required final LayerType type,
      final String? imagePath,
      final String? maskPath,
      final double opacity,
      final bool isVisible,
      final bool isLocked,
      final BlendMode blendMode,
      final double offsetX,
      final double offsetY,
      final double scale,
      final double rotation,
      final bool isFlippedH,
      final bool isFlippedV,
      final TextSettingsModel? textSettings}) = _$LayerModelImpl;

  @override
  String get id;
  @override
  String get name;
  @override
  LayerType get type;
  @override
  String? get imagePath;
  @override
  String? get maskPath;
  @override
  double get opacity;
  @override
  bool get isVisible;
  @override
  bool get isLocked;
  @override
  BlendMode get blendMode;
  @override
  double get offsetX;
  @override
  double get offsetY;
  @override
  double get scale;
  @override
  double get rotation;
  @override
  bool get isFlippedH;
  @override
  bool get isFlippedV;
  @override
  TextSettingsModel? get textSettings;
  @override
  @JsonKey(ignore: true)
  _$$LayerModelImplCopyWith<_$LayerModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
