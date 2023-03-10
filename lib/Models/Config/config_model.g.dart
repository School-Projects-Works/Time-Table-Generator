// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ConfigModelAdapter extends TypeAdapter<ConfigModel> {
  @override
  final int typeId = 2;

  @override
  ConfigModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ConfigModel(
      id: fields[0] as String?,
      academicName: fields[1] as String?,
      academicYear: fields[2] as String?,
      academicSemester: fields[3] as String?,
      days: (fields[4] as List?)?.cast<String>(),
      periods: (fields[5] as List?)
          ?.map((dynamic e) => (e as Map).cast<String, dynamic>())
          .toList(),
      liberalCourseDay: fields[6] as String?,
      liberalCoursePeriod: (fields[7] as Map?)?.cast<String, dynamic>(),
      hasLiberalCourse: fields[8] as bool,
      hasCourse: fields[9] as bool,
      hasClass: fields[10] as bool,
      liberalLevel: fields[11] as String?,
      targetedStudents: fields[12] as String?,
      breakTime: (fields[13] as Map?)?.cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, ConfigModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.academicName)
      ..writeByte(2)
      ..write(obj.academicYear)
      ..writeByte(3)
      ..write(obj.academicSemester)
      ..writeByte(4)
      ..write(obj.days)
      ..writeByte(5)
      ..write(obj.periods)
      ..writeByte(6)
      ..write(obj.liberalCourseDay)
      ..writeByte(7)
      ..write(obj.liberalCoursePeriod)
      ..writeByte(8)
      ..write(obj.hasLiberalCourse)
      ..writeByte(9)
      ..write(obj.hasCourse)
      ..writeByte(10)
      ..write(obj.hasClass)
      ..writeByte(11)
      ..write(obj.liberalLevel)
      ..writeByte(12)
      ..write(obj.targetedStudents)
      ..writeByte(13)
      ..write(obj.breakTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConfigModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
