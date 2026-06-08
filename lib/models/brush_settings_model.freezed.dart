// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'brush_settings_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$BrushSettingsModel {
  double get size => throw _privateConstructorUsedError;
  double get hardness => throw _privateConstructorUsedError;
  double get opacity => throw _privateConstructorUsedError;
  double get flow => throw _privateConstructorUsedError;
  Color get color => throw _privateConstructorUsedError;
  double get spacing => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BrushSettingsModelCopyWith<BrushSettingsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BrushSettingsModelCopyWith<$Res> {
  factory $BrushSettingsModelCopyWith(
          BrushSettingsModel value, $Res Function(BrushSettingsModel) then) =
      _$BrushSettingsModelCopyWithImpl<$Res, BrushSettingsModel>;
  @useResult
  $Res call(
      {double size,
      double hardness,
      double opacity,
      double flow,
      Color color,
      double spacing});
}

/// @nodoc
class _$BrushSettingsModelCopyWithImpl<$Res, $Val extends BrushSettingsModel>
    implements $BrushSettingsModelCopyWith<$Res> {
  _$BrushSettingsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? size = null,
    Object? hardness = null,
    Object? opacity = null,
    Object? flow = null,
    Object? color = null,
    Object? spacing = null,
  }) {
    return _then(_value.copyWith(
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as double,
      hardness: null == hardness
          ? _value.hardness
          : hardness // ignore: cast_nullable_to_non_nullable
              as double,
      opacity: null == opacity
          ? _value.opacity
          : opacity // ignore: cast_nullable_to_non_nullable
              as double,
      flow: null == flow
          ? _value.flow
          : flow // ignore: cast_nullable_to_non_nullable
              as double,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as Color,
      spacing: null == spacing
          ? _value.spacing
          : spacing // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BrushSettingsModelImplCopyWith<$Res>
    implements $BrushSettingsModelCopyWith<$Res> {
  factory _$$BrushSettingsModelImplCopyWith(_$BrushSettingsModelImpl value,
          $Res Function(_$BrushSettingsModelImpl) then) =
      __$$BrushSettingsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double size,
      double hardness,
      double opacity,
      double flow,
      Color color,
      double spacing});
}

/// @nodoc
class __$$BrushSettingsModelImplCopyWithImpl<$Res>
    extends _$BrushSettingsModelCopyWithImpl<$Res, _$BrushSettingsModelImpl>
    implements _$$BrushSettingsModelImplCopyWith<$Res> {
  __$$BrushSettingsModelImplCopyWithImpl(_$BrushSettingsModelImpl _value,
      $Res Function(_$BrushSettingsModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? size = null,
    Object? hardness = null,
    Object? opacity = null,
    Object? flow = null,
    Object? color = null,
    Object? spacing = null,
  }) {
    return _then(_$BrushSettingsModelImpl(
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as double,
      hardness: null == hardness
          ? _value.hardness
          : hardness // ignore: cast_nullable_to_non_nullable
              as double,
      opacity: null == opacity
          ? _value.opacity
          : opacity // ignore: cast_nullable_to_non_nullable
              as double,
      flow: null == flow
          ? _value.flow
          : flow // ignore: cast_nullable_to_non_nullable
              as double,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as Color,
      spacing: null == spacing
          ? _value.spacing
          : spacing // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$BrushSettingsModelImpl implements _BrushSettingsModel {
  const _$BrushSettingsModelImpl(
      {this.size = 20.0,
      this.hardness = 0.5,
      this.opacity = 1.0,
      this.flow = 1.0,
      this.color = Colors.black,
      this.spacing = 0.1});

  @override
  @JsonKey()
  final double size;
  @override
  @JsonKey()
  final double hardness;
  @override
  @JsonKey()
  final double opacity;
  @override
  @JsonKey()
  final double flow;
  @override
  @JsonKey()
  final Color color;
  @override
  @JsonKey()
  final double spacing;

  @override
  String toString() {
    return 'BrushSettingsModel(size: $size, hardness: $hardness, opacity: $opacity, flow: $flow, color: $color, spacing: $spacing)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BrushSettingsModelImpl &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.hardness, hardness) ||
                other.hardness == hardness) &&
            (identical(other.opacity, opacity) || other.opacity == opacity) &&
            (identical(other.flow, flow) || other.flow == flow) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.spacing, spacing) || other.spacing == spacing));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, size, hardness, opacity, flow, color, spacing);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BrushSettingsModelImplCopyWith<_$BrushSettingsModelImpl> get copyWith =>
      __$$BrushSettingsModelImplCopyWithImpl<_$BrushSettingsModelImpl>(
          this, _$identity);
}

abstract class _BrushSettingsModel implements BrushSettingsModel {
  const factory _BrushSettingsModel(
      {final double size,
      final double hardness,
      final double opacity,
      final double flow,
      final Color color,
      final double spacing}) = _$BrushSettingsModelImpl;

  @override
  double get size;
  @override
  double get hardness;
  @override
  double get opacity;
  @override
  double get flow;
  @override
  Color get color;
  @override
  double get spacing;
  @override
  @JsonKey(ignore: true)
  _$$BrushSettingsModelImplCopyWith<_$BrushSettingsModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
