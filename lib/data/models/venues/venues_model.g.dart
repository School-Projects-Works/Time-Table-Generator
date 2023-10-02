// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'venues_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VenuesModelAdapter extends TypeAdapter<VenuesModel> {
  @override
  final int typeId = 15;

  @override
  VenuesModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VenuesModel(
      venueName: fields[0] as String?,
      isSpecial: fields[1] as String?,
      capacity: fields[2] as String?,
      isDisabledFriendly: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, VenuesModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.venueName)
      ..writeByte(1)
      ..write(obj.isSpecial)
      ..writeByte(2)
      ..write(obj.capacity)
      ..writeByte(3)
      ..write(obj.isDisabledFriendly);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VenuesModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
