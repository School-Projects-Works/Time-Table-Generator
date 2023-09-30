// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lecturer_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LecturersModelAdapter extends TypeAdapter<LecturersModel> {
  @override
  final int typeId = 13;

  @override
  LecturersModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LecturersModel(
      name: fields[0] as String?,
      department: fields[1] as String?,
      id: fields[2] as String?,
      courseCode: fields[3] as String?,
      academicYear: fields[4] as String?,
      academicSemester: fields[5] as String?,
      classes: (fields[6] as List).cast<String>(),
      level: fields[7] as String?,
      targetStudents: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, LecturersModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.department)
      ..writeByte(2)
      ..write(obj.id)
      ..writeByte(3)
      ..write(obj.courseCode)
      ..writeByte(4)
      ..write(obj.academicYear)
      ..writeByte(5)
      ..write(obj.academicSemester)
      ..writeByte(6)
      ..write(obj.classes)
      ..writeByte(7)
      ..write(obj.level)
      ..writeByte(8)
      ..write(obj.targetStudents);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LecturersModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
