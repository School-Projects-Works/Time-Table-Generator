// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lecturer_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LecturerModelAdapter extends TypeAdapter<LecturerModel> {
  @override
  final int typeId = 3;

  @override
  LecturerModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LecturerModel(
      id: fields[0] as String?,
      courses: (fields[1] as List?)?.cast<String>(),
      classes: (fields[2] as List?)?.cast<String>(),
      lecturerName: fields[3] as String?,
      lecturerEmail: fields[4] as String?,
      department: fields[5] as String?,
      academicYear: fields[6] as String?,
      academicSemester: fields[7] as String?,
      targetedStudents: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, LecturerModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.courses)
      ..writeByte(2)
      ..write(obj.classes)
      ..writeByte(3)
      ..write(obj.lecturerName)
      ..writeByte(4)
      ..write(obj.lecturerEmail)
      ..writeByte(5)
      ..write(obj.department)
      ..writeByte(6)
      ..write(obj.academicYear)
      ..writeByte(7)
      ..write(obj.academicSemester)
      ..writeByte(8)
      ..write(obj.targetedStudents);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LecturerModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
