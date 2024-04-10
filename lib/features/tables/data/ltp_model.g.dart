// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ltp_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LTPModelAdapter extends TypeAdapter<LTPModel> {
  @override
  final int typeId = 10;

  @override
  LTPModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LTPModel(
      id: fields[0] as String,
      day: fields[1] as String,
      isAsigned: fields[2] as bool,
      period: fields[3] as String,
      periodMap: (fields[4] as Map).cast<String, dynamic>(),
      courseCode: fields[5] as String,
      lecturerName: fields[6] as String,
      lecturerId: fields[7] as String,
      courseTitle: fields[8] as String,
      courseId: fields[9] as String,
      year: fields[10] as String,
      level: fields[11] as String,
      studyMode: fields[12] as String,
      semester: fields[13] as String,
    );
  }

  @override
  void write(BinaryWriter writer, LTPModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.day)
      ..writeByte(2)
      ..write(obj.isAsigned)
      ..writeByte(3)
      ..write(obj.period)
      ..writeByte(4)
      ..write(obj.periodMap)
      ..writeByte(5)
      ..write(obj.courseCode)
      ..writeByte(6)
      ..write(obj.lecturerName)
      ..writeByte(7)
      ..write(obj.lecturerId)
      ..writeByte(8)
      ..write(obj.courseTitle)
      ..writeByte(9)
      ..write(obj.courseId)
      ..writeByte(10)
      ..write(obj.year)
      ..writeByte(11)
      ..write(obj.level)
      ..writeByte(12)
      ..write(obj.studyMode)
      ..writeByte(13)
      ..write(obj.semester);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LTPModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
