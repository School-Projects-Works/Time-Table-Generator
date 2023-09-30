// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'classes_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ClassesModelAdapter extends TypeAdapter<ClassesModel> {
  @override
  final int typeId = 11;

  @override
  ClassesModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ClassesModel(
      id: fields[0] as String?,
      level: fields[1] as String?,
      targetStudents: fields[2] as String?,
      code: fields[3] as String?,
      size: fields[4] as String?,
      hasDisabled: fields[5] as String?,
      department: fields[6] as String?,
      academicYear: fields[7] as String?,
      academicSemester: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ClassesModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.level)
      ..writeByte(2)
      ..write(obj.targetStudents)
      ..writeByte(3)
      ..write(obj.code)
      ..writeByte(4)
      ..write(obj.size)
      ..writeByte(5)
      ..write(obj.hasDisabled)
      ..writeByte(6)
      ..write(obj.department)
      ..writeByte(7)
      ..write(obj.academicYear)
      ..writeByte(8)
      ..write(obj.academicSemester);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClassesModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
