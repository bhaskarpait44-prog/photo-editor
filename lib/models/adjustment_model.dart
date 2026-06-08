import 'package:freezed_annotation/freezed_annotation.dart';

part 'adjustment_model.freezed.dart';
part 'adjustment_model.g.dart';

@freezed
class AdjustmentModel with _$AdjustmentModel {
  const factory AdjustmentModel({
    @Default(0.0) double brightness, // -100 to 100
    @Default(0.0) double contrast,   // -100 to 100
    @Default(0.0) double exposure,   // -3 to 3 EV
    @Default(0.0) double highlights, // -100 to 100
    @Default(0.0) double shadows,    // -100 to 100
    @Default(0.0) double whites,     // -100 to 100
    @Default(0.0) double blacks,     // -100 to 100
    @Default(0.0) double saturation, // -100 to 100
    @Default(0.0) double vibrance,   // -100 to 100
    @Default(0.0) double hue,        // -180 to 180
    @Default(0.0) double temperature,// -100 to 100
    @Default(0.0) double tint,       // -100 to 100
    @Default(0.0) double sharpness,  // 0 to 100
    @Default(0.0) double clarity,    // -100 to 100
    @Default(0.0) double dehaze,     // -100 to 100
    @Default(0.0) double vignette,   // -100 to 100
    @Default(0.0) double grain,      // 0 to 100
  }) = _AdjustmentModel;

  factory AdjustmentModel.fromJson(Map<String, dynamic> json) =>
      _$AdjustmentModelFromJson(json);
}
