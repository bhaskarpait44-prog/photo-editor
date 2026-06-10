import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';

class ShaderService {
  static final ShaderService _instance = ShaderService._internal();
  factory ShaderService() => _instance;
  ShaderService._internal();

  final Map<String, ui.FragmentProgram> _programs = {};

  Future<void> init() async {
    await Future.wait([
      _loadShader('brightness_contrast', 'shaders/brightness_contrast.frag'),
      _loadShader('hsl_adjust', 'shaders/hsl_adjust.frag'),
      _loadShader('exposure_shadows_highlights', 'shaders/exposure_shadows_highlights.frag'),
      _loadShader('temperature_tint', 'shaders/temperature_tint.frag'),
      _loadShader('detail_effects', 'shaders/detail_effects.frag'),
    ]);
  }

  Future<void> _loadShader(String name, String path) async {
    try {
      final program = await ui.FragmentProgram.fromAsset(path);
      _programs[name] = program;
    } catch (e) {
      debugPrint('Error loading shader $name: $e');
    }
  }

  ui.Shader? getShader(String name, {required List<double> uniforms, required ui.Image image}) {
    final program = _programs[name];
    if (program == null) return null;

    final shader = program.fragmentShader();
    for (int i = 0; i < uniforms.length; i++) {
      shader.setFloat(i, uniforms[i]);
    }
    shader.setImageSampler(0, image);
    return shader;
  }
}
