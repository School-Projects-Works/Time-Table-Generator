// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'LiberalTimePairModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LiberalTimePairModelAdapter extends TypeAdapter<LiberalTimePairModel> {
  @override
  final int typeId = 7;

  @override
  LiberalTimePairModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LiberalTimePairModel(
      id: fields[0] as String?,
      day: fields[1] as String?,
      period: fields[2] as String?,
      courseCode: fields[3] as String?,
      lecturerName: fields[4] as String?,
      lecturerEmail: fields[5] as String?,
      courseTitle: fields[6] as String?,
      academicYear: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, LiberalTimePairModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.day)
      ..writeByte(2)
      ..write(obj.period)
      ..writeByte(3)
      ..write(obj.courseCode)
      ..writeByte(4)
      ..write(obj.lecturerName)
      ..writeByte(5)
      ..write(obj.lecturerEmail)
      ..writeByte(6)
      ..write(obj.courseTitle)
      ..writeByte(7)
      ..write(obj.academicYear);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LiberalTimePairModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
