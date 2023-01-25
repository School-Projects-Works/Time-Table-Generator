// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CourseModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CourseModelAdapter extends TypeAdapter<CourseModel> {
  @override
  final int typeId = 4;

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
      lecturerName: fields[4] as String?,
      lecturerEmail: fields[5] as String?,
      department: fields[6] as String?,
      id: fields[7] as String?,
      academicYear: fields[8] as String?,
      venues: (fields[9] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, CourseModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.code)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.creditHours)
      ..writeByte(3)
      ..write(obj.specialVenue)
      ..writeByte(4)
      ..write(obj.lecturerName)
      ..writeByte(5)
      ..write(obj.lecturerEmail)
      ..writeByte(6)
      ..write(obj.department)
      ..writeByte(7)
      ..write(obj.id)
      ..writeByte(8)
      ..write(obj.academicYear)
      ..writeByte(9)
      ..write(obj.venues);
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
