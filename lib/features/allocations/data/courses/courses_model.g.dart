// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'courses_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CourseModelAdapter extends TypeAdapter<CourseModel> {
  @override
  final int typeId = 2;

  @override
  CourseModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CourseModel(
      code: fields[0] as String?,
      title: fields[1] as String?,
      creditHours: fields[2] as String?,
      specialVenue: fields[3] as String?,
      lecturerId: (fields[4] as List?)?.cast<String>(),
      lecturerName: (fields[5] as List?)?.cast<String>(),
      department: fields[6] as String?,
      id: fields[7] as String?,
      year: fields[8] as String?,
      venues: (fields[9] as List?)?.cast<String>(),
      level: fields[10] as String?,
      studyMode: fields[11] as String?,
      semester: fields[12] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CourseModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.code)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.creditHours)
      ..writeByte(3)
      ..write(obj.specialVenue)
      ..writeByte(4)
      ..write(obj.lecturerId)
      ..writeByte(5)
      ..write(obj.lecturerName)
      ..writeByte(6)
      ..write(obj.department)
      ..writeByte(7)
      ..write(obj.id)
      ..writeByte(8)
      ..write(obj.year)
      ..writeByte(9)
      ..write(obj.venues)
      ..writeByte(10)
      ..write(obj.level)
      ..writeByte(11)
      ..write(obj.studyMode)
      ..writeByte(12)
      ..write(obj.semester);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CourseModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
