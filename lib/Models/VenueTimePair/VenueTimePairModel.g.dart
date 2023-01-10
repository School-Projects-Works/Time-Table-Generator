// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'VenueTimePairModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VenueTimePairModelAdapter extends TypeAdapter<VenueTimePairModel> {
  @override
  final int typeId = 6;

  @override
  VenueTimePairModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VenueTimePairModel(
      id: fields[0] as String?,
      venueName: fields[1] as String?,
      uniqueId: fields[2] as String?,
      venueCapacity: fields[3] as String?,
      isDisabilityAccessible: fields[4] as String?,
      period: (fields[5] as Map?)?.cast<String, dynamic>(),
      day: fields[6] as String?,
      reg: fields[7] as bool?,
      eve: fields[8] as bool?,
      wnd: fields[9] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, VenueTimePairModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.venueName)
      ..writeByte(2)
      ..write(obj.uniqueId)
      ..writeByte(3)
      ..write(obj.venueCapacity)
      ..writeByte(4)
      ..write(obj.isDisabilityAccessible)
      ..writeByte(5)
      ..write(obj.period)
      ..writeByte(6)
      ..write(obj.day)
      ..writeByte(7)
      ..write(obj.reg)
      ..writeByte(8)
      ..write(obj.eve)
      ..writeByte(9)
      ..write(obj.wnd);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VenueTimePairModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
