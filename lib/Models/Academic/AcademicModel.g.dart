// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AcademicModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AcademicModelAdapter extends TypeAdapter<AcademicModel> {
  @override
  final int typeId = 1;

  @override
  AcademicModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AcademicModel(
      id: fields[0] as String?,
      name: fields[1] as String?,
      semester: fields[3] as String?,
      year: fields[2] as String?,
      createdAt: fields[4] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, AcademicModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.year)
      ..writeByte(3)
      ..write(obj.semester)
      ..writeByte(4)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AcademicModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
