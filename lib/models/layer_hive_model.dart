import 'package:hive/hive.dart';
import 'layer_model.dart';
import 'package:flutter/material.dart';

part 'layer_hive_model.g.dart';

@HiveType(typeId: 1)
class LayerHiveModel extends HiveObject {
  @HiveField(0) String id;
  @HiveField(1) String name;
  @HiveField(2) int typeIndex;
  @HiveField(3) String? imagePath;
  @HiveField(4) double opacity;
  @HiveField(5) bool isVisible;
  @HiveField(6) bool isLocked;
  @HiveField(7) int blendModeIndex;
  @HiveField(8) String projectId;
  @HiveField(9) bool isFlippedH;
  @HiveField(10) bool isFlippedV;

  LayerHiveModel({
    required this.id,
    required this.name,
    required this.typeIndex,
    this.imagePath,
    required this.opacity,
    required this.isVisible,
    required this.isLocked,
    required this.blendModeIndex,
    required this.projectId,
    this.isFlippedH = false,
    this.isFlippedV = false,
  });

  factory LayerHiveModel.fromLayerModel(LayerModel layer, String projectId) {
    return LayerHiveModel(
      id: layer.id,
      name: layer.name,
      typeIndex: layer.type.index,
      imagePath: layer.imagePath,
      opacity: layer.opacity,
      isVisible: layer.isVisible,
      isLocked: layer.isLocked,
      blendModeIndex: layer.blendMode.index,
      projectId: projectId,
      isFlippedH: layer.isFlippedH,
      isFlippedV: layer.isFlippedV,
    );
  }

  LayerModel toLayerModel() {
    return LayerModel(
      id: id,
      name: name,
      type: LayerType.values[typeIndex],
      imagePath: imagePath,
      opacity: opacity,
      isVisible: isVisible,
      isLocked: isLocked,
      blendMode: BlendMode.values[blendModeIndex],
      isFlippedH: isFlippedH,
      isFlippedV: isFlippedV,
    );
  }
}
