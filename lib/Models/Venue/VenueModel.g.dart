// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'VenueModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VenueModelAdapter extends TypeAdapter<VenueModel> {
  @override
  final int typeId = 3;

  @override
  VenueModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VenueModel(
      name: fields[0] as String?,
      capacity: fields[1] as String?,
      isDisabilityAccessible: fields[2] as String?,
      id: fields[3] as String?,
      academicYear: fields[4] as String?,
      isSpecialVenue: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, VenueModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.capacity)
      ..writeByte(2)
      ..write(obj.isDisabilityAccessible)
      ..writeByte(3)
      ..write(obj.id)
      ..writeByte(4)
      ..write(obj.academicYear)
      ..writeByte(5)
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
