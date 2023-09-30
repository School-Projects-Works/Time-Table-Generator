// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'courses_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CoursesModelAdapter extends TypeAdapter<CoursesModel> {
  @override
  final int typeId = 12;

  @override
  CoursesModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CoursesModel(
      code: fields[0] as String?,
      title: fields[1] as String?,
      creditHours: fields[2] as String?,
      specialVenue: fields[3] as String?,
      lecturer: (fields[4] as List).cast<String>(),
      department: fields[5] as String?,
      id: fields[6] as String?,
      academicYear: fields[7] as String?,
      venues: (fields[9] as List).cast<String>(),
      level: fields[10] as String?,
      targetStudents: fields[11] as String?,
      academicSemester: fields[12] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CoursesModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.code)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.creditHours)
      ..writeByte(3)
      ..write(obj.specialVenue)
      ..writeByte(4)
      ..write(obj.lecturer)
      ..writeByte(5)
      ..write(obj.department)
      ..writeByte(6)
      ..write(obj.id)
      ..writeByte(7)
      ..write(obj.academicYear)
      ..writeByte(9)
      ..write(obj.venues)
      ..writeByte(10)
      ..write(obj.level)
      ..writeByte(11)
      ..write(obj.targetStudents)
      ..writeByte(12)
      ..write(obj.academicSemester);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CoursesModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
