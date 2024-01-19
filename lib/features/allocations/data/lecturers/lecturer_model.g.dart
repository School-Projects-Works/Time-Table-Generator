// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lecturer_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LecturerModelAdapter extends TypeAdapter<LecturerModel> {
  @override
  final int typeId = 2;

  @override
  LecturerModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LecturerModel(
      id: fields[0] as String?,
      name: fields[1] as String?,
      courses: (fields[2] as List?)?.cast<String>(),
      classes: (fields[3] as List?)?.cast<String>(),
      lecturerName: fields[4] as String?,
      lecturerEmail: fields[5] as String?,
      department: fields[6] as String?,
      academicYear: fields[8] as String?,
      academicSemester: fields[12] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, LecturerModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.courses)
      ..writeByte(3)
      ..write(obj.classes)
      ..writeByte(4)
      ..write(obj.lecturerName)
      ..writeByte(5)
      ..write(obj.lecturerEmail)
      ..writeByte(6)
      ..write(obj.department)
      ..writeByte(8)
      ..write(obj.academicYear)
      ..writeByte(12)
      ..write(obj.academicSemester);
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
