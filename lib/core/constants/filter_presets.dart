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
    'Original':  const AdjustmentModel(),
    'Vivid':     const AdjustmentModel(brightness: 5, contrast: 15, saturation: 25, vibrance: 15),
    'Matte':     const AdjustmentModel(contrast: -20, blacks: 30, whites: -10, saturation: -10),
    'Cinematic': const AdjustmentModel(exposure: 0.2, contrast: 10, saturation: -15, temperature: 10, tint: -5),
    'Warm':      const AdjustmentModel(temperature: 35, tint: 5, saturation: 10),
    'Cool':      const AdjustmentModel(temperature: -30, tint: -5, saturation: 5),
    'Fade':      const AdjustmentModel(contrast: -25, blacks: 20, saturation: -20, brightness: 8),
    'Golden':    const AdjustmentModel(temperature: 40, highlights: -10, saturation: 15, brightness: 5),
    'Moody':     const AdjustmentModel(contrast: 20, shadows: -20, saturation: -10, vignette: -30),
    'Pastel':    const AdjustmentModel(brightness: 15, saturation: -30, contrast: -10, whites: 15),
    'Velvet':    const AdjustmentModel(contrast: 15, saturation: 20, blacks: -10, clarity: 20),
    'B&W':       const AdjustmentModel(saturation: -100),
    'B&W Hi':    const AdjustmentModel(saturation: -100, contrast: 35, clarity: 40),
    'Film':      const AdjustmentModel(grain: 40, contrast: 10, saturation: -15, temperature: 8),
    'Lomo':      const AdjustmentModel(contrast: 25, saturation: 30, vignette: -50, clarity: 15),
    'Vintage':   const AdjustmentModel(temperature: 20, saturation: -20, contrast: -10, grain: 25, blacks: 15),
  };
}
