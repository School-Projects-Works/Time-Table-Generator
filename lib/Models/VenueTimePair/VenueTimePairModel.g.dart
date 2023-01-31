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
      venueId: fields[2] as String?,
      venueCapacity: fields[3] as String?,
      isDisabilityAccessible: fields[4] as String?,
      periodMap: (fields[5] as Map?)?.cast<String, dynamic>(),
      day: fields[6] as String?,
      period: fields[8] as String?,
      academicYear: fields[9] as String?,
      isSpecialVenue: fields[10] as String?,
      isBooked: fields[11] as bool,
    )..targetedStudents = fields[7] as String?;
  }

  @override
  void write(BinaryWriter writer, VenueTimePairModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.venueName)
      ..writeByte(2)
      ..write(obj.venueId)
      ..writeByte(3)
      ..write(obj.venueCapacity)
      ..writeByte(4)
      ..write(obj.isDisabilityAccessible)
      ..writeByte(5)
      ..write(obj.periodMap)
      ..writeByte(6)
      ..write(obj.day)
      ..writeByte(7)
      ..write(obj.targetedStudents)
      ..writeByte(8)
      ..write(obj.period)
      ..writeByte(9)
      ..write(obj.academicYear)
      ..writeByte(10)
      ..write(obj.isSpecialVenue)
      ..writeByte(11)
      ..write(obj.isBooked);
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
