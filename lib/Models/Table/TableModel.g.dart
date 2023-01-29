// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TableModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TableModelAdapter extends TypeAdapter<TableModel> {
  @override
  final int typeId = 12;

  @override
  TableModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TableModel(
      id: fields[0] as String?,
      academicYear: fields[1] as String?,
      day: fields[2] as String?,
      period: fields[3] as String?,
      dayMap: (fields[4] as Map?)?.cast<String, dynamic>(),
      periodMap: (fields[5] as Map?)?.cast<String, dynamic>(),
      courseCode: fields[6] as String?,
      courseId: fields[7] as String?,
      lecturerName: fields[8] as String?,
      lecturerEmail: fields[9] as String?,
      courseTitle: fields[10] as String?,
      creditHours: fields[11] as String?,
      specialVenues: (fields[12] as List?)?.cast<String>(),
      venue: fields[13] as String?,
      venueId: fields[14] as String?,
      venueCapacity: fields[15] as String?,
      venueHasDisability: fields[16] as String?,
      isSpecialVenue: fields[17] as String?,
      classLevel: fields[18] as String?,
      className: fields[19] as String?,
      classType: fields[20] as String?,
      department: fields[21] as String?,
      classSize: fields[22] as String?,
      classHasDisability: fields[23] as String?,
      classId: fields[24] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, TableModel obj) {
    writer
      ..writeByte(25)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.academicYear)
      ..writeByte(2)
      ..write(obj.day)
      ..writeByte(3)
      ..write(obj.period)
      ..writeByte(4)
      ..write(obj.dayMap)
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
      ..write(obj.venue)
      ..writeByte(14)
      ..write(obj.venueId)
      ..writeByte(15)
      ..write(obj.venueCapacity)
      ..writeByte(16)
      ..write(obj.venueHasDisability)
      ..writeByte(17)
      ..write(obj.isSpecialVenue)
      ..writeByte(18)
      ..write(obj.classLevel)
      ..writeByte(19)
      ..write(obj.className)
      ..writeByte(20)
      ..write(obj.classType)
      ..writeByte(21)
      ..write(obj.department)
      ..writeByte(22)
      ..write(obj.classSize)
      ..writeByte(23)
      ..write(obj.classHasDisability)
      ..writeByte(24)
      ..write(obj.classId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TableModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
