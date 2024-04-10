// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lcc_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LCCPModelAdapter extends TypeAdapter<LCCPModel> {
  @override
  final int typeId = 11;

  @override
  LCCPModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LCCPModel(
      id: fields[0] as String,
      lecturerId: fields[1] as String,
      lecturerName: fields[2] as String,
      isAsigned: fields[3] as bool,
      lecturer: (fields[4] as Map).cast<String, dynamic>(),
      courseId: fields[5] as String,
      courseCode: fields[6] as String,
      requireSpecialVenue: fields[7] as bool,
      venues: (fields[8] as List).cast<String>(),
      courseName: fields[9] as String,
      course: (fields[10] as Map).cast<String, dynamic>(),
      classId: fields[11] as String,
      className: fields[12] as String,
      classData: (fields[13] as Map).cast<String, dynamic>(),
      classCapacity: fields[14] as int,
      studyMode: fields[15] as String,
      level: fields[16] as String,
      year: fields[17] as String,
      semester: fields[18] as String,
      department: fields[19] as String,
      hasDisability: fields[20] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, LCCPModel obj) {
    writer
      ..writeByte(21)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.lecturerId)
      ..writeByte(2)
      ..write(obj.lecturerName)
      ..writeByte(3)
      ..write(obj.isAsigned)
      ..writeByte(4)
      ..write(obj.lecturer)
      ..writeByte(5)
      ..write(obj.courseId)
      ..writeByte(6)
      ..write(obj.courseCode)
      ..writeByte(7)
      ..write(obj.requireSpecialVenue)
      ..writeByte(8)
      ..write(obj.venues)
      ..writeByte(9)
      ..write(obj.courseName)
      ..writeByte(10)
      ..write(obj.course)
      ..writeByte(11)
      ..write(obj.classId)
      ..writeByte(12)
      ..write(obj.className)
      ..writeByte(13)
      ..write(obj.classData)
      ..writeByte(14)
      ..write(obj.classCapacity)
      ..writeByte(15)
      ..write(obj.studyMode)
      ..writeByte(16)
      ..write(obj.level)
      ..writeByte(17)
      ..write(obj.year)
      ..writeByte(18)
      ..write(obj.semester)
      ..writeByte(19)
      ..write(obj.department)
      ..writeByte(20)
      ..write(obj.hasDisability);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LCCPModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
