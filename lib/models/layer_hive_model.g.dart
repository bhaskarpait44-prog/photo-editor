// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'layer_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LayerHiveModelAdapter extends TypeAdapter<LayerHiveModel> {
  @override
  final int typeId = 1;

  @override
  LayerHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LayerHiveModel(
      id: fields[0] as String,
      name: fields[1] as String,
      typeIndex: fields[2] as int,
      imagePath: fields[3] as String?,
      opacity: fields[4] as double,
      isVisible: fields[5] as bool,
      isLocked: fields[6] as bool,
      blendModeIndex: fields[7] as int,
      projectId: fields[8] as String,
      isFlippedH: fields[9] as bool,
      isFlippedV: fields[10] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, LayerHiveModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.typeIndex)
      ..writeByte(3)
      ..write(obj.imagePath)
      ..writeByte(4)
      ..write(obj.opacity)
      ..writeByte(5)
      ..write(obj.isVisible)
      ..writeByte(6)
      ..write(obj.isLocked)
      ..writeByte(7)
      ..write(obj.blendModeIndex)
      ..writeByte(8)
      ..write(obj.projectId)
      ..writeByte(9)
      ..write(obj.isFlippedH)
      ..writeByte(10)
      ..write(obj.isFlippedV);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LayerHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
