import '../../../models/adjustment_model.dart';

class FilterPresets {
  static const AdjustmentModel original = AdjustmentModel();

  static const AdjustmentModel vivid = AdjustmentModel(
    brightness: 5,
    contrast: 15,
    saturation: 25,
    vibrance: 15,
  );

  static const AdjustmentModel matte = AdjustmentModel(
    contrast: -20,
    blacks: 30,
    whites: -10,
    saturation: -10,
  );

  static const AdjustmentModel cinematic = AdjustmentModel(
    exposure: 0.2,
    contrast: 10,
    saturation: -15,
    temperature: 10,
    tint: -5,
  );

  static final Map<String, AdjustmentModel> all = {
    'Original': original,
    'Vivid': vivid,
    'Matte': matte,
    'Cinematic': cinematic,
    // Add more presets here...
  };
}
