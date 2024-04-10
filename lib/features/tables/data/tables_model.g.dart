// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tables_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TablesModelAdapter extends TypeAdapter<TablesModel> {
  @override
  final int typeId = 7;

  @override
  TablesModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TablesModel(
      id: fields[0] as String?,
      year: fields[1] as String?,
      day: fields[2] as String,
      period: fields[3] as String,
      studyMode: fields[4] as String,
      periodMap: (fields[5] as Map?)?.cast<String, dynamic>(),
      courseCode: fields[6] as String?,
      courseId: fields[7] as String,
      lecturerName: fields[8] as String,
      lecturerEmail: fields[9] as String?,
      courseTitle: fields[10] as String,
      creditHours: fields[11] as String?,
      specialVenues: (fields[12] as List?)
          ?.map((dynamic e) => (e as Map).cast<String, dynamic>())
          ?.toList(),
      venueName: fields[13] as String,
      venueId: fields[14] as String,
      venueCapacity: fields[15] as int,
      disabilityAccess: fields[16] as bool?,
      isSpecial: fields[17] as bool?,
      classLevel: fields[18] as String,
      className: fields[19] as String,
      department: fields[20] as String,
      classSize: fields[21] as String,
      hasDisable: fields[22] as bool?,
      semester: fields[23] as String,
      classId: fields[24] as String,
      lecturerId: fields[25] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TablesModel obj) {
    writer
      ..writeByte(26)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.year)
      ..writeByte(2)
      ..write(obj.day)
      ..writeByte(3)
      ..write(obj.period)
      ..writeByte(4)
      ..write(obj.studyMode)
      ..writeByte(5)
      ..write(obj.periodMap)
      ..writeByte(6)
      ..write(obj.courseCode)
      ..writeByte(7)
      ..write(obj.courseId)
      ..writeByte(8)
      ..write(obj.lecturerName)
      ..writeByte(9)
      ..write(obj.lecturerEmail)
      ..writeByte(10)
      ..write(obj.courseTitle)
      ..writeByte(11)
      ..write(obj.creditHours)
      ..writeByte(12)
      ..write(obj.specialVenues)
      ..writeByte(13)
      ..write(obj.venueName)
      ..writeByte(14)
      ..write(obj.venueId)
      ..writeByte(15)
      ..write(obj.venueCapacity)
      ..writeByte(16)
      ..write(obj.disabilityAccess)
      ..writeByte(17)
      ..write(obj.isSpecial)
      ..writeByte(18)
      ..write(obj.classLevel)
      ..writeByte(19)
      ..write(obj.className)
      ..writeByte(20)
      ..write(obj.department)
      ..writeByte(21)
      ..write(obj.classSize)
      ..writeByte(22)
      ..write(obj.hasDisable)
      ..writeByte(23)
      ..write(obj.semester)
      ..writeByte(24)
      ..write(obj.classId)
      ..writeByte(25)
      ..write(obj.lecturerId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TablesModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
