// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'LiberalModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LiberalModelAdapter extends TypeAdapter<LiberalModel> {
  @override
  final int typeId = 9;

  @override
  LiberalModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LiberalModel(
      code: fields[0] as String?,
      title: fields[1] as String?,
      lecturerName: fields[2] as String?,
      lecturerEmail: fields[3] as String?,
      id: fields[4] as String?,
      academicYear: fields[5] as String?,
      level: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, LiberalModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.code)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.lecturerName)
      ..writeByte(3)
      ..write(obj.lecturerEmail)
      ..writeByte(4)
      ..write(obj.id)
      ..writeByte(5)
      ..write(obj.academicYear)
      ..writeByte(6)
      ..write(obj.level);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LiberalModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
