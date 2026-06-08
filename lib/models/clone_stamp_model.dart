import 'package:flutter/material.dart';

class CloneStampSettings {
  final Offset? sourcePoint;
  final bool isAligned;
  final double size;
  final double hardness;

  CloneStampSettings({
    this.sourcePoint,
    this.isAligned = true,
    this.size = 50,
    this.hardness = 0.5,
  });

  CloneStampSettings copyWith({
    Offset? sourcePoint,
    bool? isAligned,
    double? size,
    double? hardness,
  }) {
    return CloneStampSettings(
      sourcePoint: sourcePoint ?? this.sourcePoint,
      isAligned: isAligned ?? this.isAligned,
      size: size ?? this.size,
      hardness: hardness ?? this.hardness,
    );
  }
}
