// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ClassModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ClassModelAdapter extends TypeAdapter<ClassModel> {
  @override
  final int typeId = 5;

  @override
  ClassModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ClassModel(
      id: fields[0] as String?,
      level: fields[1] as String?,
      type: fields[2] as String?,
      name: fields[3] as String?,
      size: fields[4] as String?,
      hasDisability: fields[5] as String?,
      department: fields[6] as String?,
      createdAt: fields[7] as String?,
      academicYear: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ClassModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.level)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.size)
      ..writeByte(5)
      ..write(obj.hasDisability)
      ..writeByte(6)
      ..write(obj.department)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.academicYear);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClassModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
