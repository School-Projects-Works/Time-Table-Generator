// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'venue_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VenueModelAdapter extends TypeAdapter<VenueModel> {
  @override
  final int typeId = 4;

  @override
  VenueModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VenueModel(
      id: fields[0] as String?,
      name: fields[1] as String?,
      capacity: fields[2] as int?,
      disabilityAccess: fields[3] as bool?,
      isSpecialVenue: fields[4] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, VenueModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.capacity)
      ..writeByte(3)
      ..write(obj.disabilityAccess)
      ..writeByte(4)
      ..write(obj.isSpecialVenue);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VenueModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
