import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/brush_settings_model.dart';

final brushSettingsProvider = StateProvider<BrushSettingsModel>((ref) {
  return const BrushSettingsModel();
});

final isEraserModeProvider = StateProvider<bool>((ref) => false);
