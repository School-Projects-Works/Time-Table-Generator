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
      umiqueId: fields[1] as String?,
      day: fields[2] as String?,
      period: fields[3] as String?,
      courseCode: fields[4] as String?,
      level: fields[5] as String?,
      lecturerName: fields[6] as String?,
      lecturerEmail: fields[7] as String?,
      lecturerPhone: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, LiberalTimePairModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.umiqueId)
      ..writeByte(2)
      ..write(obj.day)
      ..writeByte(3)
      ..write(obj.period)
      ..writeByte(4)
      ..write(obj.courseCode)
      ..writeByte(5)
      ..write(obj.level)
      ..writeByte(6)
      ..write(obj.lecturerName)
      ..writeByte(7)
      ..write(obj.lecturerEmail)
      ..writeByte(8)
      ..write(obj.lecturerPhone);
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
