// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'liberal_corurses_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LiberalCoursesModelAdapter extends TypeAdapter<LiberalCoursesModel> {
  @override
  final int typeId = 14;

  @override
  LiberalCoursesModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LiberalCoursesModel(
      courseCode: fields[0] as String?,
      courseTitle: fields[1] as String?,
      lecturer: fields[2] as String?,
      level: fields[3] as String?,
      academicSemester: fields[4] as String?,
      academicYears: fields[5] as String?,
      targetStudents: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, LiberalCoursesModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.courseCode)
      ..writeByte(1)
      ..write(obj.courseTitle)
      ..writeByte(2)
      ..write(obj.lecturer)
      ..writeByte(3)
      ..write(obj.level)
      ..writeByte(4)
      ..write(obj.academicSemester)
      ..writeByte(5)
      ..write(obj.academicYears)
      ..writeByte(6)
      ..write(obj.targetStudents);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LiberalCoursesModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
