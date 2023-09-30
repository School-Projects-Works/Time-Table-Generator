// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TableModelAdapter extends TypeAdapter<TableModel> {
  @override
  final int typeId = 5;

  @override
  TableModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TableModel(
      id: fields[0] as String?,
      configId: fields[1] as String?,
      academicYear: fields[2] as String?,
      academicSemester: fields[3] as String?,
      targetedStudents: fields[4] as String?,
      config: (fields[5] as Map?)?.cast<String, dynamic>(),
      tableItems: (fields[6] as List?)
          ?.map((dynamic e) => (e as Map).cast<String, dynamic>())
          ?.toList(),
      tableType: fields[7] as String?,
      tableSchoolName: fields[8] as String?,
      tableDescription: fields[9] as String?,
      tableFooter: fields[10] as String?,
      signature: fields[11] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, TableModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.configId)
      ..writeByte(2)
      ..write(obj.academicYear)
      ..writeByte(3)
      ..write(obj.academicSemester)
      ..writeByte(4)
      ..write(obj.targetedStudents)
      ..writeByte(5)
      ..write(obj.config)
      ..writeByte(6)
      ..write(obj.tableItems)
      ..writeByte(7)
      ..write(obj.tableType)
      ..writeByte(8)
      ..write(obj.tableSchoolName)
      ..writeByte(9)
      ..write(obj.tableDescription)
      ..writeByte(10)
      ..write(obj.tableFooter)
      ..writeByte(11)
      ..write(obj.signature);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TableModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
