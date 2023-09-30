// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'configuration_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ConfigurationModelAdapter extends TypeAdapter<ConfigurationModel> {
  @override
  final int typeId = 10;

  @override
  ConfigurationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ConfigurationModel(
      id: fields[0] as String?,
      academicYear: fields[1] as String?,
      academicSemester: fields[2] as String?,
      days: (fields[3] as List).cast<String>(),
      periods: (fields[4] as List)
          .map((dynamic e) => (e as Map).cast<String, dynamic>())
          .toList(),
      liberalCourseDay: fields[5] as String?,
      liberalCoursePeriod: (fields[6] as Map?)?.cast<String, dynamic>(),
      hasLiberalCourse: fields[7] as bool,
      hasCourse: fields[8] as bool,
      hasClass: fields[9] as bool,
      liberalLevel: fields[10] as String?,
      targetedStudents: fields[11] as String?,
      breakTime: (fields[12] as List?)
          ?.map((dynamic e) => (e as Map).cast<String, dynamic>())
          ?.toList(),
    );
  }

  @override
  void write(BinaryWriter writer, ConfigurationModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.academicYear)
      ..writeByte(2)
      ..write(obj.academicSemester)
      ..writeByte(3)
      ..write(obj.days)
      ..writeByte(4)
      ..write(obj.periods)
      ..writeByte(5)
      ..write(obj.liberalCourseDay)
      ..writeByte(6)
      ..write(obj.liberalCoursePeriod)
      ..writeByte(7)
      ..write(obj.hasLiberalCourse)
      ..writeByte(8)
      ..write(obj.hasCourse)
      ..writeByte(9)
      ..write(obj.hasClass)
      ..writeByte(10)
      ..write(obj.liberalLevel)
      ..writeByte(11)
      ..write(obj.targetedStudents)
      ..writeByte(12)
      ..write(obj.breakTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConfigurationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
