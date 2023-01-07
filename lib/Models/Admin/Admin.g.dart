// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Admin.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AdminAdapter extends TypeAdapter<Admin> {
  @override
  final int typeId = 0;

  @override
  Admin read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Admin(
      id: fields[0] as String?,
      name: fields[1] as String?,
      password: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Admin obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.password);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdminAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
