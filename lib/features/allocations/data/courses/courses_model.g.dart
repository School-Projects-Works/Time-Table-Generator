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
      lecturer: (fields[4] as List)
          .map((dynamic e) => (e as Map).cast<String, dynamic>())
          .toList(),
      department: fields[5] as String?,
      id: fields[6] as String?,
      year: fields[7] as String,
      venues: (fields[8] as List?)?.cast<String>(),
      level: fields[9] as String?,
      studyMode: fields[10] as String,
      semester: fields[11] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CourseModel obj) {
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
      ..write(obj.year)
      ..writeByte(8)
      ..write(obj.venues)
      ..writeByte(9)
      ..write(obj.level)
      ..writeByte(10)
      ..write(obj.studyMode)
      ..writeByte(11)
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
