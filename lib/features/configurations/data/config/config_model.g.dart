// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ConfigModelAdapter extends TypeAdapter<ConfigModel> {
  @override
  final int typeId = 1;

  @override
  ConfigModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ConfigModel(
      id: fields[0] as String?,
      year: fields[1] as String?,
      semester: fields[2] as String?,
      regular: (fields[3] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, ConfigModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.year)
      ..writeByte(2)
      ..write(obj.semester)
      ..writeByte(3)
      ..write(obj.regular);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConfigModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
