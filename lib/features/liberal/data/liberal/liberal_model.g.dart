// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'liberal_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LiberalModelAdapter extends TypeAdapter<LiberalModel> {
  @override
  final int typeId = 5;

  @override
  LiberalModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LiberalModel(
      id: fields[0] as String?,
      code: fields[1] as String?,
      title: fields[2] as String?,
      lecturerId: fields[3] as String?,
      lecturerName: fields[4] as String?,
      lecturerEmail: fields[5] as String?,
      year: fields[6] as String?,
      studyMode: fields[7] as String?,
      semester: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, LiberalModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.code)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.lecturerId)
      ..writeByte(4)
      ..write(obj.lecturerName)
      ..writeByte(5)
      ..write(obj.lecturerEmail)
      ..writeByte(6)
      ..write(obj.year)
      ..writeByte(7)
      ..write(obj.studyMode)
      ..writeByte(8)
      ..write(obj.semester);
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
