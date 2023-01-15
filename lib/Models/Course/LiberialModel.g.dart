// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'LiberialModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LiberialModelAdapter extends TypeAdapter<LiberialModel> {
  @override
  final int typeId = 9;

  @override
  LiberialModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LiberialModel(
      code: fields[0] as String?,
      title: fields[1] as String?,
      lecturerName: fields[2] as String?,
      lecturerEmail: fields[3] as String?,
      id: fields[4] as String?,
      academicYear: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, LiberialModel obj) {
    writer
      ..writeByte(6)
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
      ..write(obj.academicYear);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LiberialModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
