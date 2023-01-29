// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ClassCoursePairModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ClassCoursePairModelAdapter extends TypeAdapter<ClassCoursePairModel> {
  @override
  final int typeId = 10;

  @override
  ClassCoursePairModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ClassCoursePairModel(
      id: fields[0] as String?,
      courseTitle: fields[1] as String?,
      creditHours: fields[2] as String?,
      specialVenue: fields[3] as String?,
      lecturerName: fields[4] as String?,
      lecturerEmail: fields[5] as String?,
      department: fields[6] as String?,
      courseId: fields[7] as String?,
      academicYear: fields[8] as String?,
      venues: (fields[9] as List?)?.cast<String>(),
      courseCode: fields[10] as String?,
      classId: fields[11] as String?,
      classLevel: fields[12] as String?,
      classType: fields[13] as String?,
      className: fields[14] as String?,
      classSize: fields[15] as String?,
      classHasDisability: fields[16] as String?,
      classCourses: (fields[17] as List?)?.cast<dynamic>(),
      isAssigned: fields[18] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ClassCoursePairModel obj) {
    writer
      ..writeByte(19)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.courseTitle)
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
      ..write(obj.courseId)
      ..writeByte(8)
      ..write(obj.academicYear)
      ..writeByte(9)
      ..write(obj.venues)
      ..writeByte(10)
      ..write(obj.courseCode)
      ..writeByte(11)
      ..write(obj.classId)
      ..writeByte(12)
      ..write(obj.classLevel)
      ..writeByte(13)
      ..write(obj.classType)
      ..writeByte(14)
      ..write(obj.className)
      ..writeByte(15)
      ..write(obj.classSize)
      ..writeByte(16)
      ..write(obj.classHasDisability)
      ..writeByte(17)
      ..write(obj.classCourses)
      ..writeByte(18)
      ..write(obj.isAssigned);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClassCoursePairModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
